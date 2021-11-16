Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0D3C45291A
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 05:26:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240116AbhKPE1x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 23:27:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237774AbhKPE1q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 23:27:46 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6197C04EF8A
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 17:22:41 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id b13so16025217plg.2
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 17:22:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aLlAKKMK4zWJlIgrhsHRMUlQ2PCfb9lNnyiaBk8geX0=;
        b=JlmmblLFDgw1DkNOb+baplsLuAjwNhPsBiIwdHZglimjMsSOKYUeT/5Non3ayn+dfp
         LuKbvw7NuKYlllrvRr5SIJmg42YuQGKiCbjJHNzIjVRe7nfCzhc2vt8sER++UKhMQoeg
         REGB9CZTDQNk8g/ErDe59wXD5O2+PmBWk94F4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aLlAKKMK4zWJlIgrhsHRMUlQ2PCfb9lNnyiaBk8geX0=;
        b=7JzOy5xPs8SFzI+ixqce2QXfVphOEJ/bK52es9082CmsbXuDwbLT0w2DRZUgRFoTSI
         sbsmzaLIAyBqdkO492dEm/Ls/ofhtRp0hiB8O0AL3C48nDSfWas/WMdwNhTbgvMz4KHh
         R8fP+BUA1OEGO+mbD7Hz39TKf2hk3QBOU+xIUU3qBqCIFuZjk9K+evkv3lcAJ68s2jSQ
         NX90agAGmmzMQfdxFdzyQLpvz3tu6nY2qzx+DrcB5/zkHO0nr8qICJpb86Gr/8hjVe1G
         3dOanr9arCa/WR6YcX4gNQEym1/z3F+HJqpyBocDbKDEmUKVe4SZzzV3ROmVWbVwTcja
         RVEw==
X-Gm-Message-State: AOAM531P5qKHixWWosXB396UTGVDP37dyXnifHEs3gpxcC/tQBflZZkA
        pPe10H9x4KvokEqx0dEU0Wviiw==
X-Google-Smtp-Source: ABdhPJxOZsXh2an/fmXsdKtq1xUwYZYHofQN0Q0A3LR9drO9LA3LwIsyoH4icywOLygKi2bP49uZYQ==
X-Received: by 2002:a17:90a:9294:: with SMTP id n20mr3773465pjo.69.1637025761136;
        Mon, 15 Nov 2021 17:22:41 -0800 (PST)
Received: from google.com ([240f:75:7537:3187:1c10:fee2:d55b:53cd])
        by smtp.gmail.com with ESMTPSA id z3sm16223760pfh.79.2021.11.15.17.22.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 17:22:40 -0800 (PST)
Date:   Tue, 16 Nov 2021 10:22:36 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 228/917] media: videobuf2: rework vb2_mem_ops API
Message-ID: <YZMH3DJ7FbNZbx0G@google.com>
References: <20211115165428.722074685@linuxfoundation.org>
 <20211115165436.520296731@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211115165436.520296731@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On (21/11/15 17:55), Greg Kroah-Hartman wrote:
> From: Sergey Senozhatsky <senozhatsky@chromium.org>
> 
> [ Upstream commit a4b83deb3e76fb9385ca58e2c072a145b3a320d6 ]
> 
> With the new DMA API we need an extension of the videobuf2 API.
> Previously, videobuf2 core would set the non-coherent DMA bit
> in the vb2_queue dma_attr field (if user-space would pass a
> corresponding memory hint); the vb2 core then would pass the
> vb2_queue dma_attrs to the vb2 allocators. The vb2 allocator
> would use the queue's dma_attr and the DMA API would allocate
> either coherent or non-coherent memory.
> 
> But we cannot do this anymore, since there is no corresponding DMA
> attr flag and, hence, there is no way for the allocator to become
> aware of what type of allocation user-space has requested. So we
> need to pass more context from videobuf2 core to the allocators.
> 
> Fix this by changing the call_ptr_memop() macro to pass the
> vb2 pointer to the corresponding op callbacks.
> 
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Hello Greg, Sasha,

This patch needs two fix up patches to be applied.

The first one is in Linus's tree (media: videobuf2: always set buffer vb2 pointer)
67f85135c57c8ea20b5417b28ae65e53dc2ec2c3

The second one isn't yet (media: videobuf2-dma-sg: Fix buf->vb NULL pointer dereference)
https://lore.kernel.org/all/20211101145355.533704-1-hdegoede@redhat.com/raw
