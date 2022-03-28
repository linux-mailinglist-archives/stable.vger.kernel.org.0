Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A377C4E8F4F
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 09:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237771AbiC1Hwv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 03:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237327AbiC1Hwu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 03:52:50 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C13852E4F;
        Mon, 28 Mar 2022 00:51:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3291ACE10D4;
        Mon, 28 Mar 2022 07:51:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D9CEC004DD;
        Mon, 28 Mar 2022 07:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648453867;
        bh=+JP5Ab1oWpqS8fzwyXV7SypqA8884zZbHeYFiDOUYbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:From;
        b=g9VuNeim6joiptQyzGGlTwbrBJQBHdctKG6oRM0jRe1VX0NJtCshIKkdWYVGjPZ4+
         XXzzmE4Fzok/ffsHEJLyeqpKnFXxLftxIU/U78JmBqoSsW5plU9xnDOirD5Pq6jdTc
         2u3YtpjgKL3p1uq2PWefOEmCvndNcIUEfA9i6JZEpJ6de1MFEQClXZL0fl+36O+v3d
         Rnr2SEcVbmirNVC4QGXeONOWn32wOesViauO0u5MatbM4A7qpcSUjIRVVTm7OdKz5j
         7vkPuvKBjN6JiJSEgR6W8XGycvTod39XKTuHHITwEuUGmGIMjOKaHCY1ByBzWIW8hf
         Ea16OCChdMx0Q==
From:   sj@kernel.org
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>
Cc:     sj@kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] damon: vaddr-test: fix a missing check on list iterator
Date:   Mon, 28 Mar 2022 07:51:04 +0000
Message-Id: <20220328075104.31125-1-sj@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220327080345.12295-1-xiam0nd.tong@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Xiaomeng,

On Sun, 27 Mar 2022 16:03:45 +0800 Xiaomeng Tong <xiam0nd.tong@gmail.com> wrote:

> The bug is here:
> 	KUNIT_EXPECT_EQ(test, r->ar.start, start + i * expected_width);
> 	KUNIT_EXPECT_EQ(test, r->ar.end, end);
> 
> For the damon_for_each_region(), just like list_for_each_entry(),
> the list iterator 'drm_crtc' will point to a bogus position
> containing HEAD if the list is empty or no element is found.
> This case must be checked before any use of the iterator,
> otherwise it will lead to a invalid memory access.

We ensure 'damon_va_evenly_split_region()' successes before executing the loop,
so the issue cannot occur.  That said, I think this patch makes code better to
read.  Could you please resend this patch after fixing the commit message?

> 
> To fix this bug, just mov two KUNIT_EXPECT_EQ() into the loop

s/mov/move

> when found.
> 
> Cc: stable@vger.kernel.org
> Fixes: 044cd9750fe01 ("mm/damon/vaddr-test: split a test function having >1024 bytes frame size")
> Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
> ---
>  mm/damon/vaddr-test.h | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/damon/vaddr-test.h b/mm/damon/vaddr-test.h
> index 6a1b9272ea12..98b7a9f54b35 100644
> --- a/mm/damon/vaddr-test.h
> +++ b/mm/damon/vaddr-test.h
> @@ -281,14 +281,16 @@ static void damon_test_split_evenly_succ(struct kunit *test,
>  	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), nr_pieces);

As mentioned above, this will ensure the loop will not result in the bogus
pointer problem.

>  
>  	damon_for_each_region(r, t) {
> -		if (i == nr_pieces - 1)
> +		if (i == nr_pieces - 1) {
> +			KUNIT_EXPECT_EQ(test,
> +				r->ar.start, start + i * expected_width);
> +			KUNIT_EXPECT_EQ(test, r->ar.end, end);
>  			break;
> +		}
>  		KUNIT_EXPECT_EQ(test,
>  				r->ar.start, start + i++ * expected_width);
>  		KUNIT_EXPECT_EQ(test, r->ar.end, start + i * expected_width);
>  	}
> -	KUNIT_EXPECT_EQ(test, r->ar.start, start + i * expected_width);
> -	KUNIT_EXPECT_EQ(test, r->ar.end, end);
>  	damon_free_target(t);
>  }
>  
> -- 
> 2.17.1
> 
> 


Thanks,
SJ
