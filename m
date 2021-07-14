Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6B23C8778
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 17:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232360AbhGNPdj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 11:33:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:36742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232419AbhGNPdj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 11:33:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A22C6613C5;
        Wed, 14 Jul 2021 15:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626276647;
        bh=LrE32zCSfmq/HRGIAaJzLKDx2mJFgMfjgbIdQislivY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FUl5UN8dZ9XIhWJFag+7K4uDQ0/dveCjPpqaDCPzRJGQ0guJ4Sae3MwiD9A7Fq5bX
         BJ4cMJSaUGUY4MIZvj5HynHIIvncT4gxhpEfJGGX081P2wEr5BSJNt9SrKtqhtlFIY
         /8oxG1D+PCj5OylvXStbfCLqOyPrLZSnRXg+6XZQKtDsgssf+/lvR7FhmIBaPN74f2
         4iElhFqmNkuRRIvcK+MV6cgKyGN8Rnz/Zi8DTF1SVS58gCJ5gjwJYiPsrS0l/JuErk
         XPegBFYCzeWPtvqYD3kajGdsx2bdjgfO14Yf20hq7ENx1bk8modZCz/YfnKRjpk7n1
         CRggQx51iMyyA==
Date:   Wed, 14 Jul 2021 11:30:46 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Michal Hocko <mhocko@suse.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org
Subject: Re: 5.13.2-rc and others have many not for stable
Message-ID: <YO8DJkVzHFmPv6vz@sashalap>
References: <2b1b798e-8449-11e-e2a1-daf6a341409b@google.com>
 <YO0zXVX9Bx9QZCTs@kroah.com>
 <20210713182813.2fdd57075a732c229f901140@linux-foundation.org>
 <YO6X2og4mzqAEwJn@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YO6X2og4mzqAEwJn@dhcp22.suse.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 14, 2021 at 09:52:58AM +0200, Michal Hocko wrote:
>On Tue 13-07-21 18:28:13, Andrew Morton wrote:
>> At present this -stable
>> promiscuity is overriding the (sometime carefully) considered decisions
>> of the MM developers, and that's a bit scary.
>
>Not only scary, it is also a waste of precious time of those who
>carefuly evaluate stable tree backports.

I'm just as concerned with the other direction: we end up missing quite
a lot of patches that are needed in practice, and no one is circling
back to make sure that we have everything we need.

I took a peek at SUSE's tree to see how things work there, and looking
at the very latest mm/ commit:

commit c8c7b321edcf7a7e8c22dc66e0366f72aa2390f0
Author: Michal Koutný <mkoutny@suse.com>
Date:   Tue May 4 11:12:10 2021 +0200

     mm: memcontrol: fix cpuhotplug statistics flushing
     (bsc#1185606).
     
     suse-commit: 3bba386a33fac144abf2507554cb21552acb16af

This seems to be commit a3d4c05a4474 ("mm: memcontrol: fix cpuhotplug
statistics flushing") upstream, and I assume that it was picked because
it fixed a real bug someone cares about.

I can maybe understand that at the time that the patch was
written/committed it didn't seem like stable@ material and thus there
was no cc to stable.

But once someone realized it needs to be backported, why weren't we told
to take it into stable too?

-- 
Thanks,
Sasha
