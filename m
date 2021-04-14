Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E33135F16A
	for <lists+stable@lfdr.de>; Wed, 14 Apr 2021 12:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233644AbhDNKWy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Apr 2021 06:22:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233618AbhDNKWw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Apr 2021 06:22:52 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5A57C061574
        for <stable@vger.kernel.org>; Wed, 14 Apr 2021 03:22:29 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id d5so10696327iof.3
        for <stable@vger.kernel.org>; Wed, 14 Apr 2021 03:22:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SMW3nxFYepxawXrZMQ8uUIchkTpkmGCIJAQvAUQJRIc=;
        b=LLMYh428GZ0EIgOPj5nDcC+0Qqgx/RfRxB262hGCKJBBzpvqKIgClNR/njPDsbfPbG
         D9oiosHDaNPp31RwVQgCl5NDcFilU2pk86n/5iivZ9IpeazN79brsvGJPEQYfut+F58a
         sZweohge02krtmNxZXojH44wOj/ZBaQqVpz+JH22tO9obGpviyw1WRbPt+haSbkio6Ln
         v5qu9SaAPOjdusFIGpYE05kL4tYAWLk86cT0VvsiczDP4tdHYwBIifoeHAU2SeLvalwm
         FVtVnPgljiTanJJaq6UT6m2C5K9nPaIezBIsXAxdXQayza4GR6iRumqaDBugGJgX+SmE
         bTxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SMW3nxFYepxawXrZMQ8uUIchkTpkmGCIJAQvAUQJRIc=;
        b=KE/KlbYUaWAg0W1k95xMhd2fIuhIAHeU67hVL875GczwmzES3c5pZfoVDw4GO4vIL+
         PUHo34jAy3KzKUQR7UWa89qaxWsigEgf3e+fPchTL4QlUEl4yuNzrxbyWJ/5E6/tMC0Q
         C/lKvVQi8WEYncEPlk4cCXRQ4sXHs+RH6DBfmBkIGzzdzJSgl9HR0gjWNJmUEa3PCNJf
         EHw+6E/8smG7FkyRSmQn6lbKApZvvVhfOXBJ8uj7SlU7qQcWb+Qsu7WJK1PrZ0l6nQ+b
         Mj0CnaYTp6EssF6AQjMAf7v7/eFlnAcZIvhWfIqRx4Z5BF7mgfx+XZRH7kvcUvp2feOz
         NBgQ==
X-Gm-Message-State: AOAM533qBuD/AP/zgLusP/2X8IY7sFwIyJ1LTKdpiDd9uk6wqA1tg4Bk
        mwXreoqZPxmxbIq6xNeiyzQ/jkL7IGG/6ViYPPQ=
X-Google-Smtp-Source: ABdhPJzW6Rb5wJUdIoaDtNtPNuFP2E5Y6Rh3/+XepOW+b1LXqd+0RvVJZWfQcs810cb016EIeOM/moQMud9BKOCRxuo=
X-Received: by 2002:a6b:7d4c:: with SMTP id d12mr29946517ioq.162.1618395749113;
 Wed, 14 Apr 2021 03:22:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210408104622.943843-1-vaibhav@linux.ibm.com>
 <CAM9Jb+j6oVumXQ+zmYbQSvQ3UzLKT3V8XLq1SotVcwVuUwP09A@mail.gmail.com> <87r1jejkx1.fsf@vajain21.in.ibm.com>
In-Reply-To: <87r1jejkx1.fsf@vajain21.in.ibm.com>
From:   Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date:   Wed, 14 Apr 2021 12:22:18 +0200
Message-ID: <CAM9Jb+je_aEyd_c4zhP+r3ubSxfpcmjdfdez4yvUWYAESh8S4w@mail.gmail.com>
Subject: Re: [PATCH v3] libnvdimm/region: Update nvdimm_has_flush() to handle
 explicit 'flush' callbacks
To:     Vaibhav Jain <vaibhav@linux.ibm.com>
Cc:     linux-nvdimm <linux-nvdimm@lists.01.org>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>, stable@vger.kernel.org,
        Shivaprasad G Bhat <sbhat@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> >> In case a platform doesn't provide explicit flush-hints but provides an
> >> explicit flush callback, then nvdimm_has_flush() still returns '0'
> >> indicating that writes do not require flushing. This happens on PPC64
> >> with patch at [1] applied, where 'deep_flush' of a region was denied
> >> even though an explicit flush function was provided.
> >>
> >> Similar problem is also seen with virtio-pmem where the 'deep_flush'
> >> sysfs attribute is not visible as in absence of any registered nvdimm,
> >> 'nd_region->ndr_mappings == 0'.
> >
> > In case of async flush callback, do we still need "deep_flush" ?
>
> 'deep_flush' in libnvdimm (specifically 'deep_flush_store()')
> anyways resorts to calling 'async_flush' callback if its defined. Which
> makes sense to me since in absence of eADR, 'echo 1 > deep_flush' would
> ensure that writes to pmem are now durable even if there is a sudden
> power loss before cpu caches are flushed.
>
> On non-nfit architectures the 'async_flush' callback should provide such
> a guarantee, which can be triggered by user-space writing to the
> 'deep_flush' sysfs attr.
>
> In absence of 'deep_flush' sysfs attr not sure how else can user-space
> forcibly trigger async_flush callback for dev-dax char devices.

O.k. that means for filesystem DAX deep_flush is alternative to
fsync/msync call.

I still have to dig deeper to understand more about "QUEUE_FLAG_FUA" flag &
why I was seeing REQ_FUA with virtio-pmem when doing fsync if its not enabled
in function "blk_queue_write_cache". But this is for my understanding.

Overall patch looks good to me and it looks to solve (not tested
though) the warning for
virtio-pmem as well.

Reviewed-by: Pankaj Gupta <pankaj.gupta@ionos.com>



Thanks,
Pankaj
