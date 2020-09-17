Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7F9626E33E
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 20:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbgIQSGd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 14:06:33 -0400
Received: from mailout01.rmx.de ([94.199.90.91]:40476 "EHLO mailout01.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726385AbgIQRjA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 13:39:00 -0400
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout01.rmx.de (Postfix) with ESMTPS id 4Bskg41Lcwz2SWb9;
        Thu, 17 Sep 2020 19:37:04 +0200 (CEST)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4Bskfl3XCHz2xFb;
        Thu, 17 Sep 2020 19:36:47 +0200 (CEST)
Received: from n95hx1g2.localnet (192.168.54.16) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Thu, 17 Sep
 2020 19:36:34 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     Jonathan Cameron <jic23@kernel.org>
CC:     Hartmut Knaack <knaack.h@gmx.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        <linux-iio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH v2] iio: trigger: Don't use RT priority
Date:   Thu, 17 Sep 2020 19:36:33 +0200
Message-ID: <1956630.afHySLI0iv@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <20200917181942.0d5db535@archlinux>
References: <20200917120333.2337-1-ceggers@arri.de> <20200917181942.0d5db535@archlinux>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.16]
X-RMX-ID: 20200917-193653-4Bskfl3XCHz2xFb-0@kdin01
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jonathan,

On Thursday, 17 September 2020, 19:19:42 CEST, Jonathan Cameron wrote:
> On Thu, 17 Sep 2020 14:03:33 +0200 Christian Eggers <ceggers@arri.de> wrote:
> > Triggers may raise transactions on slow busses like I2C.  Using the
> > original RT priority of a threaded IRQ may prevent other important IRQ
> > handlers from being run.
> > 
> > Signed-off-by: Christian Eggers <ceggers@arri.de>
> > Cc: stable@vger.kernel.org
> > ---
> > In my particular case (on a RT kernel), the RT priority of the sysfstrig
> > threaded IRQ handler caused (temporarily) raising the prio of a user
> > space process which was holding the I2C bus mutex.
> > 
> > Due to a bug in the i2c-imx driver, this process spent 500 ms in a
> > busy-wait loop and prevented all threaded IRQ handlers from being run
> > during this time.
> 
> I'm not sure I fully understand the impacts of this yet.
> 
> What is the impact on cases where we don't have any nasty side affects
> due to users of the trigger?
The problem was not the user of the trigger. The problem was the (shared)
resource (I2C bus) which the triggered iio driver uses. I would say
that the i2c-imx driver is not "RT safe" [1]. This means that the driver performs
busy-waiting, which is less a problem for normal priorities than for RT. If the
busy-wait loop is run with RT prio, it will block everything else, even
(threaded) interrupt handlers.

> I presume reducing the priority will cause some reduction in
> performance?  If so is there any chance that would count as a regression?
I expect that other user will complain if we do this, yes. But I would like to
open the discussion, which priority is the "correct" one, or how this could be
set up from user space. According to [2], there is not much value choosing the
priority inside the kernel. Simply changing the priority of the trigger task
using "chrt" seems difficult, as this can (currently) not be done of using
libiio.

> 
> Jonathan
> 
> > v2:
> > - Use sched_set_normal() instead of sched_setscheduler_nocheck()
> > 
> >  drivers/iio/industrialio-trigger.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> > 

[1] https://lore.kernel.org/patchwork/cover/1307330/
[2] https://lwn.net/Articles/818388/



