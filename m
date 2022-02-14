Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6494B4C61
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348949AbiBNKkk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:40:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348912AbiBNKkH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:40:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0ECD41318;
        Mon, 14 Feb 2022 02:04:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF9B0B80DCA;
        Mon, 14 Feb 2022 10:03:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9372C340EF;
        Mon, 14 Feb 2022 10:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644833015;
        bh=QUkw2cL9AMbwzEWly0EXBWLsADd+Rau9WRrGJKiibKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XAhEvelr+6eJEMxi8JiMCRmfojz3cGjihhrj7VDVdOEaYyQk5xxAAWxqyf21TkrGT
         bkoDEiUjQPN51xsi4ISAf8XXxoVSBpkWACfT4z4Zn2aH1j/8Sen/aLtzmzXODf/YWu
         8XCajxR9HLM0A90kkjS4cnDfsCDXhI3nf/dUWeKM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Ewan D. Milne" <emilne@redhat.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.16 196/203] scsi: lpfc: Remove NVMe support if kernel has NVME_FC disabled
Date:   Mon, 14 Feb 2022 10:27:20 +0100
Message-Id: <20220214092517.044600427@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
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
@@ -1165,6 +1165,16 @@ struct lpfc_hba {
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
@@ -1186,9 +1196,6 @@ struct lpfc_hba {
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


