Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6201214A0
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730452AbfLPSNF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:13:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:58804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731058AbfLPSNE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:13:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9382A206E0;
        Mon, 16 Dec 2019 18:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519984;
        bh=Duh2PxodCQwkeKlbuC3U2sf922w4iB2DXgyNgfRLiBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A72z0mORTr7A6+7+r9JxPZbWcp5T5XK6ZJTK+/Kj3gM6hYumVsY1kjEQ3PmdqvWWw
         WaZemBWxxauWfCcje+40iw+z7t1KpS29SUtdIGRJ/oZH0kuIOctKkQz665947uvFQA
         z6zDeFQr98EfobR8Vl7G08bP7TNy5kpCTfxbG4OA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Himanshu Madhani <hmadhani@marvell.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 148/180] scsi: qla2xxx: Check secondary image if reading the primary image fails
Date:   Mon, 16 Dec 2019 18:49:48 +0100
Message-Id: <20191216174843.841843423@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174806.018988360@linuxfoundation.org>
References: <20191216174806.018988360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 0597fe601a3a7d103c35b922046251906e0349b3 ]

This patch fixes several Coverity complaints about reading data that has
not been initialized.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Tested-by: Himanshu Madhani <hmadhani@marvell.com>
Reviewed-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_init.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 2f39ed9c66d64..bcd3411fc6be8 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -7624,8 +7624,12 @@ qla27xx_get_active_image(struct scsi_qla_host *vha,
 		goto check_sec_image;
 	}
 
-	qla24xx_read_flash_data(vha, (void *)(&pri_image_status),
-	    ha->flt_region_img_status_pri, sizeof(pri_image_status) >> 2);
+	if (qla24xx_read_flash_data(vha, (void *)(&pri_image_status),
+	    ha->flt_region_img_status_pri, sizeof(pri_image_status) >> 2) !=
+	    QLA_SUCCESS) {
+		WARN_ON_ONCE(true);
+		goto check_sec_image;
+	}
 	qla27xx_print_image(vha, "Primary image", &pri_image_status);
 
 	if (qla27xx_check_image_status_signature(&pri_image_status)) {
-- 
2.20.1



