Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A052463FA94
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 23:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbiLAWbK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 17:31:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230273AbiLAWbI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 17:31:08 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 409E5BE695;
        Thu,  1 Dec 2022 14:31:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 87560CE1D9D;
        Thu,  1 Dec 2022 22:31:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59B51C433D6;
        Thu,  1 Dec 2022 22:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669933859;
        bh=pXrGUYzd4kxsmm/YNNu/XwlsU8sIcHepi/vICESbi2U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=x2oYEBPsj4C+C1bw5tKgazUCpot4+Qdb6f+y6/VPNj2IRWjz4FQXkse4WuwoY86qD
         VTD216+w3NgACJtqbLAgV5xgGV+q4imLZg6HTLwbiO0x1XVQ+53TfNykC14aJbOJk5
         TBn9QQyKXyGAyVOwASxrbAy51RBW7311XS6xfGIc=
Date:   Thu, 1 Dec 2022 14:30:58 -0800
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
Message-Id: <20221201143058.80296541cc6802d1e5990033@linux-foundation.org>
In-Reply-To: <a215fe2f-ef9b-1a15-f1c2-2f0bb5d5f490@redhat.com>
References: <20221114000447.1681003-1-peterx@redhat.com>
        <20221114000447.1681003-2-peterx@redhat.com>
        <5ddf1310-b49f-6e66-a22a-6de361602558@redhat.com>
        <20221130142425.6a7fdfa3e5954f3c305a77ee@linux-foundation.org>
        <Y4jIHureiOd8XjDX@x1n>
        <a215fe2f-ef9b-1a15-f1c2-2f0bb5d5f490@redhat.com>
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

On Thu, 1 Dec 2022 16:42:52 +0100 David Hildenbrand <david@redhat.com> wrote:

> On 01.12.22 16:28, Peter Xu wrote:
> > 
> > I didn't reply here because I have already replied with the question in
> > previous version with a few attempts.  Quotting myself:
> > 
> > https://lore.kernel.org/all/Y3KgYeMTdTM0FN5W@x1n/
> > 
> >          The thing is recovering the pte into its original form is the
> >          safest approach to me, so I think we need justification on why it's
> >          always safe to set the write bit.
> > 
> > I've also got another longer email trying to explain why I think it's the
> > other way round to be justfied, rather than justifying removal of the write
> > bit for a read migration entry, here:
> > 
> 
> And I disagree for this patch that is supposed to fix this hunk:
> 
> 
> @@ -243,11 +243,15 @@ static bool remove_migration_pte(struct page *page, struct vm_area_struct *vma,
>                  entry = pte_to_swp_entry(*pvmw.pte);
>                  if (is_write_migration_entry(entry))
>                          pte = maybe_mkwrite(pte, vma);
> +               else if (pte_swp_uffd_wp(*pvmw.pte))
> +                       pte = pte_mkuffd_wp(pte);
>   
>                  if (unlikely(is_zone_device_page(new))) {
>                          if (is_device_private_page(new)) {
>                                  entry = make_device_private_entry(new, pte_write(pte));
>                                  pte = swp_entry_to_pte(entry);
> +                               if (pte_swp_uffd_wp(*pvmw.pte))
> +                                       pte = pte_mkuffd_wp(pte);
>                          }
>                  }

David, I'm unclear on what you mean by the above.  Can you please
expand?

> 
> There is really nothing to justify the other way around here.
> If it's broken fix it independently and properly backport it independenty.
> 
> But we don't know about any such broken case.
> 
> I have no energy to spare to argue further ;)

This is a silent data loss bug, which is about as bad as it gets. 
Under obscure conditions, fortunately.  But please let's keep working
it.  Let's aim for something minimal for backporting purposes.  We can
revisit any cleanliness issues later.

David, do you feel that the proposed fix will at least address the bug
without adverse side-effects?

