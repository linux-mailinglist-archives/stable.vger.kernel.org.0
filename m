Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F233676ABB
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 16:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728148AbfGZOAr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 10:00:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:46040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727584AbfGZNkJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 09:40:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B75722CBB;
        Fri, 26 Jul 2019 13:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148408;
        bh=GS0t9ejWfMJx8u+jiXzlJqATgam2UjS8xzz2i1Kfo70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ck0FiNcQjy4xFqS5XBGVeVPQzPL4hLByZ/ZJabWU7lfYdMS1XLGrMXNXK0opmmP5v
         jOI5N+qcFBKEc5t2KaBNUkIhwvEdiSi4lUlJJyC6gIEPAIrCnGDXRxK6VSU+D0bzot
         ZzCVtYve4efxLwQKowFsAHhqSv/7qOTOTa7eAzAU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Gross <agross@kernel.org>,
        Niklas Cassel <niklas.cassel@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Olof Johansson <olof@lixom.net>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 17/85] arm64: qcom: qcs404: Add reset-cells to GCC node
Date:   Fri, 26 Jul 2019 09:38:27 -0400
Message-Id: <20190726133936.11177-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726133936.11177-1-sashal@kernel.org>
References: <20190726133936.11177-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Gross <agross@kernel.org>

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
index ffedf9640af7..65a2cbeb28be 100644
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

