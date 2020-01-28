Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5D014AD2E
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 01:25:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbgA1AZ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jan 2020 19:25:29 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:37922 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbgA1AZ2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jan 2020 19:25:28 -0500
Received: by mail-pl1-f196.google.com with SMTP id t6so4387512plj.5
        for <stable@vger.kernel.org>; Mon, 27 Jan 2020 16:25:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=V+BSVtOjuS68/b2v0f7OT648Jg3O+3AV7imEPIWfZyw=;
        b=EUj614/He5DI6FobTl5392ZqO7A6CzV7kdXT1PuB3EGx3J+GPDqLfqgd7QXlznNm4L
         y68b4WVm1dxVr+tnmypR/Z01rMwkubTzy9Vx1vFZQafxAHSbcHtK7iIENoEBTbXwULWv
         mkg8C12/yJRbY/G32Fwa4JEd4z8MXuoel0JtM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=V+BSVtOjuS68/b2v0f7OT648Jg3O+3AV7imEPIWfZyw=;
        b=NedXFW+/vgTfJT0MhpfXvXmkihx8WcIVhVcEZ6WoFAzdc6nPIi6uLGjVLkh/ZRXgwj
         whXNPA5A+E4C+P/8l8OwWagHunmmfs5Uk3JGPXLoOHjRWJuzupOVxj+fJ9hmEEH3vtrC
         tadIcSSqaJ5ruAZMdQos4zD+3v70lIDCjuiUBXyhPQy1YMp8k4sWT7bdu47XB1wBf+3X
         4hwrL0j/Vs1h2x/Sg2YyOje8otyTciLHTlXWy7mp4xDSnO0ST7cLHXfkazXhiUUVD0Xf
         pNzE2vqLmR61lbSIMlL1rWvPvNOwUyeVFyS2uzjJmDNc7uIuZmd4p7Ig8CK6juZypD0h
         ps3Q==
X-Gm-Message-State: APjAAAUE0WifNvKJoQ1TyqOPpBZWTnpuZUnB+Q/zoOKxrjAukE3mXec8
        n9uzrCgQDTG0H1EuF5N58MhPuw==
X-Google-Smtp-Source: APXvYqxjSyhkagCwOGrSkkXQiY8CYWhpKHQ6EdsasKmr4x2185dIVpT5C1eC06D1ybeI/kMaN6i9Rw==
X-Received: by 2002:a17:902:7d8c:: with SMTP id a12mr19193277plm.47.1580171128071;
        Mon, 27 Jan 2020 16:25:28 -0800 (PST)
Received: from localhost ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id u20sm17009658pgf.29.2020.01.27.16.25.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 16:25:27 -0800 (PST)
Date:   Mon, 27 Jan 2020 19:25:26 -0500
From:   Joel Fernandes <joel@joelfernandes.org>
To:     Todd Kjos <tkjos@google.com>
Cc:     surenb@google.com, gregkh@linuxfoundation.org, arve@android.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        maco@google.com, kernel-team@android.com,
        Jann Horn <jannh@google.com>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] staging: android: ashmem: Disallow ashmem memory from
 being remapped
Message-ID: <20200128002526.GC175575@google.com>
References: <20200127235616.48920-1-tkjos@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200127235616.48920-1-tkjos@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 27, 2020 at 03:56:16PM -0800, Todd Kjos wrote:
> From: Suren Baghdasaryan <surenb@google.com>
> 
> When ashmem file is mmapped, the resulting vma->vm_file points to the
> backing shmem file with the generic fops that do not check ashmem
> permissions like fops of ashmem do. If an mremap is done on the ashmem
> region, then the permission checks will be skipped. Fix that by disallowing
> mapping operation on the backing shmem file.

Reviewed-by: Joel Fernandes (Google) <joel@joelfernandes.org>

thanks!

 - Joel

> 
> Reported-by: Jann Horn <jannh@google.com>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> Cc: stable <stable@vger.kernel.org> # 4.4,4.9,4.14,4.18,5.4
> Signed-off-by: Todd Kjos <tkjos@google.com>
> ---
>  drivers/staging/android/ashmem.c | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
> 
> v2: update commit message as suggested by joelaf@google.com.
> 
> diff --git a/drivers/staging/android/ashmem.c b/drivers/staging/android/ashmem.c
> index 74d497d39c5a..c6695354b123 100644
> --- a/drivers/staging/android/ashmem.c
> +++ b/drivers/staging/android/ashmem.c
> @@ -351,8 +351,23 @@ static inline vm_flags_t calc_vm_may_flags(unsigned long prot)
>  	       _calc_vm_trans(prot, PROT_EXEC,  VM_MAYEXEC);
>  }
>  
> +static int ashmem_vmfile_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +	/* do not allow to mmap ashmem backing shmem file directly */
> +	return -EPERM;
> +}
> +
> +static unsigned long
> +ashmem_vmfile_get_unmapped_area(struct file *file, unsigned long addr,
> +				unsigned long len, unsigned long pgoff,
> +				unsigned long flags)
> +{
> +	return current->mm->get_unmapped_area(file, addr, len, pgoff, flags);
> +}
> +
>  static int ashmem_mmap(struct file *file, struct vm_area_struct *vma)
>  {
> +	static struct file_operations vmfile_fops;
>  	struct ashmem_area *asma = file->private_data;
>  	int ret = 0;
>  
> @@ -393,6 +408,19 @@ static int ashmem_mmap(struct file *file, struct vm_area_struct *vma)
>  		}
>  		vmfile->f_mode |= FMODE_LSEEK;
>  		asma->file = vmfile;
> +		/*
> +		 * override mmap operation of the vmfile so that it can't be
> +		 * remapped which would lead to creation of a new vma with no
> +		 * asma permission checks. Have to override get_unmapped_area
> +		 * as well to prevent VM_BUG_ON check for f_ops modification.
> +		 */
> +		if (!vmfile_fops.mmap) {
> +			vmfile_fops = *vmfile->f_op;
> +			vmfile_fops.mmap = ashmem_vmfile_mmap;
> +			vmfile_fops.get_unmapped_area =
> +					ashmem_vmfile_get_unmapped_area;
> +		}
> +		vmfile->f_op = &vmfile_fops;
>  	}
>  	get_file(asma->file);
>  
> -- 
> 2.25.0.341.g760bfbb309-goog
> 
