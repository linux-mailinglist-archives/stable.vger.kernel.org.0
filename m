Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3B451AF1F5
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 17:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbgDRP7Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 11:59:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:35484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725879AbgDRP7Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Apr 2020 11:59:16 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9A4021D93;
        Sat, 18 Apr 2020 15:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587225556;
        bh=O8f94HeDpm4JmTijCr4uq0+sKI3sW8zSAsz0vBzUv+I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2kAg4H+09BggsxSKZocFIg9nLCgex7eshBqNeakiCy4TU1aF/Y6SNFKUBtz3qW64x
         D0jTWRPLIpgRcmQA6PB1A/7qgeRs6JGk634o9pSFvPIb3M6prykgs0MQbNfg2A/Cyf
         d3ocaM9CTsg/kBIC1K4ffaBLvj2XsAFTVxM/NVNU=
Date:   Sat, 18 Apr 2020 11:59:14 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     maximmi@mellanox.com, saeedm@mellanox.com, tariqt@mellanox.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] net/mlx5e: Use preactivate hook to set
 the indirection table" failed to apply to 5.6-stable tree
Message-ID: <20200418155914.GA1809@sasha-vm>
References: <15872047304089@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <15872047304089@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Apr 18, 2020 at 12:12:10PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.6-stable tree.
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
>From fe867cac9e1967c553e4ac2aece5fc8675258010 Mon Sep 17 00:00:00 2001
>From: Maxim Mikityanskiy <maximmi@mellanox.com>
>Date: Mon, 4 Nov 2019 12:02:14 +0200
>Subject: [PATCH] net/mlx5e: Use preactivate hook to set the indirection table
>
>mlx5e_ethtool_set_channels updates the indirection table before
>switching to the new channels. If the switch fails, the indirection
>table is new, but the channels are old, which is wrong. Fix it by using
>the preactivate hook of mlx5e_safe_switch_channels to update the
>indirection table at the stage when nothing can fail anymore.
>
>As the code that updates the indirection table is now encapsulated into
>a new function, use that function in the attach flow when the driver has
>to reduce the number of channels, and prepare the code for the next
>commit.
>
>Fixes: 85082dba0a ("net/mlx5e: Correctly handle RSS indirection table when changing number of channels")
>Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
>Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
>Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>

I've grabbed these two dependencies for 5.6, 5.5, 5.4:

dca147b3dce5 ("net/mlx5e: Rename hw_modify to preactivate")
c2c95271f9f3 ("net/mlx5e: Encapsulate updating netdev queues into a function")

Older branches were more complex and still need a backport.

-- 
Thanks,
Sasha
