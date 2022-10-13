Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E97875FDA4D
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 15:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbiJMNSu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 09:18:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbiJMNSs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 09:18:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C5F12FF80
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 06:18:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66CD1609D1
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 13:18:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 793D3C433D6;
        Thu, 13 Oct 2022 13:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665667117;
        bh=3vuw/eh5y+CCa76jLIAwL0cvmzw2rj+d6/xNvLoWwk8=;
        h=Subject:To:Cc:From:Date:From;
        b=EV2LqYzP/ykb1vgwkEq5VEU3C3LCDE16QMTw2xeMQ/VBMEqLs4N6wHumQwmRpqvKL
         DDVL9PUPYh4OeAtqd2uM0aRmwKR9BqEQGCJgFgtIsq4JdTCRX1vvPppEw5KVGHSmZH
         Ujd+PrdXlj29gBc2wkOjNgixWQwXmq/3tIS2KgRk=
Subject: FAILED: patch "[PATCH] scsi: qla2xxx: Fix response queue handler reading stale" failed to apply to 5.15-stable tree
To:     aeasi@marvell.com, himanshu.madhani@oracle.com,
        martin.petersen@oracle.com, njavali@marvell.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 13 Oct 2022 15:14:03 +0200
Message-ID: <1665666843195214@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.


thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e4f8a29deb3ba30e414dfb6b09e3ae3bf6dbe74a Mon Sep 17 00:00:00 2001
From: Arun Easi <aeasi@marvell.com>
Date: Fri, 26 Aug 2022 03:25:54 -0700
Subject: [PATCH] scsi: qla2xxx: Fix response queue handler reading stale
 packets

On some platforms, the current logic of relying on finding new packet
solely based on signature pattern can lead to driver reading stale
packets. Though this is a bug in those platforms, reduce such exposures by
limiting reading packets until the IN pointer.

Link: https://lore.kernel.org/r/20220826102559.17474-3-njavali@marvell.com
Cc: stable@vger.kernel.org
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index ede76357ccb6..e19fde304e5c 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3763,7 +3763,8 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 	struct qla_hw_data *ha = vha->hw;
 	struct purex_entry_24xx *purex_entry;
 	struct purex_item *pure_item;
-	u16 cur_ring_index;
+	u16 rsp_in = 0, cur_ring_index;
+	int is_shadow_hba;
 
 	if (!ha->flags.fw_started)
 		return;
@@ -3773,7 +3774,18 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 		qla_cpu_update(rsp->qpair, smp_processor_id());
 	}
 
-	while (rsp->ring_ptr->signature != RESPONSE_PROCESSED) {
+#define __update_rsp_in(_is_shadow_hba, _rsp, _rsp_in)			\
+	do {								\
+		_rsp_in = _is_shadow_hba ? *(_rsp)->in_ptr :		\
+				rd_reg_dword_relaxed((_rsp)->rsp_q_in);	\
+	} while (0)
+
+	is_shadow_hba = IS_SHADOW_REG_CAPABLE(ha);
+
+	__update_rsp_in(is_shadow_hba, rsp, rsp_in);
+
+	while (rsp->ring_index != rsp_in &&
+		       rsp->ring_ptr->signature != RESPONSE_PROCESSED) {
 		pkt = (struct sts_entry_24xx *)rsp->ring_ptr;
 		cur_ring_index = rsp->ring_index;
 
@@ -3887,6 +3899,7 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 				}
 				pure_item = qla27xx_copy_fpin_pkt(vha,
 							  (void **)&pkt, &rsp);
+				__update_rsp_in(is_shadow_hba, rsp, rsp_in);
 				if (!pure_item)
 					break;
 				qla24xx_queue_purex_item(vha, pure_item,

