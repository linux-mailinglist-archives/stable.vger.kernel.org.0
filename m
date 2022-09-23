Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBDB75E7936
	for <lists+stable@lfdr.de>; Fri, 23 Sep 2022 13:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232116AbiIWLPA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Sep 2022 07:15:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232201AbiIWLOt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Sep 2022 07:14:49 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53B2C2F387;
        Fri, 23 Sep 2022 04:14:47 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 11E011F947;
        Fri, 23 Sep 2022 11:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1663931686; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dfT5DLVmPxZ6Z/F4rJ4D8/3rzyoU2jcg2Mx19Dzkp/4=;
        b=iSUP4pnIA8676mGrt56+5j8aj16F9I1u5aDcBWlbzc23BNF4yhdlx/IMGh34M8EJbINa6C
        A7b0d57zV/SSlZmjnAhugpR9240TlcXXEQxKMBZapmZ4ohXITjr9KwLFFdf5SzVhAZIAm6
        tegMOnjSQHsbkmUqG4G0KBVG7fHJhi4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1663931686;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dfT5DLVmPxZ6Z/F4rJ4D8/3rzyoU2jcg2Mx19Dzkp/4=;
        b=k6948tk+vleUDxoQWklFishzT7RI5ong1XmRTfOr4pYyn8r8BLoZBEpJ7I9fF/OX06gJvE
        tf7pIHL6dH5ycQDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id ED8C313AA5;
        Fri, 23 Sep 2022 11:14:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id GfvvOSWVLWOYUwAAMHmgww
        (envelope-from <jack@suse.cz>); Fri, 23 Sep 2022 11:14:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 77020A0685; Fri, 23 Sep 2022 13:14:45 +0200 (CEST)
Date:   Fri, 23 Sep 2022 13:14:45 +0200
From:   Jan Kara <jack@suse.cz>
To:     Baokun Li <libaokun1@huawei.com>
Cc:     linux-ext4@vger.kernel.org, tytso@mit.edu,
        adilger.kernel@dilger.ca, jack@suse.cz, ritesh.list@gmail.com,
        lczerner@redhat.com, enwlinux@gmail.com,
        linux-kernel@vger.kernel.org, yi.zhang@huawei.com,
        yebin10@huawei.com, chengzhihao1@huawei.com, yukuai3@huawei.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] ext4: fix use-after-free in ext4_ext_shift_extents
Message-ID: <20220923111445.letb6y3leixm2b7b@quack3>
References: <20220922120434.1294789-1-libaokun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220922120434.1294789-1-libaokun1@huawei.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_SOFTFAIL autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 22-09-22 20:04:34, Baokun Li wrote:
> If the starting position of our insert range happens to be in the hole
> between the two ext4_extent_idx, because the lblk of the ext4_extent in
> the previous ext4_extent_idx is always less than the start, which leads
> to the "extent" variable access across the boundary, the following UAF is
> triggered:
> ==================================================================
> BUG: KASAN: use-after-free in ext4_ext_shift_extents+0x257/0x790
> Read of size 4 at addr ffff88819807a008 by task fallocate/8010
> CPU: 3 PID: 8010 Comm: fallocate Tainted: G            E     5.10.0+ #492
> Call Trace:
>  dump_stack+0x7d/0xa3
>  print_address_description.constprop.0+0x1e/0x220
>  kasan_report.cold+0x67/0x7f
>  ext4_ext_shift_extents+0x257/0x790
>  ext4_insert_range+0x5b6/0x700
>  ext4_fallocate+0x39e/0x3d0
>  vfs_fallocate+0x26f/0x470
>  ksys_fallocate+0x3a/0x70
>  __x64_sys_fallocate+0x4f/0x60
>  do_syscall_64+0x33/0x40
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> ==================================================================
> 
> For right shifts, we can divide them into the following situations：
> 
> 1. When the first ee_block of ext4_extent_idx is greater than or equal to
>    start, make right shifts directly from the first ee_block.
>     1) If it is greater than start, we need to continue searching in the
>        previous ext4_extent_idx.
>     2) If it is equal to start, we can exit the loop (iterator=NULL).
> 
> 2. When the first ee_block of ext4_extent_idx is less than start, then
>    traverse from the last extent to find the first extent whose ee_block
>    is less than start.
>     1) If extent is still the last extent after traversal, it means that
>        the last ee_block of ext4_extent_idx is less than start, that is,
>        start is located in the hole between idx and (idx+1), so we can
>        exit the loop directly (break) without right shifts.
>     2) Otherwise, make right shifts at the corresponding position of the
>        found extent, and then exit the loop (iterator=NULL).
> 
> Fixes: 331573febb6a ("ext4: Add support FALLOC_FL_INSERT_RANGE for fallocate")
> Cc: stable@vger.kernel.org # v4.2+
> Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
> Signed-off-by: Baokun Li <libaokun1@huawei.com>

Thanks for the fix! It looks good to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> V1->V2:
>   Initialize "ret" after the "again:" label to avoid return value mismatch.
>   Refactoring reduces cycles and makes code more readable.
> 
>  fs/ext4/extents.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index c148bb97b527..39c9f87de0be 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -5179,6 +5179,7 @@ ext4_ext_shift_extents(struct inode *inode, handle_t *handle,
>  	 * and it is decreased till we reach start.
>  	 */
>  again:
> +	ret = 0;
>  	if (SHIFT == SHIFT_LEFT)
>  		iterator = &start;
>  	else
> @@ -5222,14 +5223,21 @@ ext4_ext_shift_extents(struct inode *inode, handle_t *handle,
>  					ext4_ext_get_actual_len(extent);
>  		} else {
>  			extent = EXT_FIRST_EXTENT(path[depth].p_hdr);
> -			if (le32_to_cpu(extent->ee_block) > 0)
> +			if (le32_to_cpu(extent->ee_block) > start)
>  				*iterator = le32_to_cpu(extent->ee_block) - 1;
> -			else
> -				/* Beginning is reached, end of the loop */
> +			else if (le32_to_cpu(extent->ee_block) == start)
>  				iterator = NULL;
> -			/* Update path extent in case we need to stop */
> -			while (le32_to_cpu(extent->ee_block) < start)
> +			else {
> +				extent = EXT_LAST_EXTENT(path[depth].p_hdr);
> +				while (le32_to_cpu(extent->ee_block) >= start)
> +					extent--;
> +
> +				if (extent == EXT_LAST_EXTENT(path[depth].p_hdr))
> +					break;
> +
>  				extent++;
> +				iterator = NULL;
> +			}
>  			path[depth].p_ext = extent;
>  		}
>  		ret = ext4_ext_shift_path_extents(path, shift, inode,
> -- 
> 2.31.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
