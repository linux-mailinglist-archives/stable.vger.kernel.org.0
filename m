Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F15411CE9C4
	for <lists+stable@lfdr.de>; Tue, 12 May 2020 02:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727886AbgELAuD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 May 2020 20:50:03 -0400
Received: from mga03.intel.com ([134.134.136.65]:14952 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726106AbgELAuD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 May 2020 20:50:03 -0400
IronPort-SDR: k0buGcKCcGM+Y0yGJFu7Fz1U78+jL+rHFIfNjI/qaYDQcUsK6e0nhP19aZ+hhFA3encAsJwVh5
 Yjoi7evNpchQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2020 17:50:03 -0700
IronPort-SDR: Rwc16MeE1V1RHo+BdcYzeEgoVhCXZ+xQTXk7xTkTJ3ywqioo4i4Ke6ZfQDJaFPmM5QjnEl31OA
 t/blL7sfUYAg==
X-IronPort-AV: E=Sophos;i="5.73,381,1583222400"; 
   d="scan'208";a="252742175"
Received: from agluck-desk2.sc.intel.com (HELO agluck-desk2.amr.corp.intel.com) ([10.3.52.68])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2020 17:50:02 -0700
Date:   Mon, 11 May 2020 17:50:01 -0700
From:   "Luck, Tony" <tony.luck@intel.com>
To:     Andy Shevchenko <andriy.shevchenko@intel.com>
Cc:     "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "linux-drivers-review@eclists.intel.com" 
        <linux-drivers-review@eclists.intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [linux-drivers-review] [PATCH] x86/mm: Fix boot with some memory
 above MAXMEM
Message-ID: <20200512005001.GA27126@agluck-desk2.amr.corp.intel.com>
References: <20200511163706.41619-1-kirill.shutemov@linux.intel.com>
 <4db011da-35b4-c6c0-aa35-54a28776169b@intel.com>
 <20200511170419.a53lgasfxd33nrk7@black.fi.intel.com>
 <5f95e4c2-66fe-42a0-f09f-cb902cd6db9a@intel.com>
 <3908561D78D1C84285E8C5FCA982C28F7F61FEF4@ORSMSX115.amr.corp.intel.com>
 <20200511184330.fbxjbnho4tzkukry@black.fi.intel.com>
 <3908561D78D1C84285E8C5FCA982C28F7F6200F3@ORSMSX115.amr.corp.intel.com>
 <20200511211925.GQ185537@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200511211925.GQ185537@smile.fi.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 12, 2020 at 12:19:25AM +0300, Andy Shevchenko wrote:
> On Mon, May 11, 2020 at 06:58:21PM +0000, Luck, Tony wrote:
> > >> > +		pr_err("%lldMB of physical memory is not addressable in the paging mode\n",
> > >> > +		       not_addressable >> 20);
> > >> 
> > >> Is "MB" the right unit for this. The problem seems to happen for systems with >64TB ... I doubt
> > >> the unaddressable memory is just a couple of MBbytes
> > >
> > > Change it to GB?
> > 
> > I think it would be more readable.
> > 
> > [Maybe Linux needs a magic %p{something} that does auto-sizing to print in the most appropriate out of KB, MB, GB, TB, PB?]
> 
> We have one in string_helpers.c.

Ah, nice.  So:

#include <linux/string_helpers.h>


	char	tmp[10]; /* Bother, no #define for this, just a comment in string_helpers.c */


	string_get_size(not_addressable, 1, STRING_UNITS_2, tmp, sizeof(tmp);

	pr_err("%s of physical memory is not addressable in the paging mode\n", tmp);

-Tony
