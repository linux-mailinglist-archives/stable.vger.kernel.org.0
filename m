Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64B0E6120D1
	for <lists+stable@lfdr.de>; Sat, 29 Oct 2022 08:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbiJ2G6k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Oct 2022 02:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiJ2G6j (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Oct 2022 02:58:39 -0400
Received: from mail.marcansoft.com (marcansoft.com [212.63.210.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B63A57B2A1;
        Fri, 28 Oct 2022 23:58:38 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 5355C41A36;
        Sat, 29 Oct 2022 06:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=marcan.st; s=default;
        t=1667026717; bh=F8W2GWWaQfsG1i1jYMpQNaDmIOB/dmx8gWHvOZLamdc=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To;
        b=AksB0uuH3gEWDI/ed5if0ziJPS8CrX8nGUSWMd8o2xDWksLM7rbZdFYSk0yTm89jK
         3uA3H9ZHNsW5kdAh/QE+j9vcC/wJq2dWsb4izlZRhUDF6WBvTp4anESeXscyL7pWBU
         rCFKXJ7Sv8t5ib7CrtrDfya38OrwV20B9NMl2hkyB7YxFQTJtR1LiLiO9JVowWOjND
         J4scjPNuY3x3Jx5VLme5/XYWuBcq9OTX3nq0uWzGyajFFr3bN/OPwtIwNVPlR1fOxr
         Kor0w+n9AMkQkE4MC4L+4XSsZd6T8zIicHHmiH4NsoLekl5yyswS7WvQkF4fRnIAyy
         RbZHrazED8fEA==
Message-ID: <40cf9da8-ce1e-4261-30b8-38580238c2b3@marcan.st>
Date:   Sat, 29 Oct 2022 15:58:32 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Content-Language: en-US
To:     Thomas Zimmermann <tzimmermann@suse.de>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Javier Martinez Canillas <javierm@redhat.com>
Cc:     Pekka Paalanen <pekka.paalanen@collabora.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, asahi@lists.linux.dev
References: <20221027135711.24425-1-marcan@marcan.st>
 <6102d131-fd3f-965b-cd52-d8d3286e0048@suse.de>
From:   Hector Martin <marcan@marcan.st>
Subject: Re: [PATCH v2] drm/format-helper: Only advertise supported formats
 for conversion
In-Reply-To: <6102d131-fd3f-965b-cd52-d8d3286e0048@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 28/10/2022 17.07, Thomas Zimmermann wrote:
> In yesterday's discussion on IRC, it was said that several devices 
> advertise ARGB framebuffers when the hardware actually uses XRGB? Is 
> there hardware that supports transparent primary planes?

ARGB hardware probably exists in the form of embedded systems with
preconfigured blending. For example, one could imagine an OSD-type setup
where there is a hardware video scaler controlled entirely outside of
DRM/KMS (probably by a horrible vendor driver), and the overlay
framebuffer is exposed via simpledrm as a dumb memory region, and
expects ARGB to work. So ideally, we wouldn't expose XRGB8888 on
ARGB8888 systems.

But there is this problem:

arch/arm64/boot/dts/qcom/msm8998-oneplus-common.dtsi:
   format = "a8r8g8b8";
arch/arm64/boot/dts/qcom/sdm630-sony-xperia-nile.dtsi:
   format = "a8r8g8b8";
arch/arm64/boot/dts/qcom/sdm660-xiaomi-lavender.dts:
   format = "a8r8g8b8";
arch/arm64/boot/dts/qcom/sdm845-shift-axolotl.dts:
format = "a8r8g8b8";
arch/arm64/boot/dts/qcom/sdm850-samsung-w737.dts:
format = "a8r8g8b8";
arch/arm64/boot/dts/qcom/sm6125-sony-xperia-seine-pdx201.dts:
           format = "a8r8g8b8";
arch/arm64/boot/dts/qcom/sm6350-sony-xperia-lena-pdx213.dts:
           format = "a8r8g8b8";
arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts:
format = "a8r8g8b8";
arch/arm64/boot/dts/qcom/sm8150-sony-xperia-kumano.dtsi:
   format = "a8r8g8b8";
arch/arm64/boot/dts/qcom/sm8250-sony-xperia-edo.dtsi:
   format = "a8r8g8b8";
arch/arm64/boot/dts/qcom/sm8350-sony-xperia-sagami.dtsi:
   format = "a8r8g8b8";
arch/arm64/boot/dts/socionext/uniphier-ld20-akebi96.dts:
format = "a8r8g8b8";

I'm pretty sure those phones don't have transparent screens, nor
magically put video planes below the firmware framebuffer. If there are
12 device trees for phones in mainline which lie about having alpha
support, who knows how many more exist outside? If we stop advertising
pretend-XRGB8888 on them, I suspect we're going to break a lot of
software...

Of course, there is one "correct" solution here: have an actual
xrgb8888->argb8888 conversion helper that just clears the high byte.
Then those platforms lying about having alpha and using xrgb8888 from
userspace will take a performace hit, but they should arguably just fix
their device tree in that case. Maybe this is the way to go in this
case? Note that there would be no inverse conversion (no advertising
argb8888 on xrgb8888 backends), so that one would be dropped vs. what we
have today. This effectively keeps the "xrgb8888 helpers and nothing
else" rule while actually supporting it for argb8888 backend
framebuffers correctly. Any platforms actually wanting to use argb8888
framebuffers with meaningful alpha should be configuring their userspace
to preferentially render directly to argb8888 to avoid the perf hit anyway.

- Hector
