Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF6F1206B14
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 06:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727056AbgFXEZp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 00:25:45 -0400
Received: from mga14.intel.com ([192.55.52.115]:64658 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726389AbgFXEZp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jun 2020 00:25:45 -0400
IronPort-SDR: Ea8TuLErRqPk/0hXor9KeStypJUZoOC6+msJfmX2XAkKwMeyKY/Odil5ZaZQ0gXfLJQ4mVlb1g
 ljKT/yu/uySQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9661"; a="143427741"
X-IronPort-AV: E=Sophos;i="5.75,273,1589266800"; 
   d="scan'208";a="143427741"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2020 21:25:44 -0700
IronPort-SDR: hIPrFEUvtyOdS6Jt/Xrmz72tsK/qgvvKKa9ktjVGEgx2I32MXaWCEkBuyW2p32uQ7bI3B05Vko
 ujYyoEX/S0ZA==
X-IronPort-AV: E=Sophos;i="5.75,273,1589266800"; 
   d="scan'208";a="279346643"
Received: from agluck-desk2.sc.intel.com (HELO agluck-desk2.amr.corp.intel.com) ([10.3.52.68])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2020 21:25:43 -0700
Date:   Tue, 23 Jun 2020 21:25:42 -0700
From:   "Luck, Tony" <tony.luck@intel.com>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     akpm@linux-foundation.org, tglx@linutronix.de, mingo@redhat.com,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Borislav Petkov <bp@alien8.de>, stable@vger.kernel.org,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Erwin Tsaur <erwin.tsaur@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
Subject: Re: [PATCH v6 0/2] Renovate memcpy_mcsafe with copy_mc_to_{user,
 kernel}
Message-ID: <20200624042542.GA30842@agluck-desk2.amr.corp.intel.com>
References: <159244031857.1107636.5054974045023236143.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159244031857.1107636.5054974045023236143.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 17, 2020 at 05:31:58PM -0700, Dan Williams wrote:
> No changes since v5 [1], just rebased to v5.8-rc1. No comments since
> that posting back at the end of May either, will continue to re-post
> weekly, I am otherwise at a loss for what else to do to move this
> forward. Should it go through Andrew since it's across PPC and x86?
> Thanks again to Michael for the PPC acks.
> 
> [1]: http://lore.kernel.org/r/159062136234.2192412.7285856919306307817.stgit@dwillia2-desk3.amr.corp.intel.com
> 
> ---
> 
> The primary motivation to go touch memcpy_mcsafe() is that the existing
> benefit of doing slow "handle with care" copies is obviated on newer
> CPUs. With that concern lifted it also obviates the need to continue to
> update the MCA-recovery capability detection code currently gated by
> "mcsafe_key". Now the old "mcsafe_key" opt-in to perform the copy with
> concerns for recovery fragility can instead be made an opt-out from the
> default fast copy implementation (enable_copy_mc_fragile()).
> 
> The discussion with Linus on the first iteration of this patch
> identified that memcpy_mcsafe() was misnamed relative to its usage. The
> new names copy_mc_to_user() and copy_mc_to_kernel() clearly indicate the
> intended use case and lets the architecture organize the implementation
> accordingly.
> 
> For both powerpc and x86 a copy_mc_generic() implementation is added as
> the backend for these interfaces.
> 
> Patches are relative to v5.8-rc1. It has a recent build success
> notification from the kbuild robot and is passing local nvdimm tests.
> 

Looks good to me.   I tested on a Broadwell generation system (i.e.
one of the system you now list as "fragile") and injecting uncorrected
errors into buffers that are then copied using copy_mc_to_kernel()
result in recovered machine checks with the return value correctly
indicating the amount remaining.

Reviewed-by: Tony Luck <tony.luck@intel.com>

-Tony
