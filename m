Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2DE264D676
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 07:35:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiLOGfY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 01:35:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiLOGfX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 01:35:23 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 246EF2E682;
        Wed, 14 Dec 2022 22:35:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671086122; x=1702622122;
  h=from:to:cc:subject:references:date:in-reply-to:
   message-id:mime-version;
  bh=6BhKwxLoiCEkdX7Mxu8xhjidUeUgBzn2t+PJF3ARK68=;
  b=XqGrx1b2G2rUFQo9A1FJgIMtpLUx/xBjJRgggbBqO4DlhhQLAgQG4A1z
   1FiXbtuNr7m16nNJoq58uzryqhI9184xcQYHmAOortwPX71pjX5nm+u5q
   PIN9v+lrBC+3YjSUzH+By0Fl961eQMdgtoE9dPIUC28D/jb1Mm2Jh9JRB
   HqZorp2ZCZd1PsJ5Zo3cRnNaP5gcBmuUfWrxLkTf2L65kIlkEnt8lxV3n
   vCe03+cN7tnIIcNWKAwLde+s5lUJ5W/M5bT0GGMCsgAhfP6+CwegXVRpe
   RqpKws9Kh7KXoouX3yLPazeoQPPe9+GzV1BHpA/S973psOdS7vQAO8HLs
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="317312612"
X-IronPort-AV: E=Sophos;i="5.96,246,1665471600"; 
   d="scan'208";a="317312612"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2022 22:35:21 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="680005274"
X-IronPort-AV: E=Sophos;i="5.96,246,1665471600"; 
   d="scan'208";a="680005274"
Received: from yhuang6-desk2.sh.intel.com (HELO yhuang6-desk2.ccr.corp.intel.com) ([10.238.208.55])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2022 22:35:17 -0800
From:   "Huang, Ying" <ying.huang@intel.com>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Ben Widawsky <ben.widawsky@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Feng Tang <feng.tang@intel.com>,
        Michal Hocko <mhocko@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Andi Kleen <ak@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        linux-api@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [RFC PATCH] mm/mempolicy: Fix memory leak in
 set_mempolicy_home_node system call
References: <20221214222110.200487-1-mathieu.desnoyers@efficios.com>
Date:   Thu, 15 Dec 2022 14:34:28 +0800
In-Reply-To: <20221214222110.200487-1-mathieu.desnoyers@efficios.com> (Mathieu
        Desnoyers's message of "Wed, 14 Dec 2022 17:21:10 -0500")
Message-ID: <87k02tcgzv.fsf@yhuang6-desk2.ccr.corp.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Mathieu Desnoyers <mathieu.desnoyers@efficios.com> writes:

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

Reviewed-by: "Huang, Ying" <ying.huang@intel.com>

Thanks!

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
