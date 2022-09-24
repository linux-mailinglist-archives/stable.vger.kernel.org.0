Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE2835E88A7
	for <lists+stable@lfdr.de>; Sat, 24 Sep 2022 08:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233097AbiIXGEB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Sep 2022 02:04:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233194AbiIXGD7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Sep 2022 02:03:59 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32CE9116C14;
        Fri, 23 Sep 2022 23:03:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663999438; x=1695535438;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=iHPeJI3uoBTGbE6747KK7GTSlL8DhnxDDSXkO1IxR08=;
  b=nHPMbVXWk21ro7SAdznCZpB7ZNKRMMYROm1Y9JoJqrrecOaOMc+kVnA7
   JfsUe7xcD8mf2nUPtfWbhgDRYjq2ejaUHM+cgfrnUPPfvBo2Vfz37XsRR
   KiMKvE8L5JnboGgO1mSeYAjB9Zdrins5jDVnNN9QhzQRyA9Iv5BNO+EOh
   DgIy7SUKIHPOCKVfC40boWS+AVAz+hRAzedMj4NgIZNTF1hqJ3HNu8ceS
   +HjHq00GpE93OtbtYbPjrO9P55s9FwJ9/rjgchD6q7Vv+ahZ8hTknlqoO
   EJNggSEIDM39i4MCqOb4AQIlDOniEB63cFXTgJkFzOawDMtX8y4SoJV6P
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10479"; a="298347680"
X-IronPort-AV: E=Sophos;i="5.93,341,1654585200"; 
   d="scan'208";a="298347680"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2022 23:03:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,341,1654585200"; 
   d="scan'208";a="615858316"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga007.jf.intel.com with ESMTP; 23 Sep 2022 23:03:54 -0700
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id 233CCF7; Sat, 24 Sep 2022 09:04:11 +0300 (EEST)
Date:   Sat, 24 Sep 2022 09:04:11 +0300
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     "Limonciello, Mario" <mario.limonciello@amd.com>
Cc:     Andreas Noever <andreas.noever@gmail.com>,
        Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Mehta Sanju <Sanju.Mehta@amd.com>, stable@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] thunderbolt: Explicitly enable lane adapter hotplug
 events at startup
Message-ID: <Yy6d233SON9qonHa@black.fi.intel.com>
References: <20220922160730.898-1-mario.limonciello@amd.com>
 <Yy15gKzHyMcitY/N@black.fi.intel.com>
 <7c0623f8-5274-c7ee-71a7-3e0fab918f97@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c0623f8-5274-c7ee-71a7-3e0fab918f97@amd.com>
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Fri, Sep 23, 2022 at 11:08:30AM -0500, Limonciello, Mario wrote:
> On 9/23/2022 04:16, Mika Westerberg wrote:
> > Hi Mario,
> > 
> > On Thu, Sep 22, 2022 at 11:07:29AM -0500, Mario Limonciello wrote:
> > > Software that has run before the USB4 CM in Linux runs may have disabled
> > > hotplug events for a given lane adapter.
> > > 
> > > Other CMs such as that one distributed with Windows 11 will enable hotplug
> > > events. Do the same thing in the Linux CM which fixes hotplug events on
> > > "AMD Pink Sardine".
> > > 
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> > > ---
> > > v1->v2:
> > >   * Only send second patch as first was merged already
> > >   * s/usb4_enable_hotplug/usb4_port_hotplug_enable/
> > >   * Clarify intended users in documentation comment
> > >   * Only call for lane adapters
> > >   * Add stable tag
> > > 
> > >   drivers/thunderbolt/switch.c  |  4 ++++
> > >   drivers/thunderbolt/tb.h      |  1 +
> > >   drivers/thunderbolt/tb_regs.h |  1 +
> > >   drivers/thunderbolt/usb4.c    | 20 ++++++++++++++++++++
> > >   4 files changed, 26 insertions(+)
> > > 
> > > diff --git a/drivers/thunderbolt/switch.c b/drivers/thunderbolt/switch.c
> > > index 77d7f07ca075..3213239d12c8 100644
> > > --- a/drivers/thunderbolt/switch.c
> > > +++ b/drivers/thunderbolt/switch.c
> > > @@ -778,6 +778,10 @@ static int tb_init_port(struct tb_port *port)
> > >   			if (!tb_port_read(port, &hop, TB_CFG_HOPS, 0, 2))
> > >   				port->ctl_credits = hop.initial_credits;
> > > +
> > > +			res = usb4_port_hotplug_enable(port);
> > > +			if (res)
> > 
> > I think this does not belong here in tb_init_port(). This is called from
> > both FW and SW CM paths and we don't want to confuse the FW CM more than
> > necessary ;-)
> > 
> > So instead I think this should be added to tb_plug_events_active().
> > 
> 
> The problem with that location is that tb_plug_events_active() is called
> from tb_switch_configure() which is before tb_switch_add() is called.
> tb_switch_add() calls tb_init_port() which reads port->config for the first
> time.

Ah indeed, I missed that.

> So if this is only to be called in tb_switch_configure() it means reading
> port->config "earlier" too.
> 
> So it definitely needs to be called in tb_init_port() or a later function
> but before the device is announced to satisfy only running on the
> appropriate port types.
> 
> tb_init_port() or tb_switch_add feels like the right place to me.  How about
> leaving it where it is but guarding with a "if (!tb_switch_is_icm())" to
> avoid the risk to the FW CM case?

What about adding a new function that does this and it called from
tb_switch_add() before announcing devices to the world? tb_init_port()
is pretty much reading stuff from adapters so I would not like to add
there anything that does writing if possible.
