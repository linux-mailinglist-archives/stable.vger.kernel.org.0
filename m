Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84BD0ABB9B
	for <lists+stable@lfdr.de>; Fri,  6 Sep 2019 17:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393172AbfIFPAi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Sep 2019 11:00:38 -0400
Received: from bastet.se.axis.com ([195.60.68.11]:39490 "EHLO
        bastet.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbfIFPAi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Sep 2019 11:00:38 -0400
Received: from localhost (localhost [127.0.0.1])
        by bastet.se.axis.com (Postfix) with ESMTP id 0A0791806E;
        Fri,  6 Sep 2019 17:00:35 +0200 (CEST)
X-Axis-User: NO
X-Axis-NonUser: YES
X-Virus-Scanned: Debian amavisd-new at bastet.se.axis.com
Received: from bastet.se.axis.com ([IPv6:::ffff:127.0.0.1])
        by localhost (bastet.se.axis.com [::ffff:127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id 2IlZI_wW4E_E; Fri,  6 Sep 2019 17:00:34 +0200 (CEST)
Received: from boulder02.se.axis.com (boulder02.se.axis.com [10.0.8.16])
        by bastet.se.axis.com (Postfix) with ESMTPS id 1018918502;
        Fri,  6 Sep 2019 17:00:34 +0200 (CEST)
Received: from boulder02.se.axis.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EB50A1A066;
        Fri,  6 Sep 2019 17:00:33 +0200 (CEST)
Received: from boulder02.se.axis.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE8721A064;
        Fri,  6 Sep 2019 17:00:33 +0200 (CEST)
Received: from seth.se.axis.com (unknown [10.0.2.172])
        by boulder02.se.axis.com (Postfix) with ESMTP;
        Fri,  6 Sep 2019 17:00:33 +0200 (CEST)
Received: from XBOX03.axis.com (xbox03.axis.com [10.0.5.17])
        by seth.se.axis.com (Postfix) with ESMTP id D14302B14;
        Fri,  6 Sep 2019 17:00:33 +0200 (CEST)
Received: from lnxricardw1.se.axis.com (10.0.5.60) by XBOX03.axis.com
 (10.0.5.17) with Microsoft SMTP Server (TLS) id 15.0.1365.1; Fri, 6 Sep 2019
 17:00:33 +0200
Date:   Fri, 6 Sep 2019 17:00:28 +0200
From:   Ricard Wanderlof <ricard.wanderlof@axis.com>
X-X-Sender: ricardw@lnxricardw1.se.axis.com
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@kernel.org>
CC:     Sasha Levin <sashal@kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: revert: ASoC: Fail card instantiation if DAI format setup fails
Message-ID: <alpine.DEB.2.20.1909061658580.3985@lnxricardw1.se.axis.com>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [10.0.5.60]
X-ClientProxiedBy: XBOX03.axis.com (10.0.5.17) To XBOX03.axis.com (10.0.5.17)
X-TM-AS-GCONF: 00
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Sorry for the repost, I relized I stupidly got Greg's email adress wrong 
first time around.

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
