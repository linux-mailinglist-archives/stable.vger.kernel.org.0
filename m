Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 637F16AF2F4
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbjCGS54 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:57:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231570AbjCGS5i (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:57:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 098D6B863F
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:45:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10D5EB818EB
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:45:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E82FC433D2;
        Tue,  7 Mar 2023 18:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214705;
        bh=mkvU2wlEMwNJJYoh/3n1OiSpTRZ1WNPSUojezGiE2sc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RqtKCszRqXv/vPabEGm3FvhDmQ50AZqcHfOiKts4IXm7zSUm2lEtkEpEp/3fSPRdZ
         MOB6Z9GK3FR965g68kIShAw3QHNFKGtgmu3DzJi+WPAkffTKbqgoGewgO8Mvtfxtu8
         M830aeZ5tDZszFtKE3Hl9BF0HGVU+zLasRNU8Zy4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Marijn Suijten <marijn.suijten@somainline.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 007/567] arm64: dts: qcom: sm8150-kumano: Panel framebuffer is 2.5k instead of 4k
Date:   Tue,  7 Mar 2023 17:55:43 +0100
Message-Id: <20230307165906.135577289@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marijn Suijten <marijn.suijten@somainline.org>

[ Upstream commit be8de06dc397c45cb0f3fe04084089c3f06c419f ]

The framebuffer configuration for kumano griffin, written in kumano dtsi
(which is overwritten in bahamut dts for its smaller panel) has to use a
1096x2560 configuration as this is what the panel (and framebuffer area)
has been initialized to.  Downstream userspace also has access to (and
uses) this 2.5k mode by default, and only switches the panel to 4k when
requested.

Fixes: d0a6ce59ea4e ("arm64: dts: qcom: sm8150: Add support for SONY Xperia 1 / 5 (Kumano platform)")
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221209191733.1458031-1-marijn.suijten@somainline.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8150-sony-xperia-kumano.dtsi | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8150-sony-xperia-kumano.dtsi b/arch/arm64/boot/dts/qcom/sm8150-sony-xperia-kumano.dtsi
index fb6e5a140c9f6..04c71f74ab72d 100644
--- a/arch/arm64/boot/dts/qcom/sm8150-sony-xperia-kumano.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8150-sony-xperia-kumano.dtsi
@@ -33,9 +33,10 @@ chosen {
 		framebuffer: framebuffer@9c000000 {
 			compatible = "simple-framebuffer";
 			reg = <0 0x9c000000 0 0x2300000>;
-			width = <1644>;
-			height = <3840>;
-			stride = <(1644 * 4)>;
+			/* Griffin BL initializes in 2.5k mode, not 4k */
+			width = <1096>;
+			height = <2560>;
+			stride = <(1096 * 4)>;
 			format = "a8r8g8b8";
 			/*
 			 * That's (going to be) a lot of clocks, but it's necessary due
-- 
2.39.2



