Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABC15200031
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 04:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729709AbgFSC2Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 22:28:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:53038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728443AbgFSC2Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jun 2020 22:28:24 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E19720773;
        Fri, 19 Jun 2020 02:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592533703;
        bh=mMJPY/Cz0rLgT2eFhf4t429DS1YMNMShb3wEVQQdNU8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2ewx2L3HGHsPBD7pvRUzhsIsPDR5Y+e5DuajFYcsAtBPAo6Fbc8sWYtXlzAvzNyms
         KzVWtJC50Jw8k3nLdz+6ON64E69g8SCBCTAXx0y8U58/WBJ4hze0EWkpDiTDUPodkA
         S2pnVgCwtCwuXNb13rKtJ7VFtPVdcbklCKp7Hesc=
Date:   Thu, 18 Jun 2020 22:28:22 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     pasha.tatashin@soleen.com, akpm@linux-foundation.org,
        dan.j.williams@intel.com, daniel.m.jordan@oracle.com,
        david@redhat.com, jmorris@namei.org, ktkhai@virtuozzo.com,
        mhocko@suse.com, pankaj.gupta.linux@gmail.com,
        shile.zhang@linux.alibaba.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz, yiwei@redhat.com
Subject: Re: FAILED: patch "[PATCH] mm: call cond_resched() from
 deferred_init_memmap()" failed to apply to 5.7-stable tree
Message-ID: <20200619022822.GV1931@sasha-vm>
References: <15924957437531@kroah.com>
 <20200618162649.GA250996@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200618162649.GA250996@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 18, 2020 at 06:26:49PM +0200, Greg KH wrote:
>On Thu, Jun 18, 2020 at 05:55:43PM +0200, gregkh@linuxfoundation.org wrote:
>>
>> The patch below does not apply to the 5.7-stable tree.
>> If someone wants it applied there, or to any other stable or longterm
>> tree, then please email the backport, including the original git commit
>> id to <stable@vger.kernel.org>.
>
>Oops, I applied things out of order, I've queued this and the 5.4
>version up, but 4.19 doesn't apply as the dependant patch does not
>apply.

Something like this should work?

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 7181dfe76440..b7905a075e79 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1611,11 +1611,13 @@ static int __init deferred_init_memmap(void *data)
		spfn = max_t(unsigned long, first_init_pfn, PFN_UP(spa));
		epfn = min_t(unsigned long, zone_end_pfn(zone), PFN_DOWN(epa));
		nr_pages += deferred_init_pages(nid, zid, spfn, epfn);
+		cond_resched();
	}
	for_each_free_mem_range(i, nid, MEMBLOCK_NONE, &spa, &epa, NULL) {
		spfn = max_t(unsigned long, first_init_pfn, PFN_UP(spa));
		epfn = min_t(unsigned long, zone_end_pfn(zone), PFN_DOWN(epa));
		deferred_free_pages(nid, zid, spfn, epfn);
+		cond_resched();
	}

	/* Sanity check that the next zone really is unpopulated */

-- 
Thanks,
Sasha
