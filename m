Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3446BE564E
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 23:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725899AbfJYV62 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 17:58:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:35712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725801AbfJYV62 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Oct 2019 17:58:28 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD05B21D7F;
        Fri, 25 Oct 2019 21:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572040707;
        bh=5idHqzI+WDLhPVhG4vI2ZMChGI3hQGDJ+ZfGRxe0PSk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=V7hXa31Uos3d+7DomJcDHCsK1tAEa/hKrzpZ6JVU5sh0ejVGcV6AYpTNCCfKj0yGH
         9L8NB8JihQZ5Uyo2PehT1vpnOs5+87csqN2nTpkxTNJhNy3nwJy0cf1Q8phBhOyjl5
         UIJUHjZz7Qk49FHME8WpQam7ERAEwn2uFD/6TQvE=
Date:   Fri, 25 Oct 2019 14:58:26 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Michal Hocko <mhocko@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Waiman Long <longman@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Roman Gushchin <guro@fb.com>,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Jann Horn <jannh@google.com>, Song Liu <songliubraving@fb.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rafael Aquini <aquini@redhat.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@suse.com>,
        David Rientjes <rientjes@google.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH 1/2] mm, vmstat: hide /proc/pagetypeinfo from normal
 users
Message-Id: <20191025145826.acfd34f4eaec65f0525ac40b@linux-foundation.org>
In-Reply-To: <be14e3c1-41bb-6727-52a1-fcf72f5caef6@suse.cz>
References: <20191025072610.18526-1-mhocko@kernel.org>
        <20191025072610.18526-2-mhocko@kernel.org>
        <be14e3c1-41bb-6727-52a1-fcf72f5caef6@suse.cz>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 25 Oct 2019 09:33:26 +0200 Vlastimil Babka <vbabka@suse.cz> wrote:

> On 10/25/19 9:26 AM, Michal Hocko wrote:
> > From: Michal Hocko <mhocko@suse.com>
> > 
> > /proc/pagetypeinfo is a debugging tool to examine internal page
> > allocator state wrt to fragmentation. It is not very useful for
> > any other use so normal users really do not need to read this file.
> > 
> > Waiman Long has noticed that reading this file can have negative side
> > effects because zone->lock is necessary for gathering data and that
> > a) interferes with the page allocator and its users and b) can lead to
> > hard lockups on large machines which have very long free_list.
> > 
> > Reduce both issues by simply not exporting the file to regular users.
> > 
> > Reported-by: Waiman Long <longman@redhat.com>
> > Cc: stable
> 
> Cc: <stable@vger.kernel.org>

As we don't really know how much damage this will cause, it would be
nice to let it bake in mainline for a month or three before committing
it to the -stable trees.  But we don't have a process for that, apart
from remembering to poke Greg at a suitable date.

Oh well.  I guess that if someone is truly harmed by this change, they
can just chmod /proc/pagetypeinfo back to 0444.
