Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC0E2127937
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 11:23:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727279AbfLTKXT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 05:23:19 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:35766 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727129AbfLTKXT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Dec 2019 05:23:19 -0500
Received: by mail-lf1-f65.google.com with SMTP id 15so6644138lfr.2;
        Fri, 20 Dec 2019 02:23:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fVDETBozZ4/qDsszN1mn7+6jrkiK3wgtTef6sQxNVJ4=;
        b=i0dM/oQQTwXG3nUbFKGEtfXQeZt2hu1rpqn3iuzNZE0oWnPpMXGHPO9ZNW6NVRvz6O
         8vhMIkXS3sFrHLWSriDBL0gCr3gG77Q+KLFKcqVr+QNWRwkhPk3oq+tKRUcDNljJzO1y
         LhtufvDXsNYOh2GBGmDYQ+IzEYwIyU+UmvpqrbnpI/zkb7azz8egtrbVJjVSk7zopvTp
         gLin2lwoLSZmFH82ee0zTUjcZFY0K9Zo9hUGrVT/Ot24q4ZM/rqE92qiAo+A8BYzvxLy
         YudbKxDQrs6+YW0lqvMeG1Lig5R6DsHpOZxipt0Mf+teMcXMd69oKqqWwMhgGTvCAuwx
         1HfA==
X-Gm-Message-State: APjAAAVlrf36ochj1UolRwFNfU2JrsJWOyZNpecZ2wmcdlHDaEjgENZL
        hOzGdsJpCN00UXLnytUPVsU=
X-Google-Smtp-Source: APXvYqxnhc7AhHRdkgCq7FXSfcejTVt7KSCTYkqz/ngaR2fEsJGHcFdA3ZXx4mY+iUrPwzq5NkOmrQ==
X-Received: by 2002:a19:c205:: with SMTP id l5mr8258003lfc.159.1576837397388;
        Fri, 20 Dec 2019 02:23:17 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id h19sm4044923ljk.44.2019.12.20.02.23.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 02:23:16 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@kernel.org>)
        id 1iiFRD-00018f-PN; Fri, 20 Dec 2019 11:23:15 +0100
Date:   Fri, 20 Dec 2019 11:23:15 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Takashi Iwai <tiwai@suse.de>
Cc:     Johan Hovold <johan@kernel.org>, Jaroslav Kysela <perex@perex.cz>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] ALSA: usb-audio: fix set_format altsetting sanity check
Message-ID: <20191220102315.GU22665@localhost>
References: <20191220093134.1248-1-johan@kernel.org>
 <s5hbls35nxx.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hbls35nxx.wl-tiwai@suse.de>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 20, 2019 at 10:46:50AM +0100, Takashi Iwai wrote:
> On Fri, 20 Dec 2019 10:31:34 +0100,
> Johan Hovold wrote:
> > 
> > Make sure to check the return value of usb_altnum_to_altsetting() to
> > avoid dereferencing a NULL pointer when the requested alternate settings
> > is missing.
> > 
> > The format altsetting number may come from a quirk table and there does
> > not seem to be any other validation of it (the corresponding index is
> > checked however).
> > 
> > Fixes: b099b9693d23 ("ALSA: usb-audio: Avoid superfluous usb_set_interface() calls")
> > Cc: stable <stable@vger.kernel.org>     # 4.18
> > Signed-off-by: Johan Hovold <johan@kernel.org>
> > ---
> >  sound/usb/pcm.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
> > index 9c8930bb00c8..73dd9d21bb42 100644
> > --- a/sound/usb/pcm.c
> > +++ b/sound/usb/pcm.c
> > @@ -506,9 +506,9 @@ static int set_format(struct snd_usb_substream *subs, struct audioformat *fmt)
> >  	if (WARN_ON(!iface))
> >  		return -EINVAL;
> >  	alts = usb_altnum_to_altsetting(iface, fmt->altsetting);
> > -	altsd = get_iface_desc(alts);
> > -	if (WARN_ON(altsd->bAlternateSetting != fmt->altsetting))
> > +	if (WARN_ON(!alts))
> >  		return -EINVAL;
> 
> Do we need WARN_ON() here?  If this may hit on syzbot, it'll stop at
> this point because of panic_on_warn.

Yeah, I considered that too and decided to leave it in. Just like for
the WARN_ON(iface), those numbers should be verified at probe.

I tried tracking where fmt->altsetting comes from, and it seems like
a sanity check needs to be added at least to create_fixed_stream_quirk()
where, for example, fmt->iface, fmt->altset_idx and the number of
endpoints are verified.

If there are other paths that can end up setting these fields to invalid
values, we want that WARN_ON() in there so we can fix those.

Johan
