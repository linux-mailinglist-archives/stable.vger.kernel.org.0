Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03AA0649EC9
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 13:34:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232171AbiLLMen (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 07:34:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232168AbiLLMeK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 07:34:10 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B1831277A
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 04:33:45 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id hd14-20020a17090b458e00b0021909875bccso13476977pjb.1
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 04:33:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9tZFt9KOuRAc3YbaSpnuN3NeGcAiDnj5wQSKgrmzEBE=;
        b=NgJfy3y1hxcURsOqlHdWS+iXmzermi8gevcmy7kSd5IFztlubqTi1w8oncpQZ95Esd
         M979Lh+21IH1kwZWSOZH2yxTsSuykgsoM7SkJQZP6WmvBi752JU2YwGhmR6MlNb+GT9H
         cEeENCFO/fuf8eEyCaiO6G38GYWw/mGpNBBO03360wE815rAF8u4FX1Hg0nxehWliJeo
         63PbPcqrRaun17whvOD8yYl7NgPzZeZTIn3aQSwzIjYjRsRjEdPQ+Ll+u4B3l7fcOMcE
         /lqjZrQYbUpTjEjLnGd6N+RC62W1v5V3ukN+m/KdL0u8MJaowC3cXv0ChtAP9xBdGmDx
         F7+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9tZFt9KOuRAc3YbaSpnuN3NeGcAiDnj5wQSKgrmzEBE=;
        b=xmj+51v1EJRaKfvKDlvQ0uP9R7rtwTq8qOFqoHBcTMOchiUxtMPrEwuJVjqA01mS/g
         CfWCjyupTlOyeoWveZLspKbcC/lbAeCNKQ9ny7PTEjAlTdixfnOviuzC0/6zwNVo76K9
         6bcXnslb0YvPXpz4hy8tIzYkK84GqvEKRjAkObJFDj383+Es8lOyYrOJhjwJSNS8ArKZ
         iCXtrI5aQvmQ0gTfXQF1GMvG0UTnfGGS6XtmxCuQwQ5P0cMvh0BRk77absRaLBsBl7iO
         /FTeGXOfmGVFWxMqkYVyhwcZrtXWMG8BCYFBgOcn9y51a39EZywKcAJLrgn9xs+/pUfT
         K/LQ==
X-Gm-Message-State: ANoB5pl7HXORSkPLWuxZx5Ov+WBC+IEeJXbeZ/RH7yx2C9b7U2f/2cWw
        iAwT+ZdN1eynznJ+DfzR52EG
X-Google-Smtp-Source: AA0mqf4ZO7xOmzA0pOR37AT59jPOz3Pbf+sfGigNiDnLJ7MxsEdWnhOZEtM/acfMFg3KN5mS/rC8PQ==
X-Received: by 2002:a17:902:9b8d:b0:186:605b:7527 with SMTP id y13-20020a1709029b8d00b00186605b7527mr15249024plp.48.1670848424742;
        Mon, 12 Dec 2022 04:33:44 -0800 (PST)
Received: from localhost.localdomain ([220.158.159.33])
        by smtp.gmail.com with ESMTPSA id j14-20020a170902da8e00b00189c93ce5easm6252557plx.166.2022.12.12.04.33.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 04:33:43 -0800 (PST)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     andersson@kernel.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, bp@alien8.de,
        tony.luck@intel.com
Cc:     quic_saipraka@quicinc.com, konrad.dybcio@linaro.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        james.morse@arm.com, mchehab@kernel.org, rric@kernel.org,
        linux-edac@vger.kernel.org, quic_ppareek@quicinc.com,
        luca.weiss@fairphone.com,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH v2 04/13] arm64: dts: qcom: sc7180: Remove reg-names property from LLCC node
Date:   Mon, 12 Dec 2022 18:03:02 +0530
Message-Id: <20221212123311.146261-5-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221212123311.146261-1-manivannan.sadhasivam@linaro.org>
References: <20221212123311.146261-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The LLCC block has several banks each with a different base address
and holes in between. So it is not a correct approach to cover these
banks with a single offset/size. Instead, the individual bank's base
address needs to be specified in devicetree with the exact size.

On SC7180, there is only one LLCC bank available. So only change needed is
to remove the reg-names property from LLCC node to conform to the binding.

The driver is expected to parse the reg field based on index to get the
addresses of each LLCC banks.

Cc: <stable@vger.kernel.org> # 5.6
Fixes: c831fa299996 ("arm64: dts: qcom: sc7180: Add Last level cache controller node")
Reported-by: Parikshit Pareek <quic_ppareek@quicinc.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 arch/arm64/boot/dts/qcom/sc7180.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7180.dtsi b/arch/arm64/boot/dts/qcom/sc7180.dtsi
index f71cf21a8dd8..b0d524bbf051 100644
--- a/arch/arm64/boot/dts/qcom/sc7180.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180.dtsi
@@ -2759,7 +2759,6 @@ dc_noc: interconnect@9160000 {
 		system-cache-controller@9200000 {
 			compatible = "qcom,sc7180-llcc";
 			reg = <0 0x09200000 0 0x50000>, <0 0x09600000 0 0x50000>;
-			reg-names = "llcc_base", "llcc_broadcast_base";
 			interrupts = <GIC_SPI 582 IRQ_TYPE_LEVEL_HIGH>;
 		};
 
-- 
2.25.1

