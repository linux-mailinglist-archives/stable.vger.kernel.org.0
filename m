Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E9154DE3FC
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 23:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241281AbiCRWaC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 18:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233444AbiCRWaB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 18:30:01 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B554E15DA9D
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 15:28:41 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-308-tJXXIe7QOkm1qFX-LQUFdA-1; Fri, 18 Mar 2022 22:28:38 +0000
X-MC-Unique: tJXXIe7QOkm1qFX-LQUFdA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.32; Fri, 18 Mar 2022 22:28:38 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.033; Fri, 18 Mar 2022 22:28:37 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Juergen Gross' <jgross@suse.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "platform-driver-x86@vger.kernel.org" 
        <platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Dell.Client.Kernel@dell.com" <Dell.Client.Kernel@dell.com>
CC:     Stuart Hayes <stuart.w.hayes@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] platform/x86/dell: add buffer allocation/free functions
 for SMI calls
Thread-Topic: [PATCH] platform/x86/dell: add buffer allocation/free functions
 for SMI calls
Thread-Index: AQHYOto/hyLOp/NEJ0S+JLWvPC30KazFQPKggAAbeICAAFvP8A==
Date:   Fri, 18 Mar 2022 22:28:37 +0000
Message-ID: <f04348c83155404c8ae4c8e5c3abedf2@AcuMS.aculab.com>
References: <20220318150950.16843-1-jgross@suse.com>
 <accf95548a8c4374b17c159b9b2d0098@AcuMS.aculab.com>
 <2a4573e0-4a8d-52c1-d29b-66b13bfe376f@suse.com>
In-Reply-To: <2a4573e0-4a8d-52c1-d29b-66b13bfe376f@suse.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogSnVlcmdlbiBHcm9zcw0KPiBTZW50OiAxOCBNYXJjaCAyMDIyIDE2OjU2DQo+IA0KPiBP
biAxOC4wMy4yMiAxNjoyMiwgRGF2aWQgTGFpZ2h0IHdyb3RlOg0KPiA+IEZyb206IEp1ZXJnZW4g
R3Jvc3MNCj4gPj4gU2VudDogMTggTWFyY2ggMjAyMiAxNToxMA0KPiA+Pg0KPiA+PiBUaGUgZGNk
YmFzIGRyaXZlciBpcyB1c2VkIHRvIGNhbGwgU01JIGhhbmRsZXJzIGZvciBib3RoLCBkY2RiYXMg
YW5kDQo+ID4+IGRlbGwtc21iaW9zLXNtbS4gQm90aCBkcml2ZXJzIGFsbG9jYXRlIGEgYnVmZmVy
IGZvciBjb21tdW5pY2F0aW5nDQo+ID4+IHdpdGggdGhlIFNNSSBoYW5kbGVyLiBUaGUgcGh5c2lj
YWwgYnVmZmVyIGFkZHJlc3MgaXMgdGhlbiBwYXNzZWQgdG8NCj4gPj4gdGhlIGNhbGxlZCBTTUkg
aGFuZGxlciB2aWEgJWVieC4NCj4gPj4NCj4gPj4gVW5mb3J0dW5hdGVseSB0aGlzIGRvZXNuJ3Qg
d29yayB3aGVuIHJ1bm5pbmcgaW4gWGVuIGRvbTAsIGFzIHRoZQ0KPiA+PiBwaHlzaWNhbCBhZGRy
ZXNzIG9idGFpbmVkIHZpYSB2aXJ0X3RvX3BoeXMoKSBpcyBvbmx5IGEgZ3Vlc3QgcGh5c2ljYWwN
Cj4gPj4gYWRkcmVzcywgYW5kIG5vdCBhIG1hY2hpbmUgcGh5c2ljYWwgYWRkcmVzcyBhcyBuZWVk
ZWQgYnkgU01JLg0KPiA+DQo+ID4gVGhlIHBoeXNpY2FsIGFkZHJlc3MgZnJvbSB2aXJ0X3RvX3Bo
eSgpIGlzIGFsd2F5cyB3cm9uZy4NCj4gPiBUaGF0IGlzIHRoZSBwaHlzaWNhbCBhZGRyZXNzIHRo
ZSBjcHUgaGFzIGZvciB0aGUgbWVtb3J5Lg0KPiA+IFdoYXQgeW91IHdhbnQgaXMgdGhlIGFkZHJl
c3MgdGhlIGRtYSBtYXN0ZXIgaW50ZXJmYWNlIG5lZWRzIHRvIHVzZS4NCj4gPiBUaGF0IGNhbiBi
ZSBkaWZmZXJlbnQgZm9yIGEgcGh5c2ljYWwgc3lzdGVtIC0gbm8gbmVlZCBmb3IgdmlydHVhbGlz
YXRpb24uDQo+ID4NCj4gPiBPbiB4ODYgdGhleSBkbyB1c3VhbGx5IG1hdGNoLCBidXQgYW55dGhp
bmcgd2l0aCBhIGZ1bGwgaW9tbXUNCj4gPiB3aWxsIG5lZWQgY29tcGxldGVseSBkaWZmZXJlbnQg
YWRkcmVzc2VzLg0KPiANCj4gWWVzLCB0aGFua3MgZm9yIHJlbWluZGluZyBtZSBvZiB0aGF0Lg0K
PiANCj4gVGhlIFNNSSBoYW5kbGVyIGlzIHJ1bm5pbmcgb24gdGhlIGNwdSwgcmlnaHQ/IFNvIHVz
aW5nIHRoZSBETUENCj4gYWRkcmVzcyBpcyB3cm9uZyBpbiBjYXNlIG9mIGFuIElPTU1VLiBJIHJl
YWxseSBuZWVkIHRoZSBtYWNoaW5lDQo+IHBoeXNpY2FsIGFkZHJlc3MuDQoNClRoYXQgb3VnaHQg
dG8gYmUgaGFuZGxlZCBieSB0aGUgJ2RldicgcGFyYW1ldGVyIHRvIGRtYV9hbGxvY19jb2hlcmVu
dCgpLg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5
IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRp
b24gTm86IDEzOTczODYgKFdhbGVzKQ0K

