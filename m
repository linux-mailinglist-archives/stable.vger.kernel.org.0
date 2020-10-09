Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BEBC289BF1
	for <lists+stable@lfdr.de>; Sat, 10 Oct 2020 00:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392018AbgJIWu7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Oct 2020 18:50:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:43388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389409AbgJIWu6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Oct 2020 18:50:58 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DA05222EB;
        Fri,  9 Oct 2020 22:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602283857;
        bh=zcmB/pdpydbCgKBcPlaBkRATTHHSFEh+mhWUqm1eToM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HKkzyoIV5otAbM1mB0lNAjMilwTpPBpdQ1VIUp5kruHuS/yJ79W6djbNnWC8BTWkN
         cU1zEuiFy994wfhNta/RB5YOw21Sqv38bVgPtSszaB84k2dkPOftB7Hyx21TkfZgN6
         Kb4ynNbxddISq4R/yaEo6Cfpx27gJOdgEFPxzg18=
Date:   Fri, 9 Oct 2020 15:50:55 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Ralph Campbell <rcampbell@nvidia.com>
Cc:     <linux-mm@kvack.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        =?ISO-8859-1?Q?J=E9r=F4me?= Glisse <jglisse@redhat.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Ira Weiny <ira.weiny@intel.com>, <stable@vger.kernel.org>
Subject: Re: [PATCH] mm/memcg: fix device private memcg accounting
Message-Id: <20201009155055.f87de51ea04d4ea879e3981a@linux-foundation.org>
In-Reply-To: <20201009215952.2726-1-rcampbell@nvidia.com>
References: <20201009215952.2726-1-rcampbell@nvidia.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 9 Oct 2020 14:59:52 -0700 Ralph Campbell <rcampbell@nvidia.com> wrote:

> The code in mc_handle_swap_pte() checks for non_swap_entry() and returns
> NULL before checking is_device_private_entry() so device private pages
> are never handled.
> Fix this by checking for non_swap_entry() after handling device private
> swap PTEs.
> 
> Cc: stable@vger.kernel.org

I was going to ask "what are the end-user visible effects of the bug". 
This is important information with a cc:stable.

> 
> I'm not sure exactly how to test this. I ran the HMM self tests but
> that is a minimal sanity check. I think moving the self test from one
> memory cgroup to another while it is running would exercise this patch.
> I'm looking at how the test could move itself to another group after
> migrating some anonymous memory to the test driver.
> 

But this makes me suspect the answer is "there aren't any that we know
of".  Are you sure a cc:stable is warranted?

