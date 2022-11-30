Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA6D563E360
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 23:24:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbiK3WYb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 17:24:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiK3WYa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 17:24:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 272A64FFBB;
        Wed, 30 Nov 2022 14:24:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96DFC61E11;
        Wed, 30 Nov 2022 22:24:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C26AC433D6;
        Wed, 30 Nov 2022 22:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669847067;
        bh=GObiuqWePXvleVN+hRN2W6TyciF+HakME2P3Lh61n28=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YAhbHJpYikQUx0jNOf+ItowlR2w21iqvGsxoJvyc3gVS/fyS7GsRYyVC5aHcGMwxW
         dqefHsBBpntp00i/4r6pJ6oZ3BPgxPgUbp+zvSU2tyL5JAOZHBzkvJfcjpFONibaSV
         vtPIAfMwt6bIwxefV+7aK10fUV23UobOvgs0sgSE=
Date:   Wed, 30 Nov 2022 14:24:25 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     David Hildenbrand <david@redhat.com>
Cc:     Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Ives van Hoorne <ives@codesandbox.io>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Alistair Popple <apopple@nvidia.com>, stable@vger.kernel.org
Subject: Re: [PATCH v3 1/2] mm/migrate: Fix read-only page got writable when
 recover pte
Message-Id: <20221130142425.6a7fdfa3e5954f3c305a77ee@linux-foundation.org>
In-Reply-To: <5ddf1310-b49f-6e66-a22a-6de361602558@redhat.com>
References: <20221114000447.1681003-1-peterx@redhat.com>
        <20221114000447.1681003-2-peterx@redhat.com>
        <5ddf1310-b49f-6e66-a22a-6de361602558@redhat.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 15 Nov 2022 19:17:43 +0100 David Hildenbrand <david@redhat.com> wrote:

> On 14.11.22 01:04, Peter Xu wrote:
> > Ives van Hoorne from codesandbox.io reported an issue regarding possible
> > data loss of uffd-wp when applied to memfds on heavily loaded systems.  The
> > symptom is some read page got data mismatch from the snapshot child VMs.
> > 
> > Here I can also reproduce with a Rust reproducer that was provided by Ives
> > that keeps taking snapshot of a 256MB VM, on a 32G system when I initiate
> > 80 instances I can trigger the issues in ten minutes.
> > 
> > It turns out that we got some pages write-through even if uffd-wp is
> > applied to the pte.
> > 
> > The problem is, when removing migration entries, we didn't really worry
> > about write bit as long as we know it's not a write migration entry.  That
> > may not be true, for some memory types (e.g. writable shmem) mk_pte can
> > return a pte with write bit set, then to recover the migration entry to its
> > original state we need to explicit wr-protect the pte or it'll has the
> > write bit set if it's a read migration entry.  For uffd it can cause
> > write-through.
> > 
> > The relevant code on uffd was introduced in the anon support, which is
> > commit f45ec5ff16a7 ("userfaultfd: wp: support swap and page migration",
> > 2020-04-07).  However anon shouldn't suffer from this problem because anon
> > should already have the write bit cleared always, so that may not be a
> > proper Fixes target, while I'm adding the Fixes to be uffd shmem support.
> > 
>
> ...
>
> > --- a/mm/migrate.c
> > +++ b/mm/migrate.c
> > @@ -213,8 +213,14 @@ static bool remove_migration_pte(struct folio *folio,
> >   			pte = pte_mkdirty(pte);
> >   		if (is_writable_migration_entry(entry))
> >   			pte = maybe_mkwrite(pte, vma);
> > -		else if (pte_swp_uffd_wp(*pvmw.pte))
> > +		else
> > +			/* NOTE: mk_pte can have write bit set */
> > +			pte = pte_wrprotect(pte);
> > +
> > +		if (pte_swp_uffd_wp(*pvmw.pte)) {
> > +			WARN_ON_ONCE(pte_write(pte));

Will this warnnig trigger in the scenario you and Ives have discovered?

> >   			pte = pte_mkuffd_wp(pte);
> > +		}
> >   
> >   		if (folio_test_anon(folio) && !is_readable_migration_entry(entry))
> >   			rmap_flags |= RMAP_EXCLUSIVE;
> 
> As raised, I don't agree to this generic non-uffd-wp change without 
> further, clear justification.

Pater, can you please work this further?

> I won't nack it, but I won't ack it either.

I wouldn't mind seeing a little code comment which explains why we're
doing this.
