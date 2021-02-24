Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 848BC323715
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 07:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233711AbhBXGAJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 01:00:09 -0500
Received: from mx2.suse.de ([195.135.220.15]:55424 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233311AbhBXGAJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 01:00:09 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 6F8EDADCD;
        Wed, 24 Feb 2021 05:59:27 +0000 (UTC)
Subject: Re: [PATCH v3] drm: Use USB controller's DMA mask when importing
 dmabufs
To:     Greg KH <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>
Cc:     Mathias Nyman <mathias.nyman@linux.intel.com>, hdegoede@redhat.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Oliver Neukum <oneukum@suse.com>,
        Johan Hovold <johan@kernel.org>,
        dri-devel@lists.freedesktop.org, christian.koenig@amd.com,
        airlied@linux.ie, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        sean@poorly.run, Christoph Hellwig <hch@lst.de>
References: <20210223105842.27011-1-tzimmermann@suse.de>
 <s5hh7m2vqyd.wl-tiwai@suse.de> <f4452070-bab1-35ad-69aa-d020a4a3a5b7@suse.de>
 <20210223160054.GC1261797@rowland.harvard.edu> <YDU7naIDtg5IM0Sz@kroah.com>
From:   Thomas Zimmermann <tzimmermann@suse.de>
Message-ID: <d255a6c8-4348-3aef-b410-415566418f4c@suse.de>
Date:   Wed, 24 Feb 2021 06:59:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YDU7naIDtg5IM0Sz@kroah.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="nQudoPuhcJk4FGGLnlplbxIzg0LF3nFC0"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--nQudoPuhcJk4FGGLnlplbxIzg0LF3nFC0
Content-Type: multipart/mixed; boundary="2IhysdsNLPfWsRC8nPxLKdv1wUERlTOmS";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: Greg KH <gregkh@linuxfoundation.org>,
 Alan Stern <stern@rowland.harvard.edu>
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>, hdegoede@redhat.com,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Oliver Neukum <oneukum@suse.com>, Johan Hovold <johan@kernel.org>,
 dri-devel@lists.freedesktop.org, christian.koenig@amd.com, airlied@linux.ie,
 stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>, sean@poorly.run,
 Christoph Hellwig <hch@lst.de>
Message-ID: <d255a6c8-4348-3aef-b410-415566418f4c@suse.de>
Subject: Re: [PATCH v3] drm: Use USB controller's DMA mask when importing
 dmabufs
References: <20210223105842.27011-1-tzimmermann@suse.de>
 <s5hh7m2vqyd.wl-tiwai@suse.de> <f4452070-bab1-35ad-69aa-d020a4a3a5b7@suse.de>
 <20210223160054.GC1261797@rowland.harvard.edu> <YDU7naIDtg5IM0Sz@kroah.com>
In-Reply-To: <YDU7naIDtg5IM0Sz@kroah.com>

--2IhysdsNLPfWsRC8nPxLKdv1wUERlTOmS
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi

Am 23.02.21 um 18:30 schrieb Greg KH:
> On Tue, Feb 23, 2021 at 11:00:54AM -0500, Alan Stern wrote:
>> On Tue, Feb 23, 2021 at 03:06:07PM +0100, Thomas Zimmermann wrote:
>>> Hi
>>>
>>> Am 23.02.21 um 14:44 schrieb Takashi Iwai:
>>
>>>> Aside from the discussion whether this "workaround" is needed, the u=
se
>>>> of udev->bus->controller here looks a bit suspicious.  As the old US=
B
>>>> code (before the commit 6eb0233ec2d0) indicated, it was rather
>>>> usb->bus->sysdev that was used for the DMA mask, and it's also the o=
ne
>>>> most of USB core code refers to.  A similar question came up while
>>>> fixing the same kind of bug in the media subsystem, and we concluded=

>>>> that bus->sysdev is a better choice.
>>>
>>> Good to hear that we're not the only ones affected by this. Wrt the o=
riginal
>>> code, using sysdev makes even more sense.
>>
>> Hmmm, I had forgotten about this.  So DMA masks aren't inherited after=

>> all, thanks to commit 6eb0233ec2d0.  That leas me to wonder how well
>> usb-storage is really working these days...
>>
>> The impression I get is that Greg would like the USB core to export a
>> function which takes struct usb_interface * as argument and returns th=
e
>> appropriate DMA mask value.  Then instead of messing around with USB
>> internals, drm_gem_prime_import_usb could just call this new function.=

>>
>> Adding such a utility function would be a sufficiently small change th=
at
>> it could go into the -stable kernels with no trouble.
>=20
> Yes, sorry for not being clear, that is what I think would make the mos=
t
> sense, then all USB drivers could use it easily and it can be changed i=
n
> one location if the DMA logic ever changes.

We can certainly do that. Thanks for clarifying. I'll send out an=20
updated patch soon.

Best regards
Thomas

>=20
> thanks,
>=20
> greg k-h
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel
>=20

--=20
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Maxfeldstr. 5, 90409 N=C3=BCrnberg, Germany
(HRB 36809, AG N=C3=BCrnberg)
Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=B6rffer


--2IhysdsNLPfWsRC8nPxLKdv1wUERlTOmS--

--nQudoPuhcJk4FGGLnlplbxIzg0LF3nFC0
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmA16z0FAwAAAAAACgkQlh/E3EQov+CB
jBAAg/yUvEfw4VHrUbO3gk2kOiCv+LAGGzNy8/AW08efUqHujd8Ky0TokfO5Nt1kzl8PVkLbuaJZ
xLCk7215ihobbLNdzPWiaQH+8hNLJD5VGTsuS9zMnZ77WBrhxxk85rY16w9dzKUhZmlBKMQ8lfx1
4Q3jx+KTlguHBF5cCRfGp9Yw5pcQtWm4MHWsuKV3uQtqv+FRGfI8HSW0iklENkV9rJPNOc0N4FNf
4hKUOobo/6zbqso302e/l+HyAE4TIlRq94y3kJCY5XVK3zBIIQpVpfz7uNRE4kZpaNfxCGjdSLLl
2Zedw8eTETIRtX0513u1V1rbUJV6aGTi2Q6cVjwiVkchyKHNAU4whcPcELwklDfZVzTv1lOqtp/Q
99OigNNDGIc5ApMFoXPyCScQdKaOG2NKbda/CePI8DmEKCZiJHrVDxsAMKqvV4P0q/4mrzTmHg2E
mzKuvJKLZgtoL/pUof22krffahoctfeqyNtmiZi1SkYzCylcFhv4bIReK8DPnmVP4oG5QjFJhnlz
Kog4j0tXrNY2fwVZZQGvEx7joU/gVOlxNY6BfaKbvybvzr3qb0CRvVcl7bMYo7u60seXuddPmMVT
NxC6pbeKdLRYnhyGbqvIpEg6s+TBUGnlhpyBejl2WyV2t81hKoQexQIIx/CwFF99OEUCKAlw10tY
D1A=
=/LxH
-----END PGP SIGNATURE-----

--nQudoPuhcJk4FGGLnlplbxIzg0LF3nFC0--
