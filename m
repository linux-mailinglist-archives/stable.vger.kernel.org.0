Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8A582F6775
	for <lists+stable@lfdr.de>; Thu, 14 Jan 2021 18:23:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725961AbhANRXy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jan 2021 12:23:54 -0500
Received: from mail-dm6nam10on2103.outbound.protection.outlook.com ([40.107.93.103]:33121
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725772AbhANRXx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Jan 2021 12:23:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jsdBMaNZAZ7UXanMuHnde0NVGaxGp+RHOouz6XYlO4pzb3E76aBXdLvt40kLG/f2M7hR9bd2pKA7Irv05tjkWxSnG734g9bW9Fai8hn0BZBVnney14PoX2Am7Jdf17wMj8l/kF9BEZaQOiL22ycqeXNuZHEbTGkxZf6Pga9EcypyHLgpXkNPKcz2d/+Jh5HIPPbWeeqpBLpbuvokKd8/SbAP0YFv6XTTXHBOpRcm0lj/F9txNYhR09NHbvUNr7epnXfWJMbXnIcfM3qpFHu3rh2fKYWeXK30uYwdxsG9y2LQ0ZkVcEyr9TmRfSvB/c/9cLN3SO198+saToAUMLBx0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KODLm510nGGF0McA5XDodzIbcZZAKh5ickK+crPXO84=;
 b=VNIjbVxE6y9OPsn/kd3tsG4L4MOmvj5k9WG4yK2YwdaOdZPgTGgeFpqXDGkUjTlO2MO5gue1qyJcFeDC6uK2/GRM+zewDg1GeDbdqFXSBudpGHsnXCj1MWX1pIswA+/relcRSkbd5jMBONHY44+wu7rO72PxuDov2a9LRK2oJOW6qGK4yMLw/J8VN3qk/5vJUWVhk51czfY4JgukTGHudH8y4wwwjPNMhsAH+WP7oWRbMbo3rUjDWohS1s8ANLy+WtZrQNq6MzW2Vj+ZhO9yYT6RKMZh+w5CGJWPMfLKoqxffDs4R7S+615PpRo2zhcQrRJGGFjxBGNL6EygL/XlsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KODLm510nGGF0McA5XDodzIbcZZAKh5ickK+crPXO84=;
 b=E8wI/6liGXa9YY6H5UNC0c1c9htUndewaLxlJbKS0g9zprEE3AxVs6mWJXHm26HCGWSLSUu7HcXH99msSQhBdCCuSBzGZzXFvgN5yELNhp7M8JHQJH/LLc20GqFXMjNKin4FZF8GjuAL3ZeKJQ5sI/znwo5wrKYS+J6zlSs60KY=
Received: from (2603:10b6:805:4::27) by
 SN6PR2101MB1773.namprd21.prod.outlook.com (2603:10b6:805:7::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.2; Thu, 14 Jan
 2021 17:22:59 +0000
Received: from SN6PR2101MB0974.namprd21.prod.outlook.com
 ([fe80::79ec:7ff0:9f3b:7513]) by SN6PR2101MB0974.namprd21.prod.outlook.com
 ([fe80::79ec:7ff0:9f3b:7513%6]) with mapi id 15.20.3784.003; Thu, 14 Jan 2021
 17:22:59 +0000
From:   Pavel Shilovskiy <pshilov@microsoft.com>
To:     Shyam Prasad N <nspmangalore@gmail.com>,
        Pavel Shilovsky <piastryyy@gmail.com>
CC:     pc <pc@cjr.nz>, linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Aurelien Aptel <aaptel@suse.com>,
        Duncan Findlay <duncf@duncf.ca>,
        Stable <stable@vger.kernel.org>
Subject: RE: [EXTERNAL] Re: [PATCH] cifs: fix interrupted close commands
Thread-Topic: [EXTERNAL] Re: [PATCH] cifs: fix interrupted close commands
Thread-Index: AQHW6dn8f85zeJ+u8k+AIH8tG0qbp6omuzMAgACkqKA=
Date:   Thu, 14 Jan 2021 17:22:59 +0000
Message-ID: <SN6PR2101MB0974D0EB5FFA26EB1128657EB6A89@SN6PR2101MB0974.namprd21.prod.outlook.com>
References: <CAH2r5msvYs4nLbje4vP+XNF_7SR=b5QehQ=t1WT4o=Ki6imPxg@mail.gmail.com>
 <20210113171616.11730-1-pc@cjr.nz>
 <CAKywueSoG8zCqmVgaOtvG5AM4fi47+bFJ3VdHPAa=sJa+v2duA@mail.gmail.com>
 <CANT5p=pBS9=Dd+=1dEtfV_9=reVgMqRcpv7rODxm6e8K3xBPOg@mail.gmail.com>
In-Reply-To: <CANT5p=pBS9=Dd+=1dEtfV_9=reVgMqRcpv7rODxm6e8K3xBPOg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=3b33cd43-898e-46ad-b79b-e19adbc1f44e;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-01-14T17:22:05Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [174.21.165.184]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a2f51894-b572-4363-2121-08d8b8b10a89
x-ms-traffictypediagnostic: SN6PR2101MB1773:
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <SN6PR2101MB1773B1C1A166D0F0AE570F97B6A89@SN6PR2101MB1773.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QSDCpXjih1rQBdWEagAlXQ6rLzv0tDp2AeYE4gBKWhxVntEvexB8voIDh4ShPhWtwKZx46q8UWc4CISwwH2oPjDcZaCvb746YN2WZX5/dmUtPWkaUjOlcJWXO5d2Sb5G/VC0cJJgOGZyFJ0RiroTa0MkMRNxv081y7MuWoOcfcZ7YP+hVS2HtdnwK9CRJ8+R4RWAQgy7dzuJ6Q996fuev0VCLbr1DIrO/L8/t8VZKq+caWEI54Z0c7aYDQMMsy+tr0nxkFs6cXeFILNprgBO4RRtf/E7jHh1z+/bCNIi8R3bt5OX/u12RnsdsplOhx/LZBxcQjyJkooXi2aAw3TV4IBHxnRjoUk2ru25wtBZhntbv2R3FNpERb4L5LKKTR9vsJ81V2+BjoS/sTMRm3RRcRKvHAucKWWtHJOah+MCvgr5bR1QCEh32PtVGK4tbWZRA0wNrfuyv+2eRYUwsXvSmFnKJ4YYFK8qTDW4GtnwC6fXurfrat3zHOwI3MSxhsclk5zutATSOrk4qu2PnOvvKQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR2101MB0974.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(396003)(376002)(366004)(39860400002)(26005)(2906002)(8936002)(6506007)(478600001)(7696005)(5660300002)(186003)(10290500003)(83380400001)(8990500004)(52536014)(8676002)(64756008)(316002)(76116006)(54906003)(66556008)(86362001)(66946007)(4326008)(33656002)(53546011)(66476007)(55016002)(71200400001)(66446008)(9686003)(82960400001)(110136005)(82950400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?a3RpNHJMakVNWktuNkFXQkt1ZkQxckhVd2FLVHJrRHJPTmNuTzlicUN6Sng2?=
 =?utf-8?B?VXVJYUcxUDRlTVBSZUF0cVBWTkZkdjNNM0tUZlIvcW0yeXBGZElDazg3ODVB?=
 =?utf-8?B?eWtpNlFPWktiYnRqYUdlSW9saVpFL3ZPb0pqamY0SlMvb2FaYUgydnlMaDFp?=
 =?utf-8?B?azFOTUhJUFVSSHJIUzVIMmdLaDZXQmFlaG1SamtueWZHVGRldEFOMTlmQ0Q1?=
 =?utf-8?B?ckV2YUxScnJWK0UrTi9XNHZNNFo4QXhtc1FnRndpMDNOVjZVKzVFNGhBV3Ay?=
 =?utf-8?B?aWVoYURDNkFvOTNDRE9zNTVoUjVEZFJKQTErZklZek5EVlVBQ0pSR3ZrZW80?=
 =?utf-8?B?TzNhTkg1N1RtK0dFaHZ3WUpNdnFHYnltbnRXbkMyaFhPVEIvQk9vWEc1UHM5?=
 =?utf-8?B?cE1vU1J4RSs5djd6Ky91Qjh3RlhRVE50RElubDI5SmpwM0pMM2VkV3l2SFlw?=
 =?utf-8?B?NjhCcE9PSm5IakEzK0l6Y0Z3OStnc1M2Wi9qZVg3TFF1QkZYOHJpekdYQkJ5?=
 =?utf-8?B?Q2pYMGE2dFV0bWl4Slo4Q0RlNlh2eThZdE56dC9Yc2VPY2pQTFpWSzAyK2g5?=
 =?utf-8?B?SmJpYzNLNXBhQzRMazk1N1dwRXFoQjNRZUFOOVN2ZDAxSGdEcGh4dExTMmlY?=
 =?utf-8?B?T1E5Z1hyazkzYjA3YVBqbXpieENySlRaMnA3TmQydUkzd1hKVm9MNUw5MnR6?=
 =?utf-8?B?R3NkbUhhYW01akh3YWZINVBXL29qWnVQbXRNS3R5Vlp2Q0F6WjUrR3JSQkZk?=
 =?utf-8?B?SlNWTXBOZmpzb1lzd0dnV2JxNytLWEZPYnJEaXluRmJHSEEwOCs3VEkvM0Ur?=
 =?utf-8?B?UlpsY1dhdGZkUWh1ZWg3OUpYMGdCVjhuZ1krMzlwTThqclFZM3lpYU9sdHBj?=
 =?utf-8?B?aVpRMXJMN1NCeEEwSksxNnIrdzN3Wis2d3M4WTJNVG9jNVlTQnZnK3pwdno3?=
 =?utf-8?B?WlFXelBEVk15UjhYU1ZBc044ZlN2cXhOZFgrSzNtOGNCRmEyUTV1b2tjMFFq?=
 =?utf-8?B?M2toRWJZdDJvMjBtYlhCWGNESjExcVNuRkFORm84OVZKMnNhT0ozczZETVFD?=
 =?utf-8?B?clNubHAxV1NtN091ZnlQalQzOFVCd01mUUpaTGhXYkZJVDQ4NkM1MkZOSkF5?=
 =?utf-8?B?YmU1NVA4RGN6bit3eC93VVkvSEpLbkkwTzJqbGdsRHNFRi9naTFoWXBweW1E?=
 =?utf-8?B?QkwwcnpJdWhybkw3dnlseG50M1NUeFp5amh3b3ZkeDlsdFlwRTkwSGRZV1k1?=
 =?utf-8?B?NE5lTVRoN2t3eHpVallVS3hyYjBJK2ZBN3dDKzFtRXBQKzY4WkpKOURGNko0?=
 =?utf-8?B?UnRja01MSFN5WCtvN2podjdCZ1I2Q0s3VHFZZVRxdnhhS1NPc0ovVElUOGho?=
 =?utf-8?B?S1dSWEFWMjA4QVNTL1gwSUswUTZTblVCenhOZ1hnZ2VudG50RTYwanZvRmNR?=
 =?utf-8?Q?WwiPygTi?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR2101MB0974.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2f51894-b572-4363-2121-08d8b8b10a89
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2021 17:22:59.7546
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N+ybYnPtPeGJsmZSCMAVS+rLdgokzGB25rXoEWB09HDW8RTYnU2fPF7VjLHje2ls9OqDk3ZdlsIien4Kha7ntg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR2101MB1773
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgU2h5YW0sDQoNCklzX2ludGVycnVwdF9lcnJvciBjb250YWlucyBhIGxpc3Qgb2YgZXJyb3Jz
IHRoYXQgY29ycmVzcG9uZCB0byBpbnRlcnJ1cHRlZCByZXF1ZXN0cyB0aGF0IGhhdmVuJ3QgbWFk
ZSBpdCB0byB0aGUgc2VydmVyLg0KDQpCZXN0IHJlZ2FyZHMsDQpQYXZlbCBTaGlsb3Zza3kNCg0K
LS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IFNoeWFtIFByYXNhZCBOIDxuc3BtYW5n
YWxvcmVAZ21haWwuY29tPiANClNlbnQ6IFdlZG5lc2RheSwgSmFudWFyeSAxMywgMjAyMSAxMToz
MyBQTQ0KVG86IFBhdmVsIFNoaWxvdnNreSA8cGlhc3RyeXl5QGdtYWlsLmNvbT4NCkNjOiBwYyA8
cGNAY2pyLm56PjsgbGludXgtY2lmcyA8bGludXgtY2lmc0B2Z2VyLmtlcm5lbC5vcmc+OyBTdGV2
ZSBGcmVuY2ggPHNtZnJlbmNoQGdtYWlsLmNvbT47IEF1cmVsaWVuIEFwdGVsIDxhYXB0ZWxAc3Vz
ZS5jb20+OyBEdW5jYW4gRmluZGxheSA8ZHVuY2ZAZHVuY2YuY2E+OyBQYXZlbCBTaGlsb3Zza2l5
IDxwc2hpbG92QG1pY3Jvc29mdC5jb20+OyBTdGFibGUgPHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc+
DQpTdWJqZWN0OiBbRVhURVJOQUxdIFJlOiBbUEFUQ0hdIGNpZnM6IGZpeCBpbnRlcnJ1cHRlZCBj
bG9zZSBjb21tYW5kcw0KDQpIaSBQYXVsbywNCg0KRG9lcyBpc19pbnRlcnJ1cHRfZXJyb3IgY29u
dGFpbiBhIGxpc3Qgb2YgYWxsIGVycm9ycyBmb3Igd2hpY2ggc2VydmVyIGNhbiBsZWF2ZSB0aGUg
ZmlsZSBoYW5kbGUgb3Blbj8NCldoYXQgYWJvdXQgRUFHQUlOPyBJIHNlZSB0aGF0IHRoZSBzZXJ2
ZXIgZXJyb3IgU1RBVFVTX1JFVFJZIG1hcHMgdG8gRUFHQUlOLg0KDQpSZWdhcmRzLA0KU2h5YW0N
Cg0KT24gVGh1LCBKYW4gMTQsIDIwMjEgYXQgMTI6MDEgQU0gUGF2ZWwgU2hpbG92c2t5IDxwaWFz
dHJ5eXlAZ21haWwuY29tPiB3cm90ZToNCj4NCj4g0YHRgCwgMTMg0Y/QvdCyLiAyMDIxINCzLiDQ
siAwOToxNiwgUGF1bG8gQWxjYW50YXJhIDxwY0BjanIubno+Og0KPiA+DQo+ID4gUmV0cnkgY2xv
c2UgY29tbWFuZCBpZiBpdCBnZXRzIGludGVycnVwdGVkIHRvIG5vdCBsZWFrIG9wZW4gaGFuZGxl
cyANCj4gPiBvbiB0aGUgc2VydmVyLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogUGF1bG8gQWxj
YW50YXJhIChTVVNFKSA8cGNAY2pyLm56Pg0KPiA+IFJlcG9ydGVkLWJ5OiBEdW5jYW4gRmluZGxh
eSA8ZHVuY2ZAZHVuY2YuY2E+DQo+ID4gU3VnZ2VzdGVkLWJ5OiBQYXZlbCBTaGlsb3Zza3kgPHBz
aGlsb3ZAbWljcm9zb2Z0LmNvbT4NCj4gPiBGaXhlczogNjk4OGE2MTlmNWI3ICgiY2lmczogYWxs
b3cgc3lzY2FsbHMgdG8gYmUgcmVzdGFydGVkIGluIA0KPiA+IF9fc21iX3NlbmRfcnFzdCgpIikN
Cj4gPiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KPiA+IC0tLQ0KPiA+ICBmcy9jaWZzL3Nt
YjJwZHUuYyB8IDIgKy0NCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRl
bGV0aW9uKC0pDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvZnMvY2lmcy9zbWIycGR1LmMgYi9mcy9j
aWZzL3NtYjJwZHUuYyBpbmRleCANCj4gPiAwNjdlYjQ0YzdiYWEuLjc5NGZjM2I2OGI0ZiAxMDA2
NDQNCj4gPiAtLS0gYS9mcy9jaWZzL3NtYjJwZHUuYw0KPiA+ICsrKyBiL2ZzL2NpZnMvc21iMnBk
dS5jDQo+ID4gQEAgLTMyNDgsNyArMzI0OCw3IEBAIF9fU01CMl9jbG9zZShjb25zdCB1bnNpZ25l
ZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLA0KPiA+ICAgICAgICAgZnJlZV9yc3Bf
YnVmKHJlc3BfYnVmdHlwZSwgcnNwKTsNCj4gPg0KPiA+ICAgICAgICAgLyogcmV0cnkgY2xvc2Ug
aW4gYSB3b3JrZXIgdGhyZWFkIGlmIHRoaXMgb25lIGlzIGludGVycnVwdGVkICovDQo+ID4gLSAg
ICAgICBpZiAocmMgPT0gLUVJTlRSKSB7DQo+ID4gKyAgICAgICBpZiAoaXNfaW50ZXJydXB0X2Vy
cm9yKHJjKSkgew0KPiA+ICAgICAgICAgICAgICAgICBpbnQgdG1wX3JjOw0KPiA+DQo+ID4gICAg
ICAgICAgICAgICAgIHRtcF9yYyA9IHNtYjJfaGFuZGxlX2NhbmNlbGxlZF9jbG9zZSh0Y29uLCAN
Cj4gPiBwZXJzaXN0ZW50X2ZpZCwNCj4gPiAtLQ0KPiA+IDIuMjkuMg0KPiA+DQo+DQo+IFRoYW5r
cyBmb3IgdGhlIGZpeCENCj4NCj4gUmV2aWV3ZWQtYnk6IFBhdmVsIFNoaWxvdnNreSA8cHNoaWxv
dkBtaWNyb3NvZnQuY29tPg0KPg0KPiAtLQ0KPiBCZXN0IHJlZ2FyZHMsDQo+IFBhdmVsIFNoaWxv
dnNreQ0KDQoNCg0KLS0NCi1TaHlhbQ0K
