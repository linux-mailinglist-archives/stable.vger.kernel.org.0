Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53B7B81D2C
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730412AbfHENVA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:21:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:57138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730376AbfHENVA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:21:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 779222067D;
        Mon,  5 Aug 2019 13:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011259;
        bh=kTm8vFgVI5vn+JvQ5m+tks9zwFBwjmQgoLwBfOhTY+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZKRdbeicX/r11UJzuAKk/aRWkFAQqLdpeNYzB4LAOqSlvZTgewt+sB39sJVan4za+
         QfieMa1nVKwYhDFjq+c6kxc0MnTFVzykANlDySefFCvDyuJZxVT7NZ1gzlhSYvUBL5
         OJgRipwtNYlLTBUCiY4rlfDXWIbIJ8g89LR49Cc4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Niklas Cassel <niklas.cassel@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <agross@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 007/131] arm64: dts: qcom: qcs404-evb: fix l3 min voltage
Date:   Mon,  5 Aug 2019 15:01:34 +0200
Message-Id: <20190805124951.918923072@linuxfoundation.org>
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

[ Upstream commit 887b528c958f40b064d53edd0bfa9fea3a69eccd ]

The current l3 min voltage level is not supported by
the regulator (the voltage is not a multiple of the regulator step size),
so a driver requesting this exact voltage would fail, see discussion in:
https://patchwork.kernel.org/comment/22461199/

It was agreed upon to set a min voltage level that is a multiple of the
regulator step size.

There was actually a patch sent that did this:
https://patchwork.kernel.org/patch/10819313/

However, the commit 331ab98f8c4a ("arm64: dts: qcom: qcs404:
Fix voltages l3") that was applied is not identical to that patch.

Signed-off-by: Niklas Cassel <niklas.cassel@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Andy Gross <agross@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qcs404-evb.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/qcs404-evb.dtsi b/arch/arm64/boot/dts/qcom/qcs404-evb.dtsi
index 2c3127167e3c2..d987d6741e40b 100644
--- a/arch/arm64/boot/dts/qcom/qcs404-evb.dtsi
+++ b/arch/arm64/boot/dts/qcom/qcs404-evb.dtsi
@@ -118,7 +118,7 @@
 		};
 
 		vreg_l3_1p05: l3 {
-			regulator-min-microvolt = <1050000>;
+			regulator-min-microvolt = <1048000>;
 			regulator-max-microvolt = <1160000>;
 		};
 
-- 
2.20.1



