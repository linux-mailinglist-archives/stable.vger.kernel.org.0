Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD07F120736
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 14:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727763AbfLPNat (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 08:30:49 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:37035 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727758AbfLPNat (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 08:30:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576503048;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=T3wALvF0xpsoopJ4Bzkk3lqyRNuGZEwsZlHqY5vrDU8=;
        b=D8FuEAKp90PI4ISdkPkEP9MgaOIAVAYq5VZdsC304Rh3NRNdn4Qvz2eHDFGy7cQPgjxe5r
        MvPC6GdvEqeyrHK6N5mvaM4zVGGoqqsLnYj6VApbH96sJG+ZdvAhSwgMK5liDsSDNIHgeD
        fC1gbDpk6SZtiXK4M3tX8BPqprJPuO8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-131-qsszcB5ZMUWLdutmVdKZhw-1; Mon, 16 Dec 2019 08:30:47 -0500
X-MC-Unique: qsszcB5ZMUWLdutmVdKZhw-1
Received: by mail-wm1-f69.google.com with SMTP id t4so1039633wmf.2
        for <stable@vger.kernel.org>; Mon, 16 Dec 2019 05:30:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=T3wALvF0xpsoopJ4Bzkk3lqyRNuGZEwsZlHqY5vrDU8=;
        b=GJYiF6nJiIq1yXYdd4ec3TbK2hvF4vCiqwP31ov8S/hOv00VaYdYPpP8KCsOl05ArZ
         qzTSWPamMBqZ73AN5zQEE74NC3lu258NP86rHTC2Xl4QOKMim4TU8xagWmpDtQRoXZVF
         YQ3BKpldBbTOWsSE6w6kwHymciEZbWa2FnxwQlhpDrM0/7Ni0FqfDcztIfzhXmOhg6Cr
         W086IvT0SYbal2T3zWknEeYGphw3X/qpwGD+PVi82+LMQex3mC1cJ0yuVK0GFj+dOgnS
         Ymp9BnDWPNJr3q+XY35XQh5Dn2Otzr6qRhDpBHxLLODN63LkqCqZ4P93CXjGbCnd3A5o
         A1Tg==
X-Gm-Message-State: APjAAAXUSLurQMs1pOvgbdMyNqIb78zqFEOdeTs8QFCFGAW3OxQO62NZ
        HEMSSaI6hY1x6JGbZNT+T64YNZlCFEbJ2z3LcxmzYA5SI1xCyvlJKDQYPcPkeuCSvP2WcemLRgj
        c5roDm2Fkiva8qwT5
X-Received: by 2002:adf:9b83:: with SMTP id d3mr30125997wrc.54.1576503046078;
        Mon, 16 Dec 2019 05:30:46 -0800 (PST)
X-Google-Smtp-Source: APXvYqwp1RzM05y36ZEXv8HKgj2CLHoERwAX15WfZnqvn+tQSSKxuIklj/RaULFXdTnzVAnGsM+K+A==
X-Received: by 2002:adf:9b83:: with SMTP id d3mr30125970wrc.54.1576503045873;
        Mon, 16 Dec 2019 05:30:45 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id 2sm21854185wrq.31.2019.12.16.05.30.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 05:30:45 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ajay Kaher <akaher@vmware.com>
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, punit.agrawal@arm.com,
        akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        willy@infradead.org, will.deacon@arm.com, mszeredi@redhat.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        srivatsab@vmware.com, srivatsa@csail.mit.edu, amakhalov@vmware.com,
        srinidhir@vmware.com, bvikas@vmware.com, anishs@vmware.com,
        vsirnapalli@vmware.com, srostedt@vmware.com,
        Vlastimil Babka <vbabka@suse.cz>,
        Oscar Salvador <osalvador@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Juergen Gross <jgross@suse.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v3 8/8] x86, mm, gup: prevent get_page() race with munmap in paravirt guest
In-Reply-To: <20191216130443.GN2844@hirez.programming.kicks-ass.net>
References: <1576529149-14269-1-git-send-email-akaher@vmware.com> <1576529149-14269-9-git-send-email-akaher@vmware.com> <20191216130443.GN2844@hirez.programming.kicks-ass.net>
Date:   Mon, 16 Dec 2019 14:30:44 +0100
Message-ID: <87lfrc9z3v.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Tue, Dec 17, 2019 at 02:15:48AM +0530, Ajay Kaher wrote:
>> From: Vlastimil Babka <vbabka@suse.cz>
>> 
>> The x86 version of get_user_pages_fast() relies on disabled interrupts to
>> synchronize gup_pte_range() between gup_get_pte(ptep); and get_page() against
>> a parallel munmap. The munmap side nulls the pte, then flushes TLBs, then
>> releases the page. As TLB flush is done synchronously via IPI disabling
>> interrupts blocks the page release, and get_page(), which assumes existing
>> reference on page, is thus safe.
>> However when TLB flush is done by a hypercall, e.g. in a Xen PV guest, there is
>> no blocking thanks to disabled interrupts, and get_page() can succeed on a page
>> that was already freed or even reused.
>> 
>> We have recently seen this happen with our 4.4 and 4.12 based kernels, with
>> userspace (java) that exits a thread, where mm_release() performs a futex_wake()
>> on tsk->clear_child_tid, and another thread in parallel unmaps the page where
>> tsk->clear_child_tid points to. The spurious get_page() succeeds, but futex code
>> immediately releases the page again, while it's already on a freelist. Symptoms
>> include a bad page state warning, general protection faults acessing a poisoned
>> list prev/next pointer in the freelist, or free page pcplists of two cpus joined
>> together in a single list. Oscar has also reproduced this scenario, with a
>> patch inserting delays before the get_page() to make the race window larger.
>> 
>> Fix this by removing the dependency on TLB flush interrupts the same way as the
>
> This is suppsed to be fixed by:
>
> arch/x86/Kconfig:       select HAVE_RCU_TABLE_FREE              if PARAVIRT
>

Yes,

but HAVE_RCU_TABLE_FREE was enabled on x86 only in 4.14:

commit 9e52fc2b50de3a1c08b44f94c610fbe998c0031a
Author: Vitaly Kuznetsov <vkuznets@redhat.com>
Date:   Mon Aug 28 10:22:51 2017 +0200

    x86/mm: Enable RCU based page table freeing (CONFIG_HAVE_RCU_TABLE_FREE=y)

and, if I understood correctly, Ajay is suggesting the patch for older
stable kernels (4.9 and 4.4 I would guess).

-- 
Vitaly

