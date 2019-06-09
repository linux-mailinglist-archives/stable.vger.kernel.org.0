Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A842F3A9AA
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732481AbfFIQ6x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:58:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:34344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732775AbfFIQ6w (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:58:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C32B320833;
        Sun,  9 Jun 2019 16:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099532;
        bh=qLAEovgYB/pUNzZ7v7oRR5Izfdc4Tkjh16+YMHLw77Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZMgxMxUK3Gkgk9uVV03IFzmFx2VrBGAlxqTweyt9gQJ2FABjmIA7kBkMZrYdzMS+F
         gIw5+rH8HSY7swIegbVF2qAjZ3GUb+4KjFshObgdRPWYH0WXIbo43hs3jGturg3UiT
         DWqCSS1sGvpfoHM8cvFQHiJ0kHs074aL88p5i5ks=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        Nigel Croxon <ncroxon@redhat.com>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH 4.4 073/241] md/raid: raid5 preserve the writeback action after the parity check
Date:   Sun,  9 Jun 2019 18:40:15 +0200
Message-Id: <20190609164149.882476432@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nigel Croxon <ncroxon@redhat.com>

commit b2176a1dfb518d870ee073445d27055fea64dfb8 upstream.

The problem is that any 'uptodate' vs 'disks' check is not precise
in this path. Put a "WARN_ON(!test_bit(R5_UPTODATE, &dev->flags)" on the
device that might try to kick off writes and then skip the action.
Better to prevent the raid driver from taking unexpected action *and* keep
the system alive vs killing the machine with BUG_ON.

Note: fixed warning reported by kbuild test robot <lkp@intel.com>

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/raid5.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3861,7 +3861,7 @@ static void handle_parity_checks6(struct
 		/* now write out any block on a failed drive,
 		 * or P or Q if they were recomputed
 		 */
-		BUG_ON(s->uptodate < disks - 1); /* We don't need Q to recover */
+		dev = NULL;
 		if (s->failed == 2) {
 			dev = &sh->dev[s->failed_num[1]];
 			s->locked++;
@@ -3886,6 +3886,14 @@ static void handle_parity_checks6(struct
 			set_bit(R5_LOCKED, &dev->flags);
 			set_bit(R5_Wantwrite, &dev->flags);
 		}
+		if (WARN_ONCE(dev && !test_bit(R5_UPTODATE, &dev->flags),
+			      "%s: disk%td not up to date\n",
+			      mdname(conf->mddev),
+			      dev - (struct r5dev *) &sh->dev)) {
+			clear_bit(R5_LOCKED, &dev->flags);
+			clear_bit(R5_Wantwrite, &dev->flags);
+			s->locked--;
+		}
 		clear_bit(STRIPE_DEGRADED, &sh->state);
 
 		set_bit(STRIPE_INSYNC, &sh->state);


