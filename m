Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86BD2442FEF
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 15:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbhKBOO4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 10:14:56 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:51434 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbhKBOOt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Nov 2021 10:14:49 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 9F4BA212C6;
        Tue,  2 Nov 2021 14:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1635862333; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zOgaJVxEip0PVqxzxEI60xVAoiPrv+jKDeYMfH5bsbQ=;
        b=Mt+wM1lcqW+lmIkB8/QM0Al6IlU3QQeWdMAh+xI6xaUeL1tTybspmIt8E3Wn2fKrj3dkBT
        P9w95XAL05OOIBLYzoN2v/hpUEwhjGLzd6jq4m6z0zotLHWP/WWGM8v7O+r82Or35l40E8
        vQ+EAK7ws6dFmq0M3ydaA+zon15sdm8=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 72B0FA3B83;
        Tue,  2 Nov 2021 14:12:13 +0000 (UTC)
Date:   Tue, 2 Nov 2021 15:12:12 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Alexey Makhalov <amakhalov@vmware.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Oscar Salvador <OSalvador@suse.com>
Subject: Re: [PATCH] mm: fix panic in __alloc_pages
Message-ID: <YYFHPGq/E9F11F7o@dhcp22.suse.cz>
References: <YYD/FkpAk5IvmOux@dhcp22.suse.cz>
 <b2e4a611-45a6-732a-a6d3-6042afd2af6e@redhat.com>
 <E34422F0-A44A-48FD-AE3B-816744359169@vmware.com>
 <b3908fce-6b07-8390-b691-56dd2f85c05f@redhat.com>
 <YYEkqH8l0ASWv/JT@dhcp22.suse.cz>
 <42abfba6-b27e-ca8b-8cdf-883a9398b506@redhat.com>
 <YYEun6s/mF9bE+rQ@dhcp22.suse.cz>
 <e7aed7c0-b7b1-4a94-f323-0bcde2f879d2@redhat.com>
 <YYE8L4gs8/+HH6bf@dhcp22.suse.cz>
 <ccf05348-e1b6-58a7-2626-701e60b662e6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ccf05348-e1b6-58a7-2626-701e60b662e6@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 02-11-21 14:41:25, David Hildenbrand wrote:
> On 02.11.21 14:25, Michal Hocko wrote:
[...]
> > Btw. do you plan to send a patch for pcp allocator to use cpu_to_mem?
> 
> You mean s/cpu_to_node/cpu_to_mem/ or also handling offline nids?

just cpu_to_mem

> cpu_to_mem() corresponds to cpu_to_node() unless on ia64+ppc IIUC, so it
> won't help for this very report.

Weird, x86 allows memory less nodes as well. But you are right
there is nothing selecting HAVE_MEMORYLESS_NODES neither do I see any
arch specific implementation. I have to say that I have forgot all those
nasty details... Sigh
-- 
Michal Hocko
SUSE Labs
