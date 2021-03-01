Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66C7E328F37
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241978AbhCATrx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:47:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:50734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234728AbhCATgF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:36:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD48B64F55;
        Mon,  1 Mar 2021 17:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620417;
        bh=xOMTcuBzpKhoiyZUle7nb6zxuuTyzEDpkAPmR6r077E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aFJD2fqShIMB6t0VbXQIEFjTkMBfxOBhU7BnIkAlPbfRnKX0xxi7ta9LUEO2VHCR1
         C1jcovQMRyCjT1MgY5/nAGwSgl4gl5EtW/Cnp957+qA8ojbKePZ+pBXP9kkqLUZI+Z
         NguS5xsGpX7Og20TA8l6xoTvFinDCpc2fFXa/GOk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 146/775] arm64: dts: qcom: sm8250: correct sdhc_2 xo clk
Date:   Mon,  1 Mar 2021 17:05:14 +0100
Message-Id: <20210301161208.865934144@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 74097d805edb9305a2a588a8ece82d2495ff5a88 ]

sdhc_2 uses 19200000 Hz clock rather than wrongly specified xo_board
(39400000 Hz). Specify correct clock to fix DLL setup for SDR104 mode.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Fixes: c4cf0300be84 ("arm64: dts: qcom: sm8250: Add support for SDC2")
Link: https://lore.kernel.org/r/20210109011252.3436533-1-dmitry.baryshkov@linaro.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8250.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
index 65acd1f381eba..1ae90e8b70f32 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -1657,7 +1657,7 @@
 
 			clocks = <&gcc GCC_SDCC2_AHB_CLK>,
 				 <&gcc GCC_SDCC2_APPS_CLK>,
-				 <&xo_board>;
+				 <&rpmhcc RPMH_CXO_CLK>;
 			clock-names = "iface", "core", "xo";
 			iommus = <&apps_smmu 0x4a0 0x0>;
 			qcom,dll-config = <0x0007642c>;
-- 
2.27.0



