Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91AF24EDE55
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 18:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233744AbiCaQG5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 12:06:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234903AbiCaQG4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 12:06:56 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A1253B79
        for <stable@vger.kernel.org>; Thu, 31 Mar 2022 09:05:08 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id o68-20020a17090a0a4a00b001c686a48263so3204172pjo.1
        for <stable@vger.kernel.org>; Thu, 31 Mar 2022 09:05:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MO0/ty9ybQF1qACMJmOXTuFnMpYGfOx5VnnNgcY+e9Q=;
        b=TmQH9EEn6+KSh1gBo8PqXnFrR7M3fjlk1YhRq6HsA1u9WvYK1E/h1V6YCew7342jmj
         CgVyhbV83B0o4tUCUHKpJmY8bXMXyjAgKLsJdLXS/yopQCK7g+p5sEeXSJMGSa4LGEQd
         8Xv2GF8ym+8pf5c0sqO+3XMuAGtenvpNLSsqJzzI4CsvTU5X8wDRkeYnHbJUyQohIBbR
         IC3lnA3ilTdmPzUTunNgMAr87OdYYR1+QC5yJqjoFt5hbCAAzizA59rokh5AmQ9R7kxi
         4le4sh0HP8lOv7uRLJxF4QfvEG/moBzF3VTPq0rbbwCtsvWe+EfeFnfpS+FdfKu2Wdty
         uQvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MO0/ty9ybQF1qACMJmOXTuFnMpYGfOx5VnnNgcY+e9Q=;
        b=gWRtp73ppE5lF81Bri3//ksMaSYIJzHRl5IbA/5bp+Hc+TR1dDzpe8jAEP5DGFtAh8
         mT7BbS6wRH+LVbZQW17L3pxf4QwhMZbeEi/QA9qik8ucXF1AYOrCsX6kMHbLnc15WYiR
         ovCzq+ed7ebDhOqxopjRnAoomqKqzF37b5ypoUpiI3VPxWvwXU76vV9tY25HRw6toZnX
         w9I0p/cdPFvhhQoysi1gS1fgZ3HOo1YhAsVO4PbrNb5pXi5c4TVX7rSWEjOdMK7FLcfz
         Mk6BOHrXa7L6t2Wy+JO02Wov+TQzEHL4e3JNldiDNupzQGPSRp7K95lORXO3caR8Wk7y
         8LaA==
X-Gm-Message-State: AOAM531lFiK/cXuJF+P/Jc45s6tkpdhAf/1Kx5tQSmLh+nPRa43Q14uL
        3dC3hbYlhHgwVdq9MkMK3tXTBA==
X-Google-Smtp-Source: ABdhPJxXHt5eM3Gd+WSSK+aqeVHamWPZ4Zv6Gk7D55KL27cI99WtCtis/TevAmnfEEspbny2+M6SpA==
X-Received: by 2002:a17:902:f787:b0:152:157:eb7 with SMTP id q7-20020a170902f78700b0015201570eb7mr5798057pln.109.1648742707715;
        Thu, 31 Mar 2022 09:05:07 -0700 (PDT)
Received: from google.com ([2620:15c:202:201:a082:a097:a7d8:d309])
        by smtp.gmail.com with ESMTPSA id m18-20020a639412000000b003820bd9f2f2sm23368141pge.53.2022.03.31.09.05.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 09:05:06 -0700 (PDT)
Date:   Thu, 31 Mar 2022 09:04:59 -0700
From:   Benson Leung <bleung@google.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Won Chung <wonchung@google.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Benson Leung <bleung@chromium.org>,
        Prashant Malani <pmalani@chromium.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] misc/mei: Add NULL check to component match callback
 functions
Message-ID: <YkXRKyfoWTXqLi1L@google.com>
References: <20220331084918.2592699-1-wonchung@google.com>
 <YkVtvhC0n9B994/A@kroah.com>
 <YkV1KK8joyDAgf50@kuha.fi.intel.com>
 <YkWSmvrEevLsyDH5@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="gxrVt/ITKp3EpEr0"
Content-Disposition: inline
In-Reply-To: <YkWSmvrEevLsyDH5@kroah.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--gxrVt/ITKp3EpEr0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Thu, Mar 31, 2022 at 01:38:02PM +0200, Greg KH wrote:
> > > >  		return 0;
> > > > =20
> > > > diff --git a/drivers/misc/mei/pxp/mei_pxp.c b/drivers/misc/mei/pxp/=
mei_pxp.c
> > > > index f7380d387bab..e32a81da8af6 100644
> > > > --- a/drivers/misc/mei/pxp/mei_pxp.c
> > > > +++ b/drivers/misc/mei/pxp/mei_pxp.c
> > > > @@ -131,7 +131,7 @@ static int mei_pxp_component_match(struct devic=
e *dev, int subcomponent,
> > > >  {
> > > >  	struct device *base =3D data;
> > > > =20
> > > > -	if (strcmp(dev->driver->name, "i915") ||
> > > > +	if (!base || !dev->driver || strcmp(dev->driver->name, "i915") ||
> > >=20
> > > Same here, shouldn't this be caught by the driver core or bus and mat=
ch
> > > should not be called?
> > >=20
> > > Why not fix this in the component/driver core instead?
> >=20
> > A component is just a device that is declared to be a "component", and
> > the code that declares it as component does not have to be the driver
> > of that device. You simply can't assume that it's bind to a driver
> > like this function does.
> >=20
> > In our case the "components" are USB ports, so devices that are never
> > bind to drivers.
>=20
> And going off of the driver name is sane?  That feels ripe for bugs and
> problems in the future, but hey, I don't understand the need for this
> driver to care about another driver at all.

I think the component framework is meant to be this loose confederation of
devices, so going into component match, you don't know what the other device
is yet.

The USB drivers and the i915 drivers 100% don't care about each other,
but the framework doesn't know that yet until all the drivers try to match.

>=20
> And why is a USB device being passed to something that it thinks is a
> PCI device?  That too feels really wrong and ripe for problems.
>=20

The problematic device that's being passed through here is actually the
usb4_port, not a usb device. My guess would be that's why it's getting past=
 any
checks for whether it's a PCI device.

The component framework currently being used by (hdac_i915, mei_hdcp, mei_p=
xp)
to connect those three devices together, and completely separately, the
component framework is being used by the typec connector class's port mappe=
r.

These two clusters of devices are using the same component framework, but a=
re
not supposed to interact with each other. When we attempted to add the usb4=
_port
and its retimer in order to link tbt/usb4 to the typec connector, we discov=
ered
this interaction because we happened to build the usb4_port built-in in our
configs, so it does its component_add earlier.

I agree, by the way. This is all a bit ugly.

Thanks,
Benson

> thanks,
>=20
> greg k-h

--=20
Benson Leung
Staff Software Engineer
Chrome OS Kernel
Google Inc.
bleung@google.com
Chromium OS Project
bleung@chromium.org

--gxrVt/ITKp3EpEr0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQQCtZK6p/AktxXfkOlzbaomhzOwwgUCYkXRKwAKCRBzbaomhzOw
wp7KAQD1kYuyRtUS/SBx+UJYpHjwkC8OCBsHLMHIg76Lrn/3FgD/eok7/ReIldES
tWDUXAOXk48rymifKK6Ivj79qlDU0As=
=cMT0
-----END PGP SIGNATURE-----

--gxrVt/ITKp3EpEr0--
