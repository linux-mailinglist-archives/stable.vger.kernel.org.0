Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7144C46E485
	for <lists+stable@lfdr.de>; Thu,  9 Dec 2021 09:46:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232634AbhLIItm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 03:49:42 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:53150 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbhLIItm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Dec 2021 03:49:42 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id EEA68210FB;
        Thu,  9 Dec 2021 08:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1639039567; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LdaRLyAcpzh2mvaBy6NuiwpxJ1+QK8t1DTA+skefRhE=;
        b=ExHgqJ0kn0EP76XCdsyjjtRQnlSzdj8+QJ2RZvGS1DPq9ieQPuT0sYZlaOFRSh7BBBv1jb
        IlSnBRdYjJM2R02g1teVLrIDLX45vlDmzpYrCt6zniIV3Q3picNMmhwR+khs/uZ4I+Xgd6
        /dX8LpVyCWVIyp2nk+trJom5gKHYh5E=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 7F492A3B85;
        Thu,  9 Dec 2021 08:46:07 +0000 (UTC)
Date:   Thu, 9 Dec 2021 09:46:07 +0100
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
Message-ID: <YbHCT1r7NXyIvpsS@dhcp22.suse.cz>
References: <YYqstfX8PSGDfWsn@dhcp22.suse.cz>
 <YYrGpn/52HaLCAyo@fedora>
 <YYrSC7vtSQXz652a@dhcp22.suse.cz>
 <BAE95F0C-FAA7-40C6-A0D6-5049B1207A27@vmware.com>
 <YZN3ExwL7BiDS5nj@dhcp22.suse.cz>
 <5239D699-523C-4F0C-923A-B068E476043E@vmware.com>
 <YZYQUn10DrKhSE7L@dhcp22.suse.cz>
 <Ya89aqij6nMwJrIZ@dhcp22.suse.cz>
 <YbBywDwc2bCxWGAQ@dhcp22.suse.cz>
 <77BCF61E-224F-435D-8620-670C9E874A9A@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77BCF61E-224F-435D-8620-670C9E874A9A@vmware.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 09-12-21 02:16:17, Alexey Makhalov wrote:
> This patch calls alloc_percpu() from setup_arch() while percpu
> allocator is not yet initialized (before setup_per_cpu_areas()).

Yeah, I haven't realized the pcp is not available. I was not really sure
about that. Could you try with the alloc_percpu dropped?

Thanks for testing!
-- 
Michal Hocko
SUSE Labs
