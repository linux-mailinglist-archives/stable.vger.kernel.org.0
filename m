Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 781B74CF82D
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233316AbiCGJwI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:52:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238839AbiCGJsr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:48:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97E3C6D4CD;
        Mon,  7 Mar 2022 01:42:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 345AB61224;
        Mon,  7 Mar 2022 09:42:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37104C36AE9;
        Mon,  7 Mar 2022 09:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646156;
        bh=ZFa5qGU/Bx44asH0ijJeAVEBfCBxgDdBxw9ajPLlLR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wI7uR24pKni/lt3CzfJ4iH1z98M19BLZZawx454EvyUWzn2NARtiVXO9Kdej3eHOm
         OL3aBm6+65pcjhAoZTbJmPBMgC7CkeM0DEp//nfXdVJYX9lk69N1RgRbsBjr0kH+Nv
         m8EUd5yabrpwMAk3bmMKv+q5g/o3NaCXrqWKzuLY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jerry Dai <jerry.dai@intel.com>,
        Dave Jiang <dave.jiang@intel.com>, Jon Mason <jdmason@kudzu.us>
Subject: [PATCH 5.15 151/262] ntb: intel: fix port config status offset for SPR
Date:   Mon,  7 Mar 2022 10:18:15 +0100
Message-Id: <20220307091706.701856383@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Jiang <dave.jiang@intel.com>

commit d5081bf5dcfb1cb83fb538708b0ac07a10a79cc4 upstream.

The field offset for port configuration status on SPR has been changed to
bit 14 from ICX where it resides at bit 12. By chance link status detection
continued to work on SPR. This is due to bit 12 being a configuration bit
which is in sync with the status bit. Fix this by checking for a SPR device
and checking correct status bit.

Fixes: 26bfe3d0b227 ("ntb: intel: Add Icelake (gen4) support for Intel NTB")
Tested-by: Jerry Dai <jerry.dai@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ntb/hw/intel/ntb_hw_gen4.c |   17 ++++++++++++++++-
 drivers/ntb/hw/intel/ntb_hw_gen4.h |   16 ++++++++++++++++
 2 files changed, 32 insertions(+), 1 deletion(-)

--- a/drivers/ntb/hw/intel/ntb_hw_gen4.c
+++ b/drivers/ntb/hw/intel/ntb_hw_gen4.c
@@ -168,6 +168,18 @@ static enum ntb_topo gen4_ppd_topo(struc
 	return NTB_TOPO_NONE;
 }
 
+static enum ntb_topo spr_ppd_topo(struct intel_ntb_dev *ndev, u32 ppd)
+{
+	switch (ppd & SPR_PPD_TOPO_MASK) {
+	case SPR_PPD_TOPO_B2B_USD:
+		return NTB_TOPO_B2B_USD;
+	case SPR_PPD_TOPO_B2B_DSD:
+		return NTB_TOPO_B2B_DSD;
+	}
+
+	return NTB_TOPO_NONE;
+}
+
 int gen4_init_dev(struct intel_ntb_dev *ndev)
 {
 	struct pci_dev *pdev = ndev->ntb.pdev;
@@ -183,7 +195,10 @@ int gen4_init_dev(struct intel_ntb_dev *
 	}
 
 	ppd1 = ioread32(ndev->self_mmio + GEN4_PPD1_OFFSET);
-	ndev->ntb.topo = gen4_ppd_topo(ndev, ppd1);
+	if (pdev_is_ICX(pdev))
+		ndev->ntb.topo = gen4_ppd_topo(ndev, ppd1);
+	else if (pdev_is_SPR(pdev))
+		ndev->ntb.topo = spr_ppd_topo(ndev, ppd1);
 	dev_dbg(&pdev->dev, "ppd %#x topo %s\n", ppd1,
 		ntb_topo_string(ndev->ntb.topo));
 	if (ndev->ntb.topo == NTB_TOPO_NONE)
--- a/drivers/ntb/hw/intel/ntb_hw_gen4.h
+++ b/drivers/ntb/hw/intel/ntb_hw_gen4.h
@@ -49,10 +49,14 @@
 #define GEN4_PPD_CLEAR_TRN		0x0001
 #define GEN4_PPD_LINKTRN		0x0008
 #define GEN4_PPD_CONN_MASK		0x0300
+#define SPR_PPD_CONN_MASK		0x0700
 #define GEN4_PPD_CONN_B2B		0x0200
 #define GEN4_PPD_DEV_MASK		0x1000
 #define GEN4_PPD_DEV_DSD		0x1000
 #define GEN4_PPD_DEV_USD		0x0000
+#define SPR_PPD_DEV_MASK		0x4000
+#define SPR_PPD_DEV_DSD 		0x4000
+#define SPR_PPD_DEV_USD 		0x0000
 #define GEN4_LINK_CTRL_LINK_DISABLE	0x0010
 
 #define GEN4_SLOTSTS			0xb05a
@@ -62,6 +66,10 @@
 #define GEN4_PPD_TOPO_B2B_USD	(GEN4_PPD_CONN_B2B | GEN4_PPD_DEV_USD)
 #define GEN4_PPD_TOPO_B2B_DSD	(GEN4_PPD_CONN_B2B | GEN4_PPD_DEV_DSD)
 
+#define SPR_PPD_TOPO_MASK	(SPR_PPD_CONN_MASK | SPR_PPD_DEV_MASK)
+#define SPR_PPD_TOPO_B2B_USD	(GEN4_PPD_CONN_B2B | SPR_PPD_DEV_USD)
+#define SPR_PPD_TOPO_B2B_DSD	(GEN4_PPD_CONN_B2B | SPR_PPD_DEV_DSD)
+
 #define GEN4_DB_COUNT			32
 #define GEN4_DB_LINK			32
 #define GEN4_DB_LINK_BIT		BIT_ULL(GEN4_DB_LINK)
@@ -111,5 +119,13 @@ static inline int pdev_is_ICX(struct pci
 		return 1;
 	return 0;
 }
+
+static inline int pdev_is_SPR(struct pci_dev *pdev)
+{
+	if (pdev_is_gen4(pdev) &&
+	    pdev->revision > PCI_DEVICE_REVISION_ICX_MAX)
+		return 1;
+	return 0;
+}
 
 #endif


