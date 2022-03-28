Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6966D4E9C4E
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 18:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241943AbiC1Qdl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 12:33:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233718AbiC1Qdk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 12:33:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FD4B62A17;
        Mon, 28 Mar 2022 09:32:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CAD36B80E70;
        Mon, 28 Mar 2022 16:31:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D239C004DD;
        Mon, 28 Mar 2022 16:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648485117;
        bh=hK7ZDdgQaPjqOYen8B81+Sjmp3Ahshxy0heHpeX2Ado=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V64A7qzbboy0p+y9aBTjLc241GMoRliUriJxyNrw6yB/jmVHADwXP4GoWMZOiZVey
         fSVW6+r6DFMiNbPdvBTPox/Ah4BTa8+qYvJi1ghnduc9HW1EnDo37W4hDT+X9HbAKp
         nhvU1oQhmiwdiOGgkZXxGOMyoelYavWmr8AI57qTYbwi1lEdXsUAc3kQ/yoWrV+RO8
         4YmZ/i4hfuEZcxWmuZ4ZW/bYCinDrRi/oLomJ56HpbbGFyCAJmvSLy0Pr+jSmQR3Yw
         NazZK5zP/Ga/fRV6B7z7EwI5hc6ahI+UjFP4be+aQapGo+bbSzrRPEt9ckM+CeQrHr
         7/1QGw/bgTLhA==
Date:   Mon, 28 Mar 2022 17:31:51 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>
Cc:     lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] soc: soc-dapm: fix two incorrect uses of list iterator
Message-ID: <YkHi98GDDWNie7GP@sirena.org.uk>
References: <20220327082138.13696-1-xiam0nd.tong@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="U/jhfLnga9E37WzA"
Content-Disposition: inline
In-Reply-To: <20220327082138.13696-1-xiam0nd.tong@gmail.com>
X-Cookie: What hath Bob wrought?
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--U/jhfLnga9E37WzA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Mar 27, 2022 at 04:21:38PM +0800, Xiaomeng Tong wrote:

>  		case snd_soc_dapm_pre:
> -			if (!w->event)
> +			if (!w->event) {
>  				list_for_each_entry_safe_continue(w, n, list,
>  								  power_list);
> +				break;
> +			}

This doesn't make much sense.  The intent here seems to clearly be to
continue; the loop but this doesn't do that - instead it appears that
continue doesn't actually do the equivalent of a continue but rather
skips over an entry.  This should instead be replaced with a plain
continue statement.

THe naming of _continue() needs fixing I think - it's just asking to be
a bug.  Fortunately there's very few users.

--U/jhfLnga9E37WzA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmJB4vYACgkQJNaLcl1U
h9CKuAf+J7JMfNycivcp5VxSUAzxAbiMWBbMwaM201sPHiXMYm9MwDk+lxEQ6yzi
jhSvB1tSNDLp4rHftobH7ShFTed4UOx/RhLShGKJPPJo3l1sfpvZYRdYdS1KGbTm
kjGx8Q4RaC6LyJjsZw8VGEvsf6lC/cJRP8MGMuTo7fN5OW8U5l8YpK9w53xaaIgo
D9f4ah5tKdO4zwpXNrYvk5U6wKjkPT9qXM6MBarcJrWuoEn16JY36o8kcCvLr2PH
xZnlW44J91Kgd/AQuUxl0wM2g5Wde5Pbk0QrlVJCrBwfIhnA0ql5RFezuS+sSZ/w
7JuLdDfkWs7g9P1i+AH1hcRZ/1BNVQ==
=Y449
-----END PGP SIGNATURE-----

--U/jhfLnga9E37WzA--
