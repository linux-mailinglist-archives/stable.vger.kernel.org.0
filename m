Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A29CD103F3C
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 16:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728879AbfKTPmO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 10:42:14 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53016 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731850AbfKTPkU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Nov 2019 10:40:20 -0500
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5X-0004d4-GA; Wed, 20 Nov 2019 15:40:15 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5V-0004Oj-Ll; Wed, 20 Nov 2019 15:40:13 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Dan Williams" <dan.j.williams@intel.com>,
        "Song Liu" <songliubraving@fb.com>,
        "Nigel Croxon" <ncroxon@redhat.com>
Date:   Wed, 20 Nov 2019 15:38:30 +0000
Message-ID: <lsq.1574264230.785481722@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 80/83] md/raid: raid5 preserve the writeback action
 after the parity check
In-Reply-To: <lsq.1574264230.280218497@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.78-rc1 review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/raid5.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3385,7 +3385,7 @@ static void handle_parity_checks6(struct
 		/* now write out any block on a failed drive,
 		 * or P or Q if they were recomputed
 		 */
-		BUG_ON(s->uptodate < disks - 1); /* We don't need Q to recover */
+		dev = NULL;
 		if (s->failed == 2) {
 			dev = &sh->dev[s->failed_num[1]];
 			s->locked++;
@@ -3410,6 +3410,14 @@ static void handle_parity_checks6(struct
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

