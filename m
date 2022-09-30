Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC505F1636
	for <lists+stable@lfdr.de>; Sat,  1 Oct 2022 00:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231233AbiI3We0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Sep 2022 18:34:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbiI3We0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Sep 2022 18:34:26 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D92117420E;
        Fri, 30 Sep 2022 15:34:24 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id dv25so11771768ejb.12;
        Fri, 30 Sep 2022 15:34:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7eVHcRj7bOTZCSoAUca2KGtBBs0g8lofOLyuo3DNi08=;
        b=OWwpfDo6nJkLj4c8oYWeKltUAPO4XgrAWv5U21zYbvxXgNBnsly/xqgtAcH6HhHyJN
         vqBPJy/094FFPg7DCLf+lmx2L3O8IHvFpy7X4hKfGJlgCFTdhSOwXv5v/1A+a2GxqbNd
         qdeLPj9oLCE2DHblUdargmzdWwfH+FyQN8U3ncL+KvcyWP9sp2DT4i9gfNCh0Gb1pzdg
         STOT/gBd3INNdDH6ml/3n0OpMEK4yClvJzTrft4YqX/Mmux+lH7AII5rAP8hK8S4hosM
         bH5DC06p9s4vNSKvmp+mvtQ+FSb96Pakn21GBFqGpneG+BpIHRqVOy0rxLl02wVB+bWE
         n9fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7eVHcRj7bOTZCSoAUca2KGtBBs0g8lofOLyuo3DNi08=;
        b=27pPZqOhMeZBthOu0SJ426jhOs1/AjTha/0GsyUxrKM+7h1p7Osqdm6kSWaryosmBu
         toos7zIT3HhMFve13SpjiOfDSLcPpZ6RkFr9T5brXjs7YnY9Nd5V4VGfEtwKDhrSHe2q
         Iwxow0d0DANDgPOV+mQLmIdK75PAluimG42H6VWdP+6J6MrH2R18w/VHou8OmMn4ud6m
         RYrIcpTIdxQcfVVnn9Js/gaPtGCMaBl7T2WmSDN69H1pFzp7hv7i8GcfavtvbRRkjWqg
         URG7WWp59MrBHW2llXj0Q7ZhVUNnxFdZ1EIM5W4WCXvl35ZUZPnsF3tYgTyGc8Uhn4au
         RIhA==
X-Gm-Message-State: ACrzQf1cinqYb5PYHfWsUuPFtAvCMvgA4AmWSPhTh+BCfGrgESndoOB+
        sbkR9FNqfi/VMM9zYvRFO3GsFMk36c72BeGHQLU=
X-Google-Smtp-Source: AMsMyM5oLkCTD4Mgre7YQ5XEM/Vy8tcOUer5mjeC7MxutJyVNVlaxAGdlZ1ZTKYuy0vKQfNQitRS91hfcc157zmBbOg=
X-Received: by 2002:a17:907:984:b0:77f:4d95:9e2f with SMTP id
 bf4-20020a170907098400b0077f4d959e2fmr8032846ejc.176.1664577262903; Fri, 30
 Sep 2022 15:34:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220930003844.1210987-1-cmllamas@google.com>
In-Reply-To: <20220930003844.1210987-1-cmllamas@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 30 Sep 2022 15:34:10 -0700
Message-ID: <CAEf4BzZC=NAT9-SCWzBkAGhYusZHokhKBQrMNSDuTWfZnr_B6A@mail.gmail.com>
Subject: Re: [PATCH] mm/mmap: undo ->mmap() when arch_validate_flags() fails
To:     Carlos Llamas <cmllamas@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Michal Hocko <mhocko@suse.com>,
        Christian Brauner <brauner@kernel.org>, linux-mm@kvack.org,
        bpf@vger.kernel.org, kernel-team@android.com,
        Liam Howlett <liam.howlett@oracle.com>,
        Suren Baghdasaryan <surenb@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 29, 2022 at 5:51 PM Carlos Llamas <cmllamas@google.com> wrote:
>
> Commit c462ac288f2c ("mm: Introduce arch_validate_flags()") added a late
> check in mmap_region() to let architectures validate vm_flags. The check
> needs to happen after calling ->mmap() as the flags can potentially be
> modified during this callback.
>
> If arch_validate_flags() check fails we unmap and free the vma. However,
> the error path fails to undo the ->mmap() call that previously succeeded
> and depending on the specific ->mmap() implementation this translates to
> reference increments, memory allocations and other operations what will
> not be cleaned up.
>
> There are several places (mainly device drivers) where this is an issue.
> However, one specific example is bpf_map_mmap() which keeps count of the
> mappings in map->writecnt. The count is incremented on ->mmap() and then
> decremented on vm_ops->close(). When arch_validate_flags() fails this
> count is off since bpf_map_mmap_close() is never called.
>
> One can reproduce this issue in arm64 devices with MTE support. Here the
> vm_flags are checked to only allow VM_MTE if VM_MTE_ALLOWED has been set
> previously. From userspace then is enough to pass the PROT_MTE flag to
> mmap() syscall to trigger the arch_validate_flags() failure.
>
> The following program reproduces this issue:
> ---
>   #include <stdio.h>
>   #include <unistd.h>
>   #include <linux/unistd.h>
>   #include <linux/bpf.h>
>   #include <sys/mman.h>
>
>   int main(void)
>   {
>         union bpf_attr attr = {
>                 .map_type = BPF_MAP_TYPE_ARRAY,
>                 .key_size = sizeof(int),
>                 .value_size = sizeof(long long),
>                 .max_entries = 256,
>                 .map_flags = BPF_F_MMAPABLE,
>         };
>         int fd;
>
>         fd = syscall(__NR_bpf, BPF_MAP_CREATE, &attr, sizeof(attr));
>         mmap(NULL, 4096, PROT_WRITE | PROT_MTE, MAP_SHARED, fd, 0);
>
>         return 0;
>   }
> ---
>
> By manually adding some log statements to the vm_ops callbacks we can
> confirm that when passing PROT_MTE to mmap() the map->writecnt is off
> upon ->release():
>
> With PROT_MTE flag:
>   root@debian:~# ./bpf-test
>   [  111.263874] bpf_map_write_active_inc: map=9 writecnt=1
>   [  111.288763] bpf_map_release: map=9 writecnt=1
>
> Without PROT_MTE flag:
>   root@debian:~# ./bpf-test
>   [  157.816912] bpf_map_write_active_inc: map=10 writecnt=1
>   [  157.830442] bpf_map_write_active_dec: map=10 writecnt=0
>   [  157.832396] bpf_map_release: map=10 writecnt=0
>
> This patch fixes the above issue by calling vm_ops->close() when the
> arch_validate_flags() check fails, after this we can proceed to unmap
> and free the vma on the error path.
>
> Fixes: c462ac288f2c ("mm: Introduce arch_validate_flags()")
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Liam Howlett <liam.howlett@oracle.com>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: <stable@vger.kernel.org> # v5.10+
> Signed-off-by: Carlos Llamas <cmllamas@google.com>
> ---

Makes sense to me, open/close callbacks should be symmetrical. From
BPF-side of things:

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  mm/mmap.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 9d780f415be3..36c08e2c78da 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1797,7 +1797,7 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
>         if (!arch_validate_flags(vma->vm_flags)) {
>                 error = -EINVAL;
>                 if (file)
> -                       goto unmap_and_free_vma;
> +                       goto close_and_free_vma;
>                 else
>                         goto free_vma;
>         }
> @@ -1844,6 +1844,9 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
>
>         return addr;
>
> +close_and_free_vma:
> +       if (vma->vm_ops && vma->vm_ops->close)
> +               vma->vm_ops->close(vma);
>  unmap_and_free_vma:
>         fput(vma->vm_file);
>         vma->vm_file = NULL;
> --
> 2.38.0.rc1.362.ged0d419d3c-goog
>
