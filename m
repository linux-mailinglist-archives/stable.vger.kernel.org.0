Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C82356FCBB
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233431AbiGKJrf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:47:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233585AbiGKJq5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:46:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D6C85B78C;
        Mon, 11 Jul 2022 02:22:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9E77FB80D2C;
        Mon, 11 Jul 2022 09:22:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ACFAC34115;
        Mon, 11 Jul 2022 09:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531374;
        bh=1TdSlce/DgVKTiZFs1xju2C/eht7mNg9T9nlCWRVF2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tscylTCJeHN199kxL4zLEiZ9ZnfoVfd2U0q8zHFpKAjAOzMxEvszO4EmQxxEVEZCL
         4TSBKvXsvzXyNzZSzS6I8Y48sU45Kqog/6c8Jw4INyt9SoayfRqKZJuQNtBWQ4Ui9u
         lchFF2siYuFcUFe1G3vLNkYZH/o2tXfDiCfQXng8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 081/230] scsi: qla2xxx: edif: Replace list_for_each_safe with list_for_each_entry_safe
Date:   Mon, 11 Jul 2022 11:05:37 +0200
Message-Id: <20220711090606.373547731@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

[ Upstream commit 8062b742d3bd336ca10ab5a1db1629d33700f9c6 ]

This patch is per review comment by Hannes Reinecke from previous
submission to replace list_for_each_safe with list_for_each_entry_safe.

Link: https://lore.kernel.org/r/20211026115412.27691-8-njavali@marvell.com
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_edif.c | 39 ++++++++-------------------------
 drivers/scsi/qla2xxx/qla_edif.h |  1 -
 drivers/scsi/qla2xxx/qla_os.c   |  8 +++----
 3 files changed, 13 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index a00fe88c6021..e40b9cc38214 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -1684,41 +1684,25 @@ static struct enode *
 qla_enode_find(scsi_qla_host_t *vha, uint32_t ntype, uint32_t p1, uint32_t p2)
 {
 	struct enode		*node_rtn = NULL;
-	struct enode		*list_node = NULL;
+	struct enode		*list_node, *q;
 	unsigned long		flags;
-	struct list_head	*pos, *q;
 	uint32_t		sid;
-	uint32_t		rw_flag;
 	struct purexevent	*purex;
 
 	/* secure the list from moving under us */
 	spin_lock_irqsave(&vha->pur_cinfo.pur_lock, flags);
 
-	list_for_each_safe(pos, q, &vha->pur_cinfo.head) {
-		list_node = list_entry(pos, struct enode, list);
+	list_for_each_entry_safe(list_node, q, &vha->pur_cinfo.head, list) {
 
 		/* node type determines what p1 and p2 are */
 		purex = &list_node->u.purexinfo;
 		sid = p1;
-		rw_flag = p2;
 
 		if (purex->pur_info.pur_sid.b24 == sid) {
-			if (purex->pur_info.pur_pend == 1 &&
-			    rw_flag == PUR_GET) {
-				/*
-				 * if the receive is in progress
-				 * and its a read/get then can't
-				 * transfer yet
-				 */
-				ql_dbg(ql_dbg_edif, vha, 0x9106,
-				    "%s purex xfer in progress for sid=%x\n",
-				    __func__, sid);
-			} else {
-				/* found it and its complete */
-				node_rtn = list_node;
-				list_del(pos);
-				break;
-			}
+			/* found it and its complete */
+			node_rtn = list_node;
+			list_del(&list_node->list);
+			break;
 		}
 	}
 
@@ -2428,7 +2412,6 @@ void qla24xx_auth_els(scsi_qla_host_t *vha, void **pkt, struct rsp_que **rsp)
 
 	purex = &ptr->u.purexinfo;
 	purex->pur_info.pur_sid = a.did;
-	purex->pur_info.pur_pend = 0;
 	purex->pur_info.pur_bytes_rcvd = totlen;
 	purex->pur_info.pur_rx_xchg_address = le32_to_cpu(p->rx_xchg_addr);
 	purex->pur_info.pur_nphdl = le16_to_cpu(p->nport_handle);
@@ -3180,18 +3163,14 @@ static uint16_t qla_edif_sadb_get_sa_index(fc_port_t *fcport,
 /* release any sadb entries -- only done at teardown */
 void qla_edif_sadb_release(struct qla_hw_data *ha)
 {
-	struct list_head *pos;
-	struct list_head *tmp;
-	struct edif_sa_index_entry *entry;
+	struct edif_sa_index_entry *entry, *tmp;
 
-	list_for_each_safe(pos, tmp, &ha->sadb_rx_index_list) {
-		entry = list_entry(pos, struct edif_sa_index_entry, next);
+	list_for_each_entry_safe(entry, tmp, &ha->sadb_rx_index_list, next) {
 		list_del(&entry->next);
 		kfree(entry);
 	}
 
-	list_for_each_safe(pos, tmp, &ha->sadb_tx_index_list) {
-		entry = list_entry(pos, struct edif_sa_index_entry, next);
+	list_for_each_entry_safe(entry, tmp, &ha->sadb_tx_index_list, next) {
 		list_del(&entry->next);
 		kfree(entry);
 	}
diff --git a/drivers/scsi/qla2xxx/qla_edif.h b/drivers/scsi/qla2xxx/qla_edif.h
index 45cf87e33778..32800bfb32a3 100644
--- a/drivers/scsi/qla2xxx/qla_edif.h
+++ b/drivers/scsi/qla2xxx/qla_edif.h
@@ -101,7 +101,6 @@ struct dinfo {
 };
 
 struct pur_ninfo {
-	unsigned int	pur_pend:1;
 	port_id_t       pur_sid;
 	port_id_t	pur_did;
 	uint8_t		vp_idx;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 12958aea893f..c7ab8a8be24c 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3886,13 +3886,13 @@ qla2x00_remove_one(struct pci_dev *pdev)
 static inline void
 qla24xx_free_purex_list(struct purex_list *list)
 {
-	struct list_head *item, *next;
+	struct purex_item *item, *next;
 	ulong flags;
 
 	spin_lock_irqsave(&list->lock, flags);
-	list_for_each_safe(item, next, &list->head) {
-		list_del(item);
-		kfree(list_entry(item, struct purex_item, list));
+	list_for_each_entry_safe(item, next, &list->head, list) {
+		list_del(&item->list);
+		kfree(item);
 	}
 	spin_unlock_irqrestore(&list->lock, flags);
 }
-- 
2.35.1



