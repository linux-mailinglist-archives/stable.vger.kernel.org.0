Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9FF714DF74
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 17:52:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727224AbgA3Qwt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 11:52:49 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38477 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727191AbgA3Qwt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jan 2020 11:52:49 -0500
Received: by mail-pf1-f195.google.com with SMTP id x185so1786776pfc.5;
        Thu, 30 Jan 2020 08:52:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BvfCsRSZW1p/nohOgM8F2lAATYVhdALP/v8/1rJaWIw=;
        b=HIi64FJTLjxHew/88/vrJXKhLDqR8R6QvnJtquI3iltIEjCjSU1nAGjAshfg/9V9k+
         3sZ8U+mmzEqNjIIkiWs8lLFeknSwKyfIuhqNcMYZcVZM5jKTgARs/qGz6lUSx0ccoNbC
         ZpV02kmTCZFjFZBtt1jcUYnNRYr1fWLDECu3ZFQGmMsj8QcBmhc86WtTyjscXB/AgZRq
         iXUANo6paHHqqmuCLPB9UHL9n1MvZzdWGm3lrrtQsD7amMO22ZWf9jx/mXkeAsiLQRGc
         vN+fCNiweFpIQautL2z4APqMNgDe8Q0DJ2weSJdZ4gjtqTGFfkI3S1Ed88Ud7CFgJJiD
         x3BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BvfCsRSZW1p/nohOgM8F2lAATYVhdALP/v8/1rJaWIw=;
        b=cDomHDO4NcACGybuJsFcTj8FC0EfJIooowQpFbGQNAc8KoseWt9wo28ryri5+udAAC
         5d0BroVRLi/yHrfCr1IjYVABoE1ROb/24XZ5DlDXGc7hPMZ8JKWotyfrK66MBlertZqU
         aZCNm86YSlVJifcWnhU0kZyxvfm/V+uVybos8tKyqzSnl1s5Zb7L2yPP5a3BVo4tpSUX
         0P3s8lLpF6L8+iJbCsplCzw4EftTuK3RKGeWqHKCsYLDnoEtv43FyLF//Zr0w+VCq9eI
         7zxJGRHQwKkLrB2vjJIpTF1ejJLsf3zCcq4shxiSIaKe9wQqAD7v31HWiqkEaHd9vDsp
         Khzg==
X-Gm-Message-State: APjAAAVklXs8U+A3lDZuX0Mr0YTCyqOorXb0cQg282MnLzjFpETQw9IT
        xd/27wAyQsTqQ9oSEKFJpYkk+ExbUg8dr/Ywr+o=
X-Google-Smtp-Source: APXvYqwEWnwqoePrgk5yXHpSjK3/YcAPZ1WeBxbdIORS5G9gXGM6VV7cscOzUakL5hFPRk8ijdgGnN27LxoUDdzE3YI=
X-Received: by 2002:a62:1944:: with SMTP id 65mr6090835pfz.151.1580403168985;
 Thu, 30 Jan 2020 08:52:48 -0800 (PST)
MIME-Version: 1.0
References: <20200130115255.20840-1-hdegoede@redhat.com> <20200130115255.20840-3-hdegoede@redhat.com>
 <20200130134310.GX14914@hirez.programming.kicks-ass.net> <b77be8c0-7107-bece-5947-a625e556e129@redhat.com>
 <01feee20ee5d4b83ab218c14fc35accb@AcuMS.aculab.com> <8a8fd7a1-945e-4541-f0bc-387fae7c6822@redhat.com>
In-Reply-To: <8a8fd7a1-945e-4541-f0bc-387fae7c6822@redhat.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Thu, 30 Jan 2020 18:52:41 +0200
Message-ID: <CAHp75VftbK+7uzBCQ6F5FFgJ4qq0f9pB1Qo7m0LwbBROYsrrYw@mail.gmail.com>
Subject: Re: [PATCH 3/3] x86/tsc_msr: Make MSR derived TSC frequency more accurate
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     David Laight <David.Laight@aculab.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Vipul Kumar <vipulk0511@gmail.com>,
        Vipul Kumar <vipul_kumar@mentor.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Srikanth Krishnakar <Srikanth_Krishnakar@mentor.com>,
        Cedric Hombourger <Cedric_Hombourger@mentor.com>,
        Len Brown <len.brown@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 30, 2020 at 6:04 PM Hans de Goede <hdegoede@redhat.com> wrote:
> On 30-01-2020 17:02, David Laight wrote:

> I have no idea. Andy if you can find any docs on the MSR_FSB_FREQ values
> for Merriefield (BYT MID) and Moorefield (CHT MID) that would be great,
> if not I suggest we stick with what we have.

First of all, Merrifield (Silvermont based Atom for phones, FYI: Intel
Edison uses it) and Moorefield (Airmont) have nothing to do with code
names Baytrail and Cherrytrail respectively.
So, please don't confuse people.

I'll try to find some information.

-- 
With Best Regards,
Andy Shevchenko
