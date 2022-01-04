Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7496F4839B4
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 02:19:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231562AbiADBTE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 20:19:04 -0500
Received: from out0.migadu.com ([94.23.1.103]:48487 "EHLO out0.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229853AbiADBTD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jan 2022 20:19:03 -0500
Subject: Re: [PATCH] md/raid1: fix missing bitmap update w/o WriteMostly
 devices
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1641259138;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0Va7Q4P8AouCq7aKXPP/3Ce0JskJ6ujhX9CWOE7Rn5g=;
        b=Yu5xEyCcRGvYQqH8OR446kFCQzdt5jszyicOqXPf0ToEUtjKUZOJbG5eYG3HA5W2aZYrQn
        BQ9IKjQtco7BwfCtAk/cC50anTfs02F4hMgA37ajsqqBIkPOAZAgN010/E3tBykein3H42
        pB06yxOf5EsBMOPh3fr6OzfR8fzANlU=
To:     Song Liu <song@kernel.org>, linux-raid@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        Norbert Warmuth <nwarmuth@t-online.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <20220103230401.180704-1-song@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <842bd2f8-1903-6da9-8bbf-09229868c7dd@linux.dev>
Date:   Tue, 4 Jan 2022 09:18:51 +0800
MIME-Version: 1.0
In-Reply-To: <20220103230401.180704-1-song@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 1/4/22 7:04 AM, Song Liu wrote:
> commit [1] causes missing bitmap updates when there isn't any WriteMostly
> devices.
>
> Detailed steps to reproduce by Norbert (which somehow didn't make to lore):
>
>     # setup md10 (raid1) with two drives (1 GByte sparse files)
>     dd if=/dev/zero of=disk1 bs=1024k seek=1024 count=0
>     dd if=/dev/zero of=disk2 bs=1024k seek=1024 count=0
>
>     losetup /dev/loop11 disk1
>     losetup /dev/loop12 disk2
>
>     mdadm --create /dev/md10 --level=1 --raid-devices=2 /dev/loop11 /dev/loop12
>
>     # add bitmap (aka write-intent log)
>     mdadm /dev/md10 --grow --bitmap=internal
>
>     echo check > /sys/block/md10/md/sync_action
>
>     root:# cat /sys/block/md10/md/mismatch_cnt
>     0
>     root:#
>
>     # remove member drive disk2 (loop12)
>     mdadm /dev/md10 -f loop12 ; mdadm /dev/md10 -r loop12
>
>     # modify degraded md device
>     dd if=/dev/urandom of=/dev/md10 bs=512 count=1
>
>     # no blocks recorded as out of sync on the remaining member disk1/loop11
>     root:# mdadm -X /dev/loop11 | grep Bitmap
>               Bitmap : 16 bits (chunks), 0 dirty (0.0%)
>     root:#
>
>     # re-add disk2, nothing synced because of empty bitmap
>     mdadm /dev/md10 --re-add /dev/loop12
>
>     # check integrity again
>     echo check > /sys/block/md10/md/sync_action
>
>     # disk1 and disk2 are no longer in sync, reads return differend data
>     root:# cat /sys/block/md10/md/mismatch_cnt
>     128
>     root:#
>
>     # clean up
>     mdadm -S /dev/md10
>     losetup -d /dev/loop11
>     losetup -d /dev/loop12
>     rm disk1 disk2
>
> Fix this by moving the WriteMostly check to the if condition for
> alloc_behind_master_bio().
>
> [1] commit fd3b6975e9c1 ("md/raid1: only allocate write behind bio for WriteMostly device")
> Fixes: fd3b6975e9c1 ("md/raid1: only allocate write behind bio for WriteMostly device")
> Cc: stable@vger.kernel.org # v5.12+
> Cc: Guoqing Jiang <guoqing.jiang@linux.dev>
> Cc: Jens Axboe <axboe@kernel.dk>
> Reported-by: Norbert Warmuth <nwarmuth@t-online.de>
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Song Liu <song@kernel.org>
> ---
>   drivers/md/raid1.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 7dc8026cf6ee..85505424f7a4 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1496,12 +1496,13 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
>   		if (!r1_bio->bios[i])
>   			continue;
>   
> -		if (first_clone && test_bit(WriteMostly, &rdev->flags)) {
> +		if (first_clone) {
>   			/* do behind I/O ?
>   			 * Not if there are too many, or cannot
>   			 * allocate memory, or a reader on WriteMostly
>   			 * is waiting for behind writes to flush */
>   			if (bitmap &&
> +			    test_bit(WriteMostly, &rdev->flags) &&
>   			    (atomic_read(&bitmap->behind_writes)
>   			     < mddev->bitmap_info.max_write_behind) &&
>   			    !waitqueue_active(&bitmap->behind_wait)) {

Indeed, I missed that md_bitmap_startwrite should be always called for 
the first clone.

Thanks,
Guoqing


