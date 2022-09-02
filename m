Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2498A5AA74A
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 07:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232771AbiIBFgX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 01:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231260AbiIBFgW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 01:36:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B738002B
        for <stable@vger.kernel.org>; Thu,  1 Sep 2022 22:36:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 540DDB829D6
        for <stable@vger.kernel.org>; Fri,  2 Sep 2022 05:36:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78A12C433D6;
        Fri,  2 Sep 2022 05:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662096978;
        bh=ZNcd+NWukL1V+FX9sFJvel3Rq+bUkTYt0Rqilbw2qho=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eB4Qpz2YjrW0VME/uPJqA7+G6Uy0E0GgcSdqUj2IiYFwk4kxg3krhX469Tn9WTrRd
         yZviiMpte0zCkg8bqwbGjyN8z9I3ku1rxFQ+TlupY8/w1EwKkcaj84D5KebXL4JT9M
         qjvtor5spRgB3WkE/QLPFvGnA2CkppYKshVGMW2Q=
Date:   Fri, 2 Sep 2022 07:36:16 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jann Horn <jannh@google.com>
Cc:     stable@vger.kernel.org, Michal Hocko <mhocko@suse.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 4.9] mm/rmap: Fix anon_vma->degree ambiguity leading to
 double-reuse
Message-ID: <YxGWUNlxlu0Oq35y@kroah.com>
References: <20220901192230.4099716-1-jannh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220901192230.4099716-1-jannh@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 01, 2022 at 09:22:30PM +0200, Jann Horn wrote:
> commit 2555283eb40df89945557273121e9393ef9b542b upstream.
> 
> anon_vma->degree tracks the combined number of child anon_vmas and VMAs
> that use the anon_vma as their ->anon_vma.
> 
> anon_vma_clone() then assumes that for any anon_vma attached to
> src->anon_vma_chain other than src->anon_vma, it is impossible for it to
> be a leaf node of the VMA tree, meaning that for such VMAs ->degree is
> elevated by 1 because of a child anon_vma, meaning that if ->degree
> equals 1 there are no VMAs that use the anon_vma as their ->anon_vma.
> 
> This assumption is wrong because the ->degree optimization leads to leaf
> nodes being abandoned on anon_vma_clone() - an existing anon_vma is
> reused and no new parent-child relationship is created.  So it is
> possible to reuse an anon_vma for one VMA while it is still tied to
> another VMA.
> 
> This is an issue because is_mergeable_anon_vma() and its callers assume
> that if two VMAs have the same ->anon_vma, the list of anon_vmas
> attached to the VMAs is guaranteed to be the same.  When this assumption
> is violated, vma_merge() can merge pages into a VMA that is not attached
> to the corresponding anon_vma, leading to dangling page->mapping
> pointers that will be dereferenced during rmap walks.
> 
> Fix it by separately tracking the number of child anon_vmas and the
> number of VMAs using the anon_vma as their ->anon_vma.
> 
> Fixes: 7a3ef208e662 ("mm: prevent endless growth of anon_vma hierarchy")
> Cc: stable@kernel.org
> Acked-by: Michal Hocko <mhocko@suse.com>
> Acked-by: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Jann Horn <jannh@google.com>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> [manually fixed up different indentation in stable]

Thanks, now queued up.

greg k-h
