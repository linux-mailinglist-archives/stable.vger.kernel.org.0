Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7A7839D11A
	for <lists+stable@lfdr.de>; Sun,  6 Jun 2021 21:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbhFFTsP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Jun 2021 15:48:15 -0400
Received: from mail-lj1-f172.google.com ([209.85.208.172]:34667 "EHLO
        mail-lj1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbhFFTsP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Jun 2021 15:48:15 -0400
Received: by mail-lj1-f172.google.com with SMTP id bn21so19075379ljb.1;
        Sun, 06 Jun 2021 12:46:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WEFvXNtn4l4k8GsstWahlRU4zhK55NEXKuCsYYjkt3g=;
        b=jvjAMfR77o7iynHF9Gv3c85ReL6hZm31XE9zJumoFB7gFUgfXEj7QqfD2eDi0TAZHG
         OYhsQvkmiMfHLeSJhl1jKveTl+3zrKDaYDZua1CCaEbgBIYnWE9zS0QnxT2yYCLOOR0s
         Iqgz+2w087eK/DR+ms1r7z9tCa7KW3plUOm1bnavqHIoS40QrgASr3c++tURHV5vxcbx
         fVfak/8PHXCniG77//OBDVYBAuQMuPgbd/uPk0Jx+qiGuQDzIn77LKvWJqgbcCJxsSGf
         /IyPpniJPi4OBvajZWK3OFduEHH8w6zqY71YIvRupqnvj1Q6peyXPHvxQfAL8RFn1wWJ
         i/FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WEFvXNtn4l4k8GsstWahlRU4zhK55NEXKuCsYYjkt3g=;
        b=IYMLjPfu3c8g2Do/S3RiYJT+bvMLxsInphYq2/LUG9Ev1lA4E045y4stchXrr1GVs0
         U7tihpfPNX9zJWuEXuQgRziXVpei9q0lc5X1xUI2IwugdVhtp+Qh3VLke6OorzYkiw7k
         5U0hdLXjaV03wXmd4SQnF8n8oghvinvPlRhMbLT9tZ+4HCohdkKT7S7TLRBZ4KaL8HWe
         9Bg1B7nmolzGFI2s0SqR3BLVQLbHybZwxlw8g57y4KQwRpj3sbVPHNYBhiUQjiVplsRD
         IaVi7hp3WE3zf+FnlseaBrrJjKENV9vS34LYFACVkE7z685I3TwaJc4oQw1W4wBjuUy3
         N/qA==
X-Gm-Message-State: AOAM5326qgFy5w6CD6SplzCeDfzHXZFTd4g3KXXFoVYEttH40+DAEAic
        DHml6077PXTtq4jbaZjSSUWRrpV30jKm7HTgnxRXmEvtw4cauw==
X-Google-Smtp-Source: ABdhPJyG8AjuhX/M3rcNTnsWON11DR9FNo24GF7QLHSomPzWWRXDYr8/o+tGRgjbgHHTbxdge8ekpHiRrO0YvdAj2bk=
X-Received: by 2002:a2e:509:: with SMTP id 9mr12425172ljf.6.1623008724338;
 Sun, 06 Jun 2021 12:45:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210310075127.1045556-1-ribalda@chromium.org> <YLoWzSoSUQ6HYsyO@chromium.org>
In-Reply-To: <YLoWzSoSUQ6HYsyO@chromium.org>
From:   Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date:   Sun, 6 Jun 2021 21:45:06 +0200
Message-ID: <CAPybu_2u-5nEy0ayT0-wrEmHpjx+UNR+iS-9+sPYb-yuRW9+qQ@mail.gmail.com>
Subject: Re: [PATCH v2] media: videobuf2: Fix integer overrun in vb2_mmap
To:     Tomasz Figa <tfiga@chromium.org>
Cc:     Ricardo Ribalda <ribalda@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Slaby <jslaby@suse.cz>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Tomasz

Thanks for your review!

We finally figured out that we would not like to support allocations
of exactly 4GiB. The rest of the code is not designed for it.

And you will get a descriptive enough error if you overrun (at least
in recent kernels):
 if (length < (vma->vm_end - vma->vm_start)) {

Best regards!

On Fri, Jun 4, 2021 at 2:06 PM Tomasz Figa <tfiga@chromium.org> wrote:
>
> On Wed, Mar 10, 2021 at 08:51:27AM +0100, Ricardo Ribalda wrote:
> > The plane_length is an unsigned integer. So, if we have a size of
> > 0xffffffff bytes we incorrectly allocate 0 bytes instead of 1 << 32.
> >
> > Suggested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> > Cc: stable@vger.kernel.org
> > Fixes: 7f8414594e47 ("[media] media: videobuf2: fix the length check for mmap")
> > Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> > Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
> > ---
> >  drivers/media/common/videobuf2/videobuf2-core.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
> > index 543da515c761..89c8bacb94a7 100644
> > --- a/drivers/media/common/videobuf2/videobuf2-core.c
> > +++ b/drivers/media/common/videobuf2/videobuf2-core.c
> > @@ -2256,7 +2256,7 @@ int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
> >        * The buffer length was page_aligned at __vb2_buf_mem_alloc(),
> >        * so, we need to do the same here.
> >        */
> > -     length = PAGE_ALIGN(vb->planes[plane].length);
> > +     length = PAGE_ALIGN((unsigned long)vb->planes[plane].length);
> >       if (length < (vma->vm_end - vma->vm_start)) {
> >               dprintk(q, 1,
> >                       "MMAP invalid, as it would overflow buffer length\n");
> > --
> > 2.30.1.766.gb4fecdf3b7-goog
> >
>
> Acked-by: Tomasz Figa <tfiga@chromium.org>
>
> Best regards,
> Tomasz



-- 
Ricardo Ribalda
