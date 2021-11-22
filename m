Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79CE645970F
	for <lists+stable@lfdr.de>; Mon, 22 Nov 2021 23:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238332AbhKVWHJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Nov 2021 17:07:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:56674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232667AbhKVWHI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Nov 2021 17:07:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C179604D1;
        Mon, 22 Nov 2021 22:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637618640;
        bh=jOZoDcdty3EVXoO97iBWXCdZc4YcdG2UrCIxg6yqsOI=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=KQaOQ/8mdKxeHcSN/IfNcXV6jpA9VIrYHF6zPGcF8oCo8ZsB+HdG1s79HpwcpkXwK
         EizF31knhMnjWgkLiQ/fygn6B7qstlQTLnaZ+VDeyNONyG+AkQCaL9R2U0egM4OLw2
         /2vOuxOlu4DjJ2SGbargP2zYoJlrVG4AnBfdDjxmlroI88ejdzqnpwd//fiGXxR4P5
         YVfZkIEd6v16rEjd2axNhFX50BlePbMOwb8/LW5WmP8cPbLxx8TWF+nwEECadwxigJ
         mMMvYj5kcXcJIpdMHmzzyCtmQY+hVo7cHOo9jrHwfILaejDnxYiXAUumTUH0lHpSYc
         5jwCX2cblL/uw==
Date:   Mon, 22 Nov 2021 14:03:59 -0800 (PST)
From:   Stefano Stabellini <sstabellini@kernel.org>
X-X-Sender: sstabellini@ubuntu-linux-20-04-desktop
To:     Jan Beulich <jbeulich@suse.com>
cc:     Stefano Stabellini <sstabellini@kernel.org>,
        boris.ostrovsky@oracle.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org,
        Stefano Stabellini <stefano.stabellini@xilinx.com>,
        stable@vger.kernel.org, jgross@suse.com
Subject: Re: [PATCH v2] xen: detect uninitialized xenbus in xenbus_init
In-Reply-To: <bc47bbe2-b330-7744-8d6b-869e3c7523e4@suse.com>
Message-ID: <alpine.DEB.2.22.394.2111221357081.1412361@ubuntu-linux-20-04-desktop>
References: <20211119202951.403525-1-sstabellini@kernel.org> <bc47bbe2-b330-7744-8d6b-869e3c7523e4@suse.com>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 22 Nov 2021, Jan Beulich wrote:
> On 19.11.2021 21:29, Stefano Stabellini wrote:
> > --- a/drivers/xen/xenbus/xenbus_probe.c
> > +++ b/drivers/xen/xenbus/xenbus_probe.c
> > @@ -951,6 +951,20 @@ static int __init xenbus_init(void)
> >  		err = hvm_get_parameter(HVM_PARAM_STORE_PFN, &v);
> >  		if (err)
> >  			goto out_error;
> > +		/* Uninitialized. */
> > +		if (v == 0 || v == ULLONG_MAX) {
> 
> Didn't you have a comment in v1 here regarding the check against 0? Or was that
> just like now only in the description? IOW I think there ought to be a code
> comment justifying the theoretically wrong check ...

Yeah, I added all the info in the commit message and shortened the
in-code comment this time. I am also happy to keep the details in the
in-code comment, e.g.:

/*
 * If the xenstore page hasn't been allocated properly, reading the
 * value of the related hvm_param (HVM_PARAM_STORE_PFN) won't actually
 * return error. Instead, it will succeed and return zero. Instead of
 * attempting to xen_remap a bad guest physical address, detect this
 * condition and return early.
 *
 * Note that although a guest physical address of zero for
 * HVM_PARAM_STORE_PFN is theoretically possible, it is not a good
 * choice and zero has never been validly used in that capacity.
 *
 * Also recognize the invalid value of INVALID_PFN which is ULLONG_MAX.
 */


> Also, while I realize there are various other similar assumptions elsewhere, I
> would generally recommend to avoid such: There's no guarantee that now and
> forever unsigned long long and uint64_t are the same thing. And it's easy in
> cases like this one:
> 
> 		if (!v || !(v + 1)) {

I am happy to use this.
