Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F378591A9E
	for <lists+stable@lfdr.de>; Sat, 13 Aug 2022 15:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237284AbiHMN3s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Aug 2022 09:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235278AbiHMN3r (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Aug 2022 09:29:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FAE75C9DD
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 06:29:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51D6BB80108
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 13:29:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98974C433C1;
        Sat, 13 Aug 2022 13:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660397384;
        bh=w5/ASIfnPcy6LIfLAHeZ9ofJMWYEwX8Tvgb+8kGhjIY=;
        h=Subject:To:Cc:From:Date:From;
        b=J+G5vgpAAsLC5Zmg8Ckz5JzUdACGuNek1vv696llmV3q675K5OLTHH6gq+9LjUwV4
         44rsTihECprxvlJ6SfVu1k20i8avNGflgPQ2e6rj9nZuJ8YFGXs1iq5ntSYOtAP0Lo
         UmitH/6GvX2hFY87+8T5wv/KXzBdFaYFM2W3UhRc=
Subject: FAILED: patch "[PATCH] scsi: qla2xxx: Fix incorrect display of max frame size" failed to apply to 5.4-stable tree
To:     bhazarika@marvell.com, himanshu.madhani@oracle.com,
        martin.petersen@oracle.com, njavali@marvell.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Aug 2022 15:29:41 +0200
Message-ID: <166039738118613@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From cf3b4fb655796674e605268bd4bfb47a47c8bce6 Mon Sep 17 00:00:00 2001
From: Bikash Hazarika <bhazarika@marvell.com>
Date: Tue, 12 Jul 2022 22:20:37 -0700
Subject: [PATCH] scsi: qla2xxx: Fix incorrect display of max frame size

Replace display field with the correct field.

Link: https://lore.kernel.org/r/20220713052045.10683-3-njavali@marvell.com
Fixes: 8777e4314d39 ("scsi: qla2xxx: Migrate NVME N2N handling into state machine")
Cc: stable@vger.kernel.org
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Bikash Hazarika <bhazarika@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 1bdc7a208fe3..91c8fedc8ffa 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3988,6 +3988,7 @@ struct qla_hw_data {
 	/* SRB cache. */
 #define SRB_MIN_REQ     128
 	mempool_t       *srb_mempool;
+	u8 port_name[WWN_SIZE];
 
 	volatile struct {
 		uint32_t	mbox_int		:1;
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index dff06a3255d6..7ca734337000 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1596,7 +1596,6 @@ qla2x00_hba_attributes(scsi_qla_host_t *vha, void *entries,
 	unsigned int callopt)
 {
 	struct qla_hw_data *ha = vha->hw;
-	struct init_cb_24xx *icb24 = (void *)ha->init_cb;
 	struct new_utsname *p_sysid = utsname();
 	struct ct_fdmi_hba_attr *eiter;
 	uint16_t alen;
@@ -1758,8 +1757,8 @@ qla2x00_hba_attributes(scsi_qla_host_t *vha, void *entries,
 	/* MAX CT Payload Length */
 	eiter = entries + size;
 	eiter->type = cpu_to_be16(FDMI_HBA_MAXIMUM_CT_PAYLOAD_LENGTH);
-	eiter->a.max_ct_len = cpu_to_be32(le16_to_cpu(IS_FWI2_CAPABLE(ha) ?
-		icb24->frame_payload_size : ha->init_cb->frame_payload_size));
+	eiter->a.max_ct_len = cpu_to_be32(ha->frame_payload_size >> 2);
+
 	alen = sizeof(eiter->a.max_ct_len);
 	alen += FDMI_ATTR_TYPELEN(eiter);
 	eiter->len = cpu_to_be16(alen);
@@ -1851,7 +1850,6 @@ qla2x00_port_attributes(scsi_qla_host_t *vha, void *entries,
 	unsigned int callopt)
 {
 	struct qla_hw_data *ha = vha->hw;
-	struct init_cb_24xx *icb24 = (void *)ha->init_cb;
 	struct new_utsname *p_sysid = utsname();
 	char *hostname = p_sysid ?
 		p_sysid->nodename : fc_host_system_hostname(vha->host);
@@ -1903,8 +1901,7 @@ qla2x00_port_attributes(scsi_qla_host_t *vha, void *entries,
 	/* Max frame size. */
 	eiter = entries + size;
 	eiter->type = cpu_to_be16(FDMI_PORT_MAX_FRAME_SIZE);
-	eiter->a.max_frame_size = cpu_to_be32(le16_to_cpu(IS_FWI2_CAPABLE(ha) ?
-		icb24->frame_payload_size : ha->init_cb->frame_payload_size));
+	eiter->a.max_frame_size = cpu_to_be32(ha->frame_payload_size);
 	alen = sizeof(eiter->a.max_frame_size);
 	alen += FDMI_ATTR_TYPELEN(eiter);
 	eiter->len = cpu_to_be16(alen);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index e9bc93395e2f..15fb5ed565c0 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4534,6 +4534,8 @@ qla2x00_init_rings(scsi_qla_host_t *vha)
 			 BIT_6) != 0;
 		ql_dbg(ql_dbg_init, vha, 0x00bc, "FA-WWPN Support: %s.\n",
 		    (ha->flags.fawwpn_enabled) ? "enabled" : "disabled");
+		/* Init_cb will be reused for other command(s).  Save a backup copy of port_name */
+		memcpy(ha->port_name, ha->init_cb->port_name, WWN_SIZE);
 	}
 
 	/* ELS pass through payload is limit by frame size. */
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 24f9a3b116d8..4fa24d318f14 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1354,9 +1354,7 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 			if (!vha->vp_idx) {
 				if (ha->flags.fawwpn_enabled &&
 				    (ha->current_topology == ISP_CFG_F)) {
-					void *wwpn = ha->init_cb->port_name;
-
-					memcpy(vha->port_name, wwpn, WWN_SIZE);
+					memcpy(vha->port_name, ha->port_name, WWN_SIZE);
 					fc_host_port_name(vha->host) =
 					    wwn_to_u64(vha->port_name);
 					ql_dbg(ql_dbg_init + ql_dbg_verbose,

