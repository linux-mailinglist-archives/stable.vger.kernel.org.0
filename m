Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0A56451E38
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:32:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345812AbhKPAf2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:35:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:45388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344682AbhKOTZN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D0F2636AE;
        Mon, 15 Nov 2021 19:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002941;
        bh=bPjtF1Os32zaf7B71YsT+UfoeHjqh9+nqJcdbIVyoaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EaQetJOTrbaSbffL4HYbLINCol0l45o23RqEJg9ad7A2+AEph59tcanIZlBW/8pzH
         jKGJ7PB4lXkpZMC4aHrQgwFmCbl+ch8ikkuZnBREOLl0/q3EniAfwcSFOWfVyZDP9i
         VUXyUxzStldI8ajvz1ritlTj6OXN0xbo+4o79UZU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 753/917] scsi: qla2xxx: edif: Increase ELS payload
Date:   Mon, 15 Nov 2021 18:04:08 +0100
Message-Id: <20211115165454.445750352@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

[ Upstream commit 0f6d600a26e89d31d8381b324fc970f72579a126 ]

Currently, firmware limits ELS payload to FC frame size/2112.  This patch
adjusts memory buffer size to be able to handle max ELS payload.

Link: https://lore.kernel.org/r/20211026115412.27691-11-njavali@marvell.com
Fixes: 84318a9f01ce ("scsi: qla2xxx: edif: Add send, receive, and accept for auth_els")
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_edif.c     | 2 +-
 drivers/scsi/qla2xxx/qla_edif.h     | 3 ++-
 drivers/scsi/qla2xxx/qla_edif_bsg.h | 2 +-
 drivers/scsi/qla2xxx/qla_init.c     | 4 ++++
 drivers/scsi/qla2xxx/qla_os.c       | 2 +-
 5 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index 3931bae3222b3..98235df803aef 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -2384,7 +2384,7 @@ void qla24xx_auth_els(scsi_qla_host_t *vha, void **pkt, struct rsp_que **rsp)
 		return;
 	}
 
-	if (totlen > MAX_PAYLOAD) {
+	if (totlen > ELS_MAX_PAYLOAD) {
 		ql_dbg(ql_dbg_edif, vha, 0x0910d,
 		    "%s WARNING: verbose ELS frame received (totlen=%x)\n",
 		    __func__, totlen);
diff --git a/drivers/scsi/qla2xxx/qla_edif.h b/drivers/scsi/qla2xxx/qla_edif.h
index 9e8f28d0caa1b..45cf87e337780 100644
--- a/drivers/scsi/qla2xxx/qla_edif.h
+++ b/drivers/scsi/qla2xxx/qla_edif.h
@@ -93,7 +93,6 @@ struct sa_update_28xx {
 };
 
 #define        NUM_ENTRIES     256
-#define        MAX_PAYLOAD     1024
 #define        PUR_GET         1
 
 struct dinfo {
@@ -128,6 +127,8 @@ struct enode {
 	} u;
 };
 
+#define RX_ELS_SIZE (roundup(sizeof(struct enode) + ELS_MAX_PAYLOAD, SMP_CACHE_BYTES))
+
 #define EDIF_SESSION_DOWN(_s) \
 	(qla_ini_mode_enabled(_s->vha) && (_s->disc_state == DSC_DELETE_PEND || \
 	 _s->disc_state == DSC_DELETED || \
diff --git a/drivers/scsi/qla2xxx/qla_edif_bsg.h b/drivers/scsi/qla2xxx/qla_edif_bsg.h
index 58b718d35d19a..53026d82ebffe 100644
--- a/drivers/scsi/qla2xxx/qla_edif_bsg.h
+++ b/drivers/scsi/qla2xxx/qla_edif_bsg.h
@@ -8,7 +8,7 @@
 #define __QLA_EDIF_BSG_H
 
 /* BSG Vendor specific commands */
-#define	ELS_MAX_PAYLOAD		1024
+#define	ELS_MAX_PAYLOAD		2112
 #ifndef	WWN_SIZE
 #define WWN_SIZE		8
 #endif
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 6da4419bcec16..847a6e5d9cb07 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4467,6 +4467,10 @@ qla2x00_init_rings(scsi_qla_host_t *vha)
 		    (ha->flags.fawwpn_enabled) ? "enabled" : "disabled");
 	}
 
+	/* ELS pass through payload is limit by frame size. */
+	if (ha->flags.edif_enabled)
+		mid_init_cb->init_cb.frame_payload_size = cpu_to_le16(ELS_MAX_PAYLOAD);
+
 	rval = qla2x00_init_firmware(vha, ha->init_cb_size);
 next_check:
 	if (rval) {
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index b5346d9066dc6..8d87cfae9c598 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4337,7 +4337,7 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 
 	/* allocate the purex dma pool */
 	ha->purex_dma_pool = dma_pool_create(name, &ha->pdev->dev,
-	    MAX_PAYLOAD, 8, 0);
+	    ELS_MAX_PAYLOAD, 8, 0);
 
 	if (!ha->purex_dma_pool) {
 		ql_dbg_pci(ql_dbg_init, ha->pdev, 0x011b,
-- 
2.33.0



