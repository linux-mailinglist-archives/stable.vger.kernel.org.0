Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70B0B2F1E9
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730473AbfE3DPp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:15:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:39860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730463AbfE3DPo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:15:44 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AA462459C;
        Thu, 30 May 2019 03:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186144;
        bh=sQSWaWrbGBLv9muTNQfRr4rpK+DViyENGQjtd2P1mug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2vhUFAZgZ5O1QrHAeW3+ZnqVTDzqsclcqGWOK+7mvtT1o0NRUUUHsk0EkINaBEChr
         Kp9dk/7ki5XH/v7pnx+L0L6y+p3g5jYcpqzlv3uvfdRcyF64Nn8qzV70nl8Xp9/wMH
         oABAGWpLPJBEFn7mt9CCtulDa+Bm4RcYCfnmeC/Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        Avri Altman <avri.altman@wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 304/346] scsi: ufs: fix a missing check of devm_reset_control_get
Date:   Wed, 29 May 2019 20:06:17 -0700
Message-Id: <20190530030556.240149492@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 63a06181d7ce169d09843645c50fea1901bc9f0a ]

devm_reset_control_get could fail, so the fix checks its return value and
passes the error code upstream in case it fails.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
Acked-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufs-hisi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/ufs/ufs-hisi.c b/drivers/scsi/ufs/ufs-hisi.c
index 452e19f8fb470..c2cee73a8560d 100644
--- a/drivers/scsi/ufs/ufs-hisi.c
+++ b/drivers/scsi/ufs/ufs-hisi.c
@@ -544,6 +544,10 @@ static int ufs_hisi_init_common(struct ufs_hba *hba)
 	ufshcd_set_variant(hba, host);
 
 	host->rst  = devm_reset_control_get(dev, "rst");
+	if (IS_ERR(host->rst)) {
+		dev_err(dev, "%s: failed to get reset control\n", __func__);
+		return PTR_ERR(host->rst);
+	}
 
 	ufs_hisi_set_pm_lvl(hba);
 
-- 
2.20.1



