Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2445A11E961
	for <lists+stable@lfdr.de>; Fri, 13 Dec 2019 18:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728413AbfLMRng (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Dec 2019 12:43:36 -0500
Received: from mail-eopbgr770059.outbound.protection.outlook.com ([40.107.77.59]:10213
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728207AbfLMRng (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Dec 2019 12:43:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kkI0gGtPU8KHOZwfvsfaMbxpnPIV1A2g1nzQYUejpohP8SWgTGUf1T+6JfRkSj7EK6g3CCznR8yWx0qFDNBESq7sJiLVVVG6FoNqiR7yoCB4N0X0V7LrbYMNlEMw57QUIuQqGTVCBt7LiDcDTmo8prc05kkAJROkAT9qaYuFgdqTlnOkBLyrUr2nJx7zD7IRvl8DWWu0h1F0n8/Si9ftCzkeAMmYMvaaNtg8OC3TaQyUVfDzu9sT1hVU2IaYbWkod49QGr9wBo3dpHUXKb75Ebdpe7OBkHoQF2IBRXuknVDevwyQ633WR63ZB+8EUUf2oUwQKzjwv3coliIOZhTxVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JiD0TcMs4VbgSAQs43o0oT8Tktq76sALSxiq9AyAhUY=;
 b=nXHYXP2XPhU+1I5X/mcDRjESgMeQroBytQUwLSQatXiPAQdkpMk3BC949ezMnr3XUKXOykglUyW1vemZ5aiGqJO7yTEcR1V5PEIaYvOy53951RLRADph8LxhAhcg7IHE9ElQvJhssfGdXIowW4JpI7dorfXPzZ/qPhirods7QbP2exVpscQIyAUD3+ODK88G0WT/U/cJXJsZRqvJfJOdfs7vnO7sApbFWlHHEc1EJ7HaZgTZPHxsp2oYtQaNVhXFjqaljVdxMzdz3I6ji5PnsxD2eYv3mkcU7odYjbZ+w5fn+y5XHR6JuEUMaG+RsHWnFHdxknsx3BKmenbQTdBlJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JiD0TcMs4VbgSAQs43o0oT8Tktq76sALSxiq9AyAhUY=;
 b=Bgrw2fVV0VqpErgVkayWkFhGQv9XWf9hLLie94M0iiZ1Ltc0cDEeHYTykqqz9w1BJtTk+5GMf1zgO6JIbNCk2XpoNtYtxJqBnAzLF40NxBRrcEyAIVp8ZvNGSNdpCn1VTSETdpjD16ctXi+DQQfZ30Ir5Hk71lx2JknR/rt6+sE=
Received: from DM5PR0501MB3799.namprd05.prod.outlook.com (10.167.110.15) by
 DM5PR0501MB3781.namprd05.prod.outlook.com (10.167.110.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.10; Fri, 13 Dec 2019 17:43:30 +0000
Received: from DM5PR0501MB3799.namprd05.prod.outlook.com
 ([fe80::c971:9c8b:a1d6:c23a]) by DM5PR0501MB3799.namprd05.prod.outlook.com
 ([fe80::c971:9c8b:a1d6:c23a%7]) with mapi id 15.20.2538.016; Fri, 13 Dec 2019
 17:43:30 +0000
From:   Steven Rostedt <srostedt@vmware.com>
To:     Ajay Kaher <akaher@vmware.com>,
        linux-kernel-review <linux-kernel-review@vmware.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Vikash Bansal <bvikas@vmware.com>,
        Srinidhi Rao <srinidhir@vmware.com>,
        Vasavi Sirnapalli <vsirnapalli@vmware.com>,
        Anish Swaminathan <anishs@vmware.com>
Subject: Re: [linux-kernel-review] [PATCH v3 8/8] x86, mm, gup: prevent
 get_page() race with munmap in paravirt guest
Thread-Topic: [linux-kernel-review] [PATCH v3 8/8] x86, mm, gup: prevent
 get_page() race with munmap in paravirt guest
Thread-Index: AQHVsdzUTJ7WIkaTgkS4juK9d1606g==
Date:   Fri, 13 Dec 2019 17:43:30 +0000
Message-ID: <adec37a3ad29152f5e2e7fc6eb99ae909a4861d3.camel@vmware.com>
References: <1575999773-4628-1-git-send-email-akaher@vmware.com>
         <1575999773-4628-9-git-send-email-akaher@vmware.com>
In-Reply-To: <1575999773-4628-9-git-send-email-akaher@vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=srostedt@vmware.com; 
x-originating-ip: [66.24.58.225]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5140f4c2-3b34-4e63-bf35-08d77ff3f78d
x-ms-traffictypediagnostic: DM5PR0501MB3781:|DM5PR0501MB3781:|DM5PR0501MB3781:
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR0501MB378153AD13007DB9C23A608AB3540@DM5PR0501MB3781.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:901;
x-forefront-prvs: 0250B840C1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(376002)(346002)(136003)(39860400002)(199004)(189003)(52314003)(478600001)(66556008)(54906003)(66476007)(26005)(81166006)(81156014)(186003)(8676002)(2616005)(4744005)(316002)(76116006)(91956017)(4326008)(71200400001)(110136005)(107886003)(2906002)(4001150100001)(36756003)(86362001)(6486002)(66946007)(6506007)(5660300002)(8936002)(6512007)(64756008)(66446008);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR0501MB3781;H:DM5PR0501MB3799.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sI3/Sb/Xve+4HpijNW+YnKPCqNOTvEXRBLf4BfH+wL64rAwe2N3BIRm1adA17DHYy7lKTMsy7KRT8mNAtIWFpxwN0S8ocH6NZf9sNpgaXcIovupT+u6/Q0jE7NGkkImFuq/9Ktv6YO0qqjo1OnAZTj2oD3sRpX0fiOQtERNAuLh67zxUTBb+gZIPoXNxsB0GDinGX6zkErQlazeLcysM3io0+9+JE0Oaany7z7aISR0H3cYggPoEETap4GmCrt8nEXHuLv2ruIHFsIvk7voLhkmAwF6pbXIHHP7uv83Y3Drpp0wY9Eys5oSBhPJDLtoRynIfpEzmukyCy3aRIB3ycGvGcJdlF0J7qKrKr3jzkDvGz+YeThEU49vT0Opxt3oMIH3CsAdlkhNOQo7FABTd/wLIK4cQbjEP4qVituaj8qzBXgA4L7twV60K1VmbcDgwHIXizkgg9b4aDPhpbMs4WvnaR865RgJacyCtPjfu/N/bPhs3aEhOqH5uBIt+P9O5
Content-Type: text/plain; charset="utf-8"
Content-ID: <608F458E1415B34A811C46241DAD18DB@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5140f4c2-3b34-4e63-bf35-08d77ff3f78d
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2019 17:43:30.1827
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lSDRRt9x86D9OushTI3qiMk1gET58Ra7ALla6mnFDIn50f3nAlaYbc8DnrCI6FU/Uh/Ln8BULuLxKO9KkUWfOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR0501MB3781
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVHVlLCAyMDE5LTEyLTEwIGF0IDIzOjEyICswNTMwLCBBamF5IEthaGVyIHdyb3RlOg0KPiBU
aGUgeDg2IHZlcnNpb24gb2YgZ2V0X3VzZXJfcGFnZXNfZmFzdCgpIHJlbGllcyBvbiBkaXNhYmxl
ZCBpbnRlcnJ1cHRzIHRvDQo+IHN5bmNocm9uaXplIGd1cF9wdGVfcmFuZ2UoKSBiZXR3ZWVuIGd1
cF9nZXRfcHRlKHB0ZXApOyBhbmQgZ2V0X3BhZ2UoKSBhZ2FpbnN0DQo+IGEgcGFyYWxsZWwgbXVu
bWFwLiBUaGUgbXVubWFwIHNpZGUgbnVsbHMgdGhlIHB0ZSwgdGhlbiBmbHVzaGVzIFRMQnMsIHRo
ZW4NCj4gcmVsZWFzZXMgdGhlIHBhZ2UuIEFzIFRMQiBmbHVzaCBpcyBkb25lIHN5bmNocm9ub3Vz
bHkgdmlhIElQSSBkaXNhYmxpbmcNCj4gaW50ZXJydXB0cyBibG9ja3MgdGhlIHBhZ2UgcmVsZWFz
ZSwgYW5kIGdldF9wYWdlKCksIHdoaWNoIGFzc3VtZXMgZXhpc3RpbmcNCj4gcmVmZXJlbmNlIG9u
IHBhZ2UsIGlzIHRodXMgc2FmZS4NCj4gSG93ZXZlciB3aGVuIFRMQiBmbHVzaCBpcyBkb25lIGJ5
IGEgaHlwZXJjYWxsLCBlLmcuIGluIGEgWGVuIFBWIGd1ZXN0LCB0aGVyZSBpcw0KPiBubyBibG9j
a2luZyB0aGFua3MgdG8gZGlzYWJsZWQgaW50ZXJydXB0cywgYW5kIGdldF9wYWdlKCkgY2FuIHN1
Y2NlZWQgb24gYSBwYWdlDQo+IHRoYXQgd2FzIGFscmVhZHkgZnJlZWQgb3IgZXZlbiByZXVzZWQu
DQoNClRoYXQgbXVzdCBoYXZlIGJlZW4gaGVsbCB0byBkZWJ1ZyENCg0KQW55d2F5LCB0aGUgcmVz
dCBsb29rcyBnb29kLg0KDQotLSBTdGV2ZQ0KDQo=
