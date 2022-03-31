Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B82A4EDFB3
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 19:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbiCaRf4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 13:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231381AbiCaRfy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 13:35:54 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 471EB5D18D
        for <stable@vger.kernel.org>; Thu, 31 Mar 2022 10:34:06 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id s8so201952pfk.12
        for <stable@vger.kernel.org>; Thu, 31 Mar 2022 10:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hMbErTT0SxAINAqq83ORsuba/wRxrUfn7/5Ck997gZc=;
        b=ib9rm2xQ6VaHyjBZRYv4+UFo00Ssflig3UjDSZ0C/YAZRNE48SDoQ6ndG1DpY5Ttao
         vDCQwLtE+FeGi1XMytJZhcsh8B6tNKtwsyR2slliUxRIwSRKEY1XE/cqI67GO+g0lWAx
         dRz3gRqqtGh/bNEM0tmXHfl5ZgKairNR+LGWX2VrIwWDe++U7h1iga0AIrtBsgNkEqEx
         b6Di4+/mG1+/64xga3Ot/lbEE7q30LzavUHUNHjRfZaWTMnrO0GhUoNASFyYRmcFJp++
         DyqtAMYJJ+d+Oz4+62clhUGLrz49KIzR48npw8B5DDithQchgb8PkBPT2M4F4vvFRpj1
         cMwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hMbErTT0SxAINAqq83ORsuba/wRxrUfn7/5Ck997gZc=;
        b=W5mtLDHsi9Wm6JHmDkJSzUaaQc5LZQ1sdsQIMyhxvwyIAfZUFX6OTKfc+6B3VXGMyh
         iTbQUaQ4AOmA9j6aXwfOsvX5I6oTyG69B5GN2ROuIlhBqU9iTorbSj2BM98+MrD9OCP0
         1V/c1ZziwW16K4uhKKAN8X2GexaM1z2F8dsDKnw+jVOORcGv+MXzU5kiCIEIxiRQXPbF
         A1dtC2CzOlqXqiN7/ZBGzSosUFY6kCf95XffzFKuFlML/wIA0wyDetPAh/phhz5MNbtH
         hlfCjVa1hUCtfhruauMEra6J/XZr/AswDwoQ7NcBN/NrRMdrQGwA59CAO9scMovR5sGs
         xOsw==
X-Gm-Message-State: AOAM533UpSXyLcVWHfbKkrpGjSvFvtVOJRPWw6e69m0IXO2FWHVh1V/Y
        IlBL9ZLEGc3qR3bu7ypRs3d+7A==
X-Google-Smtp-Source: ABdhPJyUCpExZImsOuZvYr/O3DuYD1F6zdr1CtuiwhEu74Fj+fiS02OVpvuGidJ+x5cAtUGyIaoaHg==
X-Received: by 2002:a62:84d3:0:b0:4fa:72e2:1c64 with SMTP id k202-20020a6284d3000000b004fa72e21c64mr40622735pfd.29.1648748045365;
        Thu, 31 Mar 2022 10:34:05 -0700 (PDT)
Received: from google.com ([2620:15c:202:201:a082:a097:a7d8:d309])
        by smtp.gmail.com with ESMTPSA id j7-20020a056a00130700b004b9f7cd94a4sm89021pfu.56.2022.03.31.10.34.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 10:34:03 -0700 (PDT)
Date:   Thu, 31 Mar 2022 10:33:57 -0700
From:   Benson Leung <bleung@google.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Won Chung <wonchung@google.com>, Takashi Iwai <tiwai@suse.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Benson Leung <bleung@chromium.org>,
        Prashant Malani <pmalani@chromium.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] sound/hda: Add NULL check to component match callback
 function
Message-ID: <YkXmBQ5TJ4JNnuQG@google.com>
References: <YkVzl4NEzwDAp/Zq@kuha.fi.intel.com>
 <s5hmth6eaiz.wl-tiwai@suse.de>
 <YkV1rsq1SeTNd8Ud@kuha.fi.intel.com>
 <s5hk0cae9pw.wl-tiwai@suse.de>
 <s5h7d8adzdl.wl-tiwai@suse.de>
 <s5hzgl6ciho.wl-tiwai@suse.de>
 <YkXJr2KhSzHJHxRF@google.com>
 <YkXY730wWhgJkRUy@kroah.com>
 <CAOvb9yiHXAWMn2_GcOnx5FYzfbp-2TmtN-OH90r31OqgbXQ3yQ@mail.gmail.com>
 <YkXiSEyfl9vkIG2w@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="E1fquEHOhb7T5Oxo"
Content-Disposition: inline
In-Reply-To: <YkXiSEyfl9vkIG2w@kroah.com>
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


--E1fquEHOhb7T5Oxo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Thu, Mar 31, 2022 at 07:18:00PM +0200, Greg KH wrote:
> On Thu, Mar 31, 2022 at 09:58:43AM -0700, Won Chung wrote:
> > > So is this actually triggering on 5.17 right now?  Or is it due to so=
me
> > > other not-applied changes you are testing at the moment?
> > >
> > > confused,
> > >
> > > greg k-h
> >=20
> > Hi Greg,
> >=20
> > I believe it is not causing an issue in 5.17 at the moment. It is
> > triggered when we try to apply new changes and test it locally.
> > (registering a component for usb4_port)
>=20
> Then why would it ever be needed to be backported to a stable kernel?
>=20
> Please be more careful.
>=20
> greg k-h

Sorry about that. I gave Won bad advice to cc stable. You're right, it will
only be relevant when a future patch lands in usb4.

Thanks,
Benson

--=20
Benson Leung
Staff Software Engineer
Chrome OS Kernel
Google Inc.
bleung@google.com
Chromium OS Project
bleung@chromium.org

--E1fquEHOhb7T5Oxo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQQCtZK6p/AktxXfkOlzbaomhzOwwgUCYkXmBQAKCRBzbaomhzOw
whPdAP4zpYThE+DOUyuAKUnnT6U3XkFRur72pnTiMNLwrfkKrAD/RCFAUHUKGoHB
8xryjhUyyXm+VZc/T1ItQdTq+pbaMw8=
=X8T3
-----END PGP SIGNATURE-----

--E1fquEHOhb7T5Oxo--
