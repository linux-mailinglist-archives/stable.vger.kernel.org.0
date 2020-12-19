Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 601702DF146
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 20:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727454AbgLSTQv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 14:16:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30690 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727352AbgLSTQv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Dec 2020 14:16:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608405325;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ywV9ag7r8Yesrq5smCjuibhNxqS7FDwB5/W0QCJT39A=;
        b=f1dic8Pb8Fu/hEX9eXaq6tBfrw54swZJytnik2XJ+VJ5SIgVFH8WqcTKi9OgMsCWmR8yAz
        BfOBmHWQvCrcNoRnnRAdwqxuMryrK5tV8f8KVL5uNjjNkuOcDMAIxxFzJKfYKgw8E31O6g
        ZBuNfaOO9uggKuj7qwQTtpRo2mW1K/o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-446-sVl4iiBhPNWNgqgvFyffmg-1; Sat, 19 Dec 2020 14:15:23 -0500
X-MC-Unique: sVl4iiBhPNWNgqgvFyffmg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C4F1F10054FF;
        Sat, 19 Dec 2020 19:15:21 +0000 (UTC)
Received: from mail (ovpn-119-164.rdu2.redhat.com [10.10.119.164])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 20FBD1002382;
        Sat, 19 Dec 2020 19:15:18 +0000 (UTC)
Date:   Sat, 19 Dec 2020 14:15:17 -0500
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     linux-mm@kvack.org, Peter Xu <peterx@redhat.com>,
        linux-kernel@vger.kernel.org, Nadav Amit <namit@vmware.com>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
Message-ID: <X95RRZ3hkebEmmaj@redhat.com>
References: <20201219043006.2206347-1-namit@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201219043006.2206347-1-namit@vmware.com>
User-Agent: Mutt/2.0.3 (2020-12-04)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

On Fri, Dec 18, 2020 at 08:30:06PM -0800, Nadav Amit wrote:
> Analyzing this problem indicates that there is a real bug since
> mmap_lock is only taken for read in mwriteprotect_range(). This might

Never having to take the mmap_sem for writing, and in turn never
blocking, in order to modify the pagetables is quite an important
feature in uffd that justifies uffd instead of mprotect. It's not the
most important reason to use uffd, but it'd be nice if that guarantee
would remain also for the UFFDIO_WRITEPROTECT API, not only for the
other pgtable manipulations.

> Consider the following scenario with 3 CPUs (cpu2 is not shown):
> 
> cpu0				cpu1
> ----				----
> userfaultfd_writeprotect()
> [ write-protecting ]
> mwriteprotect_range()
>  mmap_read_lock()
>  change_protection()
>   change_protection_range()
>    ...
>    change_pte_range()
>    [ defer TLB flushes]
> 				userfaultfd_writeprotect()
> 				 mmap_read_lock()
> 				 change_protection()
> 				 [ write-unprotect ]
> 				 ...
> 				  [ unprotect PTE logically ]
> 				...
> 				[ page-fault]
> 				...
> 				wp_page_copy()
> 				[ set new writable page in PTE]

Can't we check mm_tlb_flush_pending(vma->vm_mm) if MM_CP_UFFD_WP_ALL
is set and do an explicit (potentially spurious) tlb flush before
write-unprotect?

Thanks,
Andrea

