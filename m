Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D50F331E3E
	for <lists+stable@lfdr.de>; Tue,  9 Mar 2021 06:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbhCIFOl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Mar 2021 00:14:41 -0500
Received: from mx2.suse.de ([195.135.220.15]:34476 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229475AbhCIFOR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Mar 2021 00:14:17 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1615266856; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BwvCGl4RerrOMc9D3VhJpaldx+CpAEoVSAb7RV+Msz0=;
        b=PsjkzlUmjyNWLXREWyB7xNn47Lt1T1qcBVj929+SN9We23f06yjU0Cdu7T57DwVa+Y/JXI
        00xxr6+6cdKI9bHU8uj/gH2FdCy7mfpjJLrhgFlpHw9pHjHi80qZlMWH3ngOq+8pI2FxM+
        jY5DMrrzbd8QAXRkVn4CzPpCUJ5qojc=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D2610AB8C;
        Tue,  9 Mar 2021 05:14:15 +0000 (UTC)
Subject: Re: [PATCH v4 2/3] xen/events: don't unmask an event channel when an
 eoi is pending
To:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        ross.lagerwall@citrix.com
Cc:     Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org, Julien Grall <julien@xen.org>,
        Julien Grall <jgrall@amazon.com>
References: <20210306161833.4552-1-jgross@suse.com>
 <20210306161833.4552-3-jgross@suse.com>
 <ff9fb99f-12ca-c04e-e4bc-1b1c67381cc2@oracle.com>
From:   =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Message-ID: <d6a1ab2e-4b77-7b14-e397-74aa71efb70d@suse.com>
Date:   Tue, 9 Mar 2021 06:14:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <ff9fb99f-12ca-c04e-e4bc-1b1c67381cc2@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="q01kZynA2QJbHdjvIabMM3OzYodc49c7C"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--q01kZynA2QJbHdjvIabMM3OzYodc49c7C
Content-Type: multipart/mixed; boundary="tNpc0ydQx80iYjL3FMABQniegUgVN9sys";
 protected-headers="v1"
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
 ross.lagerwall@citrix.com
Cc: Stefano Stabellini <sstabellini@kernel.org>, stable@vger.kernel.org,
 Julien Grall <julien@xen.org>, Julien Grall <jgrall@amazon.com>
Message-ID: <d6a1ab2e-4b77-7b14-e397-74aa71efb70d@suse.com>
Subject: Re: [PATCH v4 2/3] xen/events: don't unmask an event channel when an
 eoi is pending
References: <20210306161833.4552-1-jgross@suse.com>
 <20210306161833.4552-3-jgross@suse.com>
 <ff9fb99f-12ca-c04e-e4bc-1b1c67381cc2@oracle.com>
In-Reply-To: <ff9fb99f-12ca-c04e-e4bc-1b1c67381cc2@oracle.com>

--tNpc0ydQx80iYjL3FMABQniegUgVN9sys
Content-Type: multipart/mixed;
 boundary="------------BE5ED103C411FDF22705A2DF"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------BE5ED103C411FDF22705A2DF
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 08.03.21 21:33, Boris Ostrovsky wrote:
>=20
> On 3/6/21 11:18 AM, Juergen Gross wrote:
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
>> Reviewed-by: Julien Grall <jgrall@amazon.com>
>> ---
>> V2:
>> - introduce a lock around masking/unmasking
>> - merge patch 3 into this one (Jan Beulich)
>> V4:
>> - don't set eoi masking flag in lateeoi_mask_ack_dynirq()
>=20
>=20
> Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
>=20
>=20
> Ross, are you planning to test this?

Just as another data point: With the previous version of the patches
a reboot loop of a guest needed max 33 reboots to loose network in
my tests (those were IIRC 6 test runs). With this patch version I
stopped the test after about 1300 reboots without having seen any
problems.

Juergen

--------------BE5ED103C411FDF22705A2DF
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

--------------BE5ED103C411FDF22705A2DF--

--tNpc0ydQx80iYjL3FMABQniegUgVN9sys--

--q01kZynA2QJbHdjvIabMM3OzYodc49c7C
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmBHBCYFAwAAAAAACgkQsN6d1ii/Ey/A
eQf/QH0znaB3+GMsnTj6zXH3Lw1t8QxjO7acZvpKciqqjxU6LRgnSY7h37Zu/SWPvf8tjantQM0z
aSbxaifZ8dmJOAICQ/djKo4WL/Ib26xkPool0Y56dqm/MdUrLBRz7Mr83SGajlO+hIsgs0Jfk9R8
whnC7ogsGZ1iFjGWVHhsEQyXdVTVgplWjf4NDFptDpRTYPT+5QOu4AL++SG0auWnFCNcN7LXv7g3
aKMxs4iyA1jtN16kXvqLI7EHFHDKp/ETHvKBLpLq4ZfsNt23VVPxE95PK7HrDNTq4NhDsxntOF6T
n3U0HgH407F+rwqhpuF5a+HAD9Z2Qb+jR8OwuNQxww==
=9CG/
-----END PGP SIGNATURE-----

--q01kZynA2QJbHdjvIabMM3OzYodc49c7C--
