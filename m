Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 607DB105B36
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 21:38:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbfKUUi0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 15:38:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:34768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726546AbfKUUi0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 Nov 2019 15:38:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BC7D2068D;
        Thu, 21 Nov 2019 20:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574368705;
        bh=tkue0peFTapJgtiml9Rsf9+zPuGR8vfy55j8RC72cxA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eWXxVHyMqL0FI5PfBcn+Pf+oXV3Wt0TEUIIKeT2DmhIJ0+/NPjMyhZbU4t8RJgByi
         VM84KxBJcrKGn/A2W2PsBHIBRSiXenDXc4E1Oj9C5BvNe5/YNMZ6P1AnHwQe43GhO3
         LYAi9LAE0OIKCVwiVR9v5/NShNJn1tnY2xohgi7Q=
Date:   Thu, 21 Nov 2019 21:38:23 +0100
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Ajay Kaher <akaher@vmware.com>
Cc:     Vlastimil Babka <vbabka@suse.cz>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "punit.agrawal@arm.com" <punit.agrawal@arm.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "willy@infradead.org" <willy@infradead.org>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "mszeredi@redhat.com" <mszeredi@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Srivatsa Bhat <srivatsab@vmware.com>,
        "srivatsa@csail.mit.edu" <srivatsa@csail.mit.edu>,
        Alexey Makhalov <amakhalov@vmware.com>,
        Srinidhi Rao <srinidhir@vmware.com>,
        Vikash Bansal <bvikas@vmware.com>,
        Anish Swaminathan <anishs@vmware.com>,
        Vasavi Sirnapalli <vsirnapalli@vmware.com>,
        Steven Rostedt <srostedt@vmware.com>,
        "stable@kernel.org" <stable@kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH v2 6/8] mm: prevent get_user_pages() from overflowing
 page refcount
Message-ID: <20191121203823.GE813260@kroah.com>
References: <1570581863-12090-1-git-send-email-akaher@vmware.com>
 <1570581863-12090-7-git-send-email-akaher@vmware.com>
 <f899be71-4bc0-d07b-f650-d85a335cdebb@suse.cz>
 <BF0587E3-D104-4DB2-B972-9BC4FD4CA014@vmware.com>
 <0E5175FB-7058-4211-9AA4-9D5E2F6A30B9@vmware.com>
 <35d74931-2c18-00ff-7622-522a79be9103@suse.cz>
 <88E8A78A-6CA3-46C1-A2AA-DFE7A3A52586@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <88E8A78A-6CA3-46C1-A2AA-DFE7A3A52586@vmware.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 11, 2019 at 05:00:29AM +0000, Ajay Kaher wrote:
> 
> ﻿On 06/11/19, 2:25 PM, "Vlastimil Babka" <vbabka@suse.cz> wrote:
> 
> > On 10/25/19 8:18 AM, Ajay Kaher wrote:
> >> On 17/10/19, 9:58 PM, "Ajay Kaher" <akaher@vmware.com> wrote:
> >>     
> >>>    
> >>> Could we handle arch-specific gup.c in different patch sets and 
> >>> let these patches to merge to 4.4.y?
> >>   
> >> Vlastimil, please suggest if it's fine to merge these patches to 4.4.y
> >
> > I'm not sure if it makes much sense to merge them without the arch-specific gup
> > support, when we're aware that it's missing.
> >
> >> and handle arch-specific gup.c in different patch sets starts from 4.19.y,
> >
> > Actually arch-specific gup.c were removed in 4.13, so it's enough to start from
> > 4.9.y, which I'm going to finally look into.
> 
> Yes x86 gup.c is removed. s390 gup.c is present till 4.19,
> so if you are making changes in this file for 4.4.y and 4.9.y, 
> then same should be done for 4.14.y and v4.19.y.

Ok, I have no idea what to do here.  I have two different series from
both of you, yet they are different.

Can you both come up with a series you agree on, and send it to me, with
both of your acks so that I know this is what should be applied?  I've
deleted both of your current series from my todo mbox.

thanks,

greg k-h
