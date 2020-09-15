Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA8826B4DE
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbgIOOga (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 10:36:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:47670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727139AbgIOOfY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:35:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2039C2225F;
        Tue, 15 Sep 2020 14:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179966;
        bh=p0yfCuu3r3hC1MeVjINVKDwZIQ6+iZFbH+3cocAao4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xiMpg0vrJ2yXf4WlyZCxgP6sV5+2W9Fofd6/TlZdXisaMLQIvxUmzt61tHuBIpwBn
         zc9wGuVnkM/cI44F9jaWfdRjX3DLsKTCLtC1flyy9qvocypWfRbWDtFOYDMBboJvKD
         F9hCfLRQnHdehxHCAsATso0zoX83sGrKwpTaXC0g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Arun Easi <aeasi@marvell.com>,
        =?UTF-8?q?Ren=C3=A9=20Rebe?= <rene@exactcode.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 026/177] scsi: qla2xxx: Fix regression on sparc64
Date:   Tue, 15 Sep 2020 16:11:37 +0200
Message-Id: <20200915140654.901549591@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: René Rebe <rene@exactcode.com>

[ Upstream commit 2a87d485c4cb4d1b34be6c278a1c6ce3e15c8b8a ]

Commit 98aee70d19a7 ("qla2xxx: Add endianizer to max_payload_size
modifier.") in 2014 broke qla2xxx on sparc64, e.g. as in the Sun Blade 1000
/ 2000. Unbreak by partial revert to fix endianness in nvram firmware
default initialization. Also mark the second frame_payload_size in nvram_t
__le16 to avoid new sparse warnings.

Link: https://lore.kernel.org/r/20200827.222729.1875148247374704975.rene@exactcode.com
Fixes: 98aee70d19a7 ("qla2xxx: Add endianizer to max_payload_size modifier.")
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: René Rebe <rene@exactcode.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_def.h  | 2 +-
 drivers/scsi/qla2xxx/qla_init.c | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 42dbf90d46510..392312333746f 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -1605,7 +1605,7 @@ typedef struct {
 	 */
 	uint8_t	 firmware_options[2];
 
-	uint16_t frame_payload_size;
+	__le16	frame_payload_size;
 	__le16	max_iocb_allocation;
 	__le16	execution_throttle;
 	uint8_t	 retry_count;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 2436a17f5cd91..2861c636dd651 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4603,18 +4603,18 @@ qla2x00_nvram_config(scsi_qla_host_t *vha)
 			nv->firmware_options[1] = BIT_7 | BIT_5;
 			nv->add_firmware_options[0] = BIT_5;
 			nv->add_firmware_options[1] = BIT_5 | BIT_4;
-			nv->frame_payload_size = 2048;
+			nv->frame_payload_size = cpu_to_le16(2048);
 			nv->special_options[1] = BIT_7;
 		} else if (IS_QLA2200(ha)) {
 			nv->firmware_options[0] = BIT_2 | BIT_1;
 			nv->firmware_options[1] = BIT_7 | BIT_5;
 			nv->add_firmware_options[0] = BIT_5;
 			nv->add_firmware_options[1] = BIT_5 | BIT_4;
-			nv->frame_payload_size = 1024;
+			nv->frame_payload_size = cpu_to_le16(1024);
 		} else if (IS_QLA2100(ha)) {
 			nv->firmware_options[0] = BIT_3 | BIT_1;
 			nv->firmware_options[1] = BIT_5;
-			nv->frame_payload_size = 1024;
+			nv->frame_payload_size = cpu_to_le16(1024);
 		}
 
 		nv->max_iocb_allocation = cpu_to_le16(256);
-- 
2.25.1



