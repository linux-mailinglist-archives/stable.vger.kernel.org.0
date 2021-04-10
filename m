Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ECD935AC06
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 10:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbhDJI4x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 04:56:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:60964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229591AbhDJI4x (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Apr 2021 04:56:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2385F610CB;
        Sat, 10 Apr 2021 08:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618044998;
        bh=uh476dzlm2ZLs/3KLJeBiudSJ+eOoSJUDrPdW896eBQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oSpM29hARBYcly2jIPOx3Wi0tvsmDxTsAuiepulAY/nmjcGb9VHKFiWTkYzuGnsWW
         wFh3yXpdpeanQBcFTZVT9mv3HtLEzo+8p4rsnwVUDwC/rfykFoENE9ILXHpAVZZFto
         Ym2VMs6e/feghkniisPpbh9arW9H4a9Eh7mR01OA=
Date:   Sat, 10 Apr 2021 10:56:36 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Rob Herring <robh@kernel.org>,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] of: property: fw_devlink: do not link ".*,nr-gpios"
Message-ID: <YHFoRFJny4+fibG4@kroah.com>
References: <20210405031436.2465475-1-ilya.lipnitskiy@gmail.com>
 <20210405222540.18145-1-ilya.lipnitskiy@gmail.com>
 <CAGETcx-gF4r1TeY2AA4Vwb5e+5O+_O3E2ENo5tKhh=n_EOJnEQ@mail.gmail.com>
 <20210407003408.GA2551507@robh.at.kernel.org>
 <CAGETcx8=sSWj_OmM1GPXNiLcv3anEkJnb_C7NoO9mNwS-O0KhQ@mail.gmail.com>
 <CAL_JsqLs4c3+9WwV6Vnk9Tovb6HiyH7t+_WXYP-ZDO72mOcO+w@mail.gmail.com>
 <CAGETcx-W_K9NFV51iBvyZ-Q+1LCUM3qipMmap9yEW_eu9B7CCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx-W_K9NFV51iBvyZ-Q+1LCUM3qipMmap9yEW_eu9B7CCg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 06, 2021 at 06:24:21PM -0700, Saravana Kannan wrote:
> On Tue, Apr 6, 2021 at 6:10 PM Rob Herring <robh@kernel.org> wrote:
> >
> > On Tue, Apr 6, 2021 at 7:46 PM Saravana Kannan <saravanak@google.com> wrote:
> > >
> > > On Tue, Apr 6, 2021 at 5:34 PM Rob Herring <robh@kernel.org> wrote:
> > > >
> > > > On Tue, Apr 06, 2021 at 04:09:10PM -0700, Saravana Kannan wrote:
> > > > > On Mon, Apr 5, 2021 at 3:26 PM Ilya Lipnitskiy
> > > > > <ilya.lipnitskiy@gmail.com> wrote:
> > > > > >
> > > > > > [<vendor>,]nr-gpios property is used by some GPIO drivers[0] to indicate
> > > > > > the number of GPIOs present on a system, not define a GPIO. nr-gpios is
> > > > > > not configured by #gpio-cells and can't be parsed along with other
> > > > > > "*-gpios" properties.
> > > > > >
> > > > > > nr-gpios without the "<vendor>," prefix is not allowed by the DT
> > > > > > spec[1], so only add exception for the ",nr-gpios" suffix and let the
> > > > > > error message continue being printed for non-compliant implementations.
> > > > > >
> > > > > > [0]: nr-gpios is referenced in Documentation/devicetree/bindings/gpio:
> > > > > >  - gpio-adnp.txt
> > > > > >  - gpio-xgene-sb.txt
> > > > > >  - gpio-xlp.txt
> > > > > >  - snps,dw-apb-gpio.yaml
> > > > > >
> > > > > > [1]:
> > > > > > Link: https://github.com/devicetree-org/dt-schema/blob/cb53a16a1eb3e2169ce170c071e47940845ec26e/schemas/gpio/gpio-consumer.yaml#L20
> > > > > >
> > > > > > Fixes errors such as:
> > > > > >   OF: /palmbus@300000/gpio@600: could not find phandle
> > > > > >
> > > > > > Fixes: 7f00be96f125 ("of: property: Add device link support for interrupt-parent, dmas and -gpio(s)")
> > > > > > Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
> > > > > > Cc: Saravana Kannan <saravanak@google.com>
> > > > > > Cc: <stable@vger.kernel.org> # 5.5.x
> > > > > > ---
> > > > > >  drivers/of/property.c | 11 ++++++++++-
> > > > > >  1 file changed, 10 insertions(+), 1 deletion(-)
> > > > > >
> > > > > > diff --git a/drivers/of/property.c b/drivers/of/property.c
> > > > > > index 2046ae311322..1793303e84ac 100644
> > > > > > --- a/drivers/of/property.c
> > > > > > +++ b/drivers/of/property.c
> > > > > > @@ -1281,7 +1281,16 @@ DEFINE_SIMPLE_PROP(pinctrl7, "pinctrl-7", NULL)
> > > > > >  DEFINE_SIMPLE_PROP(pinctrl8, "pinctrl-8", NULL)
> > > > > >  DEFINE_SUFFIX_PROP(regulators, "-supply", NULL)
> > > > > >  DEFINE_SUFFIX_PROP(gpio, "-gpio", "#gpio-cells")
> > > > > > -DEFINE_SUFFIX_PROP(gpios, "-gpios", "#gpio-cells")
> > > > > > +
> > > > > > +static struct device_node *parse_gpios(struct device_node *np,
> > > > > > +                                      const char *prop_name, int index)
> > > > > > +{
> > > > > > +       if (!strcmp_suffix(prop_name, ",nr-gpios"))
> > > > > > +               return NULL;
> > > > >
> > > > > Ah I somehow missed this patch. This gives a blanked exception for
> > > > > vendor,nr-gpios. I'd prefer explicit exceptions for all the instances
> > > > > of ",nr-gpios" we are grandfathering in. Any future additions should
> > > > > be rejected. Can we do that please?
> > > > >
> > > > > Rob, you okay with making this list more explicit?
> > > >
> > > > Not the kernel's job IMO. A schema is the right way to handle that.
> > >
> > > Ok, that's fine by me. Btw, let's land this in driver-core? I've made
> > > changes there and this might cause conflicts. Not sure.
> >
> > It merges with linux-next fine. You'll need to resend this to Greg if
> > you want to do that.
> >
> > Reviewed-by: Rob Herring <robh@kernel.org>
> 
> Hi Greg,
> 
> Can you pull this into driver-core please? I touch this file a lot and
> might need to do so again if any fw_devlink=on issues come up. So
> trying to preemptively avoid conflicts.

Pull what?  I'm totally lost in this thread, sorry...

If you need me to apply something, you at least need to cc: me on it :)

thanks,

gre gk-h
