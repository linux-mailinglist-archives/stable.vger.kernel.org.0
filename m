Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 964441CE134
	for <lists+stable@lfdr.de>; Mon, 11 May 2020 19:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730696AbgEKRHI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 May 2020 13:07:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:50936 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730629AbgEKRHI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 May 2020 13:07:08 -0400
IronPort-SDR: pDbvD0uMcg/x/IlagtnidwGm3JZcLUHc+NF7ZGVLtgyY5usuTii/NUUvC9+iN3W/W5AWNXmA66
 EeyPQWBFo0LA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2020 10:07:07 -0700
IronPort-SDR: 7/oA5vhywTnd1asbNL18FNnpZP5V1n6TRoGoB56ac1kHWkkL6M4h3KpGho8HMf0BXBG0Hpfe8/
 5bvbXyskrlCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,380,1583222400"; 
   d="scan'208";a="261830308"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga003.jf.intel.com with ESMTP; 11 May 2020 10:07:05 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id F20E2101; Mon, 11 May 2020 20:07:04 +0300 (EEST)
Date:   Mon, 11 May 2020 20:07:04 +0300
From:   "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To:     "Hansen, Dave" <dave.hansen@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>, dave.hansen@linux.intel.com,
        linux-drivers-review@eclists.intel.com, stable@vger.kernel.org
Subject: Re: [linux-drivers-review] [PATCH] x86/mm: Fix boot with some memory
 above MAXMEM
Message-ID: <20200511170704.iu3utuarnskd747d@black.fi.intel.com>
References: <20200511163706.41619-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200511163706.41619-1-kirill.shutemov@linux.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 11, 2020 at 07:37:06PM +0300, Kirill A. Shutemov wrote:
> A 5-level paging capable machine can have memory above 46-bit in the
> physical address space. This memory is only addressable in the 5-level
> paging mode: we don't have enough virtual address space to create direct
> mapping for such memory in the 4-level paging mode.
> 
> Currently, we fail boot completely: NULL pointer dereference in
> subsection_map_init().
> 
> Skip creating a memblock for such memory instead and notify user that
> some memory is not addressable.
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: stable@vger.kernel.org # v4.14
> ---
> 
> Tested with a hacked QEMU: https://gist.github.com/kiryl/d45eb54110944ff95e544972d8bdac1d

BTW, I was only able to boot with legacy SeaBIOS, not with OVMF. No idea
why.

-- 
 Kirill A. Shutemov
