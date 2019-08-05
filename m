Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98D5181D2F
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730298AbfHENUl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:20:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:56734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729773AbfHENUj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:20:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A25522075B;
        Mon,  5 Aug 2019 13:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011238;
        bh=NiODZww1Lx7CncHNndOsLnpgx9qKu/NV6F80uKpbQqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0xHXnB1S2VH7fBPIFI0lk+XyymZYIYquiKtO3WGs/C6fi7HU/A1p6jcbJpJI4Pkvz
         PwxbFThzO9HPnXdw4MWe1B2zokKr/B06yCNEG3bGCW80ZWSvPChbsGqJFWg0QtUeWw
         bgpeZLGhpjU57jPW5XtOzJVSSJGh0TmUOaEnJag4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Gross <agross@kernel.org>,
        Niklas Cassel <niklas.cassel@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Olof Johansson <olof@lixom.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 017/131] arm64: qcom: qcs404: Add reset-cells to GCC node
Date:   Mon,  5 Aug 2019 15:01:44 +0200
Message-Id: <20190805124952.589825090@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124951.453337465@linuxfoundation.org>
References: <20190805124951.453337465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 0763d0c2273a3c72247d325c48fbac3d918d6b87 ]

This patch adds a reset-cells property to the gcc controller on the QCS404.
Without this in place, we get warnings like the following if nodes reference
a gcc reset:

arch/arm64/boot/dts/qcom/qcs404.dtsi:261.38-310.5: Warning (resets_property):
/soc@0/remoteproc@b00000: Missing property '#reset-cells' in node
/soc@0/clock-controller@1800000 or bad phandle (referred from resets[0])
  also defined at arch/arm64/boot/dts/qcom/qcs404-evb.dtsi:82.18-84.3
  DTC     arch/arm64/boot/dts/qcom/qcs404-evb-4000.dtb
arch/arm64/boot/dts/qcom/qcs404.dtsi:261.38-310.5: Warning (resets_property):
/soc@0/remoteproc@b00000: Missing property '#reset-cells' in node
/soc@0/clock-controller@1800000 or bad phandle (referred from resets[0])
  also defined at arch/arm64/boot/dts/qcom/qcs404-evb.dtsi:82.18-84.3

Signed-off-by: Andy Gross <agross@kernel.org>
Reviewed-by: Niklas Cassel <niklas.cassel@linaro.org>
Reviewed-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qcs404.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/qcs404.dtsi b/arch/arm64/boot/dts/qcom/qcs404.dtsi
index ffedf9640af7d..65a2cbeb28bec 100644
--- a/arch/arm64/boot/dts/qcom/qcs404.dtsi
+++ b/arch/arm64/boot/dts/qcom/qcs404.dtsi
@@ -383,6 +383,7 @@
 			compatible = "qcom,gcc-qcs404";
 			reg = <0x01800000 0x80000>;
 			#clock-cells = <1>;
+			#reset-cells = <1>;
 
 			assigned-clocks = <&gcc GCC_APSS_AHB_CLK_SRC>;
 			assigned-clock-rates = <19200000>;
-- 
2.20.1



