Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 912A528E627
	for <lists+stable@lfdr.de>; Wed, 14 Oct 2020 20:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729462AbgJNSRN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Oct 2020 14:17:13 -0400
Received: from mail-co1nam11on2104.outbound.protection.outlook.com ([40.107.220.104]:48793
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727114AbgJNSRN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Oct 2020 14:17:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mJeZR1HxidMhgpNRdxG0LVsqh/+HY5uwutt4QFbyTry7zaKLc4pam+0a6IKjIz5Yn+XQtnbThXTRwD92yKA0VmhhDliaNVbCnl9carAfShJCbRkJ9lt47yWvRh7voRbvLMPKQ3t9bmKH7Pt7PJ5oj0DDlzdIyziCbSrWEGGoZQKzkDW3G2e6amL1KS2KQtyE8QgpWmpC3N2j4dcuuBL24kx7PQwcUDL62UwwLyrfELKP+TYEaR24TeJLBx+EEob6kgi8UhZEMvaf010R6VnNUzruJ7o9CISofLkVr0Z8ct1A3w5rTd4hrmfBYPhXqRFgjDeX4SloIFF+Jx2CvZazcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vuwuZ7Ow/70Tk/xZiDO3Y9Yb6RbPkbqSK2pMVmeaWJA=;
 b=efXCbujDDcDhKBZXd5ts9cTjJ/L54trMS748bvpxIde8jUHSGwWzEdMU7N+vm86PuOXUcCb6tTnPVmUFTIHzbZhwcxd/pqJM8oKX267qkcke8MNlIWj+Y8HvBR52xH4vrtXrb8xv6OGGIjYQ0v/rnF9GqJ9p9+OBUXmCqiXryEEnrkJMnZTgvDXSlZGw9VPemJnp+P+8Pw9msU2hKENMF9dZ9d/naOxWAUi+TwNoYilWo1T0AG61zeeeUJ7mZnsx4QkvJ0qCiuxl4o6yIH+zZaVsH9ZZqV/EPaXtpmb5Lo1TsXElzcdJwRRYp22O29wguYwCDM+Wz3/FMut+N6nMwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hammerspace.com; dmarc=pass action=none
 header.from=hammerspace.com; dkim=pass header.d=hammerspace.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hammerspace.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vuwuZ7Ow/70Tk/xZiDO3Y9Yb6RbPkbqSK2pMVmeaWJA=;
 b=VO+gIhrpWOVj3dpcUxTTWZHZ9WyhgSgCYsqaZM5F5F+yM+P77g6ICWJnwJINmK/WUKtJC7AqNwqrzX5MGccUN9p5D4g86suPjy3vweq5paUlW9fX3Huu5PYr/hX9EuUwDmpU3IpXy0dFsaRyb1x8S0K9ifCjfXmTMsrmnjfV600=
Received: from MN2PR13MB3957.namprd13.prod.outlook.com (2603:10b6:208:263::11)
 by MN2PR13MB3664.namprd13.prod.outlook.com (2603:10b6:208:19f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.11; Wed, 14 Oct
 2020 18:17:10 +0000
Received: from MN2PR13MB3957.namprd13.prod.outlook.com
 ([fe80::e8a1:6acc:70f0:ef39]) by MN2PR13MB3957.namprd13.prod.outlook.com
 ([fe80::e8a1:6acc:70f0:ef39%7]) with mapi id 15.20.3477.019; Wed, 14 Oct 2020
 18:17:10 +0000
From:   Trond Myklebust <trondmy@hammerspace.com>
To:     "ashishsangwan2@gmail.com" <ashishsangwan2@gmail.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "anna.schumaker@netapp.com" <anna.schumaker@netapp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] NFS: Fix mode bits and nlink count for v4 referral dirs
Thread-Topic: [PATCH] NFS: Fix mode bits and nlink count for v4 referral dirs
Thread-Index: AQHWm/OGeyO0BuEaoUK9JXx6hV8a+KmXdI6A
Date:   Wed, 14 Oct 2020 18:17:10 +0000
Message-ID: <2d1ff3421a88ece2f1b7708cdbc9d34b00ad3e81.camel@hammerspace.com>
References: <20201006151456.20875-1-ashishsangwan2@gmail.com>
In-Reply-To: <20201006151456.20875-1-ashishsangwan2@gmail.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=hammerspace.com;
x-originating-ip: [68.36.133.222]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 933ea864-fc25-4606-4177-08d8706d5e26
x-ms-traffictypediagnostic: MN2PR13MB3664:
x-microsoft-antispam-prvs: <MN2PR13MB366440BB1935CD5734548D8CB8050@MN2PR13MB3664.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xENKoglYRxSlqiZQNYThvFgmovMqelpij45DZg2UVWVTt9ejAzwDqqFvnSvLiw9TBAwPaJ5fVm+UIeCHtNoN5WnN+klk9MdzmQvdeZ0vALCWfVfcC8dq7+9DGwE2qryf0G2py0vA7ys96TfAhTOmY4zTbvaRelpOCk4nn3wGbiRwJVt6CNztIsWJR+kOO1HPtqFJuZJbWibR1ACCLJx+664rU1uo4ExmrZhy1TAPLkDK7xnmP651Befk/cx4eK1Q33E2nv8/0zOxofFFPJlbPbdYIFKDQOIEq1DBPwiE1KHkUYI2VKCiHtCqGu6S2Ypbdw9uhJQ2WgLZmW/OTczW4w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR13MB3957.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(376002)(346002)(396003)(39840400004)(6512007)(478600001)(36756003)(26005)(76116006)(66446008)(66946007)(66556008)(6506007)(71200400001)(66476007)(186003)(91956017)(64756008)(6486002)(2906002)(5660300002)(86362001)(4326008)(8936002)(54906003)(2616005)(6916009)(8676002)(316002)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: DGCEdl/E6g+mz54uuOY96gdSvzx1qvLj/R1X2K9jQ6j2WxwYWwaJPf3wIBUpuiuwP5257fZwxRJsmojsEFaN5fPEZ/rc1buc5x3F2C74ead6Yorq3n8WY4P53cZQBa/JAbMdGpvdWqq+241FBChSTU3lbhTiA92ehEEzy2l2C72rBeedBD/Ap3vMpjm7NcgvMw07i4o/xQaQInmsweU41R7sbSU9wv9EyO5aNn90DTynA36PWLaHSkI6oTVLqFPp/glV93vPwQrC7/5PkVMtOAIr/JrMMJ48i7AcyWI1XDNowUMvdU//8c3PM4FyxwS3nCKc6/cFWH5opUSFmCQvQl4tjw8UrxJJ6ZGb6+QvyAy2KRDxRd/dHFzH8HjCEZc9fv/TtahDtjW66MKGmWWQciXxvEobxnP+5FoY65VYUa3H7utdT8OZc/gZzYMqgq0CitrtrxfUzebzrTPfJvSX/pTSHfHSIJQaS9k9aeKLM+UFJVXAmg9BPPux3yUYRJ8AnYprdllZT4BgaKQoIcjqdcEFKC3gpKAKyZpaDGixE8AstWP90mJFPLqRRaRPf1Mkwpi82KQRS+XjSz8SBHGgnEqOqPrEQVmChQ2zLsjzhYjAx0NrO5xLqmYSWHvn88RRAGvFujo/wzOgVmiJ2QhtjA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <3ED7695FE3950145B1706F4287A85DA5@namprd13.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: hammerspace.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR13MB3957.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 933ea864-fc25-4606-4177-08d8706d5e26
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2020 18:17:10.5878
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0d4fed5c-3a70-46fe-9430-ece41741f59e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GLcssNSdHlNX/8+irl7sd17Bm9YsLKR3Ha94WUDElKCXawiumR6meFD5FAxPQvWty5IUgJwD3yc/MRki3IkTGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3664
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVHVlLCAyMDIwLTEwLTA2IGF0IDA4OjE0IC0wNzAwLCBBc2hpc2ggU2FuZ3dhbiB3cm90ZToN
Cj4gUmVxdWVzdCBmb3IgbW9kZSBiaXRzIGFuZCBubGluayBjb3VudCBpbiB0aGUgbmZzNF9nZXRf
cmVmZXJyYWwgY2FsbA0KPiBhbmQgaWYgc2VydmVyIHJldHVybnMgdGhlbSB1c2UgdGhlbSBpbnN0
ZWFkIG9mIGhhcmQgY29kZWQgdmFsdWVzLg0KPiANCj4gQ0M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5v
cmcNCj4gU2lnbmVkLW9mZi1ieTogQXNoaXNoIFNhbmd3YW4gPGFzaGlzaHNhbmd3YW4yQGdtYWls
LmNvbT4NCj4gLS0tDQo+ICBmcy9uZnMvbmZzNHByb2MuYyB8IDIwICsrKysrKysrKysrKysrKysr
LS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgMTcgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkN
Cj4gDQo+IGRpZmYgLS1naXQgYS9mcy9uZnMvbmZzNHByb2MuYyBiL2ZzL25mcy9uZnM0cHJvYy5j
DQo+IGluZGV4IDZlOTVjODVmZTM5NS4uZWZlYzA1YzVmNTM1IDEwMDY0NA0KPiAtLS0gYS9mcy9u
ZnMvbmZzNHByb2MuYw0KPiArKysgYi9mcy9uZnMvbmZzNHByb2MuYw0KPiBAQCAtMjY2LDcgKzI2
Niw5IEBAIGNvbnN0IHUzMiBuZnM0X2ZzX2xvY2F0aW9uc19iaXRtYXBbM10gPSB7DQo+ICAJfCBG
QVRUUjRfV09SRDBfRlNJRA0KPiAgCXwgRkFUVFI0X1dPUkQwX0ZJTEVJRA0KPiAgCXwgRkFUVFI0
X1dPUkQwX0ZTX0xPQ0FUSU9OUywNCj4gLQlGQVRUUjRfV09SRDFfT1dORVINCj4gKwlGQVRUUjRf
V09SRDFfTU9ERQ0KPiArCXwgRkFUVFI0X1dPUkQxX05VTUxJTktTDQo+ICsJfCBGQVRUUjRfV09S
RDFfT1dORVINCj4gIAl8IEZBVFRSNF9XT1JEMV9PV05FUl9HUk9VUA0KPiAgCXwgRkFUVFI0X1dP
UkQxX1JBV0RFVg0KPiAgCXwgRkFUVFI0X1dPUkQxX1NQQUNFX1VTRUQNCj4gQEAgLTc1OTQsMTYg
Kzc1OTYsMjggQEAgbmZzNF9saXN0eGF0dHJfbmZzNF91c2VyKHN0cnVjdCBpbm9kZSAqaW5vZGUs
DQo+IGNoYXIgKmxpc3QsIHNpemVfdCBsaXN0X2xlbikNCj4gICAqLw0KPiAgc3RhdGljIHZvaWQg
bmZzX2ZpeHVwX3JlZmVycmFsX2F0dHJpYnV0ZXMoc3RydWN0IG5mc19mYXR0ciAqZmF0dHIpDQo+
ICB7DQo+ICsJYm9vbCBmaXhfbW9kZSA9IHRydWUsIGZpeF9ubGluayA9IHRydWU7DQo+ICsNCj4g
IAlpZiAoISgoKGZhdHRyLT52YWxpZCAmIE5GU19BVFRSX0ZBVFRSX01PVU5URURfT05fRklMRUlE
KSB8fA0KPiAgCSAgICAgICAoZmF0dHItPnZhbGlkICYgTkZTX0FUVFJfRkFUVFJfRklMRUlEKSkg
JiYNCj4gIAkgICAgICAoZmF0dHItPnZhbGlkICYgTkZTX0FUVFJfRkFUVFJfRlNJRCkgJiYNCj4g
IAkgICAgICAoZmF0dHItPnZhbGlkICYgTkZTX0FUVFJfRkFUVFJfVjRfTE9DQVRJT05TKSkpDQo+
ICAJCXJldHVybjsNCj4gIA0KPiArCWlmIChmYXR0ci0+dmFsaWQgJiBORlNfQVRUUl9GQVRUUl9N
T0RFKQ0KPiArCQlmaXhfbW9kZSA9IGZhbHNlOw0KPiArCWlmIChmYXR0ci0+dmFsaWQgJiBORlNf
QVRUUl9GQVRUUl9OTElOSykNCj4gKwkJZml4X25saW5rID0gZmFsc2U7DQo+ICAJZmF0dHItPnZh
bGlkIHw9IE5GU19BVFRSX0ZBVFRSX1RZUEUgfCBORlNfQVRUUl9GQVRUUl9NT0RFIHwNCj4gIAkJ
TkZTX0FUVFJfRkFUVFJfTkxJTksgfCBORlNfQVRUUl9GQVRUUl9WNF9SRUZFUlJBTDsNCj4gLQlm
YXR0ci0+bW9kZSA9IFNfSUZESVIgfCBTX0lSVUdPIHwgU19JWFVHTzsNCj4gLQlmYXR0ci0+bmxp
bmsgPSAyOw0KPiArDQo+ICsJaWYgKGZpeF9tb2RlKQ0KPiArCQlmYXR0ci0+bW9kZSA9IFNfSUZE
SVIgfCBTX0lSVUdPIHwgU19JWFVHTzsNCj4gKwllbHNlDQo+ICsJCWZhdHRyLT5tb2RlIHw9IFNf
SUZESVI7DQo+ICsNCj4gKwlpZiAoZml4X25saW5rKQ0KPiArCQlmYXR0ci0+bmxpbmsgPSAyOw0K
PiAgfQ0KPiAgDQo+ICBzdGF0aWMgaW50IF9uZnM0X3Byb2NfZnNfbG9jYXRpb25zKHN0cnVjdCBy
cGNfY2xudCAqY2xpZW50LCBzdHJ1Y3QNCj4gaW5vZGUgKmRpciwNCg0KTkFDSyB0byB0aGlzIHBh
dGNoLiBUaGUgd2hvbGUgcG9pbnQgaXMgdGhhdCBpZiB0aGUgc2VydmVyIGhhcyBhDQpyZWZlcnJh
bCwgdGhlbiBpdCBpcyBub3QgZ29pbmcgdG8gZ2l2ZSB1cyBhbnkgYXR0cmlidXRlcyBvdGhlciB0
aGFuIHRoZQ0Kb25lcyB3ZSdyZSBhbHJlYWR5IGFza2luZyBmb3IgYmVjYXVzZSBpdCBtYXkgbm90
IGV2ZW4gaGF2ZSBhIHJlYWwNCmRpcmVjdG9yeS4gVGhlIGNsaWVudCBpcyByZXF1aXJlZCB0byBm
YWtlIHVwIGFuIGlub2RlLCBoZW5jZSB0aGUNCmV4aXN0aW5nIGNvZGUuDQoNCi0tIA0KVHJvbmQg
TXlrbGVidXN0DQpMaW51eCBORlMgY2xpZW50IG1haW50YWluZXIsIEhhbW1lcnNwYWNlDQp0cm9u
ZC5teWtsZWJ1c3RAaGFtbWVyc3BhY2UuY29tDQoNCg0K
