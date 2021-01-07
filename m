Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E74AC2ED2D1
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:38:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729042AbhAGObw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:31:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:45880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729019AbhAGObu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:31:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 438F923380;
        Thu,  7 Jan 2021 14:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610029851;
        bh=0q8qmvE5+73hTUDZwLg/Tgkq28+KghNjI0B15Ui87Mw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BJoXpboaMYcQGjHivhGw/BtvjQEv/o7acWFJYwxGff0sRXMqyecbYYZpZfdWPnuax
         zQ/GfuZQznFIzjIwMP8yeU/Iv1vHsIsoPUzM+REyEy/5Sho+KI+u5cMCQRXB44qIFi
         GUtMLvWs63cq1jXYxbLlpPvGOcXm00iUgjVQl78E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+63cbe31877bb80ef58f5@syzkaller.appspotmail.com,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.14 18/29] ALSA: seq: Use bool for snd_seq_queue internal flags
Date:   Thu,  7 Jan 2021 15:31:33 +0100
Message-Id: <20210107143055.476091798@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210107143052.973437064@linuxfoundation.org>
References: <20210107143052.973437064@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 4ebd47037027c4beae99680bff3b20fdee5d7c1e upstream.

The snd_seq_queue struct contains various flags in the bit fields.
Those are categorized to two different use cases, both of which are
protected by different spinlocks.  That implies that there are still
potential risks of the bad operations for bit fields by concurrent
accesses.

For addressing the problem, this patch rearranges those flags to be
a standard bool instead of a bit field.

Reported-by: syzbot+63cbe31877bb80ef58f5@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/20201206083456.21110-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/core/seq/seq_queue.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/sound/core/seq/seq_queue.h
+++ b/sound/core/seq/seq_queue.h
@@ -40,10 +40,10 @@ struct snd_seq_queue {
 	
 	struct snd_seq_timer *timer;	/* time keeper for this queue */
 	int	owner;		/* client that 'owns' the timer */
-	unsigned int	locked:1,	/* timer is only accesibble by owner if set */
-		klocked:1,	/* kernel lock (after START) */	
-		check_again:1,
-		check_blocked:1;
+	bool	locked;		/* timer is only accesibble by owner if set */
+	bool	klocked;	/* kernel lock (after START) */
+	bool	check_again;	/* concurrent access happened during check */
+	bool	check_blocked;	/* queue being checked */
 
 	unsigned int flags;		/* status flags */
 	unsigned int info_flags;	/* info for sync */


