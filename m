Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91537495C3C
	for <lists+stable@lfdr.de>; Fri, 21 Jan 2022 09:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234507AbiAUIq3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jan 2022 03:46:29 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:34712 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379616AbiAUIoG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jan 2022 03:44:06 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 45834218ED;
        Fri, 21 Jan 2022 08:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1642754645; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+nqVeT08mrJpHzyoInkYIgIo/MheF55WNHiHZCva8qo=;
        b=b4ddEBDUAUdOp7OX4QHDub/6c09LlEsXeOGxqy6VuANKaesjRp5cfGixAqWLiqWkoG0I4S
        amOS6FjBO+O6O9FOurE4MhcgxzX6oa3nsb4WkwTvIMbuofBZQysFrfzOL06tgSZd/X/Lpa
        iPMhoZaqmP2IDaNRsLyLooFVtnJdFQ0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1642754645;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+nqVeT08mrJpHzyoInkYIgIo/MheF55WNHiHZCva8qo=;
        b=2+xevdpFXp5yxhMjNTB462AjFesOhlni0G1IrIZnwC83pejHYEDSuuFp+cF2rNYUv4oPMT
        UBf0o8eiWYvKBBCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 214CF13BAC;
        Fri, 21 Jan 2022 08:44:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id mvsBB1Vy6mFAPgAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Fri, 21 Jan 2022 08:44:05 +0000
Message-ID: <550c94f9-8302-c015-17be-d97fbe2e1b89@suse.de>
Date:   Fri, 21 Jan 2022 09:44:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] drm/vmwgfx: Stop requesting the pci regions
Content-Language: en-US
To:     Zack Rusin <zackr@vmware.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "javierm@redhat.com" <javierm@redhat.com>
Cc:     Martin Krastev <krastevm@vmware.com>,
        Maaz Mombasawala <mombasawalam@vmware.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20220117180359.18114-1-zack@kde.org>
 <1c177e79-d28a-e896-08ec-3cd4cd2fb823@redhat.com>
 <da4e34772a9557cf4c4733ce6ee2a2ad47615044.camel@vmware.com>
 <5292edf8-0e60-28e1-15d3-6a1779023f68@suse.de>
 <afc4c659-b92e-3227-634f-7c171b7a74b3@suse.de>
 <80fc6b88d659dd7281364daccfed1fd294e785dc.camel@vmware.com>
 <89f1b9df-6ace-d59c-86a4-571cd92d0a4c@suse.de>
 <e9f42f83d7966952c8c0ff78be7e510a2aebdf01.camel@vmware.com>
 <14b3043a-2569-f4fb-a73d-d67ee1feaee4@suse.de>
 <9f9b9417d04e4ca7157b03a1e4430e2ce374d97a.camel@vmware.com>
From:   Thomas Zimmermann <tzimmermann@suse.de>
In-Reply-To: <9f9b9417d04e4ca7157b03a1e4430e2ce374d97a.camel@vmware.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------ykSv4ZUIDDse1lbC9Qu2srIW"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------ykSv4ZUIDDse1lbC9Qu2srIW
Content-Type: multipart/mixed; boundary="------------Ibl9G10vqptQtp7lyMNoRHxd";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: Zack Rusin <zackr@vmware.com>,
 "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
 "javierm@redhat.com" <javierm@redhat.com>
Cc: Martin Krastev <krastevm@vmware.com>,
 Maaz Mombasawala <mombasawalam@vmware.com>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>
Message-ID: <550c94f9-8302-c015-17be-d97fbe2e1b89@suse.de>
Subject: Re: [PATCH] drm/vmwgfx: Stop requesting the pci regions
References: <20220117180359.18114-1-zack@kde.org>
 <1c177e79-d28a-e896-08ec-3cd4cd2fb823@redhat.com>
 <da4e34772a9557cf4c4733ce6ee2a2ad47615044.camel@vmware.com>
 <5292edf8-0e60-28e1-15d3-6a1779023f68@suse.de>
 <afc4c659-b92e-3227-634f-7c171b7a74b3@suse.de>
 <80fc6b88d659dd7281364daccfed1fd294e785dc.camel@vmware.com>
 <89f1b9df-6ace-d59c-86a4-571cd92d0a4c@suse.de>
 <e9f42f83d7966952c8c0ff78be7e510a2aebdf01.camel@vmware.com>
 <14b3043a-2569-f4fb-a73d-d67ee1feaee4@suse.de>
 <9f9b9417d04e4ca7157b03a1e4430e2ce374d97a.camel@vmware.com>
In-Reply-To: <9f9b9417d04e4ca7157b03a1e4430e2ce374d97a.camel@vmware.com>

--------------Ibl9G10vqptQtp7lyMNoRHxd
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkNCg0KQW0gMjAuMDEuMjIgdW0gMjI6Mjggc2NocmllYiBaYWNrIFJ1c2luOg0KPiBPbiBU
aHUsIDIwMjItMDEtMjAgYXQgMTE6MDAgKzAxMDAsIFRob21hcyBaaW1tZXJtYW5uIHdyb3Rl
Og0KPj4+Pg0KPj4+PiBJZiB0aGF0IHdvcmtzLCB3b3VsZCB5b3UgY29uc2lkZXIgcHJvdGVj
dGluZyBwY2lfcmVxdWVzdF9yZWdpb24oKQ0KPj4+PiB3aXRoDQo+Pj4+ICDCoMKgICNpZiBu
b3QgZGVmaW5lZChDT05GSUdfRkJfU0lNUExFKQ0KPj4+PiAgwqDCoCAjZW5kaWYNCj4+Pj4N
Cj4+Pj4gd2l0aCBhIEZJWE1FIGNvbW1lbnQ/DQo+Pj4NCj4+PiBZZXMsIEkgdGhpbmsgdGhh
dCdzIGEgZ29vZCBjb21wcm9taXNlLiBJJ2xsIHJlc3BpbiB0aGUgcGF0Y2ggd2l0aA0KPj4+
IHRoYXQuDQo+Pg0KPj4gQmVmb3JlIHlvdSBkbyB0aGF0LCBJIGhhdmUgb25lIG1vcmUgcGF0
Y2ggZm9yIHlvdSB0byB0cnkuIEl0J3MgYWxsDQo+PiB0aGUNCj4+IGNoYW5nZXMgYXMgYmVm
b3JlLCBidXQgbm93IGZiZGV2IGhvdC11bnBsdWdzIHRoZSB1bmRlcmx5aW5nIHBsYXRmb3Jt
DQo+PiBkZXZpY2UgZnJvbSB0aGUgZGV2aWNlIGhpZXJhcmNoeS4gVGhlIEJPT1RGQiB3aWxs
IG5vdCBjb25zdW1lIHBhcnRzDQo+PiBvZg0KPj4gdm13Z2Z4J3MgZGlzcGxheSBtZW1vcnkg
cmFuZ2UgYW55IGxvbmdlci4gSXQncyBub3cgdGhlIHNhbWUgYmVoYXZpb3INCj4+IGFzDQo+
PiB3aXRoIHNpbXBsZWRybS4NCj4+DQo+PiBUaGlzIHdvcmtzIGZvciBtZSB3aXRoIHNpbXBs
ZWZiIGFuZCBlZmlmYiBvbiBpOTE1IGhhcmR3YXJlLg0KPiANCj4gWWVhLCB0aGF0IHdvcmtz
IGZvciBtZSB0b28uIEJvdGggd2l0aCBzaW1wbGVkcm0gYW5kIHNpbXBsZWZiLiBUaGUgcGF0
Y2gNCj4gbG9va3MgZ29vZCB0b28uDQo+IA0KPiBEbyB5b3UgdGhpbmsgeW91J2xsIGJlIGFi
bGUgdG8gZ2V0IHRoaXMgaW4gc3RhYmxlIGtlcm5lbHM/IElmIG5vdCBJJ2xsDQo+IHN0aWxs
IG5lZWQgc29tZXRoaW5nIGZvciB2bXdnZnggdG8gbWFrZSBrZXJuZWxzIGJldHdlZW4gNS4x
NSBhbmQNCj4gd2hlbmV2ZXIgdGhpcyBwYXRjaCBnZXRzIGluIGJvb3Qgd2l0aCBmYi4NCg0K
SSdsbCBwcmVwYXJlIGEgcGF0Y2hzZXQgd2l0aCB0aGVzZSBjaGFuZ2VzLiBUaGUgYWN0dWFs
IGZpeCBpcyB0aGUgY2hhbmdlIA0KdG8gZmJtZW0uYy4gVGhpcyBvbmUgc2hvdWxkIGdvIHRv
IHN0YWJsZSBhbmQgc2hvdWxkIGJlIGVhc3kgdG8gYmFja3BvcnQuIA0KQWxsIHRoZSBvdGhl
ciBwYXRjaGVzIGFyZSBtb3N0bHkgZm9yIGNvcnJlY3RuZXNzIGFuZCBjYW4gZ28gdG8gDQpk
cm0tbWlzYy1uZXh0IG9ubHkuDQoNCkNhbiBJIGFkZCB5b3VyIFRlc3RlZC1ieSB0YWcgdG8g
dGhlIHBhdGNoZXM/DQoNCkJlc3QgcmVnYXJkcw0KVGhvbWFzDQoNCj4gDQo+IHoNCg0KLS0g
DQpUaG9tYXMgWmltbWVybWFubg0KR3JhcGhpY3MgRHJpdmVyIERldmVsb3Blcg0KU1VTRSBT
b2Z0d2FyZSBTb2x1dGlvbnMgR2VybWFueSBHbWJIDQpNYXhmZWxkc3RyLiA1LCA5MDQwOSBO
w7xybmJlcmcsIEdlcm1hbnkNCihIUkIgMzY4MDksIEFHIE7DvHJuYmVyZykNCkdlc2Now6Rm
dHNmw7xocmVyOiBJdm8gVG90ZXYNCg==

--------------Ibl9G10vqptQtp7lyMNoRHxd--

--------------ykSv4ZUIDDse1lbC9Qu2srIW
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmHqclQFAwAAAAAACgkQlh/E3EQov+Br
cQ//fvaUggutff4hikAZRiLKp/xAEvY9HP+/Bp9BxWPs/mjKjEHD0ksu2Udtu7KKXUMbONDh5l1o
ZEzJpIj5USKDkCIN05CU5hUW87fnTfTvgCGAen44/YOyMdXDpxNxWw7CH1GLUTSdZTmSH6IicfFr
kZM2BILbt2BjfSfsNQSLEB/b3VPlyWX8JrLW3/2ST/VGkqiykO2p3HUqn8kbbWZbYtpxa2AKnw2C
5Mkw9VLhykGjyMTkRMe5zFPgPKeqpLvXeOCre2iuuEhtbf7hq1N3H4Unjtupbe807cdbEBxguPKA
1bJU2R4p4EiqcoQ03P3M645KYDsmI/CbwPVybx+ftlfyZnxfRPSSMfC5smSy6l9PWBwGzk2HEgzF
ckPqRe6NJ3XTgp9gFcEZBmRrPRq8b5YjbUlD6a+OOMw8Fkt1T6tPO/pLGOI/pjh9v3x/LiN/mPUk
oJlyjbcz6sGoWwI1OxEGdM36uLo+uHLmCdERn8AXHqqQnQIdX+L0wExTaCHoMs9bqiq7z6tfC7RR
kYkHintGa40HHVxt/qndotmIOdiZ1KTFrxmUNkvwD/nvrQpypjCHjjJ0NB8rtHsbkAl9tc4u3bMD
+mCW4tpQATr3yqf7FcSKBygdhgFX86J+UzApOaKnbW6OGaIKqSRw+NjjPYjag6S55cP1r87iJPIc
7tw=
=jnF0
-----END PGP SIGNATURE-----

--------------ykSv4ZUIDDse1lbC9Qu2srIW--
