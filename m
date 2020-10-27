Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB6D29BBDF
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:31:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802714AbgJ0PvF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:51:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:43956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1802363AbgJ0Pqp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:46:45 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CF4122202;
        Tue, 27 Oct 2020 15:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813603;
        bh=iw0xB0davzaLJ4JvMSTJORI/V37yRkL7UqoVBjq6OPc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SHgzLLLavviqZ5rrb6fCSo21KwmQZcAomG3ldczbghOSdhgkr+hOEpTXWxDH2KEKX
         ybtJQs7dgFs5naYYRWNDjl/Be+WEEm+WpkQjhGLfKGlNYP2iuo1tu3GDI09+4eNiDu
         c8OCcXqFuUVxYzbKSDhKhocGnbmEfnKElAEB0xN0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephan Gerhold <stephan@gerhold.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 606/757] arm64: dts: qcom: pm8916: Remove invalid reg size from wcd_codec
Date:   Tue, 27 Oct 2020 14:54:16 +0100
Message-Id: <20201027135518.975822109@linuxfoundation.org>
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

From: Stephan Gerhold <stephan@gerhold.net>

[ Upstream commit c2f0cbb57dbac6da3d38b47b5b96de0fe4e23884 ]

Tha parent node of "wcd_codec" specifies #address-cells = <1>
and #size-cells = <0>, which means that each resource should be
described by one cell for the address and size omitted.

However, wcd_codec currently lists 0x200 as second cell (probably
the size of the resource). When parsing this would be treated like
another memory resource - which is entirely wrong.

To quote the device tree specification [1]:
  "If the parent node specifies a value of 0 for #size-cells,
   the length field in the value of reg shall be omitted."

[1]: https://www.devicetree.org/specifications/

Fixes: 5582fcb3829f ("arm64: dts: apq8016-sbc: add analog audio support with multicodec")
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Link: https://lore.kernel.org/r/20200915071221.72895-4-stephan@gerhold.net
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/pm8916.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/pm8916.dtsi b/arch/arm64/boot/dts/qcom/pm8916.dtsi
index 0bcdf04711079..adf9a5988cdc2 100644
--- a/arch/arm64/boot/dts/qcom/pm8916.dtsi
+++ b/arch/arm64/boot/dts/qcom/pm8916.dtsi
@@ -119,7 +119,7 @@ pm8916_vib: vibrator@c000 {
 
 		wcd_codec: codec@f000 {
 			compatible = "qcom,pm8916-wcd-analog-codec";
-			reg = <0xf000 0x200>;
+			reg = <0xf000>;
 			reg-names = "pmic-codec-core";
 			clocks = <&gcc GCC_CODEC_DIGCODEC_CLK>;
 			clock-names = "mclk";
-- 
2.25.1



