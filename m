Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB12312EE3
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 11:24:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232164AbhBHKYA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 05:24:00 -0500
Received: from mx2.suse.de ([195.135.220.15]:41542 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232166AbhBHKVv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 05:21:51 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1612779663; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mfkAxxAokOUF/5Yrj0Gcend/eK2vJW+zxm1Juw1PG30=;
        b=GeD4RdYExGDvC/5H56o8lCjnLdv3RWi36iUlebvwdQ2k9AE3LVOM/JxaMg1+3c5WZINwpB
        YSASq02Rrd1+5IrGYsSzzox1msonlsQRKdkzzY7H6kFme5Jg5bxnwwN4GxaxOkQelRmItS
        KEdOxweuaOjwxMHasssCIdh0X8MJwU4=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 8D087AE74;
        Mon,  8 Feb 2021 10:21:03 +0000 (UTC)
Subject: Re: [PATCH 2/7] xen/events: don't unmask an event channel when an eoi
 is pending
To:     Jan Beulich <jbeulich@suse.com>
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org, Julien Grall <julien@xen.org>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
References: <20210206104932.29064-1-jgross@suse.com>
 <20210206104932.29064-3-jgross@suse.com>
 <7aa76e26-b6f4-fae2-861b-bcc0039ce497@suse.com>
From:   =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Message-ID: <db19fbd4-f613-b8b5-3d46-eaa674417e4f@suse.com>
Date:   Mon, 8 Feb 2021 11:21:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <7aa76e26-b6f4-fae2-861b-bcc0039ce497@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="i8j5vHaygQB9c5oKqQXikXYebgrf8KGnM"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--i8j5vHaygQB9c5oKqQXikXYebgrf8KGnM
Content-Type: multipart/mixed; boundary="mQVnubCfralaKH811EULeoqUjdynnObGW";
 protected-headers="v1"
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
To: Jan Beulich <jbeulich@suse.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 Stefano Stabellini <sstabellini@kernel.org>, stable@vger.kernel.org,
 Julien Grall <julien@xen.org>, xen-devel@lists.xenproject.org,
 linux-kernel@vger.kernel.org
Message-ID: <db19fbd4-f613-b8b5-3d46-eaa674417e4f@suse.com>
Subject: Re: [PATCH 2/7] xen/events: don't unmask an event channel when an eoi
 is pending
References: <20210206104932.29064-1-jgross@suse.com>
 <20210206104932.29064-3-jgross@suse.com>
 <7aa76e26-b6f4-fae2-861b-bcc0039ce497@suse.com>
In-Reply-To: <7aa76e26-b6f4-fae2-861b-bcc0039ce497@suse.com>

--mQVnubCfralaKH811EULeoqUjdynnObGW
Content-Type: multipart/mixed;
 boundary="------------CDB33DBB3839EBD104452B3B"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------CDB33DBB3839EBD104452B3B
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 08.02.21 11:06, Jan Beulich wrote:
> On 06.02.2021 11:49, Juergen Gross wrote:
>> @@ -1798,6 +1818,29 @@ static void mask_ack_dynirq(struct irq_data *da=
ta)
>>   	ack_dynirq(data);
>>   }
>>  =20
>> +static void lateeoi_ack_dynirq(struct irq_data *data)
>> +{
>> +	struct irq_info *info =3D info_for_irq(data->irq);
>> +	evtchn_port_t evtchn =3D info ? info->evtchn : 0;
>> +
>> +	if (VALID_EVTCHN(evtchn)) {
>> +		info->eoi_pending =3D true;
>> +		mask_evtchn(evtchn);
>> +	}
>> +}
>> +
>> +static void lateeoi_mask_ack_dynirq(struct irq_data *data)
>> +{
>> +	struct irq_info *info =3D info_for_irq(data->irq);
>> +	evtchn_port_t evtchn =3D info ? info->evtchn : 0;
>> +
>> +	if (VALID_EVTCHN(evtchn)) {
>> +		info->masked =3D true;
>> +		info->eoi_pending =3D true;
>> +		mask_evtchn(evtchn);
>> +	}
>> +}
>> +
>>   static int retrigger_dynirq(struct irq_data *data)
>>   {
>>   	evtchn_port_t evtchn =3D evtchn_from_irq(data->irq);
>> @@ -2023,8 +2066,8 @@ static struct irq_chip xen_lateeoi_chip __read_m=
ostly =3D {
>>   	.irq_mask		=3D disable_dynirq,
>>   	.irq_unmask		=3D enable_dynirq,
>>  =20
>> -	.irq_ack		=3D mask_ack_dynirq,
>> -	.irq_mask_ack		=3D mask_ack_dynirq,
>> +	.irq_ack		=3D lateeoi_ack_dynirq,
>> +	.irq_mask_ack		=3D lateeoi_mask_ack_dynirq,
>>  =20
>>   	.irq_set_affinity	=3D set_affinity_irq,
>>   	.irq_retrigger		=3D retrigger_dynirq,
>>
>=20
> Unlike the prior handler the two new ones don't call ack_dynirq()
> anymore, and the description doesn't give a hint towards this
> difference. As a consequence, clear_evtchn() also doesn't get
> called anymore - patch 3 adds the calls, but claims an older
> commit to have been at fault. _If_ ack_dynirq() indeed isn't to
> be called here, shouldn't the clear_evtchn() calls get added
> right here?

There was clearly too much time between writing this patch and looking
at its performance impact. :-(

Somehow I managed to overlook that I just introduced the bug here. This
OTOH explains why there are not tons of complaints with the current
implementation. :-)

Will merge patch 3 into this one.


Juergen

--------------CDB33DBB3839EBD104452B3B
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

--------------CDB33DBB3839EBD104452B3B--

--mQVnubCfralaKH811EULeoqUjdynnObGW--

--i8j5vHaygQB9c5oKqQXikXYebgrf8KGnM
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmAhEI4FAwAAAAAACgkQsN6d1ii/Ey89
kAf/ZUDsoa83NwD65pWWPOxU/aJHnp/4FqhoQB9WZoZSGqaf0aKK2Ij75nsIkms5Z17Kehnz2ZA4
cXlGsJUFAZ/zQh9acB5K5SDQeHZqN3+qOGvX1Lki4zit23JOzJdiJWdbq6yE1SW8DqGU9gBNaLfW
/QXt4qT14sfD00ZprR4rt3O/z8Z5gt3Wew7Khqe/u2bPDQkGmt/Wryo66WiO4PJSYdAPYa4Wf5Ix
NF97qLzKd/M40DovPBl7njfNMcKwrbdWDTu3Ukwg496QsnflUFEk5R3Cpz380hkTEqYS6sfLuPV4
Gmt7u0xwXmUHK9EKi8tnd1dWNNPLibHkOe0grJGT3A==
=tE8T
-----END PGP SIGNATURE-----

--i8j5vHaygQB9c5oKqQXikXYebgrf8KGnM--
