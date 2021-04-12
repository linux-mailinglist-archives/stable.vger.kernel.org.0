Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6375035C2A6
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 12:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237776AbhDLJrA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:47:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:37806 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241991AbhDLJkE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:40:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1618220382; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jrZBxSq5AWWzSeZgh55OiCUsXR2J3HeOl9tZCRpozco=;
        b=jHge4AbVMOouE1xpHkvp+HndcYlwLTOueULf9Pf6A+6xO1S4pjSZQDzKIyk9Tl9s/QtZhJ
        +06RRZ7tCYhqwCmD4j0/tEmrfiCRdJZUxmBcIf08VOef8wXUAC2G57Xyx8+XeZO0JRUlkO
        Im1WcpKtKplrdMqW+k4Ei6QOhu6knxs=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 68BEBADEF;
        Mon, 12 Apr 2021 09:39:42 +0000 (UTC)
Subject: Re: [PATCH] xen/events: fix setting irq affinity
To:     Jan Beulich <jbeulich@suse.com>
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        xen-devel@lists.xenproject.org, stable@vger.kernel.org
References: <20210412062845.13946-1-jgross@suse.com>
 <38b2b47d-a77a-9d02-3034-f1c4d03ffdd5@suse.com>
From:   Juergen Gross <jgross@suse.com>
Message-ID: <bec9c7a5-5661-73b4-1b0b-137dacba7bbf@suse.com>
Date:   Mon, 12 Apr 2021 11:39:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <38b2b47d-a77a-9d02-3034-f1c4d03ffdd5@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="9lwOrTyyNgUZVE7i0BwmBlgeTZYDSdNQY"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9lwOrTyyNgUZVE7i0BwmBlgeTZYDSdNQY
Content-Type: multipart/mixed; boundary="OEAubtW2QeisXwpfLo5vRZP6wbEBDojbo";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Jan Beulich <jbeulich@suse.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 Stefano Stabellini <sstabellini@kernel.org>, xen-devel@lists.xenproject.org,
 stable@vger.kernel.org
Message-ID: <bec9c7a5-5661-73b4-1b0b-137dacba7bbf@suse.com>
Subject: Re: [PATCH] xen/events: fix setting irq affinity
References: <20210412062845.13946-1-jgross@suse.com>
 <38b2b47d-a77a-9d02-3034-f1c4d03ffdd5@suse.com>
In-Reply-To: <38b2b47d-a77a-9d02-3034-f1c4d03ffdd5@suse.com>

--OEAubtW2QeisXwpfLo5vRZP6wbEBDojbo
Content-Type: multipart/mixed;
 boundary="------------6CCC38779F4E417872DE31E6"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------6CCC38779F4E417872DE31E6
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 12.04.21 11:32, Jan Beulich wrote:
> On 12.04.2021 08:28, Juergen Gross wrote:
>> The backport of upstream patch 25da4618af240fbec61 ("xen/events: don't=

>> unmask an event channel when an eoi is pending") introduced a
>> regression for stable kernels 5.10 and older: setting IRQ affinity for=

>> IRQs related to interdomain events would no longer work, as moving the=

>> IRQ to its new cpu was not included in the irq_ack callback for those
>> events.
>>
>> Fix that by adding the needed call.
>>
>> Note that kernels 5.11 and later don't need the explicit moving of the=

>> IRQ to the target cpu in the irq_ack callback, due to a rework of the
>> affinity setting in kernel 5.11.
>>
>> Signed-off-by: Juergen Gross <jgross@suse.com>
>> ---
>> This patch should be applied to all stable kernel branches up to
>> (including) linux-5.10.y, where upstream patch 25da4618af240fbec61 has=

>> been added.
>>
>> Signed-off-by: Juergen Gross <jgross@suse.com>
>=20
> This looks functionally correct to me, so:
> Reviewed-by: Jan Beulich <jbeulich@suse.com>
>=20
> But I have remarks / questions:
>=20
>> --- a/drivers/xen/events/events_base.c
>> +++ b/drivers/xen/events/events_base.c
>> @@ -1809,7 +1809,7 @@ static void lateeoi_ack_dynirq(struct irq_data *=
data)
>>  =20
>>   	if (VALID_EVTCHN(evtchn)) {
>>   		do_mask(info, EVT_MASK_REASON_EOI_PENDING);
>> -		event_handler_exit(info);
>> +		ack_dynirq(data);
>>   	}
>>   }
>>  =20
>> @@ -1820,7 +1820,7 @@ static void lateeoi_mask_ack_dynirq(struct irq_d=
ata *data)
>>  =20
>>   	if (VALID_EVTCHN(evtchn)) {
>>   		do_mask(info, EVT_MASK_REASON_EXPLICIT);
>> -		event_handler_exit(info);
>> +		ack_dynirq(data);
>>   	}
>>   }
>>  =20
>=20
> Can EVT_MASK_REASON_EOI_{PENDING,EXPLICIT} be cleared in a way racing
> event_handler_exit() and (if it was called directly from here)
> irq_move_masked_irq()? If not, the extra do_mask() / do_unmask() pair
> (granted living on an "unlikely" path) could be avoided.

No, they can't race. And yes, the path is really unlikely, so I didn't
want to optimize this rare case.

> Even leaving aside the extra overhead in ack_dynirq()'s unlikely code
> path, there's now some extra (redundant) processing. I guess this is
> assumed to be within noise?

Yes. All required data should be in the caches already, and the extra
processing is only a few instructions.

> Possibly related, but first of all seeing the redundancy between
> eoi_pirq() and ack_dynirq(): Wouldn't it make sense to break out the
> common part into a helper? (Really the former could simply call the
> latter as it seems.)

In theory, yes. OTOH this no longer applies to upstream, so i dind't
bother doing that for stable.


Juergen

--------------6CCC38779F4E417872DE31E6
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

--------------6CCC38779F4E417872DE31E6--

--OEAubtW2QeisXwpfLo5vRZP6wbEBDojbo--

--9lwOrTyyNgUZVE7i0BwmBlgeTZYDSdNQY
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmB0FV0FAwAAAAAACgkQsN6d1ii/Ey/O
3gf/bBiUq2qoeupNrB4Kas/mjPXYiTX3GsYjvZ8ixznD2X7TxCHMxzb9rAz5M5RjYgmCrIlhqDxE
FObF+ibX1IHmbbYiMLzjBW/bUxIZXjJoJaHl0cSRZlBHAJW2zSf6yJitYuR/kAkM7p2TJ9TUJjXb
UPc969zS3HSfImZGr/dzMwlJjj/AX5pDvWO5pxvHpgEwdag7IwuueI7JNE0eLM56k1UHDWg+4Vw+
IgwitKnbcD+exW6PlPMcCzpaM3FBsknAtPoE0x96g/dGXU/g0dX8SpuVLj97wbF/hEkJJud58vwa
G3UkckFl7aQ11UrtWtlfoQndQ6xvm6DIWDxKjKHw0w==
=kcB1
-----END PGP SIGNATURE-----

--9lwOrTyyNgUZVE7i0BwmBlgeTZYDSdNQY--
