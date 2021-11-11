Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D344D44D064
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 04:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbhKKD3k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 22:29:40 -0500
Received: from mga12.intel.com ([192.55.52.136]:35483 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229931AbhKKD3j (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 22:29:39 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10164"; a="212869389"
X-IronPort-AV: E=Sophos;i="5.87,225,1631602800"; 
   d="scan'208";a="212869389"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2021 19:26:51 -0800
X-IronPort-AV: E=Sophos;i="5.87,225,1631602800"; 
   d="scan'208";a="452574508"
Received: from agluck-desk2.sc.intel.com (HELO agluck-desk2.amr.corp.intel.com) ([10.3.52.146])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2021 19:26:50 -0800
Date:   Wed, 10 Nov 2021 19:26:49 -0800
From:   "Luck, Tony" <tony.luck@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Reinette Chatre <reinette.chatre@intel.com>,
        dave.hansen@linux.intel.com, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, linux-sgx@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH V2] x86/sgx: Fix free page accounting
Message-ID: <YYyNeW28jqKwD0tF@agluck-desk2.amr.corp.intel.com>
References: <b2e69e9febcae5d98d331de094d9cc7ce3217e66.1636487172.git.reinette.chatre@intel.com>
 <8e0bb87f05b79317a06ed2d8ab5e2f5cf6132b6a.camel@kernel.org>
 <794a7034-f6a7-4aff-7958-b1bd959ced24@intel.com>
 <94df4c660532a6bf414b6bbd8e25c3ea2e4eda5b.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94df4c660532a6bf414b6bbd8e25c3ea2e4eda5b.camel@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 11, 2021 at 04:55:14AM +0200, Jarkko Sakkinen wrote:
> On Wed, 2021-11-10 at 10:51 -0800, Reinette Chatre wrote:
> > sgx_should_reclaim() would only succeed when sgx_nr_free_pages goes 
> > below the watermark. Once sgx_nr_free_pages becomes corrupted there is 
> > no clear way in which it can correct itself since it is only ever 
> > incremented or decremented.
> 
> So one scenario would be:
> 
> 1. CPU A does a READ of sgx_nr_free_pages.
> 2. CPU B does a READ of sgx_nr_free_pages.
> 3. CPU A does a STORE of sgx_nr_free_pages.
> 4. CPU B does a STORE of sgx_nr_free_pages.
> 
> ?
> 
> That does corrupt the value, yes, but I don't see anything like this
> in the commit message, so I'll have to check.
> 
> I think the commit message is lacking a concurrency scenario, and the
> current transcripts are a bit useless.

What about this part:

	With sgx_nr_free_pages accessed and modified from a few places
	it is essential to ensure that these accesses are done safely but
	this is not the case. sgx_nr_free_pages is read without any
	protection and updated with inconsistent protection by any one
	of the spin locks associated with the individual NUMA nodes.
	For example:

	      CPU_A                                 CPU_B
	      -----                                 -----
	 spin_lock(&nodeA->lock);              spin_lock(&nodeB->lock);
	 ...                                   ...
	 sgx_nr_free_pages--;  /* NOT SAFE */  sgx_nr_free_pages--;

	 spin_unlock(&nodeA->lock);            spin_unlock(&nodeB->lock);

Maybe you missed the "NOT SAFE" hidden in the middle of
the picture?

-Tony
