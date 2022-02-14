Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B44144B4AEF
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346318AbiBNKSJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:18:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346826AbiBNKQD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:16:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B80E79C6B;
        Mon, 14 Feb 2022 01:53:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0EF6261303;
        Mon, 14 Feb 2022 09:53:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8F8CC340E9;
        Mon, 14 Feb 2022 09:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832398;
        bh=5WK0kK9roEQOPrKBdj9vTLAWvwtzCxIVmtlFHoWVxbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rD5goorXfdFEOjL8U92py9VTsCBXUvqrrz6Kuz7o7aCbDGz2QntKM6SQ/os7Bf+Nm
         gM4ULMUkRQOguijRtaG0iIkDMlUvMGFa/ZAzvqAo86k1f5eF3gtH/IFSn/TWcaPPPu
         wlmbZa5yNmxx9VYWOjT8r2T47ifb22tMgqjOFERg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Ewan D. Milne" <emilne@redhat.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 167/172] scsi: lpfc: Remove NVMe support if kernel has NVME_FC disabled
Date:   Mon, 14 Feb 2022 10:27:05 +0100
Message-Id: <20220214092512.158990748@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

commit c80b27cfd93ba9f5161383f798414609e84729f3 upstream.

The driver is initiating NVMe PRLIs to determine device NVMe support.  This
should not be occurring if CONFIG_NVME_FC support is disabled.

Correct this by changing the default value for FC4 support. Currently it
defaults to FCP and NVMe. With change, when NVME_FC support is not enabled
in the kernel, the default value is just FCP.

Link: https://lore.kernel.org/r/20220207180516.73052-1-jsmart2021@gmail.com
Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/lpfc/lpfc.h      |   13 ++++++++++---
 drivers/scsi/lpfc/lpfc_attr.c |    4 ++--
 2 files changed, 12 insertions(+), 5 deletions(-)

--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -1163,6 +1163,16 @@ struct lpfc_hba {
 	uint32_t cfg_hostmem_hgp;
 	uint32_t cfg_log_verbose;
 	uint32_t cfg_enable_fc4_type;
+#define LPFC_ENABLE_FCP  1
+#define LPFC_ENABLE_NVME 2
+#define LPFC_ENABLE_BOTH 3
+#if (IS_ENABLED(CONFIG_NVME_FC))
+#define LPFC_MAX_ENBL_FC4_TYPE LPFC_ENABLE_BOTH
+#define LPFC_DEF_ENBL_FC4_TYPE LPFC_ENABLE_BOTH
+#else
+#define LPFC_MAX_ENBL_FC4_TYPE LPFC_ENABLE_FCP
+#define LPFC_DEF_ENBL_FC4_TYPE LPFC_ENABLE_FCP
+#endif
 	uint32_t cfg_aer_support;
 	uint32_t cfg_sriov_nr_virtfn;
 	uint32_t cfg_request_firmware_upgrade;
@@ -1184,9 +1194,6 @@ struct lpfc_hba {
 	uint32_t cfg_ras_fwlog_func;
 	uint32_t cfg_enable_bbcr;	/* Enable BB Credit Recovery */
 	uint32_t cfg_enable_dpp;	/* Enable Direct Packet Push */
-#define LPFC_ENABLE_FCP  1
-#define LPFC_ENABLE_NVME 2
-#define LPFC_ENABLE_BOTH 3
 	uint32_t cfg_enable_pbde;
 	uint32_t cfg_enable_mi;
 	struct nvmet_fc_target_port *targetport;
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -3978,8 +3978,8 @@ LPFC_ATTR_R(nvmet_mrq_post,
  *                    3 - register both FCP and NVME
  * Supported values are [1,3]. Default value is 3
  */
-LPFC_ATTR_R(enable_fc4_type, LPFC_ENABLE_BOTH,
-	    LPFC_ENABLE_FCP, LPFC_ENABLE_BOTH,
+LPFC_ATTR_R(enable_fc4_type, LPFC_DEF_ENBL_FC4_TYPE,
+	    LPFC_ENABLE_FCP, LPFC_MAX_ENBL_FC4_TYPE,
 	    "Enable FC4 Protocol support - FCP / NVME");
 
 /*


