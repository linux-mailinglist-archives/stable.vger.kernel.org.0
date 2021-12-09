Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCE146E921
	for <lists+stable@lfdr.de>; Thu,  9 Dec 2021 14:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237956AbhLINct (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 08:32:49 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:51962 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231508AbhLINct (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Dec 2021 08:32:49 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 818A51F384;
        Thu,  9 Dec 2021 13:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1639056554; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qmqs+hpSxscaHl8NkKgzAtr87Qun/Wys2qUlkbqxvvQ=;
        b=HLosNG5dXKEUH6TVpU+Aokzdig6nCGS8xKykm9/jd1ut7F9zBZHVqkyVYBJ2ucSR6oS6W3
        BSmB6ZF9ITfnX48UGgW30cpIZqF2dbWRhNCvcUg9e7gydgJSUkm7Ac3xGO7FnRfBGBabLA
        dadsoCaq5DqSU0jBg3/NSBjK6ipBUpg=
Received: from suse.cz (unknown [10.163.30.174])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 51DF7A3B91;
        Thu,  9 Dec 2021 13:29:14 +0000 (UTC)
Date:   Thu, 9 Dec 2021 14:29:13 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     Alexey Makhalov <amakhalov@vmware.com>
Cc:     Dennis Zhou <dennis@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Oscar Salvador <osalvador@suse.de>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v3] mm: fix panic in __alloc_pages
Message-ID: <YbIEqflrP/vxIsXZ@dhcp22.suse.cz>
References: <YZN3ExwL7BiDS5nj@dhcp22.suse.cz>
 <5239D699-523C-4F0C-923A-B068E476043E@vmware.com>
 <YZYQUn10DrKhSE7L@dhcp22.suse.cz>
 <Ya89aqij6nMwJrIZ@dhcp22.suse.cz>
 <YbBywDwc2bCxWGAQ@dhcp22.suse.cz>
 <77BCF61E-224F-435D-8620-670C9E874A9A@vmware.com>
 <YbHCT1r7NXyIvpsS@dhcp22.suse.cz>
 <2291C572-3B22-4BE5-8C7A-0D6A4609547B@vmware.com>
 <YbHS2qN4wY+1hWZp@dhcp22.suse.cz>
 <B5B3BCE0-853B-444E-BAD8-823CEE8A3E59@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B5B3BCE0-853B-444E-BAD8-823CEE8A3E59@vmware.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 09-12-21 10:23:52, Alexey Makhalov wrote:
> 
> 
> > On Dec 9, 2021, at 1:56 AM, Michal Hocko <mhocko@suse.com> wrote:
> > 
> > On Thu 09-12-21 09:28:55, Alexey Makhalov wrote:
> >> 
> >> 
> >> [    0.081777] Node 4 uninitialized by the platform. Please report with boot dmesg.
> >> [    0.081790] Initmem setup node 4 [mem 0x0000000000000000-0x0000000000000000]
> >> ...
> >> [    0.086441] Node 127 uninitialized by the platform. Please report with boot dmesg.
> >> [    0.086454] Initmem setup node 127 [mem 0x0000000000000000-0x0000000000000000]
> > 
> > Interesting that only those two didn't get a proper arch specific
> > initialization. Could you check why? I assume init_cpu_to_node
> > doesn't see any CPU pointing at this node. Wondering why that would be
> > the case but that can be a bug in the affinity tables.
> 
> My bad shrinking. Not just these 2, but all possible and not present nodes from 4 to 127
> are having this message.

Does that mean that your possible (but offline) cpus do not set their
affinity?
-- 
Michal Hocko
SUSE Labs
