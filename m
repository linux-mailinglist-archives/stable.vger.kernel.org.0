Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE4A342A932
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 18:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbhJLQSg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 12:18:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbhJLQSf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Oct 2021 12:18:35 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEAB6C061570
        for <stable@vger.kernel.org>; Tue, 12 Oct 2021 09:16:33 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id s4so47801954ybs.8
        for <stable@vger.kernel.org>; Tue, 12 Oct 2021 09:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C7BD6wccAPTIincdVGpFvmdfRHDmwKN+1690ABm9BSo=;
        b=JqLMGsZLZwo/26rWcaEEkpSVhFFH+OlC7Yh11GjQMJWOAoOEo/OS8FiYJ5PtD0RSgu
         bw2Oaz49oFivA3bMB30OQaVH0PdMQz/7iIH4kMs9baD9eYeXd9So5SfKEEYlUTfc2qcD
         HT3wOwyZgSR1V7t810RRtL1MXXX35IhRsm/EuWIwMK/mEJvehfsBPcASE5FwzWW3dvZ0
         Eujw94ZLfnXjnkcl/a6DwpOks65BXP0jcO9OZjvoujG2wstFXydhSxouo0Wu9jvUKwXg
         Vbpuu1oBONXEWtc/vqY0EwF07tAMyG+Ci2f3vBafl2B/0xBfTrbbWXItiFFqvhaxMb2E
         ChfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C7BD6wccAPTIincdVGpFvmdfRHDmwKN+1690ABm9BSo=;
        b=G0IvNYgp/Qv2c6AEp8JPd+n/bHsBhmzf/Ukww1NujIbOlulkn7//2WJ+Zm70qGPVr2
         vds9ZQ69jiHc6BJKyzdnjX2yFEWJgpYTszH3GDZCUiQuznL5k8jmN0R3WxyR/UyGVlKW
         WumWkwfldTsQ9eaKdphe/bx9HnEuTkXlNi0pWSlnD+f+oqSZBWrMm599dxfCkNk8cmAQ
         Qjzuhdi9d+gpkzZmVBGNg8MTKCpC/gMg0jLzHiv7VuTyOu/Si/PIzlcwyDvKbzmgaM0N
         j40XGWhgRBkE5hP8Wvn9zZo6gR46lQLIKOzgWX9L6YGZAnGVnnQVt8ELi1GQ7sFsDLuf
         7/5g==
X-Gm-Message-State: AOAM532XofSKjlpRzkPOtQhwOKJ6G4OnM6P4uvQmNzVrRqGFmgKZdUhA
        mY6xiN0SIr7swBqQxEWJN0uEEBiAP4f7Qk6HYN4P+w==
X-Google-Smtp-Source: ABdhPJxDSDLnCeRzy63ns5goD4U+AUKCvcseSMV+6HMnU+P37cXoMGJA5SHu3pcghaRwcNAyK6MR7qNNOaWzyLCiEhg=
X-Received: by 2002:a25:5b04:: with SMTP id p4mr28429328ybb.34.1634055392729;
 Tue, 12 Oct 2021 09:16:32 -0700 (PDT)
MIME-Version: 1.0
References: <20211012015244.693594-1-surenb@google.com> <YWVeHbWp3kqf7Hyj@kroah.com>
In-Reply-To: <YWVeHbWp3kqf7Hyj@kroah.com>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Tue, 12 Oct 2021 09:16:21 -0700
Message-ID: <CAJuCfpHg9fs5XoyY26ZQbLuPHo0-HLoE8FPFF7CcTy1OLpSveQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] gup: document and work around "COW can break either
 way" issue
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable <stable@vger.kernel.org>, Jann Horn <jannh@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>, Peter Xu <peterx@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kirill Tkhai <ktkhai@virtuozzo.com>, Shaohua Li <shli@fb.com>,
        Nadav Amit <namit@vmware.com>, Christoph Hellwig <hch@lst.de>,
        Oleg Nesterov <oleg@redhat.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>, jack@suse.cz,
        Matthew Wilcox <willy@infradead.org>,
        linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-team <kernel-team@android.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 12, 2021 at 3:06 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Mon, Oct 11, 2021 at 06:52:44PM -0700, Suren Baghdasaryan wrote:
> > From: Linus Torvalds <torvalds@linux-foundation.org>
> >
> > From: Linus Torvalds <torvalds@linux-foundation.org>
> >
> > commit 17839856fd588f4ab6b789f482ed3ffd7c403e1f upstream.
>
> Both backports now queued up, thanks.

Thanks!

>
> greg k-h
>
> --
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
>
