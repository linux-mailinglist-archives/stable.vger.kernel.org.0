Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5C0DB28C
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 18:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439720AbfJQQjJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Oct 2019 12:39:09 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:46420 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729529AbfJQQjJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Oct 2019 12:39:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=sf8bXsEJ/gzi9qX1n3MNwbVkGFNy3+em1T/PTgOoIT8=; b=dFeTnLcQm7koViz9LdetehxIn
        ZaE2dDqWvOxXHpKQCSdnXBm9INDomi6AfUvhaQY1T4ErhRMYP+Ka49ykZvSLxM5KW9+vLQwT2jquP
        VYrKT8gseZspi8qEWErv4DfzppEuXlviU23K7J8beHI7TymT/lYpZHVq2EBJfmGJu2caQ=;
Received: from cpc102320-sgyl38-2-0-cust46.18-2.cable.virginm.net ([82.37.168.47] helo=ypsilon.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@sirena.co.uk>)
        id 1iL8nq-0001RY-8s; Thu, 17 Oct 2019 16:39:06 +0000
Received: by ypsilon.sirena.org.uk (Postfix, from userid 1000)
        id 641542742BAC; Thu, 17 Oct 2019 17:39:05 +0100 (BST)
Date:   Thu, 17 Oct 2019 17:39:05 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
Cc:     "festevam@gmail.com" <festevam@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Igor Opaniuk <igor.opaniuk@toradex.com>
Subject: Re: [PATCH 5.3 112/112] ASoC: sgtl5000: add ADC mute control
Message-ID: <20191017163905.GH4976@sirena.co.uk>
References: <20191016214907.599726506@linuxfoundation.org>
 <20191016220044.GB11473@sirena.co.uk>
 <20191016221025.GA990599@kroah.com>
 <20191016223518.GC11473@sirena.co.uk>
 <20191016232358.GA994597@kroah.com>
 <de9630e5-341f-b48d-029a-ef1a516bf820@skidata.com>
 <AM6PR05MB653568E379699EE907E146BDF96D0@AM6PR05MB6535.eurprd05.prod.outlook.com>
 <CAGgjyvFQQ4E5VfZ3nwFu+7UiGOmkyXK-n9PHjo1p=iYNX5JrPw@mail.gmail.com>
 <20191017111122.GA4976@sirena.co.uk>
 <b90f4cfc04686a669d145b5c5e7e59e2edf58779.camel@toradex.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="bpVaumkpfGNUagdU"
Content-Disposition: inline
In-Reply-To: <b90f4cfc04686a669d145b5c5e7e59e2edf58779.camel@toradex.com>
X-Cookie: Shut off engine before fueling.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--bpVaumkpfGNUagdU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 17, 2019 at 02:16:09PM +0000, Oleksandr Suvorov wrote:

> All versions of driver sgtl5000 (since creating in 2011) has a bug in
> sgtl5000_probe():
> ...
>        snd_soc_write(codec, SGTL5000_CHIP_ANA_CTRL,
>                        SGTL5000_HP_ZCD_EN |
>                        SGTL5000_ADC_ZCD_EN);
> ...
> This command rewrites the whole register value instead of just enabling
> ZCD feature for headphone and adc.

> This register has bits for HP/LineOut/ADC muting, thus sgtl5000_probe()
> always unmutes HP/LineOut/ADC.

Yes, or at the very least this is a badly documented bit of intentional
code.  I suspect it may be the latter but at this point we can't tell.

> 1. drop this patch and revert 631bc8f0134ae in stable versions 4.19,
> 5.2, 5.3.
> So the bug with unmuting all outputs and ADC on device probing will
> still present in all kernel versions that include sgtl500 codec driver.

This patch here being adding the userspace control of the switch and
631bc8f0134ae being the patch that made the ZC change only update the
specific bits rather than write an absolute value to the register.  This
means that we end up with the audio unmuted but no user control over
this at runtime.  From a user perspective I think this is fine, it's not
ideal that there's no control but they can still record.

Please include human readable descriptions of things like commits and
issues being discussed in e-mail in your mails, this makes them much
easier for humans to read.

> 2. keep 631bc8f0134ae and add 694b14554d75f to 4.19, 5.2 and 5.3.

This means the patch that makes ZC only update the ZC bits and also the
patch that makes the mutes user controllable, the default being muted.
As I pointed out up thread this would mean that someone upgrading to a
newer stable may need to change their userspace to do the unmute instead
of having things unconditionally unmuted by the driver.  This is not
really what people expect from stable updates, we want them to be able
to pull these in without thinking about it.  i

To backport the addition of the controls to stable we'd need an
additional change which sets the default for this control to unmuted,
there's a case for having such a change upstream regardless but it's
still not clear if any of these changes are really fixes in the sense
that we mean for stable.

> 3. add 631bc8f0134ae to 4.4, 4.9 and 4.14
>    add 694b14554d75f to 4.4-5.3
>    add 904a987345258 to 4.4

This is basically the same as 2 except it adds some more user
controllable mute controls with 904a987345258 and does different things
in different versions for reasons I'm not clear on.  It has the same
issue.

> So this bug will be fixed in all supported versions.

It is not clear that this is even a bug in the first place, it's not
full functionality but that doesn't mean that it's a bug it just means
that there's some missing functionality.

--bpVaumkpfGNUagdU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl2omSgACgkQJNaLcl1U
h9BFtwf/WoLBa6iKrS4oD2smJ7x7F9F12LWoy914JRUB1yrc5XVpYCUlO49bY3e5
qFaPCMJi1VGslhCnWai614kNU4Utca3R04QaWyniljAiQuJdFz4GBDJCfeQgjr10
rp082YJoky/l6d7uelGhsUmDgWIDtQVgs5Hnc/NniR0/94QAc55fh5TRSZD9U4KI
7yuMh7kU9zl/05aHVIJ+YmrBuk7TqmCLAcfMqSfpeolvt5I0WvC4KyB0A0C7Ybbg
0bpuIwzSMXsNPTo36fcoUvMhOaRxJ4TYchz65+wGWnLKVH8l3V3agJgKf60atwrd
fc93BCk7uqBfZG+SxKFKhL3urP/vKw==
=tOWv
-----END PGP SIGNATURE-----

--bpVaumkpfGNUagdU--
