Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87B4815834E
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 20:10:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbgBJTKE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 14:10:04 -0500
Received: from mail-dm6nam11on2123.outbound.protection.outlook.com ([40.107.223.123]:6900
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726831AbgBJTKD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 14:10:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hOF+sIQXd3T93zveUUSb3M28V2kGacTb86NwPlOVnDlG0IQHyao1ihHtRG7IJCF1CBvPAJWs9we2wKUrDLaHTDUtjAf3rru8teNJhzKncz36aJ7OQ8sXE+L84vrbHm/IVKzPAi7E3/UnFGQBYQX1SCexcTV1O2Op/9iLCNEkodXIj9cb1shG6VdLXIEhSelrXaBA0aGX1m6HRE82ep/avdLIqNkZ3A6sCz+DosCn2naWnoVJZKDiAXvrZG1TQXq4Fm+68YafnUiZ/0nt9lr6eipGGWUQwOtu13SUxWzwJpRQbqsICiSG1h5RjiTDxUFuiywAo6GE435wh3vuFLUUQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SUonBlm7aVaGK7EYs7h6Ney6j9ixxBap8mfOS2kcrtQ=;
 b=DZROV7OaL8EO+wvKiaf7VT6vogTbX/gTEECp2lZzeWAwGrg8aN1B9T26xveyibXX5C29jfqxU+TosG6WGyrs5vsXi8+1sj4ighmqhbHAKSRuZ54DDsF/HlVaKRxMuCOvMhEUTuzu8Atn4KEySYJf3tyR/rYyvYxxxG0TdqHgl/kHzLLUWYjJDCbg7wb8mxMqTzPreMP6PuZOHIMX+JkbadFSjPWlCD2MM97X/ByubupQ7HflkfzdQPlG+Wr1L35pxCskpUoHOPlPKsnBPKeEjZwTbHSp+dJLTR8AUkNah0M6Jx1QcTQTHDscGzYAFrQwEUtXnnQFFivHIRe48IYtKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SUonBlm7aVaGK7EYs7h6Ney6j9ixxBap8mfOS2kcrtQ=;
 b=NYo9A5tYLjZ4ZSCtK0svUmsLU6tuvS4f0BcJ/Yic0XA0JrVQtHyfWTWZknLhzvpjsNOnCuVW3GMLb8XrJRiu0ukGiZ4QG2t6dE9THQbhW99lutNToy8d+2N9DvyKSewcNtpmGCy/eFlsg7XM6Lk+OJHHY0OH5Wxsc0K7fUbnH48=
Received: from BY5PR21MB1427.namprd21.prod.outlook.com (20.180.34.88) by
 BY5PR21MB1395.namprd21.prod.outlook.com (20.180.34.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.6; Mon, 10 Feb 2020 19:10:00 +0000
Received: from BY5PR21MB1427.namprd21.prod.outlook.com
 ([fe80::5068:3086:b32b:a096]) by BY5PR21MB1427.namprd21.prod.outlook.com
 ([fe80::5068:3086:b32b:a096%9]) with mapi id 15.20.2729.016; Mon, 10 Feb 2020
 19:10:00 +0000
From:   Pavel Shilovskiy <pshilov@microsoft.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Aurelien Aptel <aaptel@suse.com>,
        Steven French <Steven.French@microsoft.com>
Subject: RE: [EXTERNAL] [PATCH 5.4 303/309] cifs: fix mode bits from dir
 listing when mounted with modefromsid
Thread-Topic: [EXTERNAL] [PATCH 5.4 303/309] cifs: fix mode bits from dir
 listing when mounted with modefromsid
Thread-Index: AQHV4A8XQX7KgvLaXECjh2i8bk7beKgUynYw
Date:   Mon, 10 Feb 2020 19:10:00 +0000
Message-ID: <BY5PR21MB14279039445B44E57437E16CB6190@BY5PR21MB1427.namprd21.prod.outlook.com>
References: <20200210122406.106356946@linuxfoundation.org>
 <20200210122436.056141941@linuxfoundation.org>
In-Reply-To: <20200210122436.056141941@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=pshilov@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-02-10T19:09:58.3081963Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=6d2fce8b-2f99-4754-9fda-69ba2a25b7b0;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pshilov@microsoft.com; 
x-originating-ip: [2001:4898:80e8:b:1087:cfa5:b59a:daa8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b7398ad3-1feb-4cab-0523-08d7ae5cd3a1
x-ms-traffictypediagnostic: BY5PR21MB1395:|BY5PR21MB1395:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR21MB1395EE94F27F7A76B4EB2E85B6190@BY5PR21MB1395.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:669;
x-forefront-prvs: 03094A4065
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(136003)(346002)(376002)(366004)(396003)(189003)(199004)(8936002)(8676002)(7696005)(33656002)(81166006)(71200400001)(54906003)(86362001)(81156014)(110136005)(53546011)(186003)(6506007)(5660300002)(316002)(2906002)(4326008)(8990500004)(66476007)(66556008)(66946007)(55016002)(66446008)(64756008)(9686003)(76116006)(478600001)(10290500003)(52536014)(107886003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY5PR21MB1395;H:BY5PR21MB1427.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vXZnKnXpoyx4sifPXISsmVOfM82BsRcXAEl39tLn6BxsYzQaFeow9c4iOQ83yigIiYn/xzOvKe5+xusJ6quZa6va7Tq/warbpajzmSCuQWGvSQuyTUxHial7EbCcjlducWH7DXuvOPaHCWqbIKusVfj72aQkBbFxbndmLpM2KFb3UjdDne0QtYpcTpIpLvUP5veukHvvR5MqzF82SrUt4vJGCP9OG5RPhZYzxxshxYH3SYfpOrufYaPsGrpqAGGyEtl+53qLRHfT6UPnerKFqNhGRVxk1QiYA1p9WQkzNkEfsKxVApbR+8VgktkdudHwqIrbK0eGT1ezhj8IVVzNwH/10q/N3zeKRBe0MR2ddRH6maz6JdZ1PX2LHcEKMGNR/ngZTzZwf+t0D4vbMSF5/1ZrCHwN4ER/S1yIOvbXQWNb1OEYQMlq+VcNSxsH1ONz
x-ms-exchange-antispam-messagedata: /eBxiaXju2PsB+2d2mHpEDoE/Jcyt8AznfndZOVjZkAxsrRg8O9g1jL0waLkisIK78pHbPI9hGZDbd6RL262kiDIMScOJkfa7rGidAzP8O/EZjRJhwxLJuFPAX/I8E0Qg19gCbdXuqR+apAtZczhPar1LK2Aq9/iUlI7sLUJwHn/uWQUY3oUQjpR5ujrf1Sx67im0Pc8OqjGvXw408EVFw==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7398ad3-1feb-4cab-0523-08d7ae5cd3a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2020 19:10:00.5888
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 12pMZXSGJZ34ayMpzklMzl31CDN+C7LgrzWjuHeDZgAuiBnoGtaRRXa5qIbPdthhT97cYamAf0pwWX5yraRAGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR21MB1395
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UgQmVnaW4tLS0tLQ0KRnJvbTogR3JlZyBLcm9haC1IYXJ0
bWFuIDxncmVna2hAbGludXhmb3VuZGF0aW9uLm9yZz4gDQpTZW50OiBNb25kYXksIEZlYnJ1YXJ5
IDEwLCAyMDIwIDQ6MzQgQU0NClRvOiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQpDYzog
R3JlZyBLcm9haC1IYXJ0bWFuIDxncmVna2hAbGludXhmb3VuZGF0aW9uLm9yZz47IHN0YWJsZUB2
Z2VyLmtlcm5lbC5vcmc7IEF1cmVsaWVuIEFwdGVsIDxhYXB0ZWxAc3VzZS5jb20+OyBTdGV2ZW4g
RnJlbmNoIDxTdGV2ZW4uRnJlbmNoQG1pY3Jvc29mdC5jb20+OyBQYXZlbCBTaGlsb3Zza2l5IDxw
c2hpbG92QG1pY3Jvc29mdC5jb20+DQpTdWJqZWN0OiBbRVhURVJOQUxdIFtQQVRDSCA1LjQgMzAz
LzMwOV0gY2lmczogZml4IG1vZGUgYml0cyBmcm9tIGRpciBsaXN0aW5nIHdoZW4gbW91bnRlZCB3
aXRoIG1vZGVmcm9tc2lkDQoNCkZyb206IEF1cmVsaWVuIEFwdGVsIDxhYXB0ZWxAc3VzZS5jb20+
DQoNCmNvbW1pdCBlM2UwNTZjMzUxMDg2NjFlNDE4YzgwM2FkZmMwNTRiZjY4MzQyNmU3IHVwc3Ry
ZWFtLg0KDQpXaGVuIG1vdW50aW5nIHdpdGggLW8gbW9kZWZyb21zaWQsIHRoZSBtb2RlIGJpdHMg
YXJlIHN0b3JlZCBpbiBhbiBBQ0UuIERpcmVjdG9yeSBlbnVtZXJhdGlvbiAoZS5nLiBscyAtbCAv
bW50KSB0cmlnZ2VycyBhbiBTTUIgUXVlcnkgRGlyIHdoaWNoIGRvZXMgbm90IGluY2x1ZGUgQUNF
cyBpbiBpdHMgcmVzcG9uc2UuIFRoZSBtb2RlIGJpdHMgaW4gdGhpcyBjYXNlIGFyZSBzaWxlbnRs
eSBzZXQgdG8gYSBkZWZhdWx0IHZhbHVlIG9mIDc1NSBpbnN0ZWFkLg0KDQpUaGlzIHBhdGNoIG1h
cmtzIHRoZSBkZW50cnkgY3JlYXRlZCBkdXJpbmcgdGhlIGRpcmVjdG9yeSBlbnVtZXJhdGlvbiBh
cyBuZWVkaW5nIHJlLWV2YWx1YXRpb24gKGkuZS4gYWRkaXRpb25hbCBRdWVyeSBJbmZvIHdpdGgg
QUNFcykgc28gdGhhdCB0aGUgbW9kZSBiaXRzIGNhbiBiZSBwcm9wZXJseSBleHRyYWN0ZWQuDQoN
ClF1aWNrIHJlcHJvOg0KDQokIG1vdW50LmNpZnMgLy93aW4xOS50ZXN0L2RhdGEgL21udCAtbyAu
Li4sbW9kZWZyb21zaWQgJCB0b3VjaCAvbW50L2ZvbyAmJiBjaG1vZCA3NTEgL21udC9mb28gJCBz
dGF0IC9tbnQvZm9vDQogICMgcmVwb3J0cyA3NTEgKE9LKQ0KJCBzbGVlcCAyDQogICMgZGVudHJ5
IG9sZGVyIHRoYW4gMXMgYnkgZGVmYXVsdCBnZXQgaW52YWxpZGF0ZWQgJCBscyAtbCAvbW50DQog
ICMgc2luY2UgZGVudHJ5IGludmFsaWQsIGxzIGRvZXMgYSBRdWVyeSBEaXINCiAgIyBhbmQgcmVw
b3J0cyBmb28gYXMgNzU1IChXUk9ORykNCg0KU2lnbmVkLW9mZi1ieTogQXVyZWxpZW4gQXB0ZWwg
PGFhcHRlbEBzdXNlLmNvbT4NClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hA
bWljcm9zb2Z0LmNvbT4NCkNDOiBTdGFibGUgPHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc+DQpSZXZp
ZXdlZC1ieTogUGF2ZWwgU2hpbG92c2t5IDxwc2hpbG92QG1pY3Jvc29mdC5jb20+DQpTaWduZWQt
b2ZmLWJ5OiBHcmVnIEtyb2FoLUhhcnRtYW4gPGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPg0K
DQotLS0NCiBmcy9jaWZzL3JlYWRkaXIuYyB8ICAgIDMgKystDQogMSBmaWxlIGNoYW5nZWQsIDIg
aW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KDQotLS0gYS9mcy9jaWZzL3JlYWRkaXIuYw0K
KysrIGIvZnMvY2lmcy9yZWFkZGlyLmMNCkBAIC0xNzQsNyArMTc0LDggQEAgY2lmc19maWxsX2Nv
bW1vbl9pbmZvKHN0cnVjdCBjaWZzX2ZhdHRyDQogCSAqIG1heSBsb29rIHdyb25nIHNpbmNlIHRo
ZSBpbm9kZXMgbWF5IG5vdCBoYXZlIHRpbWVkIG91dCBieSB0aGUgdGltZQ0KIAkgKiAibHMiIGRv
ZXMgYSBzdGF0KCkgY2FsbCBvbiB0aGVtLg0KIAkgKi8NCi0JaWYgKGNpZnNfc2ItPm1udF9jaWZz
X2ZsYWdzICYgQ0lGU19NT1VOVF9DSUZTX0FDTCkNCisJaWYgKChjaWZzX3NiLT5tbnRfY2lmc19m
bGFncyAmIENJRlNfTU9VTlRfQ0lGU19BQ0wpIHx8DQorCSAgICAoY2lmc19zYi0+bW50X2NpZnNf
ZmxhZ3MgJiBDSUZTX01PVU5UX01PREVfRlJPTV9TSUQpKQ0KIAkJZmF0dHItPmNmX2ZsYWdzIHw9
IENJRlNfRkFUVFJfTkVFRF9SRVZBTDsNCiANCiAJaWYgKGNpZnNfc2ItPm1udF9jaWZzX2ZsYWdz
ICYgQ0lGU19NT1VOVF9VTlhfRU1VTCAmJg0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UgRW5kLS0t
LS0NCg0KSGkgR3JlZywNCg0KVGhpcyBwYXRjaCBmaXhlcyB0aGUgZm9sbG93aW5nIGNvbW1pdCB0
aGF0IHdhcyBpbnRyb2R1Y2VkIGluIHY1LjU6DQoNCmNvbW1pdCBmZGVmNjY1YmE0NGFkNWVkMTU0
YWYyYWNmYjE5YWUyZWUzYmY1ZGNjDQpBdXRob3I6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWlj
cm9zb2Z0LmNvbT4NCkRhdGU6ICAgRnJpIERlYyA2IDAyOjAyOjM4IDIwMTkgLTA2MDANCg0KICAg
IHNtYjM6IGZpeCBtb2RlIHBhc3NlZCBpbiBvbiBjcmVhdGUgZm9yIG1vZGV0b3NpZCBtb3VudCBv
cHRpb24NCg0KDQpQbGVhc2UgcmVtb3ZlIHRoZSBwYXRjaCBmcm9tIGFsbCBzdGFibGUgdHJlZXMg
ZXhwZWN0IDUuNS55Lg0KDQotLQ0KQmVzdCByZWdhcmRzLA0KUGF2ZWwgU2hpbG92c2t5DQo=
