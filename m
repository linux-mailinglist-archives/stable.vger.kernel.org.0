Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26562658DEE
	for <lists+stable@lfdr.de>; Thu, 29 Dec 2022 15:36:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiL2OgB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Dec 2022 09:36:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiL2OgA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Dec 2022 09:36:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 334E312742
        for <stable@vger.kernel.org>; Thu, 29 Dec 2022 06:35:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672324517;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KePM8LGAehS8PxVf3em7bkMvOyCCyGkD1QJPFzoXjoY=;
        b=CIRadfUdkEOIDqd1qQcLdqhj+Lfaxkn4yKhueuPRnaHWwLn6Ww4zIUp8/VTGfTu+LtEqGK
        1PCI54y1IE6ky7ZxGxp+fU/jT+BajAyRP5jbhUsc5Pa4zJi3jIHBpBZdL5hve2NS3uD+P/
        qqpjzzeNAiUc7BcSi4bIhRinX2h0K5w=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-516-5TN07bmIPVuZnoQaUD3fjA-1; Thu, 29 Dec 2022 09:35:15 -0500
X-MC-Unique: 5TN07bmIPVuZnoQaUD3fjA-1
Received: by mail-wm1-f72.google.com with SMTP id c7-20020a1c3507000000b003d355c13ba8so9805924wma.6
        for <stable@vger.kernel.org>; Thu, 29 Dec 2022 06:35:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KePM8LGAehS8PxVf3em7bkMvOyCCyGkD1QJPFzoXjoY=;
        b=PXle+zZtao6oOvm36UHMu5wPh4ChOiznpX7Zqfx6FgbB/vL6rWa2iNHaKoiWy81KbI
         epHE5a3RLSZrIvkwTFsSL78xKlUNU34RDdO0Bfnwvdtz3H8M4YiZmppLLBnl3Mf6yhKT
         9Yc40Xm4gvA4oiXw3UALPPrj+NzzBVz51ytjxpF1y1Fi7/TX6BH8uTV7VRa7+9V+4kZR
         Wb1c7K4vcRU6vPU9s2lEfrm3R4OYqCX6uCBc7WzbRvDr9YYMnAm/855YDZnMhPC2vOQx
         P45709NV442aP4jMkXxtYrXd/CoPClfXfIG9pEpFfGCn/4z5zIDENAWNgprPrVmouIQZ
         9bVQ==
X-Gm-Message-State: AFqh2koT2lIXWPmTfqOKKTqDifywmeQG/i/BAZAFqot5HfsbiRP+HybZ
        o+aFd5VQ+Y32oTOS74EYL/6cbidPM1OydaTpGpQSq9zfLf0rghGqst1IhYthLIH18sr1GZfGeQ/
        HtMsR6ZfQ3QsR2gac
X-Received: by 2002:a5d:460d:0:b0:242:69f4:cb6a with SMTP id t13-20020a5d460d000000b0024269f4cb6amr16459189wrq.9.1672324514804;
        Thu, 29 Dec 2022 06:35:14 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuhgKP5nEJxUo1DwVlnSvFu/L2yowvsm+jGS3h9joQUDWOjQmxTMQckkrXQ+uhe+DCqYeOJDQ==
X-Received: by 2002:a5d:460d:0:b0:242:69f4:cb6a with SMTP id t13-20020a5d460d000000b0024269f4cb6amr16459171wrq.9.1672324514569;
        Thu, 29 Dec 2022 06:35:14 -0800 (PST)
Received: from [192.168.1.130] (205.pool92-176-231.dynamic.orange.es. [92.176.231.205])
        by smtp.gmail.com with ESMTPSA id p13-20020a05600c358d00b003d1f2c3e571sm32813393wmq.33.2022.12.29.06.35.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Dec 2022 06:35:14 -0800 (PST)
Message-ID: <21fe5a6c-06f9-a902-6621-19c4a2a451ad@redhat.com>
Date:   Thu, 29 Dec 2022 15:35:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v2 01/11] drm/amd: Delay removal of the firmware
 framebuffer
Content-Language: en-US
To:     Mario Limonciello <mario.limonciello@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        linux-kernel@vger.kernel.org
Cc:     Carlos Soriano Sanchez <csoriano@redhat.com>,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>, christian.koenig@amd.com,
        stable@vger.kernel.org, Alex Deucher <alex.deucher@amd.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>
References: <20221228163102.468-1-mario.limonciello@amd.com>
 <20221228163102.468-2-mario.limonciello@amd.com>
From:   Javier Martinez Canillas <javierm@redhat.com>
In-Reply-To: <20221228163102.468-2-mario.limonciello@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Mario,

On 12/28/22 17:30, Mario Limonciello wrote:
> Removing the firmware framebuffer from the driver means that even
> if the driver doesn't support the IP blocks in a GPU it will no
> longer be functional after the driver fails to initialize.
> 
> This change will ensure that unsupported IP blocks at least cause
> the driver to work with the EFI framebuffer.
>
> Cc: stable@vger.kernel.org
> Suggested-by: Alex Deucher <alex.deucher@amd.com>
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> ---

As mentioned, I'm not familiar with this driver but the change looks
good to me. Delaying the firmware-provided framebuffer removal is the
correct thing to do IMO.

Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>

-- 
Best regards,

Javier Martinez Canillas
Core Platforms
Red Hat

