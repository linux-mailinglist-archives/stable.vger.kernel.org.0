Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 056AD473014
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 16:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235333AbhLMPGe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 10:06:34 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:55912 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231924AbhLMPGe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 10:06:34 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 985F01F3B9;
        Mon, 13 Dec 2021 15:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1639407992; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mo0LvTTdCAdYCELtja1WibnDYrDpY4UUg3gYnSLtKHs=;
        b=Zv5q+rsqvGBcvPNXTC0JYSr5b+BCn+RUcwsHqjHFcdPO8dKSiP1Ro/pxEtzq/mPItUxgXc
        xXYhrJoSvPPt52OonbLIzk8XN6t8WeGqg3+JhoraV3Hjbtepfq22fi968GfIQH2cxqiC9v
        gsqwy8wrjljI5ipLw+Xm4mwO/6oFeb0=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 68C9DA3B8A;
        Mon, 13 Dec 2021 15:06:32 +0000 (UTC)
Date:   Mon, 13 Dec 2021 16:06:31 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     Alexey Makhalov <amakhalov@vmware.com>
Cc:     Dennis Zhou <dennis@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Oscar Salvador <osalvador@suse.de>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Nico Pache <npache@redhat.com>
Subject: Re: [PATCH v3] mm: fix panic in __alloc_pages
Message-ID: <YbdhdySBaHJ/UxBZ@dhcp22.suse.cz>
References: <2e191db3-286f-90c6-bf96-3f89891e9926@gmail.com>
 <YYqstfX8PSGDfWsn@dhcp22.suse.cz>
 <YYrGpn/52HaLCAyo@fedora>
 <YYrSC7vtSQXz652a@dhcp22.suse.cz>
 <BAE95F0C-FAA7-40C6-A0D6-5049B1207A27@vmware.com>
 <YZN3ExwL7BiDS5nj@dhcp22.suse.cz>
 <5239D699-523C-4F0C-923A-B068E476043E@vmware.com>
 <YZYQUn10DrKhSE7L@dhcp22.suse.cz>
 <Ya89aqij6nMwJrIZ@dhcp22.suse.cz>
 <YbHfBgPQMkjtuHYF@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YbHfBgPQMkjtuHYF@dhcp22.suse.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 09-12-21 11:48:42, Michal Hocko wrote:
[...]
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 852041f6be41..2d38a431f62f 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1161,19 +1161,21 @@ static void reset_node_present_pages(pg_data_t *pgdat)
>  }
>  
>  /* we are OK calling __meminit stuff here - we have CONFIG_MEMORY_HOTPLUG */
> -static pg_data_t __ref *hotadd_new_pgdat(int nid)
> +static pg_data_t __ref *hotadd_init_pgdat(int nid)
>  {
>  	struct pglist_data *pgdat;
>  
>  	pgdat = NODE_DATA(nid);
> -	if (!pgdat) {
> -		pgdat = arch_alloc_nodedata(nid);
> -		if (!pgdat)
> -			return NULL;
>  
> +	/*
> +	 * NODE_DATA is preallocated (free_area_init) but its internal
> +	 * state is not allocated completely. Add missing pieces.
> +	 * Completely offline nodes stay around and they just need
> +	 * reintialization.
> +	 */
> +	if (!pgdat->per_cpu_nodestats) {
>  		pgdat->per_cpu_nodestats =
>  			alloc_percpu(struct per_cpu_nodestat);
> -		arch_refresh_nodedata(nid, pgdat);

This should really be 
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 42211485bcf3..2daa88ce8c80 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1173,7 +1173,7 @@ static pg_data_t __ref *hotadd_init_pgdat(int nid)
 	 * Completely offline nodes stay around and they just need
 	 * reintialization.
 	 */
-	if (!pgdat->per_cpu_nodestats) {
+	if (pgdat->per_cpu_nodestats == &boot_nodestats) {
 		pgdat->per_cpu_nodestats =
 			alloc_percpu(struct per_cpu_nodestat);
 	} else {
-- 
Michal Hocko
SUSE Labs
