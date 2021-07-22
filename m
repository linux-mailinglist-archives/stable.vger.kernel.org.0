Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 404113D2521
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 16:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232222AbhGVNYb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 09:24:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:37780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232198AbhGVNYb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 09:24:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE4366128A;
        Thu, 22 Jul 2021 14:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626962705;
        bh=HQV3ltpdioq332rYU8MEJmqXRNGg6NdmH1xEjz8aR4U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z7JSVXsi1oU841lt24JeiDTQzvl9R/UX0GUoun33l7BcsCE6FDp3IqesLm5iMAfMX
         Ahu+uU8fAbUpCSmpLlshrTyp0eN6rwFjrf6NAiqJwOqH2KP7jiJuC+he6eVvqtztXO
         1OeTb0yRjxr51xP50yrlhmApOo3y29Kq/d8bKPmU=
Date:   Thu, 22 Jul 2021 16:05:02 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Hugh Dickins <hughd@google.com>
Cc:     Peter Xu <peterx@redhat.com>, stable <stable@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Igor Raits <igor@gooddata.com>,
        Hillf Danton <hdanton@sina.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH stable 5.10.y 0/2] mm/thp: Fix uffd-wp with fork(); crash
 on pmd migration entry on fork
Message-ID: <YPl7DgqTFzMNNcZA@kroah.com>
References: <796cbb7-5a1c-1ba0-dde5-479aba8224f2@google.com>
 <20210720155657.499127-1-peterx@redhat.com>
 <CANsGZ6a6DxnviD3ZPoHCXEEktXguOjNxPuUjjh=v8h0xD3bhvQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANsGZ6a6DxnviD3ZPoHCXEEktXguOjNxPuUjjh=v8h0xD3bhvQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 20, 2021 at 01:38:53PM -0700, Hugh Dickins wrote:
> On Tue, Jul 20, 2021 at 8:57 AM Peter Xu <peterx@redhat.com> wrote:
> >
> > In summary, this series should be needed for 5.10/5.12/5.13. This is the 5.10.y
> > backport of the series.  Patch 1 is a dependency of patch 2, while patch 2
> > should be the real fix.
> >
> > There's a minor conflict on patch 2 when cherry pick due to not having the new
> > helper called page_needs_cow_for_dma().  It's also mentioned at the entry of
> > patch 2.
> >
> > This series should be able to fix a rare race that mentioned in thread:
> >
> > https://lore.kernel.org/linux-mm/796cbb7-5a1c-1ba0-dde5-479aba8224f2@google.com/
> >
> > This fact wasn't discovered when the fix got proposed and merged, because the
> > fix was originally about uffd-wp and its fork event.  However it turns out that
> > the problematic commit b569a1760782f3d is also causing crashing on fork() of
> > pmd migration entries which is even more severe than the original uffd-wp
> > problem.
> >
> > Stable kernels at least on 5.12.y has the crash reproduced, and it's possible
> > 5.13.y and 5.10.y could hit it due to having the problematic commit
> > b569a1760782f3d but lacking of the uffd-wp fix patch (8f34f1eac382, which is
> > also patch 2 of this series).
> >
> > The pmd entry crash problem was reported by Igor Raits <igor@gooddata.com> and
> > debugged by Hugh Dickins <hughd@google.com>.
> >
> > Please review, thanks.
> 
> And these two for 5.10.y look good to me also: I'm glad you decided in
> the end to keep 5.10's support for uffd-wp-fork.
> The first is just a straight cherry-pick of
> 5fc7a5f6fd04bc18f309d9f979b32ef7d1d0a997, but as you noted above,
> 8f34f1eac3820fc2722e5159acceb22545b30b0d needed one line of fixup for
> that tree.

All now queued up, thanks.

greg k-h
