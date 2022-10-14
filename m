Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63B385FEE7E
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 15:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbiJNNX0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 09:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiJNNX0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 09:23:26 -0400
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE78C19E02E;
        Fri, 14 Oct 2022 06:23:23 -0700 (PDT)
Received: from [141.14.220.45] (g45.guest.molgen.mpg.de [141.14.220.45])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id D887C61EA1930;
        Fri, 14 Oct 2022 15:23:20 +0200 (CEST)
Message-ID: <8bd2e447-54b0-8a6a-9020-7453a7353dd3@molgen.mpg.de>
Date:   Fri, 14 Oct 2022 15:23:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH] md/bitmap: Fix bitmap chunk size overflow issues.
To:     Jack Wang <jinpu.wang@ionos.com>
Cc:     Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>,
        song@kernel.org, linux-raid@vger.kernel.org, stable@vger.kernel.org
References: <20221014122032.47784-1-jinpu.wang@ionos.com>
Content-Language: en-US
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20221014122032.47784-1-jinpu.wang@ionos.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear Jack, dear Florian-Ewald,


Thank you for the patch.

Am 14.10.22 um 14:20 schrieb Jack Wang:
> From: Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>
> 
> - limit bitmap chunk size internal u64 variable to values not overflowing
>    the u32 bitmap superblock structure variable stored on persistent media.
> - assign bitmap chunk size internal u64 variable from unsigned values to
>    avoid possible sign extension artifacts when assigning from a s32 value.
> 
> The bug has been there since at least kernel 4.0.

Did you find this during code review or hit actual problems? If so, a 
reproducer would be nice to have. (A small nit, should you resend, if 
you removed the dot/period from the end of the commit message 
summary/title, that’d be great.)


Kind regards,

Paul


> Cc: stable@vger.kernel.org
> 
> Signed-off-by: Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>
> Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>   drivers/md/md-bitmap.c | 20 ++++++++++++--------
>   1 file changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index bf6dffadbe6f..b266711485a8 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -486,7 +486,7 @@ void md_bitmap_print_sb(struct bitmap *bitmap)
>   	sb = kmap_atomic(bitmap->storage.sb_page);
>   	pr_debug("%s: bitmap file superblock:\n", bmname(bitmap));
>   	pr_debug("         magic: %08x\n", le32_to_cpu(sb->magic));
> -	pr_debug("       version: %d\n", le32_to_cpu(sb->version));
> +	pr_debug("       version: %u\n", le32_to_cpu(sb->version));
>   	pr_debug("          uuid: %08x.%08x.%08x.%08x\n",
>   		 le32_to_cpu(*(__le32 *)(sb->uuid+0)),
>   		 le32_to_cpu(*(__le32 *)(sb->uuid+4)),
> @@ -497,11 +497,11 @@ void md_bitmap_print_sb(struct bitmap *bitmap)
>   	pr_debug("events cleared: %llu\n",
>   		 (unsigned long long) le64_to_cpu(sb->events_cleared));
>   	pr_debug("         state: %08x\n", le32_to_cpu(sb->state));
> -	pr_debug("     chunksize: %d B\n", le32_to_cpu(sb->chunksize));
> -	pr_debug("  daemon sleep: %ds\n", le32_to_cpu(sb->daemon_sleep));
> +	pr_debug("     chunksize: %u B\n", le32_to_cpu(sb->chunksize));
> +	pr_debug("  daemon sleep: %us\n", le32_to_cpu(sb->daemon_sleep));
>   	pr_debug("     sync size: %llu KB\n",
>   		 (unsigned long long)le64_to_cpu(sb->sync_size)/2);
> -	pr_debug("max write behind: %d\n", le32_to_cpu(sb->write_behind));
> +	pr_debug("max write behind: %u\n", le32_to_cpu(sb->write_behind));
>   	kunmap_atomic(sb);
>   }
>   
> @@ -2105,7 +2105,8 @@ int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
>   			bytes = DIV_ROUND_UP(chunks, 8);
>   			if (!bitmap->mddev->bitmap_info.external)
>   				bytes += sizeof(bitmap_super_t);
> -		} while (bytes > (space << 9));
> +		} while (bytes > (space << 9) && (chunkshift + BITMAP_BLOCK_SHIFT) <
> +			(BITS_PER_BYTE * sizeof(((bitmap_super_t *)0)->chunksize) - 1));
>   	} else
>   		chunkshift = ffz(~chunksize) - BITMAP_BLOCK_SHIFT;
>   
> @@ -2150,7 +2151,7 @@ int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
>   	bitmap->counts.missing_pages = pages;
>   	bitmap->counts.chunkshift = chunkshift;
>   	bitmap->counts.chunks = chunks;
> -	bitmap->mddev->bitmap_info.chunksize = 1 << (chunkshift +
> +	bitmap->mddev->bitmap_info.chunksize = 1UL << (chunkshift +
>   						     BITMAP_BLOCK_SHIFT);
>   
>   	blocks = min(old_counts.chunks << old_counts.chunkshift,
> @@ -2176,8 +2177,8 @@ int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
>   				bitmap->counts.missing_pages = old_counts.pages;
>   				bitmap->counts.chunkshift = old_counts.chunkshift;
>   				bitmap->counts.chunks = old_counts.chunks;
> -				bitmap->mddev->bitmap_info.chunksize = 1 << (old_counts.chunkshift +
> -									     BITMAP_BLOCK_SHIFT);
> +				bitmap->mddev->bitmap_info.chunksize =
> +					1UL << (old_counts.chunkshift + BITMAP_BLOCK_SHIFT);
>   				blocks = old_counts.chunks << old_counts.chunkshift;
>   				pr_warn("Could not pre-allocate in-memory bitmap for cluster raid\n");
>   				break;
> @@ -2534,6 +2535,9 @@ chunksize_store(struct mddev *mddev, const char *buf, size_t len)
>   	if (csize < 512 ||
>   	    !is_power_of_2(csize))
>   		return -EINVAL;
> +	if (csize >= (1UL << (BITS_PER_BYTE *
> +		sizeof(((bitmap_super_t *)0)->chunksize))))
> +		return -EOVERFLOW;
>   	mddev->bitmap_info.chunksize = csize;
>   	return len;
>   }
