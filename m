Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80D45311D0A
	for <lists+stable@lfdr.de>; Sat,  6 Feb 2021 13:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbhBFMKK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Feb 2021 07:10:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:43512 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229506AbhBFMKJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 6 Feb 2021 07:10:09 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1612613360; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bLVpkjvwwsqTJMAhg+ODWS/f0rJ20lZm7EB2rlXndJQ=;
        b=nETloEJqeRb1B8noD3G6MK5p7CmyF2qhrJEJwcLTMHDgWqP4kHYsmvb53bXbtY2eXKkVXu
        p3rQeHDirXputjWpw4GiAr6r3qxh31F/2v4tj+3DGeiGTPh0TGsujNdz5+P9gInc2QKU4m
        HFPXblDYLtFGC1AdcftZegmDOKKOUcs=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C3E32ACD4;
        Sat,  6 Feb 2021 12:09:20 +0000 (UTC)
Subject: Re: [PATCH 1/7] xen/events: reset affinity of 2-level event initially
To:     Julien Grall <julien@xen.org>, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org
References: <20210206104932.29064-1-jgross@suse.com>
 <20210206104932.29064-2-jgross@suse.com>
 <f89567cf-f954-0d97-087e-5e31bfa6d49d@xen.org>
From:   =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Message-ID: <d2017caa-0ea8-ae9d-d9f6-45be3da20688@suse.com>
Date:   Sat, 6 Feb 2021 13:09:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <f89567cf-f954-0d97-087e-5e31bfa6d49d@xen.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="k44Pv081BDAGDRg5GIN3FYf23bN8FtnTt"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--k44Pv081BDAGDRg5GIN3FYf23bN8FtnTt
Content-Type: multipart/mixed; boundary="sWZapDRceH0piXqAOWoHExChDqfbHzOt6";
 protected-headers="v1"
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
To: Julien Grall <julien@xen.org>, xen-devel@lists.xenproject.org,
 linux-kernel@vger.kernel.org
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 Stefano Stabellini <sstabellini@kernel.org>, stable@vger.kernel.org
Message-ID: <d2017caa-0ea8-ae9d-d9f6-45be3da20688@suse.com>
Subject: Re: [PATCH 1/7] xen/events: reset affinity of 2-level event initially
References: <20210206104932.29064-1-jgross@suse.com>
 <20210206104932.29064-2-jgross@suse.com>
 <f89567cf-f954-0d97-087e-5e31bfa6d49d@xen.org>
In-Reply-To: <f89567cf-f954-0d97-087e-5e31bfa6d49d@xen.org>

--sWZapDRceH0piXqAOWoHExChDqfbHzOt6
Content-Type: multipart/mixed;
 boundary="------------9361F2EC9288E604E62BA699"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------9361F2EC9288E604E62BA699
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 06.02.21 12:20, Julien Grall wrote:
> Hi Juergen,
>=20
> On 06/02/2021 10:49, Juergen Gross wrote:
>> When creating a new event channel with 2-level events the affinity
>> needs to be reset initially in order to avoid using an old affinity
>> from earlier usage of the event channel port.
>>
>> The same applies to the affinity when onlining a vcpu: all old
>> affinity settings for this vcpu must be reset. As percpu events get
>> initialized before the percpu event channel hook is called,
>> resetting of the affinities happens after offlining a vcpu (this is
>> working, as initial percpu memory is zeroed out).
>>
>> Cc: stable@vger.kernel.org
>> Reported-by: Julien Grall <julien@xen.org>
>> Signed-off-by: Juergen Gross <jgross@suse.com>
>> ---
>> =C2=A0 drivers/xen/events/events_2l.c | 20 ++++++++++++++++++++
>> =C2=A0 1 file changed, 20 insertions(+)
>>
>> diff --git a/drivers/xen/events/events_2l.c=20
>> b/drivers/xen/events/events_2l.c
>> index da87f3a1e351..23217940144a 100644
>> --- a/drivers/xen/events/events_2l.c
>> +++ b/drivers/xen/events/events_2l.c
>> @@ -47,6 +47,16 @@ static unsigned evtchn_2l_max_channels(void)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return EVTCHN_2L_NR_CHANNELS;
>> =C2=A0 }
>> +static int evtchn_2l_setup(evtchn_port_t evtchn)
>> +{
>> +=C2=A0=C2=A0=C2=A0 unsigned int cpu;
>> +
>> +=C2=A0=C2=A0=C2=A0 for_each_online_cpu(cpu)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 clear_bit(evtchn, BM(per_c=
pu(cpu_evtchn_mask, cpu)));
>=20
> The bit corresponding to the event channel can only be set on a single =

> CPU. Could we avoid the loop and instead clear the bit while closing th=
e=20
> port?

This would need another callback.


Juergen


--------------9361F2EC9288E604E62BA699
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

--------------9361F2EC9288E604E62BA699--

--sWZapDRceH0piXqAOWoHExChDqfbHzOt6--

--k44Pv081BDAGDRg5GIN3FYf23bN8FtnTt
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmAehu8FAwAAAAAACgkQsN6d1ii/Ey9X
kwgAlYliBzwYKSnfrnhvXCvyGlf/2wg58/IU1RSP3v/M21lBFPsvzMXY6/x3au0rfGt8u6GZiFyE
6BdzORQdNVQzW1ODZcLHE0I3MRmoLQtfMbzg/xRD4DgG5dyJybjY7Wd0EbNJbj9L7P1Qq90OuJXj
0qWwz/MHElHwYa+MhcXdvZsRckN8gFyo389TKMlmCdb9V1Cs54KHy3czAuviGJ0WpZv62hzeteHM
I1WpABERAa3P5Ftx59OwyRWLF7n/hWDZUaBzzWqOnFwxD8eEkdU976Qy4XKo5KEbzKWtFz8k+m8v
SKj2/6BuXAEvo+ANYxJdxQ/vaONqkDIJa7jwa0A64A==
=dKdX
-----END PGP SIGNATURE-----

--k44Pv081BDAGDRg5GIN3FYf23bN8FtnTt--
