Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE223526509
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 16:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381256AbiEMOoH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 10:44:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382836AbiEMOnS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 10:43:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C532650473;
        Fri, 13 May 2022 07:41:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7203BB83051;
        Fri, 13 May 2022 14:41:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF78C34115;
        Fri, 13 May 2022 14:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652452879;
        bh=5qyDUK8nO0Cxtj7jBFZ9oSbfYmXVdT6/FyJl8N3L2Ms=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=P0J6w8fEwTzn2uDkys31ziQqf0VBLay/Fe/VgXujR/dCLTWQhUR5fDiHJgqzTijc3
         7sAhwv2ch95f/zKySBzZIoupjsAbEXOz7dkTxuPXYyHXvWgVkrrnySn4zNDj3+cmEv
         h0FMJqtxLXWOB7na5e1qgPKG8/XLRibnEWmHO01mvtV/iT+kgn5lot4kVBKqbGODu3
         j//zR62GbL8RVKg6v5PTHlD13MA86gc8Bi9Mq4ODfThAAP7qg4S0WD41RBswPDX8J0
         vVK1kroJMQ5ke+i8IiO1yS3b9o/RZkaKfdZCTBqBH6TY3xKUQDcGmj/2A5VAopA2Ba
         qNtZtnL6jgyxA==
Date:   Fri, 13 May 2022 17:39:49 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Reinette Chatre <reinette.chatre@intel.com>
Cc:     dave.hansen@linux.intel.com, tglx@linutronix.de, bp@alien8.de,
        luto@kernel.org, mingo@redhat.com, linux-sgx@vger.kernel.org,
        x86@kernel.org, haitao.huang@intel.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH V3 3/5] x86/sgx: Obtain backing storage page with enclave
 mutex held
Message-ID: <Yn5ttZBgmHtwvkLx@iki.fi>
References: <cover.1652389823.git.reinette.chatre@intel.com>
 <fa2e04c561a8555bfe1f4e7adc37d60efc77387b.1652389823.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa2e04c561a8555bfe1f4e7adc37d60efc77387b.1652389823.git.reinette.chatre@intel.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 12, 2022 at 02:50:59PM -0700, Reinette Chatre wrote:
> Haitao reported encountering a WARN triggered by the ENCLS[ELDU]
> instruction faulting with a #GP.
> 
> The WARN is encountered when the reclaimer evicts a range of
> pages from the enclave when the same pages are faulted back
> right away.
> 
> The SGX backing storage is accessed on two paths: when there
> are insufficient free pages in the EPC the reclaimer works
> to move enclave pages to the backing storage and as enclaves
> access pages that have been moved to the backing storage
> they are retrieved from there as part of page fault handling.
> 
> An oversubscribed SGX system will often run the reclaimer and
> page fault handler concurrently and needs to ensure that the
> backing store is accessed safely between the reclaimer and
> the page fault handler. This is not the case because the
> reclaimer accesses the backing store without the enclave mutex
> while the page fault handler accesses the backing store with
> the enclave mutex.
> 
> Consider the scenario where a page is faulted while a page sharing
> a PCMD page with the faulted page is being reclaimed. The
> consequence is a race between the reclaimer and page fault
> handler, the reclaimer attempting to access a PCMD at the
> same time it is truncated by the page fault handler. This
> could result in lost PCMD data. Data may still be
> lost if the reclaimer wins the race, this is addressed in
> the following patch.
> 
> The reclaimer accesses pages from the backing storage without
> holding the enclave mutex and runs the risk of concurrently
> accessing the backing storage with the page fault handler that
> does access the backing storage with the enclave mutex held.
> 
> In the scenario below a PCMD page is truncated from the backing
> store after all its pages have been loaded in to the enclave
> at the same time the PCMD page is loaded from the backing store
> when one of its pages are reclaimed:
> 
> sgx_reclaim_pages() {              sgx_vma_fault() {
>                                      ...
>                                      mutex_lock(&encl->lock);
>                                      ...
>                                      __sgx_encl_eldu() {
>                                        ...
>                                        if (pcmd_page_empty) {
> /*
>  * EPC page being reclaimed              /*
>  * shares a PCMD page with an             * PCMD page truncated
>  * enclave page that is being             * while requested from
>  * faulted in.                            * reclaimer.
>  */                                       */
> sgx_encl_get_backing()  <---------->      sgx_encl_truncate_backing_page()
>                                         }
>                                        mutex_unlock(&encl->lock);
> }                                    }
> 
> In this scenario there is a race between the reclaimer and the page fault
> handler when the reclaimer attempts to get access to the same PCMD page
> that is being truncated. This could result in the reclaimer writing to
> the PCMD page that is then truncated, causing the PCMD data to be lost,
> or in a new PCMD page being allocated. The lost PCMD data may still occur
> after protecting the backing store access with the mutex - this is fixed
> in the next patch. By ensuring the backing store is accessed with the mutex
> held the enclave page state can be made accurate with the
> SGX_ENCL_PAGE_BEING_RECLAIMED flag accurately reflecting that a page
> is in the process of being reclaimed.
> 
> Consistently protect the reclaimer's backing store access with the
> enclave's mutex to ensure that it can safely run concurrently with the
> page fault handler.
> 
> Cc: stable@vger.kernel.org
> Fixes: 1728ab54b4be ("x86/sgx: Add a page reclaimer")
> Reported-by: Haitao Huang <haitao.huang@intel.com>
> Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
> Tested-by: Jarkko Sakkinen <jarkko@kernel.org>
> Tested-by: Haitao Huang <haitao.huang@intel.com>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
> Changes since V2:
> - Move description of "scenario a" to the new patch in series that marks
>   page as dirty with enclave mutex held.
> - Add Haitao's "Tested-by" tag.
> - Add Jarkko's "Reviewed-by" and "Tested-by" tags.
> 
>  arch/x86/kernel/cpu/sgx/main.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index e71df40a4f38..ab4ec54bbdd9 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -310,6 +310,7 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
>  	sgx_encl_ewb(epc_page, backing);
>  	encl_page->epc_page = NULL;
>  	encl->secs_child_cnt--;
> +	sgx_encl_put_backing(backing);
>  
>  	if (!encl->secs_child_cnt && test_bit(SGX_ENCL_INITIALIZED, &encl->flags)) {
>  		ret = sgx_encl_get_backing(encl, PFN_DOWN(encl->size),
> @@ -381,11 +382,14 @@ static void sgx_reclaim_pages(void)
>  			goto skip;
>  
>  		page_index = PFN_DOWN(encl_page->desc - encl_page->encl->base);
> +
> +		mutex_lock(&encl_page->encl->lock);
>  		ret = sgx_encl_get_backing(encl_page->encl, page_index, &backing[i]);
> -		if (ret)
> +		if (ret) {
> +			mutex_unlock(&encl_page->encl->lock);
>  			goto skip;
> +		}
>  
> -		mutex_lock(&encl_page->encl->lock);
>  		encl_page->desc |= SGX_ENCL_PAGE_BEING_RECLAIMED;
>  		mutex_unlock(&encl_page->encl->lock);
>  		continue;
> @@ -413,7 +417,6 @@ static void sgx_reclaim_pages(void)
>  
>  		encl_page = epc_page->owner;
>  		sgx_reclaimer_write(epc_page, &backing[i]);
> -		sgx_encl_put_backing(&backing[i]);
>  
>  		kref_put(&encl_page->encl->refcount, sgx_encl_release);
>  		epc_page->flags &= ~SGX_EPC_PAGE_RECLAIMER_TRACKED;
> -- 
> 2.25.1
> 

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
