Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0B833C554
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 19:14:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbhCOSOQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 14:14:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:49746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231357AbhCOSNo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 14:13:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B27F264F01;
        Mon, 15 Mar 2021 18:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615832024;
        bh=U+aKejYtJBufoVgMSdu8hu3ay4ZDWIRJ7Q4qXJs9HuM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RUaJd9NsSeOH6OvmBdRsty3jmBOxRTbIQ6/8AjMeLD9V3drpLpekIxT+6yrVG0q4s
         23JekvLfdiuTQx+xeVBZ5AShLR1wRZsTJ6B0KFceooVLlZ7K9gwb+2SALIOk7kVFwQ
         9lAauGHpRueNH23tCNwBIow2Qv9dGXAUAUeZLqhq6iC4Wgg1tzNWdhV0xyXtHEBSyt
         v0s0qnvhUoXnqQmnSt9G+KxOpyuR38moA69UNDNXK9+zxZ1uQd+KEXj/GzuTO/OKYQ
         Dcq6mNguANwu2EMf9zhvadu2uJjf6UarpgzEK5SZ1plY1IhTH7Kc6mGKuC+rmMlyIv
         3BZhMjlFDsphw==
Date:   Mon, 15 Mar 2021 11:13:39 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Peter Oberparleiter <oberpar@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Fangrui Song <maskray@google.com>,
        Prasad Sodagudi <psodagud@quicinc.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] gcov: fix clang-11+ support
Message-ID: <20210315181339.bzs6t7aonlaavggw@archlinux-ax161>
References: <20210312220518.rz6cjh33bkwaumzz@archlinux-ax161>
 <20210312224132.3413602-1-ndesaulniers@google.com>
 <20210312224132.3413602-2-ndesaulniers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210312224132.3413602-2-ndesaulniers@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 12, 2021 at 02:41:31PM -0800, Nick Desaulniers wrote:
> LLVM changed the expected function signatures for llvm_gcda_start_file()
> and llvm_gcda_emit_function() in the clang-11 release. Users of clang-11
> or newer may have noticed their kernels failing to boot due to a panic
> when enabling CONFIG_GCOV_KERNEL=y +CONFIG_GCOV_PROFILE_ALL=y.  Fix up
> the function signatures so calling these functions doesn't panic the
> kernel.
> 
> Link: https://reviews.llvm.org/rGcdd683b516d147925212724b09ec6fb792a40041
> Link: https://reviews.llvm.org/rG13a633b438b6500ecad9e4f936ebadf3411d0f44
> Cc: stable@vger.kernel.org # 5.4
> Reported-by: Prasad Sodagudi <psodagud@quicinc.com>
> Suggested-by: Nathan Chancellor <nathan@kernel.org>
> Reviewed-by: Fangrui Song <maskray@google.com>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> Tested-by: Nathan Chancellor <nathan@kernel.org>

Reviewed-by: Nathan Chancellor <nathan@kernel.org>

> ---
> Changes V1 -> V2:
> * Use CONFIG_CLANG_VERSION instead of __clang_major__.
> * Pick up and retain Suggested-by, Tested-by, and Reviewed-by tags.
> * Drop note from commit message about `git blame`; I did what was
>   sugguested in V1, but it still looks to git like I wrote those
>   functions. Oh well.
> 
>  kernel/gcov/clang.c | 69 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 69 insertions(+)
> 
> diff --git a/kernel/gcov/clang.c b/kernel/gcov/clang.c
> index c94b820a1b62..8743150db2ac 100644
> --- a/kernel/gcov/clang.c
> +++ b/kernel/gcov/clang.c
> @@ -75,7 +75,9 @@ struct gcov_fn_info {
>  
>  	u32 num_counters;
>  	u64 *counters;
> +#if CONFIG_CLANG_VERSION < 110000
>  	const char *function_name;
> +#endif
>  };
>  
>  static struct gcov_info *current_info;
> @@ -105,6 +107,7 @@ void llvm_gcov_init(llvm_gcov_callback writeout, llvm_gcov_callback flush)
>  }
>  EXPORT_SYMBOL(llvm_gcov_init);
>  
> +#if CONFIG_CLANG_VERSION < 110000
>  void llvm_gcda_start_file(const char *orig_filename, const char version[4],
>  		u32 checksum)
>  {
> @@ -113,7 +116,17 @@ void llvm_gcda_start_file(const char *orig_filename, const char version[4],
>  	current_info->checksum = checksum;
>  }
>  EXPORT_SYMBOL(llvm_gcda_start_file);
> +#else
> +void llvm_gcda_start_file(const char *orig_filename, u32 version, u32 checksum)
> +{
> +	current_info->filename = orig_filename;
> +	current_info->version = version;
> +	current_info->checksum = checksum;
> +}
> +EXPORT_SYMBOL(llvm_gcda_start_file);
> +#endif
>  
> +#if CONFIG_CLANG_VERSION < 110000
>  void llvm_gcda_emit_function(u32 ident, const char *function_name,
>  		u32 func_checksum, u8 use_extra_checksum, u32 cfg_checksum)
>  {
> @@ -133,6 +146,24 @@ void llvm_gcda_emit_function(u32 ident, const char *function_name,
>  	list_add_tail(&info->head, &current_info->functions);
>  }
>  EXPORT_SYMBOL(llvm_gcda_emit_function);
> +#else
> +void llvm_gcda_emit_function(u32 ident, u32 func_checksum,
> +		u8 use_extra_checksum, u32 cfg_checksum)
> +{
> +	struct gcov_fn_info *info = kzalloc(sizeof(*info), GFP_KERNEL);
> +
> +	if (!info)
> +		return;
> +
> +	INIT_LIST_HEAD(&info->head);
> +	info->ident = ident;
> +	info->checksum = func_checksum;
> +	info->use_extra_checksum = use_extra_checksum;
> +	info->cfg_checksum = cfg_checksum;
> +	list_add_tail(&info->head, &current_info->functions);
> +}
> +EXPORT_SYMBOL(llvm_gcda_emit_function);
> +#endif
>  
>  void llvm_gcda_emit_arcs(u32 num_counters, u64 *counters)
>  {
> @@ -295,6 +326,7 @@ void gcov_info_add(struct gcov_info *dst, struct gcov_info *src)
>  	}
>  }
>  
> +#if CONFIG_CLANG_VERSION < 110000
>  static struct gcov_fn_info *gcov_fn_info_dup(struct gcov_fn_info *fn)
>  {
>  	size_t cv_size; /* counter values size */
> @@ -322,6 +354,28 @@ static struct gcov_fn_info *gcov_fn_info_dup(struct gcov_fn_info *fn)
>  	kfree(fn_dup);
>  	return NULL;
>  }
> +#else
> +static struct gcov_fn_info *gcov_fn_info_dup(struct gcov_fn_info *fn)
> +{
> +	size_t cv_size; /* counter values size */
> +	struct gcov_fn_info *fn_dup = kmemdup(fn, sizeof(*fn),
> +			GFP_KERNEL);
> +	if (!fn_dup)
> +		return NULL;
> +	INIT_LIST_HEAD(&fn_dup->head);
> +
> +	cv_size = fn->num_counters * sizeof(fn->counters[0]);
> +	fn_dup->counters = vmalloc(cv_size);
> +	if (!fn_dup->counters) {
> +		kfree(fn_dup);
> +		return NULL;
> +	}
> +
> +	memcpy(fn_dup->counters, fn->counters, cv_size);
> +
> +	return fn_dup;
> +}
> +#endif
>  
>  /**
>   * gcov_info_dup - duplicate profiling data set
> @@ -362,6 +416,7 @@ struct gcov_info *gcov_info_dup(struct gcov_info *info)
>   * gcov_info_free - release memory for profiling data set duplicate
>   * @info: profiling data set duplicate to free
>   */
> +#if CONFIG_CLANG_VERSION < 110000
>  void gcov_info_free(struct gcov_info *info)
>  {
>  	struct gcov_fn_info *fn, *tmp;
> @@ -375,6 +430,20 @@ void gcov_info_free(struct gcov_info *info)
>  	kfree(info->filename);
>  	kfree(info);
>  }
> +#else
> +void gcov_info_free(struct gcov_info *info)
> +{
> +	struct gcov_fn_info *fn, *tmp;
> +
> +	list_for_each_entry_safe(fn, tmp, &info->functions, head) {
> +		vfree(fn->counters);
> +		list_del(&fn->head);
> +		kfree(fn);
> +	}
> +	kfree(info->filename);
> +	kfree(info);
> +}
> +#endif
>  
>  #define ITER_STRIDE	PAGE_SIZE
>  
> 
> base-commit: f78d76e72a4671ea52d12752d92077788b4f5d50
> -- 
> 2.31.0.rc2.261.g7f71774620-goog
> 
