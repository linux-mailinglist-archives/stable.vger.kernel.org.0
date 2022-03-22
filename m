Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A79404E3D52
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 12:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232880AbiCVLQt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Mar 2022 07:16:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231743AbiCVLQs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Mar 2022 07:16:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D48357DAA8
        for <stable@vger.kernel.org>; Tue, 22 Mar 2022 04:15:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647947720;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9+UC/u0PtbhZRKj2jRfChXJZesydUtyvw1SAh08In7c=;
        b=gPVCE8cXpHvDtITuwaiI5CIczvakyDPMGUr5aUY7fv+kTe1JhbQDxD81DA3cZJvUidhWMh
        7zAMjvuT/7CC5DIIUVsw6gWfzisj9I6hwlX8zZmytFC2tZQuvg/qmpQ8X0ug27Ty9iaSX8
        eJJ5rfYAbX5T4ycb9xSAw9UDOn4PYYA=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-54-Uvos-isEOXavr3Gv6pvTlA-1; Tue, 22 Mar 2022 07:15:18 -0400
X-MC-Unique: Uvos-isEOXavr3Gv6pvTlA-1
Received: by mail-ej1-f72.google.com with SMTP id r18-20020a17090609d200b006a6e943d09eso8497949eje.20
        for <stable@vger.kernel.org>; Tue, 22 Mar 2022 04:15:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9+UC/u0PtbhZRKj2jRfChXJZesydUtyvw1SAh08In7c=;
        b=pb0rp9/SaLJElNlAszf9n8WLtpw33+mjCzN94c1FN1HZwmqMaL3UhWFrZGQZct1exh
         oKLun/6OJSCb5L2gam8OLy7BgHA4qxvvJB68hw0NkmbtsRCeDG0/RiDlXiTL1R+a92wV
         lZRwo22YjBhMrtAqCvtkVWaY4Y7QeYOXgl26vEerIdsrxtWTb4X0Mquck1Ac2eH6iKij
         IfJFO+j5G7VKqdJRopQiYF12Icp5sn7Wlcsfg9cAkxNICiO22qS4V3BPge8C0sufKrX/
         TYC4UnFa1tAjirA/iJDO268zgl7BBoVpBC/f1vvoyBbwb+yzztkr5xWK5Q8+vqzay2qX
         eUAQ==
X-Gm-Message-State: AOAM533tGY72d2vn8YGiutrkbgpeHk60p15Pjn49U7Jf5L7EkTPWdpK0
        5BicJSnlgIklmXV67kY3cue4XiC62GM2dSLMFf46a28CV6JyBa+hvokUFa+svJuFJNFqjl34ZUI
        ZOUgaab8OG6O+gFFO
X-Received: by 2002:a17:907:6d0d:b0:6db:f0f8:654d with SMTP id sa13-20020a1709076d0d00b006dbf0f8654dmr25117728ejc.304.1647947717429;
        Tue, 22 Mar 2022 04:15:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJztuw0yNJlw73T6KIfQYuamz6XiUFLX3+Qtr0m4cBQUuSF6vyV6Eeh/JUedUW2DEs+W3oFzWQ==
X-Received: by 2002:a17:907:6d0d:b0:6db:f0f8:654d with SMTP id sa13-20020a1709076d0d00b006dbf0f8654dmr25117698ejc.304.1647947717179;
        Tue, 22 Mar 2022 04:15:17 -0700 (PDT)
Received: from ?IPV6:2001:1c00:c1e:bf00:cdb2:2781:c55:5db0? (2001-1c00-0c1e-bf00-cdb2-2781-0c55-5db0.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:cdb2:2781:c55:5db0])
        by smtp.gmail.com with ESMTPSA id qa44-20020a17090786ac00b006dbe1ca23casm8117781ejc.45.2022.03.22.04.15.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Mar 2022 04:15:16 -0700 (PDT)
Message-ID: <30340bc0-3a75-cccc-ed98-f80f3ce94627@redhat.com>
Date:   Tue, 22 Mar 2022 12:15:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] Revert "Input: clear BTN_RIGHT/MIDDLE on buttonpads"
Content-Language: en-US
To:     =?UTF-8?B?Sm9zw6kgRXhww7NzaXRv?= <jose.exposito89@gmail.com>,
        jkosina@suse.cz
Cc:     tiwai@suse.de, benjamin.tissoires@redhat.com,
        regressions@leemhuis.info, peter.hutterer@who-t.net,
        linux-input@vger.kernel.org, stable@vger.kernel.org,
        regressions@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20220321184404.20025-1-jose.exposito89@gmail.com>
From:   Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <20220321184404.20025-1-jose.exposito89@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 3/21/22 19:44, José Expósito wrote:
> This reverts commit 37ef4c19b4c659926ce65a7ac709ceaefb211c40.
> 
> The touchpad present in the Dell Precision 7550 and 7750 laptops
> reports a HID_DG_BUTTONTYPE of type MT_BUTTONTYPE_CLICKPAD. However,
> the device is not a clickpad, it is a touchpad with physical buttons.
> 
> In order to fix this issue, a quirk for the device was introduced in
> libinput [1] [2] to disable the INPUT_PROP_BUTTONPAD property:
> 
> 	[Precision 7x50 Touchpad]
> 	MatchBus=i2c
> 	MatchUdevType=touchpad
> 	MatchDMIModalias=dmi:*svnDellInc.:pnPrecision7?50*
> 	AttrInputPropDisable=INPUT_PROP_BUTTONPAD
> 
> However, because of the change introduced in 37ef4c19b4 ("Input: clear
> BTN_RIGHT/MIDDLE on buttonpads") the BTN_RIGHT key bit is not mapped
> anymore breaking the device right click button and making impossible to
> workaround it in user space.
> 
> In order to avoid breakage on other present or future devices, revert
> the patch causing the issue.
> 
> Cc: stable@vger.kernel.org
> Link: https://gitlab.freedesktop.org/libinput/libinput/-/merge_requests/481 [1]
> Link: https://bugzilla.redhat.com/show_bug.cgi?id=1868789  [2]
> Signed-off-by: José Expósito <jose.exposito89@gmail.com>

Thanks, patch looks good to me:

Reviewed-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans


> ---
>  drivers/input/input.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/drivers/input/input.c b/drivers/input/input.c
> index c3139bc2aa0d..ccaeb2426385 100644
> --- a/drivers/input/input.c
> +++ b/drivers/input/input.c
> @@ -2285,12 +2285,6 @@ int input_register_device(struct input_dev *dev)
>  	/* KEY_RESERVED is not supposed to be transmitted to userspace. */
>  	__clear_bit(KEY_RESERVED, dev->keybit);
>  
> -	/* Buttonpads should not map BTN_RIGHT and/or BTN_MIDDLE. */
> -	if (test_bit(INPUT_PROP_BUTTONPAD, dev->propbit)) {
> -		__clear_bit(BTN_RIGHT, dev->keybit);
> -		__clear_bit(BTN_MIDDLE, dev->keybit);
> -	}
> -
>  	/* Make sure that bitmasks not mentioned in dev->evbit are clean. */
>  	input_cleanse_bitmasks(dev);
>  

