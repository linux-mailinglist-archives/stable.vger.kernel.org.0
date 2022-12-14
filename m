Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A711864D321
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 00:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbiLNXQ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Dec 2022 18:16:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiLNXQ2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Dec 2022 18:16:28 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 853702CC9B;
        Wed, 14 Dec 2022 15:16:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=C4PlJ3Sy7zWtp1PRUv3TzmsgmH1qPuEi2ojtvvgE5Ao=; b=OrKgF8eNHEWDfiaSD2I6V6hj+H
        BP/ZjuxCLXtd6cJzTazwX/1XnUHqYEV+bisGpK5c3q+6znFwNPIbbGsx/bjfKzhzqwEFhHVD8Q1wT
        FsYWWJk5kU7zzVb21/+wrwwNgfiXQpEcKf60UWbYde1BJO3bsPglEG3niZLM+5zGjryzkj4JrU0Mm
        JNYQYxzHWUcGKIqvgWjap/XA/UtFdSyZ+nU+hvPe7+Fi5AZCj01Bbhg2BqfbsYKyE1jY+CRePZC2i
        sX8aqTk5/A9SCv9j6ihrvVzpaCibkvszVQH/HklNsIsFR0LiRRKNMfJNqUkGWd6STIrK+Z+8cf4/a
        cLBPkwtA==;
Received: from [2601:1c2:d80:3110::a2e7]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p5az9-004BzT-MS; Wed, 14 Dec 2022 23:16:23 +0000
Message-ID: <7a2bbeed-59c2-024f-4778-3f4db3d7beaa@infradead.org>
Date:   Wed, 14 Dec 2022 15:16:22 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [RFC PATCH] mm/mempolicy: Fix memory leak in
 set_mempolicy_home_node system call
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Ben Widawsky <ben.widawsky@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Feng Tang <feng.tang@intel.com>,
        Michal Hocko <mhocko@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Andi Kleen <ak@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Huang Ying <ying.huang@intel.com>, linux-api@vger.kernel.org,
        stable@vger.kernel.org
References: <20221214222110.200487-1-mathieu.desnoyers@efficios.com>
Content-Language: en-US
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20221214222110.200487-1-mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/14/22 14:21, Mathieu Desnoyers wrote:
> When encountering any vma in the range with policy other than MPOL_BIND
> or MPOL_PREFERRED_MANY, an error is returned without issuing a mpol_put
> on the policy just allocated with mpol_dup().
> 
> This allows arbitrary users to leak kernel memory.
> 
> Fixes: c6018b4b2549 ("mm/mempolicy: add set_mempolicy_home_node syscall")
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
> Cc: Ben Widawsky <ben.widawsky@intel.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Feng Tang <feng.tang@intel.com>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: Mel Gorman <mgorman@techsingularity.net>
> Cc: Mike Kravetz <mike.kravetz@oracle.com>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Huang Ying <ying.huang@intel.com>
> Cc: <linux-api@vger.kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: stable@vger.kernel.org # 5.17+

Reviewed-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
>  mm/mempolicy.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 61aa9aedb728..02c8a712282f 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -1540,6 +1540,7 @@ SYSCALL_DEFINE4(set_mempolicy_home_node, unsigned long, start, unsigned long, le
>  		 * the home node for vmas we already updated before.
>  		 */
>  		if (new->mode != MPOL_BIND && new->mode != MPOL_PREFERRED_MANY) {
> +			mpol_put(new);
>  			err = -EOPNOTSUPP;
>  			break;
>  		}

-- 
~Randy
