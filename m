Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCE09666CD7
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 09:47:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239736AbjALIrr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 03:47:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239570AbjALIqd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 03:46:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60C5F50143
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 00:44:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673513091;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5a4BjVGA5+VS7280a0HZ27tLyRrI18llQE1bUBA8/1A=;
        b=C3l1GUuQQshmNX7JLjxqU4zgH5008d2GCHSnLh0+SjHYdLG5LikAeYNLs6DKTyzVtLBHG5
        2qJJyZKesdlWtr/OcSbbpXqSTu2UunxYg5CCgLD2P1AqVmolg5WXXOvDipwCz0727dWW7+
        zAo+HE6GTJ9RjiubBU94L5UOeidDd04=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-52-1r7sr2sUO7KMP1JXtX-Hdw-1; Thu, 12 Jan 2023 03:44:50 -0500
X-MC-Unique: 1r7sr2sUO7KMP1JXtX-Hdw-1
Received: by mail-wm1-f70.google.com with SMTP id l31-20020a05600c1d1f00b003d9720d2a0eso12115574wms.7
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 00:44:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5a4BjVGA5+VS7280a0HZ27tLyRrI18llQE1bUBA8/1A=;
        b=x+HEue2s2iCNv5ayoztnwsi2JwpUxrsNWTYErxsY9XpT4THzDKp6sXbfXzayxnqPTA
         JTQUPDmqQLf9flsMjjhFBVzCv427z6OqdIVasTVeRjBWsInxSzryZepNLU1Se/tpFEmp
         z2EfJo9n4Dz5R8ndzmpGvGj9KoK6oBrRnooSTtykl+rTEmfcV7jv1FsnxR3LIINc/u+x
         hYBrkmamDX7XQ/Y9Ous5hol8Tn17gU4yH0wytLvXPl/NhtgYniGHX8I/HFm8oHKUzJg6
         sx03zdldI7vdK0BiE+yAAeIeX+dkAg91HYAb51EH8D1de38bcMdbKjIVAg2eA+ar0G/p
         ZNcA==
X-Gm-Message-State: AFqh2kqDPrguCibsCj2Om18oc5F+G99VECbFUHvjzkNqyoF2fRXdMGco
        pmScqm62kDX1CGNCSgN+lcTnMnDcxhMTLPDS+ycwYr321CB5wil3lbSd1RGakQzhem5zTTl1SRT
        HOhitJo5nOTFoTrmi
X-Received: by 2002:a05:6000:705:b0:267:e918:d1e6 with SMTP id bs5-20020a056000070500b00267e918d1e6mr47978593wrb.51.1673513089194;
        Thu, 12 Jan 2023 00:44:49 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsBcz+NOewCErJTagdikvQUga/n6zRME4ChBTvTDSkbfqsCpMEvFJRtoH3xbPIha9jKtsWTZw==
X-Received: by 2002:a05:6000:705:b0:267:e918:d1e6 with SMTP id bs5-20020a056000070500b00267e918d1e6mr47978578wrb.51.1673513088989;
        Thu, 12 Jan 2023 00:44:48 -0800 (PST)
Received: from [192.168.1.130] (205.pool92-176-231.dynamic.orange.es. [92.176.231.205])
        by smtp.gmail.com with ESMTPSA id k9-20020a5d66c9000000b002bdd7ce63b2sm526804wrw.38.2023.01.12.00.44.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jan 2023 00:44:48 -0800 (PST)
Message-ID: <733eb41e-a296-47bb-ce06-18dff755723c@redhat.com>
Date:   Thu, 12 Jan 2023 09:44:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 11/11] video/aperture: Only remove sysfb on the default
 vga pci device
Content-Language: en-US
To:     Thomas Zimmermann <tzimmermann@suse.de>,
        Aaron Plattner <aplattner@nvidia.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>
Cc:     Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Helge Deller <deller@gmx.de>, Sam Ravnborg <sam@ravnborg.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        stable@vger.kernel.org
References: <20230111154112.90575-1-daniel.vetter@ffwll.ch>
 <20230111154112.90575-11-daniel.vetter@ffwll.ch>
 <fb72e067-3f5f-1bac-dc9b-3abd9d7739a2@redhat.com>
 <ad725823-f4ef-904f-c04c-90a6aad43323@nvidia.com>
 <7b00e592-345f-4dd5-3452-7f6f70fc608a@suse.de>
From:   Javier Martinez Canillas <javierm@redhat.com>
In-Reply-To: <7b00e592-345f-4dd5-3452-7f6f70fc608a@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/12/23 08:55, Thomas Zimmermann wrote:

[...]

>> Thanks Daniel and Javier!
>>
>> I wasn't able to reproduce the original problem on my hybrid laptop 
>> since it refuses to boot with the console on an external display, but I 
>> was able to reproduce it by switching the configuration around: booting 
>> with i915.modeset=0 and with an experimental version of nvidia-drm that 
>> registers a framebuffer console. I verified that loading nvidia-drm 
> 
> Thank you for testing.
> 
> One thing I'd like to note is that using DRM's fbdev emulation is the 
> correct way to support a console. Nvidia-drm's current approach of 
> utilizing efifb is fragile and requires workarounds from distributions 
> (at least here at SUSE). Steps towards fbdev emulation are much appreciated.
>
 
I was meaning to mention the same. Fedora also is carrying a workaround just
for the Nvidia proprietary driver since all other drivers provide a emulated
fbdev device.

So getting this finally fixed will be indeed highly appreciated.

-- 
Best regards,

Javier Martinez Canillas
Core Platforms
Red Hat

