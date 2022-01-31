Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D39744A4FB8
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 20:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231643AbiAaTvo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 14:51:44 -0500
Received: from mga18.intel.com ([134.134.136.126]:42806 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232738AbiAaTvX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 Jan 2022 14:51:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643658683; x=1675194683;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=AuQjRb5W+n0pT7rLWvB6cY+pUQDPFpGw+PwT3Eo7hgY=;
  b=WjmMyeQNo6IR0Y2JhIdaxUldK2ixlGH5pAxtFiUungGbIio+s9TiYtq3
   BKtz05+3XT5x2u9zP0Mpi21cdZ2UcteyAW31cxK7yXVYyWmRn9s+15wZ4
   qP0o+ng+gAGu75TYqIcN0kIRuzeJ1jdGE+jk9Q1f2a1f84vOQH0umRpFD
   IhYvAKYtceO4LLjI1w4tJtPGIG5PEdUqDkIMu1w8j1x1wsegZAjOcm9Ik
   9iumkfxXU8idl1DWpZyqKPD8nJDjxHBdx8z7KJX4BY6KIRduT4QuNBFHD
   S6RfyiPsCitVZ2hJsatW1Jrjqao3VjbDV3h1nOe/bHqUJ3u/HwLiImT8n
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10244"; a="231109334"
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="231109334"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 11:51:22 -0800
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="537455738"
Received: from abilal-mobl1.amr.corp.intel.com ([10.212.252.235])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 11:51:21 -0800
Date:   Mon, 31 Jan 2022 11:51:21 -0800 (PST)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Jean Sacren <sakiwit@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.16 137/200] mptcp: clean up harmless false
 expressions
In-Reply-To: <20220131105238.167982722@linuxfoundation.org>
Message-ID: <b1fa42c0-bd8f-9090-a7b9-275b6b245aaf@linux.intel.com>
References: <20220131105233.561926043@linuxfoundation.org> <20220131105238.167982722@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 31 Jan 2022, Greg Kroah-Hartman wrote:

> From: Jean Sacren <sakiwit@gmail.com>
>
> [ Upstream commit 59060a47ca50bbdb1d863b73667a1065873ecc06 ]
>

Please drop this from the stable queue for both 5.15 and 5.16. This is a 
code cleanup (no functional change) patch that was originally merged in 
net-next and then got selected for stable.

It's pretty harmless to backport this one, but I hope this feedback is 
useful for tuning your scripts or manual patch review processes. If it's 
more helpful for me to let something like this slide by, or I'm 
misunderstanding how this might belong in the stable trees, I am likewise 
open to feedback!


Thanks,
Mat


> entry->addr.id is u8 with a range from 0 to 255 and MAX_ADDR_ID is 255.
> We should drop both false expressions of (entry->addr.id > MAX_ADDR_ID).
>
> We should also remove the obsolete parentheses in the first if branch.
>
> Use U8_MAX for MAX_ADDR_ID and add a comment to show the link to
> mptcp_addr_info.id as suggested by Mr. Matthieu Baerts.
>
> Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Signed-off-by: Jean Sacren <sakiwit@gmail.com>
> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
> net/mptcp/pm_netlink.c | 8 ++++----
> 1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
> index d18b13e3e74c6..27427aeeee0e5 100644
> --- a/net/mptcp/pm_netlink.c
> +++ b/net/mptcp/pm_netlink.c
> @@ -38,7 +38,8 @@ struct mptcp_pm_add_entry {
> 	u8			retrans_times;
> };
>
> -#define MAX_ADDR_ID		255
> +/* max value of mptcp_addr_info.id */
> +#define MAX_ADDR_ID		U8_MAX
> #define BITMAP_SZ DIV_ROUND_UP(MAX_ADDR_ID + 1, BITS_PER_LONG)
>
> struct pm_nl_pernet {
> @@ -831,14 +832,13 @@ find_next:
> 		entry->addr.id = find_next_zero_bit(pernet->id_bitmap,
> 						    MAX_ADDR_ID + 1,
> 						    pernet->next_id);
> -		if ((!entry->addr.id || entry->addr.id > MAX_ADDR_ID) &&
> -		    pernet->next_id != 1) {
> +		if (!entry->addr.id && pernet->next_id != 1) {
> 			pernet->next_id = 1;
> 			goto find_next;
> 		}
> 	}
>
> -	if (!entry->addr.id || entry->addr.id > MAX_ADDR_ID)
> +	if (!entry->addr.id)
> 		goto out;
>
> 	__set_bit(entry->addr.id, pernet->id_bitmap);
> -- 
> 2.34.1
>
>
>
>

--
Mat Martineau
Intel
