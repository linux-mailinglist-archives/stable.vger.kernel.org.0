Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB881EA266
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 13:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725838AbgFALFT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 07:05:19 -0400
Received: from mail-vi1eur05on2127.outbound.protection.outlook.com ([40.107.21.127]:34913
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725788AbgFALFS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 07:05:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jsJMfAvQgFg/VF/H0G30+4Asr276rCcoob7Tyx9+2/hiIQo5mgfycci2Qg2A9rqRyPPDUXLp++fRR/PM3fNjwFJJR1i1NCZp4jnPDjrztGhHelgpH+LFnK1wlBBTvbI0YoFVw7R2e1NlFF97QPdXp7RgNPhBlspmeIizlqAL9na2P5y5FT2AlRCIPMbJ05Spln7pGVN7jhBZqNxjHIPseF0ZvR0vXCUb+4PH9CYty0FJ5ZeJaBf/5Z5XvS8lgDkiAD0Kmz9NEuM8HOIajnjmbMZiJ2MIimP9LSWWPsXWBPv+/jaxx62kh170Kh3I6s5JmawaD335UCz6oa1ooX9CFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rPXNnFq+q8FZ2/RGjaDCctsVJp2a5uwqncMMVxB615k=;
 b=EeNzHjDEFWasKpm/tKtMTggibB8QSH6ZtY+fm/2Tgn66OXescaEa7JC5QCQl0hTIm+nNHl6EnO4gykF/aZiORcDcvIwlx3CpeV2jrY2Aie9d5PsGASoELrccDTbwc3P0toyjVohcDoajk1rFXMb9gkCRQBBd9/crxq4Lh2D47CMdNNUHQCjGuXDUb34XEV5uCIty7BTl6g3/Dop7kBEvTW6Wen/ya5At8Jp5YaIBtiJzTcJhYX4FcFlgATvGWZcyPhtRUJg/Km11Ia0HO9WiD8sN9LPtI8Q73sJ/JwHA2JU9TzWLF2QUpi0XYht68J+J2MTBVINOiPTtuWllWCdb4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rPXNnFq+q8FZ2/RGjaDCctsVJp2a5uwqncMMVxB615k=;
 b=FZu498CMWWI7L5J5km1nNjPoqlaWt73H5Z+LJ+aWG3UV4jp8IDiOGfWDqaCZlqjydyUq6q66nw7etUMDZdjhCk1JBWZnf7TUvfwONeEpbdR/QoCKc2EvvRLUl0rDAx9euFd+3W/kfqwG2yErAeYKt2fOTCW58JhlD0vlw02nJEI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=virtuozzo.com;
Received: from DB6PR0802MB2374.eurprd08.prod.outlook.com (2603:10a6:4:8a::21)
 by DB6PR0802MB2581.eurprd08.prod.outlook.com (2603:10a6:4:a1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.21; Mon, 1 Jun
 2020 11:05:13 +0000
Received: from DB6PR0802MB2374.eurprd08.prod.outlook.com
 ([fe80::99c2:79cc:8d2c:ffcc]) by DB6PR0802MB2374.eurprd08.prod.outlook.com
 ([fe80::99c2:79cc:8d2c:ffcc%12]) with mapi id 15.20.3045.024; Mon, 1 Jun 2020
 11:05:13 +0000
Subject: Re: [PATCH] shmem, memcg: enable memcg aware shrinker
To:     Greg Thelen <gthelen@google.com>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20200601032204.124624-1-gthelen@google.com>
From:   Kirill Tkhai <ktkhai@virtuozzo.com>
Message-ID: <ffdff0be-f2b6-c7c0-debc-9c5e8a33ae4e@virtuozzo.com>
Date:   Mon, 1 Jun 2020 14:05:10 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
In-Reply-To: <20200601032204.124624-1-gthelen@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM3PR07CA0125.eurprd07.prod.outlook.com
 (2603:10a6:207:8::11) To DB6PR0802MB2374.eurprd08.prod.outlook.com
 (2603:10a6:4:8a::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.69] (176.14.212.145) by AM3PR07CA0125.eurprd07.prod.outlook.com (2603:10a6:207:8::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.8 via Frontend Transport; Mon, 1 Jun 2020 11:05:12 +0000
X-Originating-IP: [176.14.212.145]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ad1bd8f-e49c-4dd1-faa8-08d8061ba827
X-MS-TrafficTypeDiagnostic: DB6PR0802MB2581:
X-Microsoft-Antispam-PRVS: <DB6PR0802MB258187FE57143934AC58208CCD8A0@DB6PR0802MB2581.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:327;
X-Forefront-PRVS: 0421BF7135
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: doY0NVLF6ekYlDXKksf8ZF5S1HeBoYim1c4ynPOHFurezUI09PRa+46qNGABiIMs153hy4D0gnnPZ9AOjo0lXyQ+NQ/la2HtTxr8VzFGbGwyfCrXn8ymWG3j7yw36M2eUDPlsQpYiOWJ1jKqelWDJ5tK2GMlPMg4H+nS3IKnsOJDVXYUMNOeaJgwBqGtLUIc7WCjKcqSCxgijZXfb1Y7mewCF9shKFfVEgjdOhBgQpdC6jhmMs2pr4ixrykbkVRlZmhrqtOZrsCraxwawOO5RpM+zG9Z9u4xmXQhTS8u6snnpX33+vt8w9hfe0GnalbgaXbnFfG/QPPIOkm6Yt9+JLXMNmeR9VkT2D1th7bu5IMpA9KXIXy5txp9TmMiEUqE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6PR0802MB2374.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39840400004)(396003)(346002)(376002)(136003)(53546011)(2906002)(110136005)(956004)(31686004)(16526019)(4326008)(26005)(8676002)(316002)(186003)(16576012)(2616005)(31696002)(66556008)(66476007)(66946007)(86362001)(83380400001)(6486002)(52116002)(8936002)(478600001)(5660300002)(36756003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: CNlHl3At/07SuwJfFkcegz9nPZ2xUpEcutxVOHIB9OH2gsLbyao6AEkEpFSyVMOdWRbiuiT3SA4mum58RtN9ONmWXekdIBTVtWZF+A97GF6ycWqnN+z6e/nllelXZcG0uOcOiT/HIU4QnR8RamLltwaKvRNpGeuGbgBslZnwYLlTK8lsRnz0IpZNbwQnoykUix6ul2aqvo5UKdjBCDR3i4n0tb4Aq5JTAPDPdDRlPXNLEPiMeCxNC0x7KrfICDFIYGRTxI340RoPQVdbOrlw26mMr6/inZ+nMrZd9ResPn/UnfqeXxTjyW4HROf55bzPljFCf+XwDOSw0XbqiPHSeb+Q5c110FFsJDeZ2tkZwmyJCHeEflee5m3Go1rp3QcHQP+mR2cLyXvj/tNCyKcjeWI/RVeU67TkLB99G4caZQy3cOdZizoXOVwJfk1WKtQ76gP9jUDFMGboIzZ+3qGHp7AhePAEicBKS+hvpdPktgY=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ad1bd8f-e49c-4dd1-faa8-08d8061ba827
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2020 11:05:13.0180
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q0ziP2zAfQok8tQea8KkrkMZhJUyhDu16oca9unlcHcQvVEoHnOLS3QGZ4aas7tnbCbtr+5WqALCVAsKMZEOPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0802MB2581
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Greg,

good finding. See comments below.

On 01.06.2020 06:22, Greg Thelen wrote:
> Since v4.19 commit b0dedc49a2da ("mm/vmscan.c: iterate only over charged
> shrinkers during memcg shrink_slab()") a memcg aware shrinker is only
> called when the per-memcg per-node shrinker_map indicates that the
> shrinker may have objects to release to the memcg and node.
> 
> shmem_unused_huge_count and shmem_unused_huge_scan support the per-tmpfs
> shrinker which advertises per memcg and numa awareness.  The shmem
> shrinker releases memory by splitting hugepages that extend beyond
> i_size.
> 
> Shmem does not currently set bits in shrinker_map.  So, starting with
> b0dedc49a2da, memcg reclaim avoids calling the shmem shrinker under
> pressure.  This leads to undeserved memcg OOM kills.
> Example that reliably sees memcg OOM kill in unpatched kernel:
>   FS=/tmp/fs
>   CONTAINER=/cgroup/memory/tmpfs_shrinker
>   mkdir -p $FS
>   mount -t tmpfs -o huge=always nodev $FS
>   # Create 1000 MB container, which shouldn't suffer OOM.
>   mkdir $CONTAINER
>   echo 1000M > $CONTAINER/memory.limit_in_bytes
>   echo $BASHPID >> $CONTAINER/cgroup.procs
>   # Create 4000 files.  Ideally each file uses 4k data page + a little
>   # metadata.  Assume 8k total per-file, 32MB (4000*8k) should easily
>   # fit within container's 1000 MB.  But if data pages use 2MB
>   # hugepages (due to aggressive huge=always) then files consume 8GB,
>   # which hits memcg 1000 MB limit.
>   for i in {1..4000}; do
>     echo . > $FS/$i
>   done
> 
> v5.4 commit 87eaceb3faa5 ("mm: thp: make deferred split shrinker memcg
> aware") maintains the per-node per-memcg shrinker bitmap for THP
> shrinker.  But there's no such logic in shmem.  Make shmem set the
> per-memcg per-node shrinker bits when it modifies inodes to have
> shrinkable pages.
> 
> Fixes: b0dedc49a2da ("mm/vmscan.c: iterate only over charged shrinkers during memcg shrink_slab()")
> Cc: <stable@vger.kernel.org> # 4.19+
> Signed-off-by: Greg Thelen <gthelen@google.com>
> ---
>  mm/shmem.c | 61 +++++++++++++++++++++++++++++++-----------------------
>  1 file changed, 35 insertions(+), 26 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index bd8840082c94..e11090f78cb5 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1002,6 +1002,33 @@ static int shmem_getattr(const struct path *path, struct kstat *stat,
>  	return 0;
>  }
>  
> +/*
> + * Expose inode and optional page to shrinker as having a possibly splittable
> + * hugepage that reaches beyond i_size.
> + */
> +static void shmem_shrinker_add(struct shmem_sb_info *sbinfo,
> +			       struct inode *inode, struct page *page)
> +{
> +	struct shmem_inode_info *info = SHMEM_I(inode);
> +
> +	spin_lock(&sbinfo->shrinklist_lock);
> +	/*
> +	 * _careful to defend against unlocked access to ->shrink_list in
> +	 * shmem_unused_huge_shrink()
> +	 */
> +	if (list_empty_careful(&info->shrinklist)) {
> +		list_add_tail(&info->shrinklist, &sbinfo->shrinklist);
> +		sbinfo->shrinklist_len++;
> +	}
> +	spin_unlock(&sbinfo->shrinklist_lock);
> +
> +#ifdef CONFIG_MEMCG
> +	if (page && PageTransHuge(page))
> +		memcg_set_shrinker_bit(page->mem_cgroup, page_to_nid(page),
> +				       inode->i_sb->s_shrink.id);
> +#endif
> +}
> +
>  static int shmem_setattr(struct dentry *dentry, struct iattr *attr)
>  {
>  	struct inode *inode = d_inode(dentry);
> @@ -1048,17 +1075,13 @@ static int shmem_setattr(struct dentry *dentry, struct iattr *attr)
>  			 * to shrink under memory pressure.
>  			 */
>  			if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
> -				spin_lock(&sbinfo->shrinklist_lock);
> -				/*
> -				 * _careful to defend against unlocked access to
> -				 * ->shrink_list in shmem_unused_huge_shrink()
> -				 */
> -				if (list_empty_careful(&info->shrinklist)) {
> -					list_add_tail(&info->shrinklist,
> -							&sbinfo->shrinklist);
> -					sbinfo->shrinklist_len++;
> -				}
> -				spin_unlock(&sbinfo->shrinklist_lock);
> +				struct page *page;
> +
> +				page = find_get_page(inode->i_mapping,
> +					(newsize & HPAGE_PMD_MASK) >> PAGE_SHIFT);
> +				shmem_shrinker_add(sbinfo, inode, page);
> +				if (page)
> +					put_page(page);

1)I'd move PageTransHuge() check from shmem_shrinker_add() to here. In case of page is not trans huge,
  it looks strange and completely useless to add inode to shrinklist and then to avoid memcg_set_shrinker_bit().
  Nothing should be added to the shrinklist in this case.

2)In general I think this "last inode page spliter" does not fit SHINKER_MEMCG_AWARE conception, and
  shmem_unused_huge_shrink() should be reworked as a new separate !memcg-aware shrinker instead of
  .nr_cached_objects callback of generic fs shrinker.

CC: Kirill Shutemov

Kirill, are there any fundamental reasons to keep this shrinking logic in the generic fs shrinker?
Are there any no-go to for conversion this as a separate !memcg-aware shrinker?

>  			}
>  		}
>  	}
> @@ -1889,21 +1912,7 @@ static int shmem_getpage_gfp(struct inode *inode, pgoff_t index,
>  	if (PageTransHuge(page) &&
>  	    DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE) <
>  			hindex + HPAGE_PMD_NR - 1) {
> -		/*
> -		 * Part of the huge page is beyond i_size: subject
> -		 * to shrink under memory pressure.
> -		 */
> -		spin_lock(&sbinfo->shrinklist_lock);
> -		/*
> -		 * _careful to defend against unlocked access to
> -		 * ->shrink_list in shmem_unused_huge_shrink()
> -		 */
> -		if (list_empty_careful(&info->shrinklist)) {
> -			list_add_tail(&info->shrinklist,
> -				      &sbinfo->shrinklist);
> -			sbinfo->shrinklist_len++;
> -		}
> -		spin_unlock(&sbinfo->shrinklist_lock);
> +		shmem_shrinker_add(sbinfo, inode, page);
>  	}
>  
>  	/*

Thanks,
Kirill
