Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D159B1B831C
	for <lists+stable@lfdr.de>; Sat, 25 Apr 2020 03:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbgDYBtl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 21:49:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:46570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726032AbgDYBtl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Apr 2020 21:49:41 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F2A72076C;
        Sat, 25 Apr 2020 01:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587779380;
        bh=bD3n9+0UGbn/RLhDn1eONjwj1qap27YZ0n/6HLf1Kec=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NDIus6f4Yx0AwjdjEVhPcDrWP/ScochkaUOCVRAOMK4t1b8Sc/JcN8p2FlHZfSmea
         Y3qrRSpEGSnlDAbO7mdLC/c9HQ4v2bEDbfIRpOBk/QD2gxxXcBKAFVQpHDHMBQxFVy
         UrQqNTTwlCW+RGwn7+bcQkmCgKtMduPffq4/e/wg=
Date:   Fri, 24 Apr 2020 21:49:39 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Suraj Jitindar Singh <surajjs@amazon.com>
Cc:     stable@vger.kernel.org, sjitindarsingh@gmail.com,
        linux-xfs@vger.kernel.org, kaixuxia <xiakaixu1987@gmail.com>,
        kaixuxia <kaixuxia@tencent.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH STABLE v4.14.y 2/2] xfs: Fix deadlock between AGI and AGF
 with RENAME_WHITEOUT
Message-ID: <20200425014939.GE13035@sasha-vm>
References: <20200424230532.2852-1-surajjs@amazon.com>
 <20200424230532.2852-3-surajjs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200424230532.2852-3-surajjs@amazon.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 24, 2020 at 04:05:32PM -0700, Suraj Jitindar Singh wrote:
>From: kaixuxia <xiakaixu1987@gmail.com>
>
>commit bc56ad8c74b8588685c2875de0df8ab6974828ef upstream.
>
>When performing rename operation with RENAME_WHITEOUT flag, we will
>hold AGF lock to allocate or free extents in manipulating the dirents
>firstly, and then doing the xfs_iunlink_remove() call last to hold
>AGI lock to modify the tmpfile info, so we the lock order AGI->AGF.
>
>The big problem here is that we have an ordering constraint on AGF
>and AGI locking - inode allocation locks the AGI, then can allocate
>a new extent for new inodes, locking the AGF after the AGI. Hence
>the ordering that is imposed by other parts of the code is AGI before
>AGF. So we get an ABBA deadlock between the AGI and AGF here.
>
>Process A:
>Call trace:
> ? __schedule+0x2bd/0x620
> schedule+0x33/0x90
> schedule_timeout+0x17d/0x290
> __down_common+0xef/0x125
> ? xfs_buf_find+0x215/0x6c0 [xfs]
> down+0x3b/0x50
> xfs_buf_lock+0x34/0xf0 [xfs]
> xfs_buf_find+0x215/0x6c0 [xfs]
> xfs_buf_get_map+0x37/0x230 [xfs]
> xfs_buf_read_map+0x29/0x190 [xfs]
> xfs_trans_read_buf_map+0x13d/0x520 [xfs]
> xfs_read_agf+0xa6/0x180 [xfs]
> ? schedule_timeout+0x17d/0x290
> xfs_alloc_read_agf+0x52/0x1f0 [xfs]
> xfs_alloc_fix_freelist+0x432/0x590 [xfs]
> ? down+0x3b/0x50
> ? xfs_buf_lock+0x34/0xf0 [xfs]
> ? xfs_buf_find+0x215/0x6c0 [xfs]
> xfs_alloc_vextent+0x301/0x6c0 [xfs]
> xfs_ialloc_ag_alloc+0x182/0x700 [xfs]
> ? _xfs_trans_bjoin+0x72/0xf0 [xfs]
> xfs_dialloc+0x116/0x290 [xfs]
> xfs_ialloc+0x6d/0x5e0 [xfs]
> ? xfs_log_reserve+0x165/0x280 [xfs]
> xfs_dir_ialloc+0x8c/0x240 [xfs]
> xfs_create+0x35a/0x610 [xfs]
> xfs_generic_create+0x1f1/0x2f0 [xfs]
> ...
>
>Process B:
>Call trace:
> ? __schedule+0x2bd/0x620
> ? xfs_bmapi_allocate+0x245/0x380 [xfs]
> schedule+0x33/0x90
> schedule_timeout+0x17d/0x290
> ? xfs_buf_find+0x1fd/0x6c0 [xfs]
> __down_common+0xef/0x125
> ? xfs_buf_get_map+0x37/0x230 [xfs]
> ? xfs_buf_find+0x215/0x6c0 [xfs]
> down+0x3b/0x50
> xfs_buf_lock+0x34/0xf0 [xfs]
> xfs_buf_find+0x215/0x6c0 [xfs]
> xfs_buf_get_map+0x37/0x230 [xfs]
> xfs_buf_read_map+0x29/0x190 [xfs]
> xfs_trans_read_buf_map+0x13d/0x520 [xfs]
> xfs_read_agi+0xa8/0x160 [xfs]
> xfs_iunlink_remove+0x6f/0x2a0 [xfs]
> ? current_time+0x46/0x80
> ? xfs_trans_ichgtime+0x39/0xb0 [xfs]
> xfs_rename+0x57a/0xae0 [xfs]
> xfs_vn_rename+0xe4/0x150 [xfs]
> ...
>
>In this patch we move the xfs_iunlink_remove() call to
>before acquiring the AGF lock to preserve correct AGI/AGF locking
>order.
>
>Signed-off-by: kaixuxia <kaixuxia@tencent.com>
>Reviewed-by: Brian Foster <bfoster@redhat.com>
>Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
>Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>
>Minor massage required to backport to apply due to removal of
>out_bmap_cancel: error path label upstream as a result of code
>rework. Only change was to the last code block removed by the
>patch. Functionally equivalent to upstream.

This patch also needs to be backported to 4.19. I can look into that
tomorrow unless you can send a patch sooner :)

-- 
Thanks,
Sasha
