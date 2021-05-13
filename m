Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFF6937F575
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 12:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232582AbhEMKRt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 06:17:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:35352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232210AbhEMKRs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 May 2021 06:17:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B552F60BBB;
        Thu, 13 May 2021 10:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620900999;
        bh=9mx64i2ye6mYOE0EgEZi6wEx5WuvNuC7b+6fth4sHRs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fT+uSct0TKlsmlxxNjtcP8KkOIRvdFvUuuT4JVlrdsQNXxBqyuTZmuokL1a7/MYkb
         Tws3+xDFfWO8Bud3vZw891GM4AC4rR4UosyAr/pDffsRB3rV1N/yz8R37LCEgZhmZR
         CZLJiSvQYVYlpkJGZYSSJsUJeS8PlXYoVW7PgMDE=
Date:   Thu, 13 May 2021 12:16:36 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Szymon Janc <szymon.janc@codecoup.pl>
Cc:     Kai Krakow <kai@kaishome.de>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] Bluetooth: Remove spurious error message
Message-ID: <YJz8hJ+9N24wrIsq@kroah.com>
References: <20210512133407.52330-1-szymon.janc@codecoup.pl>
 <CAC2ZOYvax0WGO7wMzbPXQMGb2NDouAF6XRgd5TH+h-f6uWvhtg@mail.gmail.com>
 <CABBYNZKBW1wtTbkmcQbAybGm7zdcur16935yGNwid9oiGOxNFQ@mail.gmail.com>
 <4321662.LvFx2qVVIh@ix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4321662.LvFx2qVVIh@ix>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 13, 2021 at 10:09:49AM +0200, Szymon Janc wrote:
> Hi,
> 
> On Wednesday, 12 May 2021 20:13:19 CEST Luiz Augusto von Dentz wrote:
> > Hi Kai,
> > 
> > On Wed, May 12, 2021 at 11:06 AM Kai Krakow <kai@kaishome.de> wrote:
> > > Hi Szymon!
> > > 
> > > Am Mi., 12. Mai 2021 um 15:34 Uhr schrieb Szymon Janc 
> <szymon.janc@codecoup.pl>:
> > > > Even with rate limited reporting this is very spammy and since
> > > > it is remote device that is providing bogus data there is no
> > > > need to report this as error.
> > > 
> > > [...]
> > > 
> > > > [72464.546319] Bluetooth: hci0: advertising data len corrected
> > > > [72464.857318] Bluetooth: hci0: advertising data len corrected
> > > > [72465.163332] Bluetooth: hci0: advertising data len corrected
> > > > [72465.278331] Bluetooth: hci0: advertising data len corrected
> > > > [72465.432323] Bluetooth: hci0: advertising data len corrected
> > > > [72465.891334] Bluetooth: hci0: advertising data len corrected
> > > > [72466.045334] Bluetooth: hci0: advertising data len corrected
> > > > [72466.197321] Bluetooth: hci0: advertising data len corrected
> > > > [72466.340318] Bluetooth: hci0: advertising data len corrected
> > > > [72466.498335] Bluetooth: hci0: advertising data len corrected
> > > > [72469.803299] bt_err_ratelimited: 10 callbacks suppressed
> > > > 
> > > > Signed-off-by: Szymon Janc <szymon.janc@codecoup.pl>
> > > > Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=203753
> > > > Cc: stable@vger.kernel.org
> > > > ---
> > > > 
> > > >  net/bluetooth/hci_event.c | 2 --
> > > >  1 file changed, 2 deletions(-)
> > > > 
> > > > diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> > > > index 5e99968939ce..abdc44dc0b2f 100644
> > > > --- a/net/bluetooth/hci_event.c
> > > > +++ b/net/bluetooth/hci_event.c
> > > > @@ -5476,8 +5476,6 @@ static void process_adv_report(struct hci_dev
> > > > *hdev, u8 type, bdaddr_t *bdaddr,> > 
> > > >         /* Adjust for actual length */
> > > >         if (len != real_len) {
> > > > 
> > > > -               bt_dev_err_ratelimited(hdev, "advertising data len
> > > > corrected %u -> %u", -                                      len,
> > > > real_len);
> > > > 
> > > >                 len = real_len;
> > > >         
> > > >         }
> > > 
> > > This renders the "if" quite useless since it now always ensures len =
> > > real_len and nothing else. At this point, the "if" can be removed, and
> > > len can be set unconditionally. Depending on the further context of
> > > the patch, destinction between real_len and len may not be needed at
> > > all and real_len could be renamed to len, ditching the unused original
> > > which is potentially bogus data anyways according to your commit
> > > description.
> > 
> > That was introduced to truncate the len, the patch just removes the
> > logging but it does keep this logic, if you want to understand the
> > reason for it just use git blame and look at the history.
> 
> Actually, with no log there is no need for this "if" and real_len could be 
> indeed avoided.
> 
> But I'd change this is subsequent patch which would not be tagged as stable 
> candidate. Thoughts?

Fix it properly, and worry about stable trees later, they can also
always take the correct change as well.

thanks,

greg k-h
