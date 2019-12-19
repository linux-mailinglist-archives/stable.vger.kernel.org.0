Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3AF125CF5
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 09:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbfLSIvW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 03:51:22 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:35934 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbfLSIvV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Dec 2019 03:51:21 -0500
Received: by mail-lj1-f194.google.com with SMTP id r19so5318973ljg.3;
        Thu, 19 Dec 2019 00:51:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ov9Gtfji50Xp++UcgIAzGw3Er9+a23OIgWl2d1OwrHg=;
        b=EN20FP3epkeMNj6iDopIt+yMSykt8bC8MJph3L8u7SIclCG4FaeXFwONqUM7Kzt3Ha
         jljqPpQk3pHj9xpUL1PIa8mgu5Sg0g7HNQv34e3PaCE4Y244RHtJhYvp+Ey+9jBQnDIA
         quhgATpiBoh2MfY9vQgsiWQAKYOPBOhZVbA1Y900svD7Hs9vCSCzjlUkcxPX+Y25LktZ
         xmI2oDIhDieEtHt//Gnd3sbFAq/TQDOSXCt2jHq1ehqcunJaAOAz3WpVJOgXUVbnHKPp
         1REEjL0h8bQpAAmiSLCBG/yCmFa3xEfH663f3Z8gFTVLgNdgKPSwwVqsJA8HBf5QL16f
         MSvA==
X-Gm-Message-State: APjAAAVTe3khlWf7apHHDecYT32abbXrHwizOwYM2vu4P78YykzJ7gz+
        WORhspyGhou7n7UAlWNRqeg=
X-Google-Smtp-Source: APXvYqxMdEb4+JsricDkSeAKpBX8G567ClLGmRraQ9zO6RotnTVmTNGEB/wBJGrYpF8kjfk9YJWZNw==
X-Received: by 2002:a2e:9013:: with SMTP id h19mr5180544ljg.223.1576745479035;
        Thu, 19 Dec 2019 00:51:19 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id w19sm2244310lfl.55.2019.12.19.00.51.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2019 00:51:18 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@kernel.org>)
        id 1ihrWc-0003vT-J6; Thu, 19 Dec 2019 09:51:14 +0100
Date:   Thu, 19 Dec 2019 09:51:14 +0100
From:   Johan Hovold <johan@kernel.org>
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Johan Hovold <johan@kernel.org>,
        Punit Agrawal <punit1.agrawal@toshiba.co.jp>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-serial@vger.kernel.org,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        nobuhiro1.iwamatsu@toshiba.co.jp, shrirang.bagul@canonical.com,
        Stable <stable@vger.kernel.org>, Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH] serdev: Don't claim unsupported serial devices
Message-ID: <20191219085114.GQ22665@localhost>
References: <20191218065646.817493-1-punit1.agrawal@toshiba.co.jp>
 <20191218085648.GI22665@localhost>
 <CAJZ5v0h-bhg4+kwTci5_wZhn9rYN=YXoCbSTVs4vPRzRFOjU8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJZ5v0h-bhg4+kwTci5_wZhn9rYN=YXoCbSTVs4vPRzRFOjU8A@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 19, 2019 at 09:39:57AM +0100, Rafael J. Wysocki wrote:
> On Wed, Dec 18, 2019 at 9:56 AM Johan Hovold <johan@kernel.org> wrote:
> >
> > On Wed, Dec 18, 2019 at 03:56:46PM +0900, Punit Agrawal wrote:
> > > Serdev sub-system claims all serial devices that are not already
> > > enumerated. As a result, no device node is created for serial port on
> > > certain boards such as the Apollo Lake based UP2. This has the
> > > unintended consequence of not being able to raise the login prompt via
> > > serial connection.
> > >
> > > Introduce a blacklist to reject devices that should not be treated as
> > > a serdev device. Add the Intel HS UART peripheral ids to the blacklist
> > > to bring back serial port on SoCs carrying them.
> > >
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Punit Agrawal <punit1.agrawal@toshiba.co.jp>
> > > Cc: Rob Herring <robh@kernel.org>
> > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Cc: Johan Hovold <johan@kernel.org>
> > > Cc: Hans de Goede <hdegoede@redhat.com>
> > > ---
> > >
> > > Hi,
> > >
> > > The patch has been updated based on feedback recieved on the RFC[0].
> > >
> > > Please consider merging if there are no objections.
> >
> > Rafael, I vaguely remember you arguing for a white list when we
> > discussed this at some conference. Do you have any objections to the
> > blacklist approach taken here?
> 
> As a rule, I prefer whitelisting, because it only enables the feature
> for systems where it has been tested and confirmed to work.
> 
> However, if you are convinced that in this particular case the feature
> should work on the vast majority of systems with a few possible
> exceptions, blacklisting is fine too.
> 
> It all depends on what the majority is, at least in principle.

Ok, thanks. I don't have a preference either way in this case simply
because I don't know the distribution you refer to.

But if Hans thinks blacklisting is the way to go then let's do that. We
haven't had that many reports about this, but if that were to change
down the line, I guess we can always switch to whitelisting.

Punit, feel free to add my

Acked-by: Johan Hovold <johan@kernel.org>

after addressing the review comments you've gotten so far.

Johan
