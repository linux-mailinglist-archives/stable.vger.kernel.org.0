Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A116B67334F
	for <lists+stable@lfdr.de>; Thu, 19 Jan 2023 09:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbjASIHA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Jan 2023 03:07:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjASIG7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Jan 2023 03:06:59 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 701325421A
        for <stable@vger.kernel.org>; Thu, 19 Jan 2023 00:06:57 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 2B1CE5CA96;
        Thu, 19 Jan 2023 08:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1674115616; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xFYatVT434CKDQQui+qf2wAuBLLLuHdxPFc0/JYSK38=;
        b=UZ3/tZiPVKA7KVBgXRpxyePRpLmyzxeQQ7jDUZIhZv5CYqn/iFSBZ4gzP04ii2AsHwNwk3
        CZ3Gq2K0929c6ySkM0Eb3688Qi/twZzMeY9hu8u0nRujC5w1N97PUvvDKNXx08xGPnn6Gj
        UguOxak7a7A2E9yp/ZXRPDwlAGTk4Hc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1674115616;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xFYatVT434CKDQQui+qf2wAuBLLLuHdxPFc0/JYSK38=;
        b=8V6r1mgUvT4wMFfdPkGCzYZTCs8B6fffZe9Rnj3La7WPhbuUAC6En7Do/07N6dNy0bCVCp
        /SguAEO+avvXEuAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 60B3A139ED;
        Thu, 19 Jan 2023 08:06:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id zOKcFh/6yGO4TgAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Thu, 19 Jan 2023 08:06:55 +0000
Message-ID: <7ec650c7-d530-54f7-5323-45c05ee50802@suse.de>
Date:   Thu, 19 Jan 2023 09:06:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [Intel-gfx] [PATCH v2 2/3] drm/fb-helper: Set framebuffer for
 vga-switcheroo clients
Content-Language: en-US
To:     Rodrigo Vivi <rodrigo.vivi@intel.com>,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        airlied@redhat.com
Cc:     Somalapuram Amaranath <Amaranath.Somalapuram@amd.com>,
        kherbst@redhat.com, Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org, YiPeng Chai <YiPeng.Chai@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Likun Gao <Likun.Gao@amd.com>, Sam Ravnborg <sam@ravnborg.org>,
        Guchun Chen <guchun.chen@amd.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        amd-gfx@lists.freedesktop.org,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Stanley Yang <Stanley.Yang@amd.com>, bskeggs@redhat.com,
        nouveau@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        Andrey Grodzovsky <andrey.grodzovsky@amd.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Bokun Zhang <Bokun.Zhang@amd.com>,
        =?UTF-8?B?TWFyZWsgT2zFocOhaw==?= <marek.olsak@amd.com>,
        "Tianci.Yin" <tianci.yin@amd.com>,
        Hans de Goede <hdegoede@redhat.com>, jose.souza@intel.com,
        evan.quan@amd.com, tvrtko.ursulin@linux.intel.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Xiaojian Du <Xiaojian.Du@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>, Xinhui.Pan@amd.com,
        stable@vger.kernel.org, Solomon Chiu <solomon.chiu@amd.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        alexander.deucher@amd.com, Hawking Zhang <Hawking.Zhang@amd.com>,
        christian.koenig@amd.com, Hamza Mahfooz <hamza.mahfooz@amd.com>
References: <20230112201156.26849-1-tzimmermann@suse.de>
 <20230112201156.26849-3-tzimmermann@suse.de> <Y8hGsX+yafmFbq4g@intel.com>
From:   Thomas Zimmermann <tzimmermann@suse.de>
In-Reply-To: <Y8hGsX+yafmFbq4g@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------20Gcd1EgZn6SADONFQDI9tmo"
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------20Gcd1EgZn6SADONFQDI9tmo
Content-Type: multipart/mixed; boundary="------------30ez6gaNoE0IbDxaITUeHioD";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: Rodrigo Vivi <rodrigo.vivi@intel.com>, maarten.lankhorst@linux.intel.com,
 mripard@kernel.org, airlied@redhat.com
Cc: Somalapuram Amaranath <Amaranath.Somalapuram@amd.com>,
 kherbst@redhat.com, Daniel Vetter <daniel.vetter@ffwll.ch>,
 dri-devel@lists.freedesktop.org, YiPeng Chai <YiPeng.Chai@amd.com>,
 Mario Limonciello <mario.limonciello@amd.com>, Likun Gao
 <Likun.Gao@amd.com>, Sam Ravnborg <sam@ravnborg.org>,
 Guchun Chen <guchun.chen@amd.com>,
 Javier Martinez Canillas <javierm@redhat.com>,
 amd-gfx@lists.freedesktop.org, Aurabindo Pillai <aurabindo.pillai@amd.com>,
 Stanley Yang <Stanley.Yang@amd.com>, bskeggs@redhat.com,
 nouveau@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 Andrey Grodzovsky <andrey.grodzovsky@amd.com>,
 Jani Nikula <jani.nikula@intel.com>, Bokun Zhang <Bokun.Zhang@amd.com>,
 =?UTF-8?B?TWFyZWsgT2zFocOhaw==?= <marek.olsak@amd.com>,
 "Tianci.Yin" <tianci.yin@amd.com>, Hans de Goede <hdegoede@redhat.com>,
 jose.souza@intel.com, evan.quan@amd.com, tvrtko.ursulin@linux.intel.com,
 Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
 Xiaojian Du <Xiaojian.Du@amd.com>, Felix Kuehling <Felix.Kuehling@amd.com>,
 Xinhui.Pan@amd.com, stable@vger.kernel.org,
 Solomon Chiu <solomon.chiu@amd.com>,
 Kai-Heng Feng <kai.heng.feng@canonical.com>, alexander.deucher@amd.com,
 Hawking Zhang <Hawking.Zhang@amd.com>, christian.koenig@amd.com,
 Hamza Mahfooz <hamza.mahfooz@amd.com>
Message-ID: <7ec650c7-d530-54f7-5323-45c05ee50802@suse.de>
Subject: Re: [Intel-gfx] [PATCH v2 2/3] drm/fb-helper: Set framebuffer for
 vga-switcheroo clients
References: <20230112201156.26849-1-tzimmermann@suse.de>
 <20230112201156.26849-3-tzimmermann@suse.de> <Y8hGsX+yafmFbq4g@intel.com>
In-Reply-To: <Y8hGsX+yafmFbq4g@intel.com>

--------------30ez6gaNoE0IbDxaITUeHioD
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkNCg0KQW0gMTguMDEuMjMgdW0gMjA6MjEgc2NocmllYiBSb2RyaWdvIFZpdmk6DQo+IE9u
IFRodSwgSmFuIDEyLCAyMDIzIGF0IDA5OjExOjU1UE0gKzAxMDAsIFRob21hcyBaaW1tZXJt
YW5uIHdyb3RlOg0KPj4gU2V0IHRoZSBmcmFtZWJ1ZmZlciBpbmZvIGZvciBkcml2ZXJzIHRo
YXQgc3VwcG9ydCBWR0Egc3dpdGNoZXJvby4gT25seQ0KPj4gYWZmZWN0cyB0aGUgYW1kZ3B1
IGFuZCBub3V2ZWF1IGRyaXZlcnMsIHdoaWNoIHVzZSBWR0Egc3dpdGNoZXJvbyBhbmQNCj4+
IGdlbmVyaWMgZmJkZXYgZW11bGF0aW9uLiBGb3Igb3RoZXIgZHJpdmVycywgdGhpcyBkb2Vz
IG5vdGhpbmcuDQo+Pg0KPj4gVGhpcyBmaXhlcyBhIHBvdGVudGlhbCByZWdyZXNzaW9uIGlu
IHRoZSBjb25zb2xlIGNvZGUuIEJvdGgsIGFtZGdwdSBhbmQNCj4+IG5vdXZlYXUsIGludm9r
ZWQgdmdhX3N3aXRjaGVyb29fY2xpZW50X2ZiX3NldCgpIGZyb20gdGhlaXIgaW50ZXJuYWwg
ZmJkZXYNCj4+IGNvZGUuIEJ1dCB0aGUgY2FsbCBnb3QgbG9zdCB3aGVuIHRoZSBkcml2ZXJz
IHN3aXRjaGVkIHRvIHRoZSBnZW5lcmljDQo+PiBlbXVsYXRpb24uDQo+Pg0KPj4gRml4ZXM6
IDA4NzQ1MWYzNzJiZiAoImRybS9hbWRncHU6IHVzZSBnZW5lcmljIGZiIGhlbHBlcnMgaW5z
dGVhZCBvZiBzZXR0aW5nIHVwIEFNRCBvd24ncy4iKQ0KPj4gRml4ZXM6IDRhMTZkZDlkMThh
MCAoImRybS9ub3V2ZWF1L2ttczogc3dpdGNoIHRvIGRybSBmYmRldiBoZWxwZXJzIikNCj4+
IFNpZ25lZC1vZmYtYnk6IFRob21hcyBaaW1tZXJtYW5uIDx0emltbWVybWFubkBzdXNlLmRl
Pg0KPj4gUmV2aWV3ZWQtYnk6IERhbmllbCBWZXR0ZXIgPGRhbmllbC52ZXR0ZXJAZmZ3bGwu
Y2g+DQo+PiBSZXZpZXdlZC1ieTogQWxleCBEZXVjaGVyIDxhbGV4YW5kZXIuZGV1Y2hlckBh
bWQuY29tPg0KPj4gQ2M6IEJlbiBTa2VnZ3MgPGJza2VnZ3NAcmVkaGF0LmNvbT4NCj4+IENj
OiBLYXJvbCBIZXJic3QgPGtoZXJic3RAcmVkaGF0LmNvbT4NCj4+IENjOiBMeXVkZSBQYXVs
IDxseXVkZUByZWRoYXQuY29tPg0KPj4gQ2M6IFRob21hcyBaaW1tZXJtYW5uIDx0emltbWVy
bWFubkBzdXNlLmRlPg0KPj4gQ2M6IEphdmllciBNYXJ0aW5leiBDYW5pbGxhcyA8amF2aWVy
bUByZWRoYXQuY29tPg0KPj4gQ2M6IExhdXJlbnQgUGluY2hhcnQgPGxhdXJlbnQucGluY2hh
cnRAaWRlYXNvbmJvYXJkLmNvbT4NCj4+IENjOiBKYW5pIE5pa3VsYSA8amFuaS5uaWt1bGFA
aW50ZWwuY29tPg0KPj4gQ2M6IERhdmUgQWlybGllIDxhaXJsaWVkQHJlZGhhdC5jb20+DQo+
PiBDYzogRXZhbiBRdWFuIDxldmFuLnF1YW5AYW1kLmNvbT4NCj4+IENjOiBDaHJpc3RpYW4g
S8O2bmlnIDxjaHJpc3RpYW4ua29lbmlnQGFtZC5jb20+DQo+PiBDYzogQWxleCBEZXVjaGVy
IDxhbGV4YW5kZXIuZGV1Y2hlckBhbWQuY29tPg0KPj4gQ2M6IEhhd2tpbmcgWmhhbmcgPEhh
d2tpbmcuWmhhbmdAYW1kLmNvbT4NCj4+IENjOiBMaWt1biBHYW8gPExpa3VuLkdhb0BhbWQu
Y29tPg0KPj4gQ2M6ICJDaHJpc3RpYW4gS8O2bmlnIiA8Y2hyaXN0aWFuLmtvZW5pZ0BhbWQu
Y29tPg0KPj4gQ2M6IFN0YW5sZXkgWWFuZyA8U3RhbmxleS5ZYW5nQGFtZC5jb20+DQo+PiBD
YzogIlRpYW5jaS5ZaW4iIDx0aWFuY2kueWluQGFtZC5jb20+DQo+PiBDYzogWGlhb2ppYW4g
RHUgPFhpYW9qaWFuLkR1QGFtZC5jb20+DQo+PiBDYzogQW5kcmV5IEdyb2R6b3Zza3kgPGFu
ZHJleS5ncm9kem92c2t5QGFtZC5jb20+DQo+PiBDYzogWWlQZW5nIENoYWkgPFlpUGVuZy5D
aGFpQGFtZC5jb20+DQo+PiBDYzogU29tYWxhcHVyYW0gQW1hcmFuYXRoIDxBbWFyYW5hdGgu
U29tYWxhcHVyYW1AYW1kLmNvbT4NCj4+IENjOiBCb2t1biBaaGFuZyA8Qm9rdW4uWmhhbmdA
YW1kLmNvbT4NCj4+IENjOiBHdWNodW4gQ2hlbiA8Z3VjaHVuLmNoZW5AYW1kLmNvbT4NCj4+
IENjOiBIYW16YSBNYWhmb296IDxoYW16YS5tYWhmb296QGFtZC5jb20+DQo+PiBDYzogQXVy
YWJpbmRvIFBpbGxhaSA8YXVyYWJpbmRvLnBpbGxhaUBhbWQuY29tPg0KPj4gQ2M6IE1hcmlv
IExpbW9uY2llbGxvIDxtYXJpby5saW1vbmNpZWxsb0BhbWQuY29tPg0KPj4gQ2M6IFNvbG9t
b24gQ2hpdSA8c29sb21vbi5jaGl1QGFtZC5jb20+DQo+PiBDYzogS2FpLUhlbmcgRmVuZyA8
a2FpLmhlbmcuZmVuZ0BjYW5vbmljYWwuY29tPg0KPj4gQ2M6IEZlbGl4IEt1ZWhsaW5nIDxG
ZWxpeC5LdWVobGluZ0BhbWQuY29tPg0KPj4gQ2M6IERhbmllbCBWZXR0ZXIgPGRhbmllbC52
ZXR0ZXJAZmZ3bGwuY2g+DQo+PiBDYzogIk1hcmVrIE9sxaHDoWsiIDxtYXJlay5vbHNha0Bh
bWQuY29tPg0KPj4gQ2M6IFNhbSBSYXZuYm9yZyA8c2FtQHJhdm5ib3JnLm9yZz4NCj4+IENj
OiBIYW5zIGRlIEdvZWRlIDxoZGVnb2VkZUByZWRoYXQuY29tPg0KPj4gQ2M6ICJWaWxsZSBT
eXJqw6Rsw6QiIDx2aWxsZS5zeXJqYWxhQGxpbnV4LmludGVsLmNvbT4NCj4+IENjOiBkcmkt
ZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnDQo+PiBDYzogbm91dmVhdUBsaXN0cy5mcmVl
ZGVza3RvcC5vcmcNCj4+IENjOiA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz4gIyB2NS4xNysN
Cj4+IC0tLQ0KPj4gICBkcml2ZXJzL2dwdS9kcm0vZHJtX2ZiX2hlbHBlci5jIHwgOCArKysr
KysrKw0KPj4gICAxIGZpbGUgY2hhbmdlZCwgOCBpbnNlcnRpb25zKCspDQo+Pg0KPj4gZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9kcm1fZmJfaGVscGVyLmMgYi9kcml2ZXJzL2dw
dS9kcm0vZHJtX2ZiX2hlbHBlci5jDQo+PiBpbmRleCA0Mjc2MzE3MDYxMjguLjVlNDQ1YzYx
MjUyZCAxMDA2NDQNCj4+IC0tLSBhL2RyaXZlcnMvZ3B1L2RybS9kcm1fZmJfaGVscGVyLmMN
Cj4+ICsrKyBiL2RyaXZlcnMvZ3B1L2RybS9kcm1fZmJfaGVscGVyLmMNCj4+IEBAIC0zMCw3
ICszMCw5IEBADQo+PiAgICNkZWZpbmUgcHJfZm10KGZtdCkgS0JVSUxEX01PRE5BTUUgIjog
IiBmbXQNCj4+ICAgDQo+PiAgICNpbmNsdWRlIDxsaW51eC9jb25zb2xlLmg+DQo+PiArI2lu
Y2x1ZGUgPGxpbnV4L3BjaS5oPg0KPj4gICAjaW5jbHVkZSA8bGludXgvc3lzcnEuaD4NCj4+
ICsjaW5jbHVkZSA8bGludXgvdmdhX3N3aXRjaGVyb28uaD4NCj4+ICAgDQo+PiAgICNpbmNs
dWRlIDxkcm0vZHJtX2F0b21pYy5oPg0KPj4gICAjaW5jbHVkZSA8ZHJtL2RybV9kcnYuaD4N
Cj4+IEBAIC0xOTQwLDYgKzE5NDIsNyBAQCBzdGF0aWMgaW50IGRybV9mYl9oZWxwZXJfc2lu
Z2xlX2ZiX3Byb2JlKHN0cnVjdCBkcm1fZmJfaGVscGVyICpmYl9oZWxwZXIsDQo+PiAgIAkJ
CQkJIGludCBwcmVmZXJyZWRfYnBwKQ0KPj4gICB7DQo+PiAgIAlzdHJ1Y3QgZHJtX2NsaWVu
dF9kZXYgKmNsaWVudCA9ICZmYl9oZWxwZXItPmNsaWVudDsNCj4+ICsJc3RydWN0IGRybV9k
ZXZpY2UgKmRldiA9IGZiX2hlbHBlci0+ZGV2Ow0KPiANCj4gT24gZHJtLXRpcCwgdGhpcyBj
b21taXQgaGFzIGEgc2lsZW50IGNvbmZsaWN0IHdpdGgNCj4gY2ZmODRiYWM5OTIyICgiZHJt
L2ZoLWhlbHBlcjogU3BsaXQgZmJkZXYgc2luZ2xlLXByb2JlIGhlbHBlciIpDQo+IHRoYXQn
cyBhbHJlYWR5IGluIGRybS1uZXh0Lg0KPiANCj4gSSBoYWQgY3JlYXRlZCBhIGZpeC11cCBw
YXRjaCBpbiBkcm0tdGlwIHJlLWludHJvZHVjaW5nIHRoaXMgbGluZS4NCg0KVGhhbmsgeW91
LiBJcyBpdCBmaXhlZCBmb3Igbm93Pw0KDQo+IA0KPiBXZSBwcm9iYWJseSBuZWVkIGEgYmFj
a21lcmdlIGZyb20gZHJtLW5leHQgaW50byBkcm0tbWlzYy1maXhlcyB3aXRoDQo+IHRoZSBy
ZXNvbHV0aW9uIGFwcGxpZWQgdGhlcmUuIEFuZCBwcm9iYWJseSBwcm9wYWdhdGVkIHRoYXQg
cmVzb2x1dGlvbg0KPiBsYXRlci4uLg0KDQpCYWNrbWVyZ2luZyBmcm9tIC1uZXh0IGludG8g
LWZpeGVzIGJyYW5jaGVzIGlzIGEgcHJvYmxlbSwgYXMgLWZpeGVzIA0Kc2hvdWxkIGJlIGNs
b3NlIHRvIHRoZSBsYXRlc3QgcmVsZWFzZS4NCg0KQ2FuIHdlIHNvbHZlIHRoaXMgYnkgbWVy
Z2luZyAtZml4ZXMgaW50byB1cHN0cmVhbSBhbmQgYmFja21lcmdpbmcgdGhpcyANCmludG8g
b3VyIC1uZXh0IGJyYW5jaGVzPw0KDQpCZXN0IHJlZ2FyZHMNClRob21hcw0KDQo+IA0KPj4g
ICAJc3RydWN0IGRybV9mYl9oZWxwZXJfc3VyZmFjZV9zaXplIHNpemVzOw0KPj4gICAJaW50
IHJldDsNCj4+ICAgDQo+PiBAQCAtMTk2MSw2ICsxOTY0LDExIEBAIHN0YXRpYyBpbnQgZHJt
X2ZiX2hlbHBlcl9zaW5nbGVfZmJfcHJvYmUoc3RydWN0IGRybV9mYl9oZWxwZXIgKmZiX2hl
bHBlciwNCj4+ICAgCQlyZXR1cm4gcmV0Ow0KPj4gICANCj4+ICAgCXN0cmNweShmYl9oZWxw
ZXItPmZiLT5jb21tLCAiW2ZiY29uXSIpOw0KPj4gKw0KPj4gKwkvKiBTZXQgdGhlIGZiIGlu
Zm8gZm9yIHZnYXN3aXRjaGVyb28gY2xpZW50cy4gRG9lcyBub3RoaW5nIG90aGVyd2lzZS4g
Ki8NCj4+ICsJaWYgKGRldl9pc19wY2koZGV2LT5kZXYpKQ0KPj4gKwkJdmdhX3N3aXRjaGVy
b29fY2xpZW50X2ZiX3NldCh0b19wY2lfZGV2KGRldi0+ZGV2KSwgZmJfaGVscGVyLT5pbmZv
KTsNCj4+ICsNCj4+ICAgCXJldHVybiAwOw0KPj4gICB9DQo+PiAgIA0KPj4gLS0gDQo+PiAy
LjM5LjANCj4+DQoNCi0tIA0KVGhvbWFzIFppbW1lcm1hbm4NCkdyYXBoaWNzIERyaXZlciBE
ZXZlbG9wZXINClNVU0UgU29mdHdhcmUgU29sdXRpb25zIEdlcm1hbnkgR21iSA0KTWF4ZmVs
ZHN0ci4gNSwgOTA0MDkgTsO8cm5iZXJnLCBHZXJtYW55DQooSFJCIDM2ODA5LCBBRyBOw7xy
bmJlcmcpDQpHZXNjaMOkZnRzZsO8aHJlcjogSXZvIFRvdGV2DQo=

--------------30ez6gaNoE0IbDxaITUeHioD--

--------------20Gcd1EgZn6SADONFQDI9tmo
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmPI+h4FAwAAAAAACgkQlh/E3EQov+CD
WhAAsFekX+ilJqwN8sgGZ28FhcC7j7nx4WAhh8krXat4LbcZOSqXNagMXaz8F3YPxesdguza++Al
IOYVj1CFoi0NcwUDFACPADysnYnitrVaGs7fiFbgnaTZmVPQ5nKqzZ9gN3xFv2EkTc+BvHdoIDMu
kSmS1+AJpTVmjAkrZ/m/vQ1NPz0v8ar2JR2zvPQwyfN7knFnoXFMmOcjAQIf7o9LBP8BlM73JsOb
M0im+n7PLCEfePW/gCY3AnNPF8h2CTc4fM3FXyDKm3cdaou2e6Va/Y6wu0pNScfeuXJ07xwJOLdG
6RcpPJunVfh4UNMHJRhnnLZIA4Wmid79627eEgyMEeACLmmSrWHIDf07Kch+YchmpSwui7FH8egE
Yxt3FdcWffjct+RQcdPZj2U+v77OGAgvw/0/i31C/p71Bj7th1/ysPfbnNLoZ2ghsLuC0C9WQn0F
7DIawWd6KNPoHmWbhIJBc1MTkJKsPGNP5NnwhV+vbOWufjkxAYIRIL5lbE9Ybr0S3oYzo3bnS+EW
gAXMF8NGfAI/8OL0xcAuRQuJ2SiE1Mf7VrxtLNbau4I0KlNxiX17hibVqLcXm6BzCo+9qzrXosqp
XIJW2ezPPTu1maDfP29aA60Y1mEwCp05hsCUdL7ySbHAAJdUvFsbjHBIqVErrw9Z8oFqooOW1Y8P
djE=
=hJ58
-----END PGP SIGNATURE-----

--------------20Gcd1EgZn6SADONFQDI9tmo--
