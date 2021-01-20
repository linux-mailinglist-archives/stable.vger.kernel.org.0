Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10F9E2FD6F1
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 18:33:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387646AbhATOIb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 20 Jan 2021 09:08:31 -0500
Received: from aposti.net ([89.234.176.197]:49048 "EHLO aposti.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731970AbhATNW0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Jan 2021 08:22:26 -0500
Date:   Wed, 20 Jan 2021 13:21:29 +0000
From:   Paul Cercueil <paul@crapouillou.net>
Subject: Re: [PATCH v2 2/3] drm/ingenic: Register devm action to cleanup
 encoders
To:     Daniel Vetter <daniel@ffwll.ch>
Cc:     David Airlie <airlied@linux.ie>, Sam Ravnborg <sam@ravnborg.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        od@zcrc.me, dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Message-Id: <TFI8NQ.468S4PLHPA963@crapouillou.net>
In-Reply-To: <CAKMK7uFaP7xcw90=KqiGJd7Mt-gD-spvcxvOZr2Txhyv5vcBvw@mail.gmail.com>
References: <20210120123535.40226-1-paul@crapouillou.net>
        <20210120123535.40226-3-paul@crapouillou.net>
        <CAKMK7uFaP7xcw90=KqiGJd7Mt-gD-spvcxvOZr2Txhyv5vcBvw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Le mer. 20 janv. 2021 � 14:01, Daniel Vetter <daniel@ffwll.ch> a 
�crit :
> On Wed, Jan 20, 2021 at 1:36 PM Paul Cercueil <paul@crapouillou.net> 
> wrote:
>> 
>>  Since the encoders have been devm-allocated, they will be freed way
>>  before drm_mode_config_cleanup() is called. To avoid use-after-free
>>  conditions, we then must ensure that drm_encoder_cleanup() is called
>>  before the encoders are freed.
>> 
>>  v2: Use the new __drmm_simple_encoder_alloc() function
>> 
>>  Fixes: c369cb27c267 ("drm/ingenic: Support multiple panels/bridges")
>>  Cc: <stable@vger.kernel.org> # 5.8+
>>  Signed-off-by: Paul Cercueil <paul@crapouillou.net>
>>  ---
>> 
>>  Notes:
>>      Use the V1 of this patch to fix v5.11 and older kernels. This 
>> V2 only
>>      applies on the current drm-misc-next branch.
>> 
>>   drivers/gpu/drm/ingenic/ingenic-drm-drv.c | 16 +++++++---------
>>   1 file changed, 7 insertions(+), 9 deletions(-)
>> 
>>  diff --git a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c 
>> b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
>>  index 7bb31fbee29d..158433b4c084 100644
>>  --- a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
>>  +++ b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
>>  @@ -1014,20 +1014,18 @@ static int ingenic_drm_bind(struct device 
>> *dev, bool has_components)
>>                          bridge = 
>> devm_drm_panel_bridge_add_typed(dev, panel,
>>                                                                   
>> DRM_MODE_CONNECTOR_DPI);
>> 
>>  -               encoder = devm_kzalloc(dev, sizeof(*encoder), 
>> GFP_KERNEL);
>>  -               if (!encoder)
>>  -                       return -ENOMEM;
>>  +               encoder = __drmm_simple_encoder_alloc(drm, 
>> sizeof(*encoder), 0,
> 
> Please don't use the __ prefixed functions, those are the internal
> ones. The official one comes with type checking and all that included.
> Otherwise lgtm.
> -Daniel

The non-prefixed one assumes that I want to allocate a struct that 
contains the encoder, not just the drm_encoder itself.

-Paul

>>  +                                                     
>> DRM_MODE_ENCODER_DPI);
>>  +               if (IS_ERR(encoder)) {
>>  +                       ret = PTR_ERR(encoder);
>>  +                       dev_err(dev, "Failed to init encoder: 
>> %d\n", ret);
>>  +                       return ret;
>>  +               }
>> 
>>                  encoder->possible_crtcs = 1;
>> 
>>                  drm_encoder_helper_add(encoder, 
>> &ingenic_drm_encoder_helper_funcs);
>> 
>>  -               ret = drm_simple_encoder_init(drm, encoder, 
>> DRM_MODE_ENCODER_DPI);
>>  -               if (ret) {
>>  -                       dev_err(dev, "Failed to init encoder: 
>> %d\n", ret);
>>  -                       return ret;
>>  -               }
>>  -
>>                  ret = drm_bridge_attach(encoder, bridge, NULL, 0);
>>                  if (ret) {
>>                          dev_err(dev, "Unable to attach bridge\n");
>>  --
>>  2.29.2
>> 
> 
> 
> --
> Daniel Vetter
> Software Engineer, Intel Corporation
> http://blog.ffwll.ch


