Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 799964E24A6
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 11:49:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346474AbiCUKuq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 06:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346463AbiCUKuo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 06:50:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14AAF201A2;
        Mon, 21 Mar 2022 03:49:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67EE06137A;
        Mon, 21 Mar 2022 10:49:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAB0BC340ED;
        Mon, 21 Mar 2022 10:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647859757;
        bh=RIu+LXbN2Vd3SrS65/dHGNLCz/e0MWpxYGJO0vbxywE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZtpfwaMxuKoYZI9dfMWrZJW47CdBEWMC10xbCnJX+GphS97HSt3aGI/RbuHGtUTZe
         GII1olTOMtH0ZafOlhsXNy9F9UFOm1lYszayLUOHtXzh3OVIm2t4RTtrzqWaqWiVfj
         i7yUFUu3P7V1n7OBZL2EFs2AHT3RdLnx1AtQtiOugKwxB0g8HjwDUNLn90IpNexp0U
         D6X2o9LetOTSd6glJRNkBAbN/Kwxf8EeQmiADwO+vzwQgp/wXAQARFEl7dmn0O5urq
         JFX7jc8YqmgpFo7cMN/kloOxyuu6BVOPR4boTpf+2W2GgXyupbB2OipG6QQZfxbqly
         sp++pKZHGfHUA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nWFb9-00FvJp-Dh; Mon, 21 Mar 2022 10:49:15 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pci@vger.kernel.org
Cc:     Rob Herring <robh@kernel.org>,
        Toan Le <toan@os.amperecomputing.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber@ubuntu.com>,
        dann frazier <dann.frazier@canonical.com>,
        kernel-team@android.com, stable@vger.kernel.org
Subject: [PATCH v2 2/2] PCI: xgene: Revert "PCI: xgene: Fix IB window setup"
Date:   Mon, 21 Mar 2022 10:48:43 +0000
Message-Id: <20220321104843.949645-3-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220321104843.949645-1-maz@kernel.org>
References: <20220321104843.949645-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org, robh@kernel.org, toan@os.amperecomputing.com, lorenzo.pieralisi@arm.com, kw@linux.com, bhelgaas@google.com, stgraber@ubuntu.com, dann.frazier@canonical.com, kernel-team@android.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit c7a75d07827a ("PCI: xgene: Fix IB window setup") tried to
fix the damages that 6dce5aa59e0b ("PCI: xgene: Use inbound resources
for setup") caused, but actually didn't improve anything for some
plarforms (at least Mustang and m400 are still broken).

Given that 6dce5aa59e0b has been reverted, revert this patch as well,
restoring the PCIe support on XGene to its pre-5.5, working state.

Cc: Rob Herring <robh@kernel.org>
Cc: Toan Le <toan@os.amperecomputing.com>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Krzysztof Wilczyński <kw@linux.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Stéphane Graber <stgraber@ubuntu.com>
Cc: dann frazier <dann.frazier@canonical.com>
Cc: stable@vger.kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Fixes: c7a75d07827a ("PCI: xgene: Fix IB window setup")
Link: https://lore.kernel.org/r/YjN8pT5e6/8cRohQ@xps13.dannf
---
 drivers/pci/controller/pci-xgene.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pci-xgene.c b/drivers/pci/controller/pci-xgene.c
index aa41ceaf031f..7c763d820c52 100644
--- a/drivers/pci/controller/pci-xgene.c
+++ b/drivers/pci/controller/pci-xgene.c
@@ -465,7 +465,7 @@ static int xgene_pcie_select_ib_reg(u8 *ib_reg_mask, u64 size)
 		return 1;
 	}
 
-	if ((size > SZ_1K) && (size < SZ_4G) && !(*ib_reg_mask & (1 << 0))) {
+	if ((size > SZ_1K) && (size < SZ_1T) && !(*ib_reg_mask & (1 << 0))) {
 		*ib_reg_mask |= (1 << 0);
 		return 0;
 	}
-- 
2.34.1

