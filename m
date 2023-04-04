Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7576D5FFA
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 14:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234817AbjDDMQI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 08:16:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233977AbjDDMOH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 08:14:07 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 067BE4C0C
        for <stable@vger.kernel.org>; Tue,  4 Apr 2023 05:09:51 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id k14-20020a9d700e000000b0069faa923e7eso17199523otj.10
        for <stable@vger.kernel.org>; Tue, 04 Apr 2023 05:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mvista.com; s=google; t=1680610190; x=1683202190;
        h=in-reply-to:content-disposition:mime-version:references:reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8oPqY1zqTSWWuFnXYMk5IRfPfNzCYHrrnpEWXw2ihf8=;
        b=fdH/nSXOZTLegg7uXy2m9wy3hloclX7py/atjby6rWeA3xM8va6QFJ+RpKx3xeW9gr
         QPiUhnst5d88WszM2O99auPj5zqSjsmSzmVZOqjdYgtvqVH7j25dKMVwIKea/W+jIatL
         LIjJMOPMtoaoiX/I7VGOAh3CkeMku93NinlHc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680610190; x=1683202190;
        h=in-reply-to:content-disposition:mime-version:references:reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8oPqY1zqTSWWuFnXYMk5IRfPfNzCYHrrnpEWXw2ihf8=;
        b=TCNw+UM67YutiIMjJd+7lfkqIJLW5ep8vElb47yapN7mp3optNEGng/+sq6DNM24hd
         5njqeZSwiZiK/z6VPTS7GWx+qWhZozbkGOj9MWVwoxKeZ/bT0FdL3TA9Cs/02C97w97R
         eYeGnRGivmgdlQM7fhjy9U9mUJrK3ZnhINKfKQH+pkSa+S9rJRupe9T/Gq/1YFYk7fHJ
         nVqY0cp38PYwfHZlTxqg0TdF6RYxq0b4EOBNhNQ3AMHc2vRa0ez/96A2gFv6zK0gMDRF
         EfgWcri/c0FgreoT0LQAdj99HWgOWkpHLnwLPGdGZ2obk1GuNbytZ5sQKg13ZKILW1Jp
         5jYg==
X-Gm-Message-State: AAQBX9cQ85TiY+ACS56TvsvDF5Z8xC0/KVJLvJKgbpkVPmjOWU6pFyya
        nYspbTYlKnEcGVaGb50CoKB0RkorxYsbESeCjMzWKA==
X-Google-Smtp-Source: AKy350YelewO7iZrNwA15nomYKdzpattSgg57tmGLnlFTYYrFtOL58RfYzLIzxoragqjuRCu1ekHXQ==
X-Received: by 2002:a05:6830:2782:b0:6a1:23db:b139 with SMTP id x2-20020a056830278200b006a123dbb139mr1298454otu.0.1680610190295;
        Tue, 04 Apr 2023 05:09:50 -0700 (PDT)
Received: from minyard.net ([2001:470:b8f6:1b:75b6:e1c2:d759:60f9])
        by smtp.gmail.com with ESMTPSA id df5-20020a056830478500b0069d602841e7sm5320338otb.72.2023.04.04.05.09.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 05:09:49 -0700 (PDT)
Date:   Tue, 4 Apr 2023 07:09:47 -0500
From:   Corey Minyard <cminyard@mvista.com>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, patches@lists.linux.dev,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 006/173] ipmi:ssif: resend_msg() cannot fail
Message-ID: <ZCwTiwWHOJPKxnpQ@minyard.net>
Reply-To: cminyard@mvista.com
References: <20230403140414.174516815@linuxfoundation.org>
 <20230403140414.435644519@linuxfoundation.org>
 <ZCwIWfSovPxvPzU2@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="QOR+sTD+KrZFOVlt"
Content-Disposition: inline
In-Reply-To: <ZCwIWfSovPxvPzU2@duo.ucw.cz>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--QOR+sTD+KrZFOVlt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 04, 2023 at 01:22:01PM +0200, Pavel Machek wrote:
> Hi!
>=20
> > The resend_msg() function cannot fail, but there was error handling
> > around using it.  Rework the handling of the error, and fix the out of
> > retries debug reporting that was wrong around this, too.
>=20
> > @@ -909,31 +909,17 @@ static void msg_written_handler(struct ssif_info =
*ssif_info, int result,
> >  	if (result < 0) {
> >  		ssif_info->retries_left--;
> >  		if (ssif_info->retries_left > 0) {
> > -			if (!start_resend(ssif_info)) {
> > -				ssif_inc_stat(ssif_info, send_retries);
> > -				return;
> > -			}
> > -			/* request failed, just return the error. */
> > -			ssif_inc_stat(ssif_info, send_errors);
> > -
> > -			if (ssif_info->ssif_debug & SSIF_DEBUG_MSG)
> > -				dev_dbg(&ssif_info->client->dev,
> > -					"%s: Out of retries\n", __func__);
> > -			msg_done_handler(ssif_info, -EIO, NULL, 0);
> > +			start_resend(ssif_info);
> >  			return;
> >  		}
>=20
> ssif_inc_stat(ssif_info, send_errors); disappeared here, is that
> intentional?

Actually, ssif_inc_stat(ssif_info, send_retries); is the thing that
disappeared, since start_resend() cannot fail.  Thanks, I'll get in a
fix for that.

-corey

>=20
> Best regards,
> 								Pavel
> --=20
> DENX Software Engineering GmbH,        Managing Director: Erika Unter
> HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany



--QOR+sTD+KrZFOVlt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE/Q1c5nzg9ZpmiCaGYfOMkJGb/4EFAmQsE4UACgkQYfOMkJGb
/4ESlA/+LTl+LFdmRMQ8AsPElqqJJERgZeiXD9BkcetNuf0i+8GrKSAR/BbdKXrp
oaofSpuFjT3C9epLiTBiiETCwjJtDV8VKKrT41300m99Vwz2Epc6yAv8Te3HMtjf
mgtobScM0ajHQSnlEypgKyDpIDakAN0oE5pLklj+3iw6FjxrdRK9Z/sAD23gYMo3
AtWMZv8xFEa3WFeTecJ7vd0vQtYrGPTYusoELHTdCOjM/4tlJky7oWi4PJ1HqvKg
bjqRTC4xG/IlL3ZP6pQHKtZzvqf9nD2JvBGKJB4tdcSxHZ6ieL5ss5nXKRkUH0wy
Os8ob7S5N+hrHibbGUueSmG4r+Cq4zQi61pS47RF1z0xdD0m28he2qlfiGm29f2p
StMqwvLc4nYVIS3O7BJIY00xqfDrtdTQ8TTvzOZaI1d7zgFkv3r651/bqfnPm47a
bh19fQfd3WTkbDz2MqlHDPzvH5jAp47bifBPbB5bVHKUKUfPYoHrt6RTTtw0pw5x
+J/s0nV1KGaaMoWtqEqm50F6XwrBC4FvQCTxC08//8nruVFZYI6qNPKlNQ36ijA3
+JV1KnHxbYsdHgiLay4VuoBCBiVt0zMu+qpnE0Xgv1BOCq/sP5ivLfDeIBEjcC4N
Qee3zVUicQp36+gRY9YaPSoIAGD8mEtZA51YMbGTEvH0P9f0HwU=
=mDbO
-----END PGP SIGNATURE-----

--QOR+sTD+KrZFOVlt--
