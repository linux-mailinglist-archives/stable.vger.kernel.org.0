Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F21C523E1C
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 21:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242313AbiEKT5D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 May 2022 15:57:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347567AbiEKT44 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 May 2022 15:56:56 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 841E21FE3CC;
        Wed, 11 May 2022 12:56:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652299014; x=1683835014;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hdmaA0JO9RX4G9B68I/UPWOzRHdrUFjj2Fwc/fmnq2M=;
  b=I2jjXZmxRPRafMwtNp6svqGCmy4V62aXhDDPODc4Hxj2iTAoIgt4sroj
   hm8F+dR+5XthhgVQIuBzXLX5swctq8VimPDLOqwS5bEfy7zd0L5SY9aUG
   jXBF2XFK97hHARWJtNImYoHQud5DTNZkbf6yuS9AIPVzZsq3m87prNVLQ
   O8tshSKMv6EQru7JEUVw7VQ5CwlLuse90Ji46h1K4dtSaSTMZh1SkhMbG
   FvWQqbe7Iir2kkVGnSsqRUKlELbEdtuKGg2cByPzFKsmP4eDr6RVpRU6v
   NFFbX3+Ztng+x7ToVQYlGWADjcZZhfotIoi1Qt4KGtZYxwu2YOGlhlO+U
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10344"; a="332836762"
X-IronPort-AV: E=Sophos;i="5.91,218,1647327600"; 
   d="scan'208";a="332836762"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2022 12:56:54 -0700
X-IronPort-AV: E=Sophos;i="5.91,218,1647327600"; 
   d="scan'208";a="553465705"
Received: from abynum-mobl.amr.corp.intel.com (HELO spandruv-desk1.amr.corp.intel.com) ([10.209.66.243])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2022 12:56:53 -0700
Message-ID: <408701ca2c7704c146c806740eabb5a99f30c945.camel@linux.intel.com>
Subject: Re: [UPDATE][PATCH] thermal: int340x: Mode setting with new OS
 handshake
From:   srinivas pandruvada <srinivas.pandruvada@linux.intel.com>
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        Linux PM <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
Date:   Wed, 11 May 2022 12:56:53 -0700
In-Reply-To: <CAJZ5v0hDN=iGBQei6XeJ1b3qLiRxPDm+ZFtKU1PcHbBcyxGpZw@mail.gmail.com>
References: <20220510182221.3990256-1-srinivas.pandruvada@linux.intel.com>
         <CAJZ5v0hDN=iGBQei6XeJ1b3qLiRxPDm+ZFtKU1PcHbBcyxGpZw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2022-05-11 at 20:14 +0200, Rafael J. Wysocki wrote:
> On Tue, May 10, 2022 at 8:22 PM Srinivas Pandruvada
> <srinivas.pandruvada@linux.intel.com> wrote:
> > 
> > With the new OS handshake introduced with the commit: "c7ff29763989
> > ("thermal: int340x: Update OS policy capability handshake")",
> > thermal zone mode "enabled" doesn't work in the same way as the
> > legacy
> > handshake. The mode "enabled" fails with -EINVAL using new
> > handshake.
> > 
> > To address this issue, when the new OS UUID mask is set:
> > - When mode is "enabled", return 0 as the firmware already has the
> > latest policy mask.
> > - When mode is "disabled", update the firmware with UUID mask of
> > zero.
> > In this way firmware can take control of the thermal control. Also
> > reset the OS UUID mask. This allows user space to update with new
> > set of policies.
> > 
> > Fixes: c7ff29763989 ("thermal: int340x: Update OS policy capability
> > handshake")
> > Signed-off-by: Srinivas Pandruvada
> > <srinivas.pandruvada@linux.intel.com>
> > Cc: stable@vger.kernel.org
> 
> This is not -stable material yet.
I thought it will wait for 5.19 merge window.

> 
> > ---
> > update:
> > Added Fixes tag
> > 
> > 

[...]

> > +               if (priv->os_uuid_mask) {
> > +                       if (!enabled) {
> > +                               priv->os_uuid_mask = 0;
> > +                               result = set_os_uuid_mask(priv,
> > priv->os_uuid_mask);
> 
> This change worries me a bit, because it means replaying an already
> established _OSC handshake which shouldn't be done by the spec.
> 
I checked with the firmware team. The _OSC changes dynamically is
validated and is recommended when enable/disable user space thermal
control.
Looking at ACPI Spec
"OSPM may evaluate _OSC multiple times to indicate changes in OSPM
capability to the device but this may be precluded by specific device
requirements"


> But I suppose you have tested this?
I tested on TigerLake system.

> 
> > +                       }
> > +    

[...]

> 
> Patch applied as 5.18-rc material, but I've removed some unneeded
> parens from the new code, so please double check the result in
> bleeding-edge.
I tested the patch from bleeding edge.
Works fine.

Thanks,
Srinivas

> 
> Thanks!

