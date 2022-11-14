Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE91627D23
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 12:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237047AbiKNL4v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 06:56:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236888AbiKNL4e (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 06:56:34 -0500
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E86BC2529E;
        Mon, 14 Nov 2022 03:52:37 -0800 (PST)
Received: from [192.168.1.100] (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: kholk11)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id CF4FC66016A3;
        Mon, 14 Nov 2022 11:52:35 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1668426756;
        bh=UqXyw29d9gHmZnTaWA17qjx/3BT/it1DZWozqZjgUvE=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=CuXf2ZA1/Pk4AOO7DSTFEFFFgfULvaPQy0MLLwqgYUgWYqGetFd62NuDx0rNIJDTA
         lF4Pe54GLAHRsaUIrgKFVdfrXJO8QefoOFcJYzZrEx/Ou0of7YUyCcUXHTyGmt1fAI
         EfyEBvzDKFjyMgpZ9ohUJj2NysUq7yqqOXF0WESNaBNCAYBUGon6cqukg/LGeFP3U6
         lGe3MIDd4cvUJBSMWIw2sQdgxdTmJyDKZPQZmLQtOGv7W/Y1bqrj1ZkcuEbE78qAKc
         1x8l5sguUYXjAIimfVCztPTnQB1SFYyNqjxAJvA9X8votiJRbDLjaE6b/ztyJ0T6qM
         KJ7XuFKE63m0A==
Message-ID: <70108911-4934-170f-8e66-ed2ff7d63be5@collabora.com>
Date:   Mon, 14 Nov 2022 12:52:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [RESEND PATCH v2] arm64: dts: mediatek: mt8195-demo: fix the
 memory size of node secmon
Content-Language: en-US
To:     Macpaul Lin <macpaul.lin@mediatek.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Fabien Parent <fparent@baylibre.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Miles Chen <miles.chen@mediatek.com>,
        Bear Wang <bear.wang@mediatek.com>,
        Pablo Sun <pablo.sun@mediatek.com>,
        Mediatek WSD Upstream <wsd_upstream@mediatek.com>,
        Macpaul Lin <macpaul@gmail.com>, linux-usb@vger.kernel.org,
        stable@vger.kernel.org
References: <20221111095540.28881-1-macpaul.lin@mediatek.com>
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
In-Reply-To: <20221111095540.28881-1-macpaul.lin@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Il 11/11/22 10:55, Macpaul Lin ha scritto:
> The size of device tree node secmon (bl31_secmon_reserved) was
> incorrect. It should be increased to 2MiB (0x200000).
> 
> The origin setting will cause some abnormal behavior due to
> trusted-firmware-a and related firmware didn't load correctly.
> The incorrect behavior may vary because of different software stacks.
> For example, it will cause build error in some Yocto project because
> it will check if there was enough memory to load trusted-firmware-a
> to the reserved memory.
> 
> When mt8195-demo.dts sent to the upstream, at that time the size of
> BL31 was small. Because supported functions and modules in BL31 are
> basic sets when the board was under early development stage.
> 
> Now BL31 includes more firmwares of coprocessors and maturer functions
> so the size has grown bigger in real applications. According to the value
> reported by customers, we think reserved 2MiB for BL31 might be enough
> for maybe the following 2 or 3 years.
> 
> Cc: stable@vger.kernel.org      # v5.19
> Fixes: 6147314aeedc ("arm64: dts: mediatek: Add device-tree for MT8195 Demo board")
> Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
> Reviewed-by: Miles Chen <miles.chen@mediatek.com>

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>


