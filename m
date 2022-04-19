Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 696265076B6
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 19:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353185AbiDSRoG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 13:44:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236067AbiDSRoG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 13:44:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAE6827FF0;
        Tue, 19 Apr 2022 10:41:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0DCDB6151B;
        Tue, 19 Apr 2022 17:41:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF189C385AB;
        Tue, 19 Apr 2022 17:41:19 +0000 (UTC)
Date:   Tue, 19 Apr 2022 18:41:16 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Steve Capper <steve.capper@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v10] mm, hugetlbfs: Allow for "high" userspace addresses
Message-ID: <Yl70PJEfThn84awn@arm.com>
References: <ab847b6edb197bffdfe189e70fb4ac76bfe79e0d.1650033747.git.christophe.leroy@csgroup.eu>
 <20220415150929.a62cbad83c22d6304560f626@linux-foundation.org>
 <63e716ee-ad77-c087-20a7-4fda06ec1f68@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <63e716ee-ad77-c087-20a7-4fda06ec1f68@csgroup.eu>
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Apr 16, 2022 at 06:26:42AM +0000, Christophe Leroy wrote:
> Le 16/04/2022 à 00:09, Andrew Morton a écrit :
> > On Fri, 15 Apr 2022 16:45:13 +0200 Christophe Leroy <christophe.leroy@csgroup.eu> wrote:
> > 
> >> This is a fix for commit f6795053dac8 ("mm: mmap: Allow for "high"
> >> userspace addresses") for hugetlb.
> >>
> >> This patch adds support for "high" userspace addresses that are
> >> optionally supported on the system and have to be requested via a hint
> >> mechanism ("high" addr parameter to mmap).
> >>
> >> Architectures such as powerpc and x86 achieve this by making changes to
> >> their architectural versions of hugetlb_get_unmapped_area() function.
> >> However, arm64 uses the generic version of that function.
> >>
> >> So take into account arch_get_mmap_base() and arch_get_mmap_end() in
> >> hugetlb_get_unmapped_area(). To allow that, move those two macros
> >> out of mm/mmap.c into include/linux/sched/mm.h
> >>
> >> If these macros are not defined in architectural code then they default
> >> to (TASK_SIZE) and (base) so should not introduce any behavioural
> >> changes to architectures that do not define them.
> >>
> >> For the time being, only ARM64 is affected by this change.
> >>
> >> >From Catalin (ARM64):
> >>    We should have fixed hugetlb_get_unmapped_area() as well when we
> >> added support for 52-bit VA. The reason for commit f6795053dac8 was to
> >> prevent normal mmap() from returning addresses above 48-bit by default
> >> as some user-space had hard assumptions about this.
> >>
> >> It's a slight ABI change if you do this for hugetlb_get_unmapped_area()
> >> but I doubt anyone would notice. It's more likely that the current
> >> behaviour would cause issues, so I'd rather have them consistent.
> > 
> > I'm struggling to understand the need for a -stable backport from the
> > above text.
> > 
> > Could we please get a simple statement of the end-user visible effects
> > of the shortcoming?  Target audience is -stable tree maintainers, and
> > people who we've never heard of who will be wondering whether they should
> > add this to their organization's older kernel.
> 
> Catalin, can you help answering this question ? It was your 
> recommendation to tag this patch for stable in 
> https://patchwork.ozlabs.org/project/linuxppc-dev/patch/db238c1ca2d46e33c57328f8d450f2563e92f8c2.1639736449.git.christophe.leroy@csgroup.eu/

My reasoning was that we should have made hugetlb_get_unmapped_area()
consistent with arch_get_unmapped_area() since commit f6795053dac8 ("mm:
mmap: Allow for "high" userspace addresses").

Basically when arm64 gained support for 52-bit addresses we did not want
user-space calling mmap() to suddenly get such high addresses, otherwise
we could have inadvertently broken some programs (similar behaviour to
x86 here). Hence we added commit f6795053dac8. But we missed hugetlbfs
which could still get such high mmap() addresses. So in theory that's a
potential regression that should have bee addressed at the same time
as commit f6795053dac8 (and before arm64 enabled 52-bit addresses).

-- 
Catalin
