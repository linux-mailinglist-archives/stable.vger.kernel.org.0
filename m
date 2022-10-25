Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE0960C806
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 11:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbiJYJ1F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 05:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbiJYJ0p (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 05:26:45 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D29EA598A
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 02:21:59 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B90081FDAE;
        Tue, 25 Oct 2022 09:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1666689717; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TirGP9kehklLrxYyK9tTjQojXB/wauusruIKVlXQuuA=;
        b=f0LP6dUp7Gne0J/p3id+0g9bwbWMEwZ+eY6WPiHu/w/qlJkNjNyn7dGBhWx5g54eVvI+wO
        +copHCPl5P9HYbgI9l6MnpA9352oj4t111Ss2Y9hO4Qe+VtIyiYbLsFMIj9D+9opdG81SC
        ndTLzHhJZSPHEp2+n5JLm201hIgxAgg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1666689717;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TirGP9kehklLrxYyK9tTjQojXB/wauusruIKVlXQuuA=;
        b=lNxYIqBkcdYLjTD/X67beZWOhrIE5Y046yCGpsD/8Ndbzw/ykM239on6XUFGJIMG1xJPHB
        O3Rj8NzVlhclUGBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7C281134CA;
        Tue, 25 Oct 2022 09:21:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 3YiiHLWqV2N6PQAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Tue, 25 Oct 2022 09:21:57 +0000
Message-ID: <2603b160-32cf-d2ae-d218-01e86d3d7ede@suse.de>
Date:   Tue, 25 Oct 2022 11:21:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [Regression] CPU stalls and eventually causes a complete system
 freeze with 6.0.3 due to "video/aperture: Disable and unregister sysfb
 devices via aperture helpers"
Content-Language: en-US
To:     andreas.thalhammer@linux.com, Greg KH <gregkh@linuxfoundation.org>,
        Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     Sasha Levin <sashal@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        ML dri-devel <dri-devel@lists.freedesktop.org>,
        Javier Martinez Canillas <javierm@redhat.com>
References: <bbf7afe7-6ed2-6708-d302-4ba657444c45@leemhuis.info>
 <668a8ffd-ffc7-e1cc-28b4-1caca1bcc3d6@suse.de>
 <958fd763-01b6-0167-ba6b-97cbd3bddcb6@leemhuis.info>
 <Y1Z2sq9RyEnIdixD@kroah.com> <51651c2e-3706-37d7-01e7-5d473a412850@suse.de>
 <70e16994-6f5b-d648-0848-2eb7e3ad641a@gmx.net>
 <ef862938-3e1a-5138-2bda-d10e9188f920@suse.de>
 <95953ffd-32db-62be-bbba-8d4a88cb1ca6@gmx.net>
From:   Thomas Zimmermann <tzimmermann@suse.de>
In-Reply-To: <95953ffd-32db-62be-bbba-8d4a88cb1ca6@gmx.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------HKfU0llQxpwU3Yxt8SYKX0sp"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------HKfU0llQxpwU3Yxt8SYKX0sp
Content-Type: multipart/mixed; boundary="------------awyygws9fDa3XU0KxfBEniii";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: andreas.thalhammer@linux.com, Greg KH <gregkh@linuxfoundation.org>,
 Thorsten Leemhuis <regressions@leemhuis.info>
Cc: Sasha Levin <sashal@kernel.org>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>,
 "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
 ML dri-devel <dri-devel@lists.freedesktop.org>,
 Javier Martinez Canillas <javierm@redhat.com>
Message-ID: <2603b160-32cf-d2ae-d218-01e86d3d7ede@suse.de>
Subject: Re: [Regression] CPU stalls and eventually causes a complete system
 freeze with 6.0.3 due to "video/aperture: Disable and unregister sysfb
 devices via aperture helpers"
References: <bbf7afe7-6ed2-6708-d302-4ba657444c45@leemhuis.info>
 <668a8ffd-ffc7-e1cc-28b4-1caca1bcc3d6@suse.de>
 <958fd763-01b6-0167-ba6b-97cbd3bddcb6@leemhuis.info>
 <Y1Z2sq9RyEnIdixD@kroah.com> <51651c2e-3706-37d7-01e7-5d473a412850@suse.de>
 <70e16994-6f5b-d648-0848-2eb7e3ad641a@gmx.net>
 <ef862938-3e1a-5138-2bda-d10e9188f920@suse.de>
 <95953ffd-32db-62be-bbba-8d4a88cb1ca6@gmx.net>
In-Reply-To: <95953ffd-32db-62be-bbba-8d4a88cb1ca6@gmx.net>

--------------awyygws9fDa3XU0KxfBEniii
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkNCg0KQW0gMjUuMTAuMjIgdW0gMTA6NDUgc2NocmllYiBBbmRyZWFzIFRoYWxoYW1tZXI6
DQpbLi4uXQ0KPj4gWWVhaCwgaXQncyBhbHNvIHBhcnQgb2YgYSBsYXJnZXIgY2hhbmdlc2V0
LiBCdXQgSSB3b3VsZG4ndCB3YW50IHRvDQo+PiBiYWNrcG9ydCBhbGwgdGhvc2UgY2hhbmdl
cyBlaXRoZXIuDQo+Pg0KPj4gQXR0YWNoZWQgaXMgYSBzaW1wbGUgcGF0Y2ggZm9yIGxpbnV4
LXN0YWJsZSB0aGF0IGFkZHMgdGhlIG5lY2Vzc2FyeSBmaXguDQo+PiBJZiB0aGlzIHN0aWxs
IGRvZXNuJ3Qgd29yaywgd2Ugc2hvdWxkIHByb2JhYmx5IHJldmVydCB0aGUgcHJvYmxlbWF0
aWMNCj4+IHBhdGNoLg0KPj4NCj4+IFBsZWFzZSB0ZXN0IHRoZSBwYXRjaCBhbmQgbGV0IG1l
IGtub3cgaWYgaXQgd29ya3MuDQo+IA0KPiANCj4gWWVzLCB0aGlzIGZpeGVkIHRoZSBwcm9i
bGVtLiBJJ20gcnVubmluZyA2LjAuMyB3aXRoIHlvdXIgcGF0Y2ggbm93LCBhbGwNCj4gZmlu
ZS4NCg0KVGhhbmtzIGEgbG90IGZvciB0ZXN0aW5nLiBJZiBHcmVnIGRvZXNuJ3QgYWxyZWFk
eSBwaWNrIHVwIHRoZSBwYXRjaCBmcm9tIA0KdGhpcyBkaXNjdXNzaW9uLCBJJ2xsIHNlbmQg
aXQgdG8gc3RhYmxlIHNvb25pc2g7IGFkZGluZyB5b3VyIFRlc3RlZC1ieSB0YWcuDQoNCkJl
c3QgcmVnYXJkcw0KVGhvbWFzDQoNCj4gDQo+IFRoYW5rcyENCj4gQW5kcmVhcw0KPiANCj4+
DQo+PiBCZXN0IHJlZ2FyZHMNCj4+IFRob21hcw0KPj4NCj4+Pg0KPj4+IEkgZG9uJ3QgdXNl
IGdpdCBhbmQgSSBkb24ndCBrbm93IGhvdyB0byAvY2hlcnJ5LXBpY2sgY29tbWl0Lw0KPj4+
IDlkNjllZjE4MzgxNSwgYnV0IEkgZm91bmQgdGhlIHBhdGNoIGhlcmU6DQo+Pj4gaHR0cHM6
Ly9wYXRjaHdvcmsuZnJlZWRlc2t0b3Aub3JnL3BhdGNoLzQ5NDYwOS8NCj4+Pg0KPj4+IEkg
aG9wZSB0aGF0J3MgdGhlIHJpZ2h0IG9uZS4gSSByZWludGVncmF0ZWQNCj4+PiB2Mi0wNy0x
MS12aWRlby1hcGVydHVyZS1EaXNhYmxlLWFuZC11bnJlZ2lzdGVyLXN5c2ZiLWRldmljZXMt
dmlhLWFwZXJ0dXJlLWhlbHBlcnMucGF0Y2gNCj4+PiBhbmQgYWxzbyBhcHBsaWVkDQo+Pj4g
djItMDQtMTEtZmJkZXYtY29yZS1SZW1vdmUtcmVtb3ZlX2NvbmZsaWN0aW5nX3BjaV9mcmFt
ZWJ1ZmZlcnMucGF0Y2gsDQo+Pj4gZGlkIGEgIm1ha2UgbXJwcm9wZXIiIGFuZCB0aGVyZWFm
dGVyIGNvbXBpbGVkIGEgY2xlYW4gbmV3IDYuMC4zIGtlcm5lbA0KPj4+IChzYW1lIC5jb25m
aWcpLg0KPj4+DQo+Pj4gTm93IHRoZSBzeXN0ZW0gZG9lc24ndCBldmVuIGJvb3QgdG8gYSBj
b25zb2xlLiBUaGUgZmlyc3QgYm9vdCBnb3QgbWUgdG8NCj4+PiBhIHJjdV9zaGVkIHN0YWxs
IG9uIENQVXMvdGFza3MsIHNhbWUgYXMgYWJvdmUsIGJ1dCB0aGlzIHRpbWUgd2l0aDoNCj4+
PiBXb3JrcXVldWU6IGJ0cmZzLWNhY2hlIGJ0cmZzX3dvcmtfaGVscGVyDQo+Pj4NCj4+PiBJ
IGJvb3RlZCBhIHNlY29uZCB0aW1lIHdpdGggdGhlIHNhbWUga2VybmVsLCBhbmQgaXQgZ290
IHN0dWNrIGFmdGVyDQo+Pj4gbW91bnRpbmcgdGhlIHJvb3QgYnRyZnMgZmlsZXN5c3RlbSAo
d2hhdCBsb29rZWQgbGlrZSBhIHRvdGFsIGZyZWV6ZSwgYnV0DQo+Pj4gd2hlbiBpdCBkaWRu
J3Qgc2hvdyBhIHJjdV9zdGFsbCBtZXNzYWdlIGFmdGVyIH4yIG1pbiBJIGdvdCBpbXBhdGll
bnQgYW5kDQo+Pj4gd2FudGVkIHRvIHNlZSBpZiBJIGhhZCBqdXN0IGJ1c3RlZCBteSByb290
IGZpbGVzeXN0ZW0uLi4pDQo+Pj4NCj4+PiBJIGJvb3RlZCA2LjAuMiBhbmQgZXZlcnl0aGlu
ZyBpcyBmaW5lLiAoSSdtIHZlcnkgZ2xhZCEgSSBkZWZpbml0ZWx5DQo+Pj4gc2hvdWxkIHVw
ZGF0ZSBteSBiYWNrdXAgcmlnaHQgYXdheSEpDQo+Pj4NCj4+PiBJIHdpbGwgdHJ5IDYuMS1y
YzEgbmV4dCwgYmVhciB3aXRoLi4uDQo+Pj4NCj4+DQo+IA0KDQotLSANClRob21hcyBaaW1t
ZXJtYW5uDQpHcmFwaGljcyBEcml2ZXIgRGV2ZWxvcGVyDQpTVVNFIFNvZnR3YXJlIFNvbHV0
aW9ucyBHZXJtYW55IEdtYkgNCk1heGZlbGRzdHIuIDUsIDkwNDA5IE7DvHJuYmVyZywgR2Vy
bWFueQ0KKEhSQiAzNjgwOSwgQUcgTsO8cm5iZXJnKQ0KR2VzY2jDpGZ0c2bDvGhyZXI6IEl2
byBUb3Rldg0K

--------------awyygws9fDa3XU0KxfBEniii--

--------------HKfU0llQxpwU3Yxt8SYKX0sp
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmNXqrUFAwAAAAAACgkQlh/E3EQov+AY
uA//bN9y2WwRu+QdCgAltnp15GPLaEQJnEuYby+8fUgduAsxT9GG0tupViuz2h9I5EqNNVLpRXD0
M18P5YiCuCJH/8Kb4rAa812iJPTpjq29LH+s10EdsT9o6OtbOwxV+kNM/qQ7Hto76KNuqJ7SCPUa
CjyMSkZjPSF8I5V5QXeHG2KZlPeJkjqL8n/eEsvlCj5qAFECA7xrmlejTp4+0Kt8QiUdCoxthIZr
gbYythW8Ne4KtDUoOUJXuHe2pCCBHlHUFrJzSwI4w3P4QxFH+RW3bN+1vH2Vg6ANLeAoN8ql18fr
Bl6EgwTgTPzodKzv3saOXGhqCpzFtBumnXEGRp3PC7TpzdWyzorLt4U09sGYuDp4gyYQ2cE+DurV
NPvc2b4XyxiWRvdkte5FKE+InuznzwPjOoQLcL7SbpCk6SZaTEXO4l3rhTYdxPJqigv1IIXkzLeC
QJx28iWbs+/APr3+2WP1h6jG0tOZ9WZCrCXL5+AiaGYKW2anI0Vk8GhgJV2Mio3Y9cMLV2dwHAwj
/d3tvs0fXBoZbClBA20ZP1DgcsW5PP1lOIR48IcgT6XaZ/qhoxxsgvkRyewcHx7Aju6+W9EQdLSW
MHpY5bQ0UabQWZnjEQasBko7VliqPx+xkeOyqZSydddSPbQUGRIE77pVuXcdhr2n/4uj60xaR0JX
bUA=
=6xYf
-----END PGP SIGNATURE-----

--------------HKfU0llQxpwU3Yxt8SYKX0sp--
