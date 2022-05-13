Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE975264FF
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 16:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381247AbiEMOoF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 10:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382823AbiEMOnQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 10:43:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C7E5606F0;
        Fri, 13 May 2022 07:41:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D72AFB8306A;
        Fri, 13 May 2022 14:41:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39EE5C34100;
        Fri, 13 May 2022 14:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652452859;
        bh=337024fQ3LPIArZ9dmlJabVRJtgllcWJldkd7K0Q3pk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G2NXrgQqZznRPT7rA43Qppg54WUGD/3aB09W7y593/95c4AF0ROOP6KsvxLFGdpTJ
         anvTXoo07fu3nUjwLTOhzpDYlCx+B5QrW8wv6749cDU6AA/E8dihzd8FLdzkaPx0hX
         nxxvq+BWvb5Xl3A+I4VjmyK5oSvqn5Kjv7xnqLgjLG/IgJUhtvuIgfpwcO3Gw7NS09
         TOh2fMvY6uttld0cRh7TfNfxGzqTNgzFdZKTcFe/v6RtKLJfmVhJcVdDpU4b/kDXjz
         m8B34dsXu8bzuu/IGv6g0USCapjaiyE4bIUTblOoD8mT012SkDD/97Li8eGCoaP+b7
         +KHCkhAM58F8w==
Date:   Fri, 13 May 2022 17:39:29 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Reinette Chatre <reinette.chatre@intel.com>
Cc:     dave.hansen@linux.intel.com, tglx@linutronix.de, bp@alien8.de,
        luto@kernel.org, mingo@redhat.com, linux-sgx@vger.kernel.org,
        x86@kernel.org, haitao.huang@intel.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH V3 5/5] x86/sgx: Ensure no data in PCMD page after
 truncate
Message-ID: <Yn5tod7LT96rGVHd@iki.fi>
References: <cover.1652389823.git.reinette.chatre@intel.com>
 <6495120fed43fafc1496d09dd23df922b9a32709.1652389823.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6495120fed43fafc1496d09dd23df922b9a32709.1652389823.git.reinette.chatre@intel.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 12, 2022 at 02:51:01PM -0700, Reinette Chatre wrote:
> A PCMD (Paging Crypto MetaData) page contains the PCMD
> structures of enclave pages that have been encrypted and
> moved to the shmem backing store. When all enclave pages
> sharing a PCMD page are loaded in the enclave, there is no
> need for the PCMD page and it can be truncated from the
> backing store.
> 
> A few issues appeared around the truncation of PCMD pages. The
> known issues have been addressed but the PCMD handling code could
> be made more robust by loudly complaining if any new issue appears
> in this area.
> 
> Add a check that will complain with a warning if the PCMD page is not
> actually empty after it has been truncated. There should never be data
> in the PCMD page at this point since it is was just checked to be empty
> and truncated with enclave mutex held and is updated with the
> enclave mutex held.
> 
> Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
> Tested-by: Haitao Huang <haitao.huang@intel.com>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
> Changes since V2:
> - Change WARN_ON_ONCE() to pr_warn(). (Jarkko).
> - Add Haitao's Tested-by tag.
> 
> Changes since RFC v1:
> - New patch.
> 
>  arch/x86/kernel/cpu/sgx/encl.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> index 243f3bd78145..3c24e6124d95 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -187,12 +187,20 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
>  	kunmap_atomic(pcmd_page);
>  	kunmap_atomic((void *)(unsigned long)pginfo.contents);
>  
> +	get_page(b.pcmd);
>  	sgx_encl_put_backing(&b);
>  
>  	sgx_encl_truncate_backing_page(encl, page_index);
>  
> -	if (pcmd_page_empty && !reclaimer_writing_to_pcmd(encl, pcmd_first_page))
> +	if (pcmd_page_empty && !reclaimer_writing_to_pcmd(encl, pcmd_first_page)) {
>  		sgx_encl_truncate_backing_page(encl, PFN_DOWN(page_pcmd_off));
> +		pcmd_page = kmap_atomic(b.pcmd);
> +		if (memchr_inv(pcmd_page, 0, PAGE_SIZE))
> +			pr_warn("PCMD page not empty after truncate.\n");
> +		kunmap_atomic(pcmd_page);
> +	}
> +
> +	put_page(b.pcmd);
>  
>  	return ret;
>  }
> -- 
> 2.25.1
> 

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
