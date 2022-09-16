Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0365BA972
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 11:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbiIPJbP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 05:31:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiIPJbO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 05:31:14 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F154EA5C54
        for <stable@vger.kernel.org>; Fri, 16 Sep 2022 02:31:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 627DDCE1D3D
        for <stable@vger.kernel.org>; Fri, 16 Sep 2022 09:31:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F08CC433D6;
        Fri, 16 Sep 2022 09:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663320670;
        bh=H1Lg59d7QWblHNjenh1/DBN2Re+xr0Nu6m6KIAT3oVE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cJoMnDS4OP8OkX1JqwUdqwd7mpo6tiLn09AGi066vk7vlR6JCsWAGvfXimpHJAlxn
         bMW1H6RjZ+See8cA9SwV06hTNWplFRgo71wzNh4jlkMKDRGhiv5XWCKHgcdoYDwLvd
         94HXkrSd4Hr0UjQCMe3FESUl/192noWCGdwqBi6w=
Date:   Fri, 16 Sep 2022 11:31:36 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jann Horn <jannh@google.com>
Cc:     stable@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH stable 4.9-5.15] mm: Fix TLB flush for not-first PFNMAP
 mappings in unmap_region()
Message-ID: <YyRCeC+3l1NCWjXo@kroah.com>
References: <20220915142519.2941949-1-jannh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220915142519.2941949-1-jannh@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 15, 2022 at 04:25:19PM +0200, Jann Horn wrote:
> This is a stable-specific patch.
> I botched the stable-specific rewrite of
> commit b67fbebd4cf98 ("mmu_gather: Force tlb-flush VM_PFNMAP vmas"):
> As Hugh pointed out, unmap_region() actually operates on a list of VMAs,
> and the variable "vma" merely points to the first VMA in that list.
> So if we want to check whether any of the VMAs we're operating on is
> PFNMAP or MIXEDMAP, we have to iterate through the list and check each VMA.
> 
> Signed-off-by: Jann Horn <jannh@google.com>
> ---
>  mm/mmap.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)

Now queued up everywhere, thanks.

greg k-h
