Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D88C9657990
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:03:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233469AbiL1PDB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:03:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233491AbiL1PCc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:02:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D858813CCC
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:02:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72DA66153C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:02:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F934C433F0;
        Wed, 28 Dec 2022 15:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239740;
        bh=GvYOdyMW2LWb4c+OOOy02McPr3TdKMze3wjftwhEmvA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hQnuD57XA2IJ6ys3StSjRc8aLtwnBs0NtqAr6nriXNSuoE4mOl+HQyYVd24tM7SBr
         AFrWElI26161Tlw1wbrvoMDI+D+q02IYEhEOEksPXsGWlmuO0vRJXDn3gdjsKtPTNs
         sPc1o87Ymy0MtF9sLWZzNSNzvc3tyItW2d8Bv70o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0034/1146] arm64: dts: qcom: sc7280: fix codec reset line polarity for CRD 1.0/2.0
Date:   Wed, 28 Dec 2022 15:26:13 +0100
Message-Id: <20221228144331.093984203@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit b8f298d4f69d82119ac0d22809a17c80b1f188d1 ]

The driver for the codec, when resetting the chip, first drives the line
low, and then high. This means that the line is active low. Change the
annotation in the DTS accordingly.

Fixes: f8b4eb64f200 ("arm64: dts: qcom: sc7280: Add wcd9385 codec node for CRD 1.0/2.0 and IDP boards")
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221027074652.1044235-5-dmitry.torokhov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7280-idp.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7280-idp.dtsi b/arch/arm64/boot/dts/qcom/sc7280-idp.dtsi
index cd432a2856a7..7772dfba94ec 100644
--- a/arch/arm64/boot/dts/qcom/sc7280-idp.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280-idp.dtsi
@@ -34,7 +34,7 @@ wcd9385: audio-codec-1 {
 		pinctrl-0 = <&wcd_reset_n>;
 		pinctrl-1 = <&wcd_reset_n_sleep>;
 
-		reset-gpios = <&tlmm 83 GPIO_ACTIVE_HIGH>;
+		reset-gpios = <&tlmm 83 GPIO_ACTIVE_LOW>;
 
 		qcom,rx-device = <&wcd_rx>;
 		qcom,tx-device = <&wcd_tx>;
-- 
2.35.1



