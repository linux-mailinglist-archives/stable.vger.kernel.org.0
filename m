Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDB95ABE72
	for <lists+stable@lfdr.de>; Sat,  3 Sep 2022 12:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229594AbiICK1E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Sep 2022 06:27:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbiICK1C (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Sep 2022 06:27:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D99685FD3;
        Sat,  3 Sep 2022 03:27:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4F9F6117C;
        Sat,  3 Sep 2022 10:27:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CD9CC433D6;
        Sat,  3 Sep 2022 10:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662200820;
        bh=/IkOHTF9lucJ4Y99Dr1BxXHUQdq8etcVyuS/Yk89Wyc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rPa5BjtxltcjWbQXmWghhBoBiNPSzrR9PnqQIZGHiRS8vfJ1Ym61qhJIIem4RBVzX
         FtenwaiWBRWJ7rGOTBR4WPMqdHyQJmWzIIBJPFcm2+WyA1Hi4JLkDlIS+yRNngNj3I
         OCmUqeBUIP77u2iqB2MM1/5DwcXKipVvak0kf1v49FVK4ylaPwGXiDWc+68VR8T9yT
         0WxcnLoKZVPO3wQQ+PEDbLxkNKwkGJS/Ch/DH7slJkjmOyCB/x2mVkayAyLMCqbtQ8
         ckGjQwyj+b58sKUO9OjMZyT+maWqg0k+D0Lz+g+6hv14GI4dsIl4DBk4MiCPW3WRPN
         n7B91Mb/zHPzg==
Date:   Sat, 3 Sep 2022 13:26:54 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-sgx@vger.kernel.org
Cc:     Haitao Huang <haitao.huang@linux.intel.com>,
        Vijay Dhanraj <vijay.dhanraj@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86/sgx: Do not fail on incomplete sanitization on
 premature stop of ksgxd
Message-ID: <YxMr7hIXsNcWAiN5@kernel.org>
References: <20220903060108.1709739-1-jarkko@kernel.org>
 <20220903060108.1709739-2-jarkko@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220903060108.1709739-2-jarkko@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Sep 03, 2022 at 09:01:07AM +0300, Jarkko Sakkinen wrote:
> Unsanitized pages trigger WARN_ON() unconditionally, which can panic the
> whole computer, if /proc/sys/kernel/panic_on_warn is set.
> 
> In sgx_init(), if misc_register() fails or misc_register() succeeds but
> neither sgx_drv_init() nor sgx_vepc_init() succeeds, then ksgxd will be
> prematurely stopped. This may leave unsanitized pages, which will result a
> false warning.
> 
> Refine __sgx_sanitize_pages() to return:
> 
> 1. Zero when the sanitization process is complete or ksgxd has been
>    requested to stop.
> 2. The number of unsanitized pages otherwise.
> 
> Use the return value as the criteria for triggering output, and tone down
> the output to pr_err() to prevent the whole system to be taken down if for
> some reason sanitization process does not complete.
> 
> Link: https://lore.kernel.org/linux-sgx/20220825051827.246698-1-jarkko@kernel.org/T/#u
> Fixes: 51ab30eb2ad4 ("x86/sgx: Replace section->init_laundry_list with sgx_dirty_page_list")
> Cc: stable@vger.kernel.org # v5.13+
> Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> ---
> v7:
> - Rewrote commit message.
> - Do not return -ECANCELED on premature stop. Instead use zero both
>   premature stop and complete sanitization.
> 
> v6:
> - Address Reinette's feedback:
>   https://lore.kernel.org/linux-sgx/Yw6%2FiTzSdSw%2FY%2FVO@kernel.org/
> 
> v5:
> - Add the klog dump and sysctl option to the commit message.
> 
> v4:
> - Explain expectations for dirty_page_list in the function header, instead
>   of an inline comment.
> - Improve commit message to explain the conditions better.
> - Return the number of pages left dirty to ksgxd() and print warning after
>   the 2nd call, if there are any.
> 
> v3:
> - Remove WARN_ON().
> - Tuned comments and the commit message a bit.
> 
> v2:
> - Replaced WARN_ON() with optional pr_info() inside
>   __sgx_sanitize_pages().
> - Rewrote the commit message.
> - Added the fixes tag.
> ---
>  arch/x86/kernel/cpu/sgx/main.c | 33 ++++++++++++++++++++++++++-------
>  1 file changed, 26 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index 515e2a5f25bb..c0a5ce19c608 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -49,17 +49,23 @@ static LIST_HEAD(sgx_dirty_page_list);
>   * Reset post-kexec EPC pages to the uninitialized state. The pages are removed
>   * from the input list, and made available for the page allocator. SECS pages
>   * prepending their children in the input list are left intact.
> + *
> + * Contents of the @dirty_page_list must be thread-local, i.e.
> + * not shared by multiple threads.
> + *
> + * Return 0 when sanitization was successful or kthread was stopped, and the
> + * number of unsanitized pages otherwise.
>   */
> -static void __sgx_sanitize_pages(struct list_head *dirty_page_list)
> +static unsigned long __sgx_sanitize_pages(struct list_head *dirty_page_list)
>  {
> +	unsigned long left_dirty = 0;
>  	struct sgx_epc_page *page;
>  	LIST_HEAD(dirty);
>  	int ret;
>  
> -	/* dirty_page_list is thread-local, no need for a lock: */
>  	while (!list_empty(dirty_page_list)) {
>  		if (kthread_should_stop())
> -			return;
> +			return 0;
>  
>  		page = list_first_entry(dirty_page_list, struct sgx_epc_page, list);
>  
> @@ -92,12 +98,14 @@ static void __sgx_sanitize_pages(struct list_head *dirty_page_list)
>  		} else {
>  			/* The page is not yet clean - move to the dirty list. */
>  			list_move_tail(&page->list, &dirty);
> +			left_dirty++;
>  		}
>  
>  		cond_resched();
>  	}
>  
>  	list_splice(&dirty, dirty_page_list);
> +	return left_dirty;
>  }
>  
>  static bool sgx_reclaimer_age(struct sgx_epc_page *epc_page)
> @@ -388,17 +396,28 @@ void sgx_reclaim_direct(void)
>  
>  static int ksgxd(void *p)
>  {
> +	unsigned long left_dirty;
> +
>  	set_freezable();
>  
>  	/*
>  	 * Sanitize pages in order to recover from kexec(). The 2nd pass is
>  	 * required for SECS pages, whose child pages blocked EREMOVE.
>  	 */
> -	__sgx_sanitize_pages(&sgx_dirty_page_list);
> -	__sgx_sanitize_pages(&sgx_dirty_page_list);
> +	left_dirty = __sgx_sanitize_pages(&sgx_dirty_page_list);
> +	pr_debug("%ld unsanitized pages\n", left_dirty);
                  %lu

>  
> -	/* sanity check: */
> -	WARN_ON(!list_empty(&sgx_dirty_page_list));
> +	left_dirty = __sgx_sanitize_pages(&sgx_dirty_page_list);
> +	/*
> +	 * Never expected to happen in a working driver. If it happens the bug
> +	 * is expected to be in the sanitization process, but successfully
> +	 * sanitized pages are still valid and driver can be used and most
> +	 * importantly debugged without issues. To put short, the global state
> +	 * of kernel is not corrupted so no reason to do any more complicated
> +	 * rollback.
> +	 */
> +	if (left_dirty)
> +		pr_err("%ld unsanitized pages\n", left_dirty);
                        %lu

>  
>  	while (!kthread_should_stop()) {
>  		if (try_to_freeze())
> -- 
> 2.37.2
> 

BR, Jarkko
