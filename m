Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55A3132FBCD
	for <lists+stable@lfdr.de>; Sat,  6 Mar 2021 17:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbhCFQSe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Mar 2021 11:18:34 -0500
Received: from mx2.suse.de ([195.135.220.15]:39310 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230390AbhCFQS1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 6 Mar 2021 11:18:27 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1615047506; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nukSOwxYWB0nbFvij2/Dm4omz/vg/Y2S787KBEpkjPQ=;
        b=ikq+lyIUCyWydGZBrbc/5vetOXvA7c9Q6hQJW0KBEmRC9tFWwX0wFFanEWxAZbeoDsxu74
        J7hdq2bBlhniAgRF14O9XCLXvRIk9ujSdaYEc1+JSKoGpc1pQ4YIfgug7gB2edU3FkEwzy
        nsuGkx/XECs/lscQfYjAWefZvBz6Qe0=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0F0B2ACBF;
        Sat,  6 Mar 2021 16:18:26 +0000 (UTC)
Subject: Re: [PATCH v3 2/8] xen/events: don't unmask an event channel when an
 eoi is pending
To:     Ross Lagerwall <ross.lagerwall@citrix.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org, Julien Grall <julien@xen.org>
References: <20210219154030.10892-1-jgross@suse.com>
 <20210219154030.10892-3-jgross@suse.com>
 <d368a948-17d6-4e64-110e-bede3158f49f@citrix.com>
From:   =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Message-ID: <134540c1-40ac-3607-6ca0-3dcd5f83a013@suse.com>
Date:   Sat, 6 Mar 2021 17:18:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <d368a948-17d6-4e64-110e-bede3158f49f@citrix.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="kTuR8myBCAf9zSbzIMWx6GIuaVMSZMcto"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--kTuR8myBCAf9zSbzIMWx6GIuaVMSZMcto
Content-Type: multipart/mixed; boundary="tI9qAvQfSWeoIIbUUygUcu92S5FGuW44I";
 protected-headers="v1"
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
To: Ross Lagerwall <ross.lagerwall@citrix.com>,
 xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 Stefano Stabellini <sstabellini@kernel.org>, stable@vger.kernel.org,
 Julien Grall <julien@xen.org>
Message-ID: <134540c1-40ac-3607-6ca0-3dcd5f83a013@suse.com>
Subject: Re: [PATCH v3 2/8] xen/events: don't unmask an event channel when an
 eoi is pending
References: <20210219154030.10892-1-jgross@suse.com>
 <20210219154030.10892-3-jgross@suse.com>
 <d368a948-17d6-4e64-110e-bede3158f49f@citrix.com>
In-Reply-To: <d368a948-17d6-4e64-110e-bede3158f49f@citrix.com>

--tI9qAvQfSWeoIIbUUygUcu92S5FGuW44I
Content-Type: multipart/mixed;
 boundary="------------93BA1965D22E272FDC5B4750"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------93BA1965D22E272FDC5B4750
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 23.02.21 10:26, Ross Lagerwall wrote:
> On 2021-02-19 15:40, Juergen Gross wrote:
>> An event channel should be kept masked when an eoi is pending for it.
>> When being migrated to another cpu it might be unmasked, though.
>>
>> In order to avoid this keep three different flags for each event chann=
el
>> to be able to distinguish "normal" masking/unmasking from eoi related
>> masking/unmasking and temporary masking. The event channel should only=

>> be able to generate an interrupt if all flags are cleared.
>>
>> Cc: stable@vger.kernel.org
>> Fixes: 54c9de89895e0a36047 ("xen/events: add a new late EOI evtchn fra=
mework")
>> Reported-by: Julien Grall <julien@xen.org>
>> Signed-off-by: Juergen Gross <jgross@suse.com>
>=20
> I tested this patch series backported to a 4.19 kernel and found that
> when doing a reboot loop of Windows with PV drivers, occasionally it wi=
ll
> end up in a state with some event channels pending and masked in dom0
> which breaks networking in the guest.
>=20
> The issue seems to have been introduced with this patch, though at firs=
t
> glance it appears correct. I haven't yet looked into why it is happenin=
g.
> Have you seen anything like this with this patch?

I have found the issue. lateeoi_mask_ack_dynirq() must not set the "eoi"
mask reason flag, as this callback will be called when the handler will
not be called later, so there will never be a call of xen_irq_lateeoi()
to unmask the event channel again.

Juergen


--------------93BA1965D22E272FDC5B4750
Content-Type: application/pgp-keys;
 name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="OpenPGP_0xB0DE9DD628BF132F.asc"

-----BEGIN PGP PUBLIC KEY BLOCK-----

xsBNBFOMcBYBCACgGjqjoGvbEouQZw/ToiBg9W98AlM2QHV+iNHsEs7kxWhKMjrioyspZKOBy=
cWx
w3ie3j9uvg9EOB3aN4xiTv4qbnGiTr3oJhkB1gsb6ToJQZ8uxGq2kaV2KL9650I1SJvedYm8O=
f8Z
d621lSmoKOwlNClALZNew72NjJLEzTalU1OdT7/i1TXkH09XSSI8mEQ/ouNcMvIJNwQpd369y=
9bf
IhWUiVXEK7MlRgUG6MvIj6Y3Am/BBLUVbDa4+gmzDC9ezlZkTZG2t14zWPvxXP3FAp2pkW0xq=
G7/
377qptDmrk42GlSKN4z76ELnLxussxc7I2hx18NUcbP8+uty4bMxABEBAAHNHEp1ZXJnZW4gR=
3Jv
c3MgPGpnQHBmdXBmLm5ldD7CwHkEEwECACMFAlOMcBYCGwMHCwkIBwMCAQYVCAIJCgsEFgIDA=
QIe
AQIXgAAKCRCw3p3WKL8TL0KdB/93FcIZ3GCNwFU0u3EjNbNjmXBKDY4FUGNQH2lvWAUy+dnyT=
hpw
dtF/jQ6j9RwE8VP0+NXcYpGJDWlNb9/JmYqLiX2Q3TyevpB0CA3dbBQp0OW0fgCetToGIQrg0=
MbD
1C/sEOv8Mr4NAfbauXjZlvTj30H2jO0u+6WGM6nHwbh2l5O8ZiHkH32iaSTfN7Eu5RnNVUJbv=
oPH
Z8SlM4KWm8rG+lIkGurqqu5gu8q8ZMKdsdGC4bBxdQKDKHEFExLJK/nRPFmAuGlId1E3fe10v=
5QL
+qHI3EIPtyfE7i9Hz6rVwi7lWKgh7pe0ZvatAudZ+JNIlBKptb64FaiIOAWDCx1SzR9KdWVyZ=
2Vu
IEdyb3NzIDxqZ3Jvc3NAc3VzZS5jb20+wsB5BBMBAgAjBQJTjHCvAhsDBwsJCAcDAgEGFQgCC=
QoL
BBYCAwECHgECF4AACgkQsN6d1ii/Ey/HmQf/RtI7kv5A2PS4RF7HoZhPVPogNVbC4YA6lW7Dr=
Wf0
teC0RR3MzXfy6pJ+7KLgkqMlrAbN/8Dvjoz78X+5vhH/rDLa9BuZQlhFmvcGtCF8eR0T1v0nC=
/nu
AFVGy+67q2DH8As3KPu0344TBDpAvr2uYM4tSqxK4DURx5INz4ZZ0WNFHcqsfvlGJALDeE0Lh=
ITT
d9jLzdDad1pQSToCnLl6SBJZjDOX9QQcyUigZFtCXFst4dlsvddrxyqT1f17+2cFSdu7+ynLm=
XBK
7abQ3rwJY8SbRO2iRulogc5vr/RLMMlscDAiDkaFQWLoqHHOdfO9rURssHNN8WkMnQfvUewRz=
80h
SnVlcmdlbiBHcm9zcyA8amdyb3NzQG5vdmVsbC5jb20+wsB5BBMBAgAjBQJTjHDXAhsDBwsJC=
AcD
AgEGFQgCCQoLBBYCAwECHgECF4AACgkQsN6d1ii/Ey8PUQf/ehmgCI9jB9hlgexLvgOtf7PJn=
FOX
gMLdBQgBlVPO3/D9R8LtF9DBAFPNhlrsfIG/SqICoRCqUcJ96Pn3P7UUinFG/I0ECGF4EvTE1=
jnD
kfJZr6jrbjgyoZHiw/4BNwSTL9rWASyLgqlA8u1mf+c2yUwcGhgkRAd1gOwungxcwzwqgljf0=
N51
N5JfVRHRtyfwq/ge+YEkDGcTU6Y0sPOuj4Dyfm8fJzdfHNQsWq3PnczLVELStJNdapwPOoE+l=
otu
fe3AM2vAEYJ9rTz3Cki4JFUsgLkHFqGZarrPGi1eyQcXeluldO3m91NK/1xMI3/+8jbO0tsn1=
tqS
EUGIJi7ox80eSnVlcmdlbiBHcm9zcyA8amdyb3NzQHN1c2UuZGU+wsB5BBMBAgAjBQJTjHDrA=
hsD
BwsJCAcDAgEGFQgCCQoLBBYCAwECHgECF4AACgkQsN6d1ii/Ey+LhQf9GL45eU5vOowA2u5N3=
g3O
ZUEBmDHVVbqMtzwlmNC4k9Kx39r5s2vcFl4tXqW7g9/ViXYuiDXb0RfUpZiIUW89siKrkzmQ5=
dM7
wRqzgJpJwK8Bn2MIxAKArekWpiCKvBOB/Cc+3EXE78XdlxLyOi/NrmSGRIov0karw2RzMNOu5=
D+j
LRZQd1Sv27AR+IP3I8U4aqnhLpwhK7MEy9oCILlgZ1QZe49kpcumcZKORmzBTNh30FVKK1Evm=
V2x
AKDoaEOgQB4iFQLhJCdP1I5aSgM5IVFdn7v5YgEYuJYx37IoN1EblHI//x/e2AaIHpzK5h88N=
Eaw
QsaNRpNSrcfbFmAg987ATQRTjHAWAQgAyzH6AOODMBjgfWE9VeCgsrwH3exNAU32gLq2xvjpW=
nHI
s98ndPUDpnoxWQugJ6MpMncr0xSwFmHEgnSEjK/PAjppgmyc57BwKII3sV4on+gDVFJR6Y8ZR=
wgn
BC5mVM6JjQ5xDk8WRXljExRfUX9pNhdE5eBOZJrDRoLUmmjDtKzWaDhIg/+1Hzz93X4fCQkNV=
bVF
LELU9bMaLPBG/x5q4iYZ2k2ex6d47YE1ZFdMm6YBYMOljGkZKwYde5ldM9mo45mmwe0icXKLk=
pEd
IXKTZeKDO+Hdv1aqFuAcccTg9RXDQjmwhC3yEmrmcfl0+rPghO0Iv3OOImwTEe4co3c1mwARA=
QAB
wsBfBBgBAgAJBQJTjHAWAhsMAAoJELDendYovxMvQ/gH/1ha96vm4P/L+bQpJwrZ/dneZcmEw=
Tbe
8YFsw2V/Buv6Z4Mysln3nQK5ZadD534CF7TDVft7fC4tU4PONxF5D+/tvgkPfDAfF77zy2AH1=
vJz
Q1fOU8lYFpZXTXIHb+559UqvIB8AdgR3SAJGHHt4RKA0F7f5ipYBBrC6cyXJyyoprT10EMvU8=
VGi
wXvTyJz3fjoYsdFzpWPlJEBRMedCot60g5dmbdrZ5DWClAr0yau47zpWj3enf1tLWaqcsuylW=
svi
uGjKGw7KHQd3bxALOknAp4dN3QwBYCKuZ7AddY9yjynVaD5X7nF9nO5BjR/i1DG86lem3iBDX=
zXs
ZDn8R38=3D
=3D2wuH
-----END PGP PUBLIC KEY BLOCK-----

--------------93BA1965D22E272FDC5B4750--

--tI9qAvQfSWeoIIbUUygUcu92S5FGuW44I--

--kTuR8myBCAf9zSbzIMWx6GIuaVMSZMcto
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmBDq1EFAwAAAAAACgkQsN6d1ii/Ey8J
7Qf+NHVK97kON4roGF5RJItEisdxbr0ccBbz9u1cZr1HZERP3O8P79ah2OdFk0Xw2sgEp3Hgfvce
/rmWAZIt0bfRZua04Z4q2jzoahX1bROTAqZ68/m9Dj3esK/st6gp+SKt7SwWlCDvv3JT7Zm8UR9U
FGGf+ar0Sr6E01dC+KaOf7pUuZiGCbor60s4Ko9hZDvW3cGp2ofwaKX4IfVTCUmnHRX5ZGGSr6R7
ZoCa1Mo1kS78RhVQ5zlGrS3HVR2p1+9xZwCcXdpO5py9iFI/5pwkBdZty7hFEolV5vnPyF8kLt8Q
RbU2euBuFCYwCyQgv6zKRBtzoqZYZiCMcVcJH1a4cA==
=2K6b
-----END PGP SIGNATURE-----

--kTuR8myBCAf9zSbzIMWx6GIuaVMSZMcto--
