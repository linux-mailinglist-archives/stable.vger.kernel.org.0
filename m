Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA352F95BA
	for <lists+stable@lfdr.de>; Sun, 17 Jan 2021 23:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729956AbhAQWC0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jan 2021 17:02:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:58926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729550AbhAQWCY (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 17 Jan 2021 17:02:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A339920770;
        Sun, 17 Jan 2021 22:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610920904;
        bh=syw3C+yi+MfIAsKsarxDn5CIv+WBNQ1M+WvC9IOMFT0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=z9UWtErkwTPaE9iJ/e6FJXucATo+qe58tJGsr8k3lobCCopZfYhtGyFtBlcooJR7H
         3MNfOmc3VwhSLYyHiIWqsJ8vJTqMAsaQUBlVrAdJazF72qPbFcDQ38Z9sMFPZD+1q2
         ifjtpfMSbB3+cIjwdZ27dFCJ6CcO9Jqk8nbC1GNU=
Date:   Sun, 17 Jan 2021 14:01:42 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Naoya Horiguchi <nao.horiguchi@gmail.com>,
        Michal Hocko <mhocko@kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Oscar Salvador <osalvador@suse.de>, stable@vger.kernel.org,
        linux-mm@kvack.org, linux-nvdimm@lists.01.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 4/5] mm: Fix page reference leak in
 soft_offline_page()
Message-Id: <20210117140142.ab91797266e0bef6b7dba9f9@linux-foundation.org>
In-Reply-To: <161058501210.1840162.8108917599181157327.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <161058499000.1840162.702316708443239771.stgit@dwillia2-desk3.amr.corp.intel.com>
        <161058501210.1840162.8108917599181157327.stgit@dwillia2-desk3.amr.corp.intel.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 13 Jan 2021 16:43:32 -0800 Dan Williams <dan.j.williams@intel.com> wrote:

> The conversion to move pfn_to_online_page() internal to
> soft_offline_page() missed that the get_user_pages() reference taken by
> the madvise() path needs to be dropped when pfn_to_online_page() fails.
> Note the direct sysfs-path to soft_offline_page() does not perform a
> get_user_pages() lookup.
> 
> When soft_offline_page() is handed a pfn_valid() &&
> !pfn_to_online_page() pfn the kernel hangs at dax-device shutdown due to
> a leaked reference.
> 
> Fixes: feec24a6139d ("mm, soft-offline: convert parameter to pfn")
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
> Cc: Michal Hocko <mhocko@kernel.org>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Oscar Salvador <osalvador@suse.de>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

A cc:stable patch in the middle is awkward.  I'll make this a
standalone patch for merging into mainline soon (for 5.11) and shall
turn the rest into a 4-patch series, OK?

