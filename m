Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C78C05E88D7
	for <lists+stable@lfdr.de>; Sat, 24 Sep 2022 08:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232550AbiIXGqu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Sep 2022 02:46:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiIXGqt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Sep 2022 02:46:49 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C30B25FE9;
        Fri, 23 Sep 2022 23:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664002008; x=1695538008;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=9xhmRG95Oai0Gh6KQQh9QF7sHwJ15jrKdlIwr7wHUek=;
  b=nu6Qpp3WxFDXHq199aS7hdslYPd09GcSRdptyZumqiAPXqkehsh10PaL
   NykJ3GBu316DyXtXumEIQBXLFiAB3R8QIyWZ99HCIilpwoXFxhppmfXaW
   ARbMH4POT+qBO3VlanLYPCjUmtB6UwTYza3eXlyCma3r2dDR+cDoMWeSI
   CPNEcI2b2wZxqruZvEEr2eqLKYHN2TlNXufUFGtOrglcOpkhG7W9f2EhW
   Ompon42Mj/940jsNIjYAwAzeJtyeeqsgLjM44KzFIFUy+Kat1Ru78o7ev
   ZXoGn2VnLM34xf7QYJzotGQ5Ql1IDXMRqXFI3aJaagaF/2qiKTaUbTO8U
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10479"; a="302206542"
X-IronPort-AV: E=Sophos;i="5.93,341,1654585200"; 
   d="scan'208";a="302206542"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2022 23:46:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,341,1654585200"; 
   d="scan'208";a="622767116"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga007.fm.intel.com with ESMTP; 23 Sep 2022 23:46:45 -0700
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id A9FE9F7; Sat, 24 Sep 2022 09:47:03 +0300 (EEST)
Date:   Sat, 24 Sep 2022 09:47:03 +0300
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     Mario Limonciello <mario.limonciello@amd.com>
Cc:     Andreas Noever <andreas.noever@gmail.com>,
        Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Mehta Sanju <Sanju.Mehta@amd.com>, stable@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] thunderbolt: Explicitly enable lane adapter hotplug
 events at startup
Message-ID: <Yy6n56H09ct76GTJ@black.fi.intel.com>
References: <20220923183944.10746-1-mario.limonciello@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220923183944.10746-1-mario.limonciello@amd.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Mario,

On Fri, Sep 23, 2022 at 01:39:44PM -0500, Mario Limonciello wrote:
> Software that has run before the USB4 CM in Linux runs may have disabled
> hotplug events for a given lane adapter.
> 
> Other CMs such as that one distributed with Windows 11 will enable hotplug
> events. Do the same thing in the Linux CM which fixes hotplug events on
> "AMD Pink Sardine".
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> ---
> v2->v3:
>  * Guard with tb_switch_is_icm to avoid risk to Intel FW CM case
> v1->v2:
>  * s/usb4_enable_hotplug/usb4_port_hotplug_enable/
>  * Clarify intended users in documentation comment
>  * Only call for lane adapters
>  * Add stable tag
> 
> Note: v2 it was suggested to move this to tb_switch_configure, but
> port->config is not yet read at that time.  This should be the right
> time to call it, so this version of the patch just guards against the
> code running on Intel's controllers that have a FW CM.

Can we put it in a separate function that is called from
tb_switch_add()? I explained in the previous reply (to v2) that the
tb_init_port() is pretty much just reading stuff and therefore I would
not like to add there anything that does writing.

While at it, the USB4 v2 spec (not yet public but can be found from the
working group site) adds a CM requirement that forbids writing lane 1
adapter configuration registers so in addition to that please check
port->cap_usb4 there so we know we deal with the lane 0 adapter only (as
->cap_usb4 is only set for the lane 0 adapters).

So something like this:

static void tb_switch_port_hotplug_enable(struct tb_switch *sw)
{
	if (tb_switch_is_icm(sw))
		return;

	tb_switch_for_each_port(sw, port) {
		if (!port->cap_usb4)
			continue;

		// here enable the hotplug
	}
}

int tb_switch_add(struct tb_switch *sw)
{
	... // init ports and stuff happens here

	tb_switch_default_link_ports(sw);
	tb_switch_port_hotplug_enable(sw);
}

(we should probably create a new macro tb_switch_for_each_usb4_port()
that just enumerates all USB4 ports).
