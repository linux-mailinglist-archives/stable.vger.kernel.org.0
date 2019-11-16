Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 234D9FF5D8
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 22:54:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbfKPVy3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 16:54:29 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:33598 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727273AbfKPVy3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 16 Nov 2019 16:54:29 -0500
Received: from dread.disaster.area (pa49-181-255-80.pa.nsw.optusnet.com.au [49.181.255.80])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 79B2543FC79;
        Sun, 17 Nov 2019 08:54:25 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iW61Q-0000T8-03; Sun, 17 Nov 2019 08:54:24 +1100
Date:   Sun, 17 Nov 2019 08:54:23 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.19 069/237] xfs: fix use-after-free race in
 xfs_buf_rele
Message-ID: <20191116215423.GG25427@dread.disaster.area>
References: <20191116154113.7417-1-sashal@kernel.org>
 <20191116154113.7417-69-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191116154113.7417-69-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=XqaD5fcB6dAc7xyKljs8OA==:117 a=XqaD5fcB6dAc7xyKljs8OA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=MeAgGD-zjQ4A:10
        a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=4S77rzMOW_O4qRUW8bwA:9
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[cc linux-xfs@vger.kernel.org]

Hi Sasha,

Any reason these these autosel patches are not being cc'd to the XFS
list for XFS maintainer visibility and review?

Cheers,

Dave.

On Sat, Nov 16, 2019 at 10:38:24AM -0500, Sasha Levin wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> [ Upstream commit 37fd1678245f7a5898c1b05128bc481fb403c290 ]
> 
> When looking at a 4.18 based KASAN use after free report, I noticed
> that racing xfs_buf_rele() may race on dropping the last reference
> to the buffer and taking the buffer lock. This was the symptom
> displayed by the KASAN report, but the actual issue that was
> reported had already been fixed in 4.19-rc1 by commit e339dd8d8b04
> ("xfs: use sync buffer I/O for sync delwri queue submission").
> 
> Despite this, I think there is still an issue with xfs_buf_rele()
> in this code:
> 
>         release = atomic_dec_and_lock(&bp->b_hold, &pag->pag_buf_lock);
>         spin_lock(&bp->b_lock);
>         if (!release) {
> .....
> 
> If two threads race on the b_lock after both dropping a reference
> and one getting dropping the last reference so release = true, we
> end up with:
> 
> CPU 0				CPU 1
> atomic_dec_and_lock()
> 				atomic_dec_and_lock()
> 				spin_lock(&bp->b_lock)
> spin_lock(&bp->b_lock)
> <spins>
> 				<release = true bp->b_lru_ref = 0>
> 				<remove from lists>
> 				freebuf = true
> 				spin_unlock(&bp->b_lock)
> 				xfs_buf_free(bp)
> <gets lock, reading and writing freed memory>
> <accesses freed memory>
> spin_unlock(&bp->b_lock) <reads/writes freed memory>
> 
> IOWs, we can't safely take bp->b_lock after dropping the hold
> reference because the buffer may go away at any time after we
> drop that reference. However, this can be fixed simply by taking the
> bp->b_lock before we drop the reference.
> 
> It is safe to nest the pag_buf_lock inside bp->b_lock as the
> pag_buf_lock is only used to serialise against lookup in
> xfs_buf_find() and no other locks are held over or under the
> pag_buf_lock there. Make this clear by documenting the buffer lock
> orders at the top of the file.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com
> Signed-off-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

> ---
>  fs/xfs/xfs_buf.c | 38 +++++++++++++++++++++++++++++++++++++-
>  1 file changed, 37 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index e839907e8492f..f4a89c94c931b 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -37,6 +37,32 @@ static kmem_zone_t *xfs_buf_zone;
>  #define xb_to_gfp(flags) \
>  	((((flags) & XBF_READ_AHEAD) ? __GFP_NORETRY : GFP_NOFS) | __GFP_NOWARN)
>  
> +/*
> + * Locking orders
> + *
> + * xfs_buf_ioacct_inc:
> + * xfs_buf_ioacct_dec:
> + *	b_sema (caller holds)
> + *	  b_lock
> + *
> + * xfs_buf_stale:
> + *	b_sema (caller holds)
> + *	  b_lock
> + *	    lru_lock
> + *
> + * xfs_buf_rele:
> + *	b_lock
> + *	  pag_buf_lock
> + *	    lru_lock
> + *
> + * xfs_buftarg_wait_rele
> + *	lru_lock
> + *	  b_lock (trylock due to inversion)
> + *
> + * xfs_buftarg_isolate
> + *	lru_lock
> + *	  b_lock (trylock due to inversion)
> + */
>  
>  static inline int
>  xfs_buf_is_vmapped(
> @@ -1006,8 +1032,18 @@ xfs_buf_rele(
>  
>  	ASSERT(atomic_read(&bp->b_hold) > 0);
>  
> -	release = atomic_dec_and_lock(&bp->b_hold, &pag->pag_buf_lock);
> +	/*
> +	 * We grab the b_lock here first to serialise racing xfs_buf_rele()
> +	 * calls. The pag_buf_lock being taken on the last reference only
> +	 * serialises against racing lookups in xfs_buf_find(). IOWs, the second
> +	 * to last reference we drop here is not serialised against the last
> +	 * reference until we take bp->b_lock. Hence if we don't grab b_lock
> +	 * first, the last "release" reference can win the race to the lock and
> +	 * free the buffer before the second-to-last reference is processed,
> +	 * leading to a use-after-free scenario.
> +	 */
>  	spin_lock(&bp->b_lock);
> +	release = atomic_dec_and_lock(&bp->b_hold, &pag->pag_buf_lock);
>  	if (!release) {
>  		/*
>  		 * Drop the in-flight state if the buffer is already on the LRU
> -- 
> 2.20.1
> 
> 

-- 
Dave Chinner
david@fromorbit.com
