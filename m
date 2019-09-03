Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4322DA704A
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730694AbfICQhy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:37:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:47300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730629AbfICQ00 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:26:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17E5D238CE;
        Tue,  3 Sep 2019 16:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567527985;
        bh=FL0R0ieMlAqeFeTgj/WE4/2JzRGpRQvBCF/ziATjPCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S+Xomodswd4lGFkf38Ki6LFPNFajUWNXPUyOZjrUnWvwy8DVDNs3MVYOmB9ceHE1b
         zKHSnnoDYxvtN6uHD92x82RnXQl2bsoSa0YuAlBMR4fK4OwqouEu78/ZhQ/oFpGFjs
         45x2GkcUQys1YBziSNze9wydujV29FGkZ0oDYfcA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 040/167] scsi: megaraid_sas: Fix combined reply queue mode detection
Date:   Tue,  3 Sep 2019 12:23:12 -0400
Message-Id: <20190903162519.7136-40-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

[ Upstream commit e29c322133472628c6de85efb99ccd3b3df5571e ]

For Invader series, if FW supports more than 8 MSI-x vectors, driver needs
to enable combined reply queue mode. For Ventura series, driver enables
combined reply queue mode in case of more than 16 MSI-x vectors.

Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 806ceabcabc3f..b6fc7c6337610 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5325,12 +5325,29 @@ static int megasas_init_fw(struct megasas_instance *instance)
 				instance->msix_vectors = (scratch_pad_2
 					& MR_MAX_REPLY_QUEUES_OFFSET) + 1;
 				fw_msix_count = instance->msix_vectors;
-			} else { /* Invader series supports more than 8 MSI-x vectors*/
+			} else {
 				instance->msix_vectors = ((scratch_pad_2
 					& MR_MAX_REPLY_QUEUES_EXT_OFFSET)
 					>> MR_MAX_REPLY_QUEUES_EXT_OFFSET_SHIFT) + 1;
-				if (instance->msix_vectors > 16)
-					instance->msix_combined = true;
+
+				/*
+				 * For Invader series, > 8 MSI-x vectors
+				 * supported by FW/HW implies combined
+				 * reply queue mode is enabled.
+				 * For Ventura series, > 16 MSI-x vectors
+				 * supported by FW/HW implies combined
+				 * reply queue mode is enabled.
+				 */
+				switch (instance->adapter_type) {
+				case INVADER_SERIES:
+					if (instance->msix_vectors > 8)
+						instance->msix_combined = true;
+					break;
+				case VENTURA_SERIES:
+					if (instance->msix_vectors > 16)
+						instance->msix_combined = true;
+					break;
+				}
 
 				if (rdpq_enable)
 					instance->is_rdpq = (scratch_pad_2 & MR_RDPQ_MODE_OFFSET) ?
-- 
2.20.1

