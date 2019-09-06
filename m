Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0E6AB426
	for <lists+stable@lfdr.de>; Fri,  6 Sep 2019 10:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388713AbfIFIkO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Sep 2019 04:40:14 -0400
Received: from bastet.se.axis.com ([195.60.68.11]:40867 "EHLO
        bastet.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731942AbfIFIkO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Sep 2019 04:40:14 -0400
Received: from localhost (localhost [127.0.0.1])
        by bastet.se.axis.com (Postfix) with ESMTP id 6B97418519;
        Fri,  6 Sep 2019 10:40:10 +0200 (CEST)
X-Axis-User: NO
X-Axis-NonUser: YES
X-Virus-Scanned: Debian amavisd-new at bastet.se.axis.com
Received: from bastet.se.axis.com ([IPv6:::ffff:127.0.0.1])
        by localhost (bastet.se.axis.com [::ffff:127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id yOWpQzyyqH0n; Fri,  6 Sep 2019 10:40:07 +0200 (CEST)
Received: from boulder02.se.axis.com (boulder02.se.axis.com [10.0.8.16])
        by bastet.se.axis.com (Postfix) with ESMTPS id 76E7718510;
        Fri,  6 Sep 2019 10:40:07 +0200 (CEST)
Received: from boulder02.se.axis.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5BCFF1A05F;
        Fri,  6 Sep 2019 10:40:07 +0200 (CEST)
Received: from boulder02.se.axis.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4F0CB1A05D;
        Fri,  6 Sep 2019 10:40:07 +0200 (CEST)
Received: from thoth.se.axis.com (unknown [10.0.2.173])
        by boulder02.se.axis.com (Postfix) with ESMTP;
        Fri,  6 Sep 2019 10:40:07 +0200 (CEST)
Received: from XBOX03.axis.com (xbox03.axis.com [10.0.5.17])
        by thoth.se.axis.com (Postfix) with ESMTP id 41B4E2D4C;
        Fri,  6 Sep 2019 10:40:07 +0200 (CEST)
Received: from lnxricardw1.se.axis.com (10.0.5.60) by XBOX03.axis.com
 (10.0.5.17) with Microsoft SMTP Server (TLS) id 15.0.1365.1; Fri, 6 Sep 2019
 10:40:06 +0200
Date:   Fri, 6 Sep 2019 10:40:01 +0200
From:   Ricard Wanderlof <ricard.wanderlof@axis.com>
X-X-Sender: ricardw@lnxricardw1.se.axis.com
To:     <stable@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Mark Brown <broonie@kernel.org>
CC:     Sasha Levin <sashal@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: revert: ASoC: Fail card instantiation if DAI format setup
 fails
In-Reply-To: <alpine.DEB.2.20.1908280859060.5799@lnxricardw1.se.axis.com>
Message-ID: <alpine.DEB.2.20.1909061031200.3985@lnxricardw1.se.axis.com>
References: <20190814021047.14828-1-sashal@kernel.org> <20190814021047.14828-40-sashal@kernel.org> <20190814092213.GC4640@sirena.co.uk> <20190826013515.GG5281@sasha-vm> <20190827110014.GD23391@sirena.co.uk> <20190828021311.GV5281@sasha-vm>
 <alpine.DEB.2.20.1908280859060.5799@lnxricardw1.se.axis.com>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [10.0.5.60]
X-ClientProxiedBy: XBOX02.axis.com (10.0.5.16) To XBOX03.axis.com (10.0.5.17)
X-TM-AS-GCONF: 00
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


> > On Tue, Aug 27, 2019 at 12:00:14PM +0100, Mark Brown wrote:
> > > On Sun, Aug 25, 2019 at 09:35:15PM -0400, Sasha Levin wrote:
> > > > On Wed, Aug 14, 2019 at 10:22:13AM +0100, Mark Brown wrote:
> > > 
> > > > > > If the DAI format setup fails, there is no valid communication format
> > > > > > between CPU and CODEC, so fail card instantiation, rather than
> > > > continue
> > > > > > with a card that will most likely not function properly.
> > > 
> > > > > This is another one where if nobody noticed a problem already and things
> > > > > just happened to be working this might break things, it's vanishingly
> > > > > unlikely to fix anything that was broken.
> > > 
> > > > Same as the other patch: this patch suggests it fixes a real bug, and if
> > > > this patch is broken let's fix it.
> > > 
> > > If anyone ran into this on the older kernel and fixed or worked
> > > around it locally there's a reasonable chance this will then
> > > break what they're doing.  The patch itself is perfectly fine but

(Sorry about the mangled subject line, I'd accidentally deleted the 
original message from my inbox.)

I'm a bit bewildered here. As the author of the original patch I'm of 
course biased, and I can certainly understand the patch being dropped from 
existing release branches, since as Mark correctly states, it does not fix 
any broken behavior and might even break things that happen to work by 
chance.

But is this being dropped from the master branch as well? To me it makes 
the kernel behave in an inconsistent way, first reporting a failure to 
instantiate a specific sound card in the kernel log, but then seemingly 
bringing it up anyway.

/Ricard
-- 
Ricard Wolf Wanderlof                           ricardw(at)axis.com
Axis Communications AB, Lund, Sweden            www.axis.com
Phone +46 46 272 2016                           Fax +46 46 13 61 30
