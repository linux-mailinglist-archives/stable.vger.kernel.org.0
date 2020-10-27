Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1853829B9A5
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802683AbgJ0Puw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:50:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:43462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1802353AbgJ0PqR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:46:17 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D64722202;
        Tue, 27 Oct 2020 15:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813576;
        bh=ZBmwvmw6IcmRjdkRR1Byq2dSW/sHKj9PegJRSyqKy9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0FSfTPQrJ62qceyyavNVclmwveGa3AA2S/mtfW/zcFgPDpCvWIDSgakCHShfy/avn
         02Ew5YA7k+Sb2ajZiiUGAT9ve6hcfaQjwnh7Mu+ihySy4j8by7ADd2QscTX3k2/+nx
         daiEYucCFe9l/tZA6rbbP3//ThrxbFT2ROVYAemE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dafna Hirschfeld <dafna.hirschfeld@collabora.com>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 598/757] arm64: dts: mt8173-elm: fix supported values for regulator-allowed-modes of da9211
Date:   Tue, 27 Oct 2020 14:54:08 +0100
Message-Id: <20201027135518.594631190@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dafna Hirschfeld <dafna.hirschfeld@collabora.com>

[ Upstream commit 9d955478a89b4a1ff4e7442216f2822dee8fde73 ]

According to the datasheet the allowed modes for the da9211
regulator are sync and auto mode. This should be changed in the
devicetree. This also fix an error message
'BUCKA: invalid regulator-allowed-modes element 0'
since value 0 is invalid.

Fixes: 689b937beddeb ("arm64: dts: mediatek: add mt8173 elm and hana board")
Signed-off-by: Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
Tested-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Link: https://lore.kernel.org/r/20200903142819.24487-1-dafna.hirschfeld@collabora.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8173-elm.dtsi | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8173-elm.dtsi b/arch/arm64/boot/dts/mediatek/mt8173-elm.dtsi
index a5a12b2599a4a..bdec719a6b62f 100644
--- a/arch/arm64/boot/dts/mediatek/mt8173-elm.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8173-elm.dtsi
@@ -5,6 +5,7 @@
 
 #include <dt-bindings/input/input.h>
 #include <dt-bindings/input/linux-event-codes.h>
+#include <dt-bindings/regulator/dlg,da9211-regulator.h>
 #include <dt-bindings/gpio/gpio.h>
 #include "mt8173.dtsi"
 
@@ -294,7 +295,8 @@ da9211_vcpu_reg: BUCKA {
 				regulator-max-microamp  = <4400000>;
 				regulator-ramp-delay = <10000>;
 				regulator-always-on;
-				regulator-allowed-modes = <0 1>;
+				regulator-allowed-modes = <DA9211_BUCK_MODE_SYNC
+							   DA9211_BUCK_MODE_AUTO>;
 			};
 
 			da9211_vgpu_reg: BUCKB {
-- 
2.25.1



