Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AEE398916
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 03:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730683AbfHVBsd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Aug 2019 21:48:33 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:44820 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727617AbfHVBsd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Aug 2019 21:48:33 -0400
Received: by mail-pl1-f195.google.com with SMTP id t14so2395749plr.11
        for <stable@vger.kernel.org>; Wed, 21 Aug 2019 18:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Zz02ALQgN0JNO5oVLHeovhr+kbCLW32oDWBz46gUrZc=;
        b=UaR0076B/94mLLVli+bnwP9lV6qYVEFjvocAW6AF7D60zHJJgWPbcQZHtVTrVg4l/E
         OvGpfGYuAolJEz4/e5e9Ictk1KO613cRN3/MT+v/JjDMcl3y//g17jpvkIwOued2W564
         eigMrVvQMV14YtQVOkTTXogg6XW4rz6rrvf9E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Zz02ALQgN0JNO5oVLHeovhr+kbCLW32oDWBz46gUrZc=;
        b=J2VbSamEQBcKX416MHWXINT3SPKH0+SRK/dpud7aq+OBbJnzyWy+jM5pn1qFoPWesw
         W2sHLk3selgtgGxkEDqTPwsqzVD44JRl1aHwFbtdqYsfwcsjjqsqQYryhaJVGp5mGmJB
         Q8+F8RsvCGQJTS/AJLodEelA9ti9Bp+DzpZb3NWjzuVTXYnlEdSkWcwTKwxAgcP60tpY
         ntb9auPgLLKin64nVRbqGnpT0JjFT5ZmO3uhP3uVQ5Zsx7QVgWVLF57WBhuSeF98dFmK
         eusrA92aeY9pwTKFOQGNENbEqrnFhmDTq3BzcmY0GBN77cDQJfU5zLIUU3zh+TkjIHej
         bkdg==
X-Gm-Message-State: APjAAAXeO5EjmkAyV8Ukvz+R0hPwM/RX9vsaN+5MpdpEJsuYKcoCzW/X
        yN30seMK6BR36APUEinPWDqkWg==
X-Google-Smtp-Source: APXvYqxH4gcyoo0JZ5ADNUTEhcjTtr9E6xKTutX6jqRjXypSTZEDd2B0Suu9COMuMYKqyEBl6dpDEQ==
X-Received: by 2002:a17:902:bc49:: with SMTP id t9mr36969919plz.277.1566438512568;
        Wed, 21 Aug 2019 18:48:32 -0700 (PDT)
Received: from google.com ([2620:15c:202:1:534:b7c0:a63c:460c])
        by smtp.gmail.com with ESMTPSA id d20sm59895pfo.90.2019.08.21.18.48.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2019 18:48:31 -0700 (PDT)
Date:   Wed, 21 Aug 2019 18:48:29 -0700
From:   Brian Norris <briannorris@chromium.org>
To:     Michael Nosthoff <committed@heine.so>
Cc:     linux-pm@vger.kernel.org, stable@vger.kernel.org,
        Sebastian Reichel <sre@kernel.org>
Subject: Re: [PATCH] power: supply: sbs-battery: only return health when
 battery present
Message-ID: <20190822014828.GB165945@google.com>
References: <20190816075842.27333-1-committed@heine.so>
 <20190822014655.GA165945@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190822014655.GA165945@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

+ Sebastian

I'm not sure if he expects to be on the To/Cc, but that usually is the
way to get a maintainer to take your patch.

Brian

On Wed, Aug 21, 2019 at 06:46:55PM -0700, Brian Norris wrote:
> On Fri, Aug 16, 2019 at 09:58:42AM +0200, Michael Nosthoff wrote:
> > when the battery is set to sbs-mode and  no gpio detection is enabled
> > "health" is always returning a value even when the battery is not present.
> > All other fields return "not present".
> > This leads to a scenario where the driver is constantly switching between
> > "present" and "not present" state. This generates a lot of constant
> > traffic on the i2c.
> 
> That depends on how often you're checking the "health" attribute,
> doesn't it? But anyway, the bug is real.
> 
> > This commit changes the response of "health" to an error when the battery
> > is not responding leading to a consistent "not present" state.
> 
> Ack, and thanks for the fix.
> 
> > Fixes: 76b16f4cdfb8 ("power: supply: sbs-battery: don't assume
> > MANUFACTURER_DATA formats")
> > 
> > Signed-off-by: Michael Nosthoff <committed@heine.so>
> > Cc: Brian Norris <briannorris@chromium.org>
> > Cc: <stable@vger.kernel.org>
> 
> Reviewed-by: Brian Norris <briannorris@chromium.org>
> Tested-by: Brian Norris <briannorris@chromium.org>
> 
> > ---
> >  drivers/power/supply/sbs-battery.c | 25 ++++++++++++++++---------
> >  1 file changed, 16 insertions(+), 9 deletions(-)
> > 
> > diff --git a/drivers/power/supply/sbs-battery.c b/drivers/power/supply/sbs-battery.c
> > index 2e86cc1e0e35..f8d74e9f7931 100644
> > --- a/drivers/power/supply/sbs-battery.c
> > +++ b/drivers/power/supply/sbs-battery.c
> > @@ -314,17 +314,22 @@ static int sbs_get_battery_presence_and_health(
> >  {
> >  	int ret;
> >  
> > -	if (psp == POWER_SUPPLY_PROP_PRESENT) {
> > -		/* Dummy command; if it succeeds, battery is present. */
> > -		ret = sbs_read_word_data(client, sbs_data[REG_STATUS].addr);
> > -		if (ret < 0)
> > -			val->intval = 0; /* battery disconnected */
> > -		else
> > -			val->intval = 1; /* battery present */
> > -	} else { /* POWER_SUPPLY_PROP_HEALTH */
> > +	/* Dummy command; if it succeeds, battery is present. */
> > +	ret = sbs_read_word_data(client, sbs_data[REG_STATUS].addr);
> > +
> > +	if (ret < 0) { /* battery not present*/
> > +		if (psp == POWER_SUPPLY_PROP_PRESENT) {
> > +			val->intval = 0;
> > +			return 0;
> 
> Technically, you don't need the 'return 0' (and if we care about
> symmetry: the TI version doesn't), since the caller knows that "not
> present" will yield errors. I'm not sure which version makes more sense.
> 
> > +		}
> > +		return ret;
> > +	}
> > +
> > +	if (psp == POWER_SUPPLY_PROP_PRESENT)
> > +		val->intval = 1; /* battery present */
> > +	else /* POWER_SUPPLY_PROP_HEALTH */
> >  		/* SBS spec doesn't have a general health command. */
> >  		val->intval = POWER_SUPPLY_HEALTH_UNKNOWN;
> > -	}
> >  
> >  	return 0;
> >  }
> > @@ -626,6 +631,8 @@ static int sbs_get_property(struct power_supply *psy,
> >  		else
> >  			ret = sbs_get_battery_presence_and_health(client, psp,
> >  								  val);
> > +
> > +		/* this can only be true if no gpio is used */
> >  		if (psp == POWER_SUPPLY_PROP_PRESENT)
> >  			return 0;
> >  		break;
> > -- 
> > 2.20.1
> > 
