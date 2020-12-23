Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBF062E1EFD
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 16:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727624AbgLWPyH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 10:54:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38046 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727093AbgLWPyG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Dec 2020 10:54:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608738760;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CctFZb6bundK1QcZGvHF97KgBugzbNEBYOfUqLkXE1s=;
        b=guqhXXpHiaqvVxI9qKUGKWGjALkSt+NVJfwBh91yOxZXS8r/3zai3kFgYX8DhX/yACQG1W
        0pRL4AWttA4rk8kTSiqbzoDlgRz4j2mLj9ChfNdiz8vW5O79ysyY7vEZ3PNcuBc86VbE/i
        cKI8d+p2RcR4jPrp4dnxBq96MOvDYQc=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-108-Dpfna2xoP565a8b4yimUdA-1; Wed, 23 Dec 2020 10:52:38 -0500
X-MC-Unique: Dpfna2xoP565a8b4yimUdA-1
Received: by mail-qk1-f198.google.com with SMTP id u184so13906206qka.2
        for <stable@vger.kernel.org>; Wed, 23 Dec 2020 07:52:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CctFZb6bundK1QcZGvHF97KgBugzbNEBYOfUqLkXE1s=;
        b=lRAvCKoEo13SVf9mkvZlEfkd5IZEQ8jkvSMkSAfrxhnlx+4HeaD+4QlFdpJQmEa6ks
         HshDTLU+T1ow8seOrVSo4KcgqSy+l/PE3xL7lN7qC5M2kv7JBlW/3zJ/TQMkcjzXfzOQ
         USUhS59JMQTHeae+vhzN0M+StPgFl1mn8ukvJOZTFQnTSr2o2tRaJNvJHy+atwXR8Wly
         EKoxzo4XRt/TdD0QijeTF/Quj/i44Z/iYdp8C8aE1aR/vxrx7Ath0EYSAZHgf/tXn7cq
         ep5KhN7f76BoHhu4KtYALLnX+C29LsDi2oByFGT6VxdZ9OLH5btE3ewtJpsf/gpv/g1c
         SXZw==
X-Gm-Message-State: AOAM533Pcuxi1V3/5gLPzaQPQOSEriqZcVqYh6wMQRTNPkjM+gRTGcAB
        AH+vEpy61w699YSLF5SVWeF2lQUC2ArG/a7SaXuXEAFFYMG5SmkR+Dk++zAlDZbZL5dNCYPLBrT
        J2SY+QTCtIa4kDr0H
X-Received: by 2002:ac8:46c8:: with SMTP id h8mr26253728qto.17.1608738758049;
        Wed, 23 Dec 2020 07:52:38 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzJU7/Y9icFKNa6TDN6+mbeV2MBtZBm3V2OIaPguxARYP0RegIgd55bLE2LXRcKkm70WUUQEw==
X-Received: by 2002:ac8:46c8:: with SMTP id h8mr26253703qto.17.1608738757806;
        Wed, 23 Dec 2020 07:52:37 -0800 (PST)
Received: from xz-x1 ([142.126.83.202])
        by smtp.gmail.com with ESMTPSA id c14sm14501321qtg.85.2020.12.23.07.52.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Dec 2020 07:52:36 -0800 (PST)
Date:   Wed, 23 Dec 2020 10:52:35 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Yu Zhao <yuzhao@google.com>
Cc:     Andrea Arcangeli <aarcange@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Nadav Amit <nadav.amit@gmail.com>,
        linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
Message-ID: <20201223155235.GC6404@xz-x1>
References: <1FCC8F93-FF29-44D3-A73A-DF943D056680@gmail.com>
 <20201221223041.GL6640@xz-x1>
 <CAHk-=wh-bG4thjXUekLtrCg8FRrdWjtT40ibXXLSm_hzQG8eOw@mail.gmail.com>
 <CALCETrV=8tY7h=aaudWBEn-MJnNkm2wz5qjH49SYqwkjYTpOaA@mail.gmail.com>
 <X+JJqK91plkBVisG@redhat.com>
 <X+JhwVX3s5mU9ZNx@google.com>
 <X+Js/dFbC5P7C3oO@redhat.com>
 <X+KDwu1PRQ93E2LK@google.com>
 <X+Kxy3oBMSLz8Eaq@redhat.com>
 <X+K7JMrTEC9SpVIB@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <X+K7JMrTEC9SpVIB@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 22, 2020 at 08:36:04PM -0700, Yu Zhao wrote:
> In your patch, do we need to take wrprotect_rwsem in
> handle_userfault() as well? Otherwise, it seems userspace would have
> to synchronize between its wrprotect ioctl and fault handler? i.e.,
> the fault hander needs to be aware that the content of write-
> protected pages can actually change before the iotcl returns.

The handle_userfault() thread should be sleeping until another uffd_wp_resolve
fixes the page fault for it.  However when the uffd_wp_resolve ioctl comes,
then rwsem (either the group rwsem lock as Andrea proposed, or the mmap_sem, or
any new rwsem lock we'd like to introduce, maybe per-uffd rather than per-mm)
should have guaranteed the previous wr-protect ioctls are finished and tlb must
have been flushed until this thread continues.

And I don't know why it matters even if the data changed - IMHO what uffd-wp
wants to do is simply to make sure after wr-protect ioctl returns to userspace,
no change on the page should ever happen anymore.  So "whether data changed"
seems matter more on the ioctl thread rather than the handle_userfault()
thread.  IOW, I think data changes before tlb flush but after pte wr-protect is
always fine - but that's not fine anymore if the syscall returns.

Thanks,

-- 
Peter Xu

