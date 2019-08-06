Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C9CB83A98
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 22:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726018AbfHFUry (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 16:47:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:42486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbfHFUry (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 16:47:54 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A072920818;
        Tue,  6 Aug 2019 20:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565124473;
        bh=RakBuwBGrY+azH+7tmqZujcCvObRIfw33bNypTeqrrc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tqJcW5eHYR/2bmaQ42ysg0wI0NXpFe4nRE0VCwef+hXoZChcFrRKZ2zQw7SX7MSXC
         dpBqHkzk5Z0cBKZHuy2RnqZW43nk8fuyULIHJaNo4sQGE0CvfGkXsFm7x1D4+h34an
         DK9QMqzlFwLsC30ZwZhf/xv4TvUNkBNx2Zcg8NW4=
Date:   Tue, 6 Aug 2019 16:47:52 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Stephen Boyd <swboyd@chromium.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Steven Price <steven.price@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4.19] Revert "initramfs: free initrd memory if opening
 /initrd.image fails"
Message-ID: <20190806204752.GG17747@sasha-vm>
References: <20190806175940.156412-1-swboyd@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190806175940.156412-1-swboyd@chromium.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 06, 2019 at 10:59:40AM -0700, Stephen Boyd wrote:
>This reverts commit 25511676362d8f7d4b8805730a3d29484ceab1ec in the 4.19
>stable trees. From what I can tell this commit doesn't do anything to
>improve the situation, mostly just reordering code to call free_initrd()
>from one place instead of many. In doing that, it causes free_initrd()
>to be called even in the case when there isn't an initrd present. That
>leads to virtual memory bugs that manifest on arm64 devices.
>
>The fix has been merged upstream in commit 5d59aa8f9ce9 ("initramfs:
>don't free a non-existent initrd"), but backporting that here is more
>complicated because the patch is stacked upon this patch being reverted
>along with more patches that rewrites the logic in this area.
>
>Let's just revert the patch from the stable tree instead of trying to
>backport a collection of fixes to get the final fix from upstream.

The only dependency for taking the fix, 5d59aa8f9ce9, into 4.19 is
23091e28735 ("initramfs: cleanup initrd freeing") which is not too
scary.

Is it the case that 25511676362d8 shouldn't have been backported to 4.19
for some reason? If it fixes something on 4.19, I think it's better to
take the dependency and the fix instead of reverting.

--
Thanks,
Sasha
