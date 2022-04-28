Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE7E5513A69
	for <lists+stable@lfdr.de>; Thu, 28 Apr 2022 18:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350401AbiD1Qzd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Apr 2022 12:55:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235369AbiD1Qz3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Apr 2022 12:55:29 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB299A94E8
        for <stable@vger.kernel.org>; Thu, 28 Apr 2022 09:52:13 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id 126so3090067qkm.4
        for <stable@vger.kernel.org>; Thu, 28 Apr 2022 09:52:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :mime-version;
        bh=ge3ZPWN0M9amQ6mKSg0omt63Nk/S+2cZMmx9LZwp68s=;
        b=ljDUmMK6e/vLTCndgDDSANmK5RkqAFHOzkTv1LANQNLVtJx7jHydDO96kr/QUFkFL5
         8Mp9tmkS7I1gQxYtkwfpUlDsPs8GRBsJ0ykxxNJDKBb6pwlPNlweAukPs5GHsryNdD1b
         UzIVHdKWP0fKg7XjBrKILhxYCgKFsUk1K9I12+QrUiMWpL+PVE6a2tekJuW80qnjvAQ8
         3sdRbOUDWLoFE4GvDuaA6i9KYvoWLSxCsqbWD6osE3xFU4yOTQ3urv59AFsppRrpdZJn
         lImagqiFa9fVCtEPY+qnzhumXUrNulpfVQK2fGBCxYK+/uPY0EFdjxXwfNDtcJfC2hEo
         RCSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:mime-version;
        bh=ge3ZPWN0M9amQ6mKSg0omt63Nk/S+2cZMmx9LZwp68s=;
        b=P1SSFtM5teHH1+RC2s0G2DuSWfX40nTgmuVnkWcK2k8fz++GJ7ufYVPzl447uHALOq
         muSNQIv55EJieJuCeQwWQIWZk9T/sr9hn74BzRBDYMLkQY6ACLR36E9oSmEfkP90CsuK
         W6UawvqqC/IKYfp+oZMSVFvrqNcXC/Jqs/UcrIglEHhxxpo8feTlksOjC8t1XXAI7qcT
         4VWC8EIxUjXEbX8fmto8PT+Wo0MldbzzYohcKldBNu9n78dQGjksqLLkVLpLUj/3IeBv
         g+r3iOmsRMXKmsXfKzfErPHqxJhOUs/wwmSIDQnkGixQeR/BtrJUloVI6zKW6SgyYi4g
         zyJg==
X-Gm-Message-State: AOAM533UfB5Iin/AQ2xcLx0xNwNodIbKxS9rd4LTn02XaWmZJAJ4aRfJ
        4uljKLEex7lISqmRBHlIR9TXCQ==
X-Google-Smtp-Source: ABdhPJwzfes0ShPwouYNOLRg6xLyz9XwoSBWEQsuuqe3bVE9E4WYyzToSnX9IlhVbJ944pqcLt97bg==
X-Received: by 2002:a05:620a:28cb:b0:69e:befa:a4c5 with SMTP id l11-20020a05620a28cb00b0069ebefaa4c5mr20228939qkp.477.1651164732094;
        Thu, 28 Apr 2022 09:52:12 -0700 (PDT)
Received: from ripple.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id q27-20020a05620a039b00b0069c8307d9c4sm205919qkm.18.2022.04.28.09.52.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 09:52:11 -0700 (PDT)
Date:   Thu, 28 Apr 2022 09:51:58 -0700 (PDT)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@ripple.anvils
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hugh Dickins <hughd@google.com>,
        Yang Shi <shy828301@gmail.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-mm@kvack.org
Subject: Re: [PATCH AUTOSEL 13/14] mm/thp: ClearPageDoubleMap in first
 page_add_file_rmap()
In-Reply-To: <20220428154222.1230793-13-gregkh@linuxfoundation.org>
Message-ID: <c2ed1fe1-247e-e644-c367-87d32eb92cf5@google.com>
References: <20220428154222.1230793-1-gregkh@linuxfoundation.org> <20220428154222.1230793-13-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 28 Apr 2022, Greg Kroah-Hartman wrote:

> From: Hugh Dickins <hughd@google.com>
> 
> commit bd55b0c2d64e84a75575f548a33a3dfecc135b65 upstream.
> 
> PageDoubleMap is maintained differently for anon and for shmem+file: the
> shmem+file one was never cleared, because a safe place to do so could
> not be found; so it would blight future use of the cached hugepage until
> evicted.
> 
> See https://lore.kernel.org/lkml/1571938066-29031-1-git-send-email-yang.shi@linux.alibaba.com/
> 
> But page_add_file_rmap() does provide a safe place to do so (though later
> than one might wish): allowing testing to return to an initial state
> without a damaging drop_caches.
> 
> Link: https://lkml.kernel.org/r/61c5cf99-a962-9a25-597a-53ab1bd8fbc0@google.com
> Fixes: 9a73f61bdb8a ("thp, mlock: do not mlock PTE-mapped file huge pages")
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Reviewed-by: Yang Shi <shy828301@gmail.com>
> Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

NAK.

I thought we had a long-standing agreement that AUTOSEL does not try
to add patches from akpm's tree which had not been marked for stable.

(Whereas, if a developer asks for such a patch to be added to stable
later, and verifies the result, that's of course a different matter.)

I've chosen to answer to this patch of my 3 in your 14 AUTOSELs,
because this one is just an improvement, not at all a bugfix needed
for stable (maybe AUTOSEL noticed "racy" or "safely" in the comments,
and misunderstood).  The "Fixes" was intended to help any humans who
wanted to backport into their trees.

I do recall that this 13/14, and 14/14, are mods to mm/rmap.c
which followed other (mm/munlock) mods to mm/rmap.c in 5.18-rc1,
which affected the out path of the function involved, and somehow
made 14/14 a little cleaner.  I'm sorry, but I just don't rate it
worth my time at the moment, to verify whether 14/14 happens to
have ended up as a correct patch or not.

And nobody can verify them without these AUTOSELs saying to which
tree they are targeted - 5.17 I suppose.

Hugh

> ---
>  mm/rmap.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 9e27f9f038d3..444d0d958aff 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1252,6 +1252,17 @@ void page_add_file_rmap(struct page *page, bool compound)
>  		}
>  		if (!atomic_inc_and_test(compound_mapcount_ptr(page)))
>  			goto out;
> +
> +		/*
> +		 * It is racy to ClearPageDoubleMap in page_remove_file_rmap();
> +		 * but page lock is held by all page_add_file_rmap() compound
> +		 * callers, and SetPageDoubleMap below warns if !PageLocked:
> +		 * so here is a place that DoubleMap can be safely cleared.
> +		 */
> +		VM_WARN_ON_ONCE(!PageLocked(page));
> +		if (nr == nr_pages && PageDoubleMap(page))
> +			ClearPageDoubleMap(page);
> +
>  		if (PageSwapBacked(page))
>  			__mod_lruvec_page_state(page, NR_SHMEM_PMDMAPPED,
>  						nr_pages);
> -- 
> 2.36.0
