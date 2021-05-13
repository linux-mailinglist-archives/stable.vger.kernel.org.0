Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5749A37FACF
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 17:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234912AbhEMPfp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 11:35:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:42042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234909AbhEMPfn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 May 2021 11:35:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7140B611AC;
        Thu, 13 May 2021 15:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620920073;
        bh=24+QMlbm6R3el/cqW2niiiLOLvBsEwI1WXzMFtpGZ9E=;
        h=Subject:To:From:Date:From;
        b=iaNnHLmsDuWh9kyc5bC4qWDPPd5+JgI/FK/8FN6o0s07p1NOpEFwhH5u1GKH45x/u
         5u/NZW9oNoieDMNgZmLkUiYOdl5lFw20Y5Z1zY4/lS3cZq4TE86lH3vvA2wwE3UsvB
         N/RWVdM0r4VvH2pO9MSFJcBjyz9Dku0muaO/3jTw=
Subject: patch "Revert "scsi: ufs: fix a missing check of devm_reset_control_get"" added to char-misc-linus
To:     gregkh@linuxfoundation.org, avri.altman@wdc.com, kjlu@umn.edu,
        martin.petersen@oracle.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 13 May 2021 17:34:16 +0200
Message-ID: <162092005652241@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Revert "scsi: ufs: fix a missing check of devm_reset_control_get"

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 4d427b408c4c2ff1676966c72119a3a559f8e39b Mon Sep 17 00:00:00 2001
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Mon, 3 May 2021 13:56:57 +0200
Subject: Revert "scsi: ufs: fix a missing check of devm_reset_control_get"

This reverts commit 63a06181d7ce169d09843645c50fea1901bc9f0a.

Because of recent interactions with developers from @umn.edu, all
commits from them have been recently re-reviewed to ensure if they were
correct or not.

Upon review, this commit was found to be incorrect for the reasons
below, so it must be reverted.  It will be fixed up "correctly" in a
later kernel change.

The original commit is incorrect, it does not properly clean up on the
error path, so I'll keep the revert and fix it up properly with a
follow-on patch.

Cc: Kangjie Lu <kjlu@umn.edu>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Fixes: 63a06181d7ce ("scsi: ufs: fix a missing check of devm_reset_control_get")
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210503115736.2104747-31-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/ufs/ufs-hisi.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-hisi.c b/drivers/scsi/ufs/ufs-hisi.c
index 0aa58131e791..7d1e07a9d9dd 100644
--- a/drivers/scsi/ufs/ufs-hisi.c
+++ b/drivers/scsi/ufs/ufs-hisi.c
@@ -468,10 +468,6 @@ static int ufs_hisi_init_common(struct ufs_hba *hba)
 	ufshcd_set_variant(hba, host);
 
 	host->rst  = devm_reset_control_get(dev, "rst");
-	if (IS_ERR(host->rst)) {
-		dev_err(dev, "%s: failed to get reset control\n", __func__);
-		return PTR_ERR(host->rst);
-	}
 
 	ufs_hisi_set_pm_lvl(hba);
 
-- 
2.31.1


