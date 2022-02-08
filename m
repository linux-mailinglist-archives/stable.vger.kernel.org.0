Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D92084AD44F
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 10:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245035AbiBHJEF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 04:04:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237702AbiBHJEE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 04:04:04 -0500
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EF63C03FEC0;
        Tue,  8 Feb 2022 01:04:03 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: kholk11)
        with ESMTPSA id 5ED6B1F4474E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1644311042;
        bh=9sgJPXTqfK75Hu2kDZUDOsgZGJfuQ/MhsF+51PqY9d8=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=cxeCpY9JpTWim2lNGoN3hul0SMhHdA/NQydI8he7rdyfhWY7N9QUuad1cg8/AY4EW
         E55D03ZuSDgOfbQo4tRF+hDHOQ2ew1uqD3KM63YuMNQjiS/tdWjLKKh5/1VY6lipsm
         qEdIcTrFzLViuTltNWGVYE8IksuFoKoGdyXIw0n6DgNseDxH9jb+vFIbW3bvH6kAK4
         gWmHxHi/8YMCppgoaUyjEncsnx7jK9hhehV6oZp0HyEw37HccDD37SONlwwcufc+KW
         O4YMvTxxPVG/z2Sxymn98QaaU75LOL234XZt1qXP0oqe2GItnewSEEqfgAVwFpELgh
         lmXub2km4nYnQ==
Message-ID: <bf486a23-4322-328e-abdc-962a66792f23@collabora.com>
Date:   Tue, 8 Feb 2022 10:03:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v4] drm/mediatek: mtk_dsi: Avoid EPROBE_DEFER loop with
 external bridge
Content-Language: en-US
To:     CK Hu <ck.hu@mediatek.com>, dri-devel@lists.freedesktop.org
Cc:     chunkuang.hu@kernel.org, airlied@linux.ie,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        andrzej.hajda@intel.com, linux-mediatek@lists.infradead.org,
        Jagan Teki <jagan@amarulasolutions.com>,
        matthias.bgg@gmail.com, kernel@collabora.com,
        linux-arm-kernel@lists.infradead.org
References: <20220131085520.287105-1-angelogioacchino.delregno@collabora.com>
 <20755168cc2be0d1bb5e40907cfe27cea25a9363.camel@mediatek.com>
 <b886b9a8a3368127be7357e8921e18358987033d.camel@mediatek.com>
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
In-Reply-To: <b886b9a8a3368127be7357e8921e18358987033d.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Il 08/02/22 09:32, CK Hu ha scritto:
> Hi, Angelo:
> 
> On Tue, 2022-02-08 at 16:20 +0800, CK Hu wrote:
>> Hi, Angelo:
>>
>> On Mon, 2022-01-31 at 09:55 +0100, AngeloGioacchino Del Regno wrote:
>>> DRM bridge drivers are now attaching their DSI device at probe
>>> time,
>>> which requires us to register our DSI host in order to let the
>>> bridge
>>> to probe: this recently started producing an endless -EPROBE_DEFER
>>> loop on some machines that are using external bridges, like the
>>> parade-ps8640, found on the ACER Chromebook R13.
>>>
>>> Now that the DSI hosts/devices probe sequence is documented, we can
>>> do adjustments to the mtk_dsi driver as to both fix now and make
>>> sure
>>> to avoid this situation in the future: for this, following what is
>>> documented in drm_bridge.c, move the mtk_dsi component_add() to the
>>> mtk_dsi_ops.attach callback and delete it in the detach callback;
>>> keeping in mind that we are registering a drm_bridge for our DSI,
>>> which is only used/attached if the DSI Host is bound, it wouldn't
>>> make sense to keep adding our bridge at probe time (as it would
>>> be useless to have it if mtk_dsi_ops.attach() fails!), so also move
>>> that one to the dsi host attach function (and remove it in detach).
>>>
>>> Cc: <stable@vger.kernel.org> # 5.15.x
>>> Signed-off-by: AngeloGioacchino Del Regno <
>>> angelogioacchino.delregno@collabora.com>
>>> Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>
>>> Reviewed-by: Jagan Teki <jagan@amarulasolutions.com>
>>>
>>> ---
>>>   drivers/gpu/drm/mediatek/mtk_dsi.c | 167 +++++++++++++++----------
>>> ----
>>>   1 file changed, 84 insertions(+), 83 deletions(-)
>>>
>>> diff --git a/drivers/gpu/drm/mediatek/mtk_dsi.c
>>> b/drivers/gpu/drm/mediatek/mtk_dsi.c
>>> index 5d90d2eb0019..bced4c7d668e 100644
>>> --- a/drivers/gpu/drm/mediatek/mtk_dsi.c
>>> +++ b/drivers/gpu/drm/mediatek/mtk_dsi.c
>>> @@ -786,18 +786,101 @@ void mtk_dsi_ddp_stop(struct device *dev)
>>>   	mtk_dsi_poweroff(dsi);
>>>   }
>>>   
>>>
>>
>> [snip]
>>
>>> +
>>>   static int mtk_dsi_host_attach(struct mipi_dsi_host *host,
>>>   			       struct mipi_dsi_device *device)
>>>   {
>>>   	struct mtk_dsi *dsi = host_to_dsi(host);
>>> +	struct device *dev = host->dev;
>>> +	int ret;
>>>   
>>>   	dsi->lanes = device->lanes;
>>>   	dsi->format = device->format;
>>>   	dsi->mode_flags = device->mode_flags;
>>> +	dsi->next_bridge = devm_drm_of_get_bridge(dev, dev->of_node, 0,
>>> 0);
>>
>> The original would process panel. Why do you remove the panel part?
>> It's better that someone has a platform of DSI->Panel to test this
>> patch.
> 
> Sorry, devm_drm_of_get_bridge() has processed the panel part, so for
> this patch,
> 
> Reviewed-by: CK Hu <ck.hu@mediatek.com>
> 

No worries! Thanks for the review/approval.

Regards,
Angelo

>>
>> Regards,
>> CK
>>
