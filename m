Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 954C924A3BF
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 18:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbgHSQFz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 12:05:55 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:20410 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725275AbgHSQFz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 12:05:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1597853155; x=1629389155;
  h=date:from:to:cc:message-id:references:mime-version:
   in-reply-to:subject;
  bh=omhbYBTmEOMYzxX8bnYor0KxzAeqfES8koBkGPpQhJQ=;
  b=IjQwSQA+avstwZv/gWvZBjRuJFgywUZ7gSqbSzL0Y4tGIYjmYhwQdKrE
   AKA6eiJYxHE9oMEqw8Quj/cj424iUxeLES4lzwka1KSkD6ANbh+SNglJZ
   WGRVjPTZtC5qDSWrDO4HsIlGsDaPZUKjaZWQOnYrg2jAQDre5XqGa7EEq
   c=;
X-IronPort-AV: E=Sophos;i="5.76,332,1592870400"; 
   d="scan'208";a="50170375"
Subject: Re: [PATCH 4.14 1/2] genirq/affinity: Handle affinity setting on inactive
 interrupts correctly
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-c7c08562.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 19 Aug 2020 16:05:54 +0000
Received: from EX13MTAUWC002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-c7c08562.us-east-1.amazon.com (Postfix) with ESMTPS id 51FB22417F1;
        Wed, 19 Aug 2020 16:05:53 +0000 (UTC)
Received: from EX13D46UWC003.ant.amazon.com (10.43.162.119) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 19 Aug 2020 16:05:51 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13D46UWC003.ant.amazon.com (10.43.162.119) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 19 Aug 2020 16:05:51 +0000
Received: from dev-dsk-fllinden-2c-c1893d73.us-west-2.amazon.com
 (172.23.141.97) by mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Wed, 19 Aug 2020 16:05:51 +0000
Received: by dev-dsk-fllinden-2c-c1893d73.us-west-2.amazon.com (Postfix, from userid 6262777)
        id 3F62FC1501; Wed, 19 Aug 2020 16:05:51 +0000 (UTC)
Date:   Wed, 19 Aug 2020 16:05:51 +0000
From:   Frank van der Linden <fllinden@amazon.com>
To:     Greg KH <greg@kroah.com>
CC:     <stable@vger.kernel.org>, <tglx@linutronix.de>
Message-ID: <20200819160550.GA11709@dev-dsk-fllinden-2c-c1893d73.us-west-2.amazon.com>
References: <20200810201144.20618-1-fllinden@amazon.com>
 <20200819095537.GB2558675@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200819095537.GB2558675@kroah.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 19, 2020 at 11:55:37AM +0200, Greg KH wrote:
> On Mon, Aug 10, 2020 at 08:11:43PM +0000, Frank van der Linden wrote:
> > From: Thomas Gleixner <tglx@linutronix.de>
> >
> > commit baedb87d1b53532f81b4bd0387f83b05d4f7eb9a upstream.
> >
> > Setting interrupt affinity on inactive interrupts is inconsistent when
> > hierarchical irq domains are enabled. The core code should just store the
> > affinity and not call into the irq chip driver for inactive interrupts
> > because the chip drivers may not be in a state to handle such requests.
> >
> > X86 has a hacky workaround for that but all other irq chips have not which
> > causes problems e.g. on GIC V3 ITS.
> >
> > Instead of adding more ugly hacks all over the place, solve the problem in
> > the core code. If the affinity is set on an inactive interrupt then:
> >
> >     - Store it in the irq descriptors affinity mask
> >     - Update the effective affinity to reflect that so user space has
> >       a consistent view
> >     - Don't call into the irq chip driver
> >
> > This is the core equivalent of the X86 workaround and works correctly
> > because the affinity setting is established in the irq chip when the
> > interrupt is activated later on.
> >
> > Note, that this is only effective when hierarchical irq domains are enabled
> > by the architecture. Doing it unconditionally would break legacy irq chip
> > implementations.
> >
> > For hierarchial irq domains this works correctly as none of the drivers can
> > have a dependency on affinity setting in inactive state by design.
> >
> > Remove the X86 workaround as it is not longer required.
> >
> > Fixes: 02edee152d6e ("x86/apic/vector: Ignore set_affinity call for inactive interrupts")
> 
> Why is this needed for 4.14.y, when this "Fixes:" tag says a commit that
> showed up in 4.15?

The issue of set_affinity being called on inactive interrupts, and it
not being handled correctly, was already there in 4.14. The commit in
the Fixes: tag is the x86 workaround, which came in in 4.15, and is
no longer needed.

So we still need the backport of the genirq changes, to fix it in 4.14.
This is mostly for arm64 (gicv3), where this issue results in interrupts
getting messed up.

- Frank
