Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF96112B75
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 13:26:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727508AbfLDM0n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 07:26:43 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:36216 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726604AbfLDM0n (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Dec 2019 07:26:43 -0500
Received: by mail-ot1-f68.google.com with SMTP id i4so6154857otr.3;
        Wed, 04 Dec 2019 04:26:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C7FUgrpVbFgMV7hB8X3J8NH3VmoD7pIkx0fvAtoJl14=;
        b=cyKr4oHvjQNChh0aRFtziajwGeXRy9geuHKBGnhzjDRp9+2+dGkJdJpCOW5XwvViBv
         D5TUtokXrOKCZmXWvYabSFJ+p9DFN1WAL0GfHVdA7oHoCv5XUD6aVAlQwFdzuWTe67ye
         KD+gEumdsykSxvM6UyH6A2ZivVD5nROxgP/UGJrHYglJUirgJpyyPXeDno0ZOrQJgUPx
         HrqaZnt3gQ0yMhXuCcfYrC08kUM62kYMknbmpMODTyS6d8cdRLMftTJ4oigMBtlAoyQN
         2Q3BZ9PLo8XIHRPdrhj1Y2UTlzVDnqS1lI+bekRWLZjvIhRi4u5ujW+MgUpcv2hC2cKd
         IXnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C7FUgrpVbFgMV7hB8X3J8NH3VmoD7pIkx0fvAtoJl14=;
        b=FbPzWsVoJf8wyZTSEuJ4N5Fy3XAijLX8+qxAAtKBf06KDTs5weSFdGNvMy6sKsBjIu
         nsFIX9yg9W+lUT2R5ey2PcYaeLQp1x1FruOJk87hyiSz+fMWheXaCJXjBz7i9vWldz1B
         t9iDufAEHEC/GpwvEQfVBGSB3+TiPH6lgsoeYs3ypExwqWZRFIUc4MxlB03RyJbN5QS2
         QOtUg3mNxYUmUYk7IoycBaut/yp/CZJWG0SijKd5nmL1OmUWzT7buU7bXMYzTLwjoxWb
         dPwQECNYdy92DibDseEDzvlHz33im5DJ0WciRPl4qJOhHYc9dCqrdZOgVw5z3XdfMvDL
         RCLw==
X-Gm-Message-State: APjAAAVpgo6uDi+KQfVtH0fLVilOgng+xUSitTjaznsovA8Upd7WJ5xd
        xHIzbYRJ/MQ3Aq/eugIBN4OoHewbLhvKQFBi2kY=
X-Google-Smtp-Source: APXvYqweNw08GXWx+kM/1+NI1aJBTxWamovIGt0kZ1jYbN7DurSqHASvb3kud3i7thvmlNTJ8sRF9Rj33VSofmlfByc=
X-Received: by 2002:a05:6830:1705:: with SMTP id 5mr2356801otk.72.1575462402290;
 Wed, 04 Dec 2019 04:26:42 -0800 (PST)
MIME-Version: 1.0
References: <20191203223427.103571230@linuxfoundation.org> <20191203223429.401517191@linuxfoundation.org>
 <20191204115623.GA25176@duo.ucw.cz> <58738070c6a7df72451f4384567798887bac4c8a.camel@sipsolutions.net>
In-Reply-To: <58738070c6a7df72451f4384567798887bac4c8a.camel@sipsolutions.net>
From:   Ahmed Zaki <anzaki@gmail.com>
Date:   Wed, 4 Dec 2019 14:26:06 +0200
Message-ID: <CANczwAHaRT1=heEamuMiS=6dme4r+P+f7g97Rargn_1rpSCLgg@mail.gmail.com>
Subject: Re: [PATCH 4.19 044/321] mac80211: fix station inactive_time shortly
 after boot
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 4 Dec 2019 at 14:05, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Wed, 2019-12-04 at 11:56 +0000, Pavel Machek wrote:
>
> > > -   if (time_after(stats->last_rx, sta->status_stats.last_ack))
> > > +   if (!sta->status_stats.last_ack ||
> > > +       time_after(stats->last_rx, sta->status_stats.last_ack))
> > >             return stats->last_rx;
> > >     return sta->status_stats.last_ack;
> > >  }
> >
> > I mean, jiffies do wrapraound periodically, so eventually we'll have
> > sta->status_stats.last_ack == 0 even through it is not short after
> > boot, no?
>
> Yeah. I contemplated that when I applied the original patch - it's a bit
> complicated otherwise, you have to track "is this valid" etc.
>
> Since this is updated on pretty much every frame, it's highly unlikely
> you'll go without the value for long, so I figured this was good enough.
>
> johannes
>

That happened when I was testing an IBSS network, so a unit would have
last_ack = 0
for some neighbours for extended period of time, but last_rx was
always valid (from
broadcasts and beacons I guess). In this case, it makes sense to use
last_rx, no matter
jiffies had wrapped around or not.

For STA/AP situations, last_ack should pretty much be valid and non-zero.

Ahmed
