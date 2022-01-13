Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15E3148D731
	for <lists+stable@lfdr.de>; Thu, 13 Jan 2022 13:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234016AbiAMMJF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 07:09:05 -0500
Received: from mail-ma1ind01olkn0157.outbound.protection.outlook.com ([104.47.100.157]:26592
        "EHLO IND01-MA1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230310AbiAMMJE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jan 2022 07:09:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VgVFu300qQaNd/vGol1vfEAdd4VOIuVBKNCywI0l/pFkY2uSb84oH9z+jRJFE/D0d9hXNzvHobK2dTWYvea9vXmhyNYbTgwL4ZUaqOwDmHafXxp/3Hfb17CKiFshds61ZuwEOM9hXWP8bTWg0UpxZ0DtLtbhmeOEjKC5PmurSsFui0kgll6C7BD+Q064WOyxBbeoD7/MUVQAf2PHkFuWDtfyld/chG9vqUWfrRsyY0X8Ax9kZCVEsXKgEZt6Z2gMETD1JNkjtIxiPhNv0iy3AzRrI06imU5HzJKMU+Sjs45/WLCjMuyXUWs+s4hE5nqXZZM3mMDij5gUztgB1U5hyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WPxf5f+WEbvFXLzG2MLUgWVWJnMFnJfcz8aBayiMvj8=;
 b=UWUm8yhEV9vpCxxnDAI6liM3m8pKJsTkJdug1m5M2rxPQ0kFerJ4r+XqqZ0hsSzViVcIfbx0j3AtzZumpQIVeDkHXkX/47F1ORTa5u04DI+aq4mEImK+hESBcQBQ0w7NRWd+epkdV0xiLOeMUFQS+KOx3czc3yfQ7DpaTG109KeRrTFU/LQfpPPZcsPoZt4pU9hI5Ke6r84e9+z4op7Gg+/PJG8dqr9JxRCuaSEjub8FAiBL0Stl8SRMzfRO056HU4NS5a3Z9qE9U0Z+QAnEJosVUowhSdtcQqiHvaEc+c06OjbAcGg0Fsw9E1hme0tdtltp2lXHfDtjpB/9FDVXfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WPxf5f+WEbvFXLzG2MLUgWVWJnMFnJfcz8aBayiMvj8=;
 b=K38qJGYdwhbEieRy8hWqmflYUUQ3TODLTiTAVZM7EGBUCJ9omUohe4NkSClJKgbOiGK6uw82kY1h1/b5mgEvsPx3HoBTy7yAKNv47w8rAESOcdqK7ohnNFWS0cNMQVImFy6qQSyr7bGxY14zXgo0NAcRFndVz15WwWDx/SPqrdovAVBPVJDItRNL9S8TZkONJc/oA2zDVtLflLKWC/xXyl/FWMIVQoWOSz9fKQ8jw2L7xjKZ8p5u4LY2APGWuSD1TNOXsqC4RMB2itBjSq0wI0/yu2N43zk40NOGosTs+TR/HEsedHmBOBpX8l+tBhuJx8n895jJQ0196JN2A4IYHA==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PN2PR01MB4715.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11; Thu, 13 Jan
 2022 12:09:01 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7%8]) with mapi id 15.20.4867.012; Thu, 13 Jan 2022
 12:09:01 +0000
From:   Aditya Garg <gargaditya08@live.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
CC:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH][BACKPORT] mfd: intel-lpss: Fix too early PM enablement in the
 ACPI ->probe()
Thread-Topic: [PATCH][BACKPORT] mfd: intel-lpss: Fix too early PM enablement
 in the ACPI ->probe()
Thread-Index: AQHYCHZZxMvS2uQCuUufxFO7s9nbrA==
Date:   Thu, 13 Jan 2022 12:09:01 +0000
Message-ID: <450A01BA-8DFC-423E-8376-906C4FA9FF65@live.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [pYTbqsuX8Uhy/agaqhYhLtIKntO2fMsz+q4DbZLD/3DxUGP7ptclEr98l084HoYh]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1556f3a1-1ff8-4a2f-12ea-08d9d68d7c4a
x-ms-traffictypediagnostic: PN2PR01MB4715:EE_
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VXGjxYixbYrie/y1dr8sUl3XXSnskL1TqqdTiOt4+olLtmKLQRK+foQFvFoui/EboHoEZNUuJ//CdB+3ObJXPP3uU0MDWnFv3qMZVEqFzpfBH1QauY/l3t5vFPapO87ocizI1OkJBp8Q2CgJFrPvUdZEXlPCaMY+72j7LxbClKVPsmcYEvf9V62LzB7k3H3/OIDobwZr/iQqwDX/WTou1WgQlewur1sS4vKVUnTeGCJ2EOUksWYSMLJIRFdkPSpIwSVhZX+NNjOKhORmtUu8w5kXQHyZwNac6Ava6rrzC2YmWCNxSpyt4EJSCJKgc4ZEuhnqvo2CJX5/WUmoFSiAImgpelTi1TTxyCz0Ui4fNvs5kwPSYD2lncF0JK4QyhmZD8VYS+j/nmyKLfYGI22YyQJfdAFzWDa81s/znzj2wZAsdFFR+D1y7GQvz0kphy1YO3gRq0Hbu1R/6nK7v8uXtCo/exQsymcNZbwpGZjh7nLNRdCaYDZO7NPHLPTynM6Q5kjcXUHsxT8vLGAn/YMH9/350rKjIFXUf3CKSpwNWO7lrl85lq6QND0V7glQeuVt8YmHuzV4kLHhlfttIYAoB8f2icgUYtgSKkjSifzUeLxb+QVfKa3lX06iHb8s7tK1
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bUNWbzdRaWsxQi9xb0dma0NWdU9uQVpJZWpSaEpFejMrSXdSSGFhZWF6aDNO?=
 =?utf-8?B?Zi9oTk9WbDZTcVMzMHBta3A3eVJLSjR1U3F0MWw5aE1zSHdvb0hPbVViQWxp?=
 =?utf-8?B?ajcxQXF0ZUNaemFhSXJsVk1jOVduMjhNS3NCRm5DNDFTY2REUS9TQXFhZy9o?=
 =?utf-8?B?ZnRLaEw0YU8yZXdCdVM4M3R1RGJqNzJGQVlscUxQNUc2L09JWWdMYytCSDVU?=
 =?utf-8?B?NzZOQWViYzFKcmhmT0ZjZkdSTzBYaWRmeGZ4cTFEcFR6SWdxREJ3U2xHUm1U?=
 =?utf-8?B?UEZpMjR6M0UveHdZNFcxeXVQaWF5bWkrSTBEeWFiNlhKUzFKdmN4YVJuUGhx?=
 =?utf-8?B?ZDhTUE9nN0ZRTUFQRHhScEpXNkR4Y21oMGJKSzdLbnFXSmgyclc5RE84bHJO?=
 =?utf-8?B?c2dNaHY1NUhnUzBxejBQSURjS3dHOHFLM3o1c1g1S3RXVXFNbTIxVXV1a1Qv?=
 =?utf-8?B?cURva29OV2lqZTdXMHVyaEM5TGVKcXZ5MjBkQU44d1p5b29XcDN5d203MmFp?=
 =?utf-8?B?VWYzeUM1dkRRblBLV1lvU29kQlNIbTc5VlhldGJWOGtNN0FlQjlaMUlBY05D?=
 =?utf-8?B?UFVndmZET0pNWGRVMmZNSVdORVd0MVRJQ2REVGdqRTFyaUxIam9VMVh6Tnda?=
 =?utf-8?B?MjNleURLSnZ6VmhEcG1UNzIwNHRTQVpjMFovNU44NDhlREZRMGk1bldMb09X?=
 =?utf-8?B?QjliSHhaMXhxTW9EZjBvSmFyWVR6bGhRTWJibmlTMEd0bHdaUUM5Z05sdER3?=
 =?utf-8?B?T3JDYktNTnFJUUJJOWE2WFdpb1lXVUQyMXcvS3VVQmxvaUlCekladzN3VkF5?=
 =?utf-8?B?ekNZaG1mclpKQjZzamZPSlNtbEpIWk84WG1RbDV0MmhibjVMN2U1ZTE5a3ll?=
 =?utf-8?B?aTlaMzlnQ0paNDdxL3h5YmFReDJ0SEtUSjZTZ1c2cW5hcnVERlZVdzkxbUdQ?=
 =?utf-8?B?b0RLaFhydmZ5RksrZnErV29Odm9VZTJVVUo1ejRpU29xZ1F2M1FvOWRXaGJq?=
 =?utf-8?B?b1dNRlBURkN1KzdnM0tFYTdzQ1FIQURTOWZtd3dlcCtKTnJUeUp6dzhQR281?=
 =?utf-8?B?TGpaOVlNWmVzYmdnMnpVaEtLbkhLUWxMV3FETG5jZzZYdGVPbWhodXRHNXMv?=
 =?utf-8?B?UFlqdEo3WitoZFVndld4MFJwc0g5ZFpROGlwRHZENkpxUHhxODNadTRWa2Ft?=
 =?utf-8?B?b1UrVVBqOXBnSWl3QTNlWmN5V3YySlowZHQ4eFRTTVRtSXNkVExiMGdYcW9U?=
 =?utf-8?B?T0NzTm5xQnNZRmpSbm5hMHdvZkxDS3JtM3ozS2c4VE0ycWZpRkdYdVZRbmc1?=
 =?utf-8?B?RzlDRVlhQ3BjeGh4WjFVaEMxV0xOcnByTnQ0Sm5Zc1RXa2pkRzh1b1pwZVQ5?=
 =?utf-8?B?YUc5VmMvVXNDMFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8B54BD843AC2A743A451ED13F14893DD@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-42ed3.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 1556f3a1-1ff8-4a2f-12ea-08d9d68d7c4a
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2022 12:09:01.2532
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN2PR01MB4715
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

VGhlIHBhdGNoIGJlbG93IGhhcyBiZWVuIHVwc3RyZWFtZWQgYnV0IEkgYmVsaWV2ZSBoYXMgbm90
IGJlZW4gYmFjayBwb3J0ZWQgdG8gc3RhYmxlLiBUaGUgcGF0Y2ggZml4ZXMgYSBidWcgd2hpY2gg
YXJvc2UgaW4ga2VybmVsIDUuMTUsIHRodXMgSSByZXF1ZXN0IHlvdSB0byBiYWNrIHBvcnQgaXQg
dG8gNS4xNSBhbmQgNS4xNiBhcyB3ZWxsDQoNCk9yaWdpbmFsIGNvbW1pdCBpbiBMaW51c+KAmSB0
cmVlIDotIGM5ZTE0MzA4NGQxYTYwMmY4MjkxMTU2MTJlMWVjNzlkZjM3MjdjOGINCg0KRnJvbTog
QW5keSBTaGV2Y2hlbmtvIDxhbmRyaXkuc2hldmNoZW5rb0BsaW51eC5pbnRlbC5jb20+DQogDQpU
aGUgcnVudGltZSBQTSBjYWxsYmFjayBtYXkgYmUgY2FsbGVkIGFzIHNvb24gYXMgdGhlIHJ1bnRp
bWUgUE0gZmFjaWxpdHkNCmlzIGVuYWJsZWQgYW5kIGFjdGl2YXRlZC4gSXQgbWVhbnMgdGhhdCAt
PnN1c3BlbmQoKSBtYXkgYmUgY2FsbGVkIGJlZm9yZQ0Kd2UgZmluaXNoIHByb2JpbmcgdGhlIGRl
dmljZSBpbiB0aGUgQUNQSSBjYXNlLiBIZW5jZSwgTlVMTCBwb2ludGVyDQpkZXJlZmVyZW5jZToN
Cg0KICBpbnRlbC1scHNzIElOVDM0QkE6MDA6IElSUSBpbmRleCAwIG5vdCBmb3VuZA0KICBCVUc6
IGtlcm5lbCBOVUxMIHBvaW50ZXIgZGVyZWZlcmVuY2UsIGFkZHJlc3M6IDAwMDAwMDAwMDAwMDAw
MzANCiAgLi4uDQogIFdvcmtxdWV1ZTogcG0gcG1fcnVudGltZV93b3JrDQogIFJJUDogMDAxMDpp
bnRlbF9scHNzX3N1c3BlbmQrMHhiLzB4NDAgW2ludGVsX2xwc3NdDQoNClRvIGZpeCB0aGlzLCBm
aXJzdCB0cnkgdG8gcmVnaXN0ZXIgdGhlIGRldmljZSBhbmQgb25seSBhZnRlciB0aGF0IGVuYWJs
ZQ0KcnVudGltZSBQTSBmYWNpbGl0eS4NCg0KRml4ZXM6IDRiNDVlZmUgKCJtZmQ6IEFkZCBzdXBw
b3J0IGZvciBJbnRlbCBTdW5yaXNlcG9pbnQgTFBTUyBkZXZpY2VzIikNClJlcG9ydGVkLWJ5OiBP
cmxhbmRvIENoYW1iZXJsYWluIDxyZWRlY29yYXRpbmdAcHJvdG9ubWFpbC5jb20+DQpSZXBvcnRl
ZC1ieTogQWRpdHlhIEdhcmcgPGdhcmdhZGl0eWEwOEBsaXZlLmNvbT4NClNpZ25lZC1vZmYtYnk6
IEFuZHkgU2hldmNoZW5rbyA8YW5kcml5LnNoZXZjaGVua29AbGludXguaW50ZWwuY29tPg0KVGVz
dGVkLWJ5OiBBZGl0eWEgR2FyZyA8Z2FyZ2FkaXR5YTA4QGxpdmUuY29tPg0KU2lnbmVkLW9mZi1i
eTogTGVlIEpvbmVzIDxsZWUuam9uZXNAbGluYXJvLm9yZz4NCkxpbms6IGh0dHBzOi8vbG9yZS5r
ZXJuZWwub3JnL3IvMjAyMTExMDExOTAwMDguODY0NzMtMS1hbmRyaXkuc2hldmNoZW5rb0BsaW51
eC5pbnRlbC5jb20NCi0tLQ0KIGRyaXZlcnMvbWZkL2ludGVsLWxwc3MtYWNwaS5jIHwgNyArKysr
KystDQogMSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KDQpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9tZmQvaW50ZWwtbHBzcy1hY3BpLmMgYi9kcml2ZXJzL21mZC9p
bnRlbC1scHNzLWFjcGkuYw0KaW5kZXggM2YxZDk3NmViNjdjYjcuLmYyZWE2NTQwYTAxZTE0IDEw
MDY0NA0KLS0tIGEvZHJpdmVycy9tZmQvaW50ZWwtbHBzcy1hY3BpLmMNCisrKyBiL2RyaXZlcnMv
bWZkL2ludGVsLWxwc3MtYWNwaS5jDQpAQCAtMTM2LDYgKzEzNiw3IEBAIHN0YXRpYyBpbnQgaW50
ZWxfbHBzc19hY3BpX3Byb2JlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpDQogew0KIAlz
dHJ1Y3QgaW50ZWxfbHBzc19wbGF0Zm9ybV9pbmZvICppbmZvOw0KIAljb25zdCBzdHJ1Y3QgYWNw
aV9kZXZpY2VfaWQgKmlkOw0KKwlpbnQgcmV0Ow0KIA0KIAlpZCA9IGFjcGlfbWF0Y2hfZGV2aWNl
KGludGVsX2xwc3NfYWNwaV9pZHMsICZwZGV2LT5kZXYpOw0KIAlpZiAoIWlkKQ0KQEAgLTE0OSwx
MCArMTUwLDE0IEBAIHN0YXRpYyBpbnQgaW50ZWxfbHBzc19hY3BpX3Byb2JlKHN0cnVjdCBwbGF0
Zm9ybV9kZXZpY2UgKnBkZXYpDQogCWluZm8tPm1lbSA9IHBsYXRmb3JtX2dldF9yZXNvdXJjZShw
ZGV2LCBJT1JFU09VUkNFX01FTSwgMCk7DQogCWluZm8tPmlycSA9IHBsYXRmb3JtX2dldF9pcnEo
cGRldiwgMCk7DQogDQorCXJldCA9IGludGVsX2xwc3NfcHJvYmUoJnBkZXYtPmRldiwgaW5mbyk7
DQorCWlmIChyZXQpDQorCQlyZXR1cm4gcmV0Ow0KKw0KIAlwbV9ydW50aW1lX3NldF9hY3RpdmUo
JnBkZXYtPmRldik7DQogCXBtX3J1bnRpbWVfZW5hYmxlKCZwZGV2LT5kZXYpOw0KIA0KLQlyZXR1
cm4gaW50ZWxfbHBzc19wcm9iZSgmcGRldi0+ZGV2LCBpbmZvKTsNCisJcmV0dXJuIDA7DQogfQ0K
IA0KIHN0YXRpYyBpbnQgaW50ZWxfbHBzc19hY3BpX3JlbW92ZShzdHJ1Y3QgcGxhdGZvcm1fZGV2
aWNlICpwZGV2KQ==
