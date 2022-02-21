Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 787914BE98A
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:07:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350536AbiBUJdf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:33:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350399AbiBUJcV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:32:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94CDE286CF;
        Mon, 21 Feb 2022 01:13:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58D9C60E44;
        Mon, 21 Feb 2022 09:13:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DAB7C339C0;
        Mon, 21 Feb 2022 09:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434797;
        bh=/1OthzFOQiAO/LQveEl6pFw9zIZ/z8qT7p8GjumNJsE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dbTqUMs9hOohKVHHRCOKNCcRL4ogswsArBoNd/HGUk7MZ3mpsYDBvyXdfgonTxbkX
         K6WdcsaaJsiIA6YZbNcslwN40JlteQ1mfo3uKc4HjAlsis/xnxEpsUj300NNIUQJHI
         zQ8NfbjmwTaqtBDcjLU9kl3jMkRq3WPfP1CqDT84=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Daniel Gibson <metalcaedes@gmail.com>
Subject: [PATCH 5.15 134/196] tty: n_tty: do not look ahead for EOL character past the end of the buffer
Date:   Mon, 21 Feb 2022 09:49:26 +0100
Message-Id: <20220221084935.406757073@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 3593030761630e09200072a4bd06468892c27be3 upstream.

Daniel Gibson reports that the n_tty code gets line termination wrong in
very specific cases:

 "If you feed a line with exactly 64 chars + terminating newline, and
  directly afterwards (without reading) another line into a pseudo
  terminal, the the first read() on the other side will return the 64
  char line *without* terminating newline, and the next read() will
  return the missing terminating newline AND the complete next line (if
  it fits in the buffer)"

and bisected the behavior to commit 3b830a9c34d5 ("tty: convert
tty_ldisc_ops 'read()' function to take a kernel pointer").

Now, digging deeper, it turns out that the behavior isn't exactly new:
what changed in commit 3b830a9c34d5 was that the tty line discipline
.read() function is now passed an intermediate kernel buffer rather than
the final user space buffer.

And that intermediate kernel buffer is 64 bytes in size - thus that
special case with exactly 64 bytes plus terminating newline.

The same problem did exist before, but historically the boundary was not
the 64-byte chunk, but the user-supplied buffer size, which is obviously
generally bigger (and potentially bigger than N_TTY_BUF_SIZE, which
would hide the issue entirely).

The reason is that the n_tty canon_copy_from_read_buf() code would look
ahead for the EOL character one byte further than it would actually
copy.  It would then decide that it had found the terminator, and unmark
it as an EOL character - which in turn explains why the next read
wouldn't then be terminated by it.

Now, the reason it did all this in the first place is related to some
historical and pretty obscure EOF behavior, see commit ac8f3bf8832a
("n_tty: Fix poll() after buffer-limited eof push read") and commit
40d5e0905a03 ("n_tty: Fix EOF push handling").

And the reason for the EOL confusion is that we treat EOF as a special
EOL condition, with the EOL character being NUL (aka "__DISABLED_CHAR"
in the kernel sources).

So that EOF look-ahead also affects the normal EOL handling.

This patch just removes the look-ahead that causes problems, because EOL
is much more critical than the historical "EOF in the middle of a line
that coincides with the end of the buffer" handling ever was.

Now, it is possible that we should indeed re-introduce the "look at next
character to see if it's a EOF" behavior, but if so, that should be done
not at the kernel buffer chunk boundary in canon_copy_from_read_buf(),
but at a higher level, when we run out of the user buffer.

In particular, the place to do that would be at the top of
'n_tty_read()', where we check if it's a continuation of a previously
started read, and there is no more buffer space left, we could decide to
just eat the __DISABLED_CHAR at that point.

But that would be a separate patch, because I suspect nobody actually
cares, and I'd like to get a report about it before bothering.

Fixes: 3b830a9c34d5 ("tty: convert tty_ldisc_ops 'read()' function to take a kernel pointer")
Fixes: ac8f3bf8832a ("n_tty: Fix  poll() after buffer-limited eof push read")
Fixes: 40d5e0905a03 ("n_tty: Fix EOF push handling")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=215611
Reported-and-tested-by: Daniel Gibson <metalcaedes@gmail.com>
Cc: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jirislaby@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/n_tty.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1963,7 +1963,7 @@ static bool canon_copy_from_read_buf(str
 		return false;
 
 	canon_head = smp_load_acquire(&ldata->canon_head);
-	n = min(*nr + 1, canon_head - ldata->read_tail);
+	n = min(*nr, canon_head - ldata->read_tail);
 
 	tail = ldata->read_tail & (N_TTY_BUF_SIZE - 1);
 	size = min_t(size_t, tail + n, N_TTY_BUF_SIZE);
@@ -1985,10 +1985,8 @@ static bool canon_copy_from_read_buf(str
 		n += N_TTY_BUF_SIZE;
 	c = n + found;
 
-	if (!found || read_buf(ldata, eol) != __DISABLED_CHAR) {
-		c = min(*nr, c);
+	if (!found || read_buf(ldata, eol) != __DISABLED_CHAR)
 		n = c;
-	}
 
 	n_tty_trace("%s: eol:%zu found:%d n:%zu c:%zu tail:%zu more:%zu\n",
 		    __func__, eol, found, n, c, tail, more);


