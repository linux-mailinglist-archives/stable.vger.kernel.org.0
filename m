Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 284C763DAE9
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 17:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbiK3QmJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 11:42:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbiK3QmI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 11:42:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ECF68BD01
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 08:42:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0095B81BB5
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 16:42:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE7DC433C1;
        Wed, 30 Nov 2022 16:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669826525;
        bh=PdngSx0MOEeD4SWGEFmFkY6/t0cbih5OhVsmr75ybxY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1RjWCHr6jrWiTZMB7WtJU23oaUDfFIrGj0QgTEK4S8hzQwdNxmeD0qq80OEXKuObM
         8xyDOfxQ5MjkbEMP3oB982KgHPrfsObEunaJoSRlTZdXOdU0RwwUJCQvU6iHC1SZ3w
         lHQuECqm7G8cRtTsk7cgbjjioJgDsHrE1zBh8xN0=
Date:   Wed, 30 Nov 2022 17:42:03 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dominic Jones <jonesd@xmission.com>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev
Subject: Re: [REGRESSION] v6.0.x fails to boot after updating from v5.19.x
Message-ID: <Y4eH2xhXUWDp/XeL@kroah.com>
References: <709b163021b2608789dab55eb3f9724c.dominic@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <709b163021b2608789dab55eb3f9724c.dominic@xmission.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 24, 2022 at 01:08:57AM +0000, Dominic Jones wrote:
> > On Fri, Oct 28, 2022 at 02:51:43PM +0000, Dominic Jones wrote:
> > > Updating the machine's kernel from v5.19.x to v6.0.x causes the machine to not
> > > successfully boot. The machine boots successfully (and exhibits stable operation)
> > > with version v5.19.17 and multiple earlier releases in the 5.19 line. Multiple releases
> > > from the 6.0 line (including 6.0.0, 6.0.3, and 6.0.5), with no other changes to the
> > > software environment, do not boot. Instead, the machine hangs after loading services
> > > but before presenting a display manager; the machine instead shows repetitive hard
> > > drive activity at this point and then no apparent activity.
> > > 
> > > ''uname'' output for the machine successfully running v5.19.17 is:
> > > 
> > >     Linux [MACHINE_NAME] 5.19.17 #1 SMP PREEMPT_DYNAMIC Mon Oct 24 13:32:29 2022 i686 Intel(R) Atom(TM) CPU N270 @ 1.60GHz GenuineIntel GNU/Linux
> > > 
> > > The machine is an OCZ Neutrino netbook, running a custom OS build largely similar to
> > > LFS development. The kernel update uses ''make olddefconfig''.
> > 
> > Can you use 'git bisect' to find the offending change that causes this
> > to happen?
> 
> Bisection is complete. Here's what it returned.
> 
> ---
> 
> 3a194f3f8ad01bce00bd7174aaba1563bcc827eb is the first bad commit
> commit 3a194f3f8ad01bce00bd7174aaba1563bcc827eb
> Author: Naoya Horiguchi <naoya.horiguchi@nec.com>
> Date:   Thu Jul 14 13:24:14 2022 +0900
> 
>     mm/hugetlb: make pud_huge() and follow_huge_pud() aware of non-present pud entry
>     
>     follow_pud_mask() does not support non-present pud entry now.  As long as
>     I tested on x86_64 server, follow_pud_mask() still simply returns
>     no_page_table() for non-present_pud_entry() due to pud_bad(), so no severe
>     user-visible effect should happen.  But generally we should call
>     follow_huge_pud() for non-present pud entry for 1GB hugetlb page.
>     
>     Update pud_huge() and follow_huge_pud() to handle non-present pud entries.
>     The changes are similar to previous works for pud entries commit
>     e66f17ff7177 ("mm/hugetlb: take page table lock in follow_huge_pmd()") and
>     commit cbef8478bee5 ("mm/hugetlb: pmd_huge() returns true for non-present
>     hugepage").
>     
>     Link: https://lkml.kernel.org/r/20220714042420.1847125-3-naoya.horiguchi@linux.dev
>     Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
>     Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
>     Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
>     Cc: David Hildenbrand <david@redhat.com>
>     Cc: kernel test robot <lkp@intel.com>
>     Cc: Liu Shixin <liushixin2@huawei.com>
>     Cc: Muchun Song <songmuchun@bytedance.com>
>     Cc: Oscar Salvador <osalvador@suse.de>
>     Cc: Yang Shi <shy828301@gmail.com>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
>  arch/x86/mm/hugetlbpage.c |  8 +++++++-
>  mm/hugetlb.c              | 32 ++++++++++++++++++++++++++++++--
>  2 files changed, 37 insertions(+), 3 deletions(-)
> 

Great!  Please work with those developers to figure out why this is
causing a problem for your system.

thanks,

greg k-h
