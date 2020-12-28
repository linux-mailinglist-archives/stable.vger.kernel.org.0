Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8D072E3C79
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:03:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408237AbgL1ODD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:03:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:34738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408263AbgL1OBM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:01:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CEB3206D4;
        Mon, 28 Dec 2020 14:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164056;
        bh=pG8r1Ej/nB1HF+AOeT13mdeiO3n/0ymnRAzhuf6a9w4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cmvYpf4d6vHNgH7fKUlwQ6h17CXJnNDWU/uKHsfyucR2wJZAGbX6Bc7SJBtqtynZb
         FdlkWDdclbi20204iLon729DkI8gV5rcf+Ncbd2dgEIXf6EDFHArBt5uqJImd0zgHY
         7NWyFti10RpvP6h3jLOcH0lOgCYlKiNiXYramuKk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Georgi Djakov <georgi.djakov@linaro.org>,
        Rob Clark <robdclark@chromium.org>,
        Douglas Anderson <dianders@chromium.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 013/717] arm64: dts: qcom: sc7180: Fix one forgotten interconnect reference
Date:   Mon, 28 Dec 2020 13:40:11 +0100
Message-Id: <20201228125021.624410450@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 228813aaa71113d7a12313b87c4905a9d3f9df37 ]

In commit e23b1220a246 ("arm64: dts: qcom: sc7180: Increase the number
of interconnect cells") we missed increasing the cells on one
interconnect.  That's no bueno.  Fix it.

NOTE: it appears that things aren't totally broken without this fix,
but clearly something isn't going to be working right.  If nothing
else, without this fix I see this in the logs:

  OF: /soc@0/mdss@ae00000: could not get #interconnect-cells for /soc@0/interrupt-controller@17a00000

Fixes: e23b1220a246 ("arm64: dts: qcom: sc7180: Increase the number of interconnect cells")
Reviewed-by: Georgi Djakov <georgi.djakov@linaro.org>
Reviewed-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20201001141838.1.I08054d1d976eed64ffa1b0e21d568e0dc6040b54@changeid
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7180.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7180.dtsi b/arch/arm64/boot/dts/qcom/sc7180.dtsi
index 6678f1e8e3958..a02776ce77a10 100644
--- a/arch/arm64/boot/dts/qcom/sc7180.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180.dtsi
@@ -2811,7 +2811,7 @@
 			interrupt-controller;
 			#interrupt-cells = <1>;
 
-			interconnects = <&mmss_noc MASTER_MDP0 &mc_virt SLAVE_EBI1>;
+			interconnects = <&mmss_noc MASTER_MDP0 0 &mc_virt SLAVE_EBI1 0>;
 			interconnect-names = "mdp0-mem";
 
 			iommus = <&apps_smmu 0x800 0x2>;
-- 
2.27.0



