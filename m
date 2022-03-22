Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F38504E3AD5
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 09:41:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231465AbiCVImZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Mar 2022 04:42:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231459AbiCVImZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Mar 2022 04:42:25 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B65125D8;
        Tue, 22 Mar 2022 01:40:58 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 417CF210F3;
        Tue, 22 Mar 2022 08:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1647938457; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0wkneNYxu4+l2f/BwLiRAlini3J7bunPFDGOTKdmMbo=;
        b=aq6Tcn/s2XSpyqv94Jpi3whbz2A0f6QZQd2Mffhvu70LiPOkVlLzqRbyCxMnVLMHji6MN0
        +Syv9J3Ia7u2PStho5upOeSuYxDUJ4DOK2Pv4eDq5ZByXJKn1vtZvYDNPihvve6RxrdPAo
        1fLCAPZix2NZhePzVsOxCCItV6HGLaI=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id D8E3EA3B88;
        Tue, 22 Mar 2022 08:40:56 +0000 (UTC)
Date:   Tue, 22 Mar 2022 09:40:56 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     Charan Teja Kalla <quic_charante@quicinc.com>
Cc:     akpm@linux-foundation.org, surenb@google.com, vbabka@suse.cz,
        rientjes@google.com, sfr@canb.auug.org.au, edgararriaga@google.com,
        minchan@kernel.org, nadav.amit@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, "# 5 . 10+" <stable@vger.kernel.org>
Subject: Re: [PATCH V2,2/2] mm: madvise: skip unmapped vma holes passed to
 process_madvise
Message-ID: <YjmLmBUmROr+hshO@dhcp22.suse.cz>
References: <cover.1647008754.git.quic_charante@quicinc.com>
 <4f091776142f2ebf7b94018146de72318474e686.1647008754.git.quic_charante@quicinc.com>
 <Yjia8AzhgWh4KPbp@dhcp22.suse.cz>
 <7207b2f5-6b3e-aea4-aa1b-9c6d849abe34@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7207b2f5-6b3e-aea4-aa1b-9c6d849abe34@quicinc.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 22-03-22 12:40:24, Charan Teja Kalla wrote:
> Thanks Michal for the inputs.
> 
> On 3/21/2022 9:04 PM, Michal Hocko wrote:
> > On Fri 11-03-22 20:59:06, Charan Teja Kalla wrote:
> >> The process_madvise() system call is expected to skip holes in vma
> >> passed through 'struct iovec' vector list.
> > Where is this assumption coming from? From the man page I can see:
> > : The advice might be applied to only a part of iovec if one of its
> > : elements points to an invalid memory region in the remote
> > : process.  No further elements will be processed beyond that
> > : point.  
> 
> I assumed this while processing a single element of a iovec. In a
> scenario where a range passed contains multiple VMA's + holes, on
> encountering the VMA with VM_LOCKED|VM_HUGETLB|VM_PFNMAP, we are
> immediately stopping further processing of that iovec element with
> EINVAL return. Where as on encountering a hole, we are simply
> remembering it as ENOMEM but continues processing that iovec element and
> in the end returns ENOMEM. This means that complete range is processed
> but still returning ENOMEM, hence the assumption of skipping holes in a
> vma.
> 
> The other problem is, in an individual iovec element, though some bytes
> are processed we may still endup in returning EINVAL which is hard for
> the user to take decisions i.e. he doesn't know at which address it is
> exactly failed to advise.
> 
> Anyway, both these will be addressed in the next version of this patch
> with the suggestions from minchan [1] where it mentioned that: "it
> should represent exact bytes it addressed with exacts ranges like
> process_vm_readv/writev. Poviding valid ranges is responsiblity from the
> user."

I would tend to agree that the userspace should be providing sensible
ranges (either subsets or full existing mappings). Whenever multiple
vmas are defined by a single iovec, things get more complicated. IMO
process_madvise should mimic the madvise semantic applied to each iovec.
That means to bail out on an error. That applies to ENOMEM even when the
last iovec has been processed completely.

This would allow to learn about address space change that the caller is
not aware of. That being said, your first patch should be good enough.
-- 
Michal Hocko
SUSE Labs
