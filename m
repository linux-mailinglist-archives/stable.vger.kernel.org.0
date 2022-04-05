Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6104F25E0
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbiDEHwv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232967AbiDEHvu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:51:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6591A996B0;
        Tue,  5 Apr 2022 00:48:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 02583615E7;
        Tue,  5 Apr 2022 07:48:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 050F0C340EE;
        Tue,  5 Apr 2022 07:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144885;
        bh=j/JaB5MizFWMRUT8kWIBGpddEPZCIEQnSkFMhIAYwV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WM+hHB2nA1db1q4cezaYh6zPJJg0aRwXNfDhGSJpGU6ZI6ZOT0sdb9kL/6eEKCzOb
         h6zzgKxV/vlj1zH411OG4somLftEH4qMH0J2m32NAF05dVassqcge187xdP9u4nlB1
         V6/SVI907o3oJwwH53A83ywuGTr/lGJMdBpcffEE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Siming Wan <siming.wan@intel.com>,
        Xin Zeng <xin.zeng@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Marco Chiappero <marco.chiappero@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0206/1126] crypto: qat - fix access to PFVF interrupt registers for GEN4
Date:   Tue,  5 Apr 2022 09:15:53 +0200
Message-Id: <20220405070413.655637827@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

[ Upstream commit 642a7d49c249f04007e68c124a148847471dd476 ]

The logic that detects, enables and disables pfvf interrupts was
expecting a single CSR per VF. Instead, the source and mask register are
two registers with a bit per VF.
Due to this, the driver is reading and setting reserved CSRs and not
masking the correct source of interrupts.

Fix the access to the source and mask register for QAT GEN4 devices by
removing the outer loop in adf_gen4_get_vf2pf_sources(),
adf_gen4_enable_vf2pf_interrupts() and
adf_gen4_disable_vf2pf_interrupts() and changing the helper macros
ADF_4XXX_VM2PF_SOU and ADF_4XXX_VM2PF_MSK.

Fixes: a9dc0d966605 ("crypto: qat - add PFVF support to the GEN4 host driver")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Co-developed-by: Siming Wan <siming.wan@intel.com>
Signed-off-by: Siming Wan <siming.wan@intel.com>
Reviewed-by: Xin Zeng <xin.zeng@intel.com>
Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Reviewed-by: Marco Chiappero <marco.chiappero@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qat/qat_common/adf_gen4_pfvf.c | 42 ++++---------------
 1 file changed, 9 insertions(+), 33 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_gen4_pfvf.c b/drivers/crypto/qat/qat_common/adf_gen4_pfvf.c
index 8efbedf63bc8..3b3ea849c5e5 100644
--- a/drivers/crypto/qat/qat_common/adf_gen4_pfvf.c
+++ b/drivers/crypto/qat/qat_common/adf_gen4_pfvf.c
@@ -9,15 +9,12 @@
 #include "adf_pfvf_pf_proto.h"
 #include "adf_pfvf_utils.h"
 
-#define ADF_4XXX_MAX_NUM_VFS		16
-
 #define ADF_4XXX_PF2VM_OFFSET(i)	(0x40B010 + ((i) * 0x20))
 #define ADF_4XXX_VM2PF_OFFSET(i)	(0x40B014 + ((i) * 0x20))
 
 /* VF2PF interrupt source registers */
-#define ADF_4XXX_VM2PF_SOU(i)		(0x41A180 + ((i) * 4))
-#define ADF_4XXX_VM2PF_MSK(i)		(0x41A1C0 + ((i) * 4))
-#define ADF_4XXX_VM2PF_INT_EN_MSK	BIT(0)
+#define ADF_4XXX_VM2PF_SOU		0x41A180
+#define ADF_4XXX_VM2PF_MSK		0x41A1C0
 
 #define ADF_PFVF_GEN4_MSGTYPE_SHIFT	2
 #define ADF_PFVF_GEN4_MSGTYPE_MASK	0x3F
@@ -41,51 +38,30 @@ static u32 adf_gen4_pf_get_vf2pf_offset(u32 i)
 
 static u32 adf_gen4_get_vf2pf_sources(void __iomem *pmisc_addr)
 {
-	int i;
 	u32 sou, mask;
-	int num_csrs = ADF_4XXX_MAX_NUM_VFS;
-	u32 vf_mask = 0;
 
-	for (i = 0; i < num_csrs; i++) {
-		sou = ADF_CSR_RD(pmisc_addr, ADF_4XXX_VM2PF_SOU(i));
-		mask = ADF_CSR_RD(pmisc_addr, ADF_4XXX_VM2PF_MSK(i));
-		sou &= ~mask;
-		vf_mask |= sou << i;
-	}
+	sou = ADF_CSR_RD(pmisc_addr, ADF_4XXX_VM2PF_SOU);
+	mask = ADF_CSR_RD(pmisc_addr, ADF_4XXX_VM2PF_MSK);
 
-	return vf_mask;
+	return sou &= ~mask;
 }
 
 static void adf_gen4_enable_vf2pf_interrupts(void __iomem *pmisc_addr,
 					     u32 vf_mask)
 {
-	int num_csrs = ADF_4XXX_MAX_NUM_VFS;
-	unsigned long mask = vf_mask;
 	unsigned int val;
-	int i;
-
-	for_each_set_bit(i, &mask, num_csrs) {
-		unsigned int offset = ADF_4XXX_VM2PF_MSK(i);
 
-		val = ADF_CSR_RD(pmisc_addr, offset) & ~ADF_4XXX_VM2PF_INT_EN_MSK;
-		ADF_CSR_WR(pmisc_addr, offset, val);
-	}
+	val = ADF_CSR_RD(pmisc_addr, ADF_4XXX_VM2PF_MSK) & ~vf_mask;
+	ADF_CSR_WR(pmisc_addr, ADF_4XXX_VM2PF_MSK, val);
 }
 
 static void adf_gen4_disable_vf2pf_interrupts(void __iomem *pmisc_addr,
 					      u32 vf_mask)
 {
-	int num_csrs = ADF_4XXX_MAX_NUM_VFS;
-	unsigned long mask = vf_mask;
 	unsigned int val;
-	int i;
-
-	for_each_set_bit(i, &mask, num_csrs) {
-		unsigned int offset = ADF_4XXX_VM2PF_MSK(i);
 
-		val = ADF_CSR_RD(pmisc_addr, offset) | ADF_4XXX_VM2PF_INT_EN_MSK;
-		ADF_CSR_WR(pmisc_addr, offset, val);
-	}
+	val = ADF_CSR_RD(pmisc_addr, ADF_4XXX_VM2PF_MSK) | vf_mask;
+	ADF_CSR_WR(pmisc_addr, ADF_4XXX_VM2PF_MSK, val);
 }
 
 static int adf_gen4_pfvf_send(struct adf_accel_dev *accel_dev,
-- 
2.34.1



