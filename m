Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A34BC34E6EB
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 13:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231872AbhC3Lxt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 30 Mar 2021 07:53:49 -0400
Received: from aposti.net ([89.234.176.197]:58464 "EHLO aposti.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231434AbhC3Lxb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Mar 2021 07:53:31 -0400
Date:   Tue, 30 Mar 2021 12:53:04 +0100
From:   Paul Cercueil <paul@crapouillou.net>
Subject: Re: [PATCH 1/2] drm/ingenic: Switch IPU plane to type OVERLAY
To:     Simon Ser <contact@emersion.fr>
Cc:     David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sam Ravnborg <sam@ravnborg.org>, od@zcrc.me,
        linux-mips@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Message-Id: <GC6SQQ.1R937FBY9A9A1@crapouillou.net>
In-Reply-To: <BH3N8QICMyp64pmUQyXLwYMnCNBvXxThwvKJIOmyMU0XIgTtorcGd7s7AjnIFXQrLGEoJMuvPcWTiv38syiYOTCDv-bSxswFBX6y3UYqTwE=@emersion.fr>
References: <20210329175046.214629-1-paul@crapouillou.net>
        <20210329175046.214629-2-paul@crapouillou.net>
        <BH3N8QICMyp64pmUQyXLwYMnCNBvXxThwvKJIOmyMU0XIgTtorcGd7s7AjnIFXQrLGEoJMuvPcWTiv38syiYOTCDv-bSxswFBX6y3UYqTwE=@emersion.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Simon,

Le mar. 30 mars 2021 à 7:23, Simon Ser <contact@emersion.fr> a écrit :
>>  It should have been an OVERLAY from the beginning. The documentation
>>  stipulates that there should be an unique PRIMARY plane per CRTC.
> 
> Thanks for the quick patch! One comment below…
> 
>>  Fixes: fc1acf317b01 ("drm/ingenic: Add support for the IPU")
>>  Cc: <stable@vger.kernel.org> # 5.8+
>>  Signed-off-by: Paul Cercueil <paul@crapouillou.net>
>>  ---
>>   drivers/gpu/drm/ingenic/ingenic-drm-drv.c | 11 +++++------
>>   drivers/gpu/drm/ingenic/ingenic-ipu.c     |  2 +-
>>   2 files changed, 6 insertions(+), 7 deletions(-)
>> 
>>  diff --git a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c 
>> b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
>>  index 29742ec5ab95..09225b770bb8 100644
>>  --- a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
>>  +++ b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
>>  @@ -419,7 +419,7 @@ static void ingenic_drm_plane_enable(struct 
>> ingenic_drm *priv,
>>   	unsigned int en_bit;
>> 
>>   	if (priv->soc_info->has_osd) {
>>  -		if (plane->type == DRM_PLANE_TYPE_PRIMARY)
>>  +		if (plane != &priv->f0)
> 
> I don't know about this driver but… is this really the same as the 
> previous
> condition? The previous condition would match two planes, this one 
> seems to
> match only a single plane. What am I missing?

There are three planes, which we will call here f0, f1, and ipu.

Previously, the "plane->type == DRM_PLANE_TYPE_PRIMARY" matched f1 and 
ipu. Since ipu is now OVERLAY we have to change the condition or the 
behaviour will be different, as otherwise it would only match the f1 
plane.

Cheers,
-Paul


