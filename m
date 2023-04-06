Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0F16DA230
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 22:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbjDFUHY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 16:07:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjDFUHX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 16:07:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11EB26A44;
        Thu,  6 Apr 2023 13:07:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3BE364B2F;
        Thu,  6 Apr 2023 20:07:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A6BCC433EF;
        Thu,  6 Apr 2023 20:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680811642;
        bh=gQwoDTS3ub+TjZRhwYbtU1P4YaBDlo3MUyuPnnHIKbg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=T9IQUPkIdSgBlNKH2SPFrNClp0DoyyRNLc/dtDjdkZtdvvigCTNIcqngKO+ukOiyI
         GigGHuQxXzI6BVSos1cJ7mRN3YLqUb0gbd1bwUW6K15LS+rRGAEG1OyPQxeS0Pilg2
         4sE6f5KmFR3N1hx5gyd/41YYQ1cwNeuHCwjSxOxs=
Date:   Thu, 6 Apr 2023 13:07:20 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Feiyang Chen <chenfeiyang@loongson.cn>,
        Alistair Popple <apopple@nvidia.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] arm64/mm: don't WARN when alloc/free-ing device private
 pages
Message-Id: <20230406130720.ba11ed2de992cc4c2485ad5d@linux-foundation.org>
In-Reply-To: <20230406040515.383238-1-jhubbard@nvidia.com>
References: <20230406040515.383238-1-jhubbard@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 5 Apr 2023 21:05:15 -0700 John Hubbard <jhubbard@nvidia.com> wrote:

> Although CONFIG_DEVICE_PRIVATE and hmm_range_fault() and related
> functionality was first developed on x86, it also works on arm64.
> However, when trying this out on an arm64 system, it turns out that
> there is a massive slowdown during the setup and teardown phases.
> 
> This slowdown is due to lots of calls to WARN_ON()'s that are checking
> for pages that are out of the physical range for the CPU. However,
> that's a design feature of device private pages: they are specfically
> chosen in order to be outside of the range of the CPU's true physical
> pages.
>
> ...
>
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -1157,8 +1157,10 @@ int __meminit vmemmap_check_pmd(pmd_t *pmdp, int node,
>  int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
>  		struct vmem_altmap *altmap)
>  {
> +/* Device private pages are outside of the CPU's physical page range. */
> +#ifndef CONFIG_DEVICE_PRIVATE
>  	WARN_ON((start < VMEMMAP_START) || (end > VMEMMAP_END));

For a simple expression like this to cause a "massive slowdown", I
assume the WARN is triggering.  But changelog doesn't mention massive
dmesg spewage?

Given Ard's comments, perhaps a switch to WARN_ON_ONCE() would suit?
