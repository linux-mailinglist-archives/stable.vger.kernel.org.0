Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5896A2B88
	for <lists+stable@lfdr.de>; Sat, 25 Feb 2023 20:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbjBYTnY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Feb 2023 14:43:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbjBYTnX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Feb 2023 14:43:23 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D76BD10256
        for <stable@vger.kernel.org>; Sat, 25 Feb 2023 11:43:16 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id t14so2471767ljd.5
        for <stable@vger.kernel.org>; Sat, 25 Feb 2023 11:43:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FQ06yesyUgRY5DSL1h615Nm6fkq1Vhy1HsTju3YI3UI=;
        b=ZxiqbkUqEBDW1KNccJkKK7LUehWcaHJqIx3XuFbnY0uj4GN7vGXNoMgM5/cavjr+eG
         S2Kis6MUPpPXHH77SUCKr0RJ+zmzrUB7pGcj7cYvyAVN8DMoK0njiV/r8E4ayS2IIvv3
         BpeF5BTztR59OOV/oLZdOZU6cfSr1Q6W0MNXw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FQ06yesyUgRY5DSL1h615Nm6fkq1Vhy1HsTju3YI3UI=;
        b=gFzX0OSNyTq8gZKkREeCL1BuuIlVYrpxzNpRyX/xG58atSth8wW0H+/xHA79GxLEDR
         /aEa7AIAWWnZ2B0URlNtfomRVTA7w/eWgBsukkNAqZU3n5gD7DMyRWkKuBd3M6ZBTf7h
         tPCU+966+0u/OXZXsc0orJwfoeLkRjb8TThtrlyp2Ude3/9QhU3euXFN60+QzrEUhrhM
         oy4QSklOLpaTTmkA1Cx+cMF8SOFJqfNAFLRHWjCGDr81+dMbOQy8jZiRm18YLqpH/SkD
         vjSHgeNbNDm0TnKVXrHRNmg2ZiyvRHO2qf54LuIeNZFyZWhrLyawNDXvppQt95nHliJ0
         Vcpw==
X-Gm-Message-State: AO0yUKU7k5XirMqq3WCjDcg+ae9m/DDwsjyPzZHkDcFht/tyt1bARmyv
        zXNaDNPE2Osfq+0yiENUank33JUXnjOTvZyX533fUQ==
X-Google-Smtp-Source: AK7set+5ctNBZsVKFQODNTSp8JRGPQoHYGZafHxQq2PqYtgIpTfbJXHHb6i59aA/OgPsCTrixc0VwQ==
X-Received: by 2002:a05:651c:23a:b0:293:a444:f70f with SMTP id z26-20020a05651c023a00b00293a444f70fmr6389867ljn.33.1677354194746;
        Sat, 25 Feb 2023 11:43:14 -0800 (PST)
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com. [209.85.208.181])
        by smtp.gmail.com with ESMTPSA id o7-20020a2e9b47000000b00295b2e08b9dsm18696ljj.116.2023.02.25.11.43.14
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Feb 2023 11:43:14 -0800 (PST)
Received: by mail-lj1-f181.google.com with SMTP id a10so2497444ljq.1
        for <stable@vger.kernel.org>; Sat, 25 Feb 2023 11:43:14 -0800 (PST)
X-Received: by 2002:a17:907:60cd:b0:8f5:2e0e:6dc5 with SMTP id
 hv13-20020a17090760cd00b008f52e0e6dc5mr2490334ejc.0.1677354173776; Sat, 25
 Feb 2023 11:42:53 -0800 (PST)
MIME-Version: 1.0
References: <20230220194045-mutt-send-email-mst@kernel.org> <20230223020356-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230223020356-mutt-send-email-mst@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 25 Feb 2023 11:42:36 -0800
X-Gmail-Original-Message-ID: <CAHk-=wg-az1yPKQmmDMnTMdUrg8hLzPUiUtUQu9d2EbdquBOnQ@mail.gmail.com>
Message-ID: <CAHk-=wg-az1yPKQmmDMnTMdUrg8hLzPUiUtUQu9d2EbdquBOnQ@mail.gmail.com>
Subject: Re: [GIT PULL] virtio,vhost,vdpa: features, fixes
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        almasrymina@google.com, alvaro.karsz@solid-run.com,
        anders.roxell@linaro.org, bagasdotme@gmail.com,
        bhelgaas@google.com, colin.i.king@gmail.com,
        dmitry.fomichev@wdc.com, elic@nvidia.com, eperezma@redhat.com,
        hch@lst.de, jasowang@redhat.com, kangjie.xu@linux.alibaba.com,
        leiyang@redhat.com, liming.wu@jaguarmicro.com,
        lingshan.zhu@intel.com, liubo03@inspur.com, lkft@linaro.org,
        mie@igel.co.jp, m.szyprowski@samsung.com,
        ricardo.canuelo@collabora.com, sammler@google.com,
        sebastien.boeuf@intel.com, sfr@canb.auug.org.au,
        si-wei.liu@oracle.com, stable@vger.kernel.org, stefanha@gmail.com,
        suwan.kim027@gmail.com, xuanzhuo@linux.alibaba.com,
        yangyingliang@huawei.com, zyytlz.wz@163.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 22, 2023 at 11:06 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> Did I muck this one up?  Pls let me know and maybe I can fix it up
> before the merge window closes.

No much-ups, I've just been merging other things, and came back to
architectures updates and virtualization now, so it's next in my
queue.

           Linus
