Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B33B554896A
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350028AbiFMMZd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:25:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356698AbiFMMYK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:24:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92FED31905;
        Mon, 13 Jun 2022 04:05:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52523614DF;
        Mon, 13 Jun 2022 11:05:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BBF1C3411E;
        Mon, 13 Jun 2022 11:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118325;
        bh=dQNws+jJxXI0km39GL9lQb6x9kS+9wy/+s80ews2QI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L5dtoDOb+QhpovTwLdfO9FlwrmFE/nNr2IFzc1S0Many47QyvjW6elK37gkGzWmcU
         y3ymhAynlcftqLrBBXZMfzpt0ejZgttJJMK3Hm90mHh0nTXNGS/bk1LUYXdtLMRu6k
         4l/sZbTMKqRMl0/6C+OCSQAukUCLYbowbI9CrLTk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Daniel Gibson <daniel@gibson.sh>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 007/172] tty: n_tty: Restore EOF push handling behavior
Date:   Mon, 13 Jun 2022 12:09:27 +0200
Message-Id: <20220613094852.116983191@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094850.166931805@linuxfoundation.org>
References: <20220613094850.166931805@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Gibson <daniel@gibson.sh>

[ Upstream commit 65a8b287023da68c4550deab5c764e6891cf1caf ]

TTYs in ICANON mode have a special case that allows "pushing" a line
without a regular EOL character (like newline), by using EOF (the EOT
character - ASCII 0x4) as a pseudo-EOL. It is silently discarded, so
the reader of the PTS will receive the line *without* EOF or any other
terminating character.

This special case has an edge case: What happens if the readers buffer
is the same size as the line (without EOF)? Will they be able to tell
if the whole line is received, i.e. if the next read() will return more
of the same line or the next line?

There are two possibilities,  that both have (dis)advantages:

1. The next read() returns 0. FreeBSD (13.0) and OSX (10.11) do this.
   Advantage: The reader can interpret this as "the line is over".
   Disadvantage: read() returning 0 means EOF, the reader could also
   interpret it as "there's no more data" and stop reading or even
   close the PT.

2. The next read() returns the next line, the EOF is silently discarded.
   Solaris (or at least OpenIndiana 2021.10) does this, Linux has done
   do this since commit 40d5e0905a03 ("n_tty: Fix EOF push handling");
   this behavior was recently broken by commit 359303076163 ("tty:
   n_tty: do not look ahead for EOL character past the end of the buffer").
   Advantage: read() won't return 0 (EOF), reader less likely to be
   confused (and things like `while(read(..)>0)` don't break)
   Disadvantage: The reader can't really know if the read() continues
   the last line (that filled the whole read buffer) or starts a
   new line.

As both options are defensible (and are used by other Unix-likes), it's
best to stick to the "old" behavior since "n_tty: Fix EOF push handling"
of 2013, i.e. silently discard that EOF.

This patch - that I actually got from Linus for testing and only
modified slightly - restores that behavior by skipping an EOF
character if it's the next character after reading is done.

Based on a patch from Linus Torvalds.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=215611
Fixes: 359303076163 ("tty: n_tty: do not look ahead for EOL character past the end of the buffer")
Cc: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jirislaby@kernel.org>
Reviewed-and-tested-by: Daniel Gibson <daniel@gibson.sh>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Daniel Gibson <daniel@gibson.sh>
Link: https://lore.kernel.org/r/20220329235810.452513-2-daniel@gibson.sh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/n_tty.c | 38 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 58190135efb7..12dde01e576b 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -2073,6 +2073,35 @@ static bool canon_copy_from_read_buf(struct tty_struct *tty,
 	return ldata->read_tail != canon_head;
 }
 
+/*
+ * If we finished a read at the exact location of an
+ * EOF (special EOL character that's a __DISABLED_CHAR)
+ * in the stream, silently eat the EOF.
+ */
+static void canon_skip_eof(struct tty_struct *tty)
+{
+	struct n_tty_data *ldata = tty->disc_data;
+	size_t tail, canon_head;
+
+	canon_head = smp_load_acquire(&ldata->canon_head);
+	tail = ldata->read_tail;
+
+	// No data?
+	if (tail == canon_head)
+		return;
+
+	// See if the tail position is EOF in the circular buffer
+	tail &= (N_TTY_BUF_SIZE - 1);
+	if (!test_bit(tail, ldata->read_flags))
+		return;
+	if (read_buf(ldata, tail) != __DISABLED_CHAR)
+		return;
+
+	// Clear the EOL bit, skip the EOF char.
+	clear_bit(tail, ldata->read_flags);
+	smp_store_release(&ldata->read_tail, ldata->read_tail + 1);
+}
+
 /**
  *	job_control		-	check job control
  *	@tty: tty
@@ -2142,7 +2171,14 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
 	 */
 	if (*cookie) {
 		if (ldata->icanon && !L_EXTPROC(tty)) {
-			if (canon_copy_from_read_buf(tty, &kb, &nr))
+			/*
+			 * If we have filled the user buffer, see
+			 * if we should skip an EOF character before
+			 * releasing the lock and returning done.
+			 */
+			if (!nr)
+				canon_skip_eof(tty);
+			else if (canon_copy_from_read_buf(tty, &kb, &nr))
 				return kb - kbuf;
 		} else {
 			if (copy_from_read_buf(tty, &kb, &nr))
-- 
2.35.1



