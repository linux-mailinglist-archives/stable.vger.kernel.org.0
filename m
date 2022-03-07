Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DFC14CFA34
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:15:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235660AbiCGKN7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:13:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242450AbiCGKLe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:11:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B2EB8A313;
        Mon,  7 Mar 2022 01:55:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 381F660A27;
        Mon,  7 Mar 2022 09:54:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38222C340E9;
        Mon,  7 Mar 2022 09:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646874;
        bh=7ZaHIqiLhEKHT66BkWo+qr1fJJ6/m4DqN31xrBv38I4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lwJu5JvXvyNFvQwyWP/MHiSEAurIbqs8uVAMfbJzmTTxdZxt9xX0pKW284QpHYkM7
         YW7dQY7M+3EWzfDP4qsJlnX7DDyeh/NzliWaMc9Sx3qJRrbdTKFcAI2ETde7rztztI
         J/QhavTKXuQzykX1ykL+oWjNM89GYuo4fzhZk4bg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anders Roxell <anders.roxell@linaro.org>,
        Liviu Dudau <liviu.dudau@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 121/186] arm64: dts: juno: Remove GICv2m dma-range
Date:   Mon,  7 Mar 2022 10:19:19 +0100
Message-Id: <20220307091657.463588854@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091654.092878898@linuxfoundation.org>
References: <20220307091654.092878898@linuxfoundation.org>
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

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit 31eeb6b09f4053f32a30ce9fbcdfca31f713028d ]

Although it is painstakingly honest to describe all 3 PCI windows in
"dma-ranges", it misses the the subtle distinction that the window for
the GICv2m range is normally programmed for Device memory attributes
rather than Normal Cacheable like the DRAM windows. Since MMU-401 only
offers stage 2 translation, this means that when the PCI SMMU is
enabled, accesses through that IPA range unexpectedly lose coherency if
mapped as cacheable at the SMMU, due to the attribute combining rules.
Since an extra 256KB is neither here nor there when we still have 10GB
worth of usable address space, rather than attempting to describe and
cope with this detail let's just remove the offending range. If the SMMU
is not used then it makes no difference anyway.

Link: https://lore.kernel.org/r/856c3f7192c6c3ce545ba67462f2ce9c86ed6b0c.1643046936.git.robin.murphy@arm.com
Fixes: 4ac4d146cb63 ("arm64: dts: juno: Describe PCI dma-ranges")
Reported-by: Anders Roxell <anders.roxell@linaro.org>
Acked-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/arm/juno-base.dtsi | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/arm/juno-base.dtsi b/arch/arm64/boot/dts/arm/juno-base.dtsi
index 6288e104a089..a2635b14da30 100644
--- a/arch/arm64/boot/dts/arm/juno-base.dtsi
+++ b/arch/arm64/boot/dts/arm/juno-base.dtsi
@@ -543,8 +543,7 @@
 			 <0x02000000 0x00 0x50000000 0x00 0x50000000 0x0 0x08000000>,
 			 <0x42000000 0x40 0x00000000 0x40 0x00000000 0x1 0x00000000>;
 		/* Standard AXI Translation entries as programmed by EDK2 */
-		dma-ranges = <0x02000000 0x0 0x2c1c0000 0x0 0x2c1c0000 0x0 0x00040000>,
-			     <0x02000000 0x0 0x80000000 0x0 0x80000000 0x0 0x80000000>,
+		dma-ranges = <0x02000000 0x0 0x80000000 0x0 0x80000000 0x0 0x80000000>,
 			     <0x43000000 0x8 0x00000000 0x8 0x00000000 0x2 0x00000000>;
 		#interrupt-cells = <1>;
 		interrupt-map-mask = <0 0 0 7>;
-- 
2.34.1



