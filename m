Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5DF3F5312
	for <lists+stable@lfdr.de>; Mon, 23 Aug 2021 23:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232931AbhHWVzY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 23 Aug 2021 17:55:24 -0400
Received: from foss.arm.com ([217.140.110.172]:57400 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232898AbhHWVzY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Aug 2021 17:55:24 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CF9D41042;
        Mon, 23 Aug 2021 14:54:40 -0700 (PDT)
Received: from [127.0.0.1] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5FB0B3F766;
        Mon, 23 Aug 2021 14:54:40 -0700 (PDT)
Date:   Mon, 23 Aug 2021 22:54:35 +0100
From:   Steven Price <steven.price@arm.com>
To:     dri-devel@lists.freedesktop.org,
        Alyssa Rosenzweig <alyssa@collabora.com>
CC:     Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Rob Herring <robh@kernel.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, linux-kernel@vger.kernel.org,
        Chris Morgan <macromorgan@hotmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] drm/panfrost: Simplify lock_region calculation
User-Agent: K-9 Mail for Android
In-Reply-To: <YSQOdDyLqiUccBq8@maud>
References: <20210820213117.13050-1-alyssa.rosenzweig@collabora.com> <20210820213117.13050-2-alyssa.rosenzweig@collabora.com> <192e5a1b-2caf-11a8-f090-ec5649ea16b5@arm.com> <YSQOdDyLqiUccBq8@maud>
Message-ID: <7076BF0A-C40E-4E5A-9185-FDB3882EC539@arm.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 23 August 2021 22:09:08 BST, Alyssa Rosenzweig <alyssa@collabora.com> wrote:
>> > In lock_region, simplify the calculation of the region_width parameter.
>> > This field is the size, but encoded as log2(ceil(size)) - 1.
>> > log2(ceil(size)) may be computed directly as fls(size - 1). However, we
>> > want to use the 64-bit versions as the amount to lock can exceed
>> > 32-bits.
>> > 
>> > This avoids undefined behaviour when locking all memory (size ~0),
>> > caught by UBSAN.
>> 
>> It might have been useful to mention what it is that UBSAN specifically
>> picked up (it took me a while to spot) - but anyway I think there's a
>> bigger issue with it being completely wrong when size == ~0 (see below).
>
>Indeed. I've updated the commit message in v2 to explain what goes
>wrong (your analysis was spot on, but a mailing list message is more
>ephermal than a commit message). I'll send out v2 tomorrow assuming
>nobody objects to v1 in the mean time.
>
>Thanks for the review.
>
>> There is potentially a third bug which kbase only recently attempted to
>> fix. The lock address is effectively rounded down by the hardware (the
>> bottom bits are ignored). So if you have mask=(1<<region_width)-1 but
>> (iova & mask) != ((iova + size) & mask) then you are potentially failing
>> to lock the end of the intended region. kbase has added some code to
>> handle this:
>> 
>> > 	/* Round up if some memory pages spill into the next region. */
>> > 	region_frame_number_start = pfn >> (lockaddr_size_log2 - PAGE_SHIFT);
>> > 	region_frame_number_end =
>> > 	    (pfn + num_pages - 1) >> (lockaddr_size_log2 - PAGE_SHIFT);
>> > 
>> > 	if (region_frame_number_start < region_frame_number_end)
>> > 		lockaddr_size_log2 += 1;
>> 
>> I guess we should too?
>
>Oh, I missed this one. Guess we have 4 bugs with this code instead of
>just 3, yikes. How could such a short function be so deeply and horribly
>broken? ����
>
>Should I add a fourth patch to the series to fix this?

Yes please!

Thanks,
Steve
