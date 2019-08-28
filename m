Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D390F9FB3C
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 09:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbfH1HOW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 03:14:22 -0400
Received: from bastet.se.axis.com ([195.60.68.11]:35414 "EHLO
        bastet.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726253AbfH1HOW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Aug 2019 03:14:22 -0400
X-Greylist: delayed 416 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Aug 2019 03:14:21 EDT
Received: from localhost (localhost [127.0.0.1])
        by bastet.se.axis.com (Postfix) with ESMTP id 94C4918489;
        Wed, 28 Aug 2019 09:07:24 +0200 (CEST)
X-Axis-User: NO
X-Axis-NonUser: YES
X-Virus-Scanned: Debian amavisd-new at bastet.se.axis.com
Received: from bastet.se.axis.com ([IPv6:::ffff:127.0.0.1])
        by localhost (bastet.se.axis.com [::ffff:127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id hq3WF_UGHAyI; Wed, 28 Aug 2019 09:07:23 +0200 (CEST)
Received: from boulder03.se.axis.com (boulder03.se.axis.com [10.0.8.17])
        by bastet.se.axis.com (Postfix) with ESMTPS id 7D936182F4;
        Wed, 28 Aug 2019 09:07:23 +0200 (CEST)
Received: from boulder03.se.axis.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 68FDD1E06E;
        Wed, 28 Aug 2019 09:07:23 +0200 (CEST)
Received: from boulder03.se.axis.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5BDB11E064;
        Wed, 28 Aug 2019 09:07:23 +0200 (CEST)
Received: from seth.se.axis.com (unknown [10.0.2.172])
        by boulder03.se.axis.com (Postfix) with ESMTP;
        Wed, 28 Aug 2019 09:07:23 +0200 (CEST)
Received: from XBOX03.axis.com (xbox03.axis.com [10.0.5.17])
        by seth.se.axis.com (Postfix) with ESMTP id 4F111229A;
        Wed, 28 Aug 2019 09:07:23 +0200 (CEST)
Received: from lnxricardw1.se.axis.com (10.0.5.60) by XBOX03.axis.com
 (10.0.5.17) with Microsoft SMTP Server (TLS) id 15.0.1365.1; Wed, 28 Aug 2019
 09:07:23 +0200
Date:   Wed, 28 Aug 2019 09:07:17 +0200
From:   Ricard Wanderlof <ricard.wanderlof@axis.com>
X-X-Sender: ricardw@lnxricardw1.se.axis.com
To:     Sasha Levin <sashal@kernel.org>
CC:     Mark Brown <broonie@kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 5.2 040/123] ASoC: Fail card instantiation if
 DAI format setup fails
In-Reply-To: <20190828021311.GV5281@sasha-vm>
Message-ID: <alpine.DEB.2.20.1908280859060.5799@lnxricardw1.se.axis.com>
References: <20190814021047.14828-1-sashal@kernel.org> <20190814021047.14828-40-sashal@kernel.org> <20190814092213.GC4640@sirena.co.uk> <20190826013515.GG5281@sasha-vm> <20190827110014.GD23391@sirena.co.uk> <20190828021311.GV5281@sasha-vm>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [10.0.5.60]
X-ClientProxiedBy: XBOX04.axis.com (10.0.5.18) To XBOX03.axis.com (10.0.5.17)
X-TM-AS-GCONF: 00
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On Wed, 28 Aug 2019, Sasha Levin wrote:

> On Tue, Aug 27, 2019 at 12:00:14PM +0100, Mark Brown wrote:
> > On Sun, Aug 25, 2019 at 09:35:15PM -0400, Sasha Levin wrote:
> > > On Wed, Aug 14, 2019 at 10:22:13AM +0100, Mark Brown wrote:
> > 
> > > > > If the DAI format setup fails, there is no valid communication format
> > > > > between CPU and CODEC, so fail card instantiation, rather than
> > > continue
> > > > > with a card that will most likely not function properly.
> > 
> > > > This is another one where if nobody noticed a problem already and things
> > > > just happened to be working this might break things, it's vanishingly
> > > > unlikely to fix anything that was broken.
> > 
> > > Same as the other patch: this patch suggests it fixes a real bug, and if
> > > this patch is broken let's fix it.
> > 
> > If anyone ran into this on the older kernel and fixed or worked
> > around it locally there's a reasonable chance this will then
> > break what they're doing.  The patch itself is perfectly fine but
> 
> But there's not much we can do here. We can't hold off on fixing
> breakage such as this because existing users have workarounds for this.
> Are we breaking kernel ABI with this patch then?
> 
> And what about new users? We'll let them get hit by the issue and
> develop their own workarounds?

My $0.02 here: In my specific case, we noticed the problem because there 
was an unexpected left shift in the captured audio data, since the codec 
and CPU DAIs were using different formats when the DAI format was not 
explicitly set. The fix for that was to add

simple-audio-card,format= "i2s";

to the devicetree audio card section which of course should have been 
there all the time. The fact that the kernel failed halt the 
initialization of the audio card lengthened the debug time, but did not 
provoke me to attempt a workaround, since the information (the error 
printout from the ALSA framework when an invalid daifmt setting was made) 
was actually right there in the kernel log.

Possibly there might be other usecases, but in our case, if the kernel had 
stopped the audio initialization it would then have been more obvious 
where to start looking.

/Ricard
-- 
Ricard Wolf Wanderlof                           ricardw(at)axis.com
Axis Communications AB, Lund, Sweden            www.axis.com
Phone +46 46 272 2016                           Fax +46 46 13 61 30
