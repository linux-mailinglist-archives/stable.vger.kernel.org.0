Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF6D1C5814
	for <lists+stable@lfdr.de>; Tue,  5 May 2020 16:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729182AbgEEOFo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 May 2020 10:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728707AbgEEOFo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 May 2020 10:05:44 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39D56C061A0F;
        Tue,  5 May 2020 07:05:44 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id h11so851797plr.11;
        Tue, 05 May 2020 07:05:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q8WIz3FHXamstQ5RROHKWV22yynOgMb/3OWiPvwcH58=;
        b=tQWT+am+PDIVhoLRtKQN601nKRhuHxjkHmD2ua/WG/JmA/HfvqnGjf2gnt42shavh1
         gO0jskK+eEDNeD4EKB2n5QkqloIcRL5XyP6XMUwEDDpl7S0LefZj4R+NN/GsGOjwSxBt
         ZQDznhzLfiSqR5I7HEeaFW6K2ImpedhcAof1XmLedvomwktlLT/WLz0cjwhCsafUytbS
         zzQOwGZtIpoGUSZHcn9biw61unvfFzzrTI5Slx9pSvPLBBZUJYJEN/7x36Srcr1M47YG
         N+iES3xdTY/ge8TVqkVEEs4BtREh8KJEfYXsS2Mm0HgLjr+/6fl7/N8qLI7ZkJh4VdIH
         jxGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q8WIz3FHXamstQ5RROHKWV22yynOgMb/3OWiPvwcH58=;
        b=Dpd4mi1c+PDQU76Q9mipmGpuiY2wHHLwb7nim0kvIqAePGK8sbyrVAlJWNG/7Qu3ZK
         1uMvB2IYRFA1GtEyNKoUfNcc1SmxLeh9cxHBePvfoum8pIjbIyHNT+nUUWNJTixXb0PO
         T91AF/giaoFzkcuzbCwckol38lp5Z/MMBOhiyMM8IOoHgcO45ifV+HZZgWObseteQL/m
         HsgFwQmSILAF0Do6aI9QQmSLrCFEw5fiKshfA6gn2IqEjdLoPxh65D4gCzHANkbHCR19
         HLvPBkGui93mUvi+Cel+wwMtdENIl7wwAiK3ZnIDlGkrJ+X6zjvyHC/WRdB9qNpR4ufM
         VEWQ==
X-Gm-Message-State: AGi0PuZU2SxL4oJIKbnUT3afIvnsKAxDwOD6ZDNowGsFRPLxnhQKETw7
        zy48bBLuiuP3mWxDXbpmSBycpZMlj+jOSU5Rjvg=
X-Google-Smtp-Source: APiQypJ62mwSQkFfLZx/rBqZHd6X5lul6H7QgfJRLPEdsV/Il7XmM4/gfZ8p9W1VY92PM68a4Y7lh17/kbNHBRZQoo4=
X-Received: by 2002:a17:90a:fa81:: with SMTP id cu1mr3316017pjb.25.1588687543700;
 Tue, 05 May 2020 07:05:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200504165448.264746645@linuxfoundation.org> <20200504165451.307643203@linuxfoundation.org>
 <20200505123159.GC28722@amd> <CAHp75VeM+qwh5rHL7RDdacru0jPSB9me2aTs__jdy749dTKRng@mail.gmail.com>
 <20200505125818.GA31126@amd> <CAHp75VcKreeQpjROdL23XGqgVu+F_0eL5DsJ=5APEQUO9V69EQ@mail.gmail.com>
 <20200505133700.GA31753@amd>
In-Reply-To: <20200505133700.GA31753@amd>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 5 May 2020 17:05:37 +0300
Message-ID: <CAHp75Ve+pzhamZXiKxHF+VD8yfsjRF2coattHyiD+0aa7Fy2DA@mail.gmail.com>
Subject: Re: [PATCH 4.19 28/37] dmaengine: dmatest: Fix iteration non-stop logic
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 5, 2020 at 4:37 PM Pavel Machek <pavel@denx.de> wrote:
> On Tue 2020-05-05 16:19:11, Andy Shevchenko wrote:
> > On Tue, May 5, 2020 at 3:58 PM Pavel Machek <pavel@denx.de> wrote:
> > > On Tue 2020-05-05 15:51:16, Andy Shevchenko wrote:
> > > > On Tue, May 5, 2020 at 3:37 PM Pavel Machek <pavel@denx.de> wrote:
> > > > > > So, to the point, the conditional of checking the thread to be stopped being
> > > > > > first part of conjunction logic prevents to check iterations. Thus, we have to
> > > > > > always check both conditions

vvv
>>>>>> to be able to stop after given iterations.
^^^

...

> > > Yeah, I pointed that out above. Both && and || permit short
> > > execution. But that does not matter, as neither "params->iterations"
> > > nor "total_tests >= params->iterations" have side effects.
> > >
> > > Where is the runtime difference?
> >
> > We have to check *both* conditions. If we don't check iterations, we
> > just wait indefinitely until somebody tells us to stop.
> > Everything in the commit message and mentioned there commit IDs which
> > you may check.
>
> No.

Yes. Please, read carefully the commit message (for your convenience I
emphasized above). I don't want to spend time on this basics stuff
anymore.

> If kthread_should_stop() is true, we break the loop. Both old code and
> new code does that. Neither old nor new code checks the
> "params->iterations && total_tests >=dparams->iterations" condition,
> as both && and || do short execution).
>
> If you wanted both conditions to always evaluate, you'd have to do
>
> #       while (!kthread_should_stop()
> #              & !(params->iterations && total_tests >=
> #              params->iterations)) {
>
> (note && -> &). But, again, there's no reason to do that, as second
> part of expression does not have side effects.

It fixes a bug in the code, try with and without this change. (I can
reproduce it here)

-- 
With Best Regards,
Andy Shevchenko
