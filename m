Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 275FE250300
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 18:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728451AbgHXQia (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 12:38:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:40652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728421AbgHXQiK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 12:38:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3F0A22D71;
        Mon, 24 Aug 2020 16:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598287048;
        bh=cwUEubYXyozIkblDt/dZaV/h5IXzRFqz50ycpPTAa74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QXulA57i3F3dd/EHQpYbFZBPcQMnulK55fWaJmbvg8FRmBwIfEv0KB9KYyio1lIEp
         z5pW2+tbn780UIppIT3pcACtJQUdCkLJ+RSP43QnJ1oB/jhXJhhyXW/M3+8pmnzAxb
         iKIEId4nrMNF6/zH+ZQ0a4uEY1qVwmXl0lT6m7cw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 39/54] scsi: qla2xxx: Indicate correct supported speeds for Mezz card
Date:   Mon, 24 Aug 2020 12:36:18 -0400
Message-Id: <20200824163634.606093-39-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200824163634.606093-1-sashal@kernel.org>
References: <20200824163634.606093-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

[ Upstream commit 4709272f6327cc4a8ee1dc55771bcf9718346980 ]

Correct the supported speeds for 16G Mezz card.

Link: https://lore.kernel.org/r/20200806111014.28434-4-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_gs.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 7074073446701..3bfb5678f6515 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1505,11 +1505,11 @@ qla2x00_prep_ct_fdmi_req(struct ct_sns_pkt *p, uint16_t cmd,
 static uint
 qla25xx_fdmi_port_speed_capability(struct qla_hw_data *ha)
 {
+	uint speeds = 0;
+
 	if (IS_CNA_CAPABLE(ha))
 		return FDMI_PORT_SPEED_10GB;
 	if (IS_QLA28XX(ha) || IS_QLA27XX(ha)) {
-		uint speeds = 0;
-
 		if (ha->max_supported_speed == 2) {
 			if (ha->min_supported_speed <= 6)
 				speeds |= FDMI_PORT_SPEED_64GB;
@@ -1536,9 +1536,16 @@ qla25xx_fdmi_port_speed_capability(struct qla_hw_data *ha)
 		}
 		return speeds;
 	}
-	if (IS_QLA2031(ha))
-		return FDMI_PORT_SPEED_16GB|FDMI_PORT_SPEED_8GB|
-			FDMI_PORT_SPEED_4GB;
+	if (IS_QLA2031(ha)) {
+		if ((ha->pdev->subsystem_vendor == 0x103C) &&
+		    (ha->pdev->subsystem_device == 0x8002)) {
+			speeds = FDMI_PORT_SPEED_16GB;
+		} else {
+			speeds = FDMI_PORT_SPEED_16GB|FDMI_PORT_SPEED_8GB|
+				FDMI_PORT_SPEED_4GB;
+		}
+		return speeds;
+	}
 	if (IS_QLA25XX(ha))
 		return FDMI_PORT_SPEED_8GB|FDMI_PORT_SPEED_4GB|
 			FDMI_PORT_SPEED_2GB|FDMI_PORT_SPEED_1GB;
-- 
2.25.1

