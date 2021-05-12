Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD6437C419
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232353AbhELP2u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:28:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:60504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231835AbhELPWP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:22:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7203D6195B;
        Wed, 12 May 2021 15:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832143;
        bh=jvHHuGIIE4EqogEYLo/o5lyqYNqB7bePTncNn+JZBX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RwpbNyxnsFOrIGjeAzuYRNnMT/07zIjpP61QqZqgduyUpyRJ6CZ9Hwt9zV9zWsALB
         n9cJu7ScbNS4lrpfup6TXZ8MPNkntwz18yQFYO7cCtxLsbLgfJDmXP4NU2HkkICEkL
         G8f5xxmEXau5rTR+0qi+lBQCULtb9z7m9bRkJAa0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 160/530] arm64: dts: qcom: db845c: fix correct powerdown pin for WSA881x
Date:   Wed, 12 May 2021 16:44:30 +0200
Message-Id: <20210512144825.099918971@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit c561740e7cfefaf3003a256f3a0cd9f8a069137c ]

WSA881x powerdown pin is connected to GPIO1 not gpio2, so correct this.
This was working so far due to a shift bug in gpio driver, however
once that is fixed this will stop working, so fix this!

Fixes: 89a32a4e769cc ("arm64: dts: qcom: db845c: add analog audio support")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20210309102025.28405-1-srinivas.kandagatla@linaro.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-db845c.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
index c4ac6f5dc008..96d36b38f269 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
@@ -1015,7 +1015,7 @@
 		left_spkr: wsa8810-left{
 			compatible = "sdw10217201000";
 			reg = <0 1>;
-			powerdown-gpios = <&wcdgpio 2 GPIO_ACTIVE_HIGH>;
+			powerdown-gpios = <&wcdgpio 1 GPIO_ACTIVE_HIGH>;
 			#thermal-sensor-cells = <0>;
 			sound-name-prefix = "SpkrLeft";
 			#sound-dai-cells = <0>;
@@ -1023,7 +1023,7 @@
 
 		right_spkr: wsa8810-right{
 			compatible = "sdw10217201000";
-			powerdown-gpios = <&wcdgpio 2 GPIO_ACTIVE_HIGH>;
+			powerdown-gpios = <&wcdgpio 1 GPIO_ACTIVE_HIGH>;
 			reg = <0 2>;
 			#thermal-sensor-cells = <0>;
 			sound-name-prefix = "SpkrRight";
-- 
2.30.2



