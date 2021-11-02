Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF0B442EC0
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 14:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbhKBNGg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 09:06:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:21426 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229924AbhKBNGg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Nov 2021 09:06:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635858241;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=F5yWkmOg5/0evPimUvtS3b9rTndZ2SZlpCnwbNELc7c=;
        b=PMSbfmEWo7tP53+HkkNAuX2kzBCQLd/667tNRIE/HL+q+fVQFXb2X4BTy2sn7F514JJpxR
        4Ws0cPJelUd5VNuEYJdTB9Ma9zT+msZDxJz/qtxlIw/oy9K3bG0i8jky/EvnpvD6g5A7RY
        dIurL4+UDJdhQXe+Qkf//U8AC5A+EuA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-3-wCLeod3NPSW8e7fk6m004Q-1; Tue, 02 Nov 2021 09:04:00 -0400
X-MC-Unique: wCLeod3NPSW8e7fk6m004Q-1
Received: by mail-wm1-f72.google.com with SMTP id g11-20020a1c200b000000b003320d092d08so3912927wmg.9
        for <stable@vger.kernel.org>; Tue, 02 Nov 2021 06:03:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=F5yWkmOg5/0evPimUvtS3b9rTndZ2SZlpCnwbNELc7c=;
        b=U+T0EaszggbDdVN8XjK1UFQmt/c206SFOXW2e74DJsxip//4HR0RMfCXT75RSCYvlH
         TAntnLKVCXJ3UBWQN0YLi+YeNM0x5qmMQtRKqwiucPhA2cLsYfzV8XQ12DRhre7F+NSc
         5RNQgHzV4JtAjYCoTcIVgLk6Bv2dwShPfH1K9oO79wfuPSRVBr7n4IWJVuVUKViX+DMU
         Lc9C/EVyoYvaaWatE2R1frk0LmvjlNw4d7rB88Nouye2yIVbwClGsd2fAkeysd9A2qa2
         ipLhLaK8wm124uhIL2J3+EDbexC2jJpSdQn1vsqCL3bK3VPabljDHXUSNa8G40QQy1c9
         wtxg==
X-Gm-Message-State: AOAM531sI6rrqlNjTHihpysotDGkNHhhH1SBygB6BzYmObrUj9eEfvVq
        KEBuzerPXbOsYG1HMSVQUIl7Cgeu2IncEnH6Fhi4vY50Aj7hj+fizwrRFUCjpXi1LVUUtMqANs3
        yVJ2kk6RbxDDWdMP9
X-Received: by 2002:adf:d1e3:: with SMTP id g3mr46970711wrd.63.1635858238934;
        Tue, 02 Nov 2021 06:03:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzuDILBX8p9T4euEWEY2xWP7A4Nb7oizJIhNiY6eGE/hNzVLg2a0xhHfdf5bmVh6MTgKK0GBQ==
X-Received: by 2002:adf:d1e3:: with SMTP id g3mr46970686wrd.63.1635858238747;
        Tue, 02 Nov 2021 06:03:58 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id k37sm2389496wms.21.2021.11.02.06.03.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 06:03:58 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Boqun Feng <boqun.feng@gmail.com>, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Boqun Feng <boqun.feng@gmail.com>, stable@vger.kernel.org,
        Baihua Lu <baihua.lu@microsoft.com>
Subject: Re: [PATCH] Drivers: hv: balloon: Use VMBUS_RING_SIZE() wrapper for
 dm_ring_size
In-Reply-To: <20211101150026.736124-1-boqun.feng@gmail.com>
References: <20211101150026.736124-1-boqun.feng@gmail.com>
Date:   Tue, 02 Nov 2021 14:03:57 +0100
Message-ID: <87h7cuk8ua.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Boqun Feng <boqun.feng@gmail.com> writes:

> Baihua reported an error when boot an ARM64 guest with PAGE_SIZE=64k and
> BALLOON is enabled:
>
> 	hv_vmbus: registering driver hv_balloon
> 	hv_vmbus: probe failed for device 1eccfd72-4b41-45ef-b73a-4a6e44c12924 (-22)
>
> The cause of this is that the ringbuffer size for hv_balloon is not
> adjusted with VMBUS_RING_SIZE(), which makes the size not large enough
> for ringbuffers on guest with PAGE_SIZE=64k. Therefore use
> VMBUS_RING_SIZE() to calculate the ringbuffer size. Note that the old
> size (20 * 1024) counts a 4k header in the total size, while
> VMBUS_RING_SIZE() expects the parameter as the payload size, so use
> 16 * 1024.
>
> Cc: <stable@vger.kernel.org> # 5.15.x
> Reported-by: Baihua Lu <baihua.lu@microsoft.com>
> Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
> ---
>  drivers/hv/hv_balloon.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
> index 7f11ea07d698..ca873a3b98db 100644
> --- a/drivers/hv/hv_balloon.c
> +++ b/drivers/hv/hv_balloon.c
> @@ -480,7 +480,7 @@ module_param(pressure_report_delay, uint, (S_IRUGO | S_IWUSR));
>  MODULE_PARM_DESC(pressure_report_delay, "Delay in secs in reporting pressure");
>  static atomic_t trans_id = ATOMIC_INIT(0);
>  
> -static int dm_ring_size = 20 * 1024;
> +static int dm_ring_size = VMBUS_RING_SIZE(16 * 1024);
>  
>  /*
>   * Driver specific state.

Tested-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Thanks!

-- 
Vitaly

