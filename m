Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3E0C66518B
	for <lists+stable@lfdr.de>; Wed, 11 Jan 2023 03:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234783AbjAKCMz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 21:12:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231989AbjAKCMn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 21:12:43 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B7A66544
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:12:42 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id cp9-20020a17090afb8900b00226a934e0e5so2551994pjb.1
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:12:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=irVeOhn1a5BJ5XA0SQi4wtUBmDMjtpLuPHDNe0+Ec60=;
        b=RqZBJHmo7cc9H+guxiqP2NX8/GQ8JClOF8pN+9RtpdWT1LbdrPxz4IacjBbU0PcjYt
         wDaAW6hmD277UmLUy/2Hm+hTc/iQnFcqMY4S++Pq7u+SmFyxYPVzDJpA/5S3GjsniwH9
         dV7OLk1Am5qzV5vgzVM6OVlTolKHGBrk6eXc4jkhFADrt25K6FfrmE9paBWKRWKi+cia
         NAS2/GObFO4psH8um4kHhpZuAIjSMAo6Wt9Z+8h5JLVAHnnAwoa5GB2FU/m/nflsxRA5
         rWqIAU4/h5D6kUOmxmzPOV64eurU2Vo3vS+Jmrg1pAP5Noy+rPYdrO3Vu1X6xMkZ557A
         hmRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=irVeOhn1a5BJ5XA0SQi4wtUBmDMjtpLuPHDNe0+Ec60=;
        b=O0iSeS+L8QuNO8WrItBI6OmfOb5HkTM4dW7jYK25HkMvhbhrUS95YtwGyp74EnJOnz
         c8087UGRW9vexk6T7PJACk4NMuLNkMB69wH2aCqTpXa/TV+hOHiRgP0kGR72XCe70FU6
         h4vd9XV99YSI+imS7uxfpL0we6Oo88Fb/3X92AfLGzUqNxL9ZVRfYCONoFcB7ioHUrtu
         dY4Uj5Ktg+Qkg22v2gprnkoqQgXGzC2Wq5pV7ZXzFqiXVU4WP7gcZnTc9TG8QXaU46xI
         vEYFIzJBkxlVyftWweCg6UOAEdViDgKYGgzBQQ8qCUgW7FDPNraIkVWHNojREEJKtToV
         46uQ==
X-Gm-Message-State: AFqh2kpQgXDbr3b8dttopogPovGtbe3/ByofWUYx0HIcXnD0wf8BWNqP
        fxWKPl3pwNOxsOD5GlEaXaF0vw==
X-Google-Smtp-Source: AMrXdXsEVn2qTlKmP6JJUfhl6nqQZ6QlxNOmOSAQSZc5kHcdh34HBugnFRueVQPoQfUH25ZW5v0rfA==
X-Received: by 2002:a17:902:b10e:b0:191:4367:7fde with SMTP id q14-20020a170902b10e00b0019143677fdemr226996plr.0.1673403161675;
        Tue, 10 Jan 2023 18:12:41 -0800 (PST)
Received: from google.com ([2620:15c:9d:2:6a48:569f:20c1:dc8])
        by smtp.gmail.com with ESMTPSA id p5-20020a170902bd0500b001932a9e4f2csm5657256pls.255.2023.01.10.18.12.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 18:12:40 -0800 (PST)
Date:   Tue, 10 Jan 2023 18:12:35 -0800
From:   Benson Leung <bleung@google.com>
To:     Prashant Malani <pmalani@chromium.org>
Cc:     linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        bleung@chromium.org, stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guillaume Ranquet <granquet@baylibre.com>,
        Macpaul Lin <macpaul.lin@mediatek.com>,
        Pablo Sun <pablo.sun@mediatek.com>
Subject: Re: [PATCH 2/3] usb: typec: altmodes/displayport: Fix pin assignment
 calculation
Message-ID: <Y74bEyUOT3mrAY+I@google.com>
References: <20230111020546.3384569-1-pmalani@chromium.org>
 <20230111020546.3384569-2-pmalani@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="H3XDtXqWAjLUxnxA"
Content-Disposition: inline
In-Reply-To: <20230111020546.3384569-2-pmalani@chromium.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--H3XDtXqWAjLUxnxA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 11, 2023 at 02:05:42AM +0000, Prashant Malani wrote:
> Commit c1e5c2f0cb8a ("usb: typec: altmodes/displayport: correct pin
> assignment for UFP receptacles") fixed the pin assignment calculation
> to take into account whether the peripheral was a plug or a receptacle.
>=20
> But the "pin_assignments" sysfs logic was not updated. Address this by
> using the macros introduced in the aforementioned commit in the sysfs
> logic too.
>=20
> Fixes: c1e5c2f0cb8a ("usb: typec: altmodes/displayport: correct pin assig=
nment for UFP receptacles")
> Cc: stable@vger.kernel.org
> Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> Signed-off-by: Prashant Malani <pmalani@chromium.org>

Reviewed-by: Benson Leung <bleung@chromium.org>


> ---
>  drivers/usb/typec/altmodes/displayport.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/usb/typec/altmodes/displayport.c b/drivers/usb/typec=
/altmodes/displayport.c
> index f9d4a7648bc9..c0d65c93cefe 100644
> --- a/drivers/usb/typec/altmodes/displayport.c
> +++ b/drivers/usb/typec/altmodes/displayport.c
> @@ -427,9 +427,9 @@ static const char * const pin_assignments[] =3D {
>  static u8 get_current_pin_assignments(struct dp_altmode *dp)
>  {
>  	if (DP_CONF_CURRENTLY(dp->data.conf) =3D=3D DP_CONF_DFP_D)
> -		return DP_CAP_UFP_D_PIN_ASSIGN(dp->alt->vdo);
> +		return DP_CAP_PIN_ASSIGN_DFP_D(dp->alt->vdo);
>  	else
> -		return DP_CAP_DFP_D_PIN_ASSIGN(dp->alt->vdo);
> +		return DP_CAP_PIN_ASSIGN_UFP_D(dp->alt->vdo);
>  }
> =20
>  static ssize_t
> --=20
> 2.39.0.314.g84b9a713c41-goog
>=20

--=20
Benson Leung
Staff Software Engineer
Chrome OS Kernel
Google Inc.
bleung@google.com
Chromium OS Project
bleung@chromium.org

--H3XDtXqWAjLUxnxA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQQCtZK6p/AktxXfkOlzbaomhzOwwgUCY74bEwAKCRBzbaomhzOw
wh4+APwJLOrut48PsUp3KdWO6i0ZWSEbCPvHJvr5NOu69xx+MgEAneRgoN+BIzhp
qyspS5trJHRIAs3eO2MXCdpL0L7OAQk=
=/0xh
-----END PGP SIGNATURE-----

--H3XDtXqWAjLUxnxA--
