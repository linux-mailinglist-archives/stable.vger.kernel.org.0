Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B82E5E9A74
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 09:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234039AbiIZHdZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 03:33:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234074AbiIZHdX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 03:33:23 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9650B2228E
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 00:33:21 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id h3so6450327lja.1
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 00:33:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=bdmIJt6rQNjlh0yiDVLdX9e0561sbzxHw5aFIA/IaNo=;
        b=v79cy6oXnn6jFvsaen77Mg6VdE701cIGEaHuQTENaKPOGUgN9B7BSimv2dbnyULTr1
         /zKvGRHQYgZuaceUwXKyZ+TBqSHHNguVYPpScdrvDR5+40XaNOls7rfwOjyqmxidXKZl
         nyDSYayYQfBQJfq+FQPGsvpQUUzMfJ7/tr03QW22jNI+EmTXC+tpXGN3QStZCe15lpTL
         nx551+rzSYOKLyqRBPZhR0sOxEiwYpCnnjDChekA0IS2mv/7XPSGZBRcsyI8mtgV0jDC
         GbY/CWP3VHkDfo4l1/n3bgKsLlbJDfnSVQB+9070z9ftiMfjm/BH5ITCXszUztRuT5LL
         NhvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=bdmIJt6rQNjlh0yiDVLdX9e0561sbzxHw5aFIA/IaNo=;
        b=rlMemwChMSAQGrgVcOjTcj8ikih3+iUNotaCCmRiIOGYzNm9yGfwbMbKrTQiVM0xSD
         l4NLdcRWmWJuT7edNTW+N55X/mww5+DAxynrB4Jr4EeRd87sPs/qP9xvoa9xtSKoz2rF
         3nCaPrJPG7KuPCEOStiXWx8sYxI163FNn+WDWv6QIUB9wcnKRLju4dczeV0enDpxzXgq
         NMllsZ35iMqaLahJDWL6P/9QhsegfINvx3NxqzwFP9pOW80jPCVwFJzgIdKIgMxvpn3b
         LBIYGPnM0vvLMxKqeCDROn4SOi0/cfsW2XdpP1E3qiq+If22dwtVaxszrYJNqcxCjw//
         UtJw==
X-Gm-Message-State: ACrzQf0ETfGYtiWAvD5B5Ml5PCZukyZDKCr2r/Yd+LS4V19DLkW6UYSx
        +gQmZpYyca49A/bnwIfl6q7VoQ==
X-Google-Smtp-Source: AMsMyM6+bHOUKcKPn0fKD6bzf9pjyryrPSsSP+eheRR0ZtKMCuofYdlbGJLB+iKpVhBqQ6BwgXkt8Q==
X-Received: by 2002:a2e:8917:0:b0:26a:a520:db52 with SMTP id d23-20020a2e8917000000b0026aa520db52mr6804043lji.289.1664177599969;
        Mon, 26 Sep 2022 00:33:19 -0700 (PDT)
Received: from fedora.ideon.se ([85.235.10.227])
        by smtp.gmail.com with ESMTPSA id v12-20020a19740c000000b00497a2815d8dsm2442477lfe.195.2022.09.26.00.33.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 00:33:19 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     arm@kernel.org, soc@kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Christoph Hellwig <hch@lst.de>, Arnd Bergmann <arnd@arndb.de>,
        stable@vger.kernel.org
Subject: [PATCH v2] ARM: dts: integrator: Fix DMA ranges
Date:   Mon, 26 Sep 2022 09:33:11 +0200
Message-Id: <20220926073311.1610568-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A recent change affecting the behaviour of phys_to_dma() to
actually require the device tree ranges to work unmasked a
bug in the Integrator DMA ranges.

The PL110 uses the CMA allocator to obtain coherent allocations
from a dedicated 1MB video memory, leading to the following
call chain:

drm_gem_cma_create()
  dma_alloc_attrs()
    dma_alloc_from_dev_coherent()
      __dma_alloc_from_coherent()
        dma_get_device_base()
          phys_to_dma()
            translate_phys_to_dma()

phys_to_dma() by way of translate_phys_to_dma() will nowadays not
provide 1:1 mappings unless the ranges are properly defined in
the device tree and reflected into the dev->dma_range_map.

There is a bug in the device trees because the DMA ranges are
incorrectly specified, and the patch uncovers this bug.

Solution:

- Fix the LB (logic bus) ranges to be 1-to-1 like they should
  have always been.
- Provide a 1:1 dma-ranges attribute to the PL110.
- Mark the PL110 display controller as DMA coherent.

This makes the DMA ranges work right and makes the PL110
framebuffer work again.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: stable@vger.kernel.org
Fixes: af6f23b88e95 ("ARM/dma-mapping: use the generic versions of dma_to_phys/phys_to_dma by default")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- Drom dma-coherent, this device is not cache coherent
  whatsoever, just my misunderstanding.
- Change Fixes: tag to a hopefully more appropriate one.
- Update commit message.

SoC folks: please apply this directly for fixes if it seems
to be the right thing to do.
---
 arch/arm/boot/dts/integratorap-im-pd1.dts | 1 +
 arch/arm/boot/dts/integratorap.dts        | 8 ++++----
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/integratorap-im-pd1.dts b/arch/arm/boot/dts/integratorap-im-pd1.dts
index 31724753d3f3..14fab499f0fa 100644
--- a/arch/arm/boot/dts/integratorap-im-pd1.dts
+++ b/arch/arm/boot/dts/integratorap-im-pd1.dts
@@ -248,6 +248,7 @@ display@1000000 {
 		/* 640x480 16bpp @ 25.175MHz is 36827428 bytes/s */
 		max-memory-bandwidth = <40000000>;
 		memory-region = <&impd1_ram>;
+		dma-ranges;
 
 		port@0 {
 			#address-cells = <1>;
diff --git a/arch/arm/boot/dts/integratorap.dts b/arch/arm/boot/dts/integratorap.dts
index c983435ed492..9148287fa0a9 100644
--- a/arch/arm/boot/dts/integratorap.dts
+++ b/arch/arm/boot/dts/integratorap.dts
@@ -262,7 +262,7 @@ bus@c0000000 {
 		lm0: bus@c0000000 {
 			compatible = "simple-bus";
 			ranges = <0x00000000 0xc0000000 0x10000000>;
-			dma-ranges = <0x00000000 0x80000000 0x10000000>;
+			dma-ranges = <0x00000000 0xc0000000 0x10000000>;
 			reg = <0xc0000000 0x10000000>;
 			#address-cells = <1>;
 			#size-cells = <1>;
@@ -270,7 +270,7 @@ lm0: bus@c0000000 {
 		lm1: bus@d0000000 {
 			compatible = "simple-bus";
 			ranges = <0x00000000 0xd0000000 0x10000000>;
-			dma-ranges = <0x00000000 0x80000000 0x10000000>;
+			dma-ranges = <0x00000000 0xd0000000 0x10000000>;
 			reg = <0xd0000000 0x10000000>;
 			#address-cells = <1>;
 			#size-cells = <1>;
@@ -278,7 +278,7 @@ lm1: bus@d0000000 {
 		lm2: bus@e0000000 {
 			compatible = "simple-bus";
 			ranges = <0x00000000 0xe0000000 0x10000000>;
-			dma-ranges = <0x00000000 0x80000000 0x10000000>;
+			dma-ranges = <0x00000000 0xe0000000 0x10000000>;
 			reg = <0xe0000000 0x10000000>;
 			#address-cells = <1>;
 			#size-cells = <1>;
@@ -286,7 +286,7 @@ lm2: bus@e0000000 {
 		lm3: bus@f0000000 {
 			compatible = "simple-bus";
 			ranges = <0x00000000 0xf0000000 0x10000000>;
-			dma-ranges = <0x00000000 0x80000000 0x10000000>;
+			dma-ranges = <0x00000000 0xf0000000 0x10000000>;
 			reg = <0xf0000000 0x10000000>;
 			#address-cells = <1>;
 			#size-cells = <1>;
-- 
2.37.3

