Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA849E1983
	for <lists+stable@lfdr.de>; Wed, 23 Oct 2019 14:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733169AbfJWMBm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Oct 2019 08:01:42 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:42529 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732030AbfJWMBm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Oct 2019 08:01:42 -0400
Received: by mail-lf1-f67.google.com with SMTP id z12so15827651lfj.9
        for <stable@vger.kernel.org>; Wed, 23 Oct 2019 05:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=NfUSZRSycdNlSRQ2Q0qBS39dL1d94QgHWby3cKAfn88=;
        b=dv9qPFxZAKA5TIEXzaInwpyaCdyi40ylcXsQ/RWgfn9AVr3AyCNtjR5pU9KNN30Bpw
         08CvIoOrwL6Uyj4dPH3mB5VwRlru2MOv8f9TgwbLPuZAP9j9VYGVcYjYNMYhUkGBF/XE
         KhWeZBV3aFG9YD7ac0/PuTWUVbkM4QXtPH0Jw5cCwvaq0agNIUW69GtNijVzdfx2OUZD
         IYY/BPFw4bfdnnWhilrJWsy938OQ5NU3EvPejqE1aWd4Vb17D5jGBjh/EMykW8PiZ6jd
         0AwD+rem80/LDyCWft5kESZ+MZSjktsYvmLdwWmt7IU3up42OcDX3ssZ8/TZiEslWVVE
         V4kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=NfUSZRSycdNlSRQ2Q0qBS39dL1d94QgHWby3cKAfn88=;
        b=K/H39moTqjbkJxtpXcy8WxUKb4g2/wHsxS1FAEPuXXQp5PAB62ovUeV41GqwDoeNe8
         kX5/wdKV0eAs9lM7hba9IsvOOqK4c1FLnts90mleXxr4p3+d70buCM+EDkhvhwrOxjTH
         3Af3lyBDtJ9StKvlxdbhtCMI/rHXgznIIFvNOsoFRBrDZ3krsLFfPZ7aelV0J1skzpmN
         35HUYsMO8Srw2GYErDlOFrIojwqupm3o8Bc2k7aMX7dzUtIfDWpT6U7AqSGFbDMMzZog
         1LJ+VWFQzsmsPfNRMj8nZcmqWGzIlz1MpSPY6tmZqUiyYhNLArf8J/KNDwlkFtr5ccgS
         cPEw==
X-Gm-Message-State: APjAAAVMjKgDjZq6hpdqogQLjPJixaFgAzVdUNrVH/IFgYZmJgi+rjyq
        eyA6A7k5vp3iSGyCv5sdK+i1Pg==
X-Google-Smtp-Source: APXvYqyc74sL74PrBg40yNqovwHOrKbIZKZdWvDVwl8PitCpXiluHH0yeybwqLJIVzOK/V9klSfPQw==
X-Received: by 2002:a19:ed06:: with SMTP id y6mr4773201lfy.25.1571832100257;
        Wed, 23 Oct 2019 05:01:40 -0700 (PDT)
Received: from centauri (ua-84-219-138-247.bbcust.telenor.se. [84.219.138.247])
        by smtp.gmail.com with ESMTPSA id p86sm10937100lja.100.2019.10.23.05.01.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 05:01:39 -0700 (PDT)
Date:   Wed, 23 Oct 2019 14:01:37 +0200
From:   Niklas Cassel <niklas.cassel@linaro.org>
To:     Viresh Kumar <viresh.kumar@linaro.org>
Cc:     Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>,
        Stephen Boyd <sboyd@kernel.org>, linux-pm@vger.kernel.org,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Rafael Wysocki <rjw@rjwysocki.net>,
        "v5 . 0+" <stable@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] opp: of: drop incorrect lockdep_assert_held()
Message-ID: <20191023120137.GA18078@centauri>
References: <6306e18beab9deff6ee6b32f489390908495fe14.1570703431.git.viresh.kumar@linaro.org>
 <20191023053005.m4y4bcebgi4km35q@vireshk-i7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191023053005.m4y4bcebgi4km35q@vireshk-i7>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 23, 2019 at 11:00:05AM +0530, Viresh Kumar wrote:
> On 10-10-19, 16:00, Viresh Kumar wrote:
> > _find_opp_of_np() doesn't traverse the list of OPP tables but instead
> > just the entries within an OPP table and so only requires to lock the
> > OPP table itself.
> > 
> > The lockdep_assert_held() was added there by mistake and isn't really
> > required.
> > 
> > Fixes: 5d6d106fa455 ("OPP: Populate required opp tables from "required-opps" property")
> > Cc: v5.0+ <stable@vger.kernel.org> # v5.0+
> > Reported-by: Niklas Cassel <niklas.cassel@linaro.org>
> > Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> > ---
> >  drivers/opp/of.c | 2 --
> >  1 file changed, 2 deletions(-)
> > 
> > diff --git a/drivers/opp/of.c b/drivers/opp/of.c
> > index 1813f5ad5fa2..6dc41faf74b5 100644
> > --- a/drivers/opp/of.c
> > +++ b/drivers/opp/of.c
> > @@ -77,8 +77,6 @@ static struct dev_pm_opp *_find_opp_of_np(struct opp_table *opp_table,
> >  {
> >  	struct dev_pm_opp *opp;
> >  
> > -	lockdep_assert_held(&opp_table_lock);
> > -
> >  	mutex_lock(&opp_table->lock);
> >  
> >  	list_for_each_entry(opp, &opp_table->opp_list, node) {
> 
> @Niklas, any inputs from your side  here would be appreciated :)

Tested-by: Niklas Cassel <niklas.cassel@linaro.org>

After this patch, there is still a single lockdep_assert_held()
left, inside _find_table_of_opp_np(), since you kept this,
I assume that that one is still needed?

Kind regards,
Niklas
