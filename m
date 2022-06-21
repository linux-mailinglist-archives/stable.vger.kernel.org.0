Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D69A3552F88
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 12:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347054AbiFUKQW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 06:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbiFUKQV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 06:16:21 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46435286FE
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 03:16:20 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id DFB7F1F9D1;
        Tue, 21 Jun 2022 10:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1655806578; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u+KcsdCI3prL9eepOMaX2y3fXptKdJL0ky+x/xY2Yfs=;
        b=U308z87yaH4SpCuE0ywNEhrF170rDMAoJu65rUm/OeLIZrFYW/Q/lbzCSts4K+cjSxXlaa
        rhlzlAEHWNcExMIPRm8UYRSj92OsdCGQBDHobGLv8Re4uR8Jc1b5qIoRxAyunEVcHhvUuk
        asYpD4qekiESIgMZ2YZLtkNcK7qEGpU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1655806578;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u+KcsdCI3prL9eepOMaX2y3fXptKdJL0ky+x/xY2Yfs=;
        b=RUGX6j7SSsaFqv/1WWMGc6Vk2AaZra9+1eyOZRgz+bxYSQFUEJtt/FUpLPLJjTvuw7fMJz
        auUqg3brtSXbx6BA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 94D3413638;
        Tue, 21 Jun 2022 10:16:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id JyFGI3KasWKoQgAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Tue, 21 Jun 2022 10:16:18 +0000
Message-ID: <79a9829a-488f-4055-c40f-2e1755ce2ee8@suse.de>
Date:   Tue, 21 Jun 2022 12:16:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] drm/fb-helper: Make set_var validation stricter
Content-Language: en-US
From:   Thomas Zimmermann <tzimmermann@suse.de>
To:     Daniel Vetter <daniel.vetter@ffwll.ch>, security@kernel.org
Cc:     Daniel Stone <daniels@collabora.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>, stable@vger.kernel.org,
        Helge Deller <deller@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        openeuler-security@openeuler.org, guodaxing@huawei.com,
        Weigang <weigang12@huawei.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        =?UTF-8?Q?Michel_D=c3=a4nzer?= <michel@daenzer.net>
References: <20220621092319.379049-1-daniel.vetter@ffwll.ch>
 <303b9f91-9214-5243-8224-a11953960839@suse.de>
In-Reply-To: <303b9f91-9214-5243-8224-a11953960839@suse.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------Hgib6y7FTCubmWGOIqPdRDy6"
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
--------------Hgib6y7FTCubmWGOIqPdRDy6
Content-Type: multipart/mixed; boundary="------------JkPThOh6nJKk0FPxZ5YM5xQ0";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, security@kernel.org
Cc: Daniel Stone <daniels@collabora.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, stable@vger.kernel.org,
 Helge Deller <deller@gmx.de>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, openeuler-security@openeuler.org,
 guodaxing@huawei.com, Weigang <weigang12@huawei.com>,
 Daniel Vetter <daniel.vetter@intel.com>, =?UTF-8?Q?Michel_D=c3=a4nzer?=
 <michel@daenzer.net>
Message-ID: <79a9829a-488f-4055-c40f-2e1755ce2ee8@suse.de>
Subject: Re: [PATCH] drm/fb-helper: Make set_var validation stricter
References: <20220621092319.379049-1-daniel.vetter@ffwll.ch>
 <303b9f91-9214-5243-8224-a11953960839@suse.de>
In-Reply-To: <303b9f91-9214-5243-8224-a11953960839@suse.de>

--------------JkPThOh6nJKk0FPxZ5YM5xQ0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

dXBkYXRlIE1pY2hlbCdzIGFkZHJlc3MNCg0KQW0gMjEuMDYuMjIgdW0gMTI6MTUgc2Nocmll
YiBUaG9tYXMgWmltbWVybWFubjoNCj4gSGkNCj4gDQo+IEFtIDIxLjA2LjIyIHVtIDExOjIz
IHNjaHJpZWIgRGFuaWVsIFZldHRlcjoNCj4+IFRoZSBkcm0gZmJkZXYgZW11bGF0aW9uIGRv
ZXMgbm90IGZvcndhcmQgbW9kZSBjaGFuZ2VzIHRvIHRoZSBkcml2ZXIsDQo+PiBhbmQgaGVu
Y2UgYWxsIGNoYW5nZXMgd2hlcmUgcmVqZWN0ZWQgaW4gODY1YWZiMTE5NDllICgiZHJtL2Zi
LWhlbHBlcjoNCj4+IHJlamVjdCBhbnkgY2hhbmdlcyB0byB0aGUgZmJkZXYiKS4NCj4+DQo+
PiBVbmZvcnR1bmF0ZWx5IHRoaXMgcmVzdWx0ZWQgaW4gYnVncyBvbiBtdWx0aXBsZSBtb25p
dG9yIHN5c3RlbXMgd2l0aA0KPj4gZGlmZmVyZW50IHJlc29sdXRpb25zLiBJbiB0aGF0IGNh
c2UgdGhlIGZiZGV2IGVtdWxhdGlvbiBjb2RlIHNpemVzIHRoZQ0KPj4gdW5kZXJseWluZyBm
cmFtZWJ1ZmZlciBmb3IgdGhlIGxhcmdlc3Qgc2NyZWVuICh3aGljaCBkaWN0YXRlcw0KPj4g
eC95cmVzX3ZpcnR1YWwpLCBidXQgYWRqdXN0IHRoZSBmYmRldiB4L3lyZXMgdG8gbWF0Y2gg
dGhlIHNtYWxsZXN0DQo+PiByZXNvbHV0aW9uLiBUaGUgYWJvdmUgbWVudGlvbmVkIHBhdGNo
IGZhaWxlZCB0byByZWFsaXplIHRoYXQsIGFuZA0KPj4gZXJyb3Jub3VzbHkgdmFsaWRhdGVk
IHgveXJlcyBhZ2FpbnN0IHRoZSBmYiBkaW1lbnNpb25zLg0KPj4NCj4+IFRoaXMgd2FzIGZp
eGVkIGJ5IGp1c3QgZHJvcHBpbmcgdGhlIHZhbGlkYXRpb24gZm9yIHRvbyBzbWFsbCBzaXpl
cywNCj4+IHdoaWNoIHJlc3RvcmVkIHZ0IHN3aXRjaGluZyB3aXRoIDEyZmZlZDk2ZDQzNiAo
ImRybS9mYi1oZWxwZXI6IEFsbG93DQo+PiB2YXItPngveXJlcyhfdmlydHVhbCkgPCBmYi0+
d2lkdGgvaGVpZ2h0IGFnYWluIikuDQo+Pg0KPj4gQnV0IHRoaXMgYWxzbyByZXN0b3JlZCBh
bGwga2luZHMgb2YgdmFsaWRhdGlvbiBpc3N1ZXMgYW5kIHRoZWlyDQo+PiBmYWxsb3V0IGlu
IHRoZSBub3RvcmlvdXNseSBidWdneSBmYmNvbiBjb2RlIGZvciB0b28gc21hbGwgc2l6ZXMu
IFNpbmNlDQo+PiBubyBvbmUgaXMgdm9sdW50ZWVyaW5nIHRvIHJlYWxseSBtYWtlIGZiY29u
IGFuZCB2Yy92dCBmdWxseSByb2J1c3QNCj4+IGFnYWluc3QgdGhlc2UgbWF0aCBpc3N1ZXMg
bWFrZSBzdXJlIHRoaXMgYmFybiBkb29yIGlzIGNsb3NlZCBmb3IgZ29vZA0KPj4gYWdhaW4u
DQo+Pg0KPj4gU2luY2UgaXQncyBhIGJpdCB0cmlja3kgdG8gcmVtZW1iZXIgdGhlIHgveXJl
cyB3ZSBwaWNrZWQgYWNyb3NzIGJvdGgNCj4+IHRoZSBuZXdlciBnZW5lcmljIGZiZGV2IGVt
dWxhdGlvbiBhbmQgdGhlIG9sZGVyIGNvZGUgd2l0aCBtb3JlIGRyaXZlcg0KPj4gaW52b2x2
ZW1lbnQsIHdlIHNpbXBseSBjaGVjayB0aGF0IGl0IGRvZXNuJ3QgY2hhbmdlLiBUaGlzIHJl
bGllcyBvbg0KPj4gZHJtX2ZiX2hlbHBlcl9maWxsX3ZhcigpIGhhdmluZyBkb25lIHRoaW5n
cyBjb3JyZWN0bHksIGFuZCBub3RoaW5nDQo+PiBoYXZpbmcgdHJhbXBsZWQgaXQgeWV0Lg0K
Pj4NCj4+IE5vdGUgdGhhdCB0aGlzIGxlYXZlcyBhbGwgdGhlIG90aGVyIGZiZGV2IGRyaXZl
cnMgb3V0IGluIHRoZSByYWluLg0KPj4gR2l2ZW4gdGhhdCBkaXN0cm9zIGhhdmUgZmluYWxs
eSBzdGFydGVkIHRvIG1vdmUgYXdheSBmcm9tIHRob3NlDQo+PiBjb21wbGV0ZWx5IGZvciBy
ZWFsIEkgdGhpbmsgdGhhdCdzIGdvb2QgZW5vdWdoLiBUaGUgY29kZSBpdCBzcGFnaGV0dGkN
Cj4+IGVub3VnaCB0aGF0IEkgZG8gbm90IGZlZWwgY29uZmlkZW50IHRvIGV2ZW4gcmV2aWV3
IGZpeGVzIGZvciBpdC4NCj4+DQo+PiBXaGF0IG1pZ2h0IGhlbHAgZmJkZXYgaXMgZG9pbmcg
c29tZXRoaW5nIHNpbWlsYXIgdG8gd2hhdCB3YXMgZG9uZSBpbg0KPj4gYTQ5MTQ1YWNmYjk3
ICgiZmJtZW06IGFkZCBtYXJnaW4gY2hlY2sgdG8gZmJfY2hlY2tfY2FwcygpIikgYW5kIGVu
c3VyZQ0KPj4geC95cmVzX3ZpcnR1YWwgYXJlbid0IHRvbyBzbWFsbCwgZm9yIHNvbWUgdmFs
dWUgb2YgInRvbyBzbWFsbCIuIE1heWJlDQo+PiBjaGVja2luZyB0aGF0IHRoZXkncmUgYXQg
bGVhc3QgeC95cmVzIG1ha2VzIHNlbnNlPw0KPj4NCj4+IEZpeGVzOiAxMmZmZWQ5NmQ0MzYg
KCJkcm0vZmItaGVscGVyOiBBbGxvdyB2YXItPngveXJlcyhfdmlydHVhbCkgPCANCj4+IGZi
LT53aWR0aC9oZWlnaHQgYWdhaW4iKQ0KPj4gQ2M6IE1pY2hlbCBEw6RuemVyIDxtaWNoZWwu
ZGFlbnplckBhbWQuY29tPg0KPj4gQ2M6IERhbmllbCBTdG9uZSA8ZGFuaWVsc0Bjb2xsYWJv
cmEuY29tPg0KPj4gQ2M6IERhbmllbCBWZXR0ZXIgPGRhbmllbC52ZXR0ZXJAZmZ3bGwuY2g+
DQo+PiBDYzogTWFhcnRlbiBMYW5raG9yc3QgPG1hYXJ0ZW4ubGFua2hvcnN0QGxpbnV4Lmlu
dGVsLmNvbT4NCj4+IENjOiBNYXhpbWUgUmlwYXJkIDxtcmlwYXJkQGtlcm5lbC5vcmc+DQo+
PiBDYzogVGhvbWFzIFppbW1lcm1hbm4gPHR6aW1tZXJtYW5uQHN1c2UuZGU+DQo+PiBDYzog
PHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc+ICMgdjQuMTErDQo+PiBDYzogSGVsZ2UgRGVsbGVy
IDxkZWxsZXJAZ214LmRlPg0KPj4gQ2M6IEdyZWcgS3JvYWgtSGFydG1hbiA8Z3JlZ2toQGxp
bnV4Zm91bmRhdGlvbi5vcmc+DQo+PiBDYzogb3BlbmV1bGVyLXNlY3VyaXR5QG9wZW5ldWxl
ci5vcmcNCj4+IENjOiBndW9kYXhpbmdAaHVhd2VpLmNvbQ0KPj4gQ2M6IFdlaWdhbmcgKEpp
bW15KSA8d2VpZ2FuZzEyQGh1YXdlaS5jb20+DQo+PiBSZXBvcnRlZC1ieTogV2VpZ2FuZyAo
SmltbXkpIDx3ZWlnYW5nMTJAaHVhd2VpLmNvbT4NCj4+IFNpZ25lZC1vZmYtYnk6IERhbmll
bCBWZXR0ZXIgPGRhbmllbC52ZXR0ZXJAaW50ZWwuY29tPg0KPj4gLS0tDQo+PiBOb3RlOiBX
ZWlnYW5nIGFza2VkIGZvciB0aGlzIHRvIHN0YXkgdW5kZXIgZW1iYXJnbyB1bnRpbCBpdCdz
IGFsbA0KPj4gcmV2aWV3IGFuZCB0ZXN0ZWQuDQo+PiAtRGFuaWVsDQo+PiAtLS0NCj4+IMKg
IGRyaXZlcnMvZ3B1L2RybS9kcm1fZmJfaGVscGVyLmMgfCA0ICsrLS0NCj4+IMKgIDEgZmls
ZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+Pg0KPj4gZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9kcm1fZmJfaGVscGVyLmMgDQo+PiBiL2RyaXZl
cnMvZ3B1L2RybS9kcm1fZmJfaGVscGVyLmMNCj4+IGluZGV4IDY5NTk5N2FlMmE3Yy4uNTY2
NGExNzdhNDA0IDEwMDY0NA0KPj4gLS0tIGEvZHJpdmVycy9ncHUvZHJtL2RybV9mYl9oZWxw
ZXIuYw0KPj4gKysrIGIvZHJpdmVycy9ncHUvZHJtL2RybV9mYl9oZWxwZXIuYw0KPj4gQEAg
LTEzNTUsOCArMTM1NSw4IEBAIGludCBkcm1fZmJfaGVscGVyX2NoZWNrX3ZhcihzdHJ1Y3Qg
DQo+PiBmYl92YXJfc2NyZWVuaW5mbyAqdmFyLA0KPj4gwqDCoMKgwqDCoMKgICogdG8gS01T
LCBoZW5jZSBmYWlsIGlmIGRpZmZlcmVudCBzZXR0aW5ncyBhcmUgcmVxdWVzdGVkLg0KPj4g
wqDCoMKgwqDCoMKgICovDQo+PiDCoMKgwqDCoMKgIGlmICh2YXItPmJpdHNfcGVyX3BpeGVs
ID4gZmItPmZvcm1hdC0+Y3BwWzBdICogOCB8fA0KPj4gLcKgwqDCoMKgwqDCoMKgIHZhci0+
eHJlcyA+IGZiLT53aWR0aCB8fCB2YXItPnlyZXMgPiBmYi0+aGVpZ2h0IHx8DQo+PiAtwqDC
oMKgwqDCoMKgwqAgdmFyLT54cmVzX3ZpcnR1YWwgPiBmYi0+d2lkdGggfHwgdmFyLT55cmVz
X3ZpcnR1YWwgPiANCj4+IGZiLT5oZWlnaHQpIHsNCj4+ICvCoMKgwqDCoMKgwqDCoCB2YXIt
PnhyZXMgIT0gaW5mby0+dmFyLnhyZXMgfHwgdmFyLT55cmVzICE9IGluZm8tPnZhci55cmVz
IHx8DQo+IA0KPiBUaGlzIGxvb2tzIHJlYXNvbmFibGUuIFdlIGVmZmVjdGl2ZWx5IG9ubHkg
c3VwcG9ydCBhIHNpbmdsZSByZXNvbHV0aW9uIA0KPiBoZXJlLg0KPiANCj4+ICvCoMKgwqDC
oMKgwqDCoCB2YXItPnhyZXNfdmlydHVhbCAhPSBmYi0+d2lkdGggfHwgdmFyLT55cmVzX3Zp
cnR1YWwgIT0gDQo+PiBmYi0+aGVpZ2h0KSB7DQo+IA0KPiBBRkFJVSB0aGlzIGNoYW5nZSB3
b3VsZCByZXF1aXJlIHRoYXQgYWxsIHVzZXJzcGFjZSBhbHdheXMgdXNlcyBtYXhpbXVtIA0K
PiB2YWx1ZXMgZm9yIHt4cmVzLHlyZXN9X3ZpcnR1YWwuIFNlZW1zIHVucmVhbGlzdGljIHRv
IG1lLg0KPiANCj4gQmVzdCByZWdhcmRzDQo+IFRob21hcw0KPiANCj4gDQo+PiDCoMKgwqDC
oMKgwqDCoMKgwqAgZHJtX2RiZ19rbXMoZGV2LCAiZmIgcmVxdWVzdGVkIHdpZHRoL2hlaWdo
dC9icHAgY2FuJ3QgZml0IGluIA0KPj4gY3VycmVudCBmYiAiDQo+PiDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgInJlcXVlc3QgJWR4JWQtJWQgKHZpcnR1YWwgJWR4JWQpID4g
JWR4JWQtJWRcbiIsDQo+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdmFyLT54
cmVzLCB2YXItPnlyZXMsIHZhci0+Yml0c19wZXJfcGl4ZWwsDQo+IA0KDQotLSANClRob21h
cyBaaW1tZXJtYW5uDQpHcmFwaGljcyBEcml2ZXIgRGV2ZWxvcGVyDQpTVVNFIFNvZnR3YXJl
IFNvbHV0aW9ucyBHZXJtYW55IEdtYkgNCk1heGZlbGRzdHIuIDUsIDkwNDA5IE7DvHJuYmVy
ZywgR2VybWFueQ0KKEhSQiAzNjgwOSwgQUcgTsO8cm5iZXJnKQ0KR2VzY2jDpGZ0c2bDvGhy
ZXI6IEl2byBUb3Rldg0K

--------------JkPThOh6nJKk0FPxZ5YM5xQ0--

--------------Hgib6y7FTCubmWGOIqPdRDy6
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmKxmnIFAwAAAAAACgkQlh/E3EQov+Dn
IhAAsv2z/EONGKnC0W55S0F7q5zeQbBv1JzbMb1M0gKpwl6MbOZu6lk0w8exemSX5Zpw6i8RcYA4
SqHthEe8PDpYJxLhPqnEdrFnOzxyKgW46oSdROaa5EM5hhdEsPypxnEdfSkYp/GG2NdlSdjHdRAS
OymQm7NKwadXJHZ3bqCoRiBOcqDsov+R3GN5RS1XBCKsngwFxGg2sRzymPdpTgYIcWyqSXAgtgCb
BRnr3xhYgrQwXY/vjYrSWmEbViqB5EtmHXVC6Rqyysk+grRvSylXrVh1pmMD7ggjGX5i6yEBp+pj
vOOueMQlimqQBKlUDMPvwvj47jsntYMMrmK6HM8n3cnvsci8zfVzvlK+vVzMMXBkg43rhBLqfkHR
bii2b9IzmYIQA2IXxp7TdZN1U2dhpmvE0fbI6GdDRaDOTOMSHyrlk8+54CND8YVzTKtnrt8z9zvY
fL+Jb2FBQCEaVgBHGBxubjNT8qz/AZLdHisHHFel5TYqcHz4Ucgm/VVVdrv5YL2y5mx/QzoHVRpv
5tQyqRIH06FkNzcwriMCKZ/CVKT26VUy8D4M158eoA2e28JHsVCCnXA3ChsMeH7MPcj48s3YJf2J
esUw1CXREdku4a4McBYEmN9d6nkkhn0SkZsrBuOE0ocb5yGtNhjtX0CkrIy4TDKwFCVFuTBKstuO
G5c=
=5vCd
-----END PGP SIGNATURE-----

--------------Hgib6y7FTCubmWGOIqPdRDy6--
