Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F40454448B
	for <lists+stable@lfdr.de>; Thu,  9 Jun 2022 09:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237248AbiFIHNa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jun 2022 03:13:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231128AbiFIHNa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jun 2022 03:13:30 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBF052428ED
        for <stable@vger.kernel.org>; Thu,  9 Jun 2022 00:13:28 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 887841FD7F;
        Thu,  9 Jun 2022 07:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1654758806; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=F4F3m3qUD4PJ2g2dytktet4kMrsV3jAcJqPsjVvdwsk=;
        b=fFl+1jSN+9kUlPNJ4gbBCt6xwiNuvr6CVzza3yrlNBEEU2q0I5UmrShJ+n99R38O/f1k3y
        bd7fFdu7fVjiRSBXkRFl1VcvtRo2betC+/BFEaygbJ403HrsxwPc4WkxHv0oWQ9Gk+M3Zo
        y+2Jr/OCAuTgZ/b1sISKOwbF5oE0wX0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1654758806;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=F4F3m3qUD4PJ2g2dytktet4kMrsV3jAcJqPsjVvdwsk=;
        b=N0Sd5/sZmw2vfg/NH7gV0oL+F8oSeDjJGY7JADc+juKfc9jIKMFYswsxvH18zg2oTanztr
        +Cl0oyur/Kfe31Cg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 52D2A13456;
        Thu,  9 Jun 2022 07:13:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id lfdXE5adoWIqLQAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Thu, 09 Jun 2022 07:13:26 +0000
Message-ID: <f29a8c60-7f4e-eb93-feb1-863f82ec8f4f@suse.de>
Date:   Thu, 9 Jun 2022 09:13:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] drm/ast: Treat AST2600 like AST2500 in most places
Content-Language: en-US
To:     Jocelyn Falempe <jfalempe@redhat.com>,
        Kuo-Hsiang Chou <kuohsiang_chou@aspeedtech.com>,
        "airlied@redhat.com" <airlied@redhat.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "daniel@ffwll.ch" <daniel@ffwll.ch>,
        "regressions@leemhuis.info" <regressions@leemhuis.info>
Cc:     "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Luke Chen <luke_chen@aspeedtech.com>,
        Hungju Huang <hungju_huang@aspeedtech.com>,
        Charles Kuan <charles_kuan@aspeedtech.com>
References: <20220607120248.31716-1-tzimmermann@suse.de>
 <PSAPR06MB4805B23B053F80C0F23A8C6C8CA49@PSAPR06MB4805.apcprd06.prod.outlook.com>
 <c99f305f-ac4d-628b-b092-920af767a2e4@redhat.com>
 <PSAPR06MB48051E6CA20163561BAD80298CA79@PSAPR06MB4805.apcprd06.prod.outlook.com>
 <91519070-5c5b-1337-3dab-10decb1b258d@redhat.com>
From:   Thomas Zimmermann <tzimmermann@suse.de>
In-Reply-To: <91519070-5c5b-1337-3dab-10decb1b258d@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------BQvaUHea1HTqdV8BFbs8hZlK"
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------BQvaUHea1HTqdV8BFbs8hZlK
Content-Type: multipart/mixed; boundary="------------e0RZY9tGfnxfmhM7aJTEq7ZF";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: Jocelyn Falempe <jfalempe@redhat.com>,
 Kuo-Hsiang Chou <kuohsiang_chou@aspeedtech.com>,
 "airlied@redhat.com" <airlied@redhat.com>,
 "airlied@linux.ie" <airlied@linux.ie>, "daniel@ffwll.ch" <daniel@ffwll.ch>,
 "regressions@leemhuis.info" <regressions@leemhuis.info>
Cc: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>,
 Luke Chen <luke_chen@aspeedtech.com>,
 Hungju Huang <hungju_huang@aspeedtech.com>,
 Charles Kuan <charles_kuan@aspeedtech.com>
Message-ID: <f29a8c60-7f4e-eb93-feb1-863f82ec8f4f@suse.de>
Subject: Re: [PATCH] drm/ast: Treat AST2600 like AST2500 in most places
References: <20220607120248.31716-1-tzimmermann@suse.de>
 <PSAPR06MB4805B23B053F80C0F23A8C6C8CA49@PSAPR06MB4805.apcprd06.prod.outlook.com>
 <c99f305f-ac4d-628b-b092-920af767a2e4@redhat.com>
 <PSAPR06MB48051E6CA20163561BAD80298CA79@PSAPR06MB4805.apcprd06.prod.outlook.com>
 <91519070-5c5b-1337-3dab-10decb1b258d@redhat.com>
In-Reply-To: <91519070-5c5b-1337-3dab-10decb1b258d@redhat.com>

--------------e0RZY9tGfnxfmhM7aJTEq7ZF
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

DQoNCkFtIDA5LjA2LjIyIHVtIDA5OjA2IHNjaHJpZWIgSm9jZWx5biBGYWxlbXBlOg0KPiBP
biAwOS8wNi8yMDIyIDA0OjMyLCBLdW8tSHNpYW5nIENob3Ugd3JvdGU6DQo+PiBIaSBKb2Nl
bHluIEZhbGVtcGUsDQo+Pg0KPj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4+IEZy
b206IEpvY2VseW4gRmFsZW1wZSBbbWFpbHRvOmpmYWxlbXBlQHJlZGhhdC5jb21dDQo+PiBT
ZW50OiBXZWRuZXNkYXksIEp1bmUgMDgsIDIwMjIgOToxNyBQTQ0KPj4gVG86IEt1by1Ic2lh
bmcgQ2hvdSA8a3VvaHNpYW5nX2Nob3VAYXNwZWVkdGVjaC5jb20+OyBUaG9tYXMgWmltbWVy
bWFubiANCj4+IDx0emltbWVybWFubkBzdXNlLmRlPjsgYWlybGllZEByZWRoYXQuY29tOyBh
aXJsaWVkQGxpbnV4LmllOyANCj4+IGRhbmllbEBmZndsbC5jaDsgcmVncmVzc2lvbnNAbGVl
bWh1aXMuaW5mbw0KPj4gQ2M6IGRyaS1kZXZlbEBsaXN0cy5mcmVlZGVza3RvcC5vcmc7IHN0
YWJsZUB2Z2VyLmtlcm5lbC5vcmc7IEx1a2UgQ2hlbiANCj4+IDxsdWtlX2NoZW5AYXNwZWVk
dGVjaC5jb20+OyBIdW5nanUgSHVhbmcgDQo+PiA8aHVuZ2p1X2h1YW5nQGFzcGVlZHRlY2gu
Y29tPjsgQ2hhcmxlcyBLdWFuIDxjaGFybGVzX2t1YW5AYXNwZWVkdGVjaC5jb20+DQo+PiBT
dWJqZWN0OiBSZTogW1BBVENIXSBkcm0vYXN0OiBUcmVhdCBBU1QyNjAwIGxpa2UgQVNUMjUw
MCBpbiBtb3N0IHBsYWNlcw0KPj4NCj4+IE9uIDA4LzA2LzIwMjIgMTA6MDksIEt1by1Ic2lh
bmcgQ2hvdSB3cm90ZToNCj4+PiBIaSBUaG9tYXMNCj4+Pg0KPj4+IFRoYW5rcyBmb3IgeW91
ciBzdWdnZXN0aW9ucyENCj4+Pg0KPj4+IEkgYW5zd2VyIGVhY2ggcmV2aXNpb24gaW5saW5l
IHRoYXQgZm9sbG93ZWQgYnkgW0tIXTouDQo+Pg0KPj4gVGhhbmtzIGZvciByZXZpZXdpbmcg
dGhpcy4NCj4+Pg0KPj4+IFJlZ2FyZHMsDQo+Pj4NCj4+PiDCoCDCoMKgwqDCoMKgwqDCoCBL
dW8tSHNpYW5nIENob3UNCj4+Pg0KPj4+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+
Pj4NCj4+PiBGcm9tOiBUaG9tYXMgWmltbWVybWFubiBbbWFpbHRvOnR6aW1tZXJtYW5uQHN1
c2UuZGVdDQo+Pj4NCj4+PiBTZW50OiBUdWVzZGF5LCBKdW5lIDA3LCAyMDIyIDg6MDMgUE0N
Cj4+Pg0KPj4+IFRvOiBhaXJsaWVkQHJlZGhhdC5jb207IGFpcmxpZWRAbGludXguaWU7IGRh
bmllbEBmZndsbC5jaDsNCj4+PiBqZmFsZW1wZUByZWRoYXQuY29tOyByZWdyZXNzaW9uc0Bs
ZWVtaHVpcy5pbmZvOyBLdW8tSHNpYW5nIENob3UNCj4+PiA8a3VvaHNpYW5nX2Nob3VAYXNw
ZWVkdGVjaC5jb20+DQo+Pj4NCj4+PiBTdWJqZWN0OiBbUEFUQ0hdIGRybS9hc3Q6IFRyZWF0
IEFTVDI2MDAgbGlrZSBBU1QyNTAwIGluIG1vc3QgcGxhY2VzDQo+Pj4NCj4+PiBJbmNsdWRl
IEFTVDI2MDAgaW4gbW9zdCBvZiB0aGUgYnJhbmNoZXMgZm9yIEFTVDI1MDAuIFRoZXJlYnkg
cmV2ZXJ0DQo+Pj4gbW9zdCBlZmZlY3RzIG9mIGNvbW1pdCBmOWJkMDBlMGVhOWQgKCJkcm0v
YXN0OiBDcmVhdGUgY2hpcCBBU1QyNjAwIikuDQo+Pj4NCj4+PiBUaGUgQVNUMjYwMCB1c2Vk
IHRvIGJlIHRyZWF0ZWQgbGlrZSBhbiBBU1QyNTAwLCB3aGljaCBhdCBsZWFzdCBnYXZlDQo+
Pj4gdXNhYmxlIGRpc3BsYXkgb3V0cHV0LiBBZnRlciBpbnRyb2R1Y2luZyBBU1QyNjAwIGlu
IHRoZSBkcml2ZXIgd2l0aG91dA0KPj4+IGZ1cnRoZXIgdXBkYXRlcywgbG90cyBvZiBmdW5j
dGlvbnMgdGFrZSB0aGUgd3JvbmcgYnJhbmNoZXMuDQo+Pj4NCj4+PiBIYW5kbGluZyBBU1Qy
NjAwIGluIHRoZSBBU1QyNTAwIGJyYW5jaGVzIHJldmVydHMgYmFjayB0byB0aGUgb3JpZ2lu
YWwNCj4+PiBzZXR0aW5ncy4gVGhlIGV4Y2VwdGlvbiBhcmUgY2FzZXMgd2hlcmUgQVNUMjYw
MCBtZWFud2hpbGUgZ290IGl0cyBvd24NCj4+PiBicmFuY2guDQo+Pj4NCj4+PiBbS0hdOiBC
YXNlZCBvbiBDVkVfMjAxOV82MjYwIGl0ZW0zLCBQMkEgaXMgZGlzYWxsb3dlZCBhbnltb3Jl
Lg0KPj4+DQo+Pj4gUDJBIChQQ0llIHRvIEFNQkEpIGlzIGEgYnJpZGdlIHRoYXQgaXMgYWJs
ZSB0byByZXZpc2UgYW55IEJNQyByZWdpc3RlcnMuDQo+Pj4NCj4+PiBZZXMsIFAyQSBpcyBk
YW5nZXJvdXMgb24gc2VjdXJpdHkgaXNzdWUsIGJlY2F1c2UgSG9zdCBvcGVuIGEgYmFja2Rv
b3INCj4+PiBhbmQgc29tZW9uZSBtYWxpY2lvdXMgU1cvQVBQIHdpbGwgYmUgZWFzeSB0byB0
YWtlIGNvbnRyb2wgb2YgQk1DLg0KPj4+DQo+Pj4gVGhlcmVmb3JlLCBQMkEgaXMgZGlzYWJs
ZWQgZm9yZXZlci4NCj4+Pg0KPj4+IE5vdywgcmV0dXJuIHRvIHRoaXMgcGF0Y2gsIHRoZXJl
IGlzIG5vIG5lZWQgdG8gYWRkIEFTVDI2MDAgY29uZGl0aW9uDQo+Pj4gb24gdGhlIFAyQSBm
bG93Lg0KPj4+DQo+Pg0KPj4gW3NuaXBdDQo+Pj4NCj4+PiBbS0hdOiBZZXMsIHRoZSBwYXRj
aCBpcyAiZHJtL2FzdDogQ3JlYXRlIHRocmVzaG9sZCB2YWx1ZXMgZm9yIEFTVDI2MDAiDQo+
Pj4gdGhhdCBpcyB0aGUgcm9vdCBjYXVzZSBvZiB3aGl0ZXMgbGluZXMgb24gQVNUMjYwMA0K
Pj4+DQo+Pj4gY29tbWl0DQo+Pj4NCj4+Pg0KPj4+IGJjYzc3NDExZThhNjU5Mjk2NTVjZWY3
YjYzYTM2MDAwNzI0Y2RjNGINCj4+PiA8aHR0cHM6Ly9jZ2l0LmZyZWVkZXNrdG9wLm9yZy9k
cm0vZHJtL2NvbW1pdC8/aWQ9YmNjNzc0MTFlOGE2NTkyOTY1NWNlDQo+Pj4gZjdiNjNhMzYw
MDA3MjRjZGM0Yj7CoChwYXRjaA0KPj4+IDxodHRwczovL2NnaXQuZnJlZWRlc2t0b3Aub3Jn
L2RybS9kcm0vcGF0Y2gvP2lkPWJjYzc3NDExZThhNjU5Mjk2NTVjZWYNCj4+PiA3YjYzYTM2
MDAwNzI0Y2RjNGI+KQ0KPj4+DQo+Pg0KPj4NCj4+IFNvIGJhc2ljYWxseSB0aGlzIGNvbW1p
dCBzaG91bGQgYmUgZW5vdWdoIHRvIGZpeCB0aGUgd2hpdGUgbGluZXPCoCBhbmQgDQo+PiBm
bGlja2VyaW5nIHdpdGggVkdBIG91dHB1dCBvbiBBU1QyNjAwID8NCj4+IFtLSF06IFllcy4N
Cj4+IMKgwqDCoMKgWW91IGFyZSB3ZWxjb21lIHRvIHRlbGwgbWUgc29tZXRoaW5nIGlmIHlv
dSBjb25zaWRlciB0aGVyZSBpcyANCj4+IG90aGVyIHN0cmFuZ2UgaXNzdWUuDQo+PiDCoMKg
wqDCoFRoYW5rcyBmb3IgeW91ciBlZmZvcnRzIG9uIGRybS9hc3QgcHJvamVjdCENCj4+IFJl
Z2FyZHMsDQo+PiDCoMKgwqDCoEt1by1Ic2lhbmcgQ2hvdQ0KPiANCj4gSSd2ZSBnb3QgY29u
ZmlybWF0aW9uIHRoYXQgdGhpcyBjb21taXQgaXMgZW5vdWdoIHRvIGZpeCB0aGUgaXNzdWUg
DQo+IGludHJvZHVjZWQgd2l0aCBmOWJkMDBlMGVhOWQuDQo+IA0KPiBTbyBsZXQncyBkcm9w
IHRoaXMgcGF0Y2gsIGFuZCBzdWJtaXQgYmNjNzc0MTFlOGE2ICJkcm0vYXN0OiBDcmVhdGUg
DQo+IHRocmVzaG9sZCB2YWx1ZXMgZm9yIEFTVDI2MDAiIHRvIHN0YWJsZSBrZXJuZWwgaW5z
dGVhZC4NCg0KVGhhbmtzIHRvIGJvdGggb2YgeW91IGZvciB5b3VyIGhlbHAgd2l0aCB0aGlz
IGJ1Zy4NCg0KQmVzdCByZWdhcmRzDQpUaG9tYXMNCg0KPiANCj4gVGhhbmtzLA0KPiANCj4+
DQo+PiBJIHdpbGwgdHJ5IHRvIGhhdmUgaXQgdGVzdGVkLCBhbmQgaWYgaXQncyBnb29kLCB3
ZSBtYXkgd2FudCB0byBoYXZlIGl0IA0KPj4gb24gc3RhYmxlIGtlcm5lbC4NCj4+DQo+PiBC
ZXN0IHJlZ2FyZHMsDQo+Pg0KPiANCg0KLS0gDQpUaG9tYXMgWmltbWVybWFubg0KR3JhcGhp
Y3MgRHJpdmVyIERldmVsb3Blcg0KU1VTRSBTb2Z0d2FyZSBTb2x1dGlvbnMgR2VybWFueSBH
bWJIDQpNYXhmZWxkc3RyLiA1LCA5MDQwOSBOw7xybmJlcmcsIEdlcm1hbnkNCihIUkIgMzY4
MDksIEFHIE7DvHJuYmVyZykNCkdlc2Now6RmdHNmw7xocmVyOiBJdm8gVG90ZXYNCg==

--------------e0RZY9tGfnxfmhM7aJTEq7ZF--

--------------BQvaUHea1HTqdV8BFbs8hZlK
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmKhnZUFAwAAAAAACgkQlh/E3EQov+BA
XxAAkUzJhkwaS7PYeIl0ghNG1pXw6Z9D6WegG51ccGevkSJhkAddC3asoBZMpkP5ZqmAwmgwMGea
iZaG0DGaDFCFdkNe5Lmk9Ej/o2RdkS3CniXhNo0Shv9krl3KjqhXJfd8YI5eu5CnRNjN9o7iTfWL
0b0HYBcU8HHwvk+tertq97Z1YqJ5Zefuj62BjDNfBaJNdRm7MPpTVWN0eVyecktNZHPNDGM3tfh9
R2SvttTR4tbvW8JMaUzRdtxi9/tAEeOz4RuisrArpsRlAM/FuvYhuls6fmaQ/g9Z+k/OTlu409wQ
bktl6vieSDG+LnvIe6tPB4RYAjhzq111TvjeT1YKihamA6WXFRjORBhw90CAELQipINeAyCvChSK
VmixlnNiY/k4O2xZikc0gU9KZYNqk1Hh6PSRZB0BBqQU+aXErnX98dGZN/4P1Dpt2bEyDkwEEToe
aoVZbcQoIgLlKA/XZQRhb74p+b3qLSdV25TywmQynR6ByyLeeDY0+HNaRNGHUKpaR08zPAJzTjFA
jR6ydjaou+nh+PFXAv6OaAI1L1UGRLCZuzpsU746q8qTI38PmaE2pnzQ44gdKRgIr8mVVBmO1YyA
05Rp6h8DNA/gqbuDitD4Z29J/TfM4Q1NfDMe+usXMS7RqTO8xH0XpCXLSRbQuBOSc1W0W8g6PjcU
FWo=
=oGKc
-----END PGP SIGNATURE-----

--------------BQvaUHea1HTqdV8BFbs8hZlK--
