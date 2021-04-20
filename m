Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E345365B65
	for <lists+stable@lfdr.de>; Tue, 20 Apr 2021 16:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231758AbhDTOqB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Apr 2021 10:46:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:53962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231682AbhDTOqB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Apr 2021 10:46:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA91A6101C
        for <stable@vger.kernel.org>; Tue, 20 Apr 2021 14:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618929929;
        bh=3Wq/myeqG2WuaR1l/jD/afU9P7Y9mykXJODnl5Ma+uI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=aUCc6EPFU3t4h9ea0JBLs/ygJaiQ0GdD1lHtb6GfofnCzSMOdCbbUdCVywMqAiW3W
         XAt577UVDyrOfGHcTG9WAx0rbIyjg33UzW6fNuX2BkWZh28Npq5AoZvN5k5fnhbJaY
         /QMqCdzEzgFyK8Doov+j9qwbunakCMEpjCTirsP1494sRDuQsvZS002fXMSAPqI8XT
         ddkx1BFZzt9RkS6bWUsmsjvKGQ14PDikJiJ87CjyYqnBgXoD7oaWCnjNFN7nP1Vv2p
         8kTvIf++L9jXLUgzllqtp0QLCKOaJMa8A+E1ur0oJems9nBzk31robFFljPx9II+el
         sgqU2SnEvVcSw==
Received: by mail-ej1-f53.google.com with SMTP id r20so8913817ejo.11
        for <stable@vger.kernel.org>; Tue, 20 Apr 2021 07:45:29 -0700 (PDT)
X-Gm-Message-State: AOAM531zWni645wxFl9Q6aOpXRUONNcwywi4LoDM1MyUlpSvs8cSUdNg
        Y7ng97SvBRm1IEyVWPEZzi2WpUymkLIpM534SQ==
X-Google-Smtp-Source: ABdhPJw6IlKey9LU5bKSxn2TVW90xUvRqF65eweNiOcWNI+jDVAzwOvLDUIYVSucp1UJzSi/6yevwWrEK+3pZzGbCgY=
X-Received: by 2002:a17:907:70d3:: with SMTP id yk19mr27811300ejb.108.1618929928233;
 Tue, 20 Apr 2021 07:45:28 -0700 (PDT)
MIME-Version: 1.0
References: <4a4734d6-49df-677b-71d3-b926c44d89a9@foss.st.com>
In-Reply-To: <4a4734d6-49df-677b-71d3-b926c44d89a9@foss.st.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Tue, 20 Apr 2021 09:45:16 -0500
X-Gmail-Original-Message-ID: <CAL_JsqKGG8E9Y53+az+5qAOOGiZRAA-aD-1tKB-hcOp+m3CJYw@mail.gmail.com>
Message-ID: <CAL_JsqKGG8E9Y53+az+5qAOOGiZRAA-aD-1tKB-hcOp+m3CJYw@mail.gmail.com>
Subject: Re: [v5.4 stable] arm: stm32: Regression observed on "no-map"
 reserved memory region
To:     Alexandre TORGUE <alexandre.torgue@foss.st.com>
Cc:     Quentin Perret <qperret@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 20, 2021 at 9:03 AM Alexandre TORGUE
<alexandre.torgue@foss.st.com> wrote:
>
> Hi,

Greg or Sasha won't know what to do with this. Not sure who follows
the stable list either. Quentin sent the patch, but is not the author.
Given the patch in question is about consistency between EFI memory
map boot and DT memory map boot, copying EFI knowledgeable folks would
help (Ard B for starters).

>
> Since v5.4.102 I observe a regression on stm32mp1 platform: "no-map"
> reserved-memory regions are no more "reserved" and make part of the
> kernel System RAM. This causes allocation failure for devices which try
> to take a reserved-memory region.
>
> It has been introduced by the following path:
>
> "fdt: Properly handle "no-map" field in the memory region
> [ Upstream commit 86588296acbfb1591e92ba60221e95677ecadb43 ]"
> which replace memblock_remove by memblock_mark_nomap in no-map case.
>
> Reverting this patch it's fine.
>
> I add part of my DT (something is maybe wrong inside):
>
> memory@c0000000 {
>         reg = <0xc0000000 0x20000000>;
> };
>
> reserved-memory {
>         #address-cells = <1>;
>         #size-cells = <1>;
>         ranges;
>
>         gpu_reserved: gpu@d4000000 {
>                 reg = <0xd4000000 0x4000000>;
>                 no-map;
>         };
> };
>
> Sorry if this issue has already been raised and discussed.
>
> Thanks
> alex
