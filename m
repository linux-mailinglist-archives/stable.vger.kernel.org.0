Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7C96102A9
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 22:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236888AbiJ0U0B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 16:26:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236867AbiJ0U0A (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 16:26:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A93DF5EDD6;
        Thu, 27 Oct 2022 13:25:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44968624D7;
        Thu, 27 Oct 2022 20:25:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18137C433C1;
        Thu, 27 Oct 2022 20:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666902358;
        bh=URPpMsa+EIMCx1JWWkXOR1/blBrJYJpsa2cKAC8XdO8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=osGFa6VEgACvzcZvzx9pqaJAIaExsqGHzFjsFS2DpwddXssJa+2Ogd/6yCCTxPNen
         ILXp45Ptp6mZo9xiR0fBqh5wk+5S+VeOmhHbC0gQLFHDObATd2FlvSZN0vwb9uwJr3
         1FCwRNzAluaWmStka2bWwQWzuNw3SrCYmPk4Xxg4=
Date:   Thu, 27 Oct 2022 13:25:57 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     NARIBAYASHI Akira <a.naribayashi@fujitsu.com>
Cc:     vbabka@suse.cz, mgorman@techsingularity.net, rientjes@google.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] mm, compaction: fix fast_isolate_around() to stay
 within boundaries
Message-Id: <20221027132557.5f724149bd5753036f41512a@linux-foundation.org>
In-Reply-To: <20221026112438.236336-1-a.naribayashi@fujitsu.com>
References: <20221026112438.236336-1-a.naribayashi@fujitsu.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 26 Oct 2022 20:24:38 +0900 NARIBAYASHI Akira <a.naribayashi@fujitsu.com> wrote:

> Depending on the memory configuration, isolate_freepages_block() may
> scan pages out of the target range and causes panic.
> 
> The problem is that pfn as argument of fast_isolate_around() could
> be out of the target range. Therefore we should consider the case
> where pfn < start_pfn, and also the case where end_pfn < pfn.
> 
> This problem should have been addressd by the commit 6e2b7044c199
> ("mm, compaction: make fast_isolate_freepages() stay within zone")
> but there was an oversight.
> 
>  Case1: pfn < start_pfn
> 
>   <at memory compaction for node Y>
>   |  node X's zone  | node Y's zone
>   +-----------------+------------------------------...
>    pageblock    ^   ^     ^
>   +-----------+-----------+-----------+-----------+...
>                 ^   ^     ^
>                 ^   ^      end_pfn
>                 ^    start_pfn = cc->zone->zone_start_pfn
>                  pfn
>                 <---------> scanned range by "Scan After"
> 
>  Case2: end_pfn < pfn
> 
>   <at memory compaction for node X>
>   |  node X's zone  | node Y's zone
>   +-----------------+------------------------------...
>    pageblock  ^     ^   ^
>   +-----------+-----------+-----------+-----------+...
>               ^     ^   ^
>               ^     ^    pfn
>               ^      end_pfn
>                start_pfn
>               <---------> scanned range by "Scan Before"
> 
> It seems that there is no good reason to skip nr_isolated pages
> just after given pfn. So let perform simple scan from start to end
> instead of dividing the scan into "Before" and "After".

Under what circumstances will this panic occur?  I assume those
circumstnces are pretty rare, give that 6e2b7044c1992 was nearly two
years ago.

Did you consider the desirability of backporting this fix into earlier
kernels?

