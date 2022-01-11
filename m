Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F309048B57A
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 19:11:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242715AbiAKSL7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 13:11:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51731 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233632AbiAKSL7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 13:11:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641924718;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3hgp9TNlhmh2F8YJ1u7gu8AeVl0SpLbsYxPdRZu+7iA=;
        b=HDvJW6P2e5vXEUcKEyVJ7AnKUKsbBgi3WyXoWjFC5eKeZFa7oMDLseMic99If8XPF1K9pu
        hRD9rs4KvW3qRPzPjyzuTNhjheaozAjFOEqSom/niFf8Vm8DbbxRVYGaPrzHOauPEuH78S
        1CJDXoFreOOIptPzSUv/zE8bIF/VocM=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-350--Zxrl2lLM1aWAB2YMKBVsA-1; Tue, 11 Jan 2022 13:11:57 -0500
X-MC-Unique: -Zxrl2lLM1aWAB2YMKBVsA-1
Received: by mail-qv1-f69.google.com with SMTP id gc11-20020a056214230b00b004178c9ca8d2so142704qvb.7
        for <stable@vger.kernel.org>; Tue, 11 Jan 2022 10:11:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=3hgp9TNlhmh2F8YJ1u7gu8AeVl0SpLbsYxPdRZu+7iA=;
        b=r2fxTCx61DpFhSO5uiOggQOFju50MVDqDCKXvy9XInxzCn5fUCQcWVcy0NHWxr8OQ+
         mGHvfTWU4r/W2yimdd1H3ZTw0Ad3ROO20V+wNfwgvKZ8X4wVwBQtvcCXfYV+5F/yoZLy
         VtgMFXp2H+o8bnBKAyrDmE2dCcxdqmrn1xyDbih+TuB955MA0c+iscyvrulIBlOUJpNT
         FBzqE1Sat5ohZ/9mpEdugNwlEoVSs57JhW7/YZSROpYKmkkMwNiKQe5a6HcOw2EKwrK6
         xgA0GL1o+77yPpa43rvOUYOLP69B2cwCPovzjLRXTCGIf3dhoIG6YJEzg7y17JZkz83n
         W2sA==
X-Gm-Message-State: AOAM5337UvYoxCetTBlQc6PKVGmkVIaZAMgxruPQ2MpHfeMQ+5d0EZuX
        Hf3WiVN5O6/MMZH5vJbN1d87zi6gI5N8t1yNsNK/M0sHX0+nIk5yHixTIPagWANLS5hhke3gJK1
        NBNR4J/HdJqTKzLbo
X-Received: by 2002:a37:ef17:: with SMTP id j23mr3846390qkk.400.1641924716777;
        Tue, 11 Jan 2022 10:11:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyvsxA+do5OMy7/Gkj99hwDfSQMXE+E3UHnj4iMm90i8YoXCddk9cREEvoOwLscfzjDtZ8gfg==
X-Received: by 2002:a37:ef17:: with SMTP id j23mr3846376qkk.400.1641924716545;
        Tue, 11 Jan 2022 10:11:56 -0800 (PST)
Received: from [192.168.8.138] (pool-98-118-105-43.bstnma.ftas.verizon.net. [98.118.105.43])
        by smtp.gmail.com with ESMTPSA id o17sm7804481qtv.87.2022.01.11.10.11.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 10:11:56 -0800 (PST)
Message-ID: <83a52893a963f37cb1c86f0b95c9a84091620361.camel@redhat.com>
Subject: Re: [PATCH] drm/nouveau/core/object: Fix the uninitialized use of
 "type"
From:   Lyude Paul <lyude@redhat.com>
To:     Yizhuo Zhai <yzhai003@ucr.edu>
Cc:     stable@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 11 Jan 2022 13:11:54 -0500
In-Reply-To: <20211218025632.2514288-1-yzhai003@ucr.edu>
References: <20211218025632.2514288-1-yzhai003@ucr.edu>
Organization: Red Hat Inc.
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.2 (3.42.2-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Reviewed-by: Lyude Paul <lyude@redhat.com>

On Fri, 2021-12-17 at 18:56 -0800, Yizhuo Zhai wrote:
> In function nvkm_ioctl_map(), the variable "type" could be
> uninitialized if "nvkm_object_map()" returns error code, however,
> it does not check the return value and directly use the "type" in
> the if statement, which is potentially unsafe.
> 
> Cc: stable@vger.kernel.org
> Fixes: 01326050391c ("drm/nouveau/core/object: allow arguments to be passed
> to map function")
> Signed-off-by: Yizhuo Zhai <yzhai003@ucr.edu>
> ---
>  drivers/gpu/drm/nouveau/nvkm/core/ioctl.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/gpu/drm/nouveau/nvkm/core/ioctl.c
> b/drivers/gpu/drm/nouveau/nvkm/core/ioctl.c
> index 735cb6816f10..4264d9d79783 100644
> --- a/drivers/gpu/drm/nouveau/nvkm/core/ioctl.c
> +++ b/drivers/gpu/drm/nouveau/nvkm/core/ioctl.c
> @@ -266,6 +266,8 @@ nvkm_ioctl_map(struct nvkm_client *client,
>                 ret = nvkm_object_map(object, data, size, &type,
>                                       &args->v0.handle,
>                                       &args->v0.length);
> +               if (ret)
> +                       return ret;
>                 if (type == NVKM_OBJECT_MAP_IO)
>                         args->v0.type = NVIF_IOCTL_MAP_V0_IO;
>                 else

-- 
Cheers,
 Lyude Paul (she/her)
 Software Engineer at Red Hat

