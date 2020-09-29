Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45CC427BD6E
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 08:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725776AbgI2GzK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 02:55:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:50150 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgI2GzK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 02:55:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1601362508;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kFYu5xJzDawvBAsBW8M/X+65x9wkUxCZnjOlwhAOe+4=;
        b=eNJmfioAPkH849P8Qsy/inkjnkjfDSoSN9X698/PQTJY+6RWqF191MR+5CLxKctgrcnYpc
        RdNepUo8VVKAgyob3/s/E7pWK+NFKkcLnE0cOJ5ahlvzzgrQHR9y3YoPHbnCEiwpKeXr72
        QnX6AqmSNVrzbMBbZpYlUOPX9qYBk6Y=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 85EBCAA55;
        Tue, 29 Sep 2020 06:55:08 +0000 (UTC)
Date:   Tue, 29 Sep 2020 08:55:07 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>, cheloha@linux.ibm.com,
        David Hildenbrand <david@redhat.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ldufour@linux.ibm.com, Linux-MM <linux-mm@kvack.org>,
        mm-commits@vger.kernel.org, nathanl@linux.ibm.com,
        Oscar Salvador <osalvador@suse.de>,
        Rafael Wysocki <rafael@kernel.org>,
        stable <stable@vger.kernel.org>, Tony Luck <tony.luck@intel.com>
Subject: Re: [patch 8/9] mm: replace memmap_context by meminit_context
Message-ID: <20200929065507.GA22035@dhcp22.suse.cz>
References: <20200925211725.0fea54be9e9715486efea21f@linux-foundation.org>
 <20200926041928.9xJHGgkah%akpm@linux-foundation.org>
 <CAHk-=wjcg4ni8_zhGDS9vTQQYM-3ZBg4hGF7Ot9MzW5F2o7mpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjcg4ni8_zhGDS9vTQQYM-3ZBg4hGF7Ot9MzW5F2o7mpA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat 26-09-20 10:32:15, Linus Torvalds wrote:
> The explanations here do not make sense.
> 
> On Fri, Sep 25, 2020 at 9:19 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> >
> > There are 2 issues here:
> >
> > a. The sysfs memory and node's layouts are broken due to these multiple
> >    links
> >
> > b. The link errors in link_mem_sections() should not lead to a system
> >    panic.
> >
> > To address a. register_mem_sect_under_node should not rely on the system
> > state to detect whether the link operation is triggered by a hot plug
> > operation or not. This is addressed by the patches 1 and 2 of this series.
> >
> > The patch 3 is addressing the point b.
> >
> > This patch (of 2):
> >
> > The memmap_context enum is used to detect whether a memory operation is due
> > to a hot-add operation or happening at boot time.
> >
> > Make it general to the hotplug operation and rename it as meminit_context.
> >
> > There is no functional change introduced by this patch
> 
> So far so good.
> 
> But there is no "patch 3" that addresses point (b) in this series.
> 
> I see it on lore, but it's not part of what actually got sent to me,
> so the commit message for patch 1 now makes no sense any more.

You are right. There should be patch 2 posted as well. And I would argue
that the 3rd patch should go in with them as well. This is a preparatory
patch only.
-- 
Michal Hocko
SUSE Labs
