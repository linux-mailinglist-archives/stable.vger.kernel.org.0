Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4075F43B9
	for <lists+stable@lfdr.de>; Tue,  4 Oct 2022 14:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbiJDM5r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Oct 2022 08:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiJDM5Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Oct 2022 08:57:24 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5866E5F9B7;
        Tue,  4 Oct 2022 05:54:03 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id ay36so8827082wmb.0;
        Tue, 04 Oct 2022 05:54:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=hlDBjgsrtiAB20EmVK+DqfPkxi/fwq2hkeX3Gk/vlHA=;
        b=NC2sElPURU94A+oZT2BzfOw2kmYw3KRFHsAnXhb22SKXLi3zTGbXxZ62puTz8/F1Fb
         Nlb98uIqmDLJycbNBoyhGYKudcng5U9JyJ4G+V/ys/U9uCqwiKRXrGHitNaInKvFYa5F
         ZhRk/FxclhHt5Zp7aT5sjisqPIRyD0m6Xbx4FPLu0OGipVJdNiRY2IyGVMKcuCewHy/r
         Xn9jJ7n7ZqQSZF5mXgLE9nyAJg0liZtWgFerVjYF9hYLVOuuZYfRAR/jCEcsPRPvfPTD
         Ort5nw8wcLiHX1EfKlB7ikt07Er56GwiHDpIIhmObSpoU2FvP5m4Zd9DHlU6mWyy6aZo
         Da/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=hlDBjgsrtiAB20EmVK+DqfPkxi/fwq2hkeX3Gk/vlHA=;
        b=VfA/f4FNlFLRKIwfe9Cs1Aod7FdpdwJx+YNlQf8OjOhGbyr/ZBVo4+9yuHALBz9Gy9
         mbkTUhK+MIN3m6+OCig6T5XcuCO+7A4Pe9GCwAtwF8KRLVsS7YTs3f0811dZIEXBmbo3
         efAxTNnICTgyJD7uGhBuFJ+VAvFAKFPQI3Leo7fftFn4kF3jRdxfHEpX01du3nTtPPiN
         7wdQOZ3NL893lodbyKEuxCMyHRp+waZ7xPyVLaYTs1MQaA2Bkc4bvf1Uq+2gxZjgyelI
         xfHmqSV5D98UBorlc3rzGBnZzQLwLY0MowbYfsK3K0tbWs0XXba+B8qxPC9cGJxyZ6GT
         rSdg==
X-Gm-Message-State: ACrzQf1uoxXe/AdKCDyn+ZQGgdmMH1V2su1Kq/snQ8NyQhTX7EsZGYz4
        aDgh/8xXq5JQCRchbCG7FhPi26vhxw==
X-Google-Smtp-Source: AMsMyM6gBzKWs6xHtQ1ha1QDGnLvIWXKrRpH5PfEVMSlaS5p+0i7Z7ps44ZaOrvVJrX/ZXjW+UEGCw==
X-Received: by 2002:a7b:cb91:0:b0:3b4:75b9:5a4b with SMTP id m17-20020a7bcb91000000b003b475b95a4bmr9861463wmi.33.1664888023164;
        Tue, 04 Oct 2022 05:53:43 -0700 (PDT)
Received: from localhost.localdomain ([46.53.250.140])
        by smtp.gmail.com with ESMTPSA id m38-20020a05600c3b2600b003b4ff30e566sm4017998wms.3.2022.10.04.05.53.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Oct 2022 05:53:42 -0700 (PDT)
Date:   Tue, 4 Oct 2022 15:53:41 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     sethjenkins@google.com
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm: /proc/pid/smaps_rollup: fix no vma's null-deref
Message-ID: <Yzws1f1ghsifXvGu@localhost.localdomain>
References: <20221003224531.1930646-1-sethjenkins@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221003224531.1930646-1-sethjenkins@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 03, 2022 at 06:45:31PM -0400, FirstName LastName wrote:
> From: Seth Jenkins <sethjenkins@google.com>
> 
> Commit 258f669e7e88 ("mm: /proc/pid/smaps_rollup: convert to single value
> seq_file") introduced a null-deref if there are no vma's in the task in
> show_smaps_rollup.
> 
> Fixes: 258f669e7e88 ("mm: /proc/pid/smaps_rollup: convert to single value seq_file")
> Cc: stable@vger.kernel.org
> Signed-off-by: Seth Jenkins <sethjenkins@google.com>

> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -969,7 +969,7 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
>  		vma = vma->vm_next;
>  	}
>  
> -	show_vma_header_prefix(m, priv->mm->mmap->vm_start,
> +	show_vma_header_prefix(m, priv->mm->mmap ? priv->mm->mmap->vm_start : 0,
>  			       last_vma_end, 0, 0, 0, 0);
>  	seq_pad(m, ' ');
>  	seq_puts(m, "[rollup]\n");

Reviewed-by: Alexey Dobriyan <adobriyan@gmail.com>
Tested-by: Alexey Dobriyan <adobriyan@gmail.com>

Now I know how to create stable process without address space.
