Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9551D6DED17
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 09:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbjDLH7b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 03:59:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjDLH7a (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 03:59:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B4214EE8
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 00:59:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0322F62F0C
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 07:59:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1574FC433EF;
        Wed, 12 Apr 2023 07:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681286368;
        bh=cS4JdMy9GiXSblOzE4DQfk+smFmAd7Kirm5hwYXwYw8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p9TtDn7lnMfy5gYgE+zfVW8V4y4T3Td5NzgM42L3SbxIa5GoNpqKVkv/+hW5+DZzm
         tsUCojahAU/XLKOPH83SDxxSJcJJu9ClzOsIxh/Tx7+4DawHRojEheJoxGzvxcQA5a
         vH77zjMEYk88cRx7feZjqzYwMJcSRyx+CwkGmVms=
Date:   Wed, 12 Apr 2023 09:59:26 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alistair Popple <apopple@nvidia.com>
Cc:     stable@vger.kernel.org, Ralph Campbell <rcampbell@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        David Hildenbrand <david@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6.2.y] mm: take a page reference when removing device
 exclusive entries
Message-ID: <2023041216-catalyze-query-7282@gregkh>
References: <2023041153-unlikable-steam-cf2b@gregkh>
 <20230412011831.152625-1-apopple@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230412011831.152625-1-apopple@nvidia.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 12, 2023 at 11:18:31AM +1000, Alistair Popple wrote:
> Device exclusive page table entries are used to prevent CPU access to a
> page whilst it is being accessed from a device.  Typically this is used to
> implement atomic operations when the underlying bus does not support
> atomic access.  When a CPU thread encounters a device exclusive entry it
> locks the page and restores the original entry after calling mmu notifiers
> to signal drivers that exclusive access is no longer available.
> 
> The device exclusive entry holds a reference to the page making it safe to
> access the struct page whilst the entry is present.  However the fault
> handling code does not hold the PTL when taking the page lock.  This means
> if there are multiple threads faulting concurrently on the device
> exclusive entry one will remove the entry whilst others will wait on the
> page lock without holding a reference.
> 
> This can lead to threads locking or waiting on a folio with a zero
> refcount.  Whilst mmap_lock prevents the pages getting freed via munmap()
> they may still be freed by a migration.  This leads to warnings such as
> PAGE_FLAGS_CHECK_AT_FREE due to the page being locked when the refcount
> drops to zero.
> 
> Fix this by trying to take a reference on the folio before locking it.
> The code already checks the PTE under the PTL and aborts if the entry is
> no longer there.  It is also possible the folio has been unmapped, freed
> and re-allocated allowing a reference to be taken on an unrelated folio.
> This case is also detected by the PTE check and the folio is unlocked
> without further changes.
> 
> Link: https://lkml.kernel.org/r/20230330012519.804116-1-apopple@nvidia.com
> Fixes: b756a3b5e7ea ("mm: device exclusive memory access")
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> Reviewed-by: Ralph Campbell <rcampbell@nvidia.com>
> Reviewed-by: John Hubbard <jhubbard@nvidia.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> (cherry picked from commit 7c7b962938ddda6a9cd095de557ee5250706ea88)
> ---
>  mm/memory.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)

All backports now queued up, thanks.

greg k-h
