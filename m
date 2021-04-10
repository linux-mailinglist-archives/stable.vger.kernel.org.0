Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1C9E35AF9B
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 20:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234738AbhDJSfS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 14:35:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:40784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234513AbhDJSfS (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Apr 2021 14:35:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15DD361056;
        Sat, 10 Apr 2021 18:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618079703;
        bh=C7m35dBPZkTJGHIfRr1qfkEyGCGrSvUdD/3tqwQKAVI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OItV+ZvcUdehFguevYrNaezIiePtz8j2bxxXBTvHO7yKXVMVu0RqvqyEmqPSecIVi
         /r7yKK1oQUALQvnt5MOo6s94xdWJGIEZglgQ38Xewmizk3D/W5LYfLChweo6/A1Tk7
         1HZEoym8xX/1P67yiBsnh6VjqEkdezky3lCYLpSrW3UXQYohEOoJ9Y/pP3/KaMNN5Y
         LKKKLP3lmM0aR8Si/K58JOhWzDMBNudPr1sIAxATgM/8dAK6mumaVcjrNOGcpKGKIa
         EIzMMum3bpYVhwMTo5dkfMrhzWaO8/hqm+Jwlub6k0J1uMYO/pw2LJx/ZcSmFe3LNn
         ATeePAVTOZmow==
Date:   Sat, 10 Apr 2021 11:35:01 -0700
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mike Snitzer <snitzer@redhat.com>, kernel-team@android.com
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] dm verity: fix unaligned block size
Message-ID: <YHHv1dn9cP4mO7u+@google.com>
References: <20210410160151.1224296-1-jaegeuk@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210410160151.1224296-1-jaegeuk@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sorry, this patch is totally wrong. Let me dig out more.

On 04/10, Jaegeuk Kim wrote:
> From: Jaegeuk Kim <jaegeuk@google.com>
> 
> When f->roots is 2 and block size is 4096, it will gives unaligned block size
> length in the scsi command like below. Let's allocate dm_bufio to set the block
> size length to match IO chunk size.
> 
> E sd 0    : 0:0:0: [sda] tag#30 request not aligned to the logical block size
> E blk_update_request: I/O error, dev sda, sector 10368424 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
> E device-mapper: verity-fec: 254:8: FEC 9244672: parity read failed (block 18056): -5
> 
> Fixes: ce1cca17381f ("dm verity: fix FEC for RS roots unaligned to block size")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jaegeuk Kim <jaegeuk@google.com>
> ---
>  drivers/md/dm-verity-fec.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
> index 66f4c6398f67..656238131dd7 100644
> --- a/drivers/md/dm-verity-fec.c
> +++ b/drivers/md/dm-verity-fec.c
> @@ -743,7 +743,7 @@ int verity_fec_ctr(struct dm_verity *v)
>  	}
>  
>  	f->bufio = dm_bufio_client_create(f->dev->bdev,
> -					  f->roots << SECTOR_SHIFT,
> +					  1 << v->data_dev_block_bits,
>  					  1, 0, NULL, NULL);
>  	if (IS_ERR(f->bufio)) {
>  		ti->error = "Cannot initialize FEC bufio client";
> -- 
> 2.31.1.295.g9ea45b61b8-goog
