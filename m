Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2BD31241F
	for <lists+stable@lfdr.de>; Sun,  7 Feb 2021 12:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbhBGLxv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Feb 2021 06:53:51 -0500
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:58380 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229980AbhBGLxn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Feb 2021 06:53:43 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R391e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UO3wGOl_1612698777;
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UO3wGOl_1612698777)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 07 Feb 2021 19:52:58 +0800
Subject: Re: [PATCH 0/3] close udev startup race condition for several devices
To:     gregkh@linuxfoundation.org, sashal@kernel.org
Cc:     stable@vger.kernel.org, joseph.qi@linux.alibaba.com,
        caspar@linux.alibaba.com
References: <20210207114656.32141-1-jefflexu@linux.alibaba.com>
From:   JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <211e2814-363b-5a4a-572f-431076ecc089@linux.alibaba.com>
Date:   Sun, 7 Feb 2021 19:52:57 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210207114656.32141-1-jefflexu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Forgot to mention that this patch set shall be directly applied to 4.19
stable, though this issue should be fixed for all currently maintained
stable trees, from stable #4.4+.

-- 
Thanks,
Jeffle

On 2/7/21 7:46 PM, Jeffle Xu wrote:
> The upstream commit fef912bf860e8e7e48a2bfb978a356bba743a8b7 ("block:
> genhd: add 'groups' argument to device_add_disk") and the following
> patches fix a race condition of udev for several devices, including
> nvme, aoe, zram and virtio.
> 
> The stable tree commit 9e07f4e243791e00a4086ad86e573705cf7b2c65("zram:
> close udev startup race condition as default groups") only fixes zram,
> leaving other devices unfixed.
> 
> This udev race issue indeed makes trouble. We recently found that this
> issue can cause missing '/dev/disk/by-id/XXXX' symlink of virtio-blk
> devices on 4.19.
> 
> Be noted that this patch set follows the idea of stable commit
> 9e07f4e243791e00a4086ad86e573705cf7b2c65 ("zram: close udev startup race
> condition as default groups") of merging the preparation patch (commit
> fef912bf860e) and the fixing patch (commit 98af4d4df889).
> 
> Jeffle Xu (3):
>   virtio-blk: close udev startup race condition as default groups
>   aoe: close udev startup race condition as default groups
>   nvme: close udev startup race condition as default groups
> 
>  drivers/block/aoe/aoe.h       |   1 -
>  drivers/block/aoe/aoeblk.c    |  20 +++----
>  drivers/block/aoe/aoedev.c    |   1 -
>  drivers/block/virtio_blk.c    |  67 +++++++++++++---------
>  drivers/nvme/host/core.c      |  20 +++----
>  drivers/nvme/host/lightnvm.c  | 105 ++++++++++++++--------------------
>  drivers/nvme/host/multipath.c |  10 +---
>  drivers/nvme/host/nvme.h      |  10 +---
>  8 files changed, 103 insertions(+), 131 deletions(-)
> 


