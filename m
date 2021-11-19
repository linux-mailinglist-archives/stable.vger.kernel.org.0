Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B0D9456B29
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 08:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232211AbhKSH7w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 02:59:52 -0500
Received: from mail-ed1-f45.google.com ([209.85.208.45]:40937 "EHLO
        mail-ed1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230520AbhKSH7v (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Nov 2021 02:59:51 -0500
Received: by mail-ed1-f45.google.com with SMTP id r25so2182269edq.7;
        Thu, 18 Nov 2021 23:56:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=RDt+ZEKKK+y4L/cNQDNt9OYhDcSTQBElCwBPlRsrfnc=;
        b=jvr/yWGsjaA319yAKVox96pyWbDeYuf71PHyxK2e9+jaiXQPTCihOTxHyHZ7H0J3ky
         PnJQqr5rlyMjTbVSWTA1zpy9/uE0AcAvI/LGTLiigemqty8kQ+26kPrs17rQsNNmH38d
         gsp+doKJCRaxp8OB0PlzMeh6EBK4Sn9UTDm1qWWA1adoQARSeUNVhQ09uz0MSfVpM0Rn
         O1X+u8qjVLUiKTwcVJY2pbCD8SpdlnjbcQ4KObNFE8xc/+4g9aBSiOQusCgCRps7oH0v
         +2atlNNVX3YSqFwLecLNvgPt4kSAiFujsjBK2kLiR7xja3XkDKbbpq+/lX4n5x1vVPn0
         aWMA==
X-Gm-Message-State: AOAM532px0n/y3TQV7dWCSE4GrnddoF9XBTL5qXXowcC+95+BlP98/X7
        kPRRegmUuITYd1zfshgQyh8=
X-Google-Smtp-Source: ABdhPJwTw5ai0reJm+3S6rto9Pgct8VsInhZ29v2M9WvT2d1nb8nWPqJ9mlOpxDJReG9YhUgpNSywQ==
X-Received: by 2002:a17:907:75f0:: with SMTP id jz16mr5300112ejc.77.1637308609286;
        Thu, 18 Nov 2021 23:56:49 -0800 (PST)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id gs17sm840320ejc.28.2021.11.18.23.56.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Nov 2021 23:56:48 -0800 (PST)
Message-ID: <fd7132a4-a016-9bf2-bb08-616f5f9d6e85@kernel.org>
Date:   Fri, 19 Nov 2021 08:56:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 5.15 808/917] drm: fb_helper: improve CONFIG_FB dependency
Content-Language: en-US
From:   Jiri Slaby <jirislaby@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        "Acked-by: Jani Nikula" <jani.nikula@intel.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
References: <20211115165428.722074685@linuxfoundation.org>
 <20211115165456.391822721@linuxfoundation.org>
 <9fdb2bf1-de52-1b9d-4783-c61ce39e8f51@kernel.org>
In-Reply-To: <9fdb2bf1-de52-1b9d-4783-c61ce39e8f51@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 19. 11. 21, 8:50, Jiri Slaby wrote:
> On 15. 11. 21, 18:05, Greg Kroah-Hartman wrote:
>> From: Arnd Bergmann <arnd@arndb.de>
>>
>> [ Upstream commit 9d6366e743f37d36ef69347924ead7bcc596076e ]
> 
> Hi,
> 
> this breaks build on openSUSE's armv7hl config:
> $ wget -O .config 
> https://raw.githubusercontent.com/openSUSE/kernel-source/stable/config/armv7hl/default 
> 
> $ make -j168 CROSS_COMPILE=arm-suse-linux-gnueabi- ARCH=arm vmlinux
> ...
>    LD      .tmp_vmlinux.btf
> arm-suse-linux-gnueabi-ld: drivers/gpu/drm/panel/panel-simple.o: in 
> function `panel_simple_probe':
> drivers/gpu/drm/panel/panel-simple.c:803: undefined reference to 
> `drm_panel_dp_aux_backlight'
> $ grep -E 'CONFIG_(DRM|FB|DRM_KMS_HELPER|DRM_FBDEV_EMULATION)\>' .config
> CONFIG_DRM=y
> CONFIG_DRM_KMS_HELPER=m
> CONFIG_DRM_FBDEV_EMULATION=y
> CONFIG_FB=y
> 
> 5.16-rc1 builds just fine -- investigating why…

CLearly because the code moved to panel-edp.c. So doing:
-CONFIG_DRM_PANEL_EDP=m
+CONFIG_DRM_PANEL_EDP=y
leads to the same error in that file:
arm-suse-linux-gnueabi-ld: drivers/gpu/drm/panel/panel-edp.o: in 
function `panel_edp_probe':
drivers/gpu/drm/panel/panel-edp.c:843: undefined reference to 
`drm_panel_dp_aux_backlight'

>> My previous patch correctly addressed the possible link failure, but as
>> Jani points out, the dependency is now stricter than it needs to be.
>>
>> Change it again, to allow DRM_FBDEV_EMULATION to be used when
>> DRM_KMS_HELPER and FB are both loadable modules and DRM is linked into
>> the kernel.
>>
>> As a side-effect, the option is now only visible when at least one DRM
>> driver makes use of DRM_KMS_HELPER. This is better, because the option
>> has no effect otherwise.
>>
>> Fixes: 606b102876e3 ("drm: fb_helper: fix CONFIG_FB dependency")
>> Suggested-by: Acked-by: Jani Nikula <jani.nikula@intel.com>
>> Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
>> Link: 
>> https://patchwork.freedesktop.org/patch/msgid/20211029120307.1407047-1-arnd@kernel.org 
>>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>   drivers/gpu/drm/Kconfig | 5 ++---
>>   1 file changed, 2 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
>> index 9199f53861cac..6ae4269118af3 100644
>> --- a/drivers/gpu/drm/Kconfig
>> +++ b/drivers/gpu/drm/Kconfig
>> @@ -102,9 +102,8 @@ config DRM_DEBUG_DP_MST_TOPOLOGY_REFS
>>   config DRM_FBDEV_EMULATION
>>       bool "Enable legacy fbdev support for your modesetting driver"
>> -    depends on DRM
>> -    depends on FB=y || FB=DRM
>> -    select DRM_KMS_HELPER
>> +    depends on DRM_KMS_HELPER
>> +    depends on FB=y || FB=DRM_KMS_HELPER
>>       select FB_CFB_FILLRECT
>>       select FB_CFB_COPYAREA
>>       select FB_CFB_IMAGEBLIT
>>
> 
> 


-- 
js
suse labs
