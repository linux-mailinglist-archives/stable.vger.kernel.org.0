Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6617263EA6
	for <lists+stable@lfdr.de>; Thu, 10 Sep 2020 09:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729161AbgIJHXw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Sep 2020 03:23:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:54574 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730262AbgIJHXe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Sep 2020 03:23:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0AA18B165;
        Thu, 10 Sep 2020 07:23:48 +0000 (UTC)
Date:   Thu, 10 Sep 2020 09:23:31 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Laurent Dufour <ldufour@linux.ibm.com>
Cc:     akpm@linux-foundation.org, David Hildenbrand <david@redhat.com>,
        Oscar Salvador <osalvador@suse.de>, rafael@kernel.org,
        nathanl@linux.ibm.com, cheloha@linux.ibm.com,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: don't rely on system state to detect hot-plug
 operations
Message-ID: <20200910072331.GB28354@dhcp22.suse.cz>
References: <5cbd92e1-c00a-4253-0119-c872bfa0f2bc@redhat.com>
 <20200908170835.85440-1-ldufour@linux.ibm.com>
 <20200909074011.GD7348@dhcp22.suse.cz>
 <9faac1ce-c02d-7dbc-f79a-4aaaa5a73d28@linux.ibm.com>
 <20200909090953.GE7348@dhcp22.suse.cz>
 <4cdb54be-1a92-4ba4-6fee-3b415f3468a9@linux.ibm.com>
 <20200909105914.GF7348@dhcp22.suse.cz>
 <74a62b00-235e-7deb-2814-f3b240fea25e@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <74a62b00-235e-7deb-2814-f3b240fea25e@linux.ibm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed 09-09-20 18:07:15, Laurent Dufour wrote:
> Le 09/09/2020 à 12:59, Michal Hocko a écrit :
> > On Wed 09-09-20 11:21:58, Laurent Dufour wrote:
[...]
> > > For the point a, using the enum allows to know in
> > > register_mem_sect_under_node() if the link operation is due to a hotplug
> > > operation or done at boot time.
> > 
> > Yes, but let me repeat. We have a mess here and different paths check
> > for the very same condition by different ways. We need to unify those.
> 
> What are you suggesting to unify these checks (using a MP_* enum as
> suggested by David, something else)?

We do have system_state check spread at different places. I would use
this one and wrap it behind a helper. Or have I missed any reason why
that wouldn't work for this case?

-- 
Michal Hocko
SUSE Labs
