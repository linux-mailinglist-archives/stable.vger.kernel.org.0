Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 191541AB4E4
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 02:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405141AbgDPAvw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 20:51:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:40358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405166AbgDPAvt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 20:51:49 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F879208E4;
        Thu, 16 Apr 2020 00:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586998309;
        bh=8DhZOBqSZP4rnKazHCEf0i+ue1eqvaTaprZV/5yLUuQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N8I9s4GdOsOSgLe4B1nbtN1F6aSnqT8jhrZ6J5Y3GqKxgCoLKJVpQQuOBnLhFydrT
         9Kia9+G9uqk/JWrofIBiVwhyYgrl39UW3Mjhpf1qHhEz0fiLUlkIbY05Gk1OXoDoAA
         Pg4Omaehx8frrPeWu7ZyFiBmZWjWOZYzuOcHhPkQ=
Date:   Wed, 15 Apr 2020 20:51:48 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     bob.liu@oracle.com, damien.lemoal@wdc.com, snitzer@redhat.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] dm zoned: remove duplicate nr_rnd_zones
 increase in" failed to apply to 5.4-stable tree
Message-ID: <20200416005148.GO1068@sasha-vm>
References: <15869485594525@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <15869485594525@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 15, 2020 at 01:02:39PM +0200, gregkh@linuxfoundation.org wrote:
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
>From b8fdd090376a7a46d17db316638fe54b965c2fb0 Mon Sep 17 00:00:00 2001
>From: Bob Liu <bob.liu@oracle.com>
>Date: Tue, 24 Mar 2020 21:22:45 +0800
>Subject: [PATCH] dm zoned: remove duplicate nr_rnd_zones increase in
> dmz_init_zone()
>
>zmd->nr_rnd_zones was increased twice by mistake. The other place it
>is increased in dmz_init_zone() is the only one needed:
>
>1131                 zmd->nr_useable_zones++;
>1132                 if (dmz_is_rnd(zone)) {
>1133                         zmd->nr_rnd_zones++;
>					^^^
>Fixes: 3b1a94c88b79 ("dm zoned: drive-managed zoned block device target")
>Cc: stable@vger.kernel.org
>Signed-off-by: Bob Liu <bob.liu@oracle.com>
>Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
>Signed-off-by: Mike Snitzer <snitzer@redhat.com>
>
>diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
>index 516c7b671d25..369de15c4e80 100644
>--- a/drivers/md/dm-zoned-metadata.c
>+++ b/drivers/md/dm-zoned-metadata.c
>@@ -1109,7 +1109,6 @@ static int dmz_init_zone(struct blk_zone *blkz, unsigned int idx, void *data)
> 	switch (blkz->type) {
> 	case BLK_ZONE_TYPE_CONVENTIONAL:
> 		set_bit(DMZ_RND, &zone->flags);
>-		zmd->nr_rnd_zones++;
> 		break;
> 	case BLK_ZONE_TYPE_SEQWRITE_REQ:
> 	case BLK_ZONE_TYPE_SEQWRITE_PREF:

The code on older kernels was using is/else construct instead of a
switch. I've adjusted the patch and queued it up.

-- 
Thanks,
Sasha
