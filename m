Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E456848F1F0
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 22:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbiANVNB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 16:13:01 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47966 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbiANVNA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 16:13:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41BC061F6E;
        Fri, 14 Jan 2022 21:13:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26D6DC36AE5;
        Fri, 14 Jan 2022 21:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642194779;
        bh=niJzjtKa24M/K9SaTRk1489GynPFKKY7X52fQyZqBjA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NXEylpgU00kAF987ah7HC5CJVS97UihExbToSPmKKjPX6YV4LuqbiAoRoz9TAnFkf
         K1aaU3L0a/xWKZGmsYpF56VN2CH9RtI/3NXqiH8bOALYd+zhYr/8hwxWqBT5Bi+vS/
         ngx2MdIqZ/bL7kRhEiM9GHt/phpk9aJLp0ULZAF+xaGFD6wqUfBL4oeUXUeot2hRQJ
         9lNVAOisVRppl8mt+XWbSsyw33s6ASldILhE3IkKxUsuoFuDLFpJQ5173cEognDBXl
         CcXWk/l+VdM+hoB6niGS6QKDLseoqyAt9VdxVwWwMiyuXLWPzlGP41OvqC/0By3uXC
         LJgldWTdYeSOQ==
Date:   Fri, 14 Jan 2022 23:12:46 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     Tadeusz Struk <tstruk@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        linux-integrity@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, stefanb@linux.ibm.com
Subject: Re: [PATCH v3 1/2] tpm: Fix error handling in async work
Message-ID: <YeHnTlK+QCZiUyOL@iki.fi>
References: <20220111055228.1830-1-tstruk@gmail.com>
 <Yd8fY/wixkXhXEFH@iki.fi>
 <3c2eeee7-0d3e-8000-67ad-3054f229cbe0@linaro.org>
 <YeHmB0BWgfVGPL55@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YeHmB0BWgfVGPL55@iki.fi>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 14, 2022 at 11:07:22PM +0200, Jarkko Sakkinen wrote:
> On Wed, Jan 12, 2022 at 10:47:29AM -0800, Tadeusz Struk wrote:
> > On 1/12/22 10:35, Jarkko Sakkinen wrote:
> > > These look good to me! Thank you. I'm in process of compiling a test
> > > kernel.
> > 
> > Thanks Jarkko,
> > You can run the new test before and after applying the change and see
> > how it behaves. Also just noticed a mistake in the comment, sorry but
> > it was quite late when I sent it.
> > 
> > +	/*
> > +	 * If ret is > 0 then tpm_dev_transmit returned the size of the
> > +	 * response. If ret is < 0 then tpm_dev_transmit failed and
> > +	 * returned a return code.
> > +	 */
> > 
> > In the above could you please replace:
> > 
> > s/returned a return code/returned an error code/
> > 
> > before applying the patch. I would appreciate that.
> 
> Please send new versions, there's also this:
> 
> def test_flush_invlid_context()
> 
> I'd figure "invlid" should be  "invalid"
> 
> You can add, as these changes do not change the semantics of the
> patches:
> 
> Tested-by: Jarkko Sakkinen <jarkko@kernel.org>
> 
> It's always best if you author the final version, as then a clear
> reference on what was accepted exist at lore.kernel.org.

Maybe it is good to mention that the test environment was libvirt hosted
QEMU using swtpm, which I tried for the first time, instead of real hadware
(libvirt has a nice property that it handles the startup/shutdown of
swtpm). I managed to run all tests so I guess swtpm is working properly.

/Jarkko
