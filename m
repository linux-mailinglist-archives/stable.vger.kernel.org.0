Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09EB63A630C
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233372AbhFNLIz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:08:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:39060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234791AbhFNLGw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:06:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 622D16144B;
        Mon, 14 Jun 2021 10:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667543;
        bh=7ys6ZJKH+Wz9SGxsaI3CUEtNvjkyrEdX0c3Ise/YfRI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r3Slia9HW1T4IArLAEeYn5RO4uBURpawY+79OEa04+0nhn+JOyFsMBLbfb4sFEhRl
         ig71JywjbDIV/8KgrPjVLMSwwCD7iIuYnkRNSTh5gVVhVndX5EJXSEtyI9v4ikIPC6
         PJo7Lkj4+FOrZk3gB60iOna6ZPsFpb+xeHK3d8L0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jerome Brunet <jbrunet@baylibre.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 110/131] ASoC: meson: gx-card: fix sound-dai dt schema
Date:   Mon, 14 Jun 2021 12:27:51 +0200
Message-Id: <20210614102656.741326333@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102652.964395392@linuxfoundation.org>
References: <20210614102652.964395392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jerome Brunet <jbrunet@baylibre.com>

commit d031d99b02eaf7363c33f5b27b38086cc8104082 upstream.

There is a fair amount of warnings when running 'make dtbs_check' with
amlogic,gx-sound-card.yaml.

Ex:
arch/arm64/boot/dts/amlogic/meson-gxm-q200.dt.yaml: sound: dai-link-0:sound-dai:0:1: missing phandle tag in 0
arch/arm64/boot/dts/amlogic/meson-gxm-q200.dt.yaml: sound: dai-link-0:sound-dai:0:2: missing phandle tag in 0
arch/arm64/boot/dts/amlogic/meson-gxm-q200.dt.yaml: sound: dai-link-0:sound-dai:0: [66, 0, 0] is too long

The reason is that the sound-dai phandle provided has cells, and in such
case the schema should use 'phandle-array' instead of 'phandle'.

Fixes: fd00366b8e41 ("ASoC: meson: gx: add sound card dt-binding documentation")
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://lore.kernel.org/r/20210524093448.357140-1-jbrunet@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/sound/amlogic,gx-sound-card.yaml |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/devicetree/bindings/sound/amlogic,gx-sound-card.yaml
+++ b/Documentation/devicetree/bindings/sound/amlogic,gx-sound-card.yaml
@@ -57,7 +57,7 @@ patternProperties:
           rate
 
       sound-dai:
-        $ref: /schemas/types.yaml#/definitions/phandle
+        $ref: /schemas/types.yaml#/definitions/phandle-array
         description: phandle of the CPU DAI
 
     patternProperties:
@@ -71,7 +71,7 @@ patternProperties:
 
         properties:
           sound-dai:
-            $ref: /schemas/types.yaml#/definitions/phandle
+            $ref: /schemas/types.yaml#/definitions/phandle-array
             description: phandle of the codec DAI
 
         required:


