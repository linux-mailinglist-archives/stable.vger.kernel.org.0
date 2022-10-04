Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB8B45F495E
	for <lists+stable@lfdr.de>; Tue,  4 Oct 2022 20:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbiJDSqZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Oct 2022 14:46:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiJDSqY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Oct 2022 14:46:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 124AC69F5D;
        Tue,  4 Oct 2022 11:46:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AAD1B614D3;
        Tue,  4 Oct 2022 18:46:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDB27C433C1;
        Tue,  4 Oct 2022 18:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664909183;
        bh=GecLqW4Hs2snJC3yF9KcRMx95IwFQlNqrAwVphvfFhc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=xF3ghwHRQJqR6Zh3taLN6d/wH6X9IZf9yQx5gux6OHXvkzwZ2o//WphkWLiYOOmY6
         Wk0VGVljcTCWJCZJ9NEjgCbqx/KoTNmARJqSuX/Z+Rhi/g5G4KjQHD3sTwVTaMEwU/
         J6YYIXh2rKyeCqrdUI5ovDIU8TONyLhNStAUPnGI=
Date:   Tue, 4 Oct 2022 11:46:21 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     FirstName LastName <sethjenkins@google.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm: /proc/pid/smaps_rollup: fix no vma's null-deref
Message-Id: <20221004114621.7b539d2c3618b25037c4f2d0@linux-foundation.org>
In-Reply-To: <20221003224531.1930646-1-sethjenkins@google.com>
References: <20221003224531.1930646-1-sethjenkins@google.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon,  3 Oct 2022 18:45:31 -0400 FirstName LastName <sethjenkins@google.com> wrote:

> From: Seth Jenkins <sethjenkins@google.com>
> 
> Commit 258f669e7e88 ("mm: /proc/pid/smaps_rollup: convert to single value
> seq_file") introduced a null-deref if there are no vma's in the task in
> show_smaps_rollup.
> 
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

The current mm tree is very different here.  In fact the bug might not
exist any more.  Please take a look at the mm-stable branch at
git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm?

If no fixes are needed in mm-stable then I guess the process is to
propose this patch to the stable tree maintainers.

