Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE0194564A0
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 22:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232656AbhKRVDh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 16:03:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:38418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230422AbhKRVDh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Nov 2021 16:03:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D5056139F;
        Thu, 18 Nov 2021 21:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637269236;
        bh=+eXV2EHyJlDvkKpbBXFTh2C6Rkk/xNYbto1qhtiHSTY=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=QUwZaoK0p2C5nSaXw+3wAH/8DsldNvlYbUjJt7AUdDKdJ8jew32tqWtoMUq4aqUwi
         OEmwx1A0cQsKjGmPMytP83bbaOJtdXDnlR7UCWk6ewRkwISpifVEUEzFSY3rI/Z7O5
         a3jw/zKG/abree6q2cXi2+hzh4YVN3csmUWEWH9DmVdQ6UddhqnZ5jxw4+buyFNFnh
         xfC3cxf9XMwEDA9ZI9RBFdmcyUJdhQXBINSrdPYWqx8Yo4NVYt44op6OCDURBTKIQx
         ZqXYKp2tpl2HchhUYlwgE3iSOwEvzT7IY9NGk8Mrl4whacgYnWBPiV2LwdoAXghSAD
         MyOW5Bd4DhXww==
Date:   Thu, 18 Nov 2021 13:00:35 -0800 (PST)
From:   Stefano Stabellini <sstabellini@kernel.org>
X-X-Sender: sstabellini@ubuntu-linux-20-04-desktop
To:     Juergen Gross <jgross@suse.com>
cc:     Jan Beulich <jbeulich@suse.com>, boris.ostrovsky@oracle.com,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        Stefano Stabellini <stefano.stabellini@xilinx.com>,
        stable@vger.kernel.org, Stefano Stabellini <sstabellini@kernel.org>
Subject: Re: [PATCH] xen: detect uninitialized xenbus in xenbus_init
In-Reply-To: <b0cd6af9-66c4-3a73-734a-3a51d052fac2@suse.com>
Message-ID: <alpine.DEB.2.22.394.2111181226460.1412361@ubuntu-linux-20-04-desktop>
References: <20211117021145.3105042-1-sstabellini@kernel.org> <2592121c-ed62-c346-5aeb-37adb6bb1982@suse.com> <alpine.DEB.2.22.394.2111171823160.1412361@ubuntu-linux-20-04-desktop> <44403efe-a850-b53b-785f-6f5c73eb2b96@suse.com> <9453672e-56ea-71cd-cdd2-b4aaafb8db56@suse.com>
 <b0cd6af9-66c4-3a73-734a-3a51d052fac2@suse.com>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 18 Nov 2021, Juergen Gross wrote:
> On 18.11.21 09:47, Jan Beulich wrote:
> > On 18.11.2021 06:32, Juergen Gross wrote:
> > > On 18.11.21 03:37, Stefano Stabellini wrote:
> > > > --- a/drivers/xen/xenbus/xenbus_probe.c
> > > > +++ b/drivers/xen/xenbus/xenbus_probe.c
> > > > @@ -951,6 +951,28 @@ static int __init xenbus_init(void)
> > > >    		err = hvm_get_parameter(HVM_PARAM_STORE_PFN, &v);
> > > >    		if (err)
> > > >    			goto out_error;
> > > > +		/*
> > > > +		 * Return error on an invalid value.
> > > > +		 *
> > > > +		 * Uninitialized hvm_params are zero and return no error.
> > > > +		 * Although it is theoretically possible to have
> > > > +		 * HVM_PARAM_STORE_PFN set to zero on purpose, in reality it
> > > > is
> > > > +		 * not zero when valid. If zero, it means that Xenstore hasn't
> > > > +		 * been properly initialized. Instead of attempting to map a
> > > > +		 * wrong guest physical address return error.
> > > > +		 */
> > > > +		if (v == 0) {
> > > 
> > > Make this "if (v == ULONG_MAX || v== 0)" instead?
> > > This would result in the same err on a new and an old hypervisor
> > > (assuming we switch the hypervisor to init params with ~0UL).

Sure, I can do that


> > > > +			err = -ENOENT;
> > > > +			goto out_error;
> > > > +		}
> > > > +		/*
> > > > +		 * ULONG_MAX is invalid on 64-bit because is INVALID_PFN.
> > > > +		 * On 32-bit return error to avoid truncation.
> > > > +		 */
> > > > +		if (v >= ULONG_MAX) {
> > > > +			err = -EINVAL;
> > > > +			goto out_error;
> > > > +		}
> > > 
> > > Does it make sense to continue the system running in case of
> > > truncation? This would be a 32-bit guest with more than 16TB of RAM
> > > and the Xen tools decided to place the Xenstore ring page above the
> > > 16TB boundary. This is a completely insane scenario IMO.
> > > 
> > > A proper panic() in this case would make diagnosis of that much
> > > easier (me having doubts that this will ever be hit, though).
> > 
> > While I agree panic() may be an option here (albeit I'm not sure why
> > that would be better than trying to cope with 0 and hence without
> 
> I could imagine someone wanting to run a guest without Xenstore access,
> which BTW will happen in case of a guest created by the hypervisor at
> boot time.
> 
> > xenbus), I'd like to point out that the amount of RAM assigned to a
> > guest is unrelated to the choice of GFNs for the various "magic"
> > items.
> 
> Yes, but this would still be a major tools problem which probably
> would render the whole guest rather unusable.

First let's distinguish between an error due to "hvm_param not
initialized" and an error due to more serious conditions, such as "pfn
above max".

"hvm_param not initialized" could mean v == 0 (as it would be today) or
v == ~0UL (if we change Xen to initialize all hvm_param to ~0UL). I
don't think we want to panic in these cases as they are not actually
true erroneous configurations. We should just stop trying to initialize
xenstore and continue with the rest.


The "pfn above max" case could happen if v is greater than the max pfn.
This is a true error in the configuration because the toolstack should
know that the guest is 32-bit so it should give it a pfn that the guest
is able to use. As Jan wrote in another email, for 32-bit the actual
limit depends on the physical address bits but actually Linux has never
been able to cope with a pfn > ULONG_MAX on 32-bit because xen_store_gfn
is defined as unsigned long. So Linux 32-bit has been truncating
HVM_PARAM_STORE_PFN all along.

There is also an argument that depending on kconfig Linux 32-bit might
only be able to handle addresses < 4G, so I don't think the toolstack
can assume that a 32-bit guest is able to cope with HVM_PARAM_STORE_PFN
> ULONG_MAX.  If Linux is 32-bit and HVM_PARAM_STORE_PFN > ULONG_MAX,
even if HVM_PARAM_STORE_PFN < address_bits_max I think it would be fair
to still consider it an error, but I can see it could be argued either
way. Certainly if HVM_PARAM_STORE_PFN > address_bits_max is an error.

In any case, I think it is still better for Linux to stop trying to
initialize Xenstore but continue with the rest because there is a bunch
of other useful things Linux can do without it. Panic should only be the
last resort if there is nothing else to do. In this case we haven't even
initialized the service and the service is not essential, at least it is
not essential in certain ARM setups.


So in conclusion, I think this patch should:
- if v == 0 return error (uninitialized)
- if v == ~0ULL (INVALID_PFN) return error (uinitialized)
- if v >= ~0UL (32-bit) return error (even if this case could be made to
  work for v < max_address_bits depending on kconfig)

Which leads to something like:

        /* uninitialized */
		if (v == 0 || v == ~0ULL) {
			err = -ENOENT;
			goto out_error;
		}
        /* 
         * Avoid truncation on 32-bit.
         * TODO: handle addresses >= 4G
         */
        if ( v >= ~0UL ) {
            err = -EINVAL;
            goto out_error;
        }
