Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 533BD3C995D
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 09:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238623AbhGOHKL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 03:10:11 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:44002 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbhGOHKL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Jul 2021 03:10:11 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id EBF172292F;
        Thu, 15 Jul 2021 07:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1626332837; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DFsUtJ17KHHtWxUVtx62qG9GY1yWDatZDs8op1OeviY=;
        b=DahMB1c2Od0W5CpVg1fAErr8ZKmk2R8ZjPIdFOjX3c+UeGXdgROruf1h5cmLzw8k9nkG5V
        5tFlXzemgUIR6Xk75QNuoul8ZJS7ze/CdN2ECNeOL7ype9A+mhpCNpAhEl/BqoNhuBsPlX
        O6TlQ6tnRZPF/KMW6iW8EzpvCFHhl1w=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id BA3C1A3B9D;
        Thu, 15 Jul 2021 07:07:16 +0000 (UTC)
Date:   Thu, 15 Jul 2021 09:07:16 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org
Subject: Re: 5.13.2-rc and others have many not for stable
Message-ID: <YO/epN5unwgoQPdf@dhcp22.suse.cz>
References: <2b1b798e-8449-11e-e2a1-daf6a341409b@google.com>
 <YO0zXVX9Bx9QZCTs@kroah.com>
 <20210713182813.2fdd57075a732c229f901140@linux-foundation.org>
 <YO6X2og4mzqAEwJn@dhcp22.suse.cz>
 <YO8DJkVzHFmPv6vz@sashalap>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YO8DJkVzHFmPv6vz@sashalap>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed 14-07-21 11:30:46, Sasha Levin wrote:
> On Wed, Jul 14, 2021 at 09:52:58AM +0200, Michal Hocko wrote:
> > On Tue 13-07-21 18:28:13, Andrew Morton wrote:
> > > At present this -stable
> > > promiscuity is overriding the (sometime carefully) considered decisions
> > > of the MM developers, and that's a bit scary.
> > 
> > Not only scary, it is also a waste of precious time of those who
> > carefuly evaluate stable tree backports.
> 
> I'm just as concerned with the other direction: we end up missing quite
> a lot of patches that are needed in practice, and no one is circling
> back to make sure that we have everything we need.
> 
> I took a peek at SUSE's tree to see how things work there, and looking
> at the very latest mm/ commit:
> 
> commit c8c7b321edcf7a7e8c22dc66e0366f72aa2390f0
> Author: Michal Koutný <mkoutny@suse.com>
> Date:   Tue May 4 11:12:10 2021 +0200
> 
>     mm: memcontrol: fix cpuhotplug statistics flushing
>     (bsc#1185606).
>     suse-commit: 3bba386a33fac144abf2507554cb21552acb16af
> 
> This seems to be commit a3d4c05a4474 ("mm: memcontrol: fix cpuhotplug
> statistics flushing") upstream, and I assume that it was picked because
> it fixed a real bug someone cares about.

Nope. It has been identified as potentially useful/nice to have. There
was no actual bug report requiring it. We do that a lot. In fact we do
have a full infrastructure around git fixes and backport fixes
proactively. Mostly because stable tree, which we used to track in the
past, has turned out to be overwhelming with questionable/risky
backports. The thing, though, is that those fixes are carefully reviewed
by a domain expert before backporting. 

> I can maybe understand that at the time that the patch was
> written/committed it didn't seem like stable@ material and thus there
> was no cc to stable.
> 
> But once someone realized it needs to be backported, why weren't we told
> to take it into stable too?

We tend to do that for many real bug reports.
-- 
Michal Hocko
SUSE Labs
