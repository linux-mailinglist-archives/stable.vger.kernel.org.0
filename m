Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E449A59B657
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 22:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbiHUUkb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Aug 2022 16:40:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231429AbiHUUka (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Aug 2022 16:40:30 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE0FB20BD8;
        Sun, 21 Aug 2022 13:40:29 -0700 (PDT)
Received: from [10.3.2.13] (zone.collabora.co.uk [167.235.23.81])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: dmitry.osipenko)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 9DE24660036A;
        Sun, 21 Aug 2022 21:40:26 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1661114427;
        bh=Z2il1kngXjDQKOBuq7K0dhVJT9L7d/e1zgH7CmQvLiU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=k71g0emvhmeKjwzAJT0z95v48M3tVfuLio8KPqccCNWQquJrRIab1N9SHrGBlm89L
         K7R86aNuryNXJhbfMdnkikx8maiRNlGhy7FdP1zilan2I+MohRvMctXrlu8KBho13d
         CpvWSoJyUzlIdJNoliIhJYgcsFkCRzxdjizaAu4nIgurIpG+kz2AQjDVrXmxmDzr8J
         LGmxgeNrFqS6oKTPOCfvd2HhBy2biikeWeJ9U3LFBQBAYDsE3y/6ZM5yeFbyGSSBup
         xRj1ETKHiR1uDUYVMK0VRrlzLGXonvsP/PXgT2nIr8VCm7QNW6AJpQ9uFJ/qUpXO25
         gtmh0j3uElVEg==
Message-ID: <6a8f2555-1bd4-ac81-390e-b597e3c886f6@collabora.com>
Date:   Sun, 21 Aug 2022 23:40:21 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v1 2/3] media: cedrus: Set the platform driver data
 earlier
Content-Language: en-US
To:     =?UTF-8?Q?Jernej_=c5=a0krabec?= <jernej.skrabec@gmail.com>,
        linux-media@vger.kernel.org, Maxime Ripard <mripard@kernel.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Samuel Holland <samuel@sholland.org>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>
Cc:     kernel@collabora.com, stable@vger.kernel.org,
        linux-staging@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
        linux-kernel@vger.kernel.org
References: <20220818203308.439043-1-nicolas.dufresne@collabora.com>
 <4418189.LvFx2qVVIh@jernej-laptop>
 <47ce07adc73887b5afaf9815a78b793d0e9a6b54.camel@collabora.com>
 <4733096.GXAFRqVoOG@jernej-laptop>
From:   Dmitry Osipenko <dmitry.osipenko@collabora.com>
In-Reply-To: <4733096.GXAFRqVoOG@jernej-laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/20/22 11:25, Jernej Škrabec wrote:
> Dne petek, 19. avgust 2022 ob 17:37:20 CEST je Nicolas Dufresne napisal(a):
>> Le vendredi 19 août 2022 à 06:17 +0200, Jernej Škrabec a écrit :
>>> Dne četrtek, 18. avgust 2022 ob 22:33:07 CEST je Nicolas Dufresne 
> napisal(a):
>>>> From: Dmitry Osipenko <dmitry.osipenko@collabora.com>
>>>>
>>>> The cedrus_hw_resume() crashes with NULL deference on driver probe if
>>>> runtime PM is disabled because it uses platform data that hasn't been
>>>> set up yet. Fix this by setting the platform data earlier during probe.
>>>
>>> Does it even work without PM? Maybe it would be better if Cedrus would
>>> select PM in Kconfig.
>>
>> I cannot comment myself on this, but it does not seem to invalidate this
>> Dmitry's fix.
> 
> If NULL pointer dereference happens only when PM is disabled, then it does. I 
> have PM always enabled and I never experienced above issue.

Originally this fix was needed when I changed cedrus_hw_probe() to do
the rpm-resume while was debugging the hang issue and then also noticed
that the !PM should be broken. It's a good common practice for all
drivers to have the drv data set early to avoid such problems, hence it
won't hurt to make this change anyways.

In practice nobody disables PM other than for debugging purposes and !PM
handling is often broken in drivers. I assume that it might be even
better to enable PM for all Allwiner SoCs and remove !PM handling from
all the affected drivers, like it was done for Tegra some time ago.

-- 
Best regards,
Dmitry
