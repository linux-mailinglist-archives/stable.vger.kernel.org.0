Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49C981A70FD
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 04:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728817AbgDNC1C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Apr 2020 22:27:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:43674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728787AbgDNC1B (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Apr 2020 22:27:01 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B6E12072D;
        Tue, 14 Apr 2020 02:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586831220;
        bh=PkO/DP1Haa1DjU7yIv/y/7MIKR/kTvCis4tNwr2qcvw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HRj6Nx//zpqS1Au50uQ1hMnohOV13hJvu9eovYxKpoxI1W5dwPlSzwzJYUL0vYBGb
         oiU2mQTJVPAfw7PI9IC587v51UaX85j2UrMxwVLVdbTEUnK/J0mImA9S849PwAp/uu
         Pl9IhJKrBWMBfowoMzrVaqL2s5L9NKXDobZf8vGA=
Date:   Mon, 13 Apr 2020 22:26:59 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     valex@mellanox.com, jgg@mellanox.com, lariel@mellanox.com,
        leonro@mellanox.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] IB/mlx5: Replace tunnel mpls capability
 bits for" failed to apply to 4.19-stable tree
Message-ID: <20200414022659.GB1068@sasha-vm>
References: <1586509303211183@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1586509303211183@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 10, 2020 at 11:01:43AM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.19-stable tree.
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
>From 41e684ef3f37ce6e5eac3fb5b9c7c1853f4b0447 Mon Sep 17 00:00:00 2001
>From: Alex Vesker <valex@mellanox.com>
>Date: Thu, 5 Mar 2020 14:38:41 +0200
>Subject: [PATCH] IB/mlx5: Replace tunnel mpls capability bits for
> tunnel_offloads
>
>Until now the flex parser capability was used in ib_query_device() to
>indicate tunnel_offloads_caps support for mpls_over_gre/mpls_over_udp.
>
>Newer devices and firmware will have configurations with the flexparser
>but without mpls support.
>
>Testing for the flex parser capability was a mistake, the tunnel_stateless
>capability was intended for detecting mpls and was introduced at the same
>time as the flex parser capability.
>
>Otherwise userspace will be incorrectly informed that a future device
>supports MPLS when it does not.
>
>Link: https://lore.kernel.org/r/20200305123841.196086-1-leon@kernel.org
>Cc: <stable@vger.kernel.org> # 4.17
>Fixes: e818e255a58d ("IB/mlx5: Expose MPLS related tunneling offloads")
>Signed-off-by: Alex Vesker <valex@mellanox.com>
>Reviewed-by: Ariel Levkovich <lariel@mellanox.com>
>Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
>Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>

The conflict was around the cqe_checksum_full cap bit being exposed by
db849faa9bef ("net/mlx5e: Rx, Fix checksum calculation for new
hardware").

I've resolved it by exposing cqe_checksum_full, but *not* taking
db849faa9bef.

-- 
Thanks,
Sasha
