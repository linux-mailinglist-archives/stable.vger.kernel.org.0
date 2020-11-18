Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 543762B83F2
	for <lists+stable@lfdr.de>; Wed, 18 Nov 2020 19:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbgKRSfW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Nov 2020 13:35:22 -0500
Received: from btbn.de ([5.9.118.179]:37252 "EHLO btbn.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726696AbgKRSfW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Nov 2020 13:35:22 -0500
X-Greylist: delayed 408 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Nov 2020 13:35:21 EST
Received: from [IPv6:2001:16b8:646b:3300:90ed:462b:245d:1c3b] (200116b8646b330090ed462b245d1c3b.dip.versatel-1u1.de [IPv6:2001:16b8:646b:3300:90ed:462b:245d:1c3b])
        by btbn.de (Postfix) with ESMTPSA id E903F12A26C;
        Wed, 18 Nov 2020 19:28:30 +0100 (CET)
To:     stable@vger.kernel.org
Cc:     Eran Ben Elisha <eranbe@nvidia.com>, Jack Wang <xjtuwjp@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>, jgg@ziepe.ca
From:   Timo Rothenpieler <timo@rothenpieler.org>
Subject: Backport missing mlx5 fixes after 50b2412b7e7
Message-ID: <f1c78926-b95b-c4b0-c323-c7a5ca1c8856@rothenpieler.org>
Date:   Wed, 18 Nov 2020 19:28:30 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

After 50b2412b7e7862c5af0cbf4b10d93bc5c712d021 was backported to stable 
branches (I only tested 5.4), some serious issues started to arrise.

According to linux-rdma, the following two patches that need to go along 
with 50b2412b7e are missing:

> 1. 1d5558b1f0de net/mlx5: poll cmd EQ in case of command timeout
> 2. 410bd754cd73 net/mlx5: Add retry mechanism to the command entry ... 

I managed to apply those mostly cleanly after also applying two 
dependencies.
So the complete list of needed commits for 5.4 is:

1. 3ed879965cc4 net/mlx5: Use async EQ setup cleanup helpers ...
2. 1d5558b1f0de net/mlx5: poll cmd EQ in case of command timeout
3. d43b7007dbd1 net/mlx5: Fix a race when moving command ...
4. 410bd754cd73 net/mlx5: Add retry mechanism to the command entry ...

With those 4 commits applied, the issue is fixed.
For reference, that's the output I get with 5.4.77:

> Nov 17 01:12:58 store01 kernel: mlx5_ib: Mellanox Connect-IB Infiniband driver v5.0-0
> Nov 17 01:12:58 store01 kernel: mlx5_core 0000:01:00.0: cmd_work_handler:887:(pid 383): failed to allocate command entry
> Nov 17 01:12:58 store01 kernel: infiniband mlx5_0: reg_mr_callback:104:(pid 383): async reg mr failed. status -11
> Nov 17 01:12:58 store01 kernel: mlx5_core 0000:01:00.0: cmd_work_handler:887:(pid 383): failed to allocate command entry
> Nov 17 01:12:58 store01 kernel: mlx5_core 0000:01:00.0: mlx5e_create_mdev_resources:104:(pid 1): alloc td failed, -11
> Nov 17 01:12:58 store01 kernel: mlx5_0, 1: ipoib_intf_alloc failed -11 

