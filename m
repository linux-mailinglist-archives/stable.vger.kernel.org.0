Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92AE73714C3
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 14:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233726AbhECMAq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 08:00:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:34588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233740AbhECMAh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 08:00:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7184F61364;
        Mon,  3 May 2021 11:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620043184;
        bh=gXsPEK0CGEE2p019+n+3pa9NlbWquka9rwOtpPVn3hI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d24tbRk3yE5ckW2dAKockgNM7xjcM30onrYBP+xTe9L97annbbO6KeRvx16xc+xeE
         UcfrCa3F6Sh3zLkNoQQPTrpJ8c6774mSKnNVleAWzprmsx0uyy+KUB65146H6PPp44
         s3xL39ARM9bVwZLpINre3fC7KiRR09XtF3242Dcg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kangjie Lu <kjlu@umn.edu>, Avri Altman <avri.altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 30/69] Revert "scsi: ufs: fix a missing check of devm_reset_control_get"
Date:   Mon,  3 May 2021 13:56:57 +0200
Message-Id: <20210503115736.2104747-31-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210503115736.2104747-1-gregkh@linuxfoundation.org>
References: <20210503115736.2104747-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

