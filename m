Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47F791AB51E
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 02:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730956AbgDPA5N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 20:57:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:41828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387482AbgDPA5E (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 20:57:04 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 446F8208E4;
        Thu, 16 Apr 2020 00:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586998623;
        bh=ZVUR+wOL/lRrPv60H//bNFDpUKWlzf571jBpNm+KHmw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wCSQonrb5Uu2MxOPS7Cu95OnBSqeuCKeEdJk9b3ZK4G3s7TVodMVf5CxTwDDC3BzR
         v0oXXgJnLmHFml/aAjbCb3pmpuNebkxdCr/3cMIjyrt2EYBailMHz9HmskVwOT/hzD
         HGkxAkefZmJZx51gZ4QguZhn8lN1KGsrnfEKaW5M=
Date:   Wed, 15 Apr 2020 20:57:02 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     ntsironis@arrikto.com, snitzer@redhat.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] dm clone: Fix handling of partial region
 discards" failed to apply to 5.4-stable tree
Message-ID: <20200416005702.GP1068@sasha-vm>
References: <1586948589138112@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1586948589138112@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 15, 2020 at 01:03:09PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.4-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From 4b5142905d4ff58a4b93f7c8eaa7ba829c0a53c9 Mon Sep 17 00:00:00 2001
>From: Nikos Tsironis <ntsironis@arrikto.com>
>Date: Fri, 27 Mar 2020 16:01:08 +0200
>Subject: [PATCH] dm clone: Fix handling of partial region discards
>
>There is a bug in the way dm-clone handles discards, which can lead to
>discarding the wrong blocks or trying to discard blocks beyond the end
>of the device.
>
>This could lead to data corruption, if the destination device indeed
>discards the underlying blocks, i.e., if the discard operation results
>in the original contents of a block to be lost.
>
>The root of the problem is the code that calculates the range of regions
>covered by a discard request and decides which regions to discard.
>
>Since dm-clone handles the device in units of regions, we don't discard
>parts of a region, only whole regions.
>
>The range is calculated as:
>
>    rs = dm_sector_div_up(bio->bi_iter.bi_sector, clone->region_size);
>    re = bio_end_sector(bio) >> clone->region_shift;
>
>, where 'rs' is the first region to discard and (re - rs) is the number
>of regions to discard.
>
>The bug manifests when we try to discard part of a single region, i.e.,
>when we try to discard a block with size < region_size, and the discard
>request both starts at an offset with respect to the beginning of that
>region and ends before the end of the region.
>
>The root cause is the following comparison:
>
>  if (rs == re)
>    // skip discard and complete original bio immediately
>
>, which doesn't take into account that 'rs' might be greater than 're'.
>
>Thus, we then issue a discard request for the wrong blocks, instead of
>skipping the discard all together.
>
>Fix the check to also take into account the above case, so we don't end
>up discarding the wrong blocks.
>
>Also, add some range checks to dm_clone_set_region_hydrated() and
>dm_clone_cond_set_range(), which update dm-clone's region bitmap.
>
>Note that the aforementioned bug doesn't cause invalid memory accesses,
>because dm_clone_is_range_hydrated() returns True for this case, so the
>checks are just precautionary.
>
>Fixes: 7431b7835f55 ("dm: add clone target")
>Cc: stable@vger.kernel.org # v5.4+
>Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
>Signed-off-by: Mike Snitzer <snitzer@redhat.com>

I've also grabbed 6ca43ed8376a ("dm clone: replace spin_lock_irqsave
with spin_lock_irq") to deal with this conflict.

-- 
Thanks,
Sasha
