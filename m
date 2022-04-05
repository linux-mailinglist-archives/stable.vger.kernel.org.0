Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 849CA4F34F1
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355966AbiDEKW3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:22:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238271AbiDEJ3O (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:29:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A662E124F;
        Tue,  5 Apr 2022 02:16:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23569B80DA1;
        Tue,  5 Apr 2022 09:16:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84D4CC385A3;
        Tue,  5 Apr 2022 09:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150192;
        bh=OetyBOk4mrcK+T3SRboB5bEBJ2oi11RtEDB8Da2zZ5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LJ9mrAwjm0bxOJ2n5rYPJ6ZN2Dkpz7M7OwNTOzlpruytZYMg817M/fHIsH64jBtP8
         NgJoiZj6Rt3c+k1vHj9UiCXV9GvjdkG90oyzcMO0+6XWDb3PUMPgGHk+7kFrcVvN/n
         lXgoJWXsZHxWhxq1UNicGJ9MXeb+uOKrMZQ9nfh4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yong Wu <yong.wu@mediatek.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: [PATCH 5.16 0987/1017] dt-bindings: memory: mtk-smi: No need mediatek,larb-id for mt8167
Date:   Tue,  5 Apr 2022 09:31:40 +0200
Message-Id: <20220405070423.500167678@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yong Wu <yong.wu@mediatek.com>

commit ddc3a324889686ec9b358de20fdeec0d2668c7a8 upstream.

Mute the warning from "make dtbs_check":

larb@14016000: 'mediatek,larb-id' is a required property
	arch/arm64/boot/dts/mediatek/mt8167-pumpkin.dt.yaml
larb@15001000: 'mediatek,larb-id' is a required property
	arch/arm64/boot/dts/mediatek/mt8167-pumpkin.dt.yaml
larb@16010000: 'mediatek,larb-id' is a required property
	arch/arm64/boot/dts/mediatek/mt8167-pumpkin.dt.yaml

As the description of mediatek,larb-id, the property is only
required when the larbid is not consecutive from its IOMMU point of view.

Also, from the description of mediatek,larbs in
Documentation/devicetree/bindings/iommu/mediatek,iommu.yaml, all the larbs
must sort by the larb index.

In mt8167, there is only one IOMMU HW and three larbs. The drivers already
know its larb index from the mediatek,larbs property of IOMMU, thus no
need this property.

Fixes: 27bb0e42855a ("dt-bindings: memory: mediatek: Convert SMI to DT schema")
Signed-off-by: Yong Wu <yong.wu@mediatek.com>
Acked-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20220113111057.29918-3-yong.wu@mediatek.com
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/memory-controllers/mediatek,smi-larb.yaml |    1 -
 1 file changed, 1 deletion(-)

--- a/Documentation/devicetree/bindings/memory-controllers/mediatek,smi-larb.yaml
+++ b/Documentation/devicetree/bindings/memory-controllers/mediatek,smi-larb.yaml
@@ -106,7 +106,6 @@ allOf:
               - mediatek,mt2701-smi-larb
               - mediatek,mt2712-smi-larb
               - mediatek,mt6779-smi-larb
-              - mediatek,mt8167-smi-larb
               - mediatek,mt8192-smi-larb
               - mediatek,mt8195-smi-larb
 


