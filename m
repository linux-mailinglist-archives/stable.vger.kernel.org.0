Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 374522DFF3B
	for <lists+stable@lfdr.de>; Mon, 21 Dec 2020 19:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgLUSFn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Dec 2020 13:05:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32157 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725785AbgLUSFm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Dec 2020 13:05:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608573856;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6sjtlrhGUxO16NzG5DkLPHVO+T8orGHfRBW16dyzHT4=;
        b=C+MfcTKdgOlTJpW67GVO5XNndVIMG9QSnQ9BAO+RUdzgfnuywPEzyn45x1Sgpggz4IMeQA
        wOP6rMblHFTyrw/y3bJqxlQ9lR/Jm7mMzG2Pfc0Ag0Nm1Y23IcIYlCuwHDAd05ZuzVbLyC
        cq8nCVyn0hYu/fFfODgN+k4ernbwhCg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-184-vMu3G7ZzMYmvWk1oEPPh9A-1; Mon, 21 Dec 2020 13:04:14 -0500
X-MC-Unique: vMu3G7ZzMYmvWk1oEPPh9A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B32A06D24B;
        Mon, 21 Dec 2020 18:04:01 +0000 (UTC)
Received: from mail (ovpn-112-5.rdu2.redhat.com [10.10.112.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2C9041E5;
        Mon, 21 Dec 2020 18:03:58 +0000 (UTC)
Date:   Mon, 21 Dec 2020 13:03:57 -0500
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Nadav Amit <nadav.amit@gmail.com>,
        Dave Hansen <dave.hansen@intel.com>,
        linux-mm <linux-mm@kvack.org>, Peter Xu <peterx@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>, Yu Zhao <yuzhao@google.com>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
Message-ID: <X+Djjd8dW12u+rSR@redhat.com>
References: <20201219043006.2206347-1-namit@vmware.com>
 <X95RRZ3hkebEmmaj@redhat.com>
 <EDC00345-B46E-4396-8379-98E943723809@gmail.com>
 <CALCETrVtsdeOtGWMUcmT1dzDBxRpecpZDe02L61qEmJmFxSvYw@mail.gmail.com>
 <X967yWAoaTejRk5y@redhat.com>
 <CALCETrVVa-cfogKZirRrP5tmy-gCDtb=jTpLk648BpBQsK9Z5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVVa-cfogKZirRrP5tmy-gCDtb=jTpLk648BpBQsK9Z5A@mail.gmail.com>
User-Agent: Mutt/2.0.3 (2020-12-04)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

On Sat, Dec 19, 2020 at 09:08:55PM -0800, Andy Lutomirski wrote:
> On Sat, Dec 19, 2020 at 6:49 PM Andrea Arcangeli <aarcange@redhat.com> wrote:
> > The ptes are changed always with the PT lock, in fact there's no
> > problem with the PTE updates. The only difference with mprotect
> > runtime is that the mmap_lock is taken for reading. And the effect
> > contested for this change doesn't affect the PTE, but supposedly the
> > tlb flushing deferral.
> 
> Can you point me at where the lock ends up being taken in this path?

pte_offset_map_lock in change_pte_range, as in mprotect, no difference.

As I suspected on my follow up, the bug described wasn't there, but
I'll look at the new theory posted.

Thanks,
Andrea

