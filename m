Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B216740E3C7
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243042AbhIPQwD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:52:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:37600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237311AbhIPQsy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:48:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BAE761A79;
        Thu, 16 Sep 2021 16:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809664;
        bh=syBfFwq/P4uSIrG4mOGpFqTGSAukmDJ6h1bvHPp9fjU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oef4aISqvHf/hjWb2V2lgJI7VlCaa+PtAbAdK0cL3bYynFykPnUAE1u/4R2yyehCA
         nAETbRchHzpNLZLdcaMNpySajSs42Ajxoivh/MksOl0wQkxiF3Now+KCfWQlsQBeVd
         bAbQ81GFSju8q9g75dRKBO6HkgF1o0hYM8m2Xymg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 237/380] arm64: dts: qcom: ipq8074: fix pci node reg property
Date:   Thu, 16 Sep 2021 17:59:54 +0200
Message-Id: <20210916155812.141421137@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vinod Koul <vkoul@kernel.org>

[ Upstream commit 52c9887fba71fc8f12d343833fc595c762aac8c7 ]

reg property should be array of values, here it is a single array,
leading to below warning:

arch/arm64/boot/dts/qcom/ipq8074-hk01.dt.yaml: soc: pci@10000000:reg:0: [268435456, 3869, 268439328, 168, 557056, 8192, 269484032, 4096] is too long
arch/arm64/boot/dts/qcom/ipq8074-hk01.dt.yaml: soc: pci@10000000:ranges: 'oneOf' conditional failed, one must be fixed:
arch/arm64/boot/dts/qcom/ipq8074-hk01.dt.yaml: soc: pci@10000000:ranges: 'oneOf' conditional failed, one must be fixed:
[[2164260864, 0, 270532608, 270532608, 0, 1048576, 2181038080, 0, 271581184, 271581184, 0, 13631488]] is not of type 'null'
[2164260864, 0, 270532608, 270532608, 0, 1048576, 2181038080, 0, 271581184, 271581184, 0, 13631488] is too long
arch/arm64/boot/dts/qcom/ipq8074-hk01.dt.yaml: soc: pci@20000000:reg:0: [536870912, 3869, 536874784, 168, 524288, 8192, 537919488, 4096] is too long
arch/arm64/boot/dts/qcom/ipq8074-hk01.dt.yaml: soc: pci@20000000:ranges: 'oneOf' conditional failed, one must be fixed:
arch/arm64/boot/dts/qcom/ipq8074-hk01.dt.yaml: soc: pci@20000000:ranges: 'oneOf' conditional failed, one must be fixed:
[[2164260864, 0, 538968064, 538968064, 0, 1048576, 2181038080, 0, 540016640, 540016640, 0, 13631488]] is not of type 'null'
[2164260864, 0, 538968064, 538968064, 0, 1048576, 2181038080, 0, 540016640, 540016640, 0, 13631488] is too long

Signed-off-by: Vinod Koul <vkoul@kernel.org>
Link: https://lore.kernel.org/r/20210308060826.3074234-17-vkoul@kernel.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/ipq8074.dtsi | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq8074.dtsi b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
index a32e5e79ab0b..e8db62470b23 100644
--- a/arch/arm64/boot/dts/qcom/ipq8074.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
@@ -567,10 +567,10 @@ frame@b128000 {
 
 		pcie1: pci@10000000 {
 			compatible = "qcom,pcie-ipq8074";
-			reg =  <0x10000000 0xf1d
-				0x10000f20 0xa8
-				0x00088000 0x2000
-				0x10100000 0x1000>;
+			reg =  <0x10000000 0xf1d>,
+			       <0x10000f20 0xa8>,
+			       <0x00088000 0x2000>,
+			       <0x10100000 0x1000>;
 			reg-names = "dbi", "elbi", "parf", "config";
 			device_type = "pci";
 			linux,pci-domain = <1>;
@@ -629,10 +629,10 @@ IRQ_TYPE_LEVEL_HIGH>, /* int_c */
 
 		pcie0: pci@20000000 {
 			compatible = "qcom,pcie-ipq8074";
-			reg =  <0x20000000 0xf1d
-				0x20000f20 0xa8
-				0x00080000 0x2000
-				0x20100000 0x1000>;
+			reg = <0x20000000 0xf1d>,
+			      <0x20000f20 0xa8>,
+			      <0x00080000 0x2000>,
+			      <0x20100000 0x1000>;
 			reg-names = "dbi", "elbi", "parf", "config";
 			device_type = "pci";
 			linux,pci-domain = <0>;
-- 
2.30.2



