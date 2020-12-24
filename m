Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7E162E2390
	for <lists+stable@lfdr.de>; Thu, 24 Dec 2020 03:03:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728462AbgLXCCB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 21:02:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60849 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728367AbgLXCCB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Dec 2020 21:02:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608775234;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3Ni6tCCgQBk1q+zYM38+EyQ5WFEQoiTCDHuKMjM6vbA=;
        b=WAwIRp6432YHYsc0DLC0VSFRB+MoD7TM5OSeqZP8+ga2isaazHoekEtgTxmEldFWCuhSfs
        PV9O2zxOZw1Ko/i3TFtGvcm+kAKzfR9GVCJ6QF6vELryaVeM7UieLj5aO+W4wi4e9g6NXL
        KhP6nrPipzwr3t+xDC2WmJ3fxrPWMXM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-390-_9yR_rClP8iSzRGjZEvRsQ-1; Wed, 23 Dec 2020 21:00:32 -0500
X-MC-Unique: _9yR_rClP8iSzRGjZEvRsQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D5B39E763;
        Thu, 24 Dec 2020 02:00:30 +0000 (UTC)
Received: from mail (ovpn-112-5.rdu2.redhat.com [10.10.112.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 46E8010023AF;
        Thu, 24 Dec 2020 02:00:27 +0000 (UTC)
Date:   Wed, 23 Dec 2020 21:00:26 -0500
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Yu Zhao <yuzhao@google.com>, Andy Lutomirski <luto@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Xu <peterx@redhat.com>,
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
Message-ID: <X+P2OnR+ipY8d2qL@redhat.com>
References: <X+PE38s2Egq4nzKv@google.com>
 <C332B03D-30B1-4C9C-99C2-E76988BFC4A1@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <C332B03D-30B1-4C9C-99C2-E76988BFC4A1@amacapital.net>
User-Agent: Mutt/2.0.3 (2020-12-04)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 23, 2020 at 05:21:43PM -0800, Andy Lutomirski wrote:
> I don’t love this as a long term fix. AFAICT we can have mm_tlb_flush_pending set for quite a while — mprotect seems like it can wait in IO while splitting a huge page, for example. That gives us a window in which every write fault turns into a TLB flush.

mprotect can't run concurrently with a page fault in the first place.

One other near zero cost improvement easy to add if this would be "if
(vma->vm_flags & (VM_SOFTDIRTY|VM_UFFD_WP))" and it could be made
conditional to the two config options too.

Still I don't mind doing it in some other way, uffd-wp has much easier
time doing it in another way in fact.

Whatever performs better is fine, but queuing up pending invalidate
ranges don't look very attractive since it'd be a fixed cost that we'd
always have to pay even when there's no fault (and there can't be any
fault at least for mprotect).

Thanks,
Andrea

