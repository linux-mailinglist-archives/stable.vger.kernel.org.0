Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B69335752E
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 21:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348936AbhDGTvp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 15:51:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:45784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345736AbhDGTvp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Apr 2021 15:51:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D9AB610A4;
        Wed,  7 Apr 2021 19:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617825095;
        bh=VzFA9I2C0CYUWhztVXg4L5zMRzkxsAqEzsg1FbeHjjU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aL3N2w7MZLtMl+NYyZDbCNNJoBFrGOpFxpNau/HFm5Jbj01weYZsw8IjKwcPKXuZi
         0XqLHEnELZCOpIFbiFolJ/5M6UEGoRgMR52dhbFTZ65CqGgaW9x4aCMvYHRgHoUyHq
         lTaCo4X+4qIsKh/pQ6KekQ+g1ESE7Zg9tV0uC21W3pDwxqC1zJXjclCrt1AEHHOlRd
         P5e5a8EEDRk04wNysHoN1p5za4ouGER+JMESJ1Ynz2VEkXPAwzSiryXfJem3OcT6K+
         LkByX7+qAEQdt+/1qSp/m8WoQExPFglnAlyq2LlJM9vRFXSgETNnmtWrIb9VPEWjok
         tJ5baXOsxknvA==
Date:   Wed, 7 Apr 2021 12:51:30 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Peter Oberparleiter <oberpar@linux.ibm.com>,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Fangrui Song <maskray@google.com>,
        Prasad Sodagudi <psodagud@quicinc.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] gcov: re-fix clang-11+ support
Message-ID: <20210407195130.bacppddzyjs56qxi@archlinux-ax161>
References: <20210407185456.41943-1-ndesaulniers@google.com>
 <20210407185456.41943-2-ndesaulniers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210407185456.41943-2-ndesaulniers@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 07, 2021 at 11:54:55AM -0700, Nick Desaulniers wrote:
> LLVM changed the expected function signature for
> llvm_gcda_emit_function() in the clang-11 release.  Users of clang-11 or
> newer may have noticed their kernels producing invalid coverage
> information:
> 
> $ llvm-cov gcov -a -c -u -f -b <input>.gcda -- gcno=<input>.gcno
> 1 <func>: checksum mismatch, \
>   (<lineno chksum A>, <cfg chksum B>) != (<lineno chksum A>, <cfg chksum C>)
> 2 Invalid .gcda File!
> ...
> 
> Fix up the function signatures so calling this function interprets its
> parameters correctly and computes the correct cfg checksum. In
> particular, in clang-11, the additional checksum is no longer optional.
> 
> Link: https://reviews.llvm.org/rG25544ce2df0daa4304c07e64b9c8b0f7df60c11d
> Cc: stable@vger.kernel.org #5.4+
> Reported-by: Prasad Sodagudi <psodagud@quicinc.com>
> Tested-by: Prasad Sodagudi <psodagud@quicinc.com>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>

Reviewed-by: Nathan Chancellor <nathan@kernel.org>

> ---
>  kernel/gcov/clang.c | 38 +++++++++++++++++++++++++++++++++-----
>  1 file changed, 33 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/gcov/clang.c b/kernel/gcov/clang.c
> index d41f5ecda9db..1747204541bf 100644
> --- a/kernel/gcov/clang.c
> +++ b/kernel/gcov/clang.c
> @@ -69,7 +69,9 @@ struct gcov_fn_info {
>  
>  	u32 ident;
>  	u32 checksum;
> +#if CONFIG_CLANG_VERSION < 110000
>  	u8 use_extra_checksum;
> +#endif
>  	u32 cfg_checksum;
>  
>  	u32 num_counters;
> @@ -111,6 +113,7 @@ void llvm_gcda_start_file(const char *orig_filename, u32 version, u32 checksum)
>  }
>  EXPORT_SYMBOL(llvm_gcda_start_file);
>  
> +#if CONFIG_CLANG_VERSION < 110000
>  void llvm_gcda_emit_function(u32 ident, u32 func_checksum,
>  		u8 use_extra_checksum, u32 cfg_checksum)
>  {
> @@ -126,6 +129,21 @@ void llvm_gcda_emit_function(u32 ident, u32 func_checksum,
>  	info->cfg_checksum = cfg_checksum;
>  	list_add_tail(&info->head, &current_info->functions);
>  }
> +#else
> +void llvm_gcda_emit_function(u32 ident, u32 func_checksum, u32 cfg_checksum)
> +{
> +	struct gcov_fn_info *info = kzalloc(sizeof(*info), GFP_KERNEL);
> +
> +	if (!info)
> +		return;
> +
> +	INIT_LIST_HEAD(&info->head);
> +	info->ident = ident;
> +	info->checksum = func_checksum;
> +	info->cfg_checksum = cfg_checksum;
> +	list_add_tail(&info->head, &current_info->functions);
> +}
> +#endif
>  EXPORT_SYMBOL(llvm_gcda_emit_function);
>  
>  void llvm_gcda_emit_arcs(u32 num_counters, u64 *counters)
> @@ -256,11 +274,16 @@ int gcov_info_is_compatible(struct gcov_info *info1, struct gcov_info *info2)
>  		!list_is_last(&fn_ptr2->head, &info2->functions)) {
>  		if (fn_ptr1->checksum != fn_ptr2->checksum)
>  			return false;
> +#if CONFIG_CLANG_VERSION < 110000
>  		if (fn_ptr1->use_extra_checksum != fn_ptr2->use_extra_checksum)
>  			return false;
>  		if (fn_ptr1->use_extra_checksum &&
>  			fn_ptr1->cfg_checksum != fn_ptr2->cfg_checksum)
>  			return false;
> +#else
> +		if (fn_ptr1->cfg_checksum != fn_ptr2->cfg_checksum)
> +			return false;
> +#endif
>  		fn_ptr1 = list_next_entry(fn_ptr1, head);
>  		fn_ptr2 = list_next_entry(fn_ptr2, head);
>  	}
> @@ -378,17 +401,22 @@ size_t convert_to_gcda(char *buffer, struct gcov_info *info)
>  
>  	list_for_each_entry(fi_ptr, &info->functions, head) {
>  		u32 i;
> -		u32 len = 2;
> -
> -		if (fi_ptr->use_extra_checksum)
> -			len++;
>  
>  		pos += store_gcov_u32(buffer, pos, GCOV_TAG_FUNCTION);
> -		pos += store_gcov_u32(buffer, pos, len);
> +#if CONFIG_CLANG_VERSION < 110000
> +		pos += store_gcov_u32(buffer, pos,
> +			fi_ptr->use_extra_checksum ? 3 : 2);
> +#else
> +		pos += store_gcov_u32(buffer, pos, 3);
> +#endif
>  		pos += store_gcov_u32(buffer, pos, fi_ptr->ident);
>  		pos += store_gcov_u32(buffer, pos, fi_ptr->checksum);
> +#if CONFIG_CLANG_VERSION < 110000
>  		if (fi_ptr->use_extra_checksum)
>  			pos += store_gcov_u32(buffer, pos, fi_ptr->cfg_checksum);
> +#else
> +		pos += store_gcov_u32(buffer, pos, fi_ptr->cfg_checksum);
> +#endif
>  
>  		pos += store_gcov_u32(buffer, pos, GCOV_TAG_COUNTER_BASE);
>  		pos += store_gcov_u32(buffer, pos, fi_ptr->num_counters * 2);
> -- 
> 2.31.1.295.g9ea45b61b8-goog
> 
