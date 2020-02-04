Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B61B51518A8
	for <lists+stable@lfdr.de>; Tue,  4 Feb 2020 11:14:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbgBDKOa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Feb 2020 05:14:30 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:41887 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726684AbgBDKOa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Feb 2020 05:14:30 -0500
Received: by mail-lj1-f193.google.com with SMTP id h23so17959196ljc.8;
        Tue, 04 Feb 2020 02:14:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YroDskDtOiHLDDMcrVefUIpLn8oU+NjUW8m8Wr0DB+0=;
        b=sEMB/MkGhQYTHekGCt/zaKVDl9fnK7aJkgeP2aoNxiNyGs7QvV3k51sy1kDtDdNb/8
         YeeydrNe++ltk98zHoWjqWEs8gZNL0KgqHUOgb0AVJz9ty9eJVl7UJpXRNMpH/sYYSax
         2S0yXnQTUXNJqGZF5LvwGnK/KOb7TYFjpt5bfWubwSG0eGcaq/UZJI87TY8G6XFX+Mw3
         ZHVMxh7bMy4iH6ROgJ0fa6HdQadfuF2FcIc+VWyl+GnBbm7KlX9RSV03pNLRzqicok1R
         2gRpcDrBbSxdo1878dcvNv+91+C0HUV1VMkNiPqcknhrJWb2xoAVAvWso1SHoQrp3nUb
         seLw==
X-Gm-Message-State: APjAAAXj0EPivO4Ov32x8pPZPr16yKhnbq0ifDAim/9qmPZAwLdMhAoy
        0B79Ozaycn6qDeXYZfu9I6cbPhWE
X-Google-Smtp-Source: APXvYqxvN2spd0grsAdJdC39ryTTu164g1OIKcHz1JEILoyVxWuZXhzV7+rWFIUGZPtBNaSu8ojCIA==
X-Received: by 2002:a2e:9a93:: with SMTP id p19mr16872179lji.177.1580811266356;
        Tue, 04 Feb 2020 02:14:26 -0800 (PST)
Received: from xi.terra (c-12aae455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.170.18])
        by smtp.gmail.com with ESMTPSA id f4sm11211472ljo.79.2020.02.04.02.14.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2020 02:14:25 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@kernel.org>)
        id 1iyvE3-0003Wz-57; Tue, 04 Feb 2020 11:14:35 +0100
Date:   Tue, 4 Feb 2020 11:14:35 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Johan Hovold <johan@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        stable@vger.kernel.org, linux-input@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Kepplinger <martink@posteo.de>
Subject: Re: [PATCH 1/7] Input: pegasus_notetaker: fix endpoint sanity check
Message-ID: <20200204101435.GH26725@localhost>
References: <20191210113737.4016-1-johan@kernel.org>
 <20191210113737.4016-2-johan@kernel.org>
 <20200204082441.GD26725@localhost>
 <20200204100232.GB1088789@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200204100232.GB1088789@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 04, 2020 at 10:02:32AM +0000, Greg Kroah-Hartman wrote:
> On Tue, Feb 04, 2020 at 09:24:41AM +0100, Johan Hovold wrote:
> > On Tue, Dec 10, 2019 at 12:37:31PM +0100, Johan Hovold wrote:
> > > The driver was checking the number of endpoints of the first alternate
> > > setting instead of the current one, something which could be used by a
> > > malicious device (or USB descriptor fuzzer) to trigger a NULL-pointer
> > > dereference.
> > > 
> > > Fixes: 1afca2b66aac ("Input: add Pegasus Notetaker tablet driver")
> > > Cc: stable <stable@vger.kernel.org>     # 4.8
> > > Cc: Martin Kepplinger <martink@posteo.de>
> > > Signed-off-by: Johan Hovold <johan@kernel.org>
> > 
> > Looks like the stable tag was removed when this one was applied, and
> > similar for patches 2, 4 and 7 of this series (commits 3111491fca4f,
> > a8eeb74df5a6, 6b32391ed675 upstream).
> > 
> > While the last three are mostly an issue for the syzbot fuzzer, we have
> > started backporting those as well.
> > 
> > This one (bcfcb7f9b480) is more clear cut as it can be used to trigger a
> > NULL-deref.
> > 
> > I only noticed because Sasha picked up one of the other patches in the
> > series which was never intended for stable.
> 
> Did I end up catching all of these properly?  I've had to expand my
> search for some patches like this that do not explicitly have the cc:
> stable mark on them as not all subsystems do this well (if at all.)

No, sorry, should have been more clear on that point; these four were
never picked up for stable it seems.

I was a bit surprised to see the stable-tags be removed from the
original submissions here, even if I know the net-maintainers do this
routinely, and any maintainer can of course override a submitters
judgement.

> And there's also Sasha's work in digging up patches based on patterns of
> fixes, which also is needed because of this "problem".

Yeah, seems likely that autosel would have caught these eventually.

Johan
