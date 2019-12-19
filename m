Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A18FE125CD2
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 09:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbfLSIkK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 03:40:10 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:34500 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbfLSIkK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Dec 2019 03:40:10 -0500
Received: by mail-ot1-f66.google.com with SMTP id a15so6291165otf.1;
        Thu, 19 Dec 2019 00:40:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zIXZalq04LBeurRmUsXDwQBqFcS1M0HasBcmmTmIlxQ=;
        b=MMoXC+a6rAJRb0xeQlxM3FIUAxOEQY5J1w3H1qEDQcqZZH87keFEQR3PAnkGRDfc+2
         JWRqLKKWoG4mhuFkzS+ns8pFBHzVGSr3wQjwU5+odK2HMAwO26GIk+aiScXxDzbMYaUN
         EJM+xIDYu7dTsognQY6gu8+NVRA2Q+2KCYBlzk/XDwBgJ05wZEOlfn5lu5kY1Tp1giiT
         ysvn65LYMn85Nb0NP2IG5klGipiquu5jnjim1cYnscL/uueEMkAzCpIHK2Btax1SPu/9
         qQOBZrmkyqDJ83wrS7oY8p/Y3Q5yeoSsoLR41LYfnjAT7ufqZBQVl+atStVZ/4bXmylZ
         Tu8A==
X-Gm-Message-State: APjAAAXPnULjKio5TZ9bVH77G6DwOw9h2oHBFKsLD3FH6GL4+lyZyW4Z
        ZUnQ0snXwjTrEAifB8bH/XDVAAy8BVcGsjrvTd4=
X-Google-Smtp-Source: APXvYqwJxYZRBNs7Xidhl6mJ9YLQXeaJFwuyh/2N/hfG893lDh3Q3LEHxkyFazwfj4VXO/+aY/lj44v8g5vhcDIQKzc=
X-Received: by 2002:a9d:62c7:: with SMTP id z7mr2393332otk.189.1576744808992;
 Thu, 19 Dec 2019 00:40:08 -0800 (PST)
MIME-Version: 1.0
References: <20191218065646.817493-1-punit1.agrawal@toshiba.co.jp> <20191218085648.GI22665@localhost>
In-Reply-To: <20191218085648.GI22665@localhost>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 19 Dec 2019 09:39:57 +0100
Message-ID: <CAJZ5v0h-bhg4+kwTci5_wZhn9rYN=YXoCbSTVs4vPRzRFOjU8A@mail.gmail.com>
Subject: Re: [PATCH] serdev: Don't claim unsupported serial devices
To:     Johan Hovold <johan@kernel.org>
Cc:     Punit Agrawal <punit1.agrawal@toshiba.co.jp>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-serial@vger.kernel.org,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        nobuhiro1.iwamatsu@toshiba.co.jp, shrirang.bagul@canonical.com,
        Stable <stable@vger.kernel.org>, Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans de Goede <hdegoede@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 18, 2019 at 9:56 AM Johan Hovold <johan@kernel.org> wrote:
>
> On Wed, Dec 18, 2019 at 03:56:46PM +0900, Punit Agrawal wrote:
> > Serdev sub-system claims all serial devices that are not already
> > enumerated. As a result, no device node is created for serial port on
> > certain boards such as the Apollo Lake based UP2. This has the
> > unintended consequence of not being able to raise the login prompt via
> > serial connection.
> >
> > Introduce a blacklist to reject devices that should not be treated as
> > a serdev device. Add the Intel HS UART peripheral ids to the blacklist
> > to bring back serial port on SoCs carrying them.
> >
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Punit Agrawal <punit1.agrawal@toshiba.co.jp>
> > Cc: Rob Herring <robh@kernel.org>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: Johan Hovold <johan@kernel.org>
> > Cc: Hans de Goede <hdegoede@redhat.com>
> > ---
> >
> > Hi,
> >
> > The patch has been updated based on feedback recieved on the RFC[0].
> >
> > Please consider merging if there are no objections.
>
> Rafael, I vaguely remember you arguing for a white list when we
> discussed this at some conference. Do you have any objections to the
> blacklist approach taken here?

As a rule, I prefer whitelisting, because it only enables the feature
for systems where it has been tested and confirmed to work.

However, if you are convinced that in this particular case the feature
should work on the vast majority of systems with a few possible
exceptions, blacklisting is fine too.

It all depends on what the majority is, at least in principle.
