Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4613215313C
	for <lists+stable@lfdr.de>; Wed,  5 Feb 2020 13:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728072AbgBEMyU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 07:54:20 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:40359 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727104AbgBEMyU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Feb 2020 07:54:20 -0500
Received: by mail-lj1-f196.google.com with SMTP id n18so2189047ljo.7;
        Wed, 05 Feb 2020 04:54:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vkDBzbpH4IcW5zbdKwOmsL7Q9sidHCXsNPoYFnqvSaQ=;
        b=I0XUu9fbCrV+B6irMe/njypqV5Xu2BoSApb7zM0IbzZAGSnLi2fpjv1dZ+HPPZPm9w
         ur/KKWDhismvojjhlWdCoBciNxNRqWKt4ar8lRl2N+eyFU3BjW6b5uukbBFLqjaJxUWI
         1IAnaqQAL/5fYYIjHS1kNBuMjFEKVPCxTZTLxfhd+595zi/+WtMxRMcNx1FB300kHnUf
         nhX8xZW4xlZdzeN3rARr+irnMihygXlF+zCNHOnH7BSDtIBXNeEMEFcKZXXCT6aHSBkS
         K+jlt0fDQTT0Zt5cbG4qYzwy/0qt2Mu8eP7KbCl2NCR0HiHnwxpgATfMp+owVqtQg+ge
         rGIw==
X-Gm-Message-State: APjAAAXFHawcuqpKrBLDRkBmbrcj4PH7Xq/FSGvSe29fqxeKL08wpua0
        cc4wWWd9yO0imY2PI/7id0s8wSkn
X-Google-Smtp-Source: APXvYqyiWP0YQ3BBERRwm/kgl8vbrGr6gRfSRjj1IN7izSIvSPElM1pWZ6f3iMNkJK0zm6G+/8QGBg==
X-Received: by 2002:a2e:b5ce:: with SMTP id g14mr18994626ljn.264.1580907256823;
        Wed, 05 Feb 2020 04:54:16 -0800 (PST)
Received: from xi.terra (c-12aae455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.170.18])
        by smtp.gmail.com with ESMTPSA id i1sm13052535lji.71.2020.02.05.04.54.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 04:54:16 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@kernel.org>)
        id 1izKCI-0004wa-0Y; Wed, 05 Feb 2020 13:54:26 +0100
Date:   Wed, 5 Feb 2020 13:54:26 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     Johan Hovold <johan@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Martin Kepplinger <martink@posteo.de>
Subject: Re: [PATCH 1/7] Input: pegasus_notetaker: fix endpoint sanity check
Message-ID: <20200205125426.GT26725@localhost>
References: <20191210113737.4016-1-johan@kernel.org>
 <20191210113737.4016-2-johan@kernel.org>
 <20200204082441.GD26725@localhost>
 <20200204100232.GB1088789@kroah.com>
 <20200204101435.GH26725@localhost>
 <20200204192434.GH184237@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200204192434.GH184237@dtor-ws>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 04, 2020 at 11:24:34AM -0800, Dmitry Torokhov wrote:
> On Tue, Feb 04, 2020 at 11:14:35AM +0100, Johan Hovold wrote:
> > On Tue, Feb 04, 2020 at 10:02:32AM +0000, Greg Kroah-Hartman wrote:
> > > On Tue, Feb 04, 2020 at 09:24:41AM +0100, Johan Hovold wrote:
> > > > On Tue, Dec 10, 2019 at 12:37:31PM +0100, Johan Hovold wrote:
> > > > > The driver was checking the number of endpoints of the first alternate
> > > > > setting instead of the current one, something which could be used by a
> > > > > malicious device (or USB descriptor fuzzer) to trigger a NULL-pointer
> > > > > dereference.
> > > > > 
> > > > > Fixes: 1afca2b66aac ("Input: add Pegasus Notetaker tablet driver")
> > > > > Cc: stable <stable@vger.kernel.org>     # 4.8
> > > > > Cc: Martin Kepplinger <martink@posteo.de>
> > > > > Signed-off-by: Johan Hovold <johan@kernel.org>
> > > > 
> > > > Looks like the stable tag was removed when this one was applied, and
> > > > similar for patches 2, 4 and 7 of this series (commits 3111491fca4f,
> > > > a8eeb74df5a6, 6b32391ed675 upstream).
> > > > 
> > > > While the last three are mostly an issue for the syzbot fuzzer, we have
> > > > started backporting those as well.
> > > > 
> > > > This one (bcfcb7f9b480) is more clear cut as it can be used to trigger a
> > > > NULL-deref.
> > > > 
> > > > I only noticed because Sasha picked up one of the other patches in the
> > > > series which was never intended for stable.
> > > 
> > > Did I end up catching all of these properly?  I've had to expand my
> > > search for some patches like this that do not explicitly have the cc:
> > > stable mark on them as not all subsystems do this well (if at all.)
> > 
> > No, sorry, should have been more clear on that point; these four were
> > never picked up for stable it seems.
> > 
> > I was a bit surprised to see the stable-tags be removed from the
> > original submissions here, even if I know the net-maintainers do this
> > routinely, and any maintainer can of course override a submitters
> > judgement.
> 
> Sorry, dropping stable tags was not intentional. I was trying to improve
> my tooling and drop the CC noise from the changelogs, but my script got
> too eager and removed "Cc: stable" as well. I believe my tool should be
> fixed now and it should not happen again.

Ah, ok, thanks for confirming.

Johan
