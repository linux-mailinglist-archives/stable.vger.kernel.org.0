Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9314858CBC7
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 18:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242339AbiHHQCL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Aug 2022 12:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237231AbiHHQCK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Aug 2022 12:02:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3C680641E
        for <stable@vger.kernel.org>; Mon,  8 Aug 2022 09:02:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659974529;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v+VLxN4BnSUnRtGOHcjHhnP7NJbMaGRF/+oLZoagv+Q=;
        b=g7xUch6yKI8DTa6DF3VmJhUqmmuuQK2SQLF6X5XjKxeWG3d5PUQ2s/0nmOCniFvoUkuawt
        GfaaYMohYjnGRAvmVtNHXYBjBBoSbfBqAh73mcXBC/ahJv8NjyeCz7/2mbDEo/Jeciwtx/
        bUr1sLg+3vg9houQ0qnUzxiuHR/Ze5M=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-315-DDIW_9tRPqSVCGnxXgQFXg-1; Mon, 08 Aug 2022 12:02:05 -0400
X-MC-Unique: DDIW_9tRPqSVCGnxXgQFXg-1
Received: by mail-wm1-f72.google.com with SMTP id m4-20020a7bce04000000b003a386063752so1680975wmc.1
        for <stable@vger.kernel.org>; Mon, 08 Aug 2022 09:02:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=v+VLxN4BnSUnRtGOHcjHhnP7NJbMaGRF/+oLZoagv+Q=;
        b=El/iXF5YeHD2mMvUvK8fYdq8bL4yD2opEn3rJ60lMAE0ikiTDA4x5dUO59ZljVAt/D
         cUpfftnb8G1UjHLfDPBlA5eevifQWiNSDULx4+WPV5BLgOVKxu7I/2u9/TWSp6u1Anny
         xSv0RccDOXPn+QtswIXSlkvq40R3CCupU7YFR6rlYOXJCHCwBZwgle0NR0Cpm22X373b
         peIRTLXNwoCi/XPEqSBNIuz4qed2g8nGvFea+BH+cakdi8tVsA/bpIyocw2qXgdfrPaa
         L07f1bfLizvURzwmh7RApyIk/TiiXAxf1FNaXGZxB6lrZzy4ELV4GWZL1k6ufr2KHb/H
         XnLA==
X-Gm-Message-State: ACgBeo3zZcUAWEcw4MuMK9oRxRS3uA9a0Z12J+ZvFJ1t5xWH+lhut6Hn
        Ss0h3H09P6x+M2r0xxHIyb3mNNMXjXRAvefJEFiG9ovPgQphTIbB0LmUxa0p8OhZ6m43ffpXwb6
        CjNzmWLy/fxZ4Ep56
X-Received: by 2002:a05:6000:1a41:b0:20e:687f:1c3 with SMTP id t1-20020a0560001a4100b0020e687f01c3mr11547706wry.415.1659974524210;
        Mon, 08 Aug 2022 09:02:04 -0700 (PDT)
X-Google-Smtp-Source: AA6agR67Pq4plyoq9gtFCwaC8JrukP/DJqd25ev+P8l5w9C9NNDAqkHXuQ2j70Mv0jTTVryoR8cIsg==
X-Received: by 2002:a05:6000:1a41:b0:20e:687f:1c3 with SMTP id t1-20020a0560001a4100b0020e687f01c3mr11547684wry.415.1659974523955;
        Mon, 08 Aug 2022 09:02:03 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f15:c300:d2ce:1fb5:2460:179a? (p200300d82f15c300d2ce1fb52460179a.dip0.t-ipconnect.de. [2003:d8:2f15:c300:d2ce:1fb5:2460:179a])
        by smtp.gmail.com with ESMTPSA id e27-20020adfa45b000000b0021e519eba9bsm11746517wra.42.2022.08.08.09.02.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Aug 2022 09:02:03 -0700 (PDT)
Message-ID: <b5b90e42-7ea9-9804-9e13-280c97b04a18@redhat.com>
Date:   Mon, 8 Aug 2022 18:02:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v1] mm/gup: fix FOLL_FORCE COW security issue and remove
 FOLL_COW
Content-Language: en-US
To:     linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Peter Xu <peterx@redhat.com>, Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        John Hubbard <jhubbard@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>, Nadav Amit <namit@vmware.com>
References: <20220808073232.8808-1-david@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20220808073232.8808-1-david@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08.08.22 09:32, David Hildenbrand wrote:
> Ever since the Dirty COW (CVE-2016-5195) security issue happened, we know
> that FOLL_FORCE can be possibly dangerous, especially if there are races
> that can be exploited by user space.
> 
> Right now, it would be sufficient to have some code that sets a PTE of
> a R/O-mapped shared page dirty, in order for it to erroneously become
> writable by FOLL_FORCE. The implications of setting a write-protected PTE
> dirty might not be immediately obvious to everyone.
> 
> And in fact ever since commit 9ae0f87d009c ("mm/shmem: unconditionally set
> pte dirty in mfill_atomic_install_pte"), we can use UFFDIO_CONTINUE to map
> a shmem page R/O while marking the pte dirty. This can be used by
> unprivileged user space to modify tmpfs/shmem file content even if the user
> does not have write permissions to the file -- Dirty COW restricted to
> tmpfs/shmem (CVE-2022-2590).
> 
> To fix such security issues for good, the insight is that we really only
> need that fancy retry logic (FOLL_COW) for COW mappings that are not
> writable (!VM_WRITE). And in a COW mapping, we really only broke COW if
> we have an exclusive anonymous page mapped. If we have something else
> mapped, or the mapped anonymous page might be shared (!PageAnonExclusive),
> we have to trigger a write fault to break COW. If we don't find an
> exclusive anonymous page when we retry, we have to trigger COW breaking
> once again because something intervened.
> 
> Let's move away from this mandatory-retry + dirty handling and rely on
> our PageAnonExclusive() flag for making a similar decision, to use the
> same COW logic as in other kernel parts here as well. In case we stumble
> over a PTE in a COW mapping that does not map an exclusive anonymous page,
> COW was not properly broken and we have to trigger a fake write-fault to
> break COW.
> 
> Just like we do in can_change_pte_writable() added via
> commit 64fe24a3e05e ("mm/mprotect: try avoiding write faults for exclusive
> anonymous pages when changing protection") and commit 76aefad628aa
> ("mm/mprotect: fix soft-dirty check in can_change_pte_writable()"), take
> care of softdirty and uffd-wp manually.
> 
> For example, a write() via /proc/self/mem to a uffd-wp-protected range has
> to fail instead of silently granting write access and bypassing the
> userspace fault handler. Note that FOLL_FORCE is not only used for debug
> access, but also triggered by applications without debug intentions, for
> example, when pinning pages via RDMA.
> 
> This fixes CVE-2022-2590. Note that only x86_64 and aarch64 are
> affected, because only those support CONFIG_HAVE_ARCH_USERFAULTFD_MINOR.
> 
> Fortunately, FOLL_COW is no longer required to handle FOLL_FORCE. So
> let's just get rid of it.

I have to add here:

"Thanks to Nadav Amit for pointing out that the pte_dirty() check in
FOLL_FORCE code is problematic and might be exploitable."

-- 
Thanks,

David / dhildenb

