Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF355FE262
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 21:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbiJMTGD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 15:06:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbiJMTGA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 15:06:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 430D763D7;
        Thu, 13 Oct 2022 12:05:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7330B8207B;
        Thu, 13 Oct 2022 18:00:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 180E2C433D6;
        Thu, 13 Oct 2022 18:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665684058;
        bh=bOidcKm6QKaIaWqZXsQBrCRpaMrW7PXqT/0Sgh+sGxk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MjEktAbfju8ST3GDa4mG/2vBcepggl7VLHD5fOZZbaHtCGGAeDKsES7EW1bV1Q6I/
         h87Lfj8yHlAXREhXk2dv1gUsxcyvmwYJMVuRKBz2isxYUVpEy3Jl2MJhucb70IaNZh
         9lgjkIixO6vorY7gAzCqGy2vtihc4b9HXOTJCmIQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Arun Easi <aeasi@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.0 12/34] scsi: qla2xxx: Fix response queue handler reading stale packets
Date:   Thu, 13 Oct 2022 19:52:50 +0200
Message-Id: <20221013175146.840895989@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221013175146.507746257@linuxfoundation.org>
References: <20221013175146.507746257@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

commit e4f8a29deb3ba30e414dfb6b09e3ae3bf6dbe74a upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_isr.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3763,7 +3763,8 @@ void qla24xx_process_response_queue(stru
 	struct qla_hw_data *ha = vha->hw;
 	struct purex_entry_24xx *purex_entry;
 	struct purex_item *pure_item;
-	u16 cur_ring_index;
+	u16 rsp_in = 0, cur_ring_index;
+	int is_shadow_hba;
 
 	if (!ha->flags.fw_started)
 		return;
@@ -3773,7 +3774,18 @@ void qla24xx_process_response_queue(stru
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
 
@@ -3887,6 +3899,7 @@ process_err:
 				}
 				pure_item = qla27xx_copy_fpin_pkt(vha,
 							  (void **)&pkt, &rsp);
+				__update_rsp_in(is_shadow_hba, rsp, rsp_in);
 				if (!pure_item)
 					break;
 				qla24xx_queue_purex_item(vha, pure_item,


