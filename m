Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3F54594656
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352281AbiHOWyG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352523AbiHOWwE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:52:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 827C3139D9C;
        Mon, 15 Aug 2022 12:54:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F29D5B80EAB;
        Mon, 15 Aug 2022 19:54:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C7B4C433C1;
        Mon, 15 Aug 2022 19:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593275;
        bh=NyrMSadPHQ4iOESHOAaie42MIzNfVPpbp8GQaIaUq50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=crVojArAddWL8TEFv2CoxWU/hm46YQiGRTrJ7opNiZWLI8zHM2+cLblv4pQvnSEHU
         OsA+Jh3fbVw7HZ2wNDHJMf93myScUNzG/a4Bk5w1D77ClTY9c0SugHOmg+BHhhrYRC
         N9B9NZR7F/mffetvf03A4iUfPXKX5sJH+qHfefMA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0921/1095] powerpc/pci: Prefer PCI domain assignment via DT linux,pci-domain and alias
Date:   Mon, 15 Aug 2022 20:05:20 +0200
Message-Id: <20220815180507.367988683@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 0fe1e96fef0a5c53b4c0d1500d356f3906000f81 ]

Other Linux architectures use DT property 'linux,pci-domain' for
specifying fixed PCI domain of PCI controller specified in Device-Tree.

And lot of Freescale powerpc boards have defined numbered pci alias in
Device-Tree for every PCIe controller which number specify preferred PCI
domain.

So prefer usage of DT property 'linux,pci-domain' (via function
of_get_pci_domain_nr()) and DT pci alias (via function
of_alias_get_id()) on powerpc architecture for assigning PCI domain to
PCI controller.

Fixes: 63a72284b159 ("powerpc/pci: Assign fixed PHB number based on device-tree properties")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220706102148.5060-2-pali@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/pci-common.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
index 9a97a93bd11c..7daa00f3942e 100644
--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -74,16 +74,30 @@ void __init set_pci_dma_ops(const struct dma_map_ops *dma_ops)
 static int get_phb_number(struct device_node *dn)
 {
 	int ret, phb_id = -1;
-	u32 prop_32;
 	u64 prop;
 
 	/*
 	 * Try fixed PHB numbering first, by checking archs and reading
-	 * the respective device-tree properties. Firstly, try powernv by
-	 * reading "ibm,opal-phbid", only present in OPAL environment.
+	 * the respective device-tree properties. Firstly, try reading
+	 * standard "linux,pci-domain", then try reading "ibm,opal-phbid"
+	 * (only present in powernv OPAL environment), then try device-tree
+	 * alias and as the last try to use lower bits of "reg" property.
 	 */
-	ret = of_property_read_u64(dn, "ibm,opal-phbid", &prop);
+	ret = of_get_pci_domain_nr(dn);
+	if (ret >= 0) {
+		prop = ret;
+		ret = 0;
+	}
+	if (ret)
+		ret = of_property_read_u64(dn, "ibm,opal-phbid", &prop);
+	if (ret)
+		ret = of_alias_get_id(dn, "pci");
+	if (ret >= 0) {
+		prop = ret;
+		ret = 0;
+	}
 	if (ret) {
+		u32 prop_32;
 		ret = of_property_read_u32_index(dn, "reg", 1, &prop_32);
 		prop = prop_32;
 	}
@@ -95,10 +109,7 @@ static int get_phb_number(struct device_node *dn)
 	if ((phb_id >= 0) && !test_and_set_bit(phb_id, phb_bitmap))
 		return phb_id;
 
-	/*
-	 * If not pseries nor powernv, or if fixed PHB numbering tried to add
-	 * the same PHB number twice, then fallback to dynamic PHB numbering.
-	 */
+	/* If everything fails then fallback to dynamic PHB numbering. */
 	phb_id = find_first_zero_bit(phb_bitmap, MAX_PHBS);
 	BUG_ON(phb_id >= MAX_PHBS);
 	set_bit(phb_id, phb_bitmap);
-- 
2.35.1



