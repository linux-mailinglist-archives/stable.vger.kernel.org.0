Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44C02D4785
	for <lists+stable@lfdr.de>; Fri, 11 Oct 2019 20:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728714AbfJKS0W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 14:26:22 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36642 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728472AbfJKS0W (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Oct 2019 14:26:22 -0400
Received: by mail-pg1-f194.google.com with SMTP id 23so6264409pgk.3;
        Fri, 11 Oct 2019 11:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jxnkHI88PrlznD0X1thKhOQvv+RypW1KwIdA3XIbgY8=;
        b=jEwyzxuao3KGDNQYlf2/0Ho27W8nshP38GuFJ0t0eDDgLntVfJAJnYY6QQLMRDsS3C
         jEq9pSKuZmjAov7CEAa9qHuejXm0jDmUyMSwMIr27Kz8SvLeYJByirGepXKvS/jeG18w
         e2CnyP3PJ+Swpje3KQJWIQq0XPc6rMc4uDV/H7k8j/4FVaAwHnjM7R3Vh/UYZNHSjIFt
         l/ZVtjD09dUGKzf82Zh3fTrbtZuUFuTk9yu46Na+ccD9btT+1fhxndJYctrpznU18cGs
         lmRsrH1jQ/7hTvm+uCDyKDldf+mGxzUlYRFgVPoU6/ZwRo4MUchmWpcmIKwBIxUutdDZ
         t9ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jxnkHI88PrlznD0X1thKhOQvv+RypW1KwIdA3XIbgY8=;
        b=HWApv/g8ZdvwcWH4mjHHI1lC+wq4jsx4/BBXBhN8+lDz6HDP83gOihGvzvPT0gQ9Ig
         kQlMhMtg4FmSsQjcgpDBJrhTV5MGJsZsVtnZKptHA4UR22xYD/0PCS7w50TJel09qFtT
         VWN5QMWfDMmMLVg0U4fbzNtmQpw9DsTHrHBCOspIJDz5eyFBW+OpExEcsIGJq4ob36GK
         2bjcEOQzB/VRTPn+EDGwY7yFYzcnprAVEZW3M/1VRML0s8/BfpsC5454W3ZLOpgBocrt
         9yI6VxZPaPxuPUzMhuz/YfswUSxLozGIekx324ZubydFbr9JTx6LicxO+19QkP9NSl/e
         ixhg==
X-Gm-Message-State: APjAAAUNNYssT9TrDE7T7Jdgur/ybQczUz4QI6GmSVdoK9ANTPMDyw15
        8GJrx5c2l9szTChO4arMqyI=
X-Google-Smtp-Source: APXvYqxrpSc+TDPcyRF4KlmdtpyzMSwahLxwMENVk8AP/KE9KtxkTtl8oS6zl44QqX0eaWzKFk5mYg==
X-Received: by 2002:a17:90a:c382:: with SMTP id h2mr18376741pjt.110.1570818380971;
        Fri, 11 Oct 2019 11:26:20 -0700 (PDT)
Received: from dtor-ws ([2620:15c:202:201:3adc:b08c:7acc:b325])
        by smtp.gmail.com with ESMTPSA id q33sm9518894pgm.50.2019.10.11.11.26.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2019 11:26:20 -0700 (PDT)
Date:   Fri, 11 Oct 2019 11:26:17 -0700
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Henrik Rydberg <rydberg@bitmath.org>,
        Sam Bazely <sambazley@fastmail.com>,
        "Pierre-Loup A . Griffais" <pgriffais@valvesoftware.com>,
        Austin Palmer <austinp@valvesoftware.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "3.8+" <stable@vger.kernel.org>
Subject: Re: [PATCH 1/3] HID: logitech-hidpp: use devres to manage FF private
 data
Message-ID: <20191011182617.GE229325@dtor-ws>
References: <20191007051240.4410-1-andrew.smirnov@gmail.com>
 <20191007051240.4410-2-andrew.smirnov@gmail.com>
 <CAO-hwJ+jPGa5Z7=Lopsc23m8UOqGWB0=tN+DcotykseAPM7_7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO-hwJ+jPGa5Z7=Lopsc23m8UOqGWB0=tN+DcotykseAPM7_7w@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 11, 2019 at 04:52:04PM +0200, Benjamin Tissoires wrote:
> Hi Andrey,
> 
> On Mon, Oct 7, 2019 at 7:13 AM Andrey Smirnov <andrew.smirnov@gmail.com> wrote:
> >
> > To simplify resource management in commit that follows as well as to
> > save a couple of extra kfree()s and simplify hidpp_ff_deinit() switch
> > driver code to use devres to manage the life-cycle of FF private data.
> >
> > Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
> > Cc: Jiri Kosina <jikos@kernel.org>
> > Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> > Cc: Henrik Rydberg <rydberg@bitmath.org>
> > Cc: Sam Bazely <sambazley@fastmail.com>
> > Cc: Pierre-Loup A. Griffais <pgriffais@valvesoftware.com>
> > Cc: Austin Palmer <austinp@valvesoftware.com>
> > Cc: linux-input@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Cc: stable@vger.kernel.org
> 
> This patch doesn't seem to fix any error, is there a reason to send it
> to stable? (besides as a dependency of the rest of the series).
> 
> > ---
> >  drivers/hid/hid-logitech-hidpp.c | 53 +++++++++++++++++---------------
> >  1 file changed, 29 insertions(+), 24 deletions(-)
> >
> > diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
> > index 0179f7ed77e5..58eb928224e5 100644
> > --- a/drivers/hid/hid-logitech-hidpp.c
> > +++ b/drivers/hid/hid-logitech-hidpp.c
> > @@ -2079,6 +2079,11 @@ static void hidpp_ff_destroy(struct ff_device *ff)
> >         struct hidpp_ff_private_data *data = ff->private;
> >
> >         kfree(data->effect_ids);
> 
> Is there any reasons we can not also devm alloc data->effect_ids?
> 
> > +       /*
> > +        * Set private to NULL to prevent input_ff_destroy() from
> > +        * freeing our devres allocated memory
> 
> Ouch. There is something wrong here: input_ff_destroy() calls
> kfree(ff->private), when the data has not been allocated by
> input_ff_create(). This seems to lack a little bit of symmetry.

Yeah, ff and ff-memless essentially take over the private data assigned
to them. They were done before devm and the lifetime of the "private"
data pieces was tied to the lifetime of the input device to simplify
error handling and teardown.

Maybe we should clean it up a bit... I'm open to suggestions.

In this case maybe best way is to get rid of hidpp_ff_destroy() and not
set ff->private and rely on devm to free the buffers. One can get to
device private data from ff methods via input_get_drvdata() since they
all (except destroy) are passed input device pointer.

Thanks.

-- 
Dmitry
