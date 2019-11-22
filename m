Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 465BF10640C
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbfKVGO4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 01:14:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:51842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728380AbfKVGOS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 01:14:18 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C00182070E;
        Fri, 22 Nov 2019 06:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574403257;
        bh=yA/ALcMI77WBmSZhAk6X8hHB8Qj7j6gisXQdnHK9arI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FoBMS91vkYfIrNJoEUEGXfoNuxv9JzaI8pOVfpLoz9+EA/qbmvF7eNq4jQRxnqXeU
         SlBE4iARRB5/e8N9LVL+BHdSYTcRKyE9A61TrVXXDjRFTNHp2XQqLQAaNnBFxGLuRq
         a522JN233gboFcGnpk6Fb3Qn9qdXjQrA+1NVgAvI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John Garry <john.garry@huawei.com>, Jian Luo <luojian5@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 66/68] scsi: libsas: Check SMP PHY control function result
Date:   Fri, 22 Nov 2019 01:12:59 -0500
Message-Id: <20191122061301.4947-65-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122061301.4947-1-sashal@kernel.org>
References: <20191122061301.4947-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Garry <john.garry@huawei.com>

[ Upstream commit 01929a65dfa13e18d89264ab1378854a91857e59 ]

Currently the SMP PHY control execution result is checked, however the
function result for the command is not.

As such, we may be missing all potential errors, like SMP FUNCTION FAILED,
INVALID REQUEST FRAME LENGTH, etc., meaning the PHY control request has
failed.

In some scenarios we need to ensure the function result is accepted, so add
a check for this.

Tested-by: Jian Luo <luojian5@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libsas/sas_expander.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index ba16231665a5e..091af5c1cf50f 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -603,7 +603,14 @@ int sas_smp_phy_control(struct domain_device *dev, int phy_id,
 	}
 
 	res = smp_execute_task(dev, pc_req, PC_REQ_SIZE, pc_resp,PC_RESP_SIZE);
-
+	if (res) {
+		pr_err("ex %016llx phy%02d PHY control failed: %d\n",
+		       SAS_ADDR(dev->sas_addr), phy_id, res);
+	} else if (pc_resp[2] != SMP_RESP_FUNC_ACC) {
+		pr_err("ex %016llx phy%02d PHY control failed: function result 0x%x\n",
+		       SAS_ADDR(dev->sas_addr), phy_id, pc_resp[2]);
+		res = pc_resp[2];
+	}
 	kfree(pc_resp);
 	kfree(pc_req);
 	return res;
-- 
2.20.1

