Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEAA4451185
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243953AbhKOTJ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:09:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:39104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243922AbhKOTGi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:06:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CDE2633EB;
        Mon, 15 Nov 2021 18:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000215;
        bh=FVgRtSFxjBLi4lbTDdzMZGiHodtA1kV+lQqNjG6YAyY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oqAkcC0/XAgiOSEcks7NzI/lSN4jSNUgD9dx0O+wMvKRrvl/lP5K27eABgiFigYe2
         IZeA8ElY3lim8Ho5+apb1/koiJmMz7GkBy1TsowKGojhXbgk9FKvACI5hhTrOV2u2l
         fews+DDEucgBPfQedOJd79ui0kMrlF62ybPK9tU4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephan Gerhold <stephan@gerhold.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 580/849] arm64: dts: qcom: pm8916: Remove wrong reg-names for rtc@6000
Date:   Mon, 15 Nov 2021 18:01:03 +0100
Message-Id: <20211115165439.876400815@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephan Gerhold <stephan@gerhold.net>

[ Upstream commit 483de2b44cd3a168458f8f9ff237e78a434729bc ]

While removing the size from the "reg" properties in pm8916.dtsi,
commit bd6429e81010 ("ARM64: dts: qcom: Remove size elements from
pmic reg properties") mistakenly also removed the second register
address for the rtc@6000 device. That one did not represent the size
of the register region but actually the address of the second "alarm"
register region of the rtc@6000 device.

Now there are "reg-names" for two "reg" elements, but there is actually
only one "reg" listed.

Since the DT schema for "qcom,pm8941-rtc" only expects one "reg"
element anyway, just drop the "reg-names" entirely to fix this.

Fixes: bd6429e81010 ("ARM64: dts: qcom: Remove size elements from pmic reg properties")
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20210928112945.25310-1-stephan@gerhold.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/pm8916.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/pm8916.dtsi b/arch/arm64/boot/dts/qcom/pm8916.dtsi
index f931cb0de231f..42180f1b5dbbb 100644
--- a/arch/arm64/boot/dts/qcom/pm8916.dtsi
+++ b/arch/arm64/boot/dts/qcom/pm8916.dtsi
@@ -86,7 +86,6 @@
 		rtc@6000 {
 			compatible = "qcom,pm8941-rtc";
 			reg = <0x6000>;
-			reg-names = "rtc", "alarm";
 			interrupts = <0x0 0x61 0x1 IRQ_TYPE_EDGE_RISING>;
 		};
 
-- 
2.33.0



