Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3166344251
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231852AbhCVMkZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:40:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:57678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231895AbhCVMjF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:39:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E10B7619C5;
        Mon, 22 Mar 2021 12:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416682;
        bh=wLU7GhQRSUu3f61uFgDw/8SIxqM/CanymuYMLrIG4s8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bfgm54fOoEGnHBbBYEdBZHhYIy7Wl4GtILaOxMEkORSuLMltOAGzUbR3LIUMo9u03
         BIWH1CniJym/ZnjWONWGAixXWpXuMFsIIEEUdKxlo9kEkSupvEyds6eFDB7fCJZOZh
         tCrKdkhTVD+MYw6b6leeAzPOlck3EnFdpt2NmrmA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Yan <yanaijie@huawei.com>,
        John Garry <john.garry@huawei.com>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 081/157] scsi: mvsas: Pass gfp_t flags to libsas event notifiers
Date:   Mon, 22 Mar 2021 13:27:18 +0100
Message-Id: <20210322121936.356769328@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ahmed S. Darwish <a.darwish@linutronix.de>

[ Upstream commit feb18e900f0048001ff375dca639eaa327ab3c1b ]

mvsas calls the non _gfp version of the libsas event notifiers API, leading
to the buggy call chains below:

  mvsas/mv_sas.c: mvs_work_queue() [process context]
  spin_lock_irqsave(mvs_info::lock, )
    -> libsas/sas_event.c: sas_notify_phy_event()
      -> sas_alloc_event()
        -> in_interrupt() = false
          -> invalid GFP_KERNEL allocation
    -> libsas/sas_event.c: sas_notify_port_event()
      -> sas_alloc_event()
        -> in_interrupt() = false
          -> invalid GFP_KERNEL allocation

Use the new event notifiers API instead, which requires callers to
explicitly pass the gfp_t memory allocation flags.

Below are context analysis for the modified functions:

=> mvs_bytes_dmaed():

Since it is invoked from both process and atomic contexts, let its callers
pass the gfp_t flags. Call chains:

  scsi_scan.c: do_scsi_scan_host() [has msleep()]
    -> shost->hostt->scan_start()
    -> [mvsas/mv_init.c: Scsi_Host::scsi_host_template .scan_start = mvs_scan_start()]
    -> mvsas/mv_sas.c: mvs_scan_start()
      -> mvs_bytes_dmaed(..., GFP_KERNEL)

  mvsas/mv_sas.c: mvs_work_queue()
  spin_lock_irqsave(mvs_info::lock,)
    -> mvs_bytes_dmaed(..., GFP_ATOMIC)

  mvsas/mv_64xx.c: mvs_64xx_isr() || mvsas/mv_94xx.c: mvs_94xx_isr()
    -> mvsas/mv_chips.h: mvs_int_full()
      -> mvsas/mv_sas.c: mvs_int_port()
        -> mvs_bytes_dmaed(..., GFP_ATOMIC);

=> mvs_work_queue():

Invoked from process context, but it calls all the libsas event notifier
APIs under a spin_lock_irqsave(). Pass GFP_ATOMIC.

Link: https://lore.kernel.org/r/20210118100955.1761652-5-a.darwish@linutronix.de
Fixes: 1c393b970e0f ("scsi: libsas: Use dynamic alloced work to avoid sas event lost")
Cc: Jason Yan <yanaijie@huawei.com>
Reviewed-by: John Garry <john.garry@huawei.com>
Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mvsas/mv_sas.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index e5e3e95f78b0..484e01428da2 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -216,7 +216,7 @@ void mvs_set_sas_addr(struct mvs_info *mvi, int port_id, u32 off_lo,
 	MVS_CHIP_DISP->write_port_cfg_data(mvi, port_id, hi);
 }
 
-static void mvs_bytes_dmaed(struct mvs_info *mvi, int i)
+static void mvs_bytes_dmaed(struct mvs_info *mvi, int i, gfp_t gfp_flags)
 {
 	struct mvs_phy *phy = &mvi->phy[i];
 	struct asd_sas_phy *sas_phy = &phy->sas_phy;
@@ -229,7 +229,7 @@ static void mvs_bytes_dmaed(struct mvs_info *mvi, int i)
 		return;
 	}
 
-	sas_notify_phy_event(sas_phy, PHYE_OOB_DONE);
+	sas_notify_phy_event_gfp(sas_phy, PHYE_OOB_DONE, gfp_flags);
 
 	if (sas_phy->phy) {
 		struct sas_phy *sphy = sas_phy->phy;
@@ -261,7 +261,7 @@ static void mvs_bytes_dmaed(struct mvs_info *mvi, int i)
 
 	sas_phy->frame_rcvd_size = phy->frame_rcvd_size;
 
-	sas_notify_port_event(sas_phy, PORTE_BYTES_DMAED);
+	sas_notify_port_event_gfp(sas_phy, PORTE_BYTES_DMAED, gfp_flags);
 }
 
 void mvs_scan_start(struct Scsi_Host *shost)
@@ -277,7 +277,7 @@ void mvs_scan_start(struct Scsi_Host *shost)
 	for (j = 0; j < core_nr; j++) {
 		mvi = ((struct mvs_prv_info *)sha->lldd_ha)->mvi[j];
 		for (i = 0; i < mvi->chip->n_phy; ++i)
-			mvs_bytes_dmaed(mvi, i);
+			mvs_bytes_dmaed(mvi, i, GFP_KERNEL);
 	}
 	mvs_prv->scan_finished = 1;
 }
@@ -1892,20 +1892,21 @@ static void mvs_work_queue(struct work_struct *work)
 			if (!(tmp & PHY_READY_MASK)) {
 				sas_phy_disconnected(sas_phy);
 				mvs_phy_disconnected(phy);
-				sas_notify_phy_event(sas_phy,
-					PHYE_LOSS_OF_SIGNAL);
+				sas_notify_phy_event_gfp(sas_phy,
+					PHYE_LOSS_OF_SIGNAL, GFP_ATOMIC);
 				mv_dprintk("phy%d Removed Device\n", phy_no);
 			} else {
 				MVS_CHIP_DISP->detect_porttype(mvi, phy_no);
 				mvs_update_phyinfo(mvi, phy_no, 1);
-				mvs_bytes_dmaed(mvi, phy_no);
+				mvs_bytes_dmaed(mvi, phy_no, GFP_ATOMIC);
 				mvs_port_notify_formed(sas_phy, 0);
 				mv_dprintk("phy%d Attached Device\n", phy_no);
 			}
 		}
 	} else if (mwq->handler & EXP_BRCT_CHG) {
 		phy->phy_event &= ~EXP_BRCT_CHG;
-		sas_notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
+		sas_notify_port_event_gfp(sas_phy,
+				PORTE_BROADCAST_RCVD, GFP_ATOMIC);
 		mv_dprintk("phy%d Got Broadcast Change\n", phy_no);
 	}
 	list_del(&mwq->entry);
@@ -2022,7 +2023,7 @@ void mvs_int_port(struct mvs_info *mvi, int phy_no, u32 events)
 				mdelay(10);
 			}
 
-			mvs_bytes_dmaed(mvi, phy_no);
+			mvs_bytes_dmaed(mvi, phy_no, GFP_ATOMIC);
 			/* whether driver is going to handle hot plug */
 			if (phy->phy_event & PHY_PLUG_OUT) {
 				mvs_port_notify_formed(&phy->sas_phy, 0);
-- 
2.30.1



