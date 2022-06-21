Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBE61553024
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 12:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347505AbiFUKsS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 06:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348535AbiFUKsA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 06:48:00 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7416D260
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 03:47:57 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 3190F219E9;
        Tue, 21 Jun 2022 10:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1655808476; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6xEM+4l3qyc1ty5dJ7ucCSVuzRL7/JMn2oGl6p74emE=;
        b=ON/lEFvQ88hbrzRDHXnGVRWjLR5gRGR3Rd4Ak7/qw68u0ZfC7O+PAyAeor0+EolqM9R85T
        9yA4lBM7CheWh1E67h8Mjd4RV29L6SFJEhFQPCPJjmn0R9Tn5S23DspsU78iDKsh7YSStW
        pkCMiwaiRjuTdrEVlUodcO2NC7WSexA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1655808476;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6xEM+4l3qyc1ty5dJ7ucCSVuzRL7/JMn2oGl6p74emE=;
        b=ZZ8pj4aHVCfFO3iO4sXVt9nWs37a36x3MDQvzK5jGuKUDiH7VnaR9+WorNuM9gBnjAdFqx
        9pzFc94xlt8in9BA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E268713A88;
        Tue, 21 Jun 2022 10:47:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id DVZDNtuhsWLpUgAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Tue, 21 Jun 2022 10:47:55 +0000
Message-ID: <66ca66d2-f400-eb7e-1e8f-ba80c14ec388@suse.de>
Date:   Tue, 21 Jun 2022 12:47:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] drm/fb-helper: Make set_var validation stricter
Content-Language: en-US
From:   Thomas Zimmermann <tzimmermann@suse.de>
To:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        =?UTF-8?Q?Michel_D=c3=a4nzer?= <michel@daenzer.net>
Cc:     security@kernel.org, Daniel Stone <daniels@collabora.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>, stable@vger.kernel.org,
        Helge Deller <deller@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        openeuler-security@openeuler.org, guodaxing@huawei.com,
        Weigang <weigang12@huawei.com>,
        Daniel Vetter <daniel.vetter@intel.com>
References: <20220621092319.379049-1-daniel.vetter@ffwll.ch>
 <303b9f91-9214-5243-8224-a11953960839@suse.de>
 <CAKMK7uHH5Rw=0q-KsO_pZ54mGQAsQuiMLNepn8gviBNeVu4JKg@mail.gmail.com>
 <091e20d5-2658-c166-6d65-261716c57efa@suse.de>
In-Reply-To: <091e20d5-2658-c166-6d65-261716c57efa@suse.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------UUm1ibjH0T4wSIySZzKUGUeD"
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
--------------UUm1ibjH0T4wSIySZzKUGUeD
Content-Type: multipart/mixed; boundary="------------yW9izPz057aLwuc33cSbCcsJ";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, =?UTF-8?Q?Michel_D=c3=a4nzer?=
 <michel@daenzer.net>
Cc: security@kernel.org, Daniel Stone <daniels@collabora.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, stable@vger.kernel.org,
 Helge Deller <deller@gmx.de>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, openeuler-security@openeuler.org,
 guodaxing@huawei.com, Weigang <weigang12@huawei.com>,
 Daniel Vetter <daniel.vetter@intel.com>
Message-ID: <66ca66d2-f400-eb7e-1e8f-ba80c14ec388@suse.de>
Subject: Re: [PATCH] drm/fb-helper: Make set_var validation stricter
References: <20220621092319.379049-1-daniel.vetter@ffwll.ch>
 <303b9f91-9214-5243-8224-a11953960839@suse.de>
 <CAKMK7uHH5Rw=0q-KsO_pZ54mGQAsQuiMLNepn8gviBNeVu4JKg@mail.gmail.com>
 <091e20d5-2658-c166-6d65-261716c57efa@suse.de>
In-Reply-To: <091e20d5-2658-c166-6d65-261716c57efa@suse.de>

--------------yW9izPz057aLwuc33cSbCcsJ
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

DQoNCkFtIDIxLjA2LjIyIHVtIDEyOjMzIHNjaHJpZWIgVGhvbWFzIFppbW1lcm1hbm46DQo+
IEhpDQo+IA0KPiBBbSAyMS4wNi4yMiB1bSAxMjoyMCBzY2hyaWViIERhbmllbCBWZXR0ZXI6
DQo+PiBPbiBUdWUsIDIxIEp1biAyMDIyIGF0IDEyOjE1LCBUaG9tYXMgWmltbWVybWFubiA8
dHppbW1lcm1hbm5Ac3VzZS5kZT4gDQo+PiB3cm90ZToNCj4+Pg0KPj4+IEhpDQo+Pj4NCj4+
PiBBbSAyMS4wNi4yMiB1bSAxMToyMyBzY2hyaWViIERhbmllbCBWZXR0ZXI6DQo+Pj4+IFRo
ZSBkcm0gZmJkZXYgZW11bGF0aW9uIGRvZXMgbm90IGZvcndhcmQgbW9kZSBjaGFuZ2VzIHRv
IHRoZSBkcml2ZXIsDQo+Pj4+IGFuZCBoZW5jZSBhbGwgY2hhbmdlcyB3aGVyZSByZWplY3Rl
ZCBpbiA4NjVhZmIxMTk0OWUgKCJkcm0vZmItaGVscGVyOg0KPj4+PiByZWplY3QgYW55IGNo
YW5nZXMgdG8gdGhlIGZiZGV2IikuDQo+Pj4+DQo+Pj4+IFVuZm9ydHVuYXRlbHkgdGhpcyBy
ZXN1bHRlZCBpbiBidWdzIG9uIG11bHRpcGxlIG1vbml0b3Igc3lzdGVtcyB3aXRoDQo+Pj4+
IGRpZmZlcmVudCByZXNvbHV0aW9ucy4gSW4gdGhhdCBjYXNlIHRoZSBmYmRldiBlbXVsYXRp
b24gY29kZSBzaXplcyB0aGUNCj4+Pj4gdW5kZXJseWluZyBmcmFtZWJ1ZmZlciBmb3IgdGhl
IGxhcmdlc3Qgc2NyZWVuICh3aGljaCBkaWN0YXRlcw0KPj4+PiB4L3lyZXNfdmlydHVhbCks
IGJ1dCBhZGp1c3QgdGhlIGZiZGV2IHgveXJlcyB0byBtYXRjaCB0aGUgc21hbGxlc3QNCj4+
Pj4gcmVzb2x1dGlvbi4gVGhlIGFib3ZlIG1lbnRpb25lZCBwYXRjaCBmYWlsZWQgdG8gcmVh
bGl6ZSB0aGF0LCBhbmQNCj4+Pj4gZXJyb3Jub3VzbHkgdmFsaWRhdGVkIHgveXJlcyBhZ2Fp
bnN0IHRoZSBmYiBkaW1lbnNpb25zLg0KPj4+Pg0KPj4+PiBUaGlzIHdhcyBmaXhlZCBieSBq
dXN0IGRyb3BwaW5nIHRoZSB2YWxpZGF0aW9uIGZvciB0b28gc21hbGwgc2l6ZXMsDQo+Pj4+
IHdoaWNoIHJlc3RvcmVkIHZ0IHN3aXRjaGluZyB3aXRoIDEyZmZlZDk2ZDQzNiAoImRybS9m
Yi1oZWxwZXI6IEFsbG93DQo+Pj4+IHZhci0+eC95cmVzKF92aXJ0dWFsKSA8IGZiLT53aWR0
aC9oZWlnaHQgYWdhaW4iKS4NCj4+Pj4NCj4+Pj4gQnV0IHRoaXMgYWxzbyByZXN0b3JlZCBh
bGwga2luZHMgb2YgdmFsaWRhdGlvbiBpc3N1ZXMgYW5kIHRoZWlyDQo+Pj4+IGZhbGxvdXQg
aW4gdGhlIG5vdG9yaW91c2x5IGJ1Z2d5IGZiY29uIGNvZGUgZm9yIHRvbyBzbWFsbCBzaXpl
cy4gU2luY2UNCj4+Pj4gbm8gb25lIGlzIHZvbHVudGVlcmluZyB0byByZWFsbHkgbWFrZSBm
YmNvbiBhbmQgdmMvdnQgZnVsbHkgcm9idXN0DQo+Pj4+IGFnYWluc3QgdGhlc2UgbWF0aCBp
c3N1ZXMgbWFrZSBzdXJlIHRoaXMgYmFybiBkb29yIGlzIGNsb3NlZCBmb3IgZ29vZA0KPj4+
PiBhZ2Fpbi4NCj4+Pj4NCj4+Pj4gU2luY2UgaXQncyBhIGJpdCB0cmlja3kgdG8gcmVtZW1i
ZXIgdGhlIHgveXJlcyB3ZSBwaWNrZWQgYWNyb3NzIGJvdGgNCj4+Pj4gdGhlIG5ld2VyIGdl
bmVyaWMgZmJkZXYgZW11bGF0aW9uIGFuZCB0aGUgb2xkZXIgY29kZSB3aXRoIG1vcmUgZHJp
dmVyDQo+Pj4+IGludm9sdmVtZW50LCB3ZSBzaW1wbHkgY2hlY2sgdGhhdCBpdCBkb2Vzbid0
IGNoYW5nZS4gVGhpcyByZWxpZXMgb24NCj4+Pj4gZHJtX2ZiX2hlbHBlcl9maWxsX3Zhcigp
IGhhdmluZyBkb25lIHRoaW5ncyBjb3JyZWN0bHksIGFuZCBub3RoaW5nDQo+Pj4+IGhhdmlu
ZyB0cmFtcGxlZCBpdCB5ZXQuDQo+Pj4+DQo+Pj4+IE5vdGUgdGhhdCB0aGlzIGxlYXZlcyBh
bGwgdGhlIG90aGVyIGZiZGV2IGRyaXZlcnMgb3V0IGluIHRoZSByYWluLg0KPj4+PiBHaXZl
biB0aGF0IGRpc3Ryb3MgaGF2ZSBmaW5hbGx5IHN0YXJ0ZWQgdG8gbW92ZSBhd2F5IGZyb20g
dGhvc2UNCj4+Pj4gY29tcGxldGVseSBmb3IgcmVhbCBJIHRoaW5rIHRoYXQncyBnb29kIGVu
b3VnaC4gVGhlIGNvZGUgaXQgc3BhZ2hldHRpDQo+Pj4+IGVub3VnaCB0aGF0IEkgZG8gbm90
IGZlZWwgY29uZmlkZW50IHRvIGV2ZW4gcmV2aWV3IGZpeGVzIGZvciBpdC4NCj4+Pj4NCj4+
Pj4gV2hhdCBtaWdodCBoZWxwIGZiZGV2IGlzIGRvaW5nIHNvbWV0aGluZyBzaW1pbGFyIHRv
IHdoYXQgd2FzIGRvbmUgaW4NCj4+Pj4gYTQ5MTQ1YWNmYjk3ICgiZmJtZW06IGFkZCBtYXJn
aW4gY2hlY2sgdG8gZmJfY2hlY2tfY2FwcygpIikgYW5kIGVuc3VyZQ0KPj4+PiB4L3lyZXNf
dmlydHVhbCBhcmVuJ3QgdG9vIHNtYWxsLCBmb3Igc29tZSB2YWx1ZSBvZiAidG9vIHNtYWxs
Ii4gTWF5YmUNCj4+Pj4gY2hlY2tpbmcgdGhhdCB0aGV5J3JlIGF0IGxlYXN0IHgveXJlcyBt
YWtlcyBzZW5zZT8NCj4+Pj4NCj4+Pj4gRml4ZXM6IDEyZmZlZDk2ZDQzNiAoImRybS9mYi1o
ZWxwZXI6IEFsbG93IHZhci0+eC95cmVzKF92aXJ0dWFsKSA8IA0KPj4+PiBmYi0+d2lkdGgv
aGVpZ2h0IGFnYWluIikNCj4+Pj4gQ2M6IE1pY2hlbCBEw6RuemVyIDxtaWNoZWwuZGFlbnpl
ckBhbWQuY29tPg0KPj4+PiBDYzogRGFuaWVsIFN0b25lIDxkYW5pZWxzQGNvbGxhYm9yYS5j
b20+DQo+Pj4+IENjOiBEYW5pZWwgVmV0dGVyIDxkYW5pZWwudmV0dGVyQGZmd2xsLmNoPg0K
Pj4+PiBDYzogTWFhcnRlbiBMYW5raG9yc3QgPG1hYXJ0ZW4ubGFua2hvcnN0QGxpbnV4Lmlu
dGVsLmNvbT4NCj4+Pj4gQ2M6IE1heGltZSBSaXBhcmQgPG1yaXBhcmRAa2VybmVsLm9yZz4N
Cj4+Pj4gQ2M6IFRob21hcyBaaW1tZXJtYW5uIDx0emltbWVybWFubkBzdXNlLmRlPg0KPj4+
PiBDYzogPHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc+ICMgdjQuMTErDQo+Pj4+IENjOiBIZWxn
ZSBEZWxsZXIgPGRlbGxlckBnbXguZGU+DQo+Pj4+IENjOiBHcmVnIEtyb2FoLUhhcnRtYW4g
PGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPg0KPj4+PiBDYzogb3BlbmV1bGVyLXNlY3Vy
aXR5QG9wZW5ldWxlci5vcmcNCj4+Pj4gQ2M6IGd1b2RheGluZ0BodWF3ZWkuY29tDQo+Pj4+
IENjOiBXZWlnYW5nIChKaW1teSkgPHdlaWdhbmcxMkBodWF3ZWkuY29tPg0KPj4+PiBSZXBv
cnRlZC1ieTogV2VpZ2FuZyAoSmltbXkpIDx3ZWlnYW5nMTJAaHVhd2VpLmNvbT4NCj4+Pj4g
U2lnbmVkLW9mZi1ieTogRGFuaWVsIFZldHRlciA8ZGFuaWVsLnZldHRlckBpbnRlbC5jb20+
DQo+Pj4+IC0tLQ0KPj4+PiBOb3RlOiBXZWlnYW5nIGFza2VkIGZvciB0aGlzIHRvIHN0YXkg
dW5kZXIgZW1iYXJnbyB1bnRpbCBpdCdzIGFsbA0KPj4+PiByZXZpZXcgYW5kIHRlc3RlZC4N
Cj4+Pj4gLURhbmllbA0KPj4+PiAtLS0NCj4+Pj4gwqDCoCBkcml2ZXJzL2dwdS9kcm0vZHJt
X2ZiX2hlbHBlci5jIHwgNCArKy0tDQo+Pj4+IMKgwqAgMSBmaWxlIGNoYW5nZWQsIDIgaW5z
ZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4+Pj4NCj4+Pj4gZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvZ3B1L2RybS9kcm1fZmJfaGVscGVyLmMgDQo+Pj4+IGIvZHJpdmVycy9ncHUvZHJt
L2RybV9mYl9oZWxwZXIuYw0KPj4+PiBpbmRleCA2OTU5OTdhZTJhN2MuLjU2NjRhMTc3YTQw
NCAxMDA2NDQNCj4+Pj4gLS0tIGEvZHJpdmVycy9ncHUvZHJtL2RybV9mYl9oZWxwZXIuYw0K
Pj4+PiArKysgYi9kcml2ZXJzL2dwdS9kcm0vZHJtX2ZiX2hlbHBlci5jDQo+Pj4+IEBAIC0x
MzU1LDggKzEzNTUsOCBAQCBpbnQgZHJtX2ZiX2hlbHBlcl9jaGVja192YXIoc3RydWN0IA0K
Pj4+PiBmYl92YXJfc2NyZWVuaW5mbyAqdmFyLA0KPj4+PiDCoMKgwqDCoMKgwqDCoCAqIHRv
IEtNUywgaGVuY2UgZmFpbCBpZiBkaWZmZXJlbnQgc2V0dGluZ3MgYXJlIHJlcXVlc3RlZC4N
Cj4+Pj4gwqDCoMKgwqDCoMKgwqAgKi8NCj4+Pj4gwqDCoMKgwqDCoMKgIGlmICh2YXItPmJp
dHNfcGVyX3BpeGVsID4gZmItPmZvcm1hdC0+Y3BwWzBdICogOCB8fA0KPj4+PiAtwqDCoMKg
wqDCoMKgwqDCoCB2YXItPnhyZXMgPiBmYi0+d2lkdGggfHwgdmFyLT55cmVzID4gZmItPmhl
aWdodCB8fA0KPj4+PiAtwqDCoMKgwqDCoMKgwqDCoCB2YXItPnhyZXNfdmlydHVhbCA+IGZi
LT53aWR0aCB8fCB2YXItPnlyZXNfdmlydHVhbCA+IA0KPj4+PiBmYi0+aGVpZ2h0KSB7DQo+
Pj4+ICvCoMKgwqDCoMKgwqDCoMKgIHZhci0+eHJlcyAhPSBpbmZvLT52YXIueHJlcyB8fCB2
YXItPnlyZXMgIT0gaW5mby0+dmFyLnlyZXMgfHwNCj4+Pg0KPj4+IFRoaXMgbG9va3MgcmVh
c29uYWJsZS4gV2UgZWZmZWN0aXZlbHkgb25seSBzdXBwb3J0IGEgc2luZ2xlIA0KPj4+IHJl
c29sdXRpb24gaGVyZS4NCj4+Pg0KPj4+PiArwqDCoMKgwqDCoMKgwqDCoCB2YXItPnhyZXNf
dmlydHVhbCAhPSBmYi0+d2lkdGggfHwgdmFyLT55cmVzX3ZpcnR1YWwgIT0gDQo+Pj4+IGZi
LT5oZWlnaHQpIHsNCj4+Pg0KPj4+IEFGQUlVIHRoaXMgY2hhbmdlIHdvdWxkIHJlcXVpcmUg
dGhhdCBhbGwgdXNlcnNwYWNlIGFsd2F5cyB1c2VzIG1heGltdW0NCj4+PiB2YWx1ZXMgZm9y
IHt4cmVzLHlyZXN9X3ZpcnR1YWwuIFNlZW1zIHVucmVhbGlzdGljIHRvIG1lLg0KPj4NCj4+
IFRoZSB0aGluZyBpcywgdGhleSBraW5kYSBoYXZlIHRvLCBiZWNhdXNlIHRoYXQncyBhbHdh
eXMgZ29pbmcgdG8gYmUNCj4+IHRoZSBhY3R1YWxseSB2aXNpYmxlIHBhcnQgOi0pIE90b2gg
SSBndWVzcyB3ZSBjb3VsZCBhbHNvIGFsbG93IHZpcnR1YWwNCj4+IHNpemUgdG8gbWF0Y2gg
dGhlIGZiZGV2IHJlYWwgc2l6ZSwgYnV0IG1heWJlIHRoYXQga2luZCBvZiBzYW5pdHkgY2hl
Y2sNCj4+IHNob3VsZCBiZSBkb25lIGluIGZibWVtLmM/DQo+IA0KPiBJJ20gbm90IHN1cmUg
SSB1bmRlcnN0YW5kLiBJJ2QgZXhwZWN0IHRoYXQgZmJkZXYgdXNlcnNwYWNlIGFsbG9jYXRl
cyANCj4geHJlc192aXJ0dWFsIHRvIGJlIHR3aWNlIHRoZSBzaXplIG9mIHhyZXMuIFNvIGl0
IGNhbiBkbyBkb3VibGUgDQo+IGJ1ZmZlcmluZy4gSW4gbWFueSBjYXNlcyBmYi0+aGVpZ2h0
IHdvdWxkIGJlIGxhcmdlciB0aGFuIHRoYXQuDQoNCkkgbWVhbnQgeXJlcyBhbmQgeXJlc192
aXJ0dWFsIGhlcmUuDQoNCj4gDQo+Pg0KPj4gVGJoIGZvciB0aGVzZSBraW5kIG9mIHRoaW5n
cyBJJ20gbGVhbmluZyB0b3dhcmRzICJsZXQncyB3YWl0IHVudGlsIHdlDQo+PiBnZXQgYSBy
ZWdyZXNzaW9uIHJlcG9ydCIsIHNpbmNlIHRoZXJlJ3Mgc2ltcGx5IHRvbyBtYW55IHJhbmRv
bSBidWdzDQo+IA0KPiBOb3QgdGhhdCBJIGRpc2FncmVlLCBidXQgaW4gdGhpcyBjYXNlIGEg
cmVncmVzc2lvbiByZXBvcnQgc2VlbXMgaW5ldml0YWJsZS4NCj4gDQo+PiBhbGwgb3ZlciBp
biB0aGUgZmJjb24vdmMvdnQgY29kZSB3aGVuIHNvdSBzdGFydCByZXNpemluZyBzdHVmZi4g
U28gSSdtDQo+PiB2ZXJ5IGhlYXZpbHkgbGVhbmluZyB0b3dhcmRzIHJlamVjdGluZyBldmVy
eXRoaW5nIChhbmQgZS5nLiB3ZSBzaG91bGQNCj4+IGhhdmUgZml4ZWQgdGhpcyBhbGwgdXAg
YWxyZWFkeSBpbiAyMDIwIHdoZW4gdGhlIGJ1Z2ZpeCBmb3IgeC95cmVzDQo+PiByZWxhdGVk
IHVuZGVyZmxvd3MgbGFuZGVkIGluIDIwMjAgaW1vKS4NCj4gDQo+IERvIHRoZSBmYmRldiBp
Z3QgdGVzdHMgd29yayB3aXRoIHRoaXMgY2hhbmdlIGlmIG92ZXJhbGxvYyBoYXMgYmVlbiBz
ZXQgDQo+IHRvIG1vcmUgdGhhbiAyMDA/DQo+IA0KPiBCZXN0IHJlZ2FyZHMNCj4gVGhvbWFz
DQo+IA0KPj4gLURhbmllbA0KPj4NCj4+PiBCZXN0IHJlZ2FyZHMNCj4+PiBUaG9tYXMNCj4+
Pg0KPj4+DQo+Pj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZHJtX2RiZ19rbXMo
ZGV2LCAiZmIgcmVxdWVzdGVkIHdpZHRoL2hlaWdodC9icHAgY2FuJ3QgDQo+Pj4+IGZpdCBp
biBjdXJyZW50IGZiICINCj4+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgICJyZXF1ZXN0ICVkeCVkLSVkICh2aXJ0dWFsICVkeCVkKSA+IA0K
Pj4+PiAlZHglZC0lZFxuIiwNCj4+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIHZhci0+eHJlcywgdmFyLT55cmVzLCB2YXItPmJpdHNfcGVy
X3BpeGVsLA0KPj4+DQo+Pj4gLS0gDQo+Pj4gVGhvbWFzIFppbW1lcm1hbm4NCj4+PiBHcmFw
aGljcyBEcml2ZXIgRGV2ZWxvcGVyDQo+Pj4gU1VTRSBTb2Z0d2FyZSBTb2x1dGlvbnMgR2Vy
bWFueSBHbWJIDQo+Pj4gTWF4ZmVsZHN0ci4gNSwgOTA0MDkgTsO8cm5iZXJnLCBHZXJtYW55
DQo+Pj4gKEhSQiAzNjgwOSwgQUcgTsO8cm5iZXJnKQ0KPj4+IEdlc2Now6RmdHNmw7xocmVy
OiBJdm8gVG90ZXYNCj4+DQo+Pg0KPj4NCj4gDQoNCi0tIA0KVGhvbWFzIFppbW1lcm1hbm4N
CkdyYXBoaWNzIERyaXZlciBEZXZlbG9wZXINClNVU0UgU29mdHdhcmUgU29sdXRpb25zIEdl
cm1hbnkgR21iSA0KTWF4ZmVsZHN0ci4gNSwgOTA0MDkgTsO8cm5iZXJnLCBHZXJtYW55DQoo
SFJCIDM2ODA5LCBBRyBOw7xybmJlcmcpDQpHZXNjaMOkZnRzZsO8aHJlcjogSXZvIFRvdGV2
DQo=

--------------yW9izPz057aLwuc33cSbCcsJ--

--------------UUm1ibjH0T4wSIySZzKUGUeD
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmKxodsFAwAAAAAACgkQlh/E3EQov+CI
9A//fw2B3upnMyZZHzTGSeHWkeOKTB0Vbu08lqn1V2w+Z2mCcxIzXhlg8VBYNRqAMmgHdUl5FtBq
avwFNmzEadlhZrTAq/ZEtD6yTaudNVS9huqMHqyGC/99pTfHda0i6tVsdazAsGf1bhcmltFujg8S
XH/orMwePuPut8uDEhwQiINjLFc3BL0iZQsU/Qjq1UKnFuhx5TvGJ8AePVyxeB1b4oHru4ELJi9B
wz4ZXmeeJ8TUjuMRRHqGlG4LpXL2Ydgjh/154e/IQtNj/TDLJv5PkHRIh9VORBK6QU7mRAHWd73Y
DXzyG/CQYh5orVRarRy+SxrSUsvSRyFlk+bQO5EOndJlxxyrtPpExqBnUMJfhAmqB3gBjLen8dVk
v4K7f0u2lFQ6M7bR6qq7IildNwAQQATOD7na1dkY6h3Kx9SIah2uJRxuwqc7LQ4SJz15CSHkziDl
tRmJLJ0QiCuReDden3/JYZuWYFRwcOZZnS8faQ0UghoTtoLbTwmbL++7ubZLcL3P0rG1t0/PsNsb
JulfrKXMG71b04ar9rPpxsP2TUdYa9vz2cBrESq6lL870OAaChRJkTu8gkND39A+WL2zea2m8wYC
RbJFDcM1cw+wX/Yz2Lw6/uBRt7Ve46DacKs7sej14hOvpQwSTqAHR5pASudqdWe5HRBXiqaoHlIS
Vxg=
=4iif
-----END PGP SIGNATURE-----

--------------UUm1ibjH0T4wSIySZzKUGUeD--
