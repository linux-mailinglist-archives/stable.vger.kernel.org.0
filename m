Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C17D247E429
	for <lists+stable@lfdr.de>; Thu, 23 Dec 2021 14:40:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243667AbhLWNkl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Dec 2021 08:40:41 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:39616 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238660AbhLWNkk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Dec 2021 08:40:40 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 304E2210E9;
        Thu, 23 Dec 2021 13:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1640266839; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YiDR+4/nieQeAOKbU2oGGRKnr9gCnviUV4iOLI6JEaE=;
        b=WltkrI0E9+OTf7AoyoEUq/NW0AJJdVW/W532pLVS22+geMWuQ3Y+LDexxHpI/KUZCr6zsg
        lcFDTd5Anq5eGhPFQyEYaKPFxn8qpo0/m7q0xF5Uc6IH2BwXQgqqN9xrbXsFyJVZqNw8yV
        ck0ypeaCk8+e3rpdxqzjugGJueUDxqc=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 137D513E38;
        Thu, 23 Dec 2021 13:40:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id xkt1A1d8xGFfYwAAMHmgww
        (envelope-from <jgross@suse.com>); Thu, 23 Dec 2021 13:40:39 +0000
Subject: Re: [PATCH] xen/blkfront: fix bug in backported patch
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org, xen-devel@lists.xenproject.org
References: <20211223105308.17077-1-jgross@suse.com>
 <YcRWNWtraLXt9W8v@kroah.com>
From:   Juergen Gross <jgross@suse.com>
Message-ID: <9823fe0a-2db4-bc4b-2d7c-6363856322ff@suse.com>
Date:   Thu, 23 Dec 2021 14:40:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YcRWNWtraLXt9W8v@kroah.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="oILMpFocktKvEJeoHQm73Ou8ctrcT6kw8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--oILMpFocktKvEJeoHQm73Ou8ctrcT6kw8
Content-Type: multipart/mixed; boundary="Ok42bv1j9tp6S394x4lJffOiY8w0Ljwyl";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Greg KH <greg@kroah.com>
Cc: stable@vger.kernel.org, xen-devel@lists.xenproject.org
Message-ID: <9823fe0a-2db4-bc4b-2d7c-6363856322ff@suse.com>
Subject: Re: [PATCH] xen/blkfront: fix bug in backported patch
References: <20211223105308.17077-1-jgross@suse.com>
 <YcRWNWtraLXt9W8v@kroah.com>
In-Reply-To: <YcRWNWtraLXt9W8v@kroah.com>

--Ok42bv1j9tp6S394x4lJffOiY8w0Ljwyl
Content-Type: multipart/mixed;
 boundary="------------A7AFA908A67E80CD1F635943"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------A7AFA908A67E80CD1F635943
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 23.12.21 11:57, Greg KH wrote:
> On Thu, Dec 23, 2021 at 11:53:08AM +0100, Juergen Gross wrote:
>> The backport of commit 8f5a695d99000fc ("xen/blkfront: don't take loca=
l
>> copy of a request from the ring page") to stable 4.4 kernel introduced=

>> a bug when adding the needed blkif_ring_get_request() function, as
>> info->ring.req_prod_pvt was incremented twice now.
>>
>> Fix that be deleting the now superfluous increments after calling that=

>> function.
>>
>> Signed-off-by: Juergen Gross <jgross@suse.com>
>> ---
>>   drivers/block/xen-blkfront.c | 4 ----
>>   1 file changed, 4 deletions(-)
>=20
> So this is only needed in 4.4.y?  No other backports were incorrect?

Yes. 4.4 only.


Juergen

--------------A7AFA908A67E80CD1F635943
Content-Type: application/pgp-keys;
 name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Transfer-Encoding: quoted-printable
Content-Description: OpenPGP public key
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

--------------A7AFA908A67E80CD1F635943--

--Ok42bv1j9tp6S394x4lJffOiY8w0Ljwyl--

--oILMpFocktKvEJeoHQm73Ou8ctrcT6kw8
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmHEfFYFAwAAAAAACgkQsN6d1ii/Ey+h
Mgf/aVsKJujh58k9L3PfIFFHzkiuA+ZBPvtM0fEMBV35kgpB94AFcjA0r9EGPQtQ9gyQgnzPoNx8
xA0otFGOuKg+HS3rJuZ8Aw12sy/60+jJsRUhfEvNFz9lkoge8DNcOTfeM5EOMxr6dXJjkk+7kLPV
N+0JhvFbe/fYxcJii6kligV4Zfmn1YHhCKNXDflgqqad0P0BUeWxhr+uMKRFcmR1KR+AFH1RHqQu
aJDIi3x8XXF2Qqn1QUFg8ow1t8zjytE6ubZmAE7vJpwl73xXzIicHjh65yebThuDY0cf+mhk0t8J
46MTosS9B+B/uAhmS3Lbtwxuu5MuFkrkxwc5OXRMzg==
=XRAF
-----END PGP SIGNATURE-----

--oILMpFocktKvEJeoHQm73Ou8ctrcT6kw8--
