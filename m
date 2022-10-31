Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29E696140C0
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 23:39:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbiJaWjQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 18:39:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiJaWjP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 18:39:15 -0400
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6834A26CE
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 15:39:14 -0700 (PDT)
Received: from submission (posteo.de [185.67.36.169]) 
        by mout02.posteo.de (Postfix) with ESMTPS id D6DC9240103
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 23:39:12 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.de; s=2017;
        t=1667255952; bh=PVmFDAqX+9v0FAc9XtUgG1cSk0z87kQW/uOUY/XfW10=;
        h=From:To:Cc:Subject:Date:From;
        b=cZ1seywWmxL9AsBRSNM73HasGsrLP2NQIR691Pnq8PstJkomZngeoPoZEGpUt5u9M
         eLwyuHLn9yW86RQCGFH4rQdM+TxzC/YhP23O+uElHCqCSs9N5SIJ076Nysh9BpR0/H
         RBrRjTThZXKpZ1xo3wKrHAAp1zLOzJOxhIjwtYOYXwyDw1DIps+2y6W29Uy7zMS6nP
         7X61KVIsxTOteaSkxmPMTptvR+VdcMsMDHw/0JhUla104SxK5Gx52FLzYCPQqgOQZ2
         Z31MFjc9Orq8TLD8UwAB/Nbe1Ads6osnXHAuFtJirTmJQ3hJC6B1B3jsI2vHJiNQuW
         +w4Rixcw/RChw==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 4N1SkS2rwkz9rxH;
        Mon, 31 Oct 2022 23:39:12 +0100 (CET)
From:   Nils Freydank <nils.freydank@posteo.de>
To:     stable@vger.kernel.org
Cc:     Nils Freydank <nils.freydank@posteo.de>
Subject: [PATCH] platform/x86/amd: pmc: remove CONFIG_DEBUG_FS checks
Date:   Mon, 31 Oct 2022 22:36:53 +0000
Message-Id: <20221031223652.17717-1-nils.freydank@posteo.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit b37fe34c83099ba5105115f8287c5546af1f0a05 upstream.

This fixes a compilation bug introduced in commit
e9847175b266f12365160e124a207907da3dbe8e (platform/x86/amd: pmc: Read SMU
version during suspend on Cezanne systems).

Signed-off-by: Nils Freydank <nils.freydank@posteo.de>
---

 Backport patch applies and compiles with linux 6.0.6.
 Feel free to use the whole patch or any parts of it at your discretion.

 drivers/platform/x86/amd/pmc.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/platform/x86/amd/pmc.c b/drivers/platform/x86/amd/pmc.c
index fc326fdf4..6ccb9b384 100644
--- a/drivers/platform/x86/amd/pmc.c
+++ b/drivers/platform/x86/amd/pmc.c
@@ -151,9 +151,7 @@ struct amd_pmc_dev {
 	struct device *dev;
 	struct pci_dev *rdev;
 	struct mutex lock; /* generic mutex lock */
-#if IS_ENABLED(CONFIG_DEBUG_FS)
 	struct dentry *dbgfs_dir;
-#endif /* CONFIG_DEBUG_FS */
 };
 
 static bool enable_stb;
@@ -369,7 +367,6 @@ static void amd_pmc_validate_deepest(struct amd_pmc_dev *pdev)
 }
 #endif
 
-#ifdef CONFIG_DEBUG_FS
 static int smu_fw_info_show(struct seq_file *s, void *unused)
 {
 	struct amd_pmc_dev *dev = s->private;
@@ -504,15 +501,6 @@ static void amd_pmc_dbgfs_register(struct amd_pmc_dev *dev)
 					    &amd_pmc_stb_debugfs_fops);
 	}
 }
-#else
-static inline void amd_pmc_dbgfs_register(struct amd_pmc_dev *dev)
-{
-}
-
-static inline void amd_pmc_dbgfs_unregister(struct amd_pmc_dev *dev)
-{
-}
-#endif /* CONFIG_DEBUG_FS */
 
 static void amd_pmc_dump_registers(struct amd_pmc_dev *dev)
 {
-- 
2.38.1

