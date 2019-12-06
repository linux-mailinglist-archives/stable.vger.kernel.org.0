Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0171150CB
	for <lists+stable@lfdr.de>; Fri,  6 Dec 2019 14:05:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbfLFNFI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Dec 2019 08:05:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:58886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726168AbfLFNFH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Dec 2019 08:05:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13FF521835;
        Fri,  6 Dec 2019 13:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575637507;
        bh=RNg+zLEFc3CkEl5tzIKiNU62sxIhgiG6gkgRSZegPXw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2F3tsf+OH84WnQyV7z+FNLjD81BIgqkVT+qQXYrLBRLDy5ml7Zwetcv19aH2l3NH+
         /jI/rtDw6/iN9uifS/W71B/QVu4aEFkph8ibHWcxROYbw3EvklGg2fKoIUzxAMqxca
         hGXSGwaCZCt+aXnC3bHl8Z+Z6A20reX7XsQF9X3E=
Date:   Fri, 6 Dec 2019 14:05:05 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>, Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Qian Cai <cai@lca.pw>, Michal Hocko <mhocko@suse.com>,
        Oscar Salvador <osalvador@suse.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 4.19 226/321] mm/hotplug: invalid PFNs from
 pfn_to_online_page()
Message-ID: <20191206130505.GD1399220@kroah.com>
References: <20191203223427.103571230@linuxfoundation.org>
 <20191203223438.874783822@linuxfoundation.org>
 <20191205221452.GB25107@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191205221452.GB25107@duo.ucw.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 05, 2019 at 11:14:52PM +0100, Pavel Machek wrote:
> Hi!
> 
> > This is due to the commit 9f1eb38e0e11 ("mm, kmemleak: little
> > optimization while scanning") starts to use pfn_to_online_page() instead
> > of pfn_valid().  However, in the CONFIG_MEMORY_HOTPLUG=y case,
> > pfn_to_online_page() does not call memblock_is_map_memory() while
> > pfn_valid() does.
> ...
> > Fixes: 9f1eb38e0e11 ("mm, kmemleak: little optimization while scanning")
> 
> Commit 9f1eb38e0e11 does not seem to be in v4.19-stable tree. Is this
> commit still neccessary/good idea?

Good catch.

Sasha, should this be reverted?  How did your scripts pick this?

thanks,

greg k-h
