Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F06DC599F60
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350619AbiHSPyr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 11:54:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350442AbiHSPyB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 11:54:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7902A103C66;
        Fri, 19 Aug 2022 08:49:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC876B82813;
        Fri, 19 Aug 2022 15:49:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24CE2C433D6;
        Fri, 19 Aug 2022 15:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924167;
        bh=wXCHWPpTDUvlnRJMSnn2hpN/p/CupuSzUfQcIO7JB4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QBU+Mwwu/kLXtw3viiTUGKJe0NDoS+MflT5WRrzsNi7kGgN9oo6R2CNrcbrw7BQhl
         QMRBhsED9oe+GxvvRTU/VPmscxnFYQ4XcWtv3f7f+6dYRR24y69TYts3ruxCYtm6gu
         HOZEWLNjwQSPQu5ea2FuaZbGjZshdsxrdG1Hg84Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Bikash Hazarika <bhazarika@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 051/545] scsi: qla2xxx: Fix incorrect display of max frame size
Date:   Fri, 19 Aug 2022 17:37:01 +0200
Message-Id: <20220819153831.515243835@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bikash Hazarika <bhazarika@marvell.com>

commit cf3b4fb655796674e605268bd4bfb47a47c8bce6 upstream.

Replace display field with the correct field.

Link: https://lore.kernel.org/r/20220713052045.10683-3-njavali@marvell.com
Fixes: 8777e4314d39 ("scsi: qla2xxx: Migrate NVME N2N handling into state machine")
Cc: stable@vger.kernel.org
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Bikash Hazarika <bhazarika@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_def.h  |    1 +
 drivers/scsi/qla2xxx/qla_gs.c   |    9 +++------
 drivers/scsi/qla2xxx/qla_init.c |    2 ++
 drivers/scsi/qla2xxx/qla_isr.c  |    4 +---
 4 files changed, 7 insertions(+), 9 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3857,6 +3857,7 @@ struct qla_hw_data {
 	/* SRB cache. */
 #define SRB_MIN_REQ     128
 	mempool_t       *srb_mempool;
+	u8 port_name[WWN_SIZE];
 
 	volatile struct {
 		uint32_t	mbox_int		:1;
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1594,7 +1594,6 @@ qla2x00_hba_attributes(scsi_qla_host_t *
 	unsigned int callopt)
 {
 	struct qla_hw_data *ha = vha->hw;
-	struct init_cb_24xx *icb24 = (void *)ha->init_cb;
 	struct new_utsname *p_sysid = utsname();
 	struct ct_fdmi_hba_attr *eiter;
 	uint16_t alen;
@@ -1756,8 +1755,8 @@ qla2x00_hba_attributes(scsi_qla_host_t *
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
@@ -1849,7 +1848,6 @@ qla2x00_port_attributes(scsi_qla_host_t
 	unsigned int callopt)
 {
 	struct qla_hw_data *ha = vha->hw;
-	struct init_cb_24xx *icb24 = (void *)ha->init_cb;
 	struct new_utsname *p_sysid = utsname();
 	char *hostname = p_sysid ?
 		p_sysid->nodename : fc_host_system_hostname(vha->host);
@@ -1901,8 +1899,7 @@ qla2x00_port_attributes(scsi_qla_host_t
 	/* Max frame size. */
 	eiter = entries + size;
 	eiter->type = cpu_to_be16(FDMI_PORT_MAX_FRAME_SIZE);
-	eiter->a.max_frame_size = cpu_to_be32(le16_to_cpu(IS_FWI2_CAPABLE(ha) ?
-		icb24->frame_payload_size : ha->init_cb->frame_payload_size));
+	eiter->a.max_frame_size = cpu_to_be32(ha->frame_payload_size);
 	alen = sizeof(eiter->a.max_frame_size);
 	alen += FDMI_ATTR_TYPELEN(eiter);
 	eiter->len = cpu_to_be16(alen);
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4328,6 +4328,8 @@ qla2x00_init_rings(scsi_qla_host_t *vha)
 			 BIT_6) != 0;
 		ql_dbg(ql_dbg_init, vha, 0x00bc, "FA-WWPN Support: %s.\n",
 		    (ha->flags.fawwpn_enabled) ? "enabled" : "disabled");
+		/* Init_cb will be reused for other command(s).  Save a backup copy of port_name */
+		memcpy(ha->port_name, ha->init_cb->port_name, WWN_SIZE);
 	}
 
 	rval = qla2x00_init_firmware(vha, ha->init_cb_size);
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1202,9 +1202,7 @@ skip_rio:
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


