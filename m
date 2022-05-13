Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52EF25264FC
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 16:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381081AbiEMOoC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 10:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382804AbiEMOnO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 10:43:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C0B95EDC4;
        Fri, 13 May 2022 07:40:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB45962267;
        Fri, 13 May 2022 14:40:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0733BC34100;
        Fri, 13 May 2022 14:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652452836;
        bh=7oGrhX8CIp66kt0QNELQaxYz1ZjgcnRAlrNYt+x84Bs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ag5y34amHEl8FBF7sAf3BwGQdVbH8twA7My895e1UwRv1y0T/DZKUh1ZsWPZibI+V
         z/VbkedrFgqXnU/otIdd20ZqyvqI6oSrkkYh0s4bbX39MSJ5t9VJHLJW+ANmAdb+4c
         icQTH0G/vufaf78DRh0X3RqDez1Mt8cMOWeKOaYInOn9+omXQhz7/AGPHcT+qOt3NT
         z7IeMqgDyQhYtLA0R4brstO7D5PZMQ+g+vFeaBHkhVtSgki7S6lRh4pMP2C1gklab2
         DuBqsOfB9F0AFlI92MG3tDuFq0Sc8jnYll+oXzB/L6VB76QW6v5F2ewtzT4v0dp2V/
         kbRysrhf0Cdfg==
Date:   Fri, 13 May 2022 17:39:05 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Reinette Chatre <reinette.chatre@intel.com>
Cc:     dave.hansen@linux.intel.com, tglx@linutronix.de, bp@alien8.de,
        luto@kernel.org, mingo@redhat.com, linux-sgx@vger.kernel.org,
        x86@kernel.org, haitao.huang@intel.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH V3 1/5] x86/sgx: Disconnect backing page references from
 dirty status
Message-ID: <Yn5tiZL7EH2kYWiJ@iki.fi>
References: <cover.1652389823.git.reinette.chatre@intel.com>
 <fa9f98986923f43e72ef4c6702a50b2a0b3c42e3.1652389823.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa9f98986923f43e72ef4c6702a50b2a0b3c42e3.1652389823.git.reinette.chatre@intel.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 12, 2022 at 02:50:57PM -0700, Reinette Chatre wrote:
> SGX uses shmem backing storage to store encrypted enclave pages
> and their crypto metadata when enclave pages are moved out of
> enclave memory. Two shmem backing storage pages are associated with
> each enclave page - one backing page to contain the encrypted
> enclave page data and one backing page (shared by a few
> enclave pages) to contain the crypto metadata used by the
> processor to verify the enclave page when it is loaded back into
> the enclave.
> 
> sgx_encl_put_backing() is used to release references to the
> backing storage and, optionally, mark both backing store pages
> as dirty.
> 
> Managing references and dirty status together in this way results
> in both backing store pages marked as dirty, even if only one of
> the backing store pages are changed.
> 
> Additionally, waiting until the page reference is dropped to set
> the page dirty risks a race with the page fault handler that
> may load outdated data into the enclave when a page is faulted
> right after it is reclaimed.
> 
> Consider what happens if the reclaimer writes a page to the backing
> store and the page is immediately faulted back, before the reclaimer
> is able to set the dirty bit of the page:
> 
> sgx_reclaim_pages() {                    sgx_vma_fault() {
>   ...
>   sgx_encl_get_backing();
>   ...                                      ...
>   sgx_reclaimer_write() {
>     mutex_lock(&encl->lock);
>     /* Write data to backing store */
>     mutex_unlock(&encl->lock);
>   }
>                                            mutex_lock(&encl->lock);
>                                            __sgx_encl_eldu() {
>                                              ...
>                                              /*
>                                               * Enclave backing store
>                                               * page not released
>                                               * nor marked dirty -
>                                               * contents may not be
>                                               * up to date.
>                                               */
>                                               sgx_encl_get_backing();
>                                               ...
>                                               /*
>                                                * Enclave data restored
>                                                * from backing store
>                                                * and PCMD pages that
>                                                * are not up to date.
>                                                * ENCLS[ELDU] faults
>                                                * because of MAC or PCMD
>                                                * checking failure.
>                                                */
>                                                sgx_encl_put_backing();
>                                             }
>                                             ...
>   /* set page dirty */
>   sgx_encl_put_backing();
>   ...
>                                             mutex_unlock(&encl->lock);
> }                                        }
> 
> Remove the option to sgx_encl_put_backing() to set the backing
> pages as dirty and set the needed pages as dirty right after
> receiving important data while enclave mutex is held. This ensures that
> the page fault handler can get up to date data from a page and prepares
> the code for a following change where only one of the backing pages
> need to be marked as dirty.
> 
> Cc: stable@vger.kernel.org
> Fixes: 1728ab54b4be ("x86/sgx: Add a page reclaimer")
> Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
> Tested-by: Haitao Huang <haitao.huang@intel.com>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> Link: https://lore.kernel.org/linux-sgx/8922e48f-6646-c7cc-6393-7c78dcf23d23@intel.com/
> ---
> Changes since V2:
> - Mark page as dirty after receiving important data, not before. (Dave)
> - Add cc to stable and include link to discussion. (Dave)
> - Update changelog and move changelog description of race between reclaimer
>   and page fault handler from later in series to this patch.
> - Add Haitao's Tested-by tag.
> 
> Changes since RFC v1:
> - New patch.
> 
>  arch/x86/kernel/cpu/sgx/encl.c | 10 ++--------
>  arch/x86/kernel/cpu/sgx/encl.h |  2 +-
>  arch/x86/kernel/cpu/sgx/main.c |  6 ++++--
>  3 files changed, 7 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> index 7c63a1911fae..398695a20605 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -94,7 +94,7 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
>  	kunmap_atomic(pcmd_page);
>  	kunmap_atomic((void *)(unsigned long)pginfo.contents);
>  
> -	sgx_encl_put_backing(&b, false);
> +	sgx_encl_put_backing(&b);
>  
>  	sgx_encl_truncate_backing_page(encl, page_index);
>  
> @@ -645,15 +645,9 @@ int sgx_encl_get_backing(struct sgx_encl *encl, unsigned long page_index,
>  /**
>   * sgx_encl_put_backing() - Unpin the backing storage
>   * @backing:	data for accessing backing storage for the page
> - * @do_write:	mark pages dirty
>   */
> -void sgx_encl_put_backing(struct sgx_backing *backing, bool do_write)
> +void sgx_encl_put_backing(struct sgx_backing *backing)
>  {
> -	if (do_write) {
> -		set_page_dirty(backing->pcmd);
> -		set_page_dirty(backing->contents);
> -	}
> -
>  	put_page(backing->pcmd);
>  	put_page(backing->contents);
>  }
> diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
> index fec43ca65065..d44e7372151f 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.h
> +++ b/arch/x86/kernel/cpu/sgx/encl.h
> @@ -107,7 +107,7 @@ void sgx_encl_release(struct kref *ref);
>  int sgx_encl_mm_add(struct sgx_encl *encl, struct mm_struct *mm);
>  int sgx_encl_get_backing(struct sgx_encl *encl, unsigned long page_index,
>  			 struct sgx_backing *backing);
> -void sgx_encl_put_backing(struct sgx_backing *backing, bool do_write);
> +void sgx_encl_put_backing(struct sgx_backing *backing);
>  int sgx_encl_test_and_clear_young(struct mm_struct *mm,
>  				  struct sgx_encl_page *page);
>  
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index 8e4bc6453d26..e71df40a4f38 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -191,6 +191,8 @@ static int __sgx_encl_ewb(struct sgx_epc_page *epc_page, void *va_slot,
>  			  backing->pcmd_offset;
>  
>  	ret = __ewb(&pginfo, sgx_get_epc_virt_addr(epc_page), va_slot);
> +	set_page_dirty(backing->pcmd);
> +	set_page_dirty(backing->contents);
>  
>  	kunmap_atomic((void *)(unsigned long)(pginfo.metadata -
>  					      backing->pcmd_offset));
> @@ -320,7 +322,7 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
>  		sgx_encl_free_epc_page(encl->secs.epc_page);
>  		encl->secs.epc_page = NULL;
>  
> -		sgx_encl_put_backing(&secs_backing, true);
> +		sgx_encl_put_backing(&secs_backing);
>  	}
>  
>  out:
> @@ -411,7 +413,7 @@ static void sgx_reclaim_pages(void)
>  
>  		encl_page = epc_page->owner;
>  		sgx_reclaimer_write(epc_page, &backing[i]);
> -		sgx_encl_put_backing(&backing[i], true);
> +		sgx_encl_put_backing(&backing[i]);
>  
>  		kref_put(&encl_page->encl->refcount, sgx_encl_release);
>  		epc_page->flags &= ~SGX_EPC_PAGE_RECLAIMER_TRACKED;
> -- 
> 2.25.1
> 

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
