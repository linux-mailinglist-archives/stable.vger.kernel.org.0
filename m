Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC07B328FEB
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:02:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242657AbhCAT7B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:59:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:57032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241077AbhCATth (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:49:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BE7464EFE;
        Mon,  1 Mar 2021 17:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621110;
        bh=KrdJjoKSLiWxf/vwtdTpltY9eNLiirgtwuscbPW/qtg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VlqWmd3NwJCZr3l/3bgrbRHk/FOF1RhtFqdcvhoQMu6303cg8qYYPs0AEodEA9CxA
         f3/Ut/GOl/SFVL1h/ww7UuY7QvL2gKmmPr+1u71cftxnoqQ6jjQDdSjmoDJxdCSStK
         daA5SCQmVEVdzJpXsavcfBh0Mb3TiID8xZPwc6tg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        John Garry <john.garry@huawei.com>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 367/775] scsi: libsas: Remove notifier indirection
Date:   Mon,  1 Mar 2021 17:08:55 +0100
Message-Id: <20210301161219.750782918@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Garry <john.garry@huawei.com>

[ Upstream commit 121181f3f839c29d8dd9fdc3cc9babbdc74227f8 ]

LLDDs report events to libsas with .notify_port_event and .notify_phy_event
callbacks.

These callbacks are fixed and so there is no reason why the functions
cannot be called directly, so do that.

This neatens the code slightly, makes it more obvious, and reduces function
pointer usage, which is generally a good thing. Downside is that there are
2x more symbol exports.

[a.darwish@linutronix.de: Remove the now unused "sas_ha" local variables]

Link: https://lore.kernel.org/r/20210118100955.1761652-3-a.darwish@linutronix.de
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/scsi/libsas.rst          |  9 ++----
 drivers/scsi/aic94xx/aic94xx_scb.c     | 20 ++++++-------
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 12 +++-----
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |  3 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  3 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  3 +-
 drivers/scsi/isci/port.c               |  7 ++---
 drivers/scsi/libsas/sas_event.c        | 13 +++------
 drivers/scsi/libsas/sas_init.c         |  6 ----
 drivers/scsi/libsas/sas_internal.h     |  1 -
 drivers/scsi/mvsas/mv_sas.c            | 14 ++++-----
 drivers/scsi/pm8001/pm8001_hwi.c       | 40 ++++++++++++--------------
 drivers/scsi/pm8001/pm8001_sas.c       |  7 ++---
 drivers/scsi/pm8001/pm80xx_hwi.c       | 35 ++++++++++------------
 include/scsi/libsas.h                  |  7 ++---
 15 files changed, 70 insertions(+), 110 deletions(-)

diff --git a/Documentation/scsi/libsas.rst b/Documentation/scsi/libsas.rst
index f9b77c7879dbb..210df1aba1409 100644
--- a/Documentation/scsi/libsas.rst
+++ b/Documentation/scsi/libsas.rst
@@ -189,12 +189,9 @@ num_phys
 The event interface::
 
 	/* LLDD calls these to notify the class of an event. */
-	void (*notify_port_event)(struct sas_phy *, enum port_event);
-	void (*notify_phy_event)(struct sas_phy *, enum phy_event);
-
-When sas_register_ha() returns, those are set and can be
-called by the LLDD to notify the SAS layer of such events
-the SAS layer.
+	void (*notify_ha_event)(struct sas_ha_struct *, enum ha_event);
+	void sas_notify_port_event(struct sas_phy *, enum port_event);
+	void sas_notify_phy_event(struct sas_phy *, enum phy_event);
 
 The port notification::
 
diff --git a/drivers/scsi/aic94xx/aic94xx_scb.c b/drivers/scsi/aic94xx/aic94xx_scb.c
index 13677973da5cf..770546177ca46 100644
--- a/drivers/scsi/aic94xx/aic94xx_scb.c
+++ b/drivers/scsi/aic94xx/aic94xx_scb.c
@@ -68,7 +68,6 @@ static void asd_phy_event_tasklet(struct asd_ascb *ascb,
 					 struct done_list_struct *dl)
 {
 	struct asd_ha_struct *asd_ha = ascb->ha;
-	struct sas_ha_struct *sas_ha = &asd_ha->sas_ha;
 	int phy_id = dl->status_block[0] & DL_PHY_MASK;
 	struct asd_phy *phy = &asd_ha->phys[phy_id];
 
@@ -81,7 +80,7 @@ static void asd_phy_event_tasklet(struct asd_ascb *ascb,
 		ASD_DPRINTK("phy%d: device unplugged\n", phy_id);
 		asd_turn_led(asd_ha, phy_id, 0);
 		sas_phy_disconnected(&phy->sas_phy);
-		sas_ha->notify_phy_event(&phy->sas_phy, PHYE_LOSS_OF_SIGNAL);
+		sas_notify_phy_event(&phy->sas_phy, PHYE_LOSS_OF_SIGNAL);
 		break;
 	case CURRENT_OOB_DONE:
 		/* hot plugged device */
@@ -89,12 +88,12 @@ static void asd_phy_event_tasklet(struct asd_ascb *ascb,
 		get_lrate_mode(phy, oob_mode);
 		ASD_DPRINTK("phy%d device plugged: lrate:0x%x, proto:0x%x\n",
 			    phy_id, phy->sas_phy.linkrate, phy->sas_phy.iproto);
-		sas_ha->notify_phy_event(&phy->sas_phy, PHYE_OOB_DONE);
+		sas_notify_phy_event(&phy->sas_phy, PHYE_OOB_DONE);
 		break;
 	case CURRENT_SPINUP_HOLD:
 		/* hot plug SATA, no COMWAKE sent */
 		asd_turn_led(asd_ha, phy_id, 1);
-		sas_ha->notify_phy_event(&phy->sas_phy, PHYE_SPINUP_HOLD);
+		sas_notify_phy_event(&phy->sas_phy, PHYE_SPINUP_HOLD);
 		break;
 	case CURRENT_GTO_TIMEOUT:
 	case CURRENT_OOB_ERROR:
@@ -102,7 +101,7 @@ static void asd_phy_event_tasklet(struct asd_ascb *ascb,
 			    dl->status_block[1]);
 		asd_turn_led(asd_ha, phy_id, 0);
 		sas_phy_disconnected(&phy->sas_phy);
-		sas_ha->notify_phy_event(&phy->sas_phy, PHYE_OOB_ERROR);
+		sas_notify_phy_event(&phy->sas_phy, PHYE_OOB_ERROR);
 		break;
 	}
 }
@@ -222,7 +221,6 @@ static void asd_bytes_dmaed_tasklet(struct asd_ascb *ascb,
 	int edb_el = edb_id + ascb->edb_index;
 	struct asd_dma_tok *edb = ascb->ha->seq.edb_arr[edb_el];
 	struct asd_phy *phy = &ascb->ha->phys[phy_id];
-	struct sas_ha_struct *sas_ha = phy->sas_phy.ha;
 	u16 size = ((dl->status_block[3] & 7) << 8) | dl->status_block[2];
 
 	size = min(size, (u16) sizeof(phy->frame_rcvd));
@@ -234,7 +232,7 @@ static void asd_bytes_dmaed_tasklet(struct asd_ascb *ascb,
 	spin_unlock_irqrestore(&phy->sas_phy.frame_rcvd_lock, flags);
 	asd_dump_frame_rcvd(phy, dl);
 	asd_form_port(ascb->ha, phy);
-	sas_ha->notify_port_event(&phy->sas_phy, PORTE_BYTES_DMAED);
+	sas_notify_port_event(&phy->sas_phy, PORTE_BYTES_DMAED);
 }
 
 static void asd_link_reset_err_tasklet(struct asd_ascb *ascb,
@@ -270,7 +268,7 @@ static void asd_link_reset_err_tasklet(struct asd_ascb *ascb,
 	asd_turn_led(asd_ha, phy_id, 0);
 	sas_phy_disconnected(sas_phy);
 	asd_deform_port(asd_ha, phy);
-	sas_ha->notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
+	sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
 
 	if (retries_left == 0) {
 		int num = 1;
@@ -315,7 +313,7 @@ static void asd_primitive_rcvd_tasklet(struct asd_ascb *ascb,
 			spin_lock_irqsave(&sas_phy->sas_prim_lock, flags);
 			sas_phy->sas_prim = ffs(cont);
 			spin_unlock_irqrestore(&sas_phy->sas_prim_lock, flags);
-			sas_ha->notify_port_event(sas_phy,PORTE_BROADCAST_RCVD);
+			sas_notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
 			break;
 
 		case LmUNKNOWNP:
@@ -336,7 +334,7 @@ static void asd_primitive_rcvd_tasklet(struct asd_ascb *ascb,
 			/* The sequencer disables all phys on that port.
 			 * We have to re-enable the phys ourselves. */
 			asd_deform_port(asd_ha, phy);
-			sas_ha->notify_port_event(sas_phy, PORTE_HARD_RESET);
+			sas_notify_port_event(sas_phy, PORTE_HARD_RESET);
 			break;
 
 		default:
@@ -567,7 +565,7 @@ static void escb_tasklet_complete(struct asd_ascb *ascb,
 		/* the device is gone */
 		sas_phy_disconnected(sas_phy);
 		asd_deform_port(asd_ha, phy);
-		sas_ha->notify_port_event(sas_phy, PORTE_TIMER_EVENT);
+		sas_notify_port_event(sas_phy, PORTE_TIMER_EVENT);
 		break;
 	default:
 		ASD_DPRINTK("%s: phy%d: unknown event:0x%x\n", __func__,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index cf0bfac920a81..76f8fc3fad599 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -616,7 +616,6 @@ static void hisi_sas_bytes_dmaed(struct hisi_hba *hisi_hba, int phy_no)
 {
 	struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
 	struct asd_sas_phy *sas_phy = &phy->sas_phy;
-	struct sas_ha_struct *sas_ha;
 
 	if (!phy->phy_attached)
 		return;
@@ -627,8 +626,7 @@ static void hisi_sas_bytes_dmaed(struct hisi_hba *hisi_hba, int phy_no)
 		return;
 	}
 
-	sas_ha = &hisi_hba->sha;
-	sas_ha->notify_phy_event(sas_phy, PHYE_OOB_DONE);
+	sas_notify_phy_event(sas_phy, PHYE_OOB_DONE);
 
 	if (sas_phy->phy) {
 		struct sas_phy *sphy = sas_phy->phy;
@@ -656,7 +654,7 @@ static void hisi_sas_bytes_dmaed(struct hisi_hba *hisi_hba, int phy_no)
 	}
 
 	sas_phy->frame_rcvd_size = phy->frame_rcvd_size;
-	sas_ha->notify_port_event(sas_phy, PORTE_BYTES_DMAED);
+	sas_notify_port_event(sas_phy, PORTE_BYTES_DMAED);
 }
 
 static struct hisi_sas_device *hisi_sas_alloc_dev(struct domain_device *device)
@@ -1411,7 +1409,6 @@ static void hisi_sas_refresh_port_id(struct hisi_hba *hisi_hba)
 
 static void hisi_sas_rescan_topology(struct hisi_hba *hisi_hba, u32 state)
 {
-	struct sas_ha_struct *sas_ha = &hisi_hba->sha;
 	struct asd_sas_port *_sas_port = NULL;
 	int phy_no;
 
@@ -1432,7 +1429,7 @@ static void hisi_sas_rescan_topology(struct hisi_hba *hisi_hba, u32 state)
 				_sas_port = sas_port;
 
 				if (dev_is_expander(dev->dev_type))
-					sas_ha->notify_port_event(sas_phy,
+					sas_notify_port_event(sas_phy,
 							PORTE_BROADCAST_RCVD);
 			}
 		} else {
@@ -2194,7 +2191,6 @@ void hisi_sas_phy_down(struct hisi_hba *hisi_hba, int phy_no, int rdy)
 {
 	struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
 	struct asd_sas_phy *sas_phy = &phy->sas_phy;
-	struct sas_ha_struct *sas_ha = &hisi_hba->sha;
 	struct device *dev = hisi_hba->dev;
 
 	if (rdy) {
@@ -2210,7 +2206,7 @@ void hisi_sas_phy_down(struct hisi_hba *hisi_hba, int phy_no, int rdy)
 			return;
 		}
 		/* Phy down and not ready */
-		sas_ha->notify_phy_event(sas_phy, PHYE_LOSS_OF_SIGNAL);
+		sas_notify_phy_event(sas_phy, PHYE_LOSS_OF_SIGNAL);
 		sas_phy_disconnected(sas_phy);
 
 		if (port) {
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 45e866cb9164d..22eecc89d41bd 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1408,7 +1408,6 @@ static irqreturn_t int_bcast_v1_hw(int irq, void *p)
 	struct hisi_sas_phy *phy = p;
 	struct hisi_hba *hisi_hba = phy->hisi_hba;
 	struct asd_sas_phy *sas_phy = &phy->sas_phy;
-	struct sas_ha_struct *sha = &hisi_hba->sha;
 	struct device *dev = hisi_hba->dev;
 	int phy_no = sas_phy->id;
 	u32 irq_value;
@@ -1424,7 +1423,7 @@ static irqreturn_t int_bcast_v1_hw(int irq, void *p)
 	}
 
 	if (!test_bit(HISI_SAS_RESET_BIT, &hisi_hba->flags))
-		sha->notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
+		sas_notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
 
 end:
 	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT2,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 9adfdefef9cad..10ba0680da04b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -2818,14 +2818,13 @@ static void phy_bcast_v2_hw(int phy_no, struct hisi_hba *hisi_hba)
 {
 	struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
 	struct asd_sas_phy *sas_phy = &phy->sas_phy;
-	struct sas_ha_struct *sas_ha = &hisi_hba->sha;
 	u32 bcast_status;
 
 	hisi_sas_phy_write32(hisi_hba, phy_no, SL_RX_BCAST_CHK_MSK, 1);
 	bcast_status = hisi_sas_phy_read32(hisi_hba, phy_no, RX_PRIMS_STATUS);
 	if ((bcast_status & RX_BCAST_CHG_MSK) &&
 	    !test_bit(HISI_SAS_RESET_BIT, &hisi_hba->flags))
-		sas_ha->notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
+		sas_notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
 	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT0,
 			     CHL_INT0_SL_RX_BCST_ACK_MSK);
 	hisi_sas_phy_write32(hisi_hba, phy_no, SL_RX_BCAST_CHK_MSK, 0);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 7c12804b4e1d1..9d9dcc11a866b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -1600,14 +1600,13 @@ static irqreturn_t phy_bcast_v3_hw(int phy_no, struct hisi_hba *hisi_hba)
 {
 	struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
 	struct asd_sas_phy *sas_phy = &phy->sas_phy;
-	struct sas_ha_struct *sas_ha = &hisi_hba->sha;
 	u32 bcast_status;
 
 	hisi_sas_phy_write32(hisi_hba, phy_no, SL_RX_BCAST_CHK_MSK, 1);
 	bcast_status = hisi_sas_phy_read32(hisi_hba, phy_no, RX_PRIMS_STATUS);
 	if ((bcast_status & RX_BCAST_CHG_MSK) &&
 	    !test_bit(HISI_SAS_RESET_BIT, &hisi_hba->flags))
-		sas_ha->notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
+		sas_notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
 	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT0,
 			     CHL_INT0_SL_RX_BCST_ACK_MSK);
 	hisi_sas_phy_write32(hisi_hba, phy_no, SL_RX_BCAST_CHK_MSK, 0);
diff --git a/drivers/scsi/isci/port.c b/drivers/scsi/isci/port.c
index 1df45f028ea75..8d93497380674 100644
--- a/drivers/scsi/isci/port.c
+++ b/drivers/scsi/isci/port.c
@@ -164,7 +164,7 @@ static void isci_port_bc_change_received(struct isci_host *ihost,
 		"%s: isci_phy = %p, sas_phy = %p\n",
 		__func__, iphy, &iphy->sas_phy);
 
-	ihost->sas_ha.notify_port_event(&iphy->sas_phy, PORTE_BROADCAST_RCVD);
+	sas_notify_port_event(&iphy->sas_phy, PORTE_BROADCAST_RCVD);
 	sci_port_bcn_enable(iport);
 }
 
@@ -223,8 +223,7 @@ static void isci_port_link_up(struct isci_host *isci_host,
 	/* Notify libsas that we have an address frame, if indeed
 	 * we've found an SSP, SMP, or STP target */
 	if (success)
-		isci_host->sas_ha.notify_port_event(&iphy->sas_phy,
-						    PORTE_BYTES_DMAED);
+		sas_notify_port_event(&iphy->sas_phy, PORTE_BYTES_DMAED);
 }
 
 
@@ -270,7 +269,7 @@ static void isci_port_link_down(struct isci_host *isci_host,
 	 * isci_port_deformed and isci_dev_gone functions.
 	 */
 	sas_phy_disconnected(&isci_phy->sas_phy);
-	isci_host->sas_ha.notify_phy_event(&isci_phy->sas_phy,
+	sas_notify_phy_event(&isci_phy->sas_phy,
 					   PHYE_LOSS_OF_SIGNAL);
 
 	dev_dbg(&isci_host->pdev->dev,
diff --git a/drivers/scsi/libsas/sas_event.c b/drivers/scsi/libsas/sas_event.c
index a1852f6c042b9..112a1b76f63b1 100644
--- a/drivers/scsi/libsas/sas_event.c
+++ b/drivers/scsi/libsas/sas_event.c
@@ -109,7 +109,7 @@ void sas_enable_revalidation(struct sas_ha_struct *ha)
 
 		sas_phy = container_of(port->phy_list.next, struct asd_sas_phy,
 				port_phy_el);
-		ha->notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
+		sas_notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
 	}
 	mutex_unlock(&ha->disco_mutex);
 }
@@ -131,7 +131,7 @@ static void sas_phy_event_worker(struct work_struct *work)
 	sas_free_event(ev);
 }
 
-static int sas_notify_port_event(struct asd_sas_phy *phy, enum port_event event)
+int sas_notify_port_event(struct asd_sas_phy *phy, enum port_event event)
 {
 	struct asd_sas_event *ev;
 	struct sas_ha_struct *ha = phy->ha;
@@ -151,6 +151,7 @@ static int sas_notify_port_event(struct asd_sas_phy *phy, enum port_event event)
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(sas_notify_port_event);
 
 int sas_notify_phy_event(struct asd_sas_phy *phy, enum phy_event event)
 {
@@ -172,11 +173,5 @@ int sas_notify_phy_event(struct asd_sas_phy *phy, enum phy_event event)
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(sas_notify_phy_event);
 
-int sas_init_events(struct sas_ha_struct *sas_ha)
-{
-	sas_ha->notify_port_event = sas_notify_port_event;
-	sas_ha->notify_phy_event = sas_notify_phy_event;
-
-	return 0;
-}
diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
index 21c43b18d5d5b..6dc2505d36af7 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -123,12 +123,6 @@ int sas_register_ha(struct sas_ha_struct *sas_ha)
 		goto Undo_phys;
 	}
 
-	error = sas_init_events(sas_ha);
-	if (error) {
-		pr_notice("couldn't start event thread:%d\n", error);
-		goto Undo_ports;
-	}
-
 	error = -ENOMEM;
 	snprintf(name, sizeof(name), "%s_event_q", dev_name(sas_ha->dev));
 	sas_ha->event_q = create_singlethread_workqueue(name);
diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index 1f1d01901978c..53ea32ed17a75 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -54,7 +54,6 @@ void sas_free_event(struct asd_sas_event *event);
 int  sas_register_ports(struct sas_ha_struct *sas_ha);
 void sas_unregister_ports(struct sas_ha_struct *sas_ha);
 
-int  sas_init_events(struct sas_ha_struct *sas_ha);
 void sas_disable_revalidation(struct sas_ha_struct *ha);
 void sas_enable_revalidation(struct sas_ha_struct *ha);
 void __sas_drain_work(struct sas_ha_struct *ha);
diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index a920eced92ecc..e5e3e95f78b0c 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -220,7 +220,7 @@ static void mvs_bytes_dmaed(struct mvs_info *mvi, int i)
 {
 	struct mvs_phy *phy = &mvi->phy[i];
 	struct asd_sas_phy *sas_phy = &phy->sas_phy;
-	struct sas_ha_struct *sas_ha;
+
 	if (!phy->phy_attached)
 		return;
 
@@ -229,8 +229,7 @@ static void mvs_bytes_dmaed(struct mvs_info *mvi, int i)
 		return;
 	}
 
-	sas_ha = mvi->sas;
-	sas_ha->notify_phy_event(sas_phy, PHYE_OOB_DONE);
+	sas_notify_phy_event(sas_phy, PHYE_OOB_DONE);
 
 	if (sas_phy->phy) {
 		struct sas_phy *sphy = sas_phy->phy;
@@ -262,8 +261,7 @@ static void mvs_bytes_dmaed(struct mvs_info *mvi, int i)
 
 	sas_phy->frame_rcvd_size = phy->frame_rcvd_size;
 
-	mvi->sas->notify_port_event(sas_phy,
-				   PORTE_BYTES_DMAED);
+	sas_notify_port_event(sas_phy, PORTE_BYTES_DMAED);
 }
 
 void mvs_scan_start(struct Scsi_Host *shost)
@@ -1880,7 +1878,6 @@ static void mvs_work_queue(struct work_struct *work)
 	struct mvs_info *mvi = mwq->mvi;
 	unsigned long flags;
 	u32 phy_no = (unsigned long) mwq->data;
-	struct sas_ha_struct *sas_ha = mvi->sas;
 	struct mvs_phy *phy = &mvi->phy[phy_no];
 	struct asd_sas_phy *sas_phy = &phy->sas_phy;
 
@@ -1895,7 +1892,7 @@ static void mvs_work_queue(struct work_struct *work)
 			if (!(tmp & PHY_READY_MASK)) {
 				sas_phy_disconnected(sas_phy);
 				mvs_phy_disconnected(phy);
-				sas_ha->notify_phy_event(sas_phy,
+				sas_notify_phy_event(sas_phy,
 					PHYE_LOSS_OF_SIGNAL);
 				mv_dprintk("phy%d Removed Device\n", phy_no);
 			} else {
@@ -1908,8 +1905,7 @@ static void mvs_work_queue(struct work_struct *work)
 		}
 	} else if (mwq->handler & EXP_BRCT_CHG) {
 		phy->phy_event &= ~EXP_BRCT_CHG;
-		sas_ha->notify_port_event(sas_phy,
-				PORTE_BROADCAST_RCVD);
+		sas_notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
 		mv_dprintk("phy%d Got Broadcast Change\n", phy_no);
 	}
 	list_del(&mwq->entry);
diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index c8d4d87c54737..dd15246d5b037 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -3179,7 +3179,7 @@ void pm8001_bytes_dmaed(struct pm8001_hba_info *pm8001_ha, int i)
 	pm8001_dbg(pm8001_ha, MSG, "phy %d byte dmaded.\n", i);
 
 	sas_phy->frame_rcvd_size = phy->frame_rcvd_size;
-	pm8001_ha->sas->notify_port_event(sas_phy, PORTE_BYTES_DMAED);
+	sas_notify_port_event(sas_phy, PORTE_BYTES_DMAED);
 }
 
 /* Get the link rate speed  */
@@ -3293,7 +3293,6 @@ hw_event_sas_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	u32 npip_portstate = le32_to_cpu(pPayload->npip_portstate);
 	u8 portstate = (u8)(npip_portstate & 0x0000000F);
 	struct pm8001_port *port = &pm8001_ha->port[port_id];
-	struct sas_ha_struct *sas_ha = pm8001_ha->sas;
 	struct pm8001_phy *phy = &pm8001_ha->phy[phy_id];
 	unsigned long flags;
 	u8 deviceType = pPayload->sas_identify.dev_type;
@@ -3337,7 +3336,7 @@ hw_event_sas_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	else if (phy->identify.device_type != SAS_PHY_UNUSED)
 		phy->identify.target_port_protocols = SAS_PROTOCOL_SMP;
 	phy->sas_phy.oob_mode = SAS_OOB_MODE;
-	sas_ha->notify_phy_event(&phy->sas_phy, PHYE_OOB_DONE);
+	sas_notify_phy_event(&phy->sas_phy, PHYE_OOB_DONE);
 	spin_lock_irqsave(&phy->sas_phy.frame_rcvd_lock, flags);
 	memcpy(phy->frame_rcvd, &pPayload->sas_identify,
 		sizeof(struct sas_identify_frame)-4);
@@ -3369,7 +3368,6 @@ hw_event_sata_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	u32 npip_portstate = le32_to_cpu(pPayload->npip_portstate);
 	u8 portstate = (u8)(npip_portstate & 0x0000000F);
 	struct pm8001_port *port = &pm8001_ha->port[port_id];
-	struct sas_ha_struct *sas_ha = pm8001_ha->sas;
 	struct pm8001_phy *phy = &pm8001_ha->phy[phy_id];
 	unsigned long flags;
 	pm8001_dbg(pm8001_ha, DEVIO, "HW_EVENT_SATA_PHY_UP port id = %d, phy id = %d\n",
@@ -3381,7 +3379,7 @@ hw_event_sata_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	phy->phy_type |= PORT_TYPE_SATA;
 	phy->phy_attached = 1;
 	phy->sas_phy.oob_mode = SATA_OOB_MODE;
-	sas_ha->notify_phy_event(&phy->sas_phy, PHYE_OOB_DONE);
+	sas_notify_phy_event(&phy->sas_phy, PHYE_OOB_DONE);
 	spin_lock_irqsave(&phy->sas_phy.frame_rcvd_lock, flags);
 	memcpy(phy->frame_rcvd, ((u8 *)&pPayload->sata_fis - 4),
 		sizeof(struct dev_to_host_fis));
@@ -3728,11 +3726,11 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 		break;
 	case HW_EVENT_SATA_SPINUP_HOLD:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_SATA_SPINUP_HOLD\n");
-		sas_ha->notify_phy_event(&phy->sas_phy, PHYE_SPINUP_HOLD);
+		sas_notify_phy_event(&phy->sas_phy, PHYE_SPINUP_HOLD);
 		break;
 	case HW_EVENT_PHY_DOWN:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PHY_DOWN\n");
-		sas_ha->notify_phy_event(&phy->sas_phy, PHYE_LOSS_OF_SIGNAL);
+		sas_notify_phy_event(&phy->sas_phy, PHYE_LOSS_OF_SIGNAL);
 		phy->phy_attached = 0;
 		phy->phy_state = 0;
 		hw_event_phy_down(pm8001_ha, piomb);
@@ -3741,7 +3739,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PORT_INVALID\n");
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_ha->notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
+		sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
 		break;
 	/* the broadcast change primitive received, tell the LIBSAS this event
 	to revalidate the sas domain*/
@@ -3752,20 +3750,20 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 		spin_lock_irqsave(&sas_phy->sas_prim_lock, flags);
 		sas_phy->sas_prim = HW_EVENT_BROADCAST_CHANGE;
 		spin_unlock_irqrestore(&sas_phy->sas_prim_lock, flags);
-		sas_ha->notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
+		sas_notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
 		break;
 	case HW_EVENT_PHY_ERROR:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PHY_ERROR\n");
 		sas_phy_disconnected(&phy->sas_phy);
 		phy->phy_attached = 0;
-		sas_ha->notify_phy_event(&phy->sas_phy, PHYE_OOB_ERROR);
+		sas_notify_phy_event(&phy->sas_phy, PHYE_OOB_ERROR);
 		break;
 	case HW_EVENT_BROADCAST_EXP:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_BROADCAST_EXP\n");
 		spin_lock_irqsave(&sas_phy->sas_prim_lock, flags);
 		sas_phy->sas_prim = HW_EVENT_BROADCAST_EXP;
 		spin_unlock_irqrestore(&sas_phy->sas_prim_lock, flags);
-		sas_ha->notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
+		sas_notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
 		break;
 	case HW_EVENT_LINK_ERR_INVALID_DWORD:
 		pm8001_dbg(pm8001_ha, MSG,
@@ -3774,7 +3772,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 			HW_EVENT_LINK_ERR_INVALID_DWORD, port_id, phy_id, 0, 0);
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_ha->notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
+		sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
 		break;
 	case HW_EVENT_LINK_ERR_DISPARITY_ERROR:
 		pm8001_dbg(pm8001_ha, MSG,
@@ -3784,7 +3782,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 			port_id, phy_id, 0, 0);
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_ha->notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
+		sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
 		break;
 	case HW_EVENT_LINK_ERR_CODE_VIOLATION:
 		pm8001_dbg(pm8001_ha, MSG,
@@ -3794,7 +3792,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 			port_id, phy_id, 0, 0);
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_ha->notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
+		sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
 		break;
 	case HW_EVENT_LINK_ERR_LOSS_OF_DWORD_SYNCH:
 		pm8001_dbg(pm8001_ha, MSG,
@@ -3804,7 +3802,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 			port_id, phy_id, 0, 0);
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_ha->notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
+		sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
 		break;
 	case HW_EVENT_MALFUNCTION:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_MALFUNCTION\n");
@@ -3814,7 +3812,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 		spin_lock_irqsave(&sas_phy->sas_prim_lock, flags);
 		sas_phy->sas_prim = HW_EVENT_BROADCAST_SES;
 		spin_unlock_irqrestore(&sas_phy->sas_prim_lock, flags);
-		sas_ha->notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
+		sas_notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
 		break;
 	case HW_EVENT_INBOUND_CRC_ERROR:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_INBOUND_CRC_ERROR\n");
@@ -3824,13 +3822,13 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 		break;
 	case HW_EVENT_HARD_RESET_RECEIVED:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_HARD_RESET_RECEIVED\n");
-		sas_ha->notify_port_event(sas_phy, PORTE_HARD_RESET);
+		sas_notify_port_event(sas_phy, PORTE_HARD_RESET);
 		break;
 	case HW_EVENT_ID_FRAME_TIMEOUT:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_ID_FRAME_TIMEOUT\n");
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_ha->notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
+		sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
 		break;
 	case HW_EVENT_LINK_ERR_PHY_RESET_FAILED:
 		pm8001_dbg(pm8001_ha, MSG,
@@ -3840,20 +3838,20 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 			port_id, phy_id, 0, 0);
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_ha->notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
+		sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
 		break;
 	case HW_EVENT_PORT_RESET_TIMER_TMO:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PORT_RESET_TIMER_TMO\n");
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_ha->notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
+		sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
 		break;
 	case HW_EVENT_PORT_RECOVERY_TIMER_TMO:
 		pm8001_dbg(pm8001_ha, MSG,
 			   "HW_EVENT_PORT_RECOVERY_TIMER_TMO\n");
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_ha->notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
+		sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
 		break;
 	case HW_EVENT_PORT_RECOVER:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PORT_RECOVER\n");
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index d1e9dba2ef193..e21c6cfff4cbd 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -158,7 +158,6 @@ int pm8001_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
 	int rc = 0, phy_id = sas_phy->id;
 	struct pm8001_hba_info *pm8001_ha = NULL;
 	struct sas_phy_linkrates *rates;
-	struct sas_ha_struct *sas_ha;
 	struct pm8001_phy *phy;
 	DECLARE_COMPLETION_ONSTACK(completion);
 	unsigned long flags;
@@ -207,18 +206,16 @@ int pm8001_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
 		if (pm8001_ha->chip_id != chip_8001) {
 			if (pm8001_ha->phy[phy_id].phy_state ==
 				PHY_STATE_LINK_UP_SPCV) {
-				sas_ha = pm8001_ha->sas;
 				sas_phy_disconnected(&phy->sas_phy);
-				sas_ha->notify_phy_event(&phy->sas_phy,
+				sas_notify_phy_event(&phy->sas_phy,
 					PHYE_LOSS_OF_SIGNAL);
 				phy->phy_attached = 0;
 			}
 		} else {
 			if (pm8001_ha->phy[phy_id].phy_state ==
 				PHY_STATE_LINK_UP_SPC) {
-				sas_ha = pm8001_ha->sas;
 				sas_phy_disconnected(&phy->sas_phy);
-				sas_ha->notify_phy_event(&phy->sas_phy,
+				sas_notify_phy_event(&phy->sas_phy,
 					PHYE_LOSS_OF_SIGNAL);
 				phy->phy_attached = 0;
 			}
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 6772b0924dac8..f617177b7bb33 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -3243,7 +3243,6 @@ hw_event_sas_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	u8 portstate = (u8)(phyid_npip_portstate & 0x0000000F);
 
 	struct pm8001_port *port = &pm8001_ha->port[port_id];
-	struct sas_ha_struct *sas_ha = pm8001_ha->sas;
 	struct pm8001_phy *phy = &pm8001_ha->phy[phy_id];
 	unsigned long flags;
 	u8 deviceType = pPayload->sas_identify.dev_type;
@@ -3288,7 +3287,7 @@ hw_event_sas_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	else if (phy->identify.device_type != SAS_PHY_UNUSED)
 		phy->identify.target_port_protocols = SAS_PROTOCOL_SMP;
 	phy->sas_phy.oob_mode = SAS_OOB_MODE;
-	sas_ha->notify_phy_event(&phy->sas_phy, PHYE_OOB_DONE);
+	sas_notify_phy_event(&phy->sas_phy, PHYE_OOB_DONE);
 	spin_lock_irqsave(&phy->sas_phy.frame_rcvd_lock, flags);
 	memcpy(phy->frame_rcvd, &pPayload->sas_identify,
 		sizeof(struct sas_identify_frame)-4);
@@ -3322,7 +3321,6 @@ hw_event_sata_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	u8 portstate = (u8)(phyid_npip_portstate & 0x0000000F);
 
 	struct pm8001_port *port = &pm8001_ha->port[port_id];
-	struct sas_ha_struct *sas_ha = pm8001_ha->sas;
 	struct pm8001_phy *phy = &pm8001_ha->phy[phy_id];
 	unsigned long flags;
 	pm8001_dbg(pm8001_ha, DEVIO,
@@ -3336,7 +3334,7 @@ hw_event_sata_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	phy->phy_type |= PORT_TYPE_SATA;
 	phy->phy_attached = 1;
 	phy->sas_phy.oob_mode = SATA_OOB_MODE;
-	sas_ha->notify_phy_event(&phy->sas_phy, PHYE_OOB_DONE);
+	sas_notify_phy_event(&phy->sas_phy, PHYE_OOB_DONE);
 	spin_lock_irqsave(&phy->sas_phy.frame_rcvd_lock, flags);
 	memcpy(phy->frame_rcvd, ((u8 *)&pPayload->sata_fis - 4),
 		sizeof(struct dev_to_host_fis));
@@ -3418,11 +3416,8 @@ hw_event_phy_down(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		break;
 
 	}
-	if (port_sata && (portstate != PORT_IN_RESET)) {
-		struct sas_ha_struct *sas_ha = pm8001_ha->sas;
-
-		sas_ha->notify_phy_event(&phy->sas_phy, PHYE_LOSS_OF_SIGNAL);
-	}
+	if (port_sata && (portstate != PORT_IN_RESET))
+		sas_notify_phy_event(&phy->sas_phy, PHYE_LOSS_OF_SIGNAL);
 }
 
 static int mpi_phy_start_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
@@ -3520,7 +3515,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		break;
 	case HW_EVENT_SATA_SPINUP_HOLD:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_SATA_SPINUP_HOLD\n");
-		sas_ha->notify_phy_event(&phy->sas_phy, PHYE_SPINUP_HOLD);
+		sas_notify_phy_event(&phy->sas_phy, PHYE_SPINUP_HOLD);
 		break;
 	case HW_EVENT_PHY_DOWN:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PHY_DOWN\n");
@@ -3536,7 +3531,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PORT_INVALID\n");
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_ha->notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
+		sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
 		break;
 	/* the broadcast change primitive received, tell the LIBSAS this event
 	to revalidate the sas domain*/
@@ -3547,20 +3542,20 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		spin_lock_irqsave(&sas_phy->sas_prim_lock, flags);
 		sas_phy->sas_prim = HW_EVENT_BROADCAST_CHANGE;
 		spin_unlock_irqrestore(&sas_phy->sas_prim_lock, flags);
-		sas_ha->notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
+		sas_notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
 		break;
 	case HW_EVENT_PHY_ERROR:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PHY_ERROR\n");
 		sas_phy_disconnected(&phy->sas_phy);
 		phy->phy_attached = 0;
-		sas_ha->notify_phy_event(&phy->sas_phy, PHYE_OOB_ERROR);
+		sas_notify_phy_event(&phy->sas_phy, PHYE_OOB_ERROR);
 		break;
 	case HW_EVENT_BROADCAST_EXP:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_BROADCAST_EXP\n");
 		spin_lock_irqsave(&sas_phy->sas_prim_lock, flags);
 		sas_phy->sas_prim = HW_EVENT_BROADCAST_EXP;
 		spin_unlock_irqrestore(&sas_phy->sas_prim_lock, flags);
-		sas_ha->notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
+		sas_notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
 		break;
 	case HW_EVENT_LINK_ERR_INVALID_DWORD:
 		pm8001_dbg(pm8001_ha, MSG,
@@ -3597,7 +3592,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		spin_lock_irqsave(&sas_phy->sas_prim_lock, flags);
 		sas_phy->sas_prim = HW_EVENT_BROADCAST_SES;
 		spin_unlock_irqrestore(&sas_phy->sas_prim_lock, flags);
-		sas_ha->notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
+		sas_notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
 		break;
 	case HW_EVENT_INBOUND_CRC_ERROR:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_INBOUND_CRC_ERROR\n");
@@ -3607,13 +3602,13 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		break;
 	case HW_EVENT_HARD_RESET_RECEIVED:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_HARD_RESET_RECEIVED\n");
-		sas_ha->notify_port_event(sas_phy, PORTE_HARD_RESET);
+		sas_notify_port_event(sas_phy, PORTE_HARD_RESET);
 		break;
 	case HW_EVENT_ID_FRAME_TIMEOUT:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_ID_FRAME_TIMEOUT\n");
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_ha->notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
+		sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
 		break;
 	case HW_EVENT_LINK_ERR_PHY_RESET_FAILED:
 		pm8001_dbg(pm8001_ha, MSG,
@@ -3623,7 +3618,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			port_id, phy_id, 0, 0);
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_ha->notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
+		sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
 		break;
 	case HW_EVENT_PORT_RESET_TIMER_TMO:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PORT_RESET_TIMER_TMO\n");
@@ -3631,7 +3626,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			port_id, phy_id, 0, 0);
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_ha->notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
+		sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
 		if (pm8001_ha->phy[phy_id].reset_completion) {
 			pm8001_ha->phy[phy_id].port_reset_status =
 					PORT_RESET_TMO;
@@ -3648,7 +3643,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		for (i = 0; i < pm8001_ha->chip->n_phy; i++) {
 			if (port->wide_port_phymap & (1 << i)) {
 				phy = &pm8001_ha->phy[i];
-				sas_ha->notify_phy_event(&phy->sas_phy,
+				sas_notify_phy_event(&phy->sas_phy,
 						PHYE_LOSS_OF_SIGNAL);
 				port->wide_port_phymap &= ~(1 << i);
 			}
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 4e2d61e8fb1ed..3387149502e9a 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -391,10 +391,6 @@ struct sas_ha_struct {
 	int strict_wide_ports; /* both sas_addr and attached_sas_addr must match
 				* their siblings when forming wide ports */
 
-	/* LLDD calls these to notify the class of an event. */
-	int (*notify_port_event)(struct asd_sas_phy *, enum port_event);
-	int (*notify_phy_event)(struct asd_sas_phy *, enum phy_event);
-
 	void *lldd_ha;		  /* not touched by sas class code */
 
 	struct list_head eh_done_q;  /* complete via scsi_eh_flush_done_q */
@@ -706,4 +702,7 @@ struct sas_phy *sas_get_local_phy(struct domain_device *dev);
 
 int sas_request_addr(struct Scsi_Host *shost, u8 *addr);
 
+int sas_notify_port_event(struct asd_sas_phy *phy, enum port_event event);
+int sas_notify_phy_event(struct asd_sas_phy *phy, enum phy_event event);
+
 #endif /* _SASLIB_H_ */
-- 
2.27.0



