Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C11C36AEEB1
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231328AbjCGSOt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:14:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232468AbjCGSOY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:14:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A2B6A8C7E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:09:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D37D26152F
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:09:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C889AC433D2;
        Tue,  7 Mar 2023 18:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212593;
        bh=YgMoYX2vg0M1wKXsf0yf/X4srUikNM2YGY3tCbls4gQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oyW8gXwefuUxyw4OU9Cq5AYtjFQTLhYvdcvbI54Exlp7GaAscS60XLTTUMKAk99MB
         9B9CeY7NjZ8j2uzgPZ4E80J4Q0ooebU0+B7u2rEHT7kIiyqGMAbJ1/umwWOCOgeZMK
         6QHSyfIQgVBLckFz1X2U3gzC0vndZ2IZRRItgsZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Masahiro Yamada <masahiroy@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 233/885] crypto: octeontx2 - Fix objects shared between several modules
Date:   Tue,  7 Mar 2023 17:52:47 +0100
Message-Id: <20230307170012.142685515@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Lobakin <alobakin@pm.me>

[ Upstream commit 72bc4e71dbeedee0a446bcbc37c9bb25449072b7 ]

cn10k_cpt.o, otx2_cptlf.o and otx2_cpt_mbox_common.o are linked
into both rvu_cptpf and rvu_cptvf modules:

> scripts/Makefile.build:252: ./drivers/crypto/marvell/octeontx2/Makefile:
> cn10k_cpt.o is added to multiple modules: rvu_cptpf rvu_cptvf
> scripts/Makefile.build:252: ./drivers/crypto/marvell/octeontx2/Makefile:
> otx2_cptlf.o is added to multiple modules: rvu_cptpf rvu_cptvf
> scripts/Makefile.build:252: ./drivers/crypto/marvell/octeontx2/Makefile:
> otx2_cpt_mbox_common.o is added to multiple modules: rvu_cptpf rvu_cptvf

Despite they're build under the same Kconfig option
(CONFIG_CRYPTO_DEV_OCTEONTX2_CPT), it's better do link the common
code into a standalone module and export the shared functions. Under
certain circumstances, this can lead to the same situation as fixed
by commit 637a642f5ca5 ("zstd: Fixing mixed module-builtin objects").
Plus, those three common object files are relatively big to duplicate
them several times.

Introduce the new module, rvu_cptcommon, to provide the common
functions to both modules.

Fixes: 19d8e8c7be15 ("crypto: octeontx2 - add virtual function driver support")
Suggested-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
Reviewed-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/marvell/octeontx2/Makefile          | 11 +++++------
 drivers/crypto/marvell/octeontx2/cn10k_cpt.c       |  9 +++++++--
 drivers/crypto/marvell/octeontx2/cn10k_cpt.h       |  2 --
 drivers/crypto/marvell/octeontx2/otx2_cpt_common.h |  2 --
 .../marvell/octeontx2/otx2_cpt_mbox_common.c       | 14 ++++++++++++--
 drivers/crypto/marvell/octeontx2/otx2_cptlf.c      | 11 +++++++++++
 drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c |  2 ++
 drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c |  2 ++
 8 files changed, 39 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/Makefile b/drivers/crypto/marvell/octeontx2/Makefile
index 965297e969546..f0f2942c1d278 100644
--- a/drivers/crypto/marvell/octeontx2/Makefile
+++ b/drivers/crypto/marvell/octeontx2/Makefile
@@ -1,11 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0-only
-obj-$(CONFIG_CRYPTO_DEV_OCTEONTX2_CPT) += rvu_cptpf.o rvu_cptvf.o
+obj-$(CONFIG_CRYPTO_DEV_OCTEONTX2_CPT) += rvu_cptcommon.o rvu_cptpf.o rvu_cptvf.o
 
+rvu_cptcommon-objs := cn10k_cpt.o otx2_cptlf.o otx2_cpt_mbox_common.o
 rvu_cptpf-objs := otx2_cptpf_main.o otx2_cptpf_mbox.o \
-		  otx2_cpt_mbox_common.o otx2_cptpf_ucode.o otx2_cptlf.o \
-		  cn10k_cpt.o otx2_cpt_devlink.o
-rvu_cptvf-objs := otx2_cptvf_main.o otx2_cptvf_mbox.o otx2_cptlf.o \
-		  otx2_cpt_mbox_common.o otx2_cptvf_reqmgr.o \
-		  otx2_cptvf_algs.o cn10k_cpt.o
+		  otx2_cptpf_ucode.o otx2_cpt_devlink.o
+rvu_cptvf-objs := otx2_cptvf_main.o otx2_cptvf_mbox.o \
+		  otx2_cptvf_reqmgr.o otx2_cptvf_algs.o
 
 ccflags-y += -I$(srctree)/drivers/net/ethernet/marvell/octeontx2/af
diff --git a/drivers/crypto/marvell/octeontx2/cn10k_cpt.c b/drivers/crypto/marvell/octeontx2/cn10k_cpt.c
index 1499ef75b5c22..93d22b3289919 100644
--- a/drivers/crypto/marvell/octeontx2/cn10k_cpt.c
+++ b/drivers/crypto/marvell/octeontx2/cn10k_cpt.c
@@ -7,6 +7,9 @@
 #include "otx2_cptlf.h"
 #include "cn10k_cpt.h"
 
+static void cn10k_cpt_send_cmd(union otx2_cpt_inst_s *cptinst, u32 insts_num,
+			       struct otx2_cptlf_info *lf);
+
 static struct cpt_hw_ops otx2_hw_ops = {
 	.send_cmd = otx2_cpt_send_cmd,
 	.cpt_get_compcode = otx2_cpt_get_compcode,
@@ -19,8 +22,8 @@ static struct cpt_hw_ops cn10k_hw_ops = {
 	.cpt_get_uc_compcode = cn10k_cpt_get_uc_compcode,
 };
 
-void cn10k_cpt_send_cmd(union otx2_cpt_inst_s *cptinst, u32 insts_num,
-			struct otx2_cptlf_info *lf)
+static void cn10k_cpt_send_cmd(union otx2_cpt_inst_s *cptinst, u32 insts_num,
+			       struct otx2_cptlf_info *lf)
 {
 	void __iomem *lmtline = lf->lmtline;
 	u64 val = (lf->slot & 0x7FF);
@@ -68,6 +71,7 @@ int cn10k_cptpf_lmtst_init(struct otx2_cptpf_dev *cptpf)
 
 	return 0;
 }
+EXPORT_SYMBOL_NS_GPL(cn10k_cptpf_lmtst_init, CRYPTO_DEV_OCTEONTX2_CPT);
 
 int cn10k_cptvf_lmtst_init(struct otx2_cptvf_dev *cptvf)
 {
@@ -91,3 +95,4 @@ int cn10k_cptvf_lmtst_init(struct otx2_cptvf_dev *cptvf)
 
 	return 0;
 }
+EXPORT_SYMBOL_NS_GPL(cn10k_cptvf_lmtst_init, CRYPTO_DEV_OCTEONTX2_CPT);
diff --git a/drivers/crypto/marvell/octeontx2/cn10k_cpt.h b/drivers/crypto/marvell/octeontx2/cn10k_cpt.h
index c091392b47e0f..aaefc7e38e060 100644
--- a/drivers/crypto/marvell/octeontx2/cn10k_cpt.h
+++ b/drivers/crypto/marvell/octeontx2/cn10k_cpt.h
@@ -28,8 +28,6 @@ static inline u8 otx2_cpt_get_uc_compcode(union otx2_cpt_res_s *result)
 	return ((struct cn9k_cpt_res_s *)result)->uc_compcode;
 }
 
-void cn10k_cpt_send_cmd(union otx2_cpt_inst_s *cptinst, u32 insts_num,
-			struct otx2_cptlf_info *lf);
 int cn10k_cptpf_lmtst_init(struct otx2_cptpf_dev *cptpf);
 int cn10k_cptvf_lmtst_init(struct otx2_cptvf_dev *cptvf);
 
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
index 5012b7e669f07..6019066a6451a 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
@@ -145,8 +145,6 @@ int otx2_cpt_send_mbox_msg(struct otx2_mbox *mbox, struct pci_dev *pdev);
 
 int otx2_cpt_send_af_reg_requests(struct otx2_mbox *mbox,
 				  struct pci_dev *pdev);
-int otx2_cpt_add_read_af_reg(struct otx2_mbox *mbox, struct pci_dev *pdev,
-			     u64 reg, u64 *val, int blkaddr);
 int otx2_cpt_add_write_af_reg(struct otx2_mbox *mbox, struct pci_dev *pdev,
 			      u64 reg, u64 val, int blkaddr);
 int otx2_cpt_read_af_reg(struct otx2_mbox *mbox, struct pci_dev *pdev,
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_mbox_common.c b/drivers/crypto/marvell/octeontx2/otx2_cpt_mbox_common.c
index a317319696eff..115997475beb3 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cpt_mbox_common.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_mbox_common.c
@@ -19,6 +19,7 @@ int otx2_cpt_send_mbox_msg(struct otx2_mbox *mbox, struct pci_dev *pdev)
 	}
 	return ret;
 }
+EXPORT_SYMBOL_NS_GPL(otx2_cpt_send_mbox_msg, CRYPTO_DEV_OCTEONTX2_CPT);
 
 int otx2_cpt_send_ready_msg(struct otx2_mbox *mbox, struct pci_dev *pdev)
 {
@@ -36,14 +37,17 @@ int otx2_cpt_send_ready_msg(struct otx2_mbox *mbox, struct pci_dev *pdev)
 
 	return otx2_cpt_send_mbox_msg(mbox, pdev);
 }
+EXPORT_SYMBOL_NS_GPL(otx2_cpt_send_ready_msg, CRYPTO_DEV_OCTEONTX2_CPT);
 
 int otx2_cpt_send_af_reg_requests(struct otx2_mbox *mbox, struct pci_dev *pdev)
 {
 	return otx2_cpt_send_mbox_msg(mbox, pdev);
 }
+EXPORT_SYMBOL_NS_GPL(otx2_cpt_send_af_reg_requests, CRYPTO_DEV_OCTEONTX2_CPT);
 
-int otx2_cpt_add_read_af_reg(struct otx2_mbox *mbox, struct pci_dev *pdev,
-			     u64 reg, u64 *val, int blkaddr)
+static int otx2_cpt_add_read_af_reg(struct otx2_mbox *mbox,
+				    struct pci_dev *pdev, u64 reg,
+				    u64 *val, int blkaddr)
 {
 	struct cpt_rd_wr_reg_msg *reg_msg;
 
@@ -91,6 +95,7 @@ int otx2_cpt_add_write_af_reg(struct otx2_mbox *mbox, struct pci_dev *pdev,
 
 	return 0;
 }
+EXPORT_SYMBOL_NS_GPL(otx2_cpt_add_write_af_reg, CRYPTO_DEV_OCTEONTX2_CPT);
 
 int otx2_cpt_read_af_reg(struct otx2_mbox *mbox, struct pci_dev *pdev,
 			 u64 reg, u64 *val, int blkaddr)
@@ -103,6 +108,7 @@ int otx2_cpt_read_af_reg(struct otx2_mbox *mbox, struct pci_dev *pdev,
 
 	return otx2_cpt_send_mbox_msg(mbox, pdev);
 }
+EXPORT_SYMBOL_NS_GPL(otx2_cpt_read_af_reg, CRYPTO_DEV_OCTEONTX2_CPT);
 
 int otx2_cpt_write_af_reg(struct otx2_mbox *mbox, struct pci_dev *pdev,
 			  u64 reg, u64 val, int blkaddr)
@@ -115,6 +121,7 @@ int otx2_cpt_write_af_reg(struct otx2_mbox *mbox, struct pci_dev *pdev,
 
 	return otx2_cpt_send_mbox_msg(mbox, pdev);
 }
+EXPORT_SYMBOL_NS_GPL(otx2_cpt_write_af_reg, CRYPTO_DEV_OCTEONTX2_CPT);
 
 int otx2_cpt_attach_rscrs_msg(struct otx2_cptlfs_info *lfs)
 {
@@ -170,6 +177,7 @@ int otx2_cpt_detach_rsrcs_msg(struct otx2_cptlfs_info *lfs)
 
 	return ret;
 }
+EXPORT_SYMBOL_NS_GPL(otx2_cpt_detach_rsrcs_msg, CRYPTO_DEV_OCTEONTX2_CPT);
 
 int otx2_cpt_msix_offset_msg(struct otx2_cptlfs_info *lfs)
 {
@@ -202,6 +210,7 @@ int otx2_cpt_msix_offset_msg(struct otx2_cptlfs_info *lfs)
 	}
 	return ret;
 }
+EXPORT_SYMBOL_NS_GPL(otx2_cpt_msix_offset_msg, CRYPTO_DEV_OCTEONTX2_CPT);
 
 int otx2_cpt_sync_mbox_msg(struct otx2_mbox *mbox)
 {
@@ -216,3 +225,4 @@ int otx2_cpt_sync_mbox_msg(struct otx2_mbox *mbox)
 
 	return otx2_mbox_check_rsp_msgs(mbox, 0);
 }
+EXPORT_SYMBOL_NS_GPL(otx2_cpt_sync_mbox_msg, CRYPTO_DEV_OCTEONTX2_CPT);
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptlf.c b/drivers/crypto/marvell/octeontx2/otx2_cptlf.c
index c8350fcd60fab..71e5f79431afa 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptlf.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptlf.c
@@ -274,6 +274,8 @@ void otx2_cptlf_unregister_interrupts(struct otx2_cptlfs_info *lfs)
 	}
 	cptlf_disable_intrs(lfs);
 }
+EXPORT_SYMBOL_NS_GPL(otx2_cptlf_unregister_interrupts,
+		     CRYPTO_DEV_OCTEONTX2_CPT);
 
 static int cptlf_do_register_interrrupts(struct otx2_cptlfs_info *lfs,
 					 int lf_num, int irq_offset,
@@ -321,6 +323,7 @@ int otx2_cptlf_register_interrupts(struct otx2_cptlfs_info *lfs)
 	otx2_cptlf_unregister_interrupts(lfs);
 	return ret;
 }
+EXPORT_SYMBOL_NS_GPL(otx2_cptlf_register_interrupts, CRYPTO_DEV_OCTEONTX2_CPT);
 
 void otx2_cptlf_free_irqs_affinity(struct otx2_cptlfs_info *lfs)
 {
@@ -334,6 +337,7 @@ void otx2_cptlf_free_irqs_affinity(struct otx2_cptlfs_info *lfs)
 		free_cpumask_var(lfs->lf[slot].affinity_mask);
 	}
 }
+EXPORT_SYMBOL_NS_GPL(otx2_cptlf_free_irqs_affinity, CRYPTO_DEV_OCTEONTX2_CPT);
 
 int otx2_cptlf_set_irqs_affinity(struct otx2_cptlfs_info *lfs)
 {
@@ -366,6 +370,7 @@ int otx2_cptlf_set_irqs_affinity(struct otx2_cptlfs_info *lfs)
 	otx2_cptlf_free_irqs_affinity(lfs);
 	return ret;
 }
+EXPORT_SYMBOL_NS_GPL(otx2_cptlf_set_irqs_affinity, CRYPTO_DEV_OCTEONTX2_CPT);
 
 int otx2_cptlf_init(struct otx2_cptlfs_info *lfs, u8 eng_grp_mask, int pri,
 		    int lfs_num)
@@ -422,6 +427,7 @@ int otx2_cptlf_init(struct otx2_cptlfs_info *lfs, u8 eng_grp_mask, int pri,
 	lfs->lfs_num = 0;
 	return ret;
 }
+EXPORT_SYMBOL_NS_GPL(otx2_cptlf_init, CRYPTO_DEV_OCTEONTX2_CPT);
 
 void otx2_cptlf_shutdown(struct otx2_cptlfs_info *lfs)
 {
@@ -431,3 +437,8 @@ void otx2_cptlf_shutdown(struct otx2_cptlfs_info *lfs)
 	/* Send request to detach LFs */
 	otx2_cpt_detach_rsrcs_msg(lfs);
 }
+EXPORT_SYMBOL_NS_GPL(otx2_cptlf_shutdown, CRYPTO_DEV_OCTEONTX2_CPT);
+
+MODULE_AUTHOR("Marvell");
+MODULE_DESCRIPTION("Marvell RVU CPT Common module");
+MODULE_LICENSE("GPL");
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
index a402ccfac5577..ddf6e913c1c45 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
@@ -831,6 +831,8 @@ static struct pci_driver otx2_cpt_pci_driver = {
 
 module_pci_driver(otx2_cpt_pci_driver);
 
+MODULE_IMPORT_NS(CRYPTO_DEV_OCTEONTX2_CPT);
+
 MODULE_AUTHOR("Marvell");
 MODULE_DESCRIPTION(OTX2_CPT_DRV_STRING);
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c b/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
index 3411e664cf50c..392e9fee05e81 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
@@ -429,6 +429,8 @@ static struct pci_driver otx2_cptvf_pci_driver = {
 
 module_pci_driver(otx2_cptvf_pci_driver);
 
+MODULE_IMPORT_NS(CRYPTO_DEV_OCTEONTX2_CPT);
+
 MODULE_AUTHOR("Marvell");
 MODULE_DESCRIPTION("Marvell RVU CPT Virtual Function Driver");
 MODULE_LICENSE("GPL v2");
-- 
2.39.2



