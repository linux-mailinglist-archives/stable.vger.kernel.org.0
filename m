Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEE8255749F
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 09:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbiFWH50 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 03:57:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbiFWH5Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 03:57:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7E26D4706F
        for <stable@vger.kernel.org>; Thu, 23 Jun 2022 00:57:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655971043;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dvZy/50T4UgEKe2nIlW9cYFKkogyYzn4qAw+8C8pOWI=;
        b=gBmuQBJ0QkddPldsEju9txFWYm3tUo4GdMDojkZIaZ0/d+kzW/d9SWx3iZA3Znq57j4uTa
        ylRCEbQHrA6xthCA8lm4TuSkC1qpGppRS7LdfSey/h+F0+XBiiaOzsId4+/v0ntpeO4oZb
        AcLoijvIl53Xb3WNErndzNqtjmbiDhU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-117-d91_G7ztMn--p__h59En3Q-1; Thu, 23 Jun 2022 03:57:22 -0400
X-MC-Unique: d91_G7ztMn--p__h59En3Q-1
Received: by mail-wm1-f72.google.com with SMTP id v184-20020a1cacc1000000b0039c7efa3e95so6615951wme.3
        for <stable@vger.kernel.org>; Thu, 23 Jun 2022 00:57:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dvZy/50T4UgEKe2nIlW9cYFKkogyYzn4qAw+8C8pOWI=;
        b=0rclpwITRm4RrZDRf+B2DVHAv6VWTvaYk5Nm6gxmOs3qqtAj4mX7hEgmSYBzfFMAlC
         +B2I+IJo+1QfQYujjGfe7OSz2Mvy+L6YzT8Bo8NMerMRWAoo+xdK2zauRywMAufEfQ3Q
         dElesIMeVnDuPRUD+Gry1gAydRqeZ5LgyZs/2+mQCNIFuhB4nH8SxkHcqwO/SxUBf2TY
         mbqx+iZUovzYY9fASj6LSv9xERG0P3laHWcLJmpRS6egIEEIkg26d1gfkd/5pR8dJ/57
         1lAnluMb+1R/AOp2B472AOsYzQ/Yaz7uCRBrBglNcrwLald07ztQbH3gPbDHL5/hjP0h
         F0oQ==
X-Gm-Message-State: AJIora8n73ctpJx36Ejpzl6/mhzkJ6A/pzcQZSAjjYCHvcQCA6DktIQ6
        M0sBXEMVbrmDMMJqWt9PQkZl6HlBbvJGuVC+vKKyHna8meVJ5wvUhMoilojE+azvyuOiW1ykyPf
        Yi1lOK33DFbHyJ+10
X-Received: by 2002:adf:d1c6:0:b0:218:4fc3:a805 with SMTP id b6-20020adfd1c6000000b002184fc3a805mr6717235wrd.228.1655971041105;
        Thu, 23 Jun 2022 00:57:21 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1v2M7uaEAm4QL8OrSDKAtIrbQ51v3N9GqBcLPy6U4Up2VsFsxxXrxwWzU0EAxlTLgLRx/Anuw==
X-Received: by 2002:adf:d1c6:0:b0:218:4fc3:a805 with SMTP id b6-20020adfd1c6000000b002184fc3a805mr6717223wrd.228.1655971040875;
        Thu, 23 Jun 2022 00:57:20 -0700 (PDT)
Received: from [192.168.1.129] (205.pool92-176-231.dynamic.orange.es. [92.176.231.205])
        by smtp.gmail.com with ESMTPSA id n40-20020a05600c3ba800b0039c7c4a542csm2309254wms.47.2022.06.23.00.57.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jun 2022 00:57:20 -0700 (PDT)
Message-ID: <12f3bfc9-e7eb-0570-adfd-0ad0e39df91d@redhat.com>
Date:   Thu, 23 Jun 2022 09:57:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] drm/fb-helper: Fix out-of-bounds access
Content-Language: en-US
To:     Thomas Zimmermann <tzimmermann@suse.de>,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        airlied@linux.ie, daniel@ffwll.ch
Cc:     dri-devel@lists.freedesktop.org,
        =?UTF-8?Q?Nuno_Gon=c3=a7alves?= <nunojpg@gmail.com>,
        stable@vger.kernel.org
References: <20220621104617.8817-1-tzimmermann@suse.de>
From:   Javier Martinez Canillas <javierm@redhat.com>
In-Reply-To: <20220621104617.8817-1-tzimmermann@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Thomas,

On 6/21/22 12:46, Thomas Zimmermann wrote:
> Clip memory range to screen-buffer size to avoid out-of-bounds access
> in fbdev deferred I/O's damage handling.
> 
> Fbdev's deferred I/O can only track pages. From the range of pages, the
> damage handler computes the clipping rectangle for the display update.
> If the fbdev screen buffer ends near the beginning of a page, that page
> could contain more scanlines. The damage handler would then track these
> non-existing scanlines as dirty and provoke an out-of-bounds access
> during the screen update. Hence, clip the maximum memory range to the
> size of the screen buffer.
> 
> While at it, rename the variables min/max to min_off/max_off in
> drm_fb_helper_deferred_io(). This avoids confusion with the macros of
> the same name.
> 
> Reported-by: Nuno Gonçalves <nunojpg@gmail.com>
> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> Tested-by: Nuno Gonçalves <nunojpg@gmail.com>
> Fixes: 67b723f5b742 ("drm/fb-helper: Calculate damaged area in separate helper")
> Cc: Thomas Zimmermann <tzimmermann@suse.de>
> Cc: Javier Martinez Canillas <javierm@redhat.com>
> Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> Cc: Maxime Ripard <mripard@kernel.org>
> Cc: <stable@vger.kernel.org> # v5.18+
> ---

This makes sense to me.

Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>

-- 
Best regards,

Javier Martinez Canillas
Linux Engineering
Red Hat

