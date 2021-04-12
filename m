Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F06AB35BFD5
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239212AbhDLJHA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:07:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:54844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240233AbhDLJFP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:05:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 887B06135C;
        Mon, 12 Apr 2021 09:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218141;
        bh=U4dWBixOcmZg9BEwpq9ZzDgjlH21E9E8wQBwQanL1pY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qt0bCRpHZXAG+6gRa7EQyU7EzV0WDNr3U/zpd4o6ncB5CQUmN9evPCEFV+mQhaGlJ
         x58/FsV1QyYHRxDHMAy9RJSy13c9l7yRwTrojoNmbMsGSe1mVxii+fnX95ve5uOLIR
         QzyMoG6vAwOQ0FiBruj1sJT559h/LKc9kF8IWEzc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Viswas G <Viswas.G@microchip.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ash Izat <ash@ai0.uk>
Subject: [PATCH 5.11 085/210] scsi: pm80xx: Fix chip initialization failure
Date:   Mon, 12 Apr 2021 10:39:50 +0200
Message-Id: <20210412084018.842961940@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Viswas G <Viswas.G@microchip.com>

commit 65df7d1986a1909a0869419919e7d9c78d70407e upstream.

Inbound and outbound queues were not properly configured and that lead to
MPI configuration failure.

Fixes: 05c6c029a44d ("scsi: pm80xx: Increase number of supported queues")
Cc: stable@vger.kernel.org # 5.10+
Link: https://lore.kernel.org/r/20210402054212.17834-1-Viswas.G@microchip.com.com
Reported-and-tested-by: Ash Izat <ash@ai0.uk>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/pm8001/pm8001_hwi.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -223,7 +223,7 @@ static void init_default_table_values(st
 		PM8001_EVENT_LOG_SIZE;
 	pm8001_ha->main_cfg_tbl.pm8001_tbl.iop_event_log_option		= 0x01;
 	pm8001_ha->main_cfg_tbl.pm8001_tbl.fatal_err_interrupt		= 0x01;
-	for (i = 0; i < PM8001_MAX_INB_NUM; i++) {
+	for (i = 0; i < pm8001_ha->max_q_num; i++) {
 		pm8001_ha->inbnd_q_tbl[i].element_pri_size_cnt	=
 			PM8001_MPI_QUEUE | (pm8001_ha->iomb_size << 16) | (0x00<<30);
 		pm8001_ha->inbnd_q_tbl[i].upper_base_addr	=
@@ -249,7 +249,7 @@ static void init_default_table_values(st
 		pm8001_ha->inbnd_q_tbl[i].producer_idx		= 0;
 		pm8001_ha->inbnd_q_tbl[i].consumer_index	= 0;
 	}
-	for (i = 0; i < PM8001_MAX_OUTB_NUM; i++) {
+	for (i = 0; i < pm8001_ha->max_q_num; i++) {
 		pm8001_ha->outbnd_q_tbl[i].element_size_cnt	=
 			PM8001_MPI_QUEUE | (pm8001_ha->iomb_size << 16) | (0x01<<30);
 		pm8001_ha->outbnd_q_tbl[i].upper_base_addr	=
@@ -671,9 +671,9 @@ static int pm8001_chip_init(struct pm800
 	read_outbnd_queue_table(pm8001_ha);
 	/* update main config table ,inbound table and outbound table */
 	update_main_config_table(pm8001_ha);
-	for (i = 0; i < PM8001_MAX_INB_NUM; i++)
+	for (i = 0; i < pm8001_ha->max_q_num; i++)
 		update_inbnd_queue_table(pm8001_ha, i);
-	for (i = 0; i < PM8001_MAX_OUTB_NUM; i++)
+	for (i = 0; i < pm8001_ha->max_q_num; i++)
 		update_outbnd_queue_table(pm8001_ha, i);
 	/* 8081 controller donot require these operations */
 	if (deviceid != 0x8081 && deviceid != 0x0042) {


