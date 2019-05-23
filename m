Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA062867F
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387697AbfEWTKJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:10:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:43440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387650AbfEWTKI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:10:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E0F5217F9;
        Thu, 23 May 2019 19:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558638608;
        bh=FZI5N1ooc/Jf6QBaLIZLSXt2/oMJG9xwKnO+Glubvng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QwhrRzsN6bkvLbUGIfM/wKPau60htNMJhAnKd/f0UEnF60c1piBhC4JGB3O9P1o/R
         w5J2seONfEYLTCRrAIggd8uQzgD8Fd5hBNH0dbhzGouDIXFhrY4ewV3c/d5cEuGtmg
         7KSdFxmaeFFcI/+FThv6NYU3b5iQDOjnhPH38nOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        Nigel Croxon <ncroxon@redhat.com>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH 4.9 52/53] md/raid: raid5 preserve the writeback action after the parity check
Date:   Thu, 23 May 2019 21:06:16 +0200
Message-Id: <20190523181719.226466348@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181710.981455400@linuxfoundation.org>
References: <20190523181710.981455400@linuxfoundation.org>
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
@@ -3878,7 +3878,7 @@ static void handle_parity_checks6(struct
 		/* now write out any block on a failed drive,
 		 * or P or Q if they were recomputed
 		 */
-		BUG_ON(s->uptodate < disks - 1); /* We don't need Q to recover */
+		dev = NULL;
 		if (s->failed == 2) {
 			dev = &sh->dev[s->failed_num[1]];
 			s->locked++;
@@ -3903,6 +3903,14 @@ static void handle_parity_checks6(struct
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


