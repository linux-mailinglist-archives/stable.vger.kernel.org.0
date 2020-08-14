Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D445D244524
	for <lists+stable@lfdr.de>; Fri, 14 Aug 2020 08:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726122AbgHNG6K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Aug 2020 02:58:10 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44466 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbgHNG6J (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Aug 2020 02:58:09 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07E6w03m025959;
        Fri, 14 Aug 2020 06:58:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=QRRHC69XXeD8vFMhZPHnZYQVtHfwGesC2RC81X9X4Wk=;
 b=CDwwlqeeF8jnQbRjp0mB5TQkl8YVum8Ogr4HQgeHTHpvCVeNoCGowgBBegPBLgVetITF
 bPf9mGAtV/4QcIR2kd5GL5xMhW1zGTJEIG8It39TLoSn4sveDPXM1PZdaAOnDFg6zG3C
 lD6cv9WDDCweSeMcHd6h7DxAMAFzY6Z8FjzwIy1Y7FFHCtQyZ4jBszwgFcTElzWkDnJX
 K67tNxH9jI3V3AQBZayXj1jar7VRbNvIZV8xd5k6q6iPK2EVQqFmB99fadYzHobi55Fz
 Pc2TYoDXQ2lfl5zijytEwpxQDZPqS1YxRm3LJXax961XpvH6LX4AiWJ45N0Rp968A3oD 1w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 32t2ye31hv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 14 Aug 2020 06:58:00 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07E6vVmv139079;
        Fri, 14 Aug 2020 06:57:55 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 32t5ybtv6d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Aug 2020 06:57:54 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07E6vqfD003773;
        Fri, 14 Aug 2020 06:57:53 GMT
Received: from [10.159.133.241] (/10.159.133.241)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 14 Aug 2020 06:57:52 +0000
Subject: Re: [PATCH] mm: slub: fix conversion of freelist_corrupted()
To:     Eugeniu Rosca <erosca@de.adit-jv.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-mm@kvack.org, stable@vger.kernel.org,
        Eugeniu Rosca <roscaeugeniu@gmail.com>
References: <20200811124656.10308-1-erosca@de.adit-jv.com>
From:   Dongli Zhang <dongli.zhang@oracle.com>
Message-ID: <f93a9f06-8608-6f28-27c0-b17f86dca55b@oracle.com>
Date:   Thu, 13 Aug 2020 23:57:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200811124656.10308-1-erosca@de.adit-jv.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9712 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008140053
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9712 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 priorityscore=1501
 malwarescore=0 impostorscore=0 lowpriorityscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 phishscore=0 adultscore=0 spamscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008140053
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 8/11/20 5:46 AM, Eugeniu Rosca wrote:
> Commit 52f23478081ae0 ("mm/slub.c: fix corrupted freechain in
> deactivate_slab()") suffered an update when picked up from LKML [1].
> 
> Specifically, relocating 'freelist = NULL' into 'freelist_corrupted()'
> created a no-op statement. Fix it by sticking to the behavior intended
> in the original patch [1]. Prefer the lowest-line-count solution.
> 
> [1] https://lore.kernel.org/linux-mm/20200331031450.12182-1-dongli.zhang@oracle.com/
> 
> Fixes: 52f23478081ae0 ("mm/slub.c: fix corrupted freechain in deactivate_slab()")
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Dongli Zhang <dongli.zhang@oracle.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Eugeniu Rosca <erosca@de.adit-jv.com>
> ---
>  mm/slub.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 68c02b2eecd9..9a3e963b02a3 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -677,7 +677,6 @@ static bool freelist_corrupted(struct kmem_cache *s, struct page *page,
>  	if ((s->flags & SLAB_CONSISTENCY_CHECKS) &&
>  	    !check_valid_pointer(s, page, nextfree)) {
>  		object_err(s, page, freelist, "Freechain corrupt");
> -		freelist = NULL;
>  		slab_fix(s, "Isolate corrupted freechain");
>  		return true;
>  	}
> @@ -2184,8 +2183,10 @@ static void deactivate_slab(struct kmem_cache *s, struct page *page,
>  		 * 'freelist' is already corrupted.  So isolate all objects
>  		 * starting at 'freelist'.
>  		 */
> -		if (freelist_corrupted(s, page, freelist, nextfree))
> +		if (freelist_corrupted(s, page, freelist, nextfree)) {
> +			freelist = NULL;

This is good to me.

However, this would confuse people when CONFIG_SLUB_DEBUG is not defined.

While reading the source code, people may be curious why to reset freelist when
CONFIG_SLUB_DEBUG is even not defined.

Dongli Zhang
