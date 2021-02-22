Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63D913211A5
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 08:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbhBVHxe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 02:53:34 -0500
Received: from mx2.suse.de ([195.135.220.15]:47470 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230331AbhBVHxd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 02:53:33 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 270E8AE03;
        Mon, 22 Feb 2021 07:52:51 +0000 (UTC)
Subject: Re: [PATCH] drm/prime: Only call dma_map_sgtable() for devices with
 DMA support
To:     Alan Stern <stern@rowland.harvard.edu>,
        =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Cc:     daniel@ffwll.ch, airlied@linux.ie,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        sumit.semwal@linaro.org, gregkh@linuxfoundation.org,
        dri-devel@lists.freedesktop.org, noralf@tronnes.org,
        Christoph Hellwig <hch@lst.de>,
        Johan Hovold <johan@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Oliver Neukum <oneukum@suse.com>,
        Felipe Balbi <balbi@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
References: <20210219134014.7775-1-tzimmermann@suse.de>
 <02a45c11-fc73-1e5a-3839-30b080950af8@amd.com>
 <20210219155328.GA1111829@rowland.harvard.edu>
From:   Thomas Zimmermann <tzimmermann@suse.de>
Message-ID: <03c676df-b587-6d1f-20da-0a54267d6685@suse.de>
Date:   Mon, 22 Feb 2021 08:52:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210219155328.GA1111829@rowland.harvard.edu>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="64mtIiMeFA1lM9z04BneAZKiuGaO2LwTP"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--64mtIiMeFA1lM9z04BneAZKiuGaO2LwTP
Content-Type: multipart/mixed; boundary="Vr7h2TTkrYveWiohTE9VcHNe7v0nDTQGT";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: Alan Stern <stern@rowland.harvard.edu>,
 =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Cc: daniel@ffwll.ch, airlied@linux.ie, maarten.lankhorst@linux.intel.com,
 mripard@kernel.org, sumit.semwal@linaro.org, gregkh@linuxfoundation.org,
 dri-devel@lists.freedesktop.org, noralf@tronnes.org,
 Christoph Hellwig <hch@lst.de>, Johan Hovold <johan@kernel.org>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 "Ahmed S. Darwish" <a.darwish@linutronix.de>,
 Mathias Nyman <mathias.nyman@linux.intel.com>,
 Oliver Neukum <oneukum@suse.com>, Felipe Balbi <balbi@kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Message-ID: <03c676df-b587-6d1f-20da-0a54267d6685@suse.de>
Subject: Re: [PATCH] drm/prime: Only call dma_map_sgtable() for devices with
 DMA support
References: <20210219134014.7775-1-tzimmermann@suse.de>
 <02a45c11-fc73-1e5a-3839-30b080950af8@amd.com>
 <20210219155328.GA1111829@rowland.harvard.edu>
In-Reply-To: <20210219155328.GA1111829@rowland.harvard.edu>

--Vr7h2TTkrYveWiohTE9VcHNe7v0nDTQGT
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi

Am 19.02.21 um 16:53 schrieb Alan Stern:
> On Fri, Feb 19, 2021 at 02:45:54PM +0100, Christian K=C3=B6nig wrote:
>> Well as far as I can see this is a relative clear NAK.
>>
>> When a device can't do DMA and has no DMA mask then why it is requesti=
ng an
>> sg-table in the first place?
>=20
> This may not be important for your discussion, but I'd like to give an
> answer to the question -- at least, for the case of USB.
>=20
> A USB device cannot do DMA and has no DMA mask.  Nevertheless, if you
> want to send large amounts of bulk data to/from a USB device then using=

> an SG table is often a good way to do it.  The reason is simple: All
> communication with a USB device has to go through a USB host controller=
,
> and many (though not all) host controllers _can_ do DMA and _do_ have a=

> DMA mask.

It's semi-related. One idea we had for speeding up transfers is to use=20
the USB controller's DMA functionality and allocate framebuffers=20
accordingly. It needs a bit of work in the DRM memory-management code=20
IIRC. And we do some internal modifications if the frambuffer's data, so =

direct forwarding from renderer to USB controller is not always possible.=


Best regards
Thomas

>=20
> The USB mass-storage and uas drivers in particular make heavy use of
> this mechanism.
>=20
> Alan Stern
>=20

--=20
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Maxfeldstr. 5, 90409 N=C3=BCrnberg, Germany
(HRB 36809, AG N=C3=BCrnberg)
Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=B6rffer


--Vr7h2TTkrYveWiohTE9VcHNe7v0nDTQGT--

--64mtIiMeFA1lM9z04BneAZKiuGaO2LwTP
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmAzYtEFAwAAAAAACgkQlh/E3EQov+Ck
yw/+Izy2DQ4YCdmKtt7QBSFTtzrqetq4AJTfC3RMKmRNrJFqxVvRXSokrL6+KkwXqD1rj6f8wrn9
8TARZ/vm/CEknnpq3Z+L8EbzC1KyQvDerKI3W06P79EM3WPnlEmb+v5YXSMzzsZsh/68jxtXY0pQ
6Ae7iWvK9zeBrLkMalFLBiCDW/uXpL7VA+SbvHOCbPGX0kNXkvVOjY+lUUh/bJTvrO9ON9At5aKt
5A/Ppo+Gazs2AwS6I7gAaL/KjxWkH9HJHckPikUVn7/7cskykQeFEcaRCivmksifOfyAxMcG8U79
248RIHDxltApGMc3DgtVTSMOQKL1v11ioAvWZez80Yso8+PyyDglhRq1Lkrm46Je+cyxVfZQRIeY
xVVmkvEmVAGZOOsCtGlWk7mjA8quTnooI4XZhbtLEaoQzHXKXIHPtmcvZnB2i3siz+cG/zq2i750
lWbZ4UxpHsRNM9m+yNy5GO/HE1hRKIFxSAop5RgrfhR3TKWlSdZ2dfv2chDVseEXfjt0uTXkkAh4
+sqcMOzbsUI7eXMP3iNy8X6RS/flcM6W3+15pQUsJqKj5TxbgCe5AobFj5mb7bhB3Qn5PwFHlvT+
q8L7zOFWAh4kfZHFE1ZRda7SJhRFtXJDsf8kA2YI2E8ZzpOWe2TRmzBMSZfyJdYnGLE6QVnqQ700
kP4=
=NLoA
-----END PGP SIGNATURE-----

--64mtIiMeFA1lM9z04BneAZKiuGaO2LwTP--
