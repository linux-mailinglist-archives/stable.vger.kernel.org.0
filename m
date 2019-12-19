Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F04F9125D13
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 09:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbfLSI5h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 03:57:37 -0500
Received: from mo-csw1515.securemx.jp ([210.130.202.154]:42438 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbfLSI5h (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Dec 2019 03:57:37 -0500
Received: by mo-csw.securemx.jp (mx-mo-csw1515) id xBJ8vJro018437; Thu, 19 Dec 2019 17:57:19 +0900
X-Iguazu-Qid: 34tKThYsqI7CuVd7ye
X-Iguazu-QSIG: v=2; s=0; t=1576745839; q=34tKThYsqI7CuVd7ye; m=O3BnQ2bs5DsNfd7TZPZJZDHDPfXbewPgW32ALy13FeM=
Received: from imx12.toshiba.co.jp (imx12.toshiba.co.jp [61.202.160.132])
        by relay.securemx.jp (mx-mr1511) id xBJ8vHQN019037;
        Thu, 19 Dec 2019 17:57:18 +0900
Received: from enc02.toshiba.co.jp ([61.202.160.51])
        by imx12.toshiba.co.jp  with ESMTP id xBJ8vHvf001484;
        Thu, 19 Dec 2019 17:57:17 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id xBJ8vH2O017194;
        Thu, 19 Dec 2019 17:57:17 +0900
From:   Punit Agrawal <punit1.agrawal@toshiba.co.jp>
To:     Johan Hovold <johan@kernel.org>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        <linux-serial@vger.kernel.org>,
        "ACPI Devel Maling List" <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <nobuhiro1.iwamatsu@toshiba.co.jp>, <shrirang.bagul@canonical.com>,
        Stable <stable@vger.kernel.org>, Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Hans de Goede" <hdegoede@redhat.com>
Subject: Re: [PATCH] serdev: Don't claim unsupported serial devices
References: <20191218065646.817493-1-punit1.agrawal@toshiba.co.jp>
        <20191218085648.GI22665@localhost>
        <CAJZ5v0h-bhg4+kwTci5_wZhn9rYN=YXoCbSTVs4vPRzRFOjU8A@mail.gmail.com>
        <20191219085114.GQ22665@localhost>
Date:   Thu, 19 Dec 2019 17:58:08 +0900
In-Reply-To: <20191219085114.GQ22665@localhost> (Johan Hovold's message of
        "Thu, 19 Dec 2019 09:51:14 +0100")
X-TSB-HOP: ON
Message-ID: <875zicofof.fsf@kokedama.swc.toshiba.co.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Johan Hovold <johan@kernel.org> writes:

> On Thu, Dec 19, 2019 at 09:39:57AM +0100, Rafael J. Wysocki wrote:
>> On Wed, Dec 18, 2019 at 9:56 AM Johan Hovold <johan@kernel.org> wrote:
>> >
>> > On Wed, Dec 18, 2019 at 03:56:46PM +0900, Punit Agrawal wrote:
>> > > Serdev sub-system claims all serial devices that are not already
>> > > enumerated. As a result, no device node is created for serial port on
>> > > certain boards such as the Apollo Lake based UP2. This has the
>> > > unintended consequence of not being able to raise the login prompt via
>> > > serial connection.
>> > >
>> > > Introduce a blacklist to reject devices that should not be treated as
>> > > a serdev device. Add the Intel HS UART peripheral ids to the blacklist
>> > > to bring back serial port on SoCs carrying them.
>> > >
>> > > Cc: stable@vger.kernel.org
>> > > Signed-off-by: Punit Agrawal <punit1.agrawal@toshiba.co.jp>
>> > > Cc: Rob Herring <robh@kernel.org>
>> > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> > > Cc: Johan Hovold <johan@kernel.org>
>> > > Cc: Hans de Goede <hdegoede@redhat.com>
>> > > ---
>> > >
>> > > Hi,
>> > >
>> > > The patch has been updated based on feedback recieved on the RFC[0].
>> > >
>> > > Please consider merging if there are no objections.
>> >
>> > Rafael, I vaguely remember you arguing for a white list when we
>> > discussed this at some conference. Do you have any objections to the
>> > blacklist approach taken here?
>> 
>> As a rule, I prefer whitelisting, because it only enables the feature
>> for systems where it has been tested and confirmed to work.
>> 
>> However, if you are convinced that in this particular case the feature
>> should work on the vast majority of systems with a few possible
>> exceptions, blacklisting is fine too.
>> 
>> It all depends on what the majority is, at least in principle.
>
> Ok, thanks. I don't have a preference either way in this case simply
> because I don't know the distribution you refer to.
>
> But if Hans thinks blacklisting is the way to go then let's do that. We
> haven't had that many reports about this, but if that were to change
> down the line, I guess we can always switch to whitelisting.
>
> Punit, feel free to add my
>
> Acked-by: Johan Hovold <johan@kernel.org>
>
> after addressing the review comments you've gotten so far.

Thanks Johan.

I will post a new version with the updates and acks.
