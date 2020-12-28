Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A54522E412C
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:03:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439891AbgL1OMd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:12:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:46804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439885AbgL1OMb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:12:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A542B206C3;
        Mon, 28 Dec 2020 14:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164736;
        bh=0npDmd/In9O/OjMT3VJo/+arTiDEArAeDeK+0HAJKmk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BesVMMObGa/WYC/mw+SpwDjks0ZO+rrscHoLZrNH6EDABkf4L9ZqwkHh9PIndaLAB
         quuw+z0n+DPjL88yaPF4D8V4f3pxrtS2aHx+YH9Z5k5vvVDMJDtb29QjAuHU90ruFq
         NmcqNtuwcI/VNchgHu+gBmGFIWxumbpbYQf4gW8w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vikram Auradkar <auradkar@google.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 248/717] scsi: pm80xx: Do not sleep in atomic context
Date:   Mon, 28 Dec 2020 13:44:06 +0100
Message-Id: <20201228125032.869230554@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ahmed S. Darwish <a.darwish@linutronix.de>

[ Upstream commit 4ba9e516573e60c471c01bb369144651f6f8d50b ]

hw_event_sas_phy_up() is used in hardirq/softirq context:

 pm8001_interrupt_handler_msix() || pm8001_interrupt_handler_intx() || pm8001_tasklet
   => PM8001_CHIP_DISP->isr() = pm80xx_chip_isr()
     => process_oq() [spin_lock_irqsave(&pm8001_ha->lock,)]
       => process_one_iomb()
         => mpi_hw_event()
           => hw_event_sas_phy_up()
             => msleep(200)

Revert the msleep() back to an mdelay() to avoid sleeping in atomic
context.

Link: https://lore.kernel.org/r/20201126132952.2287996-2-bigeasy@linutronix.de
Fixes: 4daf1ef3c681 ("scsi: pm80xx: Convert 'long' mdelay to msleep")
Cc: Vikram Auradkar <auradkar@google.com>
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 7593f248afb2c..155382ce84698 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -3363,7 +3363,7 @@ hw_event_sas_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	pm8001_get_attached_sas_addr(phy, phy->sas_phy.attached_sas_addr);
 	spin_unlock_irqrestore(&phy->sas_phy.frame_rcvd_lock, flags);
 	if (pm8001_ha->flags == PM8001F_RUN_TIME)
-		msleep(200);/*delay a moment to wait disk to spinup*/
+		mdelay(200); /* delay a moment to wait for disk to spin up */
 	pm8001_bytes_dmaed(pm8001_ha, phy_id);
 }
 
-- 
2.27.0



