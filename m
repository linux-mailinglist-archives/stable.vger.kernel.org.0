Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10B3A39FA12
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 17:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233744AbhFHPO1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 11:14:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50584 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233807AbhFHPOP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 11:14:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623165141;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ma+Y7/rVHYJ+wDRQx2MNgyshZEcsANdp8Rhdd7Nu3l0=;
        b=c9vvJGVkqkcS/SBPlm3VXRNaRtFd3X9NsXD6rS5ZX8KrB6zcrbWIrfrm6cP76rRZJmnWhw
        JdJmT7t1WDz17jfrmy8Wb/l3RHuM66sg9TryrqCH225Sk3PSnAqSuUJZDywQinIilL3TBp
        wTdlpHoI2k15vn8qCkMA5SZQxh+Lp6Q=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-78-7L5z4_JvN1WKvYCJTaLPFQ-1; Tue, 08 Jun 2021 11:12:18 -0400
X-MC-Unique: 7L5z4_JvN1WKvYCJTaLPFQ-1
Received: by mail-wm1-f71.google.com with SMTP id m23-20020a05600c3b17b02901b3e8a9db8eso497521wms.6
        for <stable@vger.kernel.org>; Tue, 08 Jun 2021 08:12:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Ma+Y7/rVHYJ+wDRQx2MNgyshZEcsANdp8Rhdd7Nu3l0=;
        b=FBNXB95o9SXDyQ/1TE1xrANEQR0SnTWs1RYUTxV/qf8rHzGqbYWZG/sgnBbCSB5gpt
         mGl6w/kLEX2qhhm0isih7gSw8k6i1ylMCGbsvpIOH3sy5ENqj1YPmtgUvXSTX2GbRniJ
         CruJphEKRogNzxfeTzk1OZajvG5HxXtQp6cEMefNEER0gCzKT1KE54oLaNIosVH2xHsL
         g/95qSEZQAGsosFsbn5Pjg+lA8IAkOvAh47oBtIlwhPxVBHlE9xna9pwMn7SQkLCpI5O
         epDUUuOnJXCtZzim6X51wMKoSxssBkFmoH8gt4fZh4WsjE8tW8nrLj3twTphbBxRfvU5
         L7Ow==
X-Gm-Message-State: AOAM5318TdXGQMzBTTW90tDiC8M42oNWvh37LPRdFi1Mq26fB7dhw0K5
        XaDmFoHpLOkYMDEsQCAJisCdxB1Zg5mBaoxKXSfvqm+iXy1XjMzo/+kwQbNj55aAHzXD8I+iMjX
        +rwRX0cDrxJLBfJKnHpspdnAVaG/WXkPBmggyPAgCUOkYhxMiFYUghdLVzeJW9lrAIA==
X-Received: by 2002:adf:f28b:: with SMTP id k11mr22343322wro.89.1623165136986;
        Tue, 08 Jun 2021 08:12:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwAPeOeqX15noJQRyOaa2NEx/vRR2eMPJsfDOGcNDSbualMJ4uzJxyHFbfEx0XnIoGz8rW2pA==
X-Received: by 2002:adf:f28b:: with SMTP id k11mr22343295wro.89.1623165136814;
        Tue, 08 Jun 2021 08:12:16 -0700 (PDT)
Received: from dresden.str.redhat.com ([2a02:908:1e46:160:b272:8083:d5:bc7d])
        by smtp.gmail.com with ESMTPSA id f14sm19791658wry.40.2021.06.08.08.12.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jun 2021 08:12:16 -0700 (PDT)
Subject: Re: [PATCH v2 3/7] fuse: Fix infinite loop in sget_fc()
To:     Greg Kurz <groug@kaod.org>, Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        virtio-fs@redhat.com, Vivek Goyal <vgoyal@redhat.com>,
        stable@vger.kernel.org
References: <20210604161156.408496-1-groug@kaod.org>
 <20210604161156.408496-4-groug@kaod.org>
From:   Max Reitz <mreitz@redhat.com>
Message-ID: <1fc488d8-91b8-9613-8127-a8b34ddb4744@redhat.com>
Date:   Tue, 8 Jun 2021 17:12:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210604161156.408496-4-groug@kaod.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 04.06.21 18:11, Greg Kurz wrote:
> We don't set the SB_BORN flag on submounts. This is wrong as these
> superblocks are then considered as partially constructed or dying
> in the rest of the code and can break some assumptions.
>
> One such case is when you have a virtiofs filesystem with submounts
> and you try to mount it again : virtio_fs_get_tree() tries to obtain
> a superblock with sget_fc(). The logic in sget_fc() is to loop until
> it has either found an existing matching superblock with SB_BORN set
> or to create a brand new one. It is assumed that a superblock without
> SB_BORN is transient and the loop is restarted. Forgetting to set
> SB_BORN on submounts hence causes sget_fc() to retry forever.
>
> Setting SB_BORN requires special care, i.e. a write barrier for
> super_cache_count() which can check SB_BORN without taking any lock.
> We should call vfs_get_tree() to deal with that but this requires
> to have a proper ->get_tree() implementation for submounts, which
> is a bigger piece of work. Go for a simple bug fix in the meatime.
>
> Fixes: bf109c64040f ("fuse: implement crossmounts")
> Cc: mreitz@redhat.com
> Cc: stable@vger.kernel.org # v5.10+
> Signed-off-by: Greg Kurz <groug@kaod.org>
> ---
>   fs/fuse/dir.c | 11 +++++++++++
>   1 file changed, 11 insertions(+)

Reviewed-by: Max Reitz <mreitz@redhat.com>

