Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3B838F067
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 18:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235017AbhEXQDG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 12:03:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:46588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235788AbhEXQCO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 12:02:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4E8F6140F;
        Mon, 24 May 2021 15:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621871224;
        bh=QgX1uQdpz9hIHeIfKigvuNElTGeFfE7w7S9K68xiF8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=buLXvhMqEv/zlVWySQo6FMtvpaqAUq7vWfNB5642SDIY7M1GBuwQcZLgXbRDO8+2j
         pqqo+0w815ZQevBDy/NFUbBHEXRJcoWYtd+Sos+1C72OO/yE4U1UT2yuj9auqvuja/
         D3PleCJi9KSBrDE2OceYLBwQOAq5nHoApcbsze+k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        Avri Altman <avri.altman@wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.12 102/127] Revert "scsi: ufs: fix a missing check of devm_reset_control_get"
Date:   Mon, 24 May 2021 17:26:59 +0200
Message-Id: <20210524152338.303723763@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
References: <20210524152334.857620285@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 4d427b408c4c2ff1676966c72119a3a559f8e39b upstream.

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
 drivers/scsi/ufs/ufs-hisi.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/scsi/ufs/ufs-hisi.c
+++ b/drivers/scsi/ufs/ufs-hisi.c
@@ -468,10 +468,6 @@ static int ufs_hisi_init_common(struct u
 	ufshcd_set_variant(hba, host);
 
 	host->rst  = devm_reset_control_get(dev, "rst");
-	if (IS_ERR(host->rst)) {
-		dev_err(dev, "%s: failed to get reset control\n", __func__);
-		return PTR_ERR(host->rst);
-	}
 
 	ufs_hisi_set_pm_lvl(hba);
 


