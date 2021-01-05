Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0AE72EA78F
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 10:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728574AbhAEJbY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 04:31:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:49296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728269AbhAEJ3Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Jan 2021 04:29:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05DED229CA;
        Tue,  5 Jan 2021 09:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609838901;
        bh=0q8qmvE5+73hTUDZwLg/Tgkq28+KghNjI0B15Ui87Mw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u9rSvVTCKMi3vqUfpoEJ7aup9oqJQ/s/j1xnc5pwyEU06Ga6cqv0dL5+FF3Gd1CrH
         PK4fjW6AkHox0/q1cPviYJ+Ers6Zn5mzJLVqdJnk/E4QiHEeuKIejyFZ7jKP8JaCd8
         NqhrjHd7KsV2n5fDON43JtEtxpKp0DkCoVbOMO2I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+63cbe31877bb80ef58f5@syzkaller.appspotmail.com,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 19/29] ALSA: seq: Use bool for snd_seq_queue internal flags
Date:   Tue,  5 Jan 2021 10:29:05 +0100
Message-Id: <20210105090821.011719460@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210105090818.518271884@linuxfoundation.org>
References: <20210105090818.518271884@linuxfoundation.org>
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


