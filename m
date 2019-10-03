Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C933C9EB2
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 14:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbfJCMpi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 08:45:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:58100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725827AbfJCMpi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 08:45:38 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3524920862;
        Thu,  3 Oct 2019 12:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570106737;
        bh=W35vWbr3POGzrA/RrD9w96e9HHM20loggocp+PmpuN4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FC16RiTU8lBWBn9FXv+4XGeJu7gcR7mGezCze/IU03WTJtVq/RlUh6h6uXh8TIov5
         dQjUPqrInF+rb4u7eo9yblFgBlfU0JQMaLMwHQKRmKLDB2MvOG/A8u1XM52Pz5AC8H
         6aON4h50b1mU4AOM7xZ369CVOBqqL4HVLlgzaCDs=
Date:   Thu, 3 Oct 2019 08:45:36 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     neilb@suse.de, guoqing.jiang@cloud.ionos.com,
        songliubraving@fb.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] md/raid0: avoid RAID0 data corruption due
 to layout" failed to apply to 5.3-stable tree
Message-ID: <20191003124536.GU17454@sasha-vm>
References: <1570089215120157@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1570089215120157@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 03, 2019 at 09:53:35AM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.3-stable tree.
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
>From c84a1372df929033cb1a0441fb57bd3932f39ac9 Mon Sep 17 00:00:00 2001
>From: NeilBrown <neilb@suse.de>
>Date: Mon, 9 Sep 2019 16:30:02 +1000
>Subject: [PATCH] md/raid0: avoid RAID0 data corruption due to layout
> confusion.
>
>If the drives in a RAID0 are not all the same size, the array is
>divided into zones.
>The first zone covers all drives, to the size of the smallest.
>The second zone covers all drives larger than the smallest, up to
>the size of the second smallest - etc.
>
>A change in Linux 3.14 unintentionally changed the layout for the
>second and subsequent zones.  All the correct data is still stored, but
>each chunk may be assigned to a different device than in pre-3.14 kernels.
>This can lead to data corruption.
>
>It is not possible to determine what layout to use - it depends which
>kernel the data was written by.
>So we add a module parameter to allow the old (0) or new (1) layout to be
>specified, and refused to assemble an affected array if that parameter is
>not set.
>
>Fixes: 20d0189b1012 ("block: Introduce new bio_split()")
>cc: stable@vger.kernel.org (3.14+)
>Acked-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
>Signed-off-by: NeilBrown <neilb@suse.de>
>Signed-off-by: Song Liu <songliubraving@fb.com>

Had to adjust context slightly due to missing 62f7b1989c02f ("md
raid0/linear: Mark array as 'broken' and fail BIOs if a member is
gone)" in 5.3-4.14.

On 4.9 and 4.4 we need a more complex backport which I didn't attempt
due to missing be306c2989804 ("md: define mddev flags, recovery flags
and r1bio state bits using enums") and a few fixes of that.

Queued up for 5.3-4.14.

--
Thanks,
Sasha
