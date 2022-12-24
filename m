Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 706E5655879
	for <lists+stable@lfdr.de>; Sat, 24 Dec 2022 06:36:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231232AbiLXFga (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Dec 2022 00:36:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiLXFg3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Dec 2022 00:36:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B6D91AE
        for <stable@vger.kernel.org>; Fri, 23 Dec 2022 21:35:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671860140;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9inerhQQEwTB9gS95jFKFAYGecKLrmD2EeG2lXh213o=;
        b=LiJEpaF6lQMHy0O//IMNTPYxdBBSD2OF+ygU2VMGX6xPjetAY6elFj/CtCeem24R05yHZY
        w6UOlV54xP4YUOx1YyAC/BQ/HLcbBhDC25ZcIYGS29P9+3WmActJkTUnbfz/LyBdst7mWY
        9BM57r5d6KLh9Y+znkrWz+5iWM/hHVE=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-131--lJetEIpPrS7QEAJGyUM6A-1; Sat, 24 Dec 2022 00:35:38 -0500
X-MC-Unique: -lJetEIpPrS7QEAJGyUM6A-1
Received: by mail-ej1-f69.google.com with SMTP id jg25-20020a170907971900b007c0e98ad898so4483885ejc.15
        for <stable@vger.kernel.org>; Fri, 23 Dec 2022 21:35:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9inerhQQEwTB9gS95jFKFAYGecKLrmD2EeG2lXh213o=;
        b=pJokEqu04OPX7mq0sg71+bjjxZr3Bh8CbmYC75j9W1Wm429wDwcHWj9S8k+7e94KV+
         mrPQWOhzZp5Gwpyl0ykt0wZFS9ae1xe1WmHv4NpBg7HKTxkTIqoGqx8E1lVMRTiiqjML
         JkPPjL+sSYLOEQbzBAUWioy714DoyknSwl/1QBD7Z5Fgz2JH9SEfTnTtyuupeA9Hi7BF
         9TQpIZpQAFlbb+S3VW7VbcIApFfdVGDZ5XFTES2hUthU7HwVCAI3feD23i0H6NViQ0YO
         wAHsrU6Z273sbpdH38c7JS3yCzKXN6mrNfeJ9wSGr2Nwz1S+StniBFIfEl1+Qg1ollF1
         lL5Q==
X-Gm-Message-State: AFqh2koAVS5bgk6EAtSFEH6MHcHru/PnzgC9jRfc94C1GD+EHijyAWGX
        Dk5UfljHxZ6b8GOOPEpHZZna1bLVhPowwFwAeYSyFAr7JO4VzA6cESDlN1qgVs8N55BSJk65Dxc
        yP7mBQbUVOaKiizig
X-Received: by 2002:a17:906:65a:b0:7c1:7045:1a53 with SMTP id t26-20020a170906065a00b007c170451a53mr9229041ejb.15.1671860137872;
        Fri, 23 Dec 2022 21:35:37 -0800 (PST)
X-Google-Smtp-Source: AMrXdXud/Fb0wtBmXHI4TVa1R5iStbJI7HVjmtxNzdJlo5vEGwnAH05ulhj4IafppoZeQFZu1DEQKg==
X-Received: by 2002:a17:906:65a:b0:7c1:7045:1a53 with SMTP id t26-20020a170906065a00b007c170451a53mr9229005ejb.15.1671860137631;
        Fri, 23 Dec 2022 21:35:37 -0800 (PST)
Received: from redhat.com ([2.55.175.215])
        by smtp.gmail.com with ESMTPSA id a1-20020a170906684100b007c0f90a9cc5sm2140091ejs.105.2022.12.23.21.35.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Dec 2022 21:35:36 -0800 (PST)
Date:   Sat, 24 Dec 2022 00:35:30 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        almasrymina@google.com, alvaro.karsz@solid-run.com,
        anders.roxell@linaro.org, angus.chen@jaguarmicro.com,
        bobby.eshleman@bytedance.com, colin.i.king@gmail.com,
        dave@stgolabs.net, dengshaomin@cdjrlc.com, dmitry.fomichev@wdc.com,
        elic@nvidia.com, eperezma@redhat.com, gautam.dawar@xilinx.com,
        harshit.m.mogalapalli@oracle.com, jasowang@redhat.com,
        leiyang@redhat.com, lingshan.zhu@intel.com, lkft@linaro.org,
        lulu@redhat.com, m.szyprowski@samsung.com, nathan@kernel.org,
        pabeni@redhat.com, pizhenwei@bytedance.com, rafaelmendsr@gmail.com,
        ricardo.canuelo@collabora.com, ruanjinjie@huawei.com,
        sammler@google.com, set_pte_at@outlook.com, sfr@canb.auug.org.au,
        sgarzare@redhat.com, shaoqin.huang@intel.com,
        si-wei.liu@oracle.com, stable@vger.kernel.org, stefanha@gmail.com,
        sunnanyong@huawei.com, wangjianli@cdjrlc.com,
        wangrong68@huawei.com, weiyongjun1@huawei.com,
        xuanzhuo@linux.alibaba.com, yuancan@huawei.com
Subject: Re: [GIT PULL] virtio,vhost,vdpa: features, fixes, cleanups
Message-ID: <20221224003445-mutt-send-email-mst@kernel.org>
References: <20221222144343-mutt-send-email-mst@kernel.org>
 <CAHk-=wi6Gkr7hJz20+xD=pBuTrseccVgNR9ajU7=Bqbrdk1t4g@mail.gmail.com>
 <20221223172549-mutt-send-email-mst@kernel.org>
 <CAHk-=whpdP7X+L8RtGsonthr7Ffug=FhR+TrFe3JUyb5-zaYCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whpdP7X+L8RtGsonthr7Ffug=FhR+TrFe3JUyb5-zaYCA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 23, 2022 at 02:36:46PM -0800, Linus Torvalds wrote:
> On Fri, Dec 23, 2022 at 2:27 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > They were all there, just not as these commits, as I squashed fixups to
> > avoid bisect breakages with some configs. Did I do wrong?
> 
> I am literally looking at the next-20221214 state right now, doing
> 
>     git log linus/master.. -- drivers/vhost/vsock.c
>     git log linus/master.. -- drivers/vdpa/mlx5/
>     git log --grep="temporary variable type tweak"
> 
> and seeing nothing.
> 
> So none of these commits - in *any* form - were in linux-next last
> week as far as I can tell.
> 
>              Linus


They were in  next-20221220 though.

-- 
MST

