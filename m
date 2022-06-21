Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54487552FC9
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 12:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347222AbiFUKdl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 06:33:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbiFUKdk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 06:33:40 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1857713D7F
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 03:33:39 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id C94D21F972;
        Tue, 21 Jun 2022 10:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1655807617; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nxNmyygDJQRZJMAKXAu8sBA10dB9yXgnEqhPGroFU2k=;
        b=IgH+nG+HMsMaqbxExB6/SXM0PKLpD4HviFZqd+izIPW6snDILqy6vIPlydn5cGZJKxjCqr
        b1iQr2k0/tkHdZW06/e/M88BAerDEEAXnWOEhOKKPeNSTGr0q6wGeR6qakpFYY0GGstCs8
        UELRy8AlUJkVKsKEFH+QuSughZk9BXQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1655807617;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nxNmyygDJQRZJMAKXAu8sBA10dB9yXgnEqhPGroFU2k=;
        b=eF7LZVPmsMtBP1Feo+G9h+RWINa2UFd1v+fD8VwhE+e0GnJJ3sqhYobxKnuWivLL8kCnb3
        V5XnM4ojxAYZpdBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 880B013A88;
        Tue, 21 Jun 2022 10:33:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id BLqTH4GesWKGSwAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Tue, 21 Jun 2022 10:33:37 +0000
Message-ID: <091e20d5-2658-c166-6d65-261716c57efa@suse.de>
Date:   Tue, 21 Jun 2022 12:33:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] drm/fb-helper: Make set_var validation stricter
Content-Language: en-US
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
From:   Thomas Zimmermann <tzimmermann@suse.de>
In-Reply-To: <CAKMK7uHH5Rw=0q-KsO_pZ54mGQAsQuiMLNepn8gviBNeVu4JKg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------ZV0Fuo7LF59AyIqHFyCJdruw"
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
--------------ZV0Fuo7LF59AyIqHFyCJdruw
Content-Type: multipart/mixed; boundary="------------5IV3ZUG130mCgkAu4VP84xWO";
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
Message-ID: <091e20d5-2658-c166-6d65-261716c57efa@suse.de>
Subject: Re: [PATCH] drm/fb-helper: Make set_var validation stricter
References: <20220621092319.379049-1-daniel.vetter@ffwll.ch>
 <303b9f91-9214-5243-8224-a11953960839@suse.de>
 <CAKMK7uHH5Rw=0q-KsO_pZ54mGQAsQuiMLNepn8gviBNeVu4JKg@mail.gmail.com>
In-Reply-To: <CAKMK7uHH5Rw=0q-KsO_pZ54mGQAsQuiMLNepn8gviBNeVu4JKg@mail.gmail.com>

--------------5IV3ZUG130mCgkAu4VP84xWO
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkNCg0KQW0gMjEuMDYuMjIgdW0gMTI6MjAgc2NocmllYiBEYW5pZWwgVmV0dGVyOg0KPiBP
biBUdWUsIDIxIEp1biAyMDIyIGF0IDEyOjE1LCBUaG9tYXMgWmltbWVybWFubiA8dHppbW1l
cm1hbm5Ac3VzZS5kZT4gd3JvdGU6DQo+Pg0KPj4gSGkNCj4+DQo+PiBBbSAyMS4wNi4yMiB1
bSAxMToyMyBzY2hyaWViIERhbmllbCBWZXR0ZXI6DQo+Pj4gVGhlIGRybSBmYmRldiBlbXVs
YXRpb24gZG9lcyBub3QgZm9yd2FyZCBtb2RlIGNoYW5nZXMgdG8gdGhlIGRyaXZlciwNCj4+
PiBhbmQgaGVuY2UgYWxsIGNoYW5nZXMgd2hlcmUgcmVqZWN0ZWQgaW4gODY1YWZiMTE5NDll
ICgiZHJtL2ZiLWhlbHBlcjoNCj4+PiByZWplY3QgYW55IGNoYW5nZXMgdG8gdGhlIGZiZGV2
IikuDQo+Pj4NCj4+PiBVbmZvcnR1bmF0ZWx5IHRoaXMgcmVzdWx0ZWQgaW4gYnVncyBvbiBt
dWx0aXBsZSBtb25pdG9yIHN5c3RlbXMgd2l0aA0KPj4+IGRpZmZlcmVudCByZXNvbHV0aW9u
cy4gSW4gdGhhdCBjYXNlIHRoZSBmYmRldiBlbXVsYXRpb24gY29kZSBzaXplcyB0aGUNCj4+
PiB1bmRlcmx5aW5nIGZyYW1lYnVmZmVyIGZvciB0aGUgbGFyZ2VzdCBzY3JlZW4gKHdoaWNo
IGRpY3RhdGVzDQo+Pj4geC95cmVzX3ZpcnR1YWwpLCBidXQgYWRqdXN0IHRoZSBmYmRldiB4
L3lyZXMgdG8gbWF0Y2ggdGhlIHNtYWxsZXN0DQo+Pj4gcmVzb2x1dGlvbi4gVGhlIGFib3Zl
IG1lbnRpb25lZCBwYXRjaCBmYWlsZWQgdG8gcmVhbGl6ZSB0aGF0LCBhbmQNCj4+PiBlcnJv
cm5vdXNseSB2YWxpZGF0ZWQgeC95cmVzIGFnYWluc3QgdGhlIGZiIGRpbWVuc2lvbnMuDQo+
Pj4NCj4+PiBUaGlzIHdhcyBmaXhlZCBieSBqdXN0IGRyb3BwaW5nIHRoZSB2YWxpZGF0aW9u
IGZvciB0b28gc21hbGwgc2l6ZXMsDQo+Pj4gd2hpY2ggcmVzdG9yZWQgdnQgc3dpdGNoaW5n
IHdpdGggMTJmZmVkOTZkNDM2ICgiZHJtL2ZiLWhlbHBlcjogQWxsb3cNCj4+PiB2YXItPngv
eXJlcyhfdmlydHVhbCkgPCBmYi0+d2lkdGgvaGVpZ2h0IGFnYWluIikuDQo+Pj4NCj4+PiBC
dXQgdGhpcyBhbHNvIHJlc3RvcmVkIGFsbCBraW5kcyBvZiB2YWxpZGF0aW9uIGlzc3VlcyBh
bmQgdGhlaXINCj4+PiBmYWxsb3V0IGluIHRoZSBub3RvcmlvdXNseSBidWdneSBmYmNvbiBj
b2RlIGZvciB0b28gc21hbGwgc2l6ZXMuIFNpbmNlDQo+Pj4gbm8gb25lIGlzIHZvbHVudGVl
cmluZyB0byByZWFsbHkgbWFrZSBmYmNvbiBhbmQgdmMvdnQgZnVsbHkgcm9idXN0DQo+Pj4g
YWdhaW5zdCB0aGVzZSBtYXRoIGlzc3VlcyBtYWtlIHN1cmUgdGhpcyBiYXJuIGRvb3IgaXMg
Y2xvc2VkIGZvciBnb29kDQo+Pj4gYWdhaW4uDQo+Pj4NCj4+PiBTaW5jZSBpdCdzIGEgYml0
IHRyaWNreSB0byByZW1lbWJlciB0aGUgeC95cmVzIHdlIHBpY2tlZCBhY3Jvc3MgYm90aA0K
Pj4+IHRoZSBuZXdlciBnZW5lcmljIGZiZGV2IGVtdWxhdGlvbiBhbmQgdGhlIG9sZGVyIGNv
ZGUgd2l0aCBtb3JlIGRyaXZlcg0KPj4+IGludm9sdmVtZW50LCB3ZSBzaW1wbHkgY2hlY2sg
dGhhdCBpdCBkb2Vzbid0IGNoYW5nZS4gVGhpcyByZWxpZXMgb24NCj4+PiBkcm1fZmJfaGVs
cGVyX2ZpbGxfdmFyKCkgaGF2aW5nIGRvbmUgdGhpbmdzIGNvcnJlY3RseSwgYW5kIG5vdGhp
bmcNCj4+PiBoYXZpbmcgdHJhbXBsZWQgaXQgeWV0Lg0KPj4+DQo+Pj4gTm90ZSB0aGF0IHRo
aXMgbGVhdmVzIGFsbCB0aGUgb3RoZXIgZmJkZXYgZHJpdmVycyBvdXQgaW4gdGhlIHJhaW4u
DQo+Pj4gR2l2ZW4gdGhhdCBkaXN0cm9zIGhhdmUgZmluYWxseSBzdGFydGVkIHRvIG1vdmUg
YXdheSBmcm9tIHRob3NlDQo+Pj4gY29tcGxldGVseSBmb3IgcmVhbCBJIHRoaW5rIHRoYXQn
cyBnb29kIGVub3VnaC4gVGhlIGNvZGUgaXQgc3BhZ2hldHRpDQo+Pj4gZW5vdWdoIHRoYXQg
SSBkbyBub3QgZmVlbCBjb25maWRlbnQgdG8gZXZlbiByZXZpZXcgZml4ZXMgZm9yIGl0Lg0K
Pj4+DQo+Pj4gV2hhdCBtaWdodCBoZWxwIGZiZGV2IGlzIGRvaW5nIHNvbWV0aGluZyBzaW1p
bGFyIHRvIHdoYXQgd2FzIGRvbmUgaW4NCj4+PiBhNDkxNDVhY2ZiOTcgKCJmYm1lbTogYWRk
IG1hcmdpbiBjaGVjayB0byBmYl9jaGVja19jYXBzKCkiKSBhbmQgZW5zdXJlDQo+Pj4geC95
cmVzX3ZpcnR1YWwgYXJlbid0IHRvbyBzbWFsbCwgZm9yIHNvbWUgdmFsdWUgb2YgInRvbyBz
bWFsbCIuIE1heWJlDQo+Pj4gY2hlY2tpbmcgdGhhdCB0aGV5J3JlIGF0IGxlYXN0IHgveXJl
cyBtYWtlcyBzZW5zZT8NCj4+Pg0KPj4+IEZpeGVzOiAxMmZmZWQ5NmQ0MzYgKCJkcm0vZmIt
aGVscGVyOiBBbGxvdyB2YXItPngveXJlcyhfdmlydHVhbCkgPCBmYi0+d2lkdGgvaGVpZ2h0
IGFnYWluIikNCj4+PiBDYzogTWljaGVsIETDpG56ZXIgPG1pY2hlbC5kYWVuemVyQGFtZC5j
b20+DQo+Pj4gQ2M6IERhbmllbCBTdG9uZSA8ZGFuaWVsc0Bjb2xsYWJvcmEuY29tPg0KPj4+
IENjOiBEYW5pZWwgVmV0dGVyIDxkYW5pZWwudmV0dGVyQGZmd2xsLmNoPg0KPj4+IENjOiBN
YWFydGVuIExhbmtob3JzdCA8bWFhcnRlbi5sYW5raG9yc3RAbGludXguaW50ZWwuY29tPg0K
Pj4+IENjOiBNYXhpbWUgUmlwYXJkIDxtcmlwYXJkQGtlcm5lbC5vcmc+DQo+Pj4gQ2M6IFRo
b21hcyBaaW1tZXJtYW5uIDx0emltbWVybWFubkBzdXNlLmRlPg0KPj4+IENjOiA8c3RhYmxl
QHZnZXIua2VybmVsLm9yZz4gIyB2NC4xMSsNCj4+PiBDYzogSGVsZ2UgRGVsbGVyIDxkZWxs
ZXJAZ214LmRlPg0KPj4+IENjOiBHcmVnIEtyb2FoLUhhcnRtYW4gPGdyZWdraEBsaW51eGZv
dW5kYXRpb24ub3JnPg0KPj4+IENjOiBvcGVuZXVsZXItc2VjdXJpdHlAb3BlbmV1bGVyLm9y
Zw0KPj4+IENjOiBndW9kYXhpbmdAaHVhd2VpLmNvbQ0KPj4+IENjOiBXZWlnYW5nIChKaW1t
eSkgPHdlaWdhbmcxMkBodWF3ZWkuY29tPg0KPj4+IFJlcG9ydGVkLWJ5OiBXZWlnYW5nIChK
aW1teSkgPHdlaWdhbmcxMkBodWF3ZWkuY29tPg0KPj4+IFNpZ25lZC1vZmYtYnk6IERhbmll
bCBWZXR0ZXIgPGRhbmllbC52ZXR0ZXJAaW50ZWwuY29tPg0KPj4+IC0tLQ0KPj4+IE5vdGU6
IFdlaWdhbmcgYXNrZWQgZm9yIHRoaXMgdG8gc3RheSB1bmRlciBlbWJhcmdvIHVudGlsIGl0
J3MgYWxsDQo+Pj4gcmV2aWV3IGFuZCB0ZXN0ZWQuDQo+Pj4gLURhbmllbA0KPj4+IC0tLQ0K
Pj4+ICAgIGRyaXZlcnMvZ3B1L2RybS9kcm1fZmJfaGVscGVyLmMgfCA0ICsrLS0NCj4+PiAg
ICAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPj4+
DQo+Pj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9kcm1fZmJfaGVscGVyLmMgYi9k
cml2ZXJzL2dwdS9kcm0vZHJtX2ZiX2hlbHBlci5jDQo+Pj4gaW5kZXggNjk1OTk3YWUyYTdj
Li41NjY0YTE3N2E0MDQgMTAwNjQ0DQo+Pj4gLS0tIGEvZHJpdmVycy9ncHUvZHJtL2RybV9m
Yl9oZWxwZXIuYw0KPj4+ICsrKyBiL2RyaXZlcnMvZ3B1L2RybS9kcm1fZmJfaGVscGVyLmMN
Cj4+PiBAQCAtMTM1NSw4ICsxMzU1LDggQEAgaW50IGRybV9mYl9oZWxwZXJfY2hlY2tfdmFy
KHN0cnVjdCBmYl92YXJfc2NyZWVuaW5mbyAqdmFyLA0KPj4+ICAgICAgICAgKiB0byBLTVMs
IGhlbmNlIGZhaWwgaWYgZGlmZmVyZW50IHNldHRpbmdzIGFyZSByZXF1ZXN0ZWQuDQo+Pj4g
ICAgICAgICAqLw0KPj4+ICAgICAgICBpZiAodmFyLT5iaXRzX3Blcl9waXhlbCA+IGZiLT5m
b3JtYXQtPmNwcFswXSAqIDggfHwNCj4+PiAtICAgICAgICAgdmFyLT54cmVzID4gZmItPndp
ZHRoIHx8IHZhci0+eXJlcyA+IGZiLT5oZWlnaHQgfHwNCj4+PiAtICAgICAgICAgdmFyLT54
cmVzX3ZpcnR1YWwgPiBmYi0+d2lkdGggfHwgdmFyLT55cmVzX3ZpcnR1YWwgPiBmYi0+aGVp
Z2h0KSB7DQo+Pj4gKyAgICAgICAgIHZhci0+eHJlcyAhPSBpbmZvLT52YXIueHJlcyB8fCB2
YXItPnlyZXMgIT0gaW5mby0+dmFyLnlyZXMgfHwNCj4+DQo+PiBUaGlzIGxvb2tzIHJlYXNv
bmFibGUuIFdlIGVmZmVjdGl2ZWx5IG9ubHkgc3VwcG9ydCBhIHNpbmdsZSByZXNvbHV0aW9u
IGhlcmUuDQo+Pg0KPj4+ICsgICAgICAgICB2YXItPnhyZXNfdmlydHVhbCAhPSBmYi0+d2lk
dGggfHwgdmFyLT55cmVzX3ZpcnR1YWwgIT0gZmItPmhlaWdodCkgew0KPj4NCj4+IEFGQUlV
IHRoaXMgY2hhbmdlIHdvdWxkIHJlcXVpcmUgdGhhdCBhbGwgdXNlcnNwYWNlIGFsd2F5cyB1
c2VzIG1heGltdW0NCj4+IHZhbHVlcyBmb3Ige3hyZXMseXJlc31fdmlydHVhbC4gU2VlbXMg
dW5yZWFsaXN0aWMgdG8gbWUuDQo+IA0KPiBUaGUgdGhpbmcgaXMsIHRoZXkga2luZGEgaGF2
ZSB0bywgYmVjYXVzZSB0aGF0J3MgYWx3YXlzIGdvaW5nIHRvIGJlDQo+IHRoZSBhY3R1YWxs
eSB2aXNpYmxlIHBhcnQgOi0pIE90b2ggSSBndWVzcyB3ZSBjb3VsZCBhbHNvIGFsbG93IHZp
cnR1YWwNCj4gc2l6ZSB0byBtYXRjaCB0aGUgZmJkZXYgcmVhbCBzaXplLCBidXQgbWF5YmUg
dGhhdCBraW5kIG9mIHNhbml0eSBjaGVjaw0KPiBzaG91bGQgYmUgZG9uZSBpbiBmYm1lbS5j
Pw0KDQpJJ20gbm90IHN1cmUgSSB1bmRlcnN0YW5kLiBJJ2QgZXhwZWN0IHRoYXQgZmJkZXYg
dXNlcnNwYWNlIGFsbG9jYXRlcyANCnhyZXNfdmlydHVhbCB0byBiZSB0d2ljZSB0aGUgc2l6
ZSBvZiB4cmVzLiBTbyBpdCBjYW4gZG8gZG91YmxlIA0KYnVmZmVyaW5nLiBJbiBtYW55IGNh
c2VzIGZiLT5oZWlnaHQgd291bGQgYmUgbGFyZ2VyIHRoYW4gdGhhdC4NCg0KPiANCj4gVGJo
IGZvciB0aGVzZSBraW5kIG9mIHRoaW5ncyBJJ20gbGVhbmluZyB0b3dhcmRzICJsZXQncyB3
YWl0IHVudGlsIHdlDQo+IGdldCBhIHJlZ3Jlc3Npb24gcmVwb3J0Iiwgc2luY2UgdGhlcmUn
cyBzaW1wbHkgdG9vIG1hbnkgcmFuZG9tIGJ1Z3MNCg0KTm90IHRoYXQgSSBkaXNhZ3JlZSwg
YnV0IGluIHRoaXMgY2FzZSBhIHJlZ3Jlc3Npb24gcmVwb3J0IHNlZW1zIGluZXZpdGFibGUu
DQoNCj4gYWxsIG92ZXIgaW4gdGhlIGZiY29uL3ZjL3Z0IGNvZGUgd2hlbiBzb3Ugc3RhcnQg
cmVzaXppbmcgc3R1ZmYuIFNvIEknbQ0KPiB2ZXJ5IGhlYXZpbHkgbGVhbmluZyB0b3dhcmRz
IHJlamVjdGluZyBldmVyeXRoaW5nIChhbmQgZS5nLiB3ZSBzaG91bGQNCj4gaGF2ZSBmaXhl
ZCB0aGlzIGFsbCB1cCBhbHJlYWR5IGluIDIwMjAgd2hlbiB0aGUgYnVnZml4IGZvciB4L3ly
ZXMNCj4gcmVsYXRlZCB1bmRlcmZsb3dzIGxhbmRlZCBpbiAyMDIwIGltbykuDQoNCkRvIHRo
ZSBmYmRldiBpZ3QgdGVzdHMgd29yayB3aXRoIHRoaXMgY2hhbmdlIGlmIG92ZXJhbGxvYyBo
YXMgYmVlbiBzZXQgDQp0byBtb3JlIHRoYW4gMjAwPw0KDQpCZXN0IHJlZ2FyZHMNClRob21h
cw0KDQo+IC1EYW5pZWwNCj4gDQo+PiBCZXN0IHJlZ2FyZHMNCj4+IFRob21hcw0KPj4NCj4+
DQo+Pj4gICAgICAgICAgICAgICAgZHJtX2RiZ19rbXMoZGV2LCAiZmIgcmVxdWVzdGVkIHdp
ZHRoL2hlaWdodC9icHAgY2FuJ3QgZml0IGluIGN1cnJlbnQgZmIgIg0KPj4+ICAgICAgICAg
ICAgICAgICAgICAgICAgICAicmVxdWVzdCAlZHglZC0lZCAodmlydHVhbCAlZHglZCkgPiAl
ZHglZC0lZFxuIiwNCj4+PiAgICAgICAgICAgICAgICAgICAgICAgICAgdmFyLT54cmVzLCB2
YXItPnlyZXMsIHZhci0+Yml0c19wZXJfcGl4ZWwsDQo+Pg0KPj4gLS0NCj4+IFRob21hcyBa
aW1tZXJtYW5uDQo+PiBHcmFwaGljcyBEcml2ZXIgRGV2ZWxvcGVyDQo+PiBTVVNFIFNvZnR3
YXJlIFNvbHV0aW9ucyBHZXJtYW55IEdtYkgNCj4+IE1heGZlbGRzdHIuIDUsIDkwNDA5IE7D
vHJuYmVyZywgR2VybWFueQ0KPj4gKEhSQiAzNjgwOSwgQUcgTsO8cm5iZXJnKQ0KPj4gR2Vz
Y2jDpGZ0c2bDvGhyZXI6IEl2byBUb3Rldg0KPiANCj4gDQo+IA0KDQotLSANClRob21hcyBa
aW1tZXJtYW5uDQpHcmFwaGljcyBEcml2ZXIgRGV2ZWxvcGVyDQpTVVNFIFNvZnR3YXJlIFNv
bHV0aW9ucyBHZXJtYW55IEdtYkgNCk1heGZlbGRzdHIuIDUsIDkwNDA5IE7DvHJuYmVyZywg
R2VybWFueQ0KKEhSQiAzNjgwOSwgQUcgTsO8cm5iZXJnKQ0KR2VzY2jDpGZ0c2bDvGhyZXI6
IEl2byBUb3Rldg0K

--------------5IV3ZUG130mCgkAu4VP84xWO--

--------------ZV0Fuo7LF59AyIqHFyCJdruw
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmKxnoEFAwAAAAAACgkQlh/E3EQov+As
xw/9GY/lO1bs19H2g4Y6JkAl2SGipkAqOQYYxJSJAyIHb6YyNplAEU/03TWVyUz+jNwJwHGKQXVf
wWpwt8f/RTM+VxlrltshrM8Pvjq4WB/3xgOMLcLZNv0ddfShkaqOV5WBenshUYcQXfaREOvffCZa
rMqLr586moWMhr+e2c8nvJlHYM21cot+Y6m9BFWjvNUVtzdIArxqTi5m0fPJANGKXk6tsUYXBu+R
e2aiq6sN1euqR6M7ITSTeNk0JTrKby/cpNi3tAe/1y0UWqPlh+UiKT7cycWCHckSftqtkPJPDOTv
OBXLCrCCJMDa9+lVxeh1sA7mCKKba79eZNItqdb+kUUrKtK2oVIae4ifovTY7x9XuX0uVqtaOe9m
E/V9pBjFxU86gOzelnE9axf/bqGXQ1MLEWeiifMlvGIAhGGgcQz2hULklvbnnGJ4wBitlSXPo1oW
pmMr/TNGIucyuj/w45NHLVPLQskmKPDAN3mOe05p5RKycirXGrHTImZxN0ki0wEscm9M75Sdz4Wr
b5sAOzMWpbeCaCRmmARXXUcSNsxq1+p4ji2f3a+QrgPvzfLU8J95i673rZfcG/ZRfEaRMcaQPASh
nXxfKbcrlPwZ5KmLqwMNHXNumi5ghjktY3D0zShXfeFyNbqMq8gDG/dtPsprIysFFF5q7E7Lu5Fp
8eY=
=JUEp
-----END PGP SIGNATURE-----

--------------ZV0Fuo7LF59AyIqHFyCJdruw--
