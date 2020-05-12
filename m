Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 719261CF21A
	for <lists+stable@lfdr.de>; Tue, 12 May 2020 12:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726193AbgELKFS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 May 2020 06:05:18 -0400
Received: from mga12.intel.com ([192.55.52.136]:44925 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726187AbgELKFR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 May 2020 06:05:17 -0400
IronPort-SDR: MdMTjn7tE3JwPGoCHB1y52ncCRIYQ/y5HdRFuhuPRP+20Jnzbrbj5KNUmVMohziIQNisHLqHXm
 GV8/hCjPm8aQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2020 03:05:17 -0700
IronPort-SDR: UpOceRC9Yf3sV+OOnBzSOUIv+XJOQ0VnhDNZFNvak+OTJIG3sWvAo5DYaS/9yDY1RE/T5rTW+I
 /O4OtCPkAhgA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,383,1583222400"; 
   d="scan'208";a="251423804"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga007.fm.intel.com with ESMTP; 12 May 2020 03:05:13 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id 17DEB179; Tue, 12 May 2020 13:05:12 +0300 (EEST)
Date:   Tue, 12 May 2020 13:05:12 +0300
From:   "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To:     "Luck, Tony" <tony.luck@intel.com>
Cc:     Andy Shevchenko <andriy.shevchenko@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "linux-drivers-review@eclists.intel.com" 
        <linux-drivers-review@eclists.intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [linux-drivers-review] [PATCH] x86/mm: Fix boot with some memory
 above MAXMEM
Message-ID: <20200512100512.nqovrzouvdw2b4dq@black.fi.intel.com>
References: <20200511163706.41619-1-kirill.shutemov@linux.intel.com>
 <4db011da-35b4-c6c0-aa35-54a28776169b@intel.com>
 <20200511170419.a53lgasfxd33nrk7@black.fi.intel.com>
 <5f95e4c2-66fe-42a0-f09f-cb902cd6db9a@intel.com>
 <3908561D78D1C84285E8C5FCA982C28F7F61FEF4@ORSMSX115.amr.corp.intel.com>
 <20200511184330.fbxjbnho4tzkukry@black.fi.intel.com>
 <3908561D78D1C84285E8C5FCA982C28F7F6200F3@ORSMSX115.amr.corp.intel.com>
 <20200511211925.GQ185537@smile.fi.intel.com>
 <20200512005001.GA27126@agluck-desk2.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512005001.GA27126@agluck-desk2.amr.corp.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 11, 2020 at 05:50:01PM -0700, Luck, Tony wrote:
> On Tue, May 12, 2020 at 12:19:25AM +0300, Andy Shevchenko wrote:
> > On Mon, May 11, 2020 at 06:58:21PM +0000, Luck, Tony wrote:
> > > >> > +		pr_err("%lldMB of physical memory is not addressable in the paging mode\n",
> > > >> > +		       not_addressable >> 20);
> > > >> 
> > > >> Is "MB" the right unit for this. The problem seems to happen for systems with >64TB ... I doubt
> > > >> the unaddressable memory is just a couple of MBbytes
> > > >
> > > > Change it to GB?
> > > 
> > > I think it would be more readable.
> > > 
> > > [Maybe Linux needs a magic %p{something} that does auto-sizing to print in the most appropriate out of KB, MB, GB, TB, PB?]
> > 
> > We have one in string_helpers.c.
> 
> Ah, nice.  So:
> 
> #include <linux/string_helpers.h>
> 
> 
> 	char	tmp[10]; /* Bother, no #define for this, just a comment in string_helpers.c */
> 
> 
> 	string_get_size(not_addressable, 1, STRING_UNITS_2, tmp, sizeof(tmp);
> 
> 	pr_err("%s of physical memory is not addressable in the paging mode\n", tmp);

I've already submitted the patch upstream. I'll add it if a new revision
is needed.

-- 
 Kirill A. Shutemov
