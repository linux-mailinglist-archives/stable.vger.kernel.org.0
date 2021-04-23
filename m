Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7A4368D80
	for <lists+stable@lfdr.de>; Fri, 23 Apr 2021 09:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbhDWHBF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Apr 2021 03:01:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:55634 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229478AbhDWHBF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Apr 2021 03:01:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1619161227; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3gXh3FGsXDlt+Rrt1Wsm/dUEJBcFCjrIm4/In1CZTGc=;
        b=CoTXtgLIjUHnzL1b7CsMnguagAfqih5iEU0WTUeGVW4ZdrlP5n2grb8OAsdeN3MRxSnaVw
        Uk5ukFz45myh2gUxahLgpj8Kio8qwESo+5N57AO0r/zZe62zKhYF4vxWPI+1CCJxREIyst
        4YFdxBNteM7HJf1hKZzoLgVT9pfbV/g=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 6CAD5AFE2;
        Fri, 23 Apr 2021 07:00:27 +0000 (UTC)
Subject: Re: [PATCH] xen/gntdev: fix gntdev_mmap() error exit path
To:     Luca Fancellu <luca.fancellu@arm.com>
Cc:     xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org,
        =?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?= 
        <marmarek@invisiblethingslab.com>
References: <20210423054038.26696-1-jgross@suse.com>
 <467B8109-C829-4755-8398-196E50090898@arm.com>
From:   Juergen Gross <jgross@suse.com>
Message-ID: <9cb9bd6c-8185-9741-31b9-8f6baf3848a3@suse.com>
Date:   Fri, 23 Apr 2021 09:00:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <467B8109-C829-4755-8398-196E50090898@arm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="7ayNSUCrXn5ckIGGaFScYNp0p0tZKBGXJ"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7ayNSUCrXn5ckIGGaFScYNp0p0tZKBGXJ
Content-Type: multipart/mixed; boundary="LKCNSGiy0nLMI7qsYI7xNT6BUHoXvzqvv";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Luca Fancellu <luca.fancellu@arm.com>
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 Stefano Stabellini <sstabellini@kernel.org>, stable@vger.kernel.org,
 =?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?= <marmarek@invisiblethingslab.com>
Message-ID: <9cb9bd6c-8185-9741-31b9-8f6baf3848a3@suse.com>
Subject: Re: [PATCH] xen/gntdev: fix gntdev_mmap() error exit path
References: <20210423054038.26696-1-jgross@suse.com>
 <467B8109-C829-4755-8398-196E50090898@arm.com>
In-Reply-To: <467B8109-C829-4755-8398-196E50090898@arm.com>

--LKCNSGiy0nLMI7qsYI7xNT6BUHoXvzqvv
Content-Type: multipart/mixed;
 boundary="------------B36DB28A3BBCE5553396DB97"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------B36DB28A3BBCE5553396DB97
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 23.04.21 08:55, Luca Fancellu wrote:
>=20
>=20
>> On 23 Apr 2021, at 06:40, Juergen Gross <jgross@suse.com> wrote:
>>
>> Commit d3eeb1d77c5d0af ("xen/gntdev: use mmu_interval_notifier_insert"=
)
>> introduced an error in gntdev_mmap(): in case the call of
>> mmu_interval_notifier_insert_locked() fails the exit path should not
>> call mmu_interval_notifier_remove(), as this might result in NULL
>> dereferences.
>>
>> One reason for failure is e.g. a signal pending for the running
>> process.
>>
>> Fixes: d3eeb1d77c5d0af ("xen/gntdev: use mmu_interval_notifier_insert"=
)
>> Cc: stable@vger.kernel.org
>> Reported-by: Marek Marczykowski-G=C3=B3recki <marmarek@invisiblethings=
lab.com>
>> Tested-by: Marek Marczykowski-G=C3=B3recki <marmarek@invisiblethingsla=
b.com>
>> Signed-off-by: Juergen Gross <jgross@suse.com>
>> ---
>> drivers/xen/gntdev.c | 4 +++-
>> 1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
>> index f01d58c7a042..a3e7be96527d 100644
>> --- a/drivers/xen/gntdev.c
>> +++ b/drivers/xen/gntdev.c
>> @@ -1017,8 +1017,10 @@ static int gntdev_mmap(struct file *flip, struc=
t vm_area_struct *vma)
>> 		err =3D mmu_interval_notifier_insert_locked(
>> 			&map->notifier, vma->vm_mm, vma->vm_start,
>> 			vma->vm_end - vma->vm_start, &gntdev_mmu_ops);
>> -		if (err)
>> +		if (err) {
>> +			map->vma =3D NULL;
>> 			goto out_unlock_put;
>> +		}
>> 	}
>> 	mutex_unlock(&priv->lock);
>>
>> --=20
>> 2.26.2
>>
>>
>=20
> Hi Juergen,
>=20
> I can see from the code that there is another path to out_unlock_put la=
bel some lines before:
>=20
>          [=E2=80=A6]
>          vma->vm_private_data =3D map;
> 	if (map->flags) {
> 		if ((vma->vm_flags & VM_WRITE) &&
> 				(map->flags & GNTMAP_readonly))
> 			goto out_unlock_put;
> 	} else {
> 		map->flags =3D GNTMAP_host_map;
> 		if (!(vma->vm_flags & VM_WRITE))
> 			map->flags |=3D GNTMAP_readonly;
> 	}
>          [=E2=80=A6]
>=20
> Can be the case that use_ptemod is !=3D 0 also for that path?

map->vma will be NULL in this case, so there will be no problem
resulting from that path.


Juergen

--------------B36DB28A3BBCE5553396DB97
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

--------------B36DB28A3BBCE5553396DB97--

--LKCNSGiy0nLMI7qsYI7xNT6BUHoXvzqvv--

--7ayNSUCrXn5ckIGGaFScYNp0p0tZKBGXJ
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmCCcIoFAwAAAAAACgkQsN6d1ii/Ey+w
nAf+O46tcpYGxWRUlmpQz9aXmS/beyu7Al3yBGxj2izhyazpO5pqlpeoFVYYp4lpDFbHLDv8Gk28
mjDKZMjqunQHQPQZHz+mQyb5jV0+nYKMtg8zglbYXSaXKJHNUhFeb3/qrHW2ce0G2XTgPBlrhLzc
FBr2ifE/9GYtTpax4pXB7ZRlVXnyZp4NGNPQyhpzQvwgNeG0ckgpi62mbEKk6tnD2cY4pkacoFfS
kmtkOl8pPp2rgXZBwRTf8wHkWbtd8umWJ0iu9d2hDj4s7imcKny5Cn8h00lgxVcVfXv9j5blEEVc
N/sbGvwfN8pmgP3AI8a/Bupwe88ybpwfo5izuwGrcA==
=zxBS
-----END PGP SIGNATURE-----

--7ayNSUCrXn5ckIGGaFScYNp0p0tZKBGXJ--
