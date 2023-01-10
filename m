Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E44F6664A4B
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234597AbjAJSb5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:31:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239328AbjAJSbE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:31:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC4DD50F67
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:26:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12AF2B81904
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:26:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F2C9C433D2;
        Tue, 10 Jan 2023 18:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375172;
        bh=tFJpC3OzyjxTaOOM9P1wVEp9VNvoDQokAB6nCxKJyCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tpo45Yr8KF9Q9RkL7Tk/MfdTZal/bgEx8umWOehgzfQ5/aTIZz6K0ifHfXJOvwbTD
         ogJP/oxjWhERdlB5uq5Wr5kGqZ0VSf4abgHEmBElyBH5+9LCsNojVyVOEeLx+3SR4M
         4oz+i0T3RuRTSOQ0tsIW0qKM22oxeSYWSTRvfqt8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Steev Klimaszewski <steev@kali.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 5.15 071/290] arm64: dts: qcom: sdm850-lenovo-yoga-c630: correct I2C12 pins drive strength
Date:   Tue, 10 Jan 2023 19:02:43 +0100
Message-Id: <20230110180034.087813063@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit fd49776d8f458bba5499384131eddc0b8bcaf50c upstream.

The pin configuration (done with generic pin controller helpers and
as expressed by bindings) requires children nodes with either:
1. "pins" property and the actual configuration,
2. another set of nodes with above point.

The qup_i2c12_default pin configuration used second method - with a
"pinmux" child.

Fixes: 44acee207844 ("arm64: dts: qcom: Add Lenovo Yoga C630")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Tested-by: Steev Klimaszewski <steev@kali.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20220930192039.240486-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
+++ b/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
@@ -475,8 +475,10 @@
 };
 
 &qup_i2c12_default {
-	drive-strength = <2>;
-	bias-disable;
+	pinmux {
+		drive-strength = <2>;
+		bias-disable;
+	};
 };
 
 &qup_uart6_default {


