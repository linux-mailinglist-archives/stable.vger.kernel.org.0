Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0DD6D6599
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 16:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbjDDOlo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 10:41:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjDDOln (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 10:41:43 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E2110E6
        for <stable@vger.kernel.org>; Tue,  4 Apr 2023 07:41:40 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 5DDA021E5E;
        Tue,  4 Apr 2023 14:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1680619299; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dbkovA1Hg9thUry/IqOrol/J/XThZU1GYZerhs3gEcc=;
        b=rbS/UULleE4Lffl+4QxWxUAGYeX0eo5Hx6BOOGBPRfA9JPMhDcNuOvXkkqniwXNiIxuP9R
        GFL1+bVhE76GSjQc4YCDKWEKEQpx+sK1kq5rVM4T1OTJ3EkIvePhKqGkS4lR0dQ3aaZ8Sw
        pzbr55FY2mwZLRDICf0vH2tg746kuRQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1680619299;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dbkovA1Hg9thUry/IqOrol/J/XThZU1GYZerhs3gEcc=;
        b=ROYvtd81j1v9vBlspKe5v7PYg8IouxxiDEcJ01TBXlpsBL7qTshjrXLUy88k0+orTUg6cs
        PzT1+IXQMUulpSBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2453E13920;
        Tue,  4 Apr 2023 14:41:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id nsrqByM3LGTIbAAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Tue, 04 Apr 2023 14:41:39 +0000
Message-ID: <fab035dd-6276-5343-7422-69969afb8006@suse.de>
Date:   Tue, 4 Apr 2023 16:41:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH] fbdev: Don't spam dmesg on bad userspace ioctl input
Content-Language: en-US
To:     Daniel Vetter <daniel@ffwll.ch>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Rodrigo Siqueira <rodrigosiqueiramelo@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Helge Deller <deller@gmx.de>,
        syzbot+20dcf81733d43ddff661@syzkaller.appspotmail.com,
        Javier Martinez Canillas <javierm@redhat.com>,
        stable@vger.kernel.org, Melissa Wen <melissa.srw@gmail.com>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@intel.com>
References: <20230404123624.360384-1-daniel.vetter@ffwll.ch>
 <CAMuHMdUR=rx2QPvpzsSCwXTSTsPQOudNMzyL3dtZGQdQfrQGDA@mail.gmail.com>
 <ZCwtMJEAJiId/TJe@phenom.ffwll.local> <ZCwx+2hAmyDqOfWu@phenom.ffwll.local>
From:   Thomas Zimmermann <tzimmermann@suse.de>
In-Reply-To: <ZCwx+2hAmyDqOfWu@phenom.ffwll.local>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------FOUOaVAdBeoc4kG6Y0QrJ023"
X-Spam-Status: No, score=-4.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------FOUOaVAdBeoc4kG6Y0QrJ023
Content-Type: multipart/mixed; boundary="------------L07aBmLc0ndjB40qAv00Y19v";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: Daniel Vetter <daniel@ffwll.ch>, Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Rodrigo Siqueira <rodrigosiqueiramelo@gmail.com>,
 Daniel Vetter <daniel.vetter@ffwll.ch>, Helge Deller <deller@gmx.de>,
 syzbot+20dcf81733d43ddff661@syzkaller.appspotmail.com,
 Javier Martinez Canillas <javierm@redhat.com>, stable@vger.kernel.org,
 Melissa Wen <melissa.srw@gmail.com>,
 DRI Development <dri-devel@lists.freedesktop.org>,
 Daniel Vetter <daniel.vetter@intel.com>
Message-ID: <fab035dd-6276-5343-7422-69969afb8006@suse.de>
Subject: Re: [PATCH] fbdev: Don't spam dmesg on bad userspace ioctl input
References: <20230404123624.360384-1-daniel.vetter@ffwll.ch>
 <CAMuHMdUR=rx2QPvpzsSCwXTSTsPQOudNMzyL3dtZGQdQfrQGDA@mail.gmail.com>
 <ZCwtMJEAJiId/TJe@phenom.ffwll.local> <ZCwx+2hAmyDqOfWu@phenom.ffwll.local>
In-Reply-To: <ZCwx+2hAmyDqOfWu@phenom.ffwll.local>

--------------L07aBmLc0ndjB40qAv00Y19v
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkNCg0KQW0gMDQuMDQuMjMgdW0gMTY6MTkgc2NocmllYiBEYW5pZWwgVmV0dGVyOg0KPiBP
biBUdWUsIEFwciAwNCwgMjAyMyBhdCAwMzo1OToxMlBNICswMjAwLCBEYW5pZWwgVmV0dGVy
IHdyb3RlOg0KPj4gT24gVHVlLCBBcHIgMDQsIDIwMjMgYXQgMDM6NTM6MDlQTSArMDIwMCwg
R2VlcnQgVXl0dGVyaG9ldmVuIHdyb3RlOg0KPj4+IEhpIERhbmllbCwNCj4+Pg0KPj4+IEND
IHZrbXNkcm0gbWFpbnRhaW5lcg0KPj4+DQo+Pj4gVGhhbmtzIGZvciB5b3VyIHBhdGNoIQ0K
Pj4+DQo+Pj4gT24gVHVlLCBBcHIgNCwgMjAyMyBhdCAyOjM24oCvUE0gRGFuaWVsIFZldHRl
ciA8ZGFuaWVsLnZldHRlckBmZndsbC5jaD4gd3JvdGU6DQo+Pj4+IFRoZXJlJ3MgYSBmZXcg
cmVhc29ucyB0aGUga2VybmVsIHNob3VsZCBub3Qgc3BhbSBkbWVzZyBvbiBiYWQNCj4+Pj4g
dXNlcnNwYWNlIGlvY3RsIGlucHV0Og0KPj4+PiAtIGF0IHdhcm5pbmcgbGV2ZWwgaXQgcmVz
dWx0cyBpbiBDSSBmYWxzZSBwb3NpdGl2ZXMNCj4+Pj4gLSBpdCBhbGxvd3MgdXNlcnNwYWNl
IHRvIGRyb3duIGRtZXNnIG91dHB1dCwgcG90ZW50aWFsbHkgaGlkaW5nIHJlYWwNCj4+Pj4g
ICAgaXNzdWVzLg0KPj4+Pg0KPj4+PiBOb25lIG9mIHRoZSBvdGhlciBnZW5lcmljIEVJTlZB
TCBjaGVja3MgcmVwb3J0IGluIHRoZQ0KPj4+PiBGQklPUFVUX1ZTQ1JFRU5JTkZPIGlvY3Rs
IGRvIHRoaXMsIHNvIGl0J3MgYWxzbyBpbmNvbnNpc3RlbnQuDQo+Pj4+DQo+Pj4+IEkgZ3Vl
c3MgdGhlIGludGVudCBvZiB0aGUgcGF0Y2ggd2hpY2ggaW50cm9kdWNlZCB0aGlzIHdhcm5p
bmcgd2FzIHRoYXQNCj4+Pj4gdGhlIGRyaXZlcnMgLT5mYl9jaGVja192YXIgcm91dGluZSBz
aG91bGQgZmFpbCBpbiB0aGF0IGNhc2UuIFJlYWxpdHkNCj4+Pj4gaXMgdGhhdCB0aGVyZSdz
IHRvbyBtYW55IGZiZGV2IGRyaXZlcnMgYW5kIG5vdCBlbm91Z2ggcGVvcGxlDQo+Pj4+IG1h
aW50YWluaW5nIHRoZW0gYnkgZmFyLCBhbmQgc28gb3ZlciB0aGUgcGFzdCBmZXcgeWVhcnMg
d2UndmUgc2ltcGx5DQo+Pj4+IGhhbmRsZWQgYWxsIHRoZXNlIHZhbGlkYXRpb24gZ2FwcyBi
eSB0aWdobmluZyB0aGUgY2hlY2tzIGluIHRoZSBjb3JlLA0KPj4+PiBiZWNhdXNlIHRoYXQn
cyByZWFsaXN0aWNhbGx5IHJlYWxseSBhbGwgdGhhdCB3aWxsIGV2ZXIgaGFwcGVuLg0KPj4+
Pg0KPj4+PiBSZXBvcnRlZC1ieTogc3l6Ym90KzIwZGNmODE3MzNkNDNkZGZmNjYxQHN5emth
bGxlci5hcHBzcG90bWFpbC5jb20NCj4+Pj4gTGluazogaHR0cHM6Ly9zeXprYWxsZXIuYXBw
c3BvdC5jb20vYnVnP2lkPWM1ZmFmOTgzYmZhNGE2MDdkZTUzMGNkM2JiMDA4ODg4YmYwNmNl
ZmMNCj4+Pg0KPj4+ICAgICAgV0FSTklORzogZmJjb246IERyaXZlciAndmttc2RybWZiJyBt
aXNzZWQgdG8gYWRqdXN0IHZpcnR1YWwgc2NyZWVuDQo+Pj4gc2l6ZSAoMHgwIHZzLiA2NHg3
NjgpDQo+Pj4NCj4+PiBUaGlzIGlzIGEgYnVnIGluIHRoZSB2a21zZHJtZmIgZHJpdmVyIGFu
ZC9vciBEUk0gaGVscGVycy4NCj4+Pg0KPj4+IFRoZSBtZXNzYWdlIHdhcyBhZGRlZCB0byBt
YWtlIHN1cmUgdGhlIGluZGl2aWR1YWwgZHJpdmVycyBhcmUgZml4ZWQuDQo+Pj4gUGVyaGFw
cyBpdCBzaG91bGQgYmUgY2hhbmdlZCB0byBCVUcoKSBpbnN0ZWFkLCBzbyBkbWVzZyBvdXRw
dXQNCj4+PiBjYW5ub3QgYmUgZHJvd24/DQo+Pg0KPj4gU28geW91J3JlIHNvbHV0aW9uIGlz
IHRvIGVzc2VudGlhbGx5IGZvcmNlIHVzIHRvIHJlcGxpY2F0ZSB0aGlzIGNoZWNrIG92ZXIN
Cj4+IGFsbCB0aGUgZHJpdmVycyB3aGljaCBjYW5ub3QgY2hhbmdlIHRoZSB2aXJ0dWFsIHNp
emU/DQo+Pg0KPj4gQXJlIHlvdSB2b2x1bnRlZXJpbmcgdG8gZmllbGQgdGhhdCBhdWRpdCBh
bmQgdHlwZSBhbGwgdGhlIHBhdGNoZXM/DQo+IA0KPiBOb3RlIHRoYXQgYXQgbGVhc3QgZWZp
ZmIsIHZlc2FmYiBhbmQgb2ZmYiBzZWVtIHRvIGdldCB0aGlzIHdyb25nLiBJIGRpZG4ndA0K
PiBib3RoZXIgY2hlY2tpbmcgYW55IG9mIHRoZSBub24tZncgZHJpdmVycy4gSW93IHRoZXJl
IGlzIGEgX2xvdF8gb2Ygd29yayBpbg0KPiB5b3VyIG5hY2suDQoNCkFzIG1vc3Qgb2YgdXMg
cmVhbGx5IG9ubHkgY2FyZSBhYm91dCBEUk0sIHdlIGNhbiBhZGQgdGhpcyB0ZXN0IHRvIA0K
ZHJtX2ZiX2hlbHBlcl9jaGVja192YXIoKSBbMV0gYW5kIHRoYXQncyBpdC4gTm8gbmVlZCB0
byBmaXggYWxsIG9mIHRoZSANCmZiZGV2IGRyaXZlcnMuDQoNCkhhdmluZyBzYWlkIHRoYXQs
IEkgdGhpbmsgdGhlIGZldyByZW1haW5pbmcgZmJkZXYgZGV2cyBzaG91bGQgZGVjaWRlIGlm
IA0KdGhleSB3YW50IHRvIGFjdHVhbGx5IHB1dCBlZmZvcnQgaW50byBmYmRldiwgb3IgYWNj
ZXB0IGl0IHRvIGJpdHJvdCANCmF3YXkuIFRoZSBjdXJyZW50IHN0YXRlIG9mICdub24tbWFp
bnRlbmFuY2UnIGlzIHRoZSB3b3JzdCBzaXR1YXRpb24uIA0KSSd2ZSBiZWVuIHdvcmtpbmcg
b24gdGhlIGNvbnNvbGUgZW11bGF0aW9uIGFuZCBpdCBpcyBoYXJkIHRvIGdldCANCnF1YWxp
ZmllZCByZXZpZXdzIG9mIHRoZSByZWxhdGVkIGZiZGV2IGNvZGUuIEF0IHRoZSBzYW1lIHRp
bWUsIGl0J3MgYWxzbyANCm5vdCBwb3NzaWJsZSB0byBnZXQgQWNrLWJ5cyBydWJiZXItc3Rh
bXBlZC4NCg0KQmVzdCByZWdhcmRzDQpUaG9tYXMNCg0KWzFdIA0KaHR0cHM6Ly9lbGl4aXIu
Ym9vdGxpbi5jb20vbGludXgvbGF0ZXN0L3NvdXJjZS9kcml2ZXJzL2dwdS9kcm0vZHJtX2Zi
X2hlbHBlci5jI0wxNTE0DQoNCj4gLURhbmllbA0KPiANCj4+Pj4gRml4ZXM6IDZjMTFkZjU4
ZmQxYSAoImZibWVtOiBDaGVjayB2aXJ0dWFsIHNjcmVlbiBzaXplcyBpbiBmYl9zZXRfdmFy
KCkiKQ0KPj4+PiBDYzogSGVsZ2UgRGVsbGVyIDxkZWxsZXJAZ214LmRlPg0KPj4+PiBDYzog
R2VlcnQgVXl0dGVyaG9ldmVuIDxnZWVydEBsaW51eC1tNjhrLm9yZz4NCj4+Pj4gQ2M6IHN0
YWJsZUB2Z2VyLmtlcm5lbC5vcmcgIyB2NS40Kw0KPj4+PiBDYzogRGFuaWVsIFZldHRlciA8
ZGFuaWVsQGZmd2xsLmNoPg0KPj4+PiBDYzogSmF2aWVyIE1hcnRpbmV6IENhbmlsbGFzIDxq
YXZpZXJtQHJlZGhhdC5jb20+DQo+Pj4+IENjOiBUaG9tYXMgWmltbWVybWFubiA8dHppbW1l
cm1hbm5Ac3VzZS5kZT4NCj4+Pj4gU2lnbmVkLW9mZi1ieTogRGFuaWVsIFZldHRlciA8ZGFu
aWVsLnZldHRlckBpbnRlbC5jb20+DQo+Pj4NCj4+PiBOQUtlZC1ieTogR2VlcnQgVXl0dGVy
aG9ldmVuIDxnZWVydEBsaW51eC1tNjhrLm9yZz4NCj4+DQo+PiBZZXMgSSBrbm93IGl0J3Mg
bm90IHByZXR0eSwgYnV0IHJlYWxpc3RpY2FsbHkgdW5sZXNzIHNvbWVvbmUgc3RhcnRzIHR5
cGluZw0KPj4gYSBfbG90XyBvZiBwYXRjaGVzIHRoaXMgaXMgdGhlIHNvbHV0aW9uLiBJdCdz
IGV4YWN0bHkgdGhlIHNhbWUgc29sdXRpb24NCj4+IHdlJ3ZlIGltcGxlbWVudGVkIGZvciBh
bGwgb3RoZXIgZ2FwcyBzeXpjYWxsZXIgaGFzIGZpbmQgaW4gZmJkZXYgaW5wdXQNCj4+IHZh
bGlkYXRpb24uIFVubGVzcyB5b3UgY2FuIHNob3cgdGhhdCB0aGlzIGlzIHBhcGVyaW5nIG92
ZXIgYSBtb3JlIHNldmVyZQ0KPj4gYnVnIHNvbWV3aGVyZSwgYnV0IHRoZW4gSSBndWVzcyBp
dCByZWFsbHkgc2hvdWxkIGJlIGEgQlVHIHRvIHByZXZlbnQgd29yc2UNCj4+IHRoaW5ncyBm
cm9tIGhhcHBlbmluZy4NCj4+IC1EYW5pZWwNCj4+DQo+Pj4NCj4+Pj4gLS0tIGEvZHJpdmVy
cy92aWRlby9mYmRldi9jb3JlL2ZibWVtLmMNCj4+Pj4gKysrIGIvZHJpdmVycy92aWRlby9m
YmRldi9jb3JlL2ZibWVtLmMNCj4+Pj4gQEAgLTEwMjEsMTAgKzEwMjEsNiBAQCBmYl9zZXRf
dmFyKHN0cnVjdCBmYl9pbmZvICppbmZvLCBzdHJ1Y3QgZmJfdmFyX3NjcmVlbmluZm8gKnZh
cikNCj4+Pj4gICAgICAgICAgLyogdmVyaWZ5IHRoYXQgdmlydHVhbCByZXNvbHV0aW9uID49
IHBoeXNpY2FsIHJlc29sdXRpb24gKi8NCj4+Pj4gICAgICAgICAgaWYgKHZhci0+eHJlc192
aXJ0dWFsIDwgdmFyLT54cmVzIHx8DQo+Pj4+ICAgICAgICAgICAgICB2YXItPnlyZXNfdmly
dHVhbCA8IHZhci0+eXJlcykgew0KPj4+PiAtICAgICAgICAgICAgICAgcHJfd2FybigiV0FS
TklORzogZmJjb246IERyaXZlciAnJXMnIG1pc3NlZCB0byBhZGp1c3QgdmlydHVhbCBzY3Jl
ZW4gc2l6ZSAoJXV4JXUgdnMuICV1eCV1KVxuIiwNCj4+Pj4gLSAgICAgICAgICAgICAgICAg
ICAgICAgaW5mby0+Zml4LmlkLA0KPj4+PiAtICAgICAgICAgICAgICAgICAgICAgICB2YXIt
PnhyZXNfdmlydHVhbCwgdmFyLT55cmVzX3ZpcnR1YWwsDQo+Pj4+IC0gICAgICAgICAgICAg
ICAgICAgICAgIHZhci0+eHJlcywgdmFyLT55cmVzKTsNCj4+Pj4gICAgICAgICAgICAgICAg
ICByZXR1cm4gLUVJTlZBTDsNCj4+Pj4gICAgICAgICAgfQ0KPj4+DQo+Pj4gR3J7b2V0amUs
ZWV0aW5nfXMsDQo+Pj4NCj4+PiAgICAgICAgICAgICAgICAgICAgICAgICAgR2VlcnQNCj4+
Pg0KPj4+DQo+Pj4gLS0NCj4+PiBHZWVydCBVeXR0ZXJob2V2ZW4gLS0gVGhlcmUncyBsb3Rz
IG9mIExpbnV4IGJleW9uZCBpYTMyIC0tIGdlZXJ0QGxpbnV4LW02OGsub3JnDQo+Pj4NCj4+
PiBJbiBwZXJzb25hbCBjb252ZXJzYXRpb25zIHdpdGggdGVjaG5pY2FsIHBlb3BsZSwgSSBj
YWxsIG15c2VsZiBhIGhhY2tlci4gQnV0DQo+Pj4gd2hlbiBJJ20gdGFsa2luZyB0byBqb3Vy
bmFsaXN0cyBJIGp1c3Qgc2F5ICJwcm9ncmFtbWVyIiBvciBzb21ldGhpbmcgbGlrZSB0aGF0
Lg0KPj4+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIC0tIExpbnVzIFRvcnZh
bGRzDQo+Pg0KPj4gLS0gDQo+PiBEYW5pZWwgVmV0dGVyDQo+PiBTb2Z0d2FyZSBFbmdpbmVl
ciwgSW50ZWwgQ29ycG9yYXRpb24NCj4+IGh0dHA6Ly9ibG9nLmZmd2xsLmNoDQo+IA0KDQot
LSANClRob21hcyBaaW1tZXJtYW5uDQpHcmFwaGljcyBEcml2ZXIgRGV2ZWxvcGVyDQpTVVNF
IFNvZnR3YXJlIFNvbHV0aW9ucyBHZXJtYW55IEdtYkgNCk1heGZlbGRzdHIuIDUsIDkwNDA5
IE7DvHJuYmVyZywgR2VybWFueQ0KKEhSQiAzNjgwOSwgQUcgTsO8cm5iZXJnKQ0KR2VzY2jD
pGZ0c2bDvGhyZXI6IEl2byBUb3Rldg0K

--------------L07aBmLc0ndjB40qAv00Y19v--

--------------FOUOaVAdBeoc4kG6Y0QrJ023
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmQsNyIFAwAAAAAACgkQlh/E3EQov+Do
ag/9EAy/8eiQkdcT0Sn5Jyvk7DWQDZ+taCxQD2sZEGcV75IcQH0uL9QQZAalUun62EVp5Cum16so
vW7V2xZtkCQoxNcp/jzRy12WIjDl1li/V4fNebDMa0vAHNCmRPIIiVdV2lqa0+w9gANgE/wDAWfo
kA2XZAVmNETBuX8uPyC53z3l4srs5vI/gvHESf4vC9rgXYI+3e7N3adUeVF+UKdVIe8Z9yvlbe/l
v1RgWNGxl1eype4Wzj2eQRg41DCgw56s5g1UwCtdYtCtrTxgw9qxhHMcWMkFhWQcrKvh/Qai3F1k
xDlkBFHr8vnTpyuisrCh9+iyBS/473SkiiMFjpAqcX0TPx1ptMNU8C9md+BS9y+K3jsJlyAuSlUd
1CdpaR43p12e8yOWmldhg4dMSW2/H78BWvF1x4Z4amjUEySGa4xoDXJfzBF3LS34lcFbT1/GPhLt
i2TGGJ2v1F7KeWWlzUVGR2QPJVWEh39bZBprzUajE5JVf5WUe4FzRtCIDqBAImropgM8J9cr4lKP
WyLdr2PgcNL0GG7HXfdhMH4r7q/zvvJQk1CSqYRwBe5UR6e1qelceD2cLEIDxlaECkyrZJRp+Sbb
/82/E7MJng9Bk7Z2I7JMjzGLwGwTdUyqnTV6r1dpM2SewhX897aBS7mtPhJ7f7TdkFxcNCbTP/GS
R4w=
=JwjN
-----END PGP SIGNATURE-----

--------------FOUOaVAdBeoc4kG6Y0QrJ023--
