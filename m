Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 383C22BC78F
	for <lists+stable@lfdr.de>; Sun, 22 Nov 2020 18:48:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727938AbgKVRsr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Nov 2020 12:48:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:34894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727567AbgKVRsr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Nov 2020 12:48:47 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAA232076B;
        Sun, 22 Nov 2020 17:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606067327;
        bh=/L2g3KYTfyRQn20kXBH4EBV3uBvXoJ0wsxhdACXAJlo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TnvddxEgKh6EZLuVp2u8a1OfSrFdn1MwmIICM5ZR+76gnqDNnigq+Q63xPx3HvWMR
         MaG5hu62iL/sBf6ADyZn/2KUWG8XzVJMAZXHipEq8oahQP8Tjsw5TvBqNqU2N8pcXY
         KhIFj+PclIfQf5r42SbrUNBp5ORAUSUOTZRudt3Q=
Date:   Sun, 22 Nov 2020 12:48:45 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Jack Wang <xjtuwjp@gmail.com>
Cc:     Timo Rothenpieler <timo@rothenpieler.org>,
        gregkh@linuxfoundation.org, stable@vger.kernel.org,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: Backport missing mlx5 fixes after 50b2412b7e7
Message-ID: <20201122174845.GK643756@sasha-vm>
References: <f1c78926-b95b-c4b0-c323-c7a5ca1c8856@rothenpieler.org>
 <CAD+HZHWy1dba7z0UcX3cofSgzQvFUcfRms+zC+RvJoqh3p5MoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAD+HZHWy1dba7z0UcX3cofSgzQvFUcfRms+zC+RvJoqh3p5MoQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 20, 2020 at 07:18:04AM +0100, Jack Wang wrote:
>Timo Rothenpieler <timo@rothenpieler.org> 于2020年11月18日周三 下午7:28写道：
>>
>> Hi,
>>
>> After 50b2412b7e7862c5af0cbf4b10d93bc5c712d021 was backported to stable
>> branches (I only tested 5.4), some serious issues started to arrise.
>>
>> According to linux-rdma, the following two patches that need to go along
>> with 50b2412b7e are missing:
>>
>> > 1. 1d5558b1f0de net/mlx5: poll cmd EQ in case of command timeout
>> > 2. 410bd754cd73 net/mlx5: Add retry mechanism to the command entry ...
>>
>> I managed to apply those mostly cleanly after also applying two
>> dependencies.
>> So the complete list of needed commits for 5.4 is:
>>
>> 1. 3ed879965cc4 net/mlx5: Use async EQ setup cleanup helpers ...
>> 2. 1d5558b1f0de net/mlx5: poll cmd EQ in case of command timeout
>> 3. d43b7007dbd1 net/mlx5: Fix a race when moving command ...
>> 4. 410bd754cd73 net/mlx5: Add retry mechanism to the command entry ...
>>
>> With those 4 commits applied, the issue is fixed.
>> For reference, that's the output I get with 5.4.77:
>>
>> > Nov 17 01:12:58 store01 kernel: mlx5_ib: Mellanox Connect-IB Infiniband driver v5.0-0
>> > Nov 17 01:12:58 store01 kernel: mlx5_core 0000:01:00.0: cmd_work_handler:887:(pid 383): failed to allocate command entry
>> > Nov 17 01:12:58 store01 kernel: infiniband mlx5_0: reg_mr_callback:104:(pid 383): async reg mr failed. status -11
>> > Nov 17 01:12:58 store01 kernel: mlx5_core 0000:01:00.0: cmd_work_handler:887:(pid 383): failed to allocate command entry
>> > Nov 17 01:12:58 store01 kernel: mlx5_core 0000:01:00.0: mlx5e_create_mdev_resources:104:(pid 1): alloc td failed, -11
>> > Nov 17 01:12:58 store01 kernel: mlx5_0, 1: ipoib_intf_alloc failed -11
>>
>+cc Greg & Sascha
>Hi,
>
>We hit the same problem on mlx5, I've tested four mentioned commits,
>it works fine, please include them in future 5.4 kernel.

Looks like Greg picked them up, thanks!

-- 
Thanks,
Sasha
