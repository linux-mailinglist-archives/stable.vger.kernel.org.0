Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED24114EF6
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbfEFOh1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:37:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:58112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726308AbfEFOh0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:37:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7A44206A3;
        Mon,  6 May 2019 14:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153445;
        bh=pajcmLcPQKgbIqeJurlmK4vrFJz+RTfrxOKFhXUH0RQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rtzN5zJv6EdTimq9kBh5073QC3N9QREKBR5Ht8pJiWu86NqKsE20cVyzSZM2rWARY
         gYILsdMmPkdbjIy8/T/OKt/6fJV5iHPVR1uaRAYJb967q5vxockc9/WIikgOPh+Bzb
         qsmTS99mcScYabVALtor4aseh+xpVWob65GeV0pw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.0 092/122] scsi: hisi_sas: Fix to only call scsi_get_prot_op() for non-NULL scsi_cmnd
Date:   Mon,  6 May 2019 16:32:30 +0200
Message-Id: <20190506143102.943296271@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143054.670334917@linuxfoundation.org>
References: <20190506143054.670334917@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Garry <john.garry@huawei.com>

commit e1ba0b0b44512c5a209526c09ea3eb7d256b6951 upstream.

A NULL-pointer dereference was introduced for TMF SSP commands from the
upstreaming reworking.

Fix this by relocating the scsi_get_prot_op() callsite.

Fixes: d6a9000b81be ("scsi: hisi_sas: Add support for DIF feature for v2 hw")
Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -1033,8 +1033,8 @@ static void prep_ssp_v3_hw(struct hisi_h
 	struct sas_ssp_task *ssp_task = &task->ssp_task;
 	struct scsi_cmnd *scsi_cmnd = ssp_task->cmd;
 	struct hisi_sas_tmf_task *tmf = slot->tmf;
-	unsigned char prot_op = scsi_get_prot_op(scsi_cmnd);
 	int has_data = 0, priority = !!tmf;
+	unsigned char prot_op;
 	u8 *buf_cmd;
 	u32 dw1 = 0, dw2 = 0, len = 0;
 
@@ -1049,6 +1049,7 @@ static void prep_ssp_v3_hw(struct hisi_h
 		dw1 |= 2 << CMD_HDR_FRAME_TYPE_OFF;
 		dw1 |= DIR_NO_DATA << CMD_HDR_DIR_OFF;
 	} else {
+		prot_op = scsi_get_prot_op(scsi_cmnd);
 		dw1 |= 1 << CMD_HDR_FRAME_TYPE_OFF;
 		switch (scsi_cmnd->sc_data_direction) {
 		case DMA_TO_DEVICE:


