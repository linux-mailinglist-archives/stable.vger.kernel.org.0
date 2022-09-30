Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E33685F081F
	for <lists+stable@lfdr.de>; Fri, 30 Sep 2022 11:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231570AbiI3J75 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Sep 2022 05:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231556AbiI3J7r (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Sep 2022 05:59:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD964222AC;
        Fri, 30 Sep 2022 02:59:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FE0B6205F;
        Fri, 30 Sep 2022 09:59:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B55FAC433D6;
        Fri, 30 Sep 2022 09:59:39 +0000 (UTC)
Date:   Fri, 30 Sep 2022 10:59:36 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Carlos Llamas <cmllamas@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.com>,
        Christian Brauner <brauner@kernel.org>, linux-mm@kvack.org,
        bpf@vger.kernel.org, kernel-team@android.com,
        Liam Howlett <liam.howlett@oracle.com>,
        Suren Baghdasaryan <surenb@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/mmap: undo ->mmap() when arch_validate_flags() fails
Message-ID: <Yza+CFDEl938+1Zf@arm.com>
References: <20220930003844.1210987-1-cmllamas@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220930003844.1210987-1-cmllamas@google.com>
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 30, 2022 at 12:38:43AM +0000, Carlos Llamas wrote:
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 9d780f415be3..36c08e2c78da 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1797,7 +1797,7 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
>  	if (!arch_validate_flags(vma->vm_flags)) {
>  		error = -EINVAL;
>  		if (file)
> -			goto unmap_and_free_vma;
> +			goto close_and_free_vma;
>  		else
>  			goto free_vma;
>  	}
> @@ -1844,6 +1844,9 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
>  
>  	return addr;
>  
> +close_and_free_vma:
> +	if (vma->vm_ops && vma->vm_ops->close)
> +		vma->vm_ops->close(vma);
>  unmap_and_free_vma:
>  	fput(vma->vm_file);
>  	vma->vm_file = NULL;

The fix looks right to me but I'm not an mm expert. FWIW:

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
