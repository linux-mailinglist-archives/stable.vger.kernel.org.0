Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2575A86A8
	for <lists+stable@lfdr.de>; Wed, 31 Aug 2022 21:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbiHaTVY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Aug 2022 15:21:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiHaTVX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Aug 2022 15:21:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9764DDEB48
        for <stable@vger.kernel.org>; Wed, 31 Aug 2022 12:21:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 598F7B82220
        for <stable@vger.kernel.org>; Wed, 31 Aug 2022 19:21:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7402CC433C1;
        Wed, 31 Aug 2022 19:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661973680;
        bh=8WYUVbQsa+CJuG1qSh7T0i4xAHkvWN1U80oJeWSHkXU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GCkkyOIcfBIrD9q2iIgvboCaocBSB82TokbzGoZvzNu8ACKd7lvInrAMlGv0uPUlj
         hlMhYrktnG3AiTpSZiKmjgHQ/yiD6+S+lhzv1WHafWOtD4A0MNZLaWgK5LTbIG9RYK
         Uwr2QKtxPI3VmKs6Dg7J8WZfQ08f0OfSacNxhFlI=
Date:   Wed, 31 Aug 2022 21:21:17 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jann Horn <jannh@google.com>
Cc:     stable@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>
Subject: Re: [PATCH stable 4.9-5.15] mm: Force TLB flush for PFNMAP mappings
 before unlink_file_vma()
Message-ID: <Yw+0rQS/cr8F/JZC@kroah.com>
References: <20220831191348.3388208-1-jannh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220831191348.3388208-1-jannh@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 31, 2022 at 09:13:48PM +0200, Jann Horn wrote:
> commit b67fbebd4cf980aecbcc750e1462128bffe8ae15 upstream.
> 
> Some drivers rely on having all VMAs through which a PFN might be
> accessible listed in the rmap for correctness.
> However, on X86, it was possible for a VMA with stale TLB entries
> to not be listed in the rmap.
> 
> This was fixed in mainline with
> commit b67fbebd4cf9 ("mmu_gather: Force tlb-flush VM_PFNMAP vmas"),
> but that commit relies on preceding refactoring in
> commit 18ba064e42df3 ("mmu_gather: Let there be one tlb_{start,end}_vma()
> implementation") and commit 1e9fdf21a4339 ("mmu_gather: Remove per arch
> tlb_{start,end}_vma()").
> 
> This patch provides equivalent protection without needing that
> refactoring, by forcing a TLB flush between removing PTEs in
> unmap_vmas() and the call to unlink_file_vma() in free_pgtables().
> 
> [This is a stable-specific rewrite of the upstream commit!]
> Signed-off-by: Jann Horn <jannh@google.com>

Now queued up, thanks.

greg k-h
