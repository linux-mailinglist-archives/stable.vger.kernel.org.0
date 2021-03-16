Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4876733E1FF
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 00:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbhCPXTn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 19:19:43 -0400
Received: from mail-mw2nam12on2092.outbound.protection.outlook.com ([40.107.244.92]:37633
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229491AbhCPXTY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 19:19:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DBm4ma40rlzhBHINBVpsaUREUY3QXydl/35sl4gC4mDAfeETJc2UIwdbrwnqo27o584t5GZ8gjrfAEkSWd3uUA5Q8QM0XosYYnUuo4CUcpSEj5tBVsxfNYLRlS25O1QncKZk/TkUKX032FisySQKveHumMZjSqqyxb3yHcV1CwDdZDUuAz8LN1jO7lTFk2q05YOLD8l5KNMez3FBiFaWeLF0fFg6oKBfOYlgDDUK2UJIMa/SyBKtrMowKpZornKrWoBnFPR8YiWrXBiE85POlOtJLYXnhN/xa5s6Iprtckb14Konh48ouej1QSWWKmZWecTz/SR3uV04mT+kNiQtwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mUAvQrym7haaa2v2D5qJamqw46MEuxoFUuJau0JSxR8=;
 b=XDjkcx6LzfmNfFhKKJYxix+W80BChc8ZtN2tcU4028Sf553HlLtBMgkZ4l5J1rCba/05chStiuo85hSBI9bw+FzsNfHu4358qEYuNz/fs9V8buAVQwLluWlu7cVZdnAPP4m5A/GwYa7S5n6bUymVd8sSUF+9YCEJsOWq+dO+B2TSTWpBgYLKj6x4gLVmK7+jSOwgOEAJUUvhuCRmwx6b0CXL68THGIoKr+84rD5NBr+0lMYEj/YYsjIRbMpP9YoemD4Y0Ne3ZG9D71Wo5qPZRQk1QsvGhYOJFW9/2B8jUtwi/KVw/IvkI6R4QdFgBxZgsv1AayONgjeL6mlXH5kgYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hammerspace.com; dmarc=pass action=none
 header.from=hammerspace.com; dkim=pass header.d=hammerspace.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hammerspace.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mUAvQrym7haaa2v2D5qJamqw46MEuxoFUuJau0JSxR8=;
 b=gZVWiGn8MBu+63UJITZSLFIjbv93hceNNlnXntL59Jdancx2XzLyBUK6IAaf0Z922RViJywsNDK20o47UseiZN0r/rXgNZ4yN743+FktpmNj1NqBY3P1xD/ywoifMp2C3RZ8HhOy2cV6Ivoh8/7zDcY6eYMBcindUBd48mfuwMU=
Received: from CH2PR13MB3525.namprd13.prod.outlook.com (2603:10b6:610:21::29)
 by CH0PR13MB4732.namprd13.prod.outlook.com (2603:10b6:610:ca::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.11; Tue, 16 Mar
 2021 23:19:21 +0000
Received: from CH2PR13MB3525.namprd13.prod.outlook.com
 ([fe80::f453:2dd2:675:d063]) by CH2PR13MB3525.namprd13.prod.outlook.com
 ([fe80::f453:2dd2:675:d063%3]) with mapi id 15.20.3955.010; Tue, 16 Mar 2021
 23:19:21 +0000
From:   Trond Myklebust <trondmy@hammerspace.com>
To:     "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "dhowells@redhat.com" <dhowells@redhat.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "anna.schumaker@netapp.com" <anna.schumaker@netapp.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "syzbot+ba2e91df8f74809417fa@syzkaller.appspotmail.com" 
        <syzbot+ba2e91df8f74809417fa@syzkaller.appspotmail.com>,
        "syzbot+f3a0fa110fd630ab56c8@syzkaller.appspotmail.com" 
        <syzbot+f3a0fa110fd630ab56c8@syzkaller.appspotmail.com>
Subject: Re: [PATCH] NFS: fs_context: validate UDP retrans to prevent shift
 out-of-bounds
Thread-Topic: [PATCH] NFS: fs_context: validate UDP retrans to prevent shift
 out-of-bounds
Thread-Index: AQHXDvnAvfNR5PqdykmZVAF5r/Bd4qqHS36AgAAMJAA=
Date:   Tue, 16 Mar 2021 23:19:21 +0000
Message-ID: <8a992689a73f6e3481f4a0316adc93a0e032fd96.camel@hammerspace.com>
References: <20210302001930.2253-1-rdunlap@infradead.org>
         <b98720c9-2798-f168-eaaa-01d638d9900d@infradead.org>
In-Reply-To: <b98720c9-2798-f168-eaaa-01d638d9900d@infradead.org>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none
 header.from=hammerspace.com;
x-originating-ip: [68.36.133.222]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 523a0034-33da-4dd2-a425-08d8e8d1ee36
x-ms-traffictypediagnostic: CH0PR13MB4732:
x-microsoft-antispam-prvs: <CH0PR13MB473252838ED76D94A0A978D2B86B9@CH0PR13MB4732.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1091;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: l/cpyBpk4wynM3jxy7eeX/mHbZqDqlt56lR21Bfqx16ylfDE/AK1jj0RqY1j1a9w2rZmfzMynXvTZdGKAR9hvUmRd2b7T6oU2591diVoWKNVKqlA/MR1H3hW3xn/mtXPAb1YtZqFTCIUjdV/tQ2fcWnowARVccw7PQay7QHv7Ua4tBfQ49Zp527TLFg5X3FNvwiLFPn0peSr75D44hLjLzgjT1/Ndjd2lkJ5kEKxYENMtXDxCCkpgYiFG5T+tO1qyxo9YugA/2rsaWnPM6fvqEshd6drt1F3K8eM3eWOY4NbasaIqmGCmHKvBmxY8cLeB3chFIAIgp6/QuuLnTQ4lxDIhlHdvID2owPs5HW6oQ3SaM4IuxklwlvUJCmgvyx0yFKNHTjaN8+AU4NBQOgCunLv783Jr1gkG2CyuytpSKcSPpIQneYP0Ot2p+Vc6X2RyHl4EnmaM3IL4NV3kf4pPD6zTM3Da0RYIUxR29tRMWqM59QukFVC8ZWLfgwWFg/JekUIF9N+7P0ft/vsV6qGxIixeBDcthbQXFtKpqRddT7OCGPfLKAhvHCr/fAN8r9t
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR13MB3525.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(39840400004)(366004)(396003)(376002)(136003)(346002)(66946007)(316002)(2616005)(36756003)(66556008)(8676002)(5660300002)(8936002)(54906003)(4326008)(478600001)(64756008)(76116006)(110136005)(6486002)(6506007)(53546011)(71200400001)(83380400001)(2906002)(66476007)(6512007)(26005)(66446008)(86362001)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?TStKVXM2MVhJQTJndTF4V2ZKTEZRbzVRR2VrSzcvQUZPSDNldEdtWTJsazFS?=
 =?utf-8?B?MzRlOUExeTFOZlFNTkxBRG9iYUYwTHJpMHE4OUpRUEVGLzhEb1VoRjlycy9j?=
 =?utf-8?B?M0toU2tyMG5tM1A0dGo4QlVvYmlCV3VNOUliYnQzZVhQanlJcVFXbE5Jc0Z3?=
 =?utf-8?B?YVVvOGM1RzRnRDR2em04eWRiTTJoY3gyckg4QXZpdFlMUjdrZFUzblpRbjJO?=
 =?utf-8?B?TzM0RldGSFBmWXYwRitnaUZ3WUREOHk4d1IrU2NYZlEzeUo1Z3g5anZsb1pO?=
 =?utf-8?B?UE0vTlZZT28wcmhNYnpET0cvZFhxUzU2anAvM09kUU1xZHVPWWtWeDR0Ymkz?=
 =?utf-8?B?SFNSWllMTjhHdzBxQUFkQ1pTVXpkOGhQMysxZ1ZPVnZvcEpSbk1YUUUxbFZL?=
 =?utf-8?B?R1F4eVAxNEdYRG50OXE0TFNhUFJQbVNrTStMZ3poU2kxRVhYM1JKM0JvcXRp?=
 =?utf-8?B?ZEUwNHNNMGdFSGdoYmVaczh3Y1hpQkFndTZLS1c3TzMzTVJOMjNnSjZodk9B?=
 =?utf-8?B?S0hqcnlpdXNiZnZXcmFTdGl3VFN2eEdmZGJraVJQWlpuVnBJWlNxMWJXQ0Vt?=
 =?utf-8?B?NVhwb01uaUdZVjV2U2JkajlBQ0xSZVZtek9pSFBxVmVvZ28xMUhsVU9tRWtt?=
 =?utf-8?B?a1BsVko0TUtqWTcyVFM2MnVOOWhEb2pqN3E2bEkyeldWNnUvN1EvalZQeEkv?=
 =?utf-8?B?RkFoeXVPZzlGS1UzV2kwOGVSSmRSYVlacUd1M3B5Z0VUSVFwZysvdnpqeGM0?=
 =?utf-8?B?dm5lK3NkMXFxb3BlS0EzMVYwamdOckFERE1GRVhXNmJRdkFtc0s0ZWhLNXky?=
 =?utf-8?B?eXRVaTNMRWdmcllhd0htUzNiN3JhTWZ0SzJSRnRxVzRueDBoYjBpek5tWXVZ?=
 =?utf-8?B?VHlIckRvTTI1c0duVCtGVThRa0lqMHpwK1pNNHUybEYwUGdxOGlqY0JQSnVI?=
 =?utf-8?B?K1pIUW5jL1d5VDl5TnJocEt3TUt5WnRFV0lxaU5uRkU1R01xMWkxclhlbDRi?=
 =?utf-8?B?SXJGOUVoNkNnMEY5WllHUmtpSmhZUWdLWWRWeVdIb2hVWVQrTlhZaXEzUlNS?=
 =?utf-8?B?SEVjMkJ2aUhCam1zZURPcDFUTENEeXFZdnNuNlVnR0ZFeWhoUzBoOWc4Q25B?=
 =?utf-8?B?VTNUcVlFNzY3Ull0V2NqZGxnbVROUThNNlduMnA5STNkTjFhYzc0aFFycHBS?=
 =?utf-8?B?eGUvZW9ZRUxob1M5WGo2amxkZTFiNUxqNHNHQnFEN0NKZnpXNkhkazZDUVk4?=
 =?utf-8?B?ZlNZd295R3pmNU5zWnJIYnJqZ2FtaXd3WTZzZEZTNzlUS1JBc1ErM2F0emdp?=
 =?utf-8?B?R2R2UXphekZBTnBUcVV4UjBpaUs4S0lFTlg0MkdUcXZxWnlnaUwxRW9JMm03?=
 =?utf-8?B?TkhTd2FRV0VoN1lwU2ZWOWFRTVB2eVVRTDNJTjFzSnlDUDM2d3F2cy9lOG00?=
 =?utf-8?B?UGE2UEY0Nkl1ZmFGUkdWMkFOb3VwT2srS1hQMDdoTlRVYmY1SjFNc2FQMm1K?=
 =?utf-8?B?Rnc3d2c0ajJDMzdpQ2U5Mk0rWHhqTWJaUmgwV1QrRkRMSk9oY1ZKaGNSamhM?=
 =?utf-8?B?VEFjeDRQVnhtU09IV1FuazVyTHRUemsxa2haTEVXQjBraVZzY29ldVplRjJI?=
 =?utf-8?B?aFJQNW9GTkpBd0IrUVg3UTIyMkJzRDEyMm1WOFdOVVYyZTRwczhvSStzSU42?=
 =?utf-8?B?bkpQWVJPenVrZHVuTUlWdVhwRWp5ZnF0NzdtNHhxd2VWMFFHbEhjOWNIVDQ5?=
 =?utf-8?Q?7cC27Zwiqhe7lpu/SAbhHZCEka3KV6buecU/er5?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <F025EF7F69026B449B3AB67FD382DC35@namprd13.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: hammerspace.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR13MB3525.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 523a0034-33da-4dd2-a425-08d8e8d1ee36
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2021 23:19:21.4083
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0d4fed5c-3a70-46fe-9430-ece41741f59e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: axqWxekZNX0stgPUnWKg9XY8vUHkBni8ZEYDkGtxH0O20G/V9iE2oDZrhcFGBrJg003z43hyb/dtTHRYRCO5xA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB4732
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgUmFuZHksDQoNCk9uIFR1ZSwgMjAyMS0wMy0xNiBhdCAxNTozNSAtMDcwMCwgUmFuZHkgRHVu
bGFwIHdyb3RlOg0KPiBwaW5nPw0KPiANCg0KSSBjYW4gdGFrZSB0aGlzIHBhdGNoIGZvciB0aGUg
bmV4dCBtZXJnZSB3aW5kb3cuDQoNCj4gT24gMy8xLzIxIDQ6MTkgUE0sIFJhbmR5IER1bmxhcCB3
cm90ZToNCj4gPiBGaXggc2hpZnQgb3V0LW9mLWJvdW5kcyBpbiB4cHJ0X2NhbGNfbWFqb3J0aW1l
bygpLiBUaGlzIGlzIGNhdXNlZA0KPiA+IGJ5IGEgZ2FyYmFnZSB0aW1lb3V0IChyZXRyYW5zKSBt
b3VudCBvcHRpb24gYmVpbmcgcGFzc2VkIHRvIG5mcw0KPiA+IG1vdW50LA0KPiA+IGluIHRoaXMg
Y2FzZSBmcm9tIHN5emthbGxlci4NCj4gPiANCj4gPiBJZiB0aGUgcHJvdG9jb2wgaXMgWFBSVF9U
UkFOU1BPUlRfVURQLCB0aGVuICdyZXRyYW5zJyBpcyBhIHNoaWZ0DQo+ID4gdmFsdWUgZm9yIGEg
NjQtYml0IGxvbmcgaW50ZWdlciwgc28gJ3JldHJhbnMnIGNhbm5vdCBiZSA+PSA2NC4NCj4gPiBJ
ZiBpdCBpcyA+PSA2NCwgZmFpbCB0aGUgbW91bnQgYW5kIHJldHVybiBhbiBlcnJvci4NCj4gPiAN
Cj4gPiBGaXhlczogOTk1NGJmOTJjMGNkICgiTkZTOiBNb3ZlIG1vdW50IHBhcmFtZXRlcmlzYXRp
b24gYml0cyBpbnRvDQo+ID4gdGhlaXIgb3duIGZpbGUiKQ0KPiA+IFJlcG9ydGVkLWJ5OiBzeXpi
b3QrYmEyZTkxZGY4Zjc0ODA5NDE3ZmFAc3l6a2FsbGVyLmFwcHNwb3RtYWlsLmNvbQ0KPiA+IFJl
cG9ydGVkLWJ5OiBzeXpib3QrZjNhMGZhMTEwZmQ2MzBhYjU2YzhAc3l6a2FsbGVyLmFwcHNwb3Rt
YWlsLmNvbQ0KPiA+IFNpZ25lZC1vZmYtYnk6IFJhbmR5IER1bmxhcCA8cmR1bmxhcEBpbmZyYWRl
YWQub3JnPg0KPiA+IENjOiBUcm9uZCBNeWtsZWJ1c3QgPHRyb25kLm15a2xlYnVzdEBoYW1tZXJz
cGFjZS5jb20+DQo+ID4gQ2M6IEFubmEgU2NodW1ha2VyIDxhbm5hLnNjaHVtYWtlckBuZXRhcHAu
Y29tPg0KPiA+IENjOiBsaW51eC1uZnNAdmdlci5rZXJuZWwub3JnDQo+ID4gQ2M6IERhdmlkIEhv
d2VsbHMgPGRob3dlbGxzQHJlZGhhdC5jb20+DQo+ID4gQ2M6IEFsIFZpcm8gPHZpcm9AemVuaXYu
bGludXgub3JnLnVrPg0KPiA+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+ID4gLS0tDQo+
ID4gwqBmcy9uZnMvZnNfY29udGV4dC5jIHzCoMKgIDEyICsrKysrKysrKysrKw0KPiA+IMKgMSBm
aWxlIGNoYW5nZWQsIDEyIGluc2VydGlvbnMoKykNCj4gPiANCj4gPiAtLS0gbG54LTUxMi1yYzEu
b3JpZy9mcy9uZnMvZnNfY29udGV4dC5jDQo+ID4gKysrIGxueC01MTItcmMxL2ZzL25mcy9mc19j
b250ZXh0LmMNCj4gPiBAQCAtOTc0LDYgKzk3NCwxNSBAQCBzdGF0aWMgaW50IG5mczIzX3BhcnNl
X21vbm9saXRoaWMoc3RydWN0DQo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHNpemVvZihtbnRmaC0+ZGF0YSkgLSBtbnRmaC0+
c2l6ZSk7DQo+ID4gwqANCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoC8qDQo+
ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqIGZvciBwcm90byA9PSBYUFJUX1RS
QU5TUE9SVF9VRFAsIHdoaWNoIGlzIHdoYXQNCj4gPiB1c2VzDQo+ID4gK8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCAqIHRvX2V4cG9uZW50aWFsLCBpbXBseWluZyBzaGlmdDogbGltaXQg
dGhlIHNoaWZ0DQo+ID4gdmFsdWUNCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
ICogdG8gQklUU19QRVJfTE9ORyAobWFqb3J0aW1lbyBpcyB1bnNpZ25lZCBsb25nKQ0KPiA+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKi8NCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgaWYgKCEoZGF0YS0+ZmxhZ3MgJiBORlNfTU9VTlRfVENQKSkgLyogdGhpcyB3
aWxsIGJlDQo+ID4gVURQICovDQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqBpZiAoZGF0YS0+cmV0cmFucyA+PSA2NCkgLyogc2hpZnQgdmFsdWUgaXMN
Cj4gPiB0b28gbGFyZ2UgKi8NCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBnb3RvIG91dF9pbnZhbGlkX2RhdGE7DQo+ID4g
Kw0KPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAvKg0KPiA+IMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgICogVHJhbnNsYXRlIHRvIG5mc19mc19jb250ZXh0LCB3aGlj
aA0KPiA+IG5mc19maWxsX3N1cGVyDQo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgKiBjYW4gZGVhbCB3aXRoLg0KPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
ICovDQo+ID4gQEAgLTEwNzMsNiArMTA4Miw5IEBAIG91dF9ub19hZGRyZXNzOg0KPiA+IMKgDQo+
ID4gwqBvdXRfaW52YWxpZF9maDoNCj4gPiDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIG5mc19pbnZh
bGYoZmMsICJORlM6IGludmFsaWQgcm9vdCBmaWxlaGFuZGxlIik7DQo+ID4gKw0KPiA+ICtvdXRf
aW52YWxpZF9kYXRhOg0KPiA+ICvCoMKgwqDCoMKgwqDCoHJldHVybiBuZnNfaW52YWxmKGZjLCAi
TkZTOiBpbnZhbGlkIGJpbmFyeSBtb3VudCBkYXRhIik7DQo+ID4gwqB9DQo+ID4gwqANCj4gPiDC
oCNpZiBJU19FTkFCTEVEKENPTkZJR19ORlNfVjQpDQo+ID4gDQo+IA0KPiANCg0KLS0gDQpUcm9u
ZCBNeWtsZWJ1c3QNCkxpbnV4IE5GUyBjbGllbnQgbWFpbnRhaW5lciwgSGFtbWVyc3BhY2UNCnRy
b25kLm15a2xlYnVzdEBoYW1tZXJzcGFjZS5jb20NCg0KDQo=
