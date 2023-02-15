Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A51E469763E
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 07:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232370AbjBOGYF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 01:24:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjBOGYE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 01:24:04 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3CFCEB6D;
        Tue, 14 Feb 2023 22:24:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676442243; x=1707978243;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=h3WFkrrQBFpAY0aMOsEVQtfpvfyMaLersTO9L3M03ro=;
  b=BVwutFV/y3KQn6fkPQCt6EjbDjpE21kZCdEuGJzIl70tuO2hKV+zWVRM
   +eQWBuRDtuIXmpCeVkEXQ3WNdDksNlEnsC4TxH7dYHU4MVHngor8eTAMG
   HR0eDAzTSKKGDlwdNEaKQKIU0uXQEs0JfZj4VZfS4AF8Fcqq9mN0DDK2G
   z/5aezn1T2ZQu0TRQzritorrOfXqjeWudV9ENQ94a+qkHnMuGn5g4b8qc
   1I2dHvB8HdVcyLgsqdEULShaZOyCyksNIgO97AgEue8o4YsRXhlpz02aS
   KdCOozNQUeqL+1h2ZDB5kP+7gWM5Tgg1i08lDc1ba+MmkJnOZoGkIpbIS
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="393757703"
X-IronPort-AV: E=Sophos;i="5.97,298,1669104000"; 
   d="scan'208";a="393757703"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 22:24:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="738180278"
X-IronPort-AV: E=Sophos;i="5.97,298,1669104000"; 
   d="scan'208";a="738180278"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga004.fm.intel.com with ESMTP; 14 Feb 2023 22:23:59 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id 598D11A6; Wed, 15 Feb 2023 08:24:39 +0200 (EET)
Date:   Wed, 15 Feb 2023 08:24:39 +0200
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     Mario Limonciello <mario.limonciello@amd.com>
Cc:     Andreas Noever <andreas.noever@gmail.com>,
        Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>, Sanju.Mehta@amd.com,
        stable@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] thunderbolt: Read DROM directly from NVM before
 trying bit banging
Message-ID: <Y+x6pwHKDe2gXNUY@black.fi.intel.com>
References: <20230214154647.874-1-mario.limonciello@amd.com>
 <20230214154647.874-2-mario.limonciello@amd.com>
 <Y+x0cbSpnIPYjZJE@black.fi.intel.com>
 <8f099a80-7fd1-c98a-4990-4a936a5a610a@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8f099a80-7fd1-c98a-4990-4a936a5a610a@amd.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Wed, Feb 15, 2023 at 12:10:54AM -0600, Mario Limonciello wrote:
> 
> On 2/14/23 23:58, Mika Westerberg wrote:
> > Hi,
> > 
> > On Tue, Feb 14, 2023 at 09:46:45AM -0600, Mario Limonciello wrote:
> > > Some TBT3 devices have a hard time reliably responding to bit banging
> > > requests correctly when connected to AMD USB4 hosts running Linux.
> > > 
> > > These problems are not reported in any other CM, and comparing the
> > > implementations the Linux CM is the only one that utilizes bit banging
> > > to access the DROM. Other CM implementations access the DROM directly
> > > from the NVM instead of bit banging.
> > I'm sure Apple CM uses bitbanging because it is what Andreas reverse
> > engineered when he added the initial Linux Thunderbolt support ;-) I
> > guess this is then only Window CM? The problem with reading NVM directly
> > is that we may lose things like UUID, so I'm wondering if there is
> > something else going on.
> 
> When I say other CMs, maybe I should have specified which ones were checked
> :)
> 
> The following CM get the DROM without bit-banging:
> 
> Win11 CM (MS inbox)
> 
> Win10 CM (AMD)
> 
> Pre-OS CM (AMD)

Okay that's good to know :) I think you may want to mention this in the
commit log too.

> > Can you give some details, like what is the device in question?
> 
> It happens with both AR and TR based TBT3 devices connected to AMD USB4
> router.
> It's not any one specific vendor or model, we've seen it across multiple
> vendors with
> a failure rate of about 30%.
> 
> 
> With an analyzer connected in between we can see that the connected TBT3
> device
> does respond to the bit banging correctly, but the response is not making it
> over to
> the USB4 router.

I see.

> It happens with multiple retimer vendors, but it hasn't been checked on a
> retimer-less
> system yet.
> 
> > > Adjust the flow to try this on TBT3 devices before resorting to bit
> > > banging.
> > > 
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> > > ---
> > >   drivers/thunderbolt/eeprom.c | 4 ++++
> > >   1 file changed, 4 insertions(+)
> > > 
> > > diff --git a/drivers/thunderbolt/eeprom.c b/drivers/thunderbolt/eeprom.c
> > > index c90d22f56d4e1..d9d9567bb938b 100644
> > > --- a/drivers/thunderbolt/eeprom.c
> > > +++ b/drivers/thunderbolt/eeprom.c
> > > @@ -640,6 +640,10 @@ int tb_drom_read(struct tb_switch *sw)
> > >   		return 0;
> > >   	}
> > > +	/* TBT3 devices have the DROM as part of NVM */
> > > +	if (tb_drom_copy_nvm(sw, &size) == 0)
> > > +		goto parse;
> > > +
> > >   	res = tb_drom_read_n(sw, 14, (u8 *) &size, 2);
> > >   	if (res)
> > >   		return res;
> > > -- 
> > > 2.25.1
> 
> I guess something else that might be less detrimental the loss of UUID
> by reading DROM this way would be to only read DROM this way if any CRC
> failed.

Actually we do read UUID for TBT3 devices from link controller registers
(see tb_lc_read_uuid()) instead so I think perhaps we can limit the
bitbanging just for older TBT devices with no LC or something like that?
