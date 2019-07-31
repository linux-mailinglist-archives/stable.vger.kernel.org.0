Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 353757D203
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 01:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729021AbfGaXii (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 19:38:38 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:55316 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbfGaXii (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Jul 2019 19:38:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1564616317; x=1596152317;
  h=subject:to:references:from:message-id:date:mime-version:
   in-reply-to:content-transfer-encoding;
  bh=Kd98BXsBmYyhXF8NQI/xoh/VfpCf36zrcpwwmqSjLZQ=;
  b=ufN57qAL04haOgigzx7ujX7uLOeeVw20tdenmE5/Jm25qxWK/TH+hRc2
   2hdKSO8FFTr41LSy+pKxclrhdTbw3CSTyWuzOxPzm/ZWq6Q1cA5TsrALo
   Hv5OTAO/Bnx0OZP88BJHDXRBaf7VGxMH0k2mxiFxZLGRH4zBabUYIDQb/
   Q=;
X-IronPort-AV: E=Sophos;i="5.64,332,1559520000"; 
   d="scan'208";a="413325993"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-d0be17ee.us-west-2.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 31 Jul 2019 23:38:35 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2a-d0be17ee.us-west-2.amazon.com (Postfix) with ESMTPS id 73F2CA1E0F;
        Wed, 31 Jul 2019 23:38:34 +0000 (UTC)
Received: from EX13D10UWB004.ant.amazon.com (10.43.161.121) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 31 Jul 2019 23:38:34 +0000
Received: from [10.63.178.84] (10.43.160.160) by EX13D10UWB004.ant.amazon.com
 (10.43.161.121) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Wed, 31 Jul
 2019 23:38:33 +0000
Subject: Re: [PATCH v2] nbd: replace kill_bdev() with __invalidate_device()
 again
To:     SunKe <sunke32@huawei.com>, <josef@toxicpanda.com>,
        <axboe@kernel.dk>, <linux-block@vger.kernel.org>,
        <nbd@other.debian.org>, <linux-kernel@vger.kernel.org>,
        <manoj.br@gmail.com>, <stable@vger.kernel.org>, <dwmw@amazon.com>
References: <1564575190-132357-1-git-send-email-sunke32@huawei.com>
From:   Munehisa Kamata <kamatam@amazon.com>
Message-ID: <98ac17cf-c658-9e80-8505-4309805fc1f0@amazon.com>
Date:   Wed, 31 Jul 2019 16:38:33 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1564575190-132357-1-git-send-email-sunke32@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.160.160]
X-ClientProxiedBy: EX13D15UWB004.ant.amazon.com (10.43.161.61) To
 EX13D10UWB004.ant.amazon.com (10.43.161.121)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/31/2019 5:13 AM, SunKe wrote:
> From: Munehisa Kamata <kamatam@amazon.com>
> 
> Commit abbbdf12497d ("replace kill_bdev() with __invalidate_device()")
> once did this, but 29eaadc03649 ("nbd: stop using the bdev everywhere")
> resurrected kill_bdev() and it has been there since then. So buffer_head
> mappings still get killed on a server disconnection, and we can still
> hit the BUG_ON on a filesystem on the top of the nbd device.
> 
>   EXT4-fs (nbd0): mounted filesystem with ordered data mode. Opts: (null)
>   block nbd0: Receive control failed (result -32)
>   block nbd0: shutting down sockets
>   print_req_error: I/O error, dev nbd0, sector 66264 flags 3000
>   EXT4-fs warning (device nbd0): htree_dirblock_to_tree:979: inode #2: lblock 0: comm ls: error -5 reading directory block
>   print_req_error: I/O error, dev nbd0, sector 2264 flags 3000
>   EXT4-fs error (device nbd0): __ext4_get_inode_loc:4690: inode #2: block 283: comm ls: unable to read itable block
>   EXT4-fs error (device nbd0) in ext4_reserve_inode_write:5894: IO failure
>   ------------[ cut here ]------------
>   kernel BUG at fs/buffer.c:3057!
>   invalid opcode: 0000 [#1] SMP PTI
>   CPU: 7 PID: 40045 Comm: jbd2/nbd0-8 Not tainted 5.1.0-rc3+ #4
>   Hardware name: Amazon EC2 m5.12xlarge/, BIOS 1.0 10/16/2017
>   RIP: 0010:submit_bh_wbc+0x18b/0x190
>   ...
>   Call Trace:
>    jbd2_write_superblock+0xf1/0x230 [jbd2]
>    ? account_entity_enqueue+0xc5/0xf0
>    jbd2_journal_update_sb_log_tail+0x94/0xe0 [jbd2]
>    jbd2_journal_commit_transaction+0x12f/0x1d20 [jbd2]
>    ? __switch_to_asm+0x40/0x70
>    ...
>    ? lock_timer_base+0x67/0x80
>    kjournald2+0x121/0x360 [jbd2]
>    ? remove_wait_queue+0x60/0x60
>    kthread+0xf8/0x130
>    ? commit_timeout+0x10/0x10 [jbd2]
>    ? kthread_bind+0x10/0x10
>    ret_from_fork+0x35/0x40
> 
> With __invalidate_device(), I no longer hit the BUG_ON with sync or
> unmount on the disconnected device.
> 
> Fixes: 29eaadc03649 ("nbd: stop using the bdev everywhere")
> Cc: linux-block@vger.kernel.org
> Cc: Ratna Manoj Bolla <manoj.br@gmail.com>
> Cc: nbd@other.debian.org
> Cc: stable@vger.kernel.org
> Cc: David Woodhouse <dwmw@amazon.com>
> Signed-off-by: Munehisa Kamata <kamatam@amazon.com>
> 
> ---
> I reproduced this phenomenon on the fat file system.
> reproduce steps :
> 1.Establish a nbd connection.
> 2.Run two threads:one do mount and umount,anther one do clear_sock ioctl
> 3.Then hit the BUG_ON.
> 
> v2: Delete a link.
> 
> Signed-off-by: SunKe <sunke32@huawei.com>
> 
>  drivers/block/nbd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
> index 9bcde23..e21d2de 100644
> --- a/drivers/block/nbd.c
> +++ b/drivers/block/nbd.c
> @@ -1231,7 +1231,7 @@ static void nbd_clear_sock_ioctl(struct nbd_device *nbd,
>  				 struct block_device *bdev)
>  {
>  	sock_shutdown(nbd);
> -	kill_bdev(bdev);
> +	__invalidate_device(bdev, true);
>  	nbd_bdev_reset(bdev);
>  	if (test_and_clear_bit(NBD_HAS_CONFIG_REF,
>  			       &nbd->config->runtime_flags))
> 

Hi SunKe,

I accidentally included the link in the original one. Sorry about that and thanks
for picking this up.

Regards,
Munehsia
