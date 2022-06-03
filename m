Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50B9C53D3F9
	for <lists+stable@lfdr.de>; Sat,  4 Jun 2022 01:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231924AbiFCX7D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 19:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231737AbiFCX7C (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 19:59:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8833C31DE4;
        Fri,  3 Jun 2022 16:59:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3CC6BB82500;
        Fri,  3 Jun 2022 23:59:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B56C1C385A9;
        Fri,  3 Jun 2022 23:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654300739;
        bh=0BSB0KdJ9TZOGWmSitv+cPteX1vDEFfMvQFuucYCfS8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=VEpgatTqZ3vbeJ6CESNEHBVV/eafdAvzizMYVPxwY2w2PrVkXxaYaoSC7STz5vN8O
         oOYGSShPOij3kbgr/AXDqqMcdFpa6paCxFHeRks4vGIwa6LelF+o1UNbLuQxd6kVwT
         PwedxrQ5J6a6IPpYDoE769AC/mbXl4PYsWhAm3l4TWFtQut2K+jSRM3tb0YRxZSDhz
         LSMnN2A0xyUlfmuIocYzzl9XoLqGHRhZLalwmwmNJakY8tLC/v7+rkgoHwBh9OFuLp
         8JjOaPsaDD/SlpHkU1ZgxVBPfzqLjIWapsO7kx8VXMO9Ix3JHmt/RvVn8Xytkl65lH
         e+XFKCW9PVK+Q==
Date:   Fri, 3 Jun 2022 18:58:56 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Mohamed Khalfella <mkhalfella@purestorage.com>
Cc:     linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        msaggi@purestorage.com, ebadger@purestorage.com,
        stable@vger.kernel.org, bhelgaas@google.com, oohall@gmail.com,
        rajatja@google.com, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] PCI/AER: Iterate over error counters instead of error
Message-ID: <20220603235856.GA117911@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220603221247.5118-1-mkhalfella@purestorage.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 03, 2022 at 10:12:47PM +0000, Mohamed Khalfella wrote:
> Is there any chance for this to land in 5.19?

Too late for v5.19, since the merge window will end in a couple days.
Remind me again if you don't see it in -next by v5.20-rc5 or so.

> On 5/10/22 14:17, Mohamed Khalfella wrote:
> > > Thanks for catching this; it definitely looks like a real issue!  I
> > > guess you're probably seeing junk in the sysfs files?
> > 
> > That is correct. The initial report was seeing junk when reading sysfs
> > files. As descibed, this is happening because we reading data past the
> > end of the stats counters array.
> > 
> > 
> > > I think maybe we should populate the currently NULL entries in the
> > > string[] arrays and simplify the code here, e.g.,
> > > 
> > > static const char *aer_correctable_error_string[] = {
> > >        "RxErr",                        /* Bit Position 0       */
> > >        "dev_cor_errs_bit[1]",
> > >	...
> > >
> > >  if (stats[i])
> > >    len += sysfs_emit_at(buf, len, "%s %llu\n", strings_array[i], stats[i]);
> > 
> > Doing it this way will change the output format. In this case we will show
> > stats only if their value is greater than zero. The current code shows all the
> > stats those have names (regardless of their value) plus those have non-zero
> > values.
> > 
> > >> @@ -1342,6 +1342,11 @@ static int aer_probe(struct pcie_device *dev)
> > >>  	struct device *device = &dev->device;
> > >>  	struct pci_dev *port = dev->port;
> > >>
> > >> +	BUILD_BUG_ON(ARRAY_SIZE(aer_correctable_error_string) <
> > >> +		     AER_MAX_TYPEOF_COR_ERRS);
> > >> +	BUILD_BUG_ON(ARRAY_SIZE(aer_uncorrectable_error_string) <
> > >> +		     AER_MAX_TYPEOF_UNCOR_ERRS);
> > >
> > > And make these check for "!=" instead of "<".
> 
> I am happy to remove these BUILD_BUG_ON() if you think it is a good
> idea to do so.

I think it's good to enforce correctness there somehow, so let's leave
them there unless somebody has a better idea.

> > This will require unnecessarily extending stats arrays to have 32 entries
> > in order to match names arrays. If you don't feel strogly about changing
> > "<" to "!=", I prefer to keep the code as it is. 
