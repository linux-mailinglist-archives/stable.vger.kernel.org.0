Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB2E24CE50A
	for <lists+stable@lfdr.de>; Sat,  5 Mar 2022 14:43:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbiCENoZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Mar 2022 08:44:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiCENoY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Mar 2022 08:44:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D79D3B3EA
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 05:43:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45FCCB80968
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 13:43:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E69C004E1;
        Sat,  5 Mar 2022 13:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646487812;
        bh=5vI1Lpp82VO89gKPstOSz97G8przo4YXpv5ggcLQELU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IUyen5shIkkuo6od+rqgjjWpd7RBV5g0gMFTatbilKsDsZZeYldjfnlQo1dwpRouF
         azo+tIPPkFZ30moRiABNMdYFbg6e1FCv1yrHqNe8SFl+teto/cN3xu4NnvLIQLyFJ2
         MjKOk2WycJ4QY7lYXqxEBdiN2TW00GGnp3AWqmHA=
Date:   Sat, 5 Mar 2022 14:43:28 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Jankowski, Konrad0" <konrad0.jankowski@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: Re: [PATCH 1/2] ice: Fix race conditions between virtchnl handling
 and VF ndo ops
Message-ID: <YiNpANXX8hi1enjc@kroah.com>
References: <20220225202101.4077712-1-jacob.e.keller@intel.com>
 <YhytnJGxStO0Gai9@kroah.com>
 <Yhywy/LYW38Aavxt@kroah.com>
 <CO1PR11MB508937A170C114A274CBE809D6019@CO1PR11MB5089.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO1PR11MB508937A170C114A274CBE809D6019@CO1PR11MB5089.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 28, 2022 at 08:57:50PM +0000, Keller, Jacob E wrote:
> 
> 
> > -----Original Message-----
> > From: Greg KH <gregkh@linuxfoundation.org>
> > Sent: Monday, February 28, 2022 3:24 AM
> > To: Keller, Jacob E <jacob.e.keller@intel.com>
> > Cc: stable@vger.kernel.org; Brett Creeley <brett.creeley@intel.com>; Jankowski,
> > Konrad0 <konrad0.jankowski@intel.com>; Nguyen, Anthony L
> > <anthony.l.nguyen@intel.com>
> > Subject: Re: [PATCH 1/2] ice: Fix race conditions between virtchnl handling and VF
> > ndo ops
> > 
> > On Mon, Feb 28, 2022 at 12:10:20PM +0100, Greg KH wrote:
> > > On Fri, Feb 25, 2022 at 12:21:00PM -0800, Jacob Keller wrote:
> > > > From: Brett Creeley <brett.creeley@intel.com>
> > > >
> > > > commit e6ba5273d4ede03d075d7a116b8edad1f6115f4d upstream.
> > > >
> > > > [I had to fix the cherry-pick manually as the patch added a line around
> > > > some context that was missing.]
> > >
> > > What stable tree(s) is this for?$
> > 
> > Looks like it applied only to 5.15.y.  Can you also provide backports
> > for the other older kernels that these are needed for?
> > 
> 
> Hi Greg!
> 
> I sent a series that should apply from v5.8 through 5.12 (excepting one patch that was already on 5.10 but not the other trees, for some reason). I also sent a series for 5.13 and one for 5.14.
> 
> The code prior to 5.8 still has this bug, going back to the first release with ice, (4.20), but it is different enough that I had trouble determining what the correct patch is. Especially for the first patch which is necessary for the later fixes, since it introduces the lock we need. I'm going to spend a bit more time later this evening to see if I can sort it out. If not, we may have to live without the fixes on those trees.

I've applied the 2 missing changes to the 5.10.y tree.  The other ones
are all end-of-life, sorry.

thanks,

greg k-h
