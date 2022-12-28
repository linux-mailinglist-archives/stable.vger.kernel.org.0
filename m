Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A48E657A67
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:11:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233161AbiL1PLP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:11:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233669AbiL1PKl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:10:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E861813E0B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:10:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81E3361551
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:10:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9368AC433D2;
        Wed, 28 Dec 2022 15:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240239;
        bh=Mdsob+SE7nZK0xnBTXgXVW89uWMn9GX9eUzueW0JSjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xrwWajscmJIyOxUlvfYqFSU79Gh6FS0hGP0ZEjBiQieZgKWgZZqGZI5t/RpyIiNT+
         OW7g4QCW67ya1YK9s69nW8l7AtoUmYCr3EOgRFI0hVCQfYt0gv3PrwcYGA7dBAMZAD
         Zmky5IC6A61C9TtALy+oJPK0dM+g8wCl9IGyl75g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Janne Grunau <j@jannau.net>,
        Mark Kettenis <kettenis@openbsd.org>,
        Hector Martin <marcan@marcan.st>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0099/1146] arch: arm64: apple: t8103: Use standard "iommu" node name
Date:   Wed, 28 Dec 2022 15:27:18 +0100
Message-Id: <20221228144332.833152087@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Janne Grunau <j@jannau.net>

[ Upstream commit 56d32c51dffac8a431b472a4c31efb8563b048d1 ]

The PCIe iommu nodes use "dart" as node names. Replace it with the
the standard "iommu" node name as all other iommu nodes.

Fixes: 3c866bb79577 ("arm64: dts: apple: t8103: Add PCIe DARTs")
Signed-off-by: Janne Grunau <j@jannau.net>
Reviewed-by: Mark Kettenis <kettenis@openbsd.org>
Signed-off-by: Hector Martin <marcan@marcan.st>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/apple/t8103.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/apple/t8103.dtsi b/arch/arm64/boot/dts/apple/t8103.dtsi
index 51a63b29d404..a4d195e9eb8c 100644
--- a/arch/arm64/boot/dts/apple/t8103.dtsi
+++ b/arch/arm64/boot/dts/apple/t8103.dtsi
@@ -412,7 +412,7 @@ nvme@27bcc0000 {
 			resets = <&ps_ans2>;
 		};
 
-		pcie0_dart_0: dart@681008000 {
+		pcie0_dart_0: iommu@681008000 {
 			compatible = "apple,t8103-dart";
 			reg = <0x6 0x81008000 0x0 0x4000>;
 			#iommu-cells = <1>;
@@ -421,7 +421,7 @@ pcie0_dart_0: dart@681008000 {
 			power-domains = <&ps_apcie_gp>;
 		};
 
-		pcie0_dart_1: dart@682008000 {
+		pcie0_dart_1: iommu@682008000 {
 			compatible = "apple,t8103-dart";
 			reg = <0x6 0x82008000 0x0 0x4000>;
 			#iommu-cells = <1>;
@@ -430,7 +430,7 @@ pcie0_dart_1: dart@682008000 {
 			power-domains = <&ps_apcie_gp>;
 		};
 
-		pcie0_dart_2: dart@683008000 {
+		pcie0_dart_2: iommu@683008000 {
 			compatible = "apple,t8103-dart";
 			reg = <0x6 0x83008000 0x0 0x4000>;
 			#iommu-cells = <1>;
-- 
2.35.1



