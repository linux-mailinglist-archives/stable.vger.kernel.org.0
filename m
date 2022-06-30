Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02037561291
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 08:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbiF3Ghd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 02:37:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbiF3Ghc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 02:37:32 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27A242E683
        for <stable@vger.kernel.org>; Wed, 29 Jun 2022 23:37:31 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 591CD21BCB;
        Thu, 30 Jun 2022 06:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1656571049; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=X0I2vwPRHloEH+OZJCbj7rH+JFn3kpe+m0VMaPEXJIY=;
        b=dG5nHBKffX6Key9LOfL+JKJPxz1vvXySbJs93CrBcpCiWyufGFPGbinJruk0zNhe2eJuYc
        IHoYSBk+K/xriWL9MoteiBR7h0tqtkn2Jh0J3GSYrNg0sPU74JzY+s7DJNu4MS7QOBUdmC
        CEN1WzhBjztj7yotsMek0XEvpUayAeo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1656571049;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=X0I2vwPRHloEH+OZJCbj7rH+JFn3kpe+m0VMaPEXJIY=;
        b=5iiit5fpzY2raCp+/ezh1jm12bUgah/DgH89GKGeLp+tDuerhfc2+eV6iEKbia9YicLL0L
        9OaJZRnTuOFNrrDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 34476139E9;
        Thu, 30 Jun 2022 06:37:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id eteAC6lEvWLhHQAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Thu, 30 Jun 2022 06:37:29 +0000
Message-ID: <09f5fde3-fdec-87be-256c-cf8981d42a7c@suse.de>
Date:   Thu, 30 Jun 2022 08:37:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] drm/fb-helper: Fix out-of-bounds access
Content-Language: en-US
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     airlied@linux.ie,
        =?UTF-8?Q?Nuno_Gon=c3=a7alves?= <nunojpg@gmail.com>,
        javierm@redhat.com, dri-devel@lists.freedesktop.org,
        stable@vger.kernel.org
References: <20220621104617.8817-1-tzimmermann@suse.de>
 <alpine.DEB.2.22.394.2206292006230.319606@ramsan.of.borg>
From:   Thomas Zimmermann <tzimmermann@suse.de>
In-Reply-To: <alpine.DEB.2.22.394.2206292006230.319606@ramsan.of.borg>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------eEFiOL9FnfombVovyZ0E06SJ"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------eEFiOL9FnfombVovyZ0E06SJ
Content-Type: multipart/mixed; boundary="------------VPY83nh1h5aj9VQ133Rw60sx";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: airlied@linux.ie, =?UTF-8?Q?Nuno_Gon=c3=a7alves?= <nunojpg@gmail.com>,
 javierm@redhat.com, dri-devel@lists.freedesktop.org, stable@vger.kernel.org
Message-ID: <09f5fde3-fdec-87be-256c-cf8981d42a7c@suse.de>
Subject: Re: [PATCH] drm/fb-helper: Fix out-of-bounds access
References: <20220621104617.8817-1-tzimmermann@suse.de>
 <alpine.DEB.2.22.394.2206292006230.319606@ramsan.of.borg>
In-Reply-To: <alpine.DEB.2.22.394.2206292006230.319606@ramsan.of.borg>

--------------VPY83nh1h5aj9VQ133Rw60sx
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkNCg0KQW0gMjkuMDYuMjIgdW0gMjA6MTcgc2NocmllYiBHZWVydCBVeXR0ZXJob2V2ZW46
DQo+ICDCoMKgwqDCoEhpIFRob21hcywNCj4gDQo+IE9uIFR1ZSwgMjEgSnVuIDIwMjIsIFRo
b21hcyBaaW1tZXJtYW5uIHdyb3RlOg0KPj4gQ2xpcCBtZW1vcnkgcmFuZ2UgdG8gc2NyZWVu
LWJ1ZmZlciBzaXplIHRvIGF2b2lkIG91dC1vZi1ib3VuZHMgYWNjZXNzDQo+PiBpbiBmYmRl
diBkZWZlcnJlZCBJL08ncyBkYW1hZ2UgaGFuZGxpbmcuDQo+Pg0KPj4gRmJkZXYncyBkZWZl
cnJlZCBJL08gY2FuIG9ubHkgdHJhY2sgcGFnZXMuIEZyb20gdGhlIHJhbmdlIG9mIHBhZ2Vz
LCB0aGUNCj4+IGRhbWFnZSBoYW5kbGVyIGNvbXB1dGVzIHRoZSBjbGlwcGluZyByZWN0YW5n
bGUgZm9yIHRoZSBkaXNwbGF5IHVwZGF0ZS4NCj4+IElmIHRoZSBmYmRldiBzY3JlZW4gYnVm
ZmVyIGVuZHMgbmVhciB0aGUgYmVnaW5uaW5nIG9mIGEgcGFnZSwgdGhhdCBwYWdlDQo+PiBj
b3VsZCBjb250YWluIG1vcmUgc2NhbmxpbmVzLiBUaGUgZGFtYWdlIGhhbmRsZXIgd291bGQg
dGhlbiB0cmFjayB0aGVzZQ0KPj4gbm9uLWV4aXN0aW5nIHNjYW5saW5lcyBhcyBkaXJ0eSBh
bmQgcHJvdm9rZSBhbiBvdXQtb2YtYm91bmRzIGFjY2Vzcw0KPj4gZHVyaW5nIHRoZSBzY3Jl
ZW4gdXBkYXRlLiBIZW5jZSwgY2xpcCB0aGUgbWF4aW11bSBtZW1vcnkgcmFuZ2UgdG8gdGhl
DQo+PiBzaXplIG9mIHRoZSBzY3JlZW4gYnVmZmVyLg0KPj4NCj4+IFdoaWxlIGF0IGl0LCBy
ZW5hbWUgdGhlIHZhcmlhYmxlcyBtaW4vbWF4IHRvIG1pbl9vZmYvbWF4X29mZiBpbg0KPj4g
ZHJtX2ZiX2hlbHBlcl9kZWZlcnJlZF9pbygpLiBUaGlzIGF2b2lkcyBjb25mdXNpb24gd2l0
aCB0aGUgbWFjcm9zIG9mDQo+PiB0aGUgc2FtZSBuYW1lLg0KPj4NCj4+IFJlcG9ydGVkLWJ5
OiBOdW5vIEdvbsOnYWx2ZXMgPG51bm9qcGdAZ21haWwuY29tPg0KPj4gU2lnbmVkLW9mZi1i
eTogVGhvbWFzIFppbW1lcm1hbm4gPHR6aW1tZXJtYW5uQHN1c2UuZGU+DQo+PiBUZXN0ZWQt
Ynk6IE51bm8gR29uw6dhbHZlcyA8bnVub2pwZ0BnbWFpbC5jb20+DQo+PiBGaXhlczogNjdi
NzIzZjViNzQyICgiZHJtL2ZiLWhlbHBlcjogQ2FsY3VsYXRlIGRhbWFnZWQgYXJlYSBpbiAN
Cj4+IHNlcGFyYXRlIGhlbHBlciIpDQo+IA0KPiBUaGFua3MgZm9yIHlvdXIgcGF0Y2gsIHdo
aWNoIGlzIG5vdyBjb21taXQgYWUyNTg4NWJkZjU5ZmRlNA0KPiAoImRybS9mYi1oZWxwZXI6
IEZpeCBvdXQtb2YtYm91bmRzIGFjY2VzcyIpIGluIGRybS1taXNjL2Zvci1saW51eC1uZXh0
Lg0KPiANCj4gSSBoYWQgc2VlbiB0aGUgY3Jhc2ggYmVmb3JlLCBidXQgdGhvdWdodCBpdCB3
YXMgYSBidWcgaW4gbXkgd2lwDQo+IGF0YXJpLWRybSBkcml2ZXIuwqAgV2hlbiBkaXZpbmcg
ZGVlcGVyIHRvZGF5LCBhbmQgY29uc2VxdWVudGx5IGxvb2tpbmcNCj4gZm9yIHJlY2VudCBj
aGFuZ2VzIHRvIHRoZSBkYW1hZ2UgaGVscGVyLCBJIGZvdW5kIHRoaXMgY29tbWl0IGluDQo+
IGxpbnV4LW5leHQuDQo+IA0KPiBXaXRoIHlvdXIgcGF0Y2ggaW5zdGVhZCBvZiBteSBvd24g
d29ya2Fyb3VuZCBJIHVzZWQgdGhpcyBtb3JuaW5nLCBbMV0NCj4gc3RpbGwgd29ya3MgZmlu
ZSwgc286DQo+IFRlc3RlZC1ieTogR2VlcnQgVXl0dGVyaG9ldmVuIDxnZWVydEBsaW51eC1t
NjhrLm9yZz4uDQo+IFJldmlld2VkLWJ5OiBHZWVydCBVeXR0ZXJob2V2ZW4gPGdlZXJ0QGxp
bnV4LW02OGsub3JnPi4NCg0KR3JlYXQgdGhhbmtzIGEgbG90Lg0KDQpCVFcsIHdoYXQncyB0
aGUgc3RhdHVzIG9mIHRoZSBhdGFyaS1kcm0gZHJpdmVyPw0KDQpCZXN0IHJlZ2FyZA0KVGhv
bWFzDQoNCj4gDQo+IFsxXSBbUEFUQ0hdIGRybS9mYi1oZWxwZXI6IFJlbW92ZSBoZWxwZXJz
IHRvIGNoYW5nZSBmcmFtZSBidWZmZXIgY29uZmlnDQo+ICAgICAgDQo+IGh0dHBzOi8vbG9y
ZS5rZXJuZWwub3JnL2FsbC8yMDIyMDYyOTEwNTY1OC4xMzczNzcwLTEtZ2VlcnRAbGludXgt
bTY4ay5vcmcNCj4gDQo+IEdye29ldGplLGVldGluZ31zLA0KPiANCj4gIMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgR2VlcnQNCj4gDQo+IC0tIA0K
PiBHZWVydCBVeXR0ZXJob2V2ZW4gLS0gVGhlcmUncyBsb3RzIG9mIExpbnV4IGJleW9uZCBp
YTMyIC0tIA0KPiBnZWVydEBsaW51eC1tNjhrLm9yZw0KPiANCj4gSW4gcGVyc29uYWwgY29u
dmVyc2F0aW9ucyB3aXRoIHRlY2huaWNhbCBwZW9wbGUsIEkgY2FsbCBteXNlbGYgYSBoYWNr
ZXIuIA0KPiBCdXQNCj4gd2hlbiBJJ20gdGFsa2luZyB0byBqb3VybmFsaXN0cyBJIGp1c3Qg
c2F5ICJwcm9ncmFtbWVyIiBvciBzb21ldGhpbmcgDQo+IGxpa2UgdGhhdC4NCj4gIMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIC0tIExpbnVzIFRvcnZhbGRzDQoNCi0tIA0KVGhvbWFzIFppbW1lcm1hbm4NCkdyYXBo
aWNzIERyaXZlciBEZXZlbG9wZXINClNVU0UgU29mdHdhcmUgU29sdXRpb25zIEdlcm1hbnkg
R21iSA0KTWF4ZmVsZHN0ci4gNSwgOTA0MDkgTsO8cm5iZXJnLCBHZXJtYW55DQooSFJCIDM2
ODA5LCBBRyBOw7xybmJlcmcpDQpHZXNjaMOkZnRzZsO8aHJlcjogSXZvIFRvdGV2DQo=

--------------VPY83nh1h5aj9VQ133Rw60sx--

--------------eEFiOL9FnfombVovyZ0E06SJ
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmK9RKgFAwAAAAAACgkQlh/E3EQov+Bp
IxAAtrgPVOf1D2epGCDdUe0PxXONyHIcm8QfT2qsFUmex3V3CTm2NuNm85ocYLvR/LocPL1q5Vxk
cSclR8UGaaB6FJ8YbYGBAMQam9dpOOK7uEx91HR8c9arpVRRJqP6WKsx0PmmGI8kJHCXw60KHQOY
bbNzAaNBus/B0nB4cFz/z7pEhkYIFY0q3bucsXZnSPt/wCn0smlWO3n3xVvswFx6ucPZ33Jxt8xS
qBD9pwRgBoYNa6VPeolmZbDrlIJCCm+HT8DQx1BdfqRIjQWv1Ah0trQ0Do48MklJZhVXE32LNdQD
Y0D0rDsD9QdwFyFdrLQ58WqwGRLpk7B4hJ8fA0Vj2tiHDFXbTO5y59bF9I0EKYSoKnE4UXdGUOKW
o6p40Sn4uVhS3kgccGU9YbrfjlK60qLJur6zWlVjGl4lFUm3FRDelmi0LJfwOZJGhwzDvOsvBYM6
U6XiOJfQl2ahNrDwN5p+SR11TFYHkwfNu9XwUoV+kYPMVkQuGD+sW5+MSbF+nFgTAVnsY0Sz5SoY
t/HI7QtBhar4vpHcihw3JPTRkUD70KxdEuR4vRzSEOs109B4fSyyxkoEzn4vIcvnY44JsH32hTTH
5beUpF2AVRaN6QrifNptsuDEXy2szQvJAXMh6EMYJZzB9kK38dmbd+r0J8j/2iHClxaIwswrXxIA
zqQ=
=Ijvq
-----END PGP SIGNATURE-----

--------------eEFiOL9FnfombVovyZ0E06SJ--
