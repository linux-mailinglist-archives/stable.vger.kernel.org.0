Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3342E20A0
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 19:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727100AbgLWS45 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 13:56:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58527 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725957AbgLWS45 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Dec 2020 13:56:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608749730;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8jQ8TvAnsIxDbptywrLeuoJWSkK3iD3Et9L2f3gXwKM=;
        b=OUdu3fxdAJV4agT6FnTqjumqnIxbQCjGpAdpSd+uj14qez+9UMmvFLJOrEqVQhS3/XMHe2
        G8lAnkLk1MRaYBS+Oa1FPmLP/ftdnfPGdFbIiP7Fj0Sx3LSy8HhFMi36l4dh2VnjKS8Q9n
        ZJEjmjumPJk+J6YgPwVuZX3Ojh4UWLg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-497-7T_J0a-cPcCaOgKh-YUWgw-1; Wed, 23 Dec 2020 13:55:22 -0500
X-MC-Unique: 7T_J0a-cPcCaOgKh-YUWgw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 23C0CC29F;
        Wed, 23 Dec 2020 18:55:20 +0000 (UTC)
Received: from mail (ovpn-112-5.rdu2.redhat.com [10.10.112.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4947C5D9C6;
        Wed, 23 Dec 2020 18:55:16 +0000 (UTC)
Date:   Wed, 23 Dec 2020 13:55:15 -0500
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Yu Zhao <yuzhao@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
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
Message-ID: <X+OSk8Ri8my5uXtZ@redhat.com>
References: <X+JJqK91plkBVisG@redhat.com>
 <X+JhwVX3s5mU9ZNx@google.com>
 <X+Js/dFbC5P7C3oO@redhat.com>
 <X+KDwu1PRQ93E2LK@google.com>
 <CAHk-=wiBWkgxLtwD7n01irD7hTQzuumtrqCkxxZx=6dbiGKUqQ@mail.gmail.com>
 <CAHk-=wjG7xx7Gsb=K0DteB1SPcKjus02zY2gFUoxMY5mm7tfsA@mail.gmail.com>
 <CAHk-=wjNv1GQn+8stK419HAqK0ofkJ1vOR9YSWSNjbW3T5as9A@mail.gmail.com>
 <X+MWppLjiR7hLgg9@google.com>
 <20201223162416.GD6404@xz-x1>
 <X+ORz1CVIhzKvunq@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X+ORz1CVIhzKvunq@redhat.com>
User-Agent: Mutt/2.0.3 (2020-12-04)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 23, 2020 at 01:51:59PM -0500, Andrea Arcangeli wrote:
> NOTE: about the above comment, that mprotect takes
> mmap_read_lock. Your above code change in the commit above, still has
       ^^^^ write

Correction to avoid any confusion.

