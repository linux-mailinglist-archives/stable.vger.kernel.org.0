Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02B223142A8
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 23:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231271AbhBHWMx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 17:12:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231167AbhBHWMn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 17:12:43 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA96BC061788
        for <stable@vger.kernel.org>; Mon,  8 Feb 2021 14:12:02 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id fa16so388676pjb.1
        for <stable@vger.kernel.org>; Mon, 08 Feb 2021 14:12:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=22MMalabtZ2RQbKXO0pIa+HsXMknjHt8lQOcrFaJITI=;
        b=BUPGvhj29ArCVqpTBBGTpjgjXRBPU4yITXWWaQ/rnmH7B15mgCUwXcg0YSXvF+Mdlq
         QbcA4xJcxwLVZb5j6sb/JgpqMTSmVFGWeF5rPv1+SIgr8Q7vXvw/EqGevklMk6dMV0l+
         LL3ZUZlKf/5KflbQYMcuu02koP9awXcAG5sJg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=22MMalabtZ2RQbKXO0pIa+HsXMknjHt8lQOcrFaJITI=;
        b=d76CVJKugyyWkKQcuYt0yoXI/t+S/8tkVl4fb8imHTfNF0R4lEzpMzg3toLv/Ss6/C
         0g23yQNssP1KUUT1oodqenC9lfgZlN7DQh8Rr9gy1GZhmoVUrrPmeqrVmkURjG/ccTms
         iX9SGE2WSn2oYD0SVPK+92ehtM+ZNXoYzwrcXsln56JXWu+u1a1Q4rJpGcPFKUPM//Rk
         f7cBP6QGUUfNjwWKpgOpAYlvdiPVtyE68lTAxsht6pC11wTZK3k4PMnhihIkEAWK1adK
         E+3/7LCVZsi+pEJhstUP0c9aF+Q0wALcyLVmieH4XLq2urjJrVx33eOQuT+SBBOGAj0X
         7Oag==
X-Gm-Message-State: AOAM533xREtQUlb0RvlAR0pe0xmYAyzr2w3CFvSszoe/O+BM8F6UMFjW
        X1R+C1hPZI8WyXjk1Ri1xu5r1A==
X-Google-Smtp-Source: ABdhPJwtaPVt/FqaLjFA4nw63Drtkit86I5h199UsYenko/Etc1SLxtreZ9TZGJBuA6rBs4JlCAyCw==
X-Received: by 2002:a17:903:3109:b029:e2:86d3:bec with SMTP id w9-20020a1709033109b02900e286d30becmr18493164plc.49.1612822322542;
        Mon, 08 Feb 2021 14:12:02 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id lr7sm247827pjb.56.2021.02.08.14.12.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 14:12:01 -0800 (PST)
Date:   Mon, 8 Feb 2021 14:12:00 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org,
        Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Lucas Stach <l.stach@pengutronix.de>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Cyrill Gorcunov <gorcunov@gmail.com>, stable@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [PATCH v3] kcmp: Support selection of SYS_kcmp without
 CHECKPOINT_RESTORE
Message-ID: <202102081411.73A442F17@keescook>
References: <20210205163752.11932-1-chris@chris-wilson.co.uk>
 <20210205220012.1983-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210205220012.1983-1-chris@chris-wilson.co.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 05, 2021 at 10:00:12PM +0000, Chris Wilson wrote:
> Userspace has discovered the functionality offered by SYS_kcmp and has
> started to depend upon it. In particular, Mesa uses SYS_kcmp for
> os_same_file_description() in order to identify when two fd (e.g. device
> or dmabuf) point to the same struct file. Since they depend on it for
> core functionality, lift SYS_kcmp out of the non-default
> CONFIG_CHECKPOINT_RESTORE into the selectable syscall category.
> 
> Rasmus Villemoes also pointed out that systemd uses SYS_kcmp to
> deduplicate the per-service file descriptor store.
> 
> Note that some distributions such as Ubuntu are already enabling
> CHECKPOINT_RESTORE in their configs and so, by extension, SYS_kcmp.
> 
> References: https://gitlab.freedesktop.org/drm/intel/-/issues/3046
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>

Thanks!

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> Cc: Kees Cook <keescook@chromium.org>
> Cc: Andy Lutomirski <luto@amacapital.net>
> Cc: Will Drewry <wad@chromium.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Dave Airlie <airlied@gmail.com>
> Cc: Daniel Vetter <daniel@ffwll.ch>
> Cc: Lucas Stach <l.stach@pengutronix.de>
> Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Cc: Cyrill Gorcunov <gorcunov@gmail.com>
> Cc: stable@vger.kernel.org
> Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch> # DRM depends on kcmp
> Acked-by: Rasmus Villemoes <linux@rasmusvillemoes.dk> # systemd uses kcmp
> 
> ---
> v2:
>   - Default n.
>   - Borrrow help message from man kcmp.
>   - Export get_epoll_tfile_raw_ptr() for CONFIG_KCMP
> v3:
>   - Select KCMP for CONFIG_DRM
> ---
>  drivers/gpu/drm/Kconfig                       |  3 +++
>  fs/eventpoll.c                                |  4 ++--
>  include/linux/eventpoll.h                     |  2 +-
>  init/Kconfig                                  | 11 +++++++++++
>  kernel/Makefile                               |  2 +-
>  tools/testing/selftests/seccomp/seccomp_bpf.c |  2 +-
>  6 files changed, 19 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
> index 0973f408d75f..af6c6d214d91 100644
> --- a/drivers/gpu/drm/Kconfig
> +++ b/drivers/gpu/drm/Kconfig
> @@ -15,6 +15,9 @@ menuconfig DRM
>  	select I2C_ALGOBIT
>  	select DMA_SHARED_BUFFER
>  	select SYNC_FILE
> +# gallium uses SYS_kcmp for os_same_file_description() to de-duplicate
> +# device and dmabuf fd. Let's make sure that is available for our userspace.
> +	select KCMP
>  	help
>  	  Kernel-level support for the Direct Rendering Infrastructure (DRI)
>  	  introduced in XFree86 4.0. If you say Y here, you need to select
> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> index a829af074eb5..3196474cbe24 100644
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -979,7 +979,7 @@ static struct epitem *ep_find(struct eventpoll *ep, struct file *file, int fd)
>  	return epir;
>  }
>  
> -#ifdef CONFIG_CHECKPOINT_RESTORE
> +#ifdef CONFIG_KCMP
>  static struct epitem *ep_find_tfd(struct eventpoll *ep, int tfd, unsigned long toff)
>  {
>  	struct rb_node *rbp;
> @@ -1021,7 +1021,7 @@ struct file *get_epoll_tfile_raw_ptr(struct file *file, int tfd,
>  
>  	return file_raw;
>  }
> -#endif /* CONFIG_CHECKPOINT_RESTORE */
> +#endif /* CONFIG_KCMP */
>  
>  /**
>   * Adds a new entry to the tail of the list in a lockless way, i.e.
> diff --git a/include/linux/eventpoll.h b/include/linux/eventpoll.h
> index 0350393465d4..593322c946e6 100644
> --- a/include/linux/eventpoll.h
> +++ b/include/linux/eventpoll.h
> @@ -18,7 +18,7 @@ struct file;
>  
>  #ifdef CONFIG_EPOLL
>  
> -#ifdef CONFIG_CHECKPOINT_RESTORE
> +#ifdef CONFIG_KCMP
>  struct file *get_epoll_tfile_raw_ptr(struct file *file, int tfd, unsigned long toff);
>  #endif
>  
> diff --git a/init/Kconfig b/init/Kconfig
> index b77c60f8b963..9cc7436b2f73 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1194,6 +1194,7 @@ endif # NAMESPACES
>  config CHECKPOINT_RESTORE
>  	bool "Checkpoint/restore support"
>  	select PROC_CHILDREN
> +	select KCMP
>  	default n
>  	help
>  	  Enables additional kernel features in a sake of checkpoint/restore.
> @@ -1737,6 +1738,16 @@ config ARCH_HAS_MEMBARRIER_CALLBACKS
>  config ARCH_HAS_MEMBARRIER_SYNC_CORE
>  	bool
>  
> +config KCMP
> +	bool "Enable kcmp() system call" if EXPERT
> +	help
> +	  Enable the kernel resource comparison system call. It provides
> +	  user-space with the ability to compare two processes to see if they
> +	  share a common resource, such as a file descriptor or even virtual
> +	  memory space.
> +
> +	  If unsure, say N.
> +
>  config RSEQ
>  	bool "Enable rseq() system call" if EXPERT
>  	default y
> diff --git a/kernel/Makefile b/kernel/Makefile
> index aa7368c7eabf..320f1f3941b7 100644
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -51,7 +51,7 @@ obj-y += livepatch/
>  obj-y += dma/
>  obj-y += entry/
>  
> -obj-$(CONFIG_CHECKPOINT_RESTORE) += kcmp.o
> +obj-$(CONFIG_KCMP) += kcmp.o
>  obj-$(CONFIG_FREEZER) += freezer.o
>  obj-$(CONFIG_PROFILING) += profile.o
>  obj-$(CONFIG_STACKTRACE) += stacktrace.o
> diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
> index 26c72f2b61b1..1b6c7d33c4ff 100644
> --- a/tools/testing/selftests/seccomp/seccomp_bpf.c
> +++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
> @@ -315,7 +315,7 @@ TEST(kcmp)
>  	ret = __filecmp(getpid(), getpid(), 1, 1);
>  	EXPECT_EQ(ret, 0);
>  	if (ret != 0 && errno == ENOSYS)
> -		SKIP(return, "Kernel does not support kcmp() (missing CONFIG_CHECKPOINT_RESTORE?)");
> +		SKIP(return, "Kernel does not support kcmp() (missing CONFIG_KCMP?)");
>  }
>  
>  TEST(mode_strict_support)
> -- 
> 2.20.1
> 

-- 
Kees Cook
