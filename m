Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4E8034D764
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 20:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbhC2Sgg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 14:36:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:64377 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230271AbhC2SgK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 14:36:10 -0400
IronPort-SDR: pqbggAYU52asxG4W3PuVVULTfG7lw1TM2cIElitJZzeShYeXALnyvnIW30Q5rGlcqBLe0m08mp
 quwVpi2HmNWA==
X-IronPort-AV: E=McAfee;i="6000,8403,9938"; a="188339647"
X-IronPort-AV: E=Sophos;i="5.81,288,1610438400"; 
   d="scan'208";a="188339647"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2021 11:36:09 -0700
IronPort-SDR: GVmyVYddbTheVlWjv4OmIRFKrpnQj6Tx68zIp33V3ltDHH2AzWWWDci/jUHfPgCeDkxNtJ7mF3
 /CjrAXYbN/aA==
X-IronPort-AV: E=Sophos;i="5.81,288,1610438400"; 
   d="scan'208";a="417794044"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2021 11:36:09 -0700
Date:   Mon, 29 Mar 2021 11:36:09 -0700
From:   Ira Weiny <ira.weiny@intel.com>
To:     dennis.dalessandro@cornelisnetworks.com
Cc:     dledford@redhat.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH for-rc 4/4] IB/hfi1: Fix regressions in security fix
Message-ID: <20210329183609.GA3014244@iweiny-DESK2.sc.intel.com>
References: <1617025700-31865-1-git-send-email-dennis.dalessandro@cornelisnetworks.com>
 <1617025700-31865-5-git-send-email-dennis.dalessandro@cornelisnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1617025700-31865-5-git-send-email-dennis.dalessandro@cornelisnetworks.com>
User-Agent: Mutt/1.11.1 (2018-12-01)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 29, 2021 at 09:48:20AM -0400, dennis.dalessandro@cornelisnetworks.com wrote:
> From: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
> 
> The security code guards for non-current mm in all cases for
> updating the rb tree.
> 
> That is ok for insert, but NOT ok for remove, since the insert
> has already guarded the node from being inserted and the remove
> can be called with a different mm because of a segfault other similar
> "close" issues where current-mm is NULL.
> 
> Best case, is we leak pages. worst case we delete items for an lru_list
> more than once:
> [20945.911107] list_del corruption, ffffa0cd536bcac8->next is LIST_POISON1 (dead000000000100)
> 
> Fix by removing the guard from any functions that remove nodes
> from the tree assuming the node was entered into the tree as valid since
> the insert is guarded.

Does this open up a child process being able to remove nodes which the parent
added?

Ira

> 
> Fixes: 3d2a9d642512 ("IB/hfi1: Ensure correct mm is used at all times")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
> ---
>  drivers/infiniband/hw/hfi1/mmu_rb.c | 9 ---------
>  1 file changed, 9 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/hfi1/mmu_rb.c b/drivers/infiniband/hw/hfi1/mmu_rb.c
> index f3fb28e..375a881 100644
> --- a/drivers/infiniband/hw/hfi1/mmu_rb.c
> +++ b/drivers/infiniband/hw/hfi1/mmu_rb.c
> @@ -210,9 +210,6 @@ bool hfi1_mmu_rb_remove_unless_exact(struct mmu_rb_handler *handler,
>  	unsigned long flags;
>  	bool ret = false;
>  
> -	if (current->mm != handler->mn.mm)
> -		return ret;
> -
>  	spin_lock_irqsave(&handler->lock, flags);
>  	node = __mmu_rb_search(handler, addr, len);
>  	if (node) {
> @@ -235,9 +232,6 @@ void hfi1_mmu_rb_evict(struct mmu_rb_handler *handler, void *evict_arg)
>  	unsigned long flags;
>  	bool stop = false;
>  
> -	if (current->mm != handler->mn.mm)
> -		return;
> -
>  	INIT_LIST_HEAD(&del_list);
>  
>  	spin_lock_irqsave(&handler->lock, flags);
> @@ -271,9 +265,6 @@ void hfi1_mmu_rb_remove(struct mmu_rb_handler *handler,
>  {
>  	unsigned long flags;
>  
> -	if (current->mm != handler->mn.mm)
> -		return;
> -
>  	/* Validity of handler and node pointers has been checked by caller. */
>  	trace_hfi1_mmu_rb_remove(node->addr, node->len);
>  	spin_lock_irqsave(&handler->lock, flags);
> -- 
> 1.8.3.1
> 
