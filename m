Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5296F5B4ED5
	for <lists+stable@lfdr.de>; Sun, 11 Sep 2022 14:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbiIKMnR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Sep 2022 08:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbiIKMnQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Sep 2022 08:43:16 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3DBC32DAA
        for <stable@vger.kernel.org>; Sun, 11 Sep 2022 05:43:14 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-110-ec45KESrOn6H5-DrFmI1fQ-1; Sun, 11 Sep 2022 13:43:11 +0100
X-MC-Unique: ec45KESrOn6H5-DrFmI1fQ-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Sun, 11 Sep
 2022 13:43:12 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.040; Sun, 11 Sep 2022 13:43:12 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'NeilBrown' <neilb@suse.de>, Eugeniu Rosca <erosca@de.adit-jv.com>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Michael Rodin <mrodin@de.adit-jv.com>,
        "Eugeniu Rosca" <erosca@de.adit-jv.com>,
        Eugeniu Rosca <roscaeugeniu@gmail.com>
Subject: RE: [PATCH 4.14 022/284] SUNRPC: avoid race between mod_timer() and
 del_timer_sync()
Thread-Topic: [PATCH 4.14 022/284] SUNRPC: avoid race between mod_timer() and
 del_timer_sync()
Thread-Index: AQHYwx4h9IHpyJYDe0qgG97udhdnBq3aKpgw
Date:   Sun, 11 Sep 2022 12:43:12 +0000
Message-ID: <1c8cdc749fa34486abd435a15ec201fc@AcuMS.aculab.com>
References: <20220418121210.689577360@linuxfoundation.org>,
 <20220418121211.327937970@linuxfoundation.org>,
 <20220907142548.GA9975@lxhi-065>
 <166259870333.30452.4204968221881228505@noble.neil.brown.name>
In-Reply-To: <166259870333.30452.4204968221881228505@noble.neil.brown.name>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogTmVpbEJyb3duDQo+IFNlbnQ6IDA4IFNlcHRlbWJlciAyMDIyIDAxOjU4DQo+IA0KPiBP
biBUaHUsIDA4IFNlcCAyMDIyLCBFdWdlbml1IFJvc2NhIHdyb3RlOg0KPiA+IEhlbGxvIGFsbCwN
Cj4gPg0KPiA+IE9uIE1vLCBBcHIgMTgsIDIwMjIgYXQgMDI6MTA6MDMgKzAyMDAsIEdyZWcgS3Jv
YWgtSGFydG1hbiB3cm90ZToNCj4gPiA+IEZyb206IE5laWxCcm93biA8bmVpbGJAc3VzZS5kZT4N
Cj4gPiA+DQo+ID4gPiBjb21taXQgMzg0OGU5NmVkZjQ3ODhmNzcyZDgzOTkwMDIyZmE3MDIzYTIz
M2Q4MyB1cHN0cmVhbS4NCj4gPiA+DQo+ID4gPiB4cHJ0X2Rlc3RvcnkoKSBjbGFpbXMgWFBSVF9M
T0NLRUQgYW5kIHRoZW4gY2FsbHMgZGVsX3RpbWVyX3N5bmMoKS4NCj4gPiA+IEJvdGggeHBydF91
bmxvY2tfY29ubmVjdCgpIGFuZCB4cHJ0X3JlbGVhc2UoKSBjYWxsDQo+ID4gPiAgLT5yZWxlYXNl
X3hwcnQoKQ0KPiA+ID4gd2hpY2ggZHJvcHMgWFBSVF9MT0NLRUQgYW5kICp0aGVuKiB4cHJ0X3Nj
aGVkdWxlX2F1dG9kaXNjb25uZWN0KCkNCj4gPiA+IHdoaWNoIGNhbGxzIG1vZF90aW1lcigpLg0K
PiA+ID4NCj4gPiA+IFRoaXMgbWF5IHJlc3VsdCBpbiBtb2RfdGltZXIoKSBiZWluZyBjYWxsZWQg
KmFmdGVyKiBkZWxfdGltZXJfc3luYygpLg0KPiA+ID4gV2hlbiB0aGlzIGhhcHBlbnMsIHRoZSB0
aW1lciBtYXkgZmlyZSBsb25nIGFmdGVyIHRoZSB4cHJ0IGhhcyBiZWVuIGZyZWVkLA0KPiA+ID4g
YW5kIHJ1bl90aW1lcl9zb2Z0aXJxKCkgd2lsbCBwcm9iYWJseSBjcmFzaC4NCj4gPiA+DQo+ID4g
PiBUaGUgcGFpcmluZyBvZiAtPnJlbGVhc2VfeHBydCgpIGFuZCB4cHJ0X3NjaGVkdWxlX2F1dG9k
aXNjb25uZWN0KCkgaXMNCj4gPiA+IGFsd2F5cyBjYWxsZWQgdW5kZXIgLT50cmFuc3BvcnRfbG9j
ay4gIFNvIGlmIHdlIHRha2UgLT50cmFuc3BvcnRfbG9jayB0bw0KPiA+ID4gY2FsbCBkZWxfdGlt
ZXJfc3luYygpLCB3ZSBjYW4gYmUgc3VyZSB0aGF0IG1vZF90aW1lcigpIHdpbGwgcnVuIGZpcnN0
DQo+ID4gPiAoaWYgaXQgcnVucyBhdCBhbGwpLg0KPiA+ID4NCj4gPiA+IENjOiBzdGFibGVAdmdl
ci5rZXJuZWwub3JnDQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBOZWlsQnJvd24gPG5laWxiQHN1c2Uu
ZGU+DQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBUcm9uZCBNeWtsZWJ1c3QgPHRyb25kLm15a2xlYnVz
dEBoYW1tZXJzcGFjZS5jb20+DQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBHcmVnIEtyb2FoLUhhcnRt
YW4gPGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPg0KPiA+ID4gLS0tDQo+ID4gPiAgbmV0L3N1
bnJwYy94cHJ0LmMgfCAgICA3ICsrKysrKysNCj4gPiA+ICAxIGZpbGUgY2hhbmdlZCwgNyBpbnNl
cnRpb25zKCspDQo+ID4gPg0KPiA+ID4gLS0tIGEvbmV0L3N1bnJwYy94cHJ0LmMNCj4gPiA+ICsr
KyBiL25ldC9zdW5ycGMveHBydC5jDQo+ID4gPiBAQCAtMTUyMCw3ICsxNTIwLDE0IEBAIHN0YXRp
YyB2b2lkIHhwcnRfZGVzdHJveShzdHJ1Y3QgcnBjX3hwcnQNCj4gPiA+ICAJICovDQo+ID4gPiAg
CXdhaXRfb25fYml0X2xvY2soJnhwcnQtPnN0YXRlLCBYUFJUX0xPQ0tFRCwgVEFTS19VTklOVEVS
UlVQVElCTEUpOw0KPiA+ID4NCj4gPiA+ICsJLyoNCj4gPiA+ICsJICogeHBydF9zY2hlZHVsZV9h
dXRvZGlzY29ubmVjdCgpIGNhbiBydW4gYWZ0ZXIgWFBSVF9MT0NLRUQNCj4gPiA+ICsJICogaXMg
Y2xlYXJlZC4gIFdlIHVzZSAtPnRyYW5zcG9ydF9sb2NrIHRvIGVuc3VyZSB0aGUgbW9kX3RpbWVy
KCkNCj4gPiA+ICsJICogY2FuIG9ubHkgcnVuICpiZWZvcmUqIGRlbF90aW1lX3N5bmMoKSwgbmV2
ZXIgYWZ0ZXIuDQo+ID4gPiArCSAqLw0KPiA+ID4gKwlzcGluX2xvY2soJnhwcnQtPnRyYW5zcG9y
dF9sb2NrKTsNCj4gPiA+ICAJZGVsX3RpbWVyX3N5bmMoJnhwcnQtPnRpbWVyKTsNCj4gPiA+ICsJ
c3Bpbl91bmxvY2soJnhwcnQtPnRyYW5zcG9ydF9sb2NrKTsNCj4gDQo+IEkgdGhpbmsgaXQgaXMg
c3VmZmljaWVudCB0byBjaGFuZ2UgdGhlIHRvIHNwaW5feyx1bn1sb2NrX2JoKCkNCj4gaW4gb2xk
ZXIga2VybmVscy4gIFRoZSBzcGlubG9jayBjYWxsIG5lZWQgdG8gbWF0Y2ggb3RoZXIgdXNlcyBv
ZiB0aGUNCj4gc2FtZSBsb2NrLg0KDQpFdmVyeSB0aW1lIEkgc2VlIHRoaXMgcGF0Y2ggaXQgbG9v
a3Mgd3JvbmcuDQpZb3UgbmVlZCBzb21ldGhpbmcgdG8gc3RvcCB0aGUgY29kZSB0aGF0IGlzIGNh
bGxpbmcgbW9kX3RpbWVyKCkNCnJ1bm5pbmcgYWZ0ZXIgdGhlIHNwaW5fdW5sb2NrKCkuDQpOb3cg
aXQgbWlnaHQgYmUgdGhhdCB0aGVyZSBpcyBzb21lIG90aGVyIHN0YXRlIHRoYXQgaXMNCmFscmVh
ZHkgc2V0IC0gaW4gd2hpY2ggY2FzZSB5b3Ugb25seSBuZWVkIHRvIHdhaXQgZm9yIHRoZQ0Kc3Bp
bl9sb2NrIHRvIGJlIHJlbGVhc2VkIC0gc2luY2UgaXQgY2FuJ3QgYmUgb2J0YWluZWQgYWdhaW4N
Cih0byBzdGFydCB0aGUgdGltZXIpLg0KDQpTbyBJJ2QgZXhwZWN0IHRvIHNlZToNCglzcGluX2xv
Y2soKTsNCglpZiAobm90aGluZ19zZXRfZWFybGllcikNCgkJeHBydC0+ZGVzdHJveWluZyA9IDE7
DQoJc3Bpbl91bmxvY2soKQ0KCWRlbF90aW1lcl9zeW5jKCk7DQoNCkxvb2tpbmcgYXQgdGhlIGNv
ZGUgKGZvciBhIGNoYW5nZSkgaXMgbG9va3MgZXZlbiB3b3JzZS4NCg0KZGVsX3RpbWVyX3N5bmMo
KSBpc24ndCBhbnl3aGVyZSBuZWFyIGVub3VnaC4NCkFsbCB0aGUgdGltZXIgY2FsbGJhY2sgZnVu
Y3Rpb24gZG9lcyBpcyBzY2hlZHVsZSBzb21lIHdvcmsuDQpTbyB5b3UgYWxzbyBuZWVkIHRvIHdh
aXQgZm9yIHRoZSB3b3JrIHRvIGNvbXBsZXRlLg0KDQpDaGFuZ2luZyBpdCBhbGwgdG8gdXNlIGRl
bGF5ZWRfd29yayBtaWdodCByZWR1Y2UgdGhlIHByb2JsZW1zLg0KDQpPaCwgYW55IHVzaW5nIHBy
b3BlciBtdXRleC9sb2NrcyBpbnN0ZWFkIG9mIHdhaXRfb25fYml0X2xvY2soKS4NCg0KCURhdmlk
DQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBG
YXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2
IChXYWxlcykNCg==

