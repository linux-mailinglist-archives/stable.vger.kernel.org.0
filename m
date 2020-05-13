Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAEE91D0BB5
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730432AbgEMJQM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:16:12 -0400
Received: from mo-csw1114.securemx.jp ([210.130.202.156]:55616 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730334AbgEMJQL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 May 2020 05:16:11 -0400
Received: by mo-csw.securemx.jp (mx-mo-csw1114) id 04D9FwEQ032415; Wed, 13 May 2020 18:15:58 +0900
X-Iguazu-Qid: 2wHHK1VZq0MdxNVqxG
X-Iguazu-QSIG: v=2; s=0; t=1589361358; q=2wHHK1VZq0MdxNVqxG; m=U188YTmkK6swnOrP0fHa+PKfx0IBgdbVjRM/pX6LVeI=
Received: from imx12.toshiba.co.jp (imx12.toshiba.co.jp [61.202.160.132])
        by relay.securemx.jp (mx-mr1110) id 04D9FvK9017231;
        Wed, 13 May 2020 18:15:57 +0900
Received: from enc02.toshiba.co.jp ([61.202.160.51])
        by imx12.toshiba.co.jp  with ESMTP id 04D9Fu4A012837;
        Wed, 13 May 2020 18:15:56 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id 04D9Fu7d004079;
        Wed, 13 May 2020 18:15:56 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i5gvQ7w8wn6MIORV73609Xq3kRIoZrenlgsuJKz2mCJtLRGd8Y0EKh+WdbqMOPYIqjLZUUtcUFeuRXFJJozQ2FtaWuFTvrRHkjmBkVUOy6ikvb58pCfR8pFSy+TSlgYor3vE2mhdrdFRMg2Wdfs0FT5JmjVC6g07ONRFSYvLBg7CaxU8t/ABf8WR7Bo2smIbK4nTo/6HbOFF6EHPxi6wTVWfYXAs50Ch2mtVBpKa0Y9GgQIzsVyH/4hSOYVvc00GwSAJ1bTa2U+IRbqSUfDkUNXAJ5nCAULnNGSQ0lMpC2CNS6UNCivMdPthA4IQtwgMGh6HvYiT6LejXOT6QW8lSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SBYrWF6bJbTCVABQhlutOeFVluokv+kMnFn/Ab+IDtk=;
 b=C614d5ao+EkAOFf9kYO2GTupYh4ylU/JgcHfZruxrDVaReUEYAviq2BJ+/PZ7XGgKtg+sk+c8kMem4p8sg+gPQ30heCQoFoufPr5Ywrzov+wWdnjQ1Oyebi99+sDiqoFoPmcKYd2f5PLu2C1vVRgoz/vEmSQgMz4YTcZQGn7Ah4dgPu80NHBKrKH4vnty9pNvN5E26WHhijcZa7KwMZ02J+/ZuQ5Ev+ae5rC4BYb88mGkxgAFntYiTdzSPeti39oGWCmu3jgOXdJjeEI3s1Zmg0fnQpuzcrpncTpx7LcXNSj6vr3VWm3QBD+XXtq81f6bs28a2uYtU5X/E4eSxH/cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toshiba.co.jp; dmarc=pass action=none
 header.from=toshiba.co.jp; dkim=pass header.d=toshiba.co.jp; arc=none
From:   <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     <nobuhiro1.iwamatsu@toshiba.co.jp>, <stable@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>, <dsa@cumulusnetworks.com>,
        <andreyknvl@google.com>, <davem@davemloft.net>
Subject: RE: [PATCH] net: handle no dst on skb in icmp6_send
Thread-Topic: [PATCH] net: handle no dst on skb in icmp6_send
Thread-Index: AQHWKQWdZ2fNG6diaESTInRFdsC6pailu1Lw
Date:   Wed, 13 May 2020 09:15:34 +0000
X-TSB-HOP: ON
Message-ID: <OSBPR01MB29839259893D8DD04E08B61F92BF0@OSBPR01MB2983.jpnprd01.prod.outlook.com>
References: <20200513090451.939095-1-nobuhiro1.iwamatsu@toshiba.co.jp>
In-Reply-To: <20200513090451.939095-1-nobuhiro1.iwamatsu@toshiba.co.jp>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
authentication-results: toshiba.co.jp; dkim=none (message not signed)
 header.d=none;toshiba.co.jp; dmarc=none action=none
 header.from=toshiba.co.jp;
x-originating-ip: [103.91.184.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e498eee0-6c22-404a-4ad7-08d7f71e312f
x-ms-traffictypediagnostic: OSBPR01MB3208:
x-ld-processed: f109924e-fb71-4ba0-b2cc-65dcdf6fbe4f,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSBPR01MB3208F80FB249843402F971BB92BF0@OSBPR01MB3208.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1824;
x-forefront-prvs: 0402872DA1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: u+HyfGCDnZaIsMw0S92MzSnx9nE9RHz9KE7VRbZ3GXIuh2JoT97hP0xMAQIgB4GKDhKZgB2HsJ0GhI4m3dz7TBVsKAH69SR6kIfsLBmfAG4SrIEqXaIknPcsqrzVwcIZaS8opJhS0NELXzgyZQYmk13j0P8xzT0EgnxWNYoXGAFvZT6nZARHIBdCQk8vlhzwoX9igBMQudkq6O4n9wVQiAJKXzQUoKeDRK8XWMkV/TSq1GqE877zHdEtstpgtc7ry0MWwIVh0EQiw7Hn+WLX7PMsReqYi5Sg3Kghv8ny5IFOIZk8WQRtQOqZa+MaDHs274fKQjEvyyUe9PJlbWjLZvacPQyo7BsgwtyY11+kEhcaSuNYkxBsF7mzSQ4CP5rmRmxpdPdvuD2+5zpDxtaL6ZlJtiN9GQKhMU2ptFnuBA1ASCSyFlq/1EP3sofFIfX2asmFvrHKnzFsBIueBHAEpdTgU7d6Vm4CUH4sxShQiVQqR4n54SbUWIdg8bOd9Y9FfV5p7dE1JlFqGXx73NUY1g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSBPR01MB2983.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(136003)(346002)(366004)(376002)(33430700001)(33656002)(45080400002)(55016002)(7696005)(9686003)(478600001)(86362001)(5660300002)(71200400001)(4326008)(8676002)(316002)(33440700001)(2906002)(52536014)(53546011)(6506007)(76116006)(66946007)(186003)(64756008)(66446008)(66556008)(8936002)(54906003)(110136005)(26005)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: nLgdZx66MQa/n5x44tclD3xEjVNL8g05mDaa1KLGmuXhxbGLphYU8rzrvyOUjlPj3gS7lK9HhkCXfKEtOhb3b4OTPojl42PyqWi0CQ2/hd9lqNte9w5SD39udcp+mt9HIU1QtTSdcR/Wt4flTONnlfBoQogO1ThuwBBhX7U92A/TnlCtk5CTFIzQKRyzinvOXaR5mRiO6LXXtFS4xbdVrjO9XmeUr6AZwgP9abaf7+YTEfabFp3x4OuYo+qR8+tlch/SKvD8pHDrxIp6M/NtCLiUyBh+MsXIm+TBRztPOqfuJcvSdwN6GziT8VNcb/VvtPF7jW+P6qxNekQQm0GgWqPqerWy+BYKdeWmqy5EVGMjzHl8zHdh0X9mUOWnwAUpU/bR4lP84QrpT47oWm7/2R9ITU4WBV3IIYvNS2e32RVHqGBfVBxYXTcp8RZqaYO4aXArWSTO8TrQISuJLD4bJj9n4aIWfAXHMeURRZxUQDI=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e498eee0-6c22-404a-4ad7-08d7f71e312f
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2020 09:15:34.1827
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f109924e-fb71-4ba0-b2cc-65dcdf6fbe4f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u99Gjm1GdY0diycOcW2UhDeeHGbMt3jN5EBIoTr6tLwZ1AZsrsBasxtn5WjIXejBKNF75JoRTpOfXZuhyVeWOK5RPBoKUbsoRs3LWzBGnOT4F6I35ni+e2y5jnc9fgpB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB3208
X-OriginatorOrg: toshiba.co.jp
MSSCP.TransferMailToMossAgent: 103
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGksDQoNCkkgZm9yZ290IHRvIGFkZCB0aGUgdmVyc2lvbiB0byB0aGUgc3ViamVjdC4NClRoaXMg
aXMgYSBwYXRjaCB0byA0LjQueSBvbmx5LiBUaGlzIGlzIG5vdCBuZWVkZWQgZm9yIG90aGVyIGtl
cm5lbHMuDQoNCkJlc3QgcmVnYXJkcywNCiAgTm9idWhpcm8NCg0KPiAtLS0tLU9yaWdpbmFsIE1l
c3NhZ2UtLS0tLQ0KPiBGcm9tOiBOb2J1aGlybyBJd2FtYXRzdSBbbWFpbHRvOm5vYnVoaXJvMS5p
d2FtYXRzdUB0b3NoaWJhLmNvLmpwXQ0KPiBTZW50OiBXZWRuZXNkYXksIE1heSAxMywgMjAyMCA2
OjA1IFBNDQo+IFRvOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+IENjOiBncmVna2hAbGludXhm
b3VuZGF0aW9uLm9yZzsgRGF2aWQgQWhlcm4gPGRzYUBjdW11bHVzbmV0d29ya3MuY29tPjsgQW5k
cmV5IEtvbm92YWxvdiA8YW5kcmV5a252bEBnb29nbGUuY29tPjsNCj4gRGF2aWQgUyAuIE1pbGxl
ciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IGl3YW1hdHN1IG5vYnVoaXJvKOWyqeadviDkv6HmtIsg
4pah77yz77y377yj4pev77yh77yj77y0KQ0KPiA8bm9idWhpcm8xLml3YW1hdHN1QHRvc2hpYmEu
Y28uanA+DQo+IFN1YmplY3Q6IFtQQVRDSF0gbmV0OiBoYW5kbGUgbm8gZHN0IG9uIHNrYiBpbiBp
Y21wNl9zZW5kDQo+IA0KPiBGcm9tOiBEYXZpZCBBaGVybiA8ZHNhQGN1bXVsdXNuZXR3b3Jrcy5j
b20+DQo+IA0KPiBjb21taXQgNzlkYzdlM2YxY2QzMjNiZTRjODFhYTFhOTRmYWExYjNlZDk4N2Zi
MiB1cHN0cmVhbS4NCj4gDQo+IEFuZHJleSByZXBvcnRlZCB0aGUgZm9sbG93aW5nIHdoaWxlIGZ1
enppbmcgdGhlIGtlcm5lbCB3aXRoIHN5emthbGxlcjoNCj4gDQo+IGthc2FuOiBDT05GSUdfS0FT
QU5fSU5MSU5FIGVuYWJsZWQNCj4ga2FzYW46IEdQRiBjb3VsZCBiZSBjYXVzZWQgYnkgTlVMTC1w
dHIgZGVyZWYgb3IgdXNlciBtZW1vcnkgYWNjZXNzDQo+IGdlbmVyYWwgcHJvdGVjdGlvbiBmYXVs
dDogMDAwMCBbIzFdIFNNUCBLQVNBTg0KPiBNb2R1bGVzIGxpbmtlZCBpbjoNCj4gQ1BVOiAwIFBJ
RDogMzg1OSBDb21tOiBhLm91dCBOb3QgdGFpbnRlZCA0LjkuMC1yYzYrICM0MjkNCj4gSGFyZHdh
cmUgbmFtZTogUUVNVSBTdGFuZGFyZCBQQyAoaTQ0MEZYICsgUElJWCwgMTk5NiksIEJJT1MgQm9j
aHMgMDEvMDEvMjAxMQ0KPiB0YXNrOiBmZmZmODgwMDY2NmQ0MjAwIHRhc2suc3RhY2s6IGZmZmY4
ODAwNjczNDgwMDANCj4gUklQOiAwMDEwOls8ZmZmZmZmZmY4MzM2MTdlYz5dICBbPGZmZmZmZmZm
ODMzNjE3ZWM+XQ0KPiBpY21wNl9zZW5kKzB4NWZjLzB4MWUzMCBuZXQvaXB2Ni9pY21wLmM6NDUx
DQo+IFJTUDogMDAxODpmZmZmODgwMDY3MzRmMmMwICBFRkxBR1M6IDAwMDEwMjA2DQo+IFJBWDog
ZmZmZjg4MDA2NjZkNDIwMCBSQlg6IDAwMDAwMDAwMDAwMDAwMDAgUkNYOiAwMDAwMDAwMDAwMDAw
MDAwDQo+IFJEWDogMDAwMDAwMDAwMDAwMDAwMCBSU0k6IGRmZmZmYzAwMDAwMDAwMDAgUkRJOiAw
MDAwMDAwMDAwMDAwMDE4DQo+IFJCUDogZmZmZjg4MDA2NzM0ZjYzMCBSMDg6IGZmZmY4ODAwNjQx
Mzg0MTggUjA5OiAwMDAwMDAwMDAwMDAwMDAzDQo+IFIxMDogZGZmZmZjMDAwMDAwMDAwMCBSMTE6
IDAwMDAwMDAwMDAwMDAwMDUgUjEyOiAwMDAwMDAwMDAwMDAwMDAwDQo+IFIxMzogZmZmZmZmZmY4
NGU3ZTIwMCBSMTQ6IGZmZmY4ODAwNjQxMzg0ODQgUjE1OiBmZmZmODgwMDY0MTM4M2MwDQo+IEZT
OiAgMDAwMDdmYjM4ODdhMDdjMCgwMDAwKSBHUzpmZmZmODgwMDZjYzAwMDAwKDAwMDApIGtubEdT
OjAwMDAwMDAwMDAwMDAwMDANCj4gQ1M6ICAwMDEwIERTOiAwMDAwIEVTOiAwMDAwIENSMDogMDAw
MDAwMDA4MDA1MDAzMw0KPiBDUjI6IDAwMDAwMDAwMjAwMDAwMDAgQ1IzOiAwMDAwMDAwMDZiMDQw
MDAwIENSNDogMDAwMDAwMDAwMDAwMDZmMA0KPiBTdGFjazoNCj4gIGZmZmY4ODAwNjY2ZDQyMDAg
ZmZmZjg4MDA2NjZkNDlmOCBmZmZmODgwMDY2NmQ0MjAwIGZmZmZmZmZmODRjMDI0NjANCj4gIGZm
ZmY4ODAwNjY2ZDRhMWEgMWZmZmYxMDAwY2NkYWEyZiBmZmZmODgwMDY3MzRmNDk4IDAwMDAwMDAw
MDAwMDAwNDYNCj4gIGZmZmY4ODAwNjczNGY0NDAgZmZmZmZmZmY4MzJmNDI2OSBmZmZmODgwMDY0
YmE3NDU2IDAwMDAwMDAwMDAwMDAwMDANCj4gQ2FsbCBUcmFjZToNCj4gIFs8ZmZmZmZmZmY4MzM2
NGRkYz5dIGljbXB2Nl9wYXJhbV9wcm9iKzB4MmMvMHg0MCBuZXQvaXB2Ni9pY21wLmM6NTU3DQo+
ICBbPCAgICAgaW5saW5lICAgICA+XSBpcDZfdGx2b3B0X3Vua25vd24gbmV0L2lwdjYvZXh0aGRy
cy5jOjg4DQo+ICBbPGZmZmZmZmZmODMzOTQ0MDU+XSBpcDZfcGFyc2VfdGx2KzB4NTU1LzB4Njcw
IG5ldC9pcHY2L2V4dGhkcnMuYzoxNTcNCj4gIFs8ZmZmZmZmZmY4MzM5YTc1OT5dIGlwdjZfcGFy
c2VfaG9wb3B0cysweDE5OS8weDQ2MCBuZXQvaXB2Ni9leHRoZHJzLmM6NjYzDQo+ICBbPGZmZmZm
ZmZmODMyZWU3NzM+XSBpcHY2X3JjdisweGZhMy8weDFkYzAgbmV0L2lwdjYvaXA2X2lucHV0LmM6
MTkxDQo+ICAuLi4NCj4gDQo+IGljbXA2X3NlbmQgLyBpY21wdjZfc2VuZCBpcyBpbnZva2VkIGZv
ciBib3RoIHJ4IGFuZCB0eCBwYXRocy4gSW4gYm90aA0KPiBjYXNlcyB0aGUgZHN0LT5kZXYgc2hv
dWxkIGJlIHByZWZlcnJlZCBmb3IgZGV0ZXJtaW5pbmcgdGhlIEwzIGRvbWFpbg0KPiBpZiB0aGUg
ZHN0IGhhcyBiZWVuIHNldCBvbiB0aGUgc2tiLiBGYWxsYmFjayB0byB0aGUgc2tiLT5kZXYgaWYg
aXQgaGFzDQo+IG5vdC4gVGhpcyBjb3ZlcnMgdGhlIGNhc2UgcmVwb3J0ZWQgaGVyZSB3aGVyZSBp
Y21wNl9zZW5kIGlzIGludm9rZWQgb24NCj4gUnggYmVmb3JlIHRoZSByb3V0ZSBsb29rdXAuDQo+
IA0KPiBGaXhlczogNWQ0MWNlMjllICgibmV0OiBpY21wNl9zZW5kIHNob3VsZCB1c2UgZHN0IGRl
diB0byBkZXRlcm1pbmUgTDMgZG9tYWluIikNCj4gUmVwb3J0ZWQtYnk6IEFuZHJleSBLb25vdmFs
b3YgPGFuZHJleWtudmxAZ29vZ2xlLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogRGF2aWQgQWhlcm4g
PGRzYUBjdW11bHVzbmV0d29ya3MuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBEYXZpZCBTLiBNaWxs
ZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+DQo+IFNpZ25lZC1vZmYtYnk6IE5vYnVoaXJvIEl3YW1h
dHN1IChDSVApIDxub2J1aGlybzEuaXdhbWF0c3VAdG9zaGliYS5jby5qcD4NCj4gLS0tDQo+ICBu
ZXQvaXB2Ni9pY21wLmMgfCA2ICsrKystLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9u
cygrKSwgMiBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9uZXQvaXB2Ni9pY21wLmMg
Yi9uZXQvaXB2Ni9pY21wLmMNCj4gaW5kZXggZDIxZTgxY2Q2MTIwZS4uZmE5NmUwNWNmMjJiZSAx
MDA2NDQNCj4gLS0tIGEvbmV0L2lwdjYvaWNtcC5jDQo+ICsrKyBiL25ldC9pcHY2L2ljbXAuYw0K
PiBAQCAtNDQ1LDggKzQ0NSwxMCBAQCBzdGF0aWMgdm9pZCBpY21wNl9zZW5kKHN0cnVjdCBza19i
dWZmICpza2IsIHU4IHR5cGUsIHU4IGNvZGUsIF9fdTMyIGluZm8pDQo+IA0KPiAgCWlmIChfX2lw
djZfYWRkcl9uZWVkc19zY29wZV9pZChhZGRyX3R5cGUpKQ0KPiAgCQlpaWYgPSBza2ItPmRldi0+
aWZpbmRleDsNCj4gLQllbHNlDQo+IC0JCWlpZiA9IGwzbWRldl9tYXN0ZXJfaWZpbmRleChza2Jf
ZHN0KHNrYiktPmRldik7DQo+ICsJZWxzZSB7DQo+ICsJCWRzdCA9IHNrYl9kc3Qoc2tiKTsNCj4g
KwkJaWlmID0gbDNtZGV2X21hc3Rlcl9pZmluZGV4KGRzdCA/IGRzdC0+ZGV2IDogc2tiLT5kZXYp
Ow0KPiArCX0NCj4gDQo+ICAJLyoNCj4gIAkgKglNdXN0IG5vdCBzZW5kIGVycm9yIGlmIHRoZSBz
b3VyY2UgZG9lcyBub3QgdW5pcXVlbHkNCj4gLS0NCj4gMi4yNi4wDQoNCg==
