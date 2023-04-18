Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 223676E64C8
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232181AbjDRMwh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232213AbjDRMwZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:52:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E115D16FAF
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:52:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1BE963419
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:52:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7BD6C433EF;
        Tue, 18 Apr 2023 12:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822320;
        bh=7sJ3RB/VcGqjzA38chrxHOX01i4exNYmqIGHFI8aKOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E0vLthOQlsqFzOOFvhQVbd/zL3Qhjo5dOfFf0wQRjOA0ElrCKZLDvyD0uQ04PCtMQ
         Wcp5A09H10EPfvI7miZDZ4j/eufjHN+5KvIaa9xgD8QcbJw4Bc2mVbyI7q+qKlrTxp
         l71xUHi73htSvZlN9IpiDrdykaStKsyEgMQ8+eRY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Luca Weiss <luca@z3ntu.xyz>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 076/139] ARM: dts: qcom: apq8026-lg-lenok: add missing reserved memory
Date:   Tue, 18 Apr 2023 14:22:21 +0200
Message-Id: <20230418120316.693763921@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luca Weiss <luca@z3ntu.xyz>

[ Upstream commit ecd240875e877d78fd03efbc62292f550872df3f ]

Turns out these two memory regions also need to be avoided, otherwise
weird things will happen when Linux tries to use this memory.

Signed-off-by: Luca Weiss <luca@z3ntu.xyz>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230308-lenok-reserved-memory-v1-1-b8bf6ff01207@z3ntu.xyz
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom-apq8026-lg-lenok.dts | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/qcom-apq8026-lg-lenok.dts b/arch/arm/boot/dts/qcom-apq8026-lg-lenok.dts
index de2fb1c01b6e3..b82381229adf6 100644
--- a/arch/arm/boot/dts/qcom-apq8026-lg-lenok.dts
+++ b/arch/arm/boot/dts/qcom-apq8026-lg-lenok.dts
@@ -27,6 +27,16 @@
 	};
 
 	reserved-memory {
+		sbl_region: sbl@2f00000 {
+			reg = <0x02f00000 0x100000>;
+			no-map;
+		};
+
+		external_image_region: external-image@3100000 {
+			reg = <0x03100000 0x200000>;
+			no-map;
+		};
+
 		adsp_region: adsp@3300000 {
 			reg = <0x03300000 0x1400000>;
 			no-map;
-- 
2.39.2



