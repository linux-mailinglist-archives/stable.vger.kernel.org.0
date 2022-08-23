Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED93059EBF6
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 21:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231467AbiHWTPq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 15:15:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232031AbiHWTO4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 15:14:56 -0400
Received: from mail-vk1-xa35.google.com (mail-vk1-xa35.google.com [IPv6:2607:f8b0:4864:20::a35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C07418992B
        for <stable@vger.kernel.org>; Tue, 23 Aug 2022 10:52:19 -0700 (PDT)
Received: by mail-vk1-xa35.google.com with SMTP id g185so5060974vkb.13
        for <stable@vger.kernel.org>; Tue, 23 Aug 2022 10:52:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=Es/SKRV3OFmw44FXdjOkfiW1qF34GTyugA5yXeHJg1o=;
        b=Htyr6zgvLeb7VOm7M8YiX0MsuKqOQFg/1Dp9MRFHsmMgRGKEd9WwyKRrcHeLFHDm29
         nM/bfzgL5k3eFrWzgPUgctn35VeUeDiJtJePnx7M8C0hWVKT2REkwMdmxOUxw1i9Lfw/
         CbaaQ7uMsAT/X0Ph7VPdpGckzFqaPwgU378K5NGCsUHDagyqlzkGONXRTiXCOcBGYWCI
         q+YsgKQhl5xhXQB8Pc+6yWmSx4zaOylSieaKP7lpCxr22IPB5+DWeJotUqS+aEZLUsRo
         lVTqqaXDT5t9QEmcI+bIRPwSAPgzInt39jLGTIsGH1dQuSP7u56N7t5qOqn2Fr4w4b5y
         /Ucw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=Es/SKRV3OFmw44FXdjOkfiW1qF34GTyugA5yXeHJg1o=;
        b=lajFwArbQ8cA31xN7zCeYNAVuaxxmlMh5mfnpZMmntCCYTav245dU9LS2w7wb+Jnqf
         AJZSUKoFtl5HSQ6G8rLoe/YdPR6E1yDHLDMxkpDKXLl7xtFAD1FzVyQ807b5OkKm0qXF
         53CVX2t+9cpGsS6uUoT9nYm81xbdrNkLLE7CIQhQEdxtF1ih8tBOkFFXrUkQTxzJkwmV
         jgEZkTYHZwjy1vBrRRqPywIEG/GgHQ4gFRHk5mOMNNuEWue9sn+puXDVOOL6kssjA+cX
         sF1TOkmA+ndpA4VcRqx/nWdtfvoTNFjqNqNTmZaXTEmHGC0flq9UiuPS7N6Sh0QGX4/Z
         hveQ==
X-Gm-Message-State: ACgBeo008abdZvn2+DvA5yv4pBHNUovCIYYgeK/5voTSS+Xxgtd9hgeW
        FUKXJgaFg+MYkqVKTCMdAMbhxLM4vZT5e86Ch3bUuA==
X-Google-Smtp-Source: AA6agR5LT5c2oH4HlSHea9+vMd6hW5j0wL9NLrJYmoLqS7f6O+74rga8DGg+9ywWJM7NvmxoN1meBCLo0cewOr+i/3A=
X-Received: by 2002:a1f:9b07:0:b0:378:7c48:c6c with SMTP id
 d7-20020a1f9b07000000b003787c480c6cmr9890448vke.32.1661277112758; Tue, 23 Aug
 2022 10:51:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220823080118.128342613@linuxfoundation.org> <20220823080131.532813281@linuxfoundation.org>
 <c49d3b2b-9f5a-4257-9085-f7ac107cff40@oracle.com>
In-Reply-To: <c49d3b2b-9f5a-4257-9085-f7ac107cff40@oracle.com>
From:   Yu Zhao <yuzhao@google.com>
Date:   Tue, 23 Aug 2022 11:51:16 -0600
Message-ID: <CAOUHufagA1x4jyjH9Q0RX65fwF3SyYHUTkNnB0S_t-2GqbiC2A@mail.gmail.com>
Subject: Re: [PATCH 5.19 319/365] swiotlb: panic if nslabs is too small
To:     Dongli Zhang <dongli.zhang@oracle.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christoph Hellwig <hch@lst.de>,
        Robin Murphy <robin.murphy@arm.com>,
        stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        iommu@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 23, 2022 at 11:25 AM Dongli Zhang <dongli.zhang@oracle.com> wrote:
>
> Adding Robin, Yu and swiotlb list.

Thanks.

> There is an on-going discussion whether to revert this patch, because it breaks
> a corner case in MIPS

I wouldn't call it a corner case. Cavium Octeon is the major platform
we use to test Debian MIPS ports [1], and 4 out of 5 best-selling
Wi-Fi routers are MIPS-based [2].

[1] https://wiki.debian.org/MIPSPort
[2] https://www.amazon.com/bestsellers/pc/300189

> when many kernel CONFIGs are not enabled (related to PCI
> and device). As a result, MIPS pre-allocates only PAGE_SIZE buffer as swiotlb.
>
> https://lore.kernel.org/all/20220820012031.1285979-1-yuzhao@google.com/
>
> However, the core idea of the patch is to panic on purpose if the swiotlb is
> configured with <1MB memory, in order to sync with the remap failure handler in
> swiotlb_init_remap().
>
> Therefore, I am waiting for suggestion from Christoph whether (1) to revert this
> patch, or (2) enforce the restriction to disallow <1MB allocation.

There are other archs (arm, ppc, riscv, s390, etc.) that call
swiotlb_init(). Have you verified them all?
