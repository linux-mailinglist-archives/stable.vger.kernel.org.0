Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9BA73F5291
	for <lists+stable@lfdr.de>; Mon, 23 Aug 2021 23:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232627AbhHWVKD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 17:10:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232503AbhHWVKD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Aug 2021 17:10:03 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DDCBC061575;
        Mon, 23 Aug 2021 14:09:20 -0700 (PDT)
Received: from maud (unknown [IPv6:2600:8800:8c06:1000::c8f3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: alyssa)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 336701F425BC;
        Mon, 23 Aug 2021 22:09:14 +0100 (BST)
Date:   Mon, 23 Aug 2021 17:09:08 -0400
From:   Alyssa Rosenzweig <alyssa@collabora.com>
To:     Steven Price <steven.price@arm.com>
Cc:     Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        dri-devel@lists.freedesktop.org, Rob Herring <robh@kernel.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, linux-kernel@vger.kernel.org,
        Chris Morgan <macromorgan@hotmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] drm/panfrost: Simplify lock_region calculation
Message-ID: <YSQOdDyLqiUccBq8@maud>
References: <20210820213117.13050-1-alyssa.rosenzweig@collabora.com>
 <20210820213117.13050-2-alyssa.rosenzweig@collabora.com>
 <192e5a1b-2caf-11a8-f090-ec5649ea16b5@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <192e5a1b-2caf-11a8-f090-ec5649ea16b5@arm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> > In lock_region, simplify the calculation of the region_width parameter.
> > This field is the size, but encoded as log2(ceil(size)) - 1.
> > log2(ceil(size)) may be computed directly as fls(size - 1). However, we
> > want to use the 64-bit versions as the amount to lock can exceed
> > 32-bits.
> > 
> > This avoids undefined behaviour when locking all memory (size ~0),
> > caught by UBSAN.
> 
> It might have been useful to mention what it is that UBSAN specifically
> picked up (it took me a while to spot) - but anyway I think there's a
> bigger issue with it being completely wrong when size == ~0 (see below).

Indeed. I've updated the commit message in v2 to explain what goes
wrong (your analysis was spot on, but a mailing list message is more
ephermal than a commit message). I'll send out v2 tomorrow assuming
nobody objects to v1 in the mean time.

Thanks for the review.

> There is potentially a third bug which kbase only recently attempted to
> fix. The lock address is effectively rounded down by the hardware (the
> bottom bits are ignored). So if you have mask=(1<<region_width)-1 but
> (iova & mask) != ((iova + size) & mask) then you are potentially failing
> to lock the end of the intended region. kbase has added some code to
> handle this:
> 
> > 	/* Round up if some memory pages spill into the next region. */
> > 	region_frame_number_start = pfn >> (lockaddr_size_log2 - PAGE_SHIFT);
> > 	region_frame_number_end =
> > 	    (pfn + num_pages - 1) >> (lockaddr_size_log2 - PAGE_SHIFT);
> > 
> > 	if (region_frame_number_start < region_frame_number_end)
> > 		lockaddr_size_log2 += 1;
> 
> I guess we should too?

Oh, I missed this one. Guess we have 4 bugs with this code instead of
just 3, yikes. How could such a short function be so deeply and horribly
broken? 😃

Should I add a fourth patch to the series to fix this?
