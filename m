Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 414302FA9CA
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 20:12:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437170AbhARTLZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 18 Jan 2021 14:11:25 -0500
Received: from aposti.net ([89.234.176.197]:38822 "EHLO aposti.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390494AbhARLiv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:38:51 -0500
Date:   Mon, 18 Jan 2021 11:37:49 +0000
From:   Paul Cercueil <paul@crapouillou.net>
Subject: Re: [PATCH 2/3] drm/ingenic: Register devm action to cleanup encoders
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org, od@zcrc.me,
        dri-devel@lists.freedesktop.org, Sam Ravnborg <sam@ravnborg.org>
Message-Id: <1BO4NQ.1RZAXLMVC01T@crapouillou.net>
In-Reply-To: <YAVYUzR9+ic5lEjE@pendragon.ideasonboard.com>
References: <20210117112646.98353-1-paul@crapouillou.net>
        <20210117112646.98353-3-paul@crapouillou.net>
        <YAVYUzR9+ic5lEjE@pendragon.ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Laurent,

Le lun. 18 janv. 2021 à 11:43, Laurent Pinchart 
<laurent.pinchart@ideasonboard.com> a écrit :
> Hi Paul,
> 
> Thank you for the patch.
> 
> On Sun, Jan 17, 2021 at 11:26:45AM +0000, Paul Cercueil wrote:
>>  Since the encoders have been devm-allocated, they will be freed way
>>  before drm_mode_config_cleanup() is called. To avoid use-after-free
>>  conditions, we then must ensure that drm_encoder_cleanup() is called
>>  before the encoders are freed.
> 
> How about allocating the encoder with drmm_encoder_alloc() instead ?

That would work, but it is not yet in drm-misc-fixes :(

-Paul

>>  Fixes: c369cb27c267 ("drm/ingenic: Support multiple panels/bridges")
>>  Cc: <stable@vger.kernel.org> # 5.8+
>>  Signed-off-by: Paul Cercueil <paul@crapouillou.net>
>>  ---
>>   drivers/gpu/drm/ingenic/ingenic-drm-drv.c | 10 ++++++++++
>>   1 file changed, 10 insertions(+)
>> 
>>  diff --git a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c 
>> b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
>>  index 368bfef8b340..d23a3292a0e0 100644
>>  --- a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
>>  +++ b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
>>  @@ -803,6 +803,11 @@ static void __maybe_unused 
>> ingenic_drm_release_rmem(void *d)
>>   	of_reserved_mem_device_release(d);
>>   }
>> 
>>  +static void ingenic_drm_encoder_cleanup(void *encoder)
>>  +{
>>  +	drm_encoder_cleanup(encoder);
>>  +}
>>  +
>>   static int ingenic_drm_bind(struct device *dev, bool 
>> has_components)
>>   {
>>   	struct platform_device *pdev = to_platform_device(dev);
>>  @@ -1011,6 +1016,11 @@ static int ingenic_drm_bind(struct device 
>> *dev, bool has_components)
>>   			return ret;
>>   		}
>> 
>>  +		ret = devm_add_action_or_reset(dev, ingenic_drm_encoder_cleanup,
>>  +					       encoder);
>>  +		if (ret)
>>  +			return ret;
>>  +
>>   		ret = drm_bridge_attach(encoder, bridge, NULL, 0);
>>   		if (ret) {
>>   			dev_err(dev, "Unable to attach bridge\n");
> 
> --
> Regards,
> 
> Laurent Pinchart


