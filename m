Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEECD55B43
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 00:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725914AbfFYWdp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 18:33:45 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40425 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbfFYWdm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jun 2019 18:33:42 -0400
Received: by mail-pf1-f196.google.com with SMTP id p184so148267pfp.7
        for <stable@vger.kernel.org>; Tue, 25 Jun 2019 15:33:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=JT1Dg+Da84rmyT0HimXlivWp8rkXdkjd2YjQgSg5q78=;
        b=g0YgCWmWyWoOk8i0P51O+hzfezQLPWB35vHuYvI92qYbh/90WoDAhhrmkhKiKU7HnL
         u67taUAMYO/RuifJsYFWe87jOy6YD4Kg78lUjB9KOPOh18LgI6x3hyfkJLXuyGg5gKLw
         BS8wVHY3pMPdA24g4TL+k1Xx7Gi9DriOMFX1btp6Di7Ltrc8xT/aw2c4ZiM15gx6NlAO
         seDd1BYMelbsEw+WoH4yNpNXTfE7MlrXO7BuKB2QG5Lsh5tBybIA70LrQU79Nmu74W8Q
         zlSTHA3/yBtQv7jRnkmy6Oio2hdBzm/JWrRtXbiTuJ5lBvNvyqvRgY/gKiAXGtcj0Lew
         GY3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=JT1Dg+Da84rmyT0HimXlivWp8rkXdkjd2YjQgSg5q78=;
        b=fAv5dxtx8LOt9USCG+9IUHTK66ABLO2xxOfU+D0wki3enT8W/5eIsTgfobfNNX1piT
         6TlSWJaMk9cMFy9bmuuSvKZR8YojUCU5V8aTwZ5h8QI6PfCy9ekD57/jFHAJ0F8wFuC+
         DOwnCZSIlaWBXcA6lAzZGzKdWYm2G1OWkK4MHWUBfpzj7xA/jq0iee2VBSoXlNj2YS7t
         FMKsiBGNbIPUS9XjdLKraDg1TRnfVF2rt1lmdd5Gf8QOZCtmt13ZX0+VvLxDkYfwxn4t
         XDkjKT8oug77rV/WGZT8fcJphviQTeAmyAXaclo9IPI65WEmULblzSRNmohiDocrqW0z
         XcaA==
X-Gm-Message-State: APjAAAVHulSTHUySIscZFk/wtth6sOLHSKAH1i0Y79JMwUOJnE2jqo7g
        ApJ3p/KPq6fXnCCu2On2z4vwlA==
X-Google-Smtp-Source: APXvYqyKtzqaJPagQIzaNMbJft8gYiPTJ/62A6mnD2mpmhx2FUd/IX5Bn3rvFBc7HFZmTo52Uib8rw==
X-Received: by 2002:a17:90a:db08:: with SMTP id g8mr251900pjv.39.1561502020992;
        Tue, 25 Jun 2019 15:33:40 -0700 (PDT)
Received: from google.com ([2620:15c:201:2:765b:31cb:30c4:166])
        by smtp.gmail.com with ESMTPSA id v138sm17334627pfc.15.2019.06.25.15.33.39
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 15:33:40 -0700 (PDT)
Date:   Tue, 25 Jun 2019 15:33:35 -0700
From:   Eric Biggers <ebiggers@google.com>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+7fddca22578bc67c3fe4@syzkaller.appspotmail.com,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 4.19 84/90] cfg80211: fix memory leak of wiphy device name
Message-ID: <20190625223335.GB218319@google.com>
References: <20190624092313.788773607@linuxfoundation.org>
 <20190624092319.410368076@linuxfoundation.org>
 <20190625215135.GA32248@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190625215135.GA32248@amd>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 25, 2019 at 11:51:36PM +0200, Pavel Machek wrote:
> Hi!
> 
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > commit 4f488fbca2a86cc7714a128952eead92cac279ab upstream.
> > 
> > In wiphy_new_nm(), if an error occurs after dev_set_name() and
> > device_initialize() have already been called, it's necessary to call
> > put_device() (via wiphy_free()) to avoid a memory leak.
> ....
> > --- a/net/wireless/core.c
> > +++ b/net/wireless/core.c
> > @@ -498,7 +498,7 @@ use_default_name:
> >  				   &rdev->rfkill_ops, rdev);
> >  
> >  	if (!rdev->rfkill) {
> > -		kfree(rdev);
> > +		wiphy_free(&rdev->wiphy);
> >  		return NULL;
> >  	}
> 
> Is kfree(rdev) still neccessary?
> drivers/net/wireless/marvell/libertas/cfg.c seems to suggest so.
> 

No, because it's freed by:

    wiphy_free()
        => put_device()
            => wiphy_dev_release()
                => cfg80211_dev_free()
		    => kfree(rdev)

drivers/net/wireless/marvell/libertas/cfg.c is different because there the
struct wiphy is separately allocated from the struct wireless_dev that's being
freed afterwards.

- Eric
