Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A62B211FD7A
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 05:08:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbfLPEIm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 23:08:42 -0500
Received: from mail-eopbgr700067.outbound.protection.outlook.com ([40.107.70.67]:38240
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726528AbfLPEIm (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Dec 2019 23:08:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GeRuxtRHtx5drprv7W3bXsdK1+MJec9wk5gPEC1Po8s+E0vHg9BJhlpN/Y3m82OhJOBRkyt1RA/2LZkWbjfeVoTMTVAy5aPEpsC7xG1Ma5oXXkKbZUtvX8fHbMC0e8RBJ6+cao2a3UqwXEIXjzhnWQGTbFjNoD4OWz/EBU92mwaL7yyXGory1yOgdFeNdsNhYtSDaJEMLH3cOyfyWnIimwogPAh5yE59TZLNyPX3AwiiPYE2BVsNQIE0z55MXbxyE4S9GeiQKfqhXDCNI9MArKeBm191E3CZSThAFu475xWXX8PVbpgPCF3zFUd8lSz/rvTiSP20C3CfYISREnFm3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QgLB6cDN/5G29IR7O4CUeyPZjeviyREwYPnNTGwq0dw=;
 b=V0F4wjIeLn+FOKc46CeNVdTaBxG4mC8mOqydlxgaXV/6wnzR0nXbnHwx03uNzXaQyVS8N1kB+u6igqLciYe98wa7go1H2yDYLbLW7vZBLzI3u2w4DH0Ova3wL7OSz5U1W+XDWpaYJW/X41fl4IuDRrbBpdCHAj3fnI8CnSZ5i3EDQIuyiPLeNavLChzwXc0a3ZwVk8P3nl/A9IHlfNX5lY1R+1Tih3WA0zQcwd/wh28nWPDViY9IbNKXWbdxNrbY2UhENCHQYmvDrhD7ub1n6EJ+GHrUaZqRSGuv99CG91JESlDcRntt4gmk5IUACoLI53R3s48a6O9kVGwzKgcfcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QgLB6cDN/5G29IR7O4CUeyPZjeviyREwYPnNTGwq0dw=;
 b=C6XEcviuVWfhsWISYO37JPD/Son9mOeDOeZxWoWiOchEHQas/3IfViusHXaBjxy9aOhRInXyd9MKm/nIAYOtimWqIgQdf8dbsxifB1opINxfgY1JtcI0wWru586Vzzyqh0EGO8oBM2piQtKHzcOu4rfC7csaupW65az/58fYbnE=
Received: from MN2PR05MB6208.namprd05.prod.outlook.com (20.178.241.91) by
 MN2PR05MB7070.namprd05.prod.outlook.com (52.135.39.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.12; Mon, 16 Dec 2019 04:08:39 +0000
Received: from MN2PR05MB6208.namprd05.prod.outlook.com
 ([fe80::ed0d:9029:720c:1459]) by MN2PR05MB6208.namprd05.prod.outlook.com
 ([fe80::ed0d:9029:720c:1459%2]) with mapi id 15.20.2559.012; Mon, 16 Dec 2019
 04:08:39 +0000
From:   Ajay Kaher <akaher@vmware.com>
To:     Steven Rostedt <srostedt@vmware.com>,
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
Thread-Index: AQHVrz5HlBvia6jSn0un3fZ4VmcqWae4Wy0AgAQvaoA=
Date:   Mon, 16 Dec 2019 04:08:38 +0000
Message-ID: <3E51A6DE-956D-4D3F-82FB-F2FBBE4ED8F4@vmware.com>
References: <1575999773-4628-1-git-send-email-akaher@vmware.com>
 <1575999773-4628-9-git-send-email-akaher@vmware.com>
 <adec37a3ad29152f5e2e7fc6eb99ae909a4861d3.camel@vmware.com>
In-Reply-To: <adec37a3ad29152f5e2e7fc6eb99ae909a4861d3.camel@vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=akaher@vmware.com; 
x-originating-ip: [103.19.212.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 14a7d572-874e-410f-3cef-08d781dda162
x-ms-traffictypediagnostic: MN2PR05MB7070:|MN2PR05MB7070:|MN2PR05MB7070:
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR05MB707043881EF6A1A04A84251ABB510@MN2PR05MB7070.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1303;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(376002)(346002)(366004)(136003)(52314003)(199004)(189003)(6486002)(64756008)(66446008)(91956017)(86362001)(66556008)(5660300002)(66476007)(66946007)(6512007)(81156014)(2616005)(76116006)(2906002)(186003)(6506007)(26005)(8676002)(33656002)(71200400001)(4744005)(8936002)(36756003)(81166006)(54906003)(316002)(110136005)(4001150100001)(4326008)(478600001)(107886003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR05MB7070;H:MN2PR05MB6208.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zw79ZSzbQro1zJzEy0NkNOX03eXRjCnytXegiZnR8lHPdQnEgGHRjEFLtHYEmzlK/JIFGHGAcZ+rYQqPkEOnzfT8wOy14g8BxQB8Yf7tUy5Q4+snD2A2aFcPVC0SOWwFb59ZOsSaHl8sy+0yTAgcQJXliToM8Ms0znFJSz2LIjMcIHIQiygai4onfYWyobfA6KaLPG9hale9d41WZ6iHRTVBymE1hAYqFLKQSYMXbfks5X6uMdMrfEYU9ZRhsyvBURT2m9FYYZxqpOoJas3vnOI4mgGr78/vKyslNYejRGtSEAOtEEBz2bgpnXqziBsBsSvdnc111AYjPUVxrkcNJPQwe6YqRc3mT0c4eJZAWSgFV4eHE6iC4nuqYJbfc9M4lsyn71qLv/ZkzlEZz09PW+223F+WY5iJcHeNuajlqLLhgf9O7dCEUt1jhI7cDPsK4a0qoH6gZFry0ySkuYQFHMQuzhgRtQ+TQQ9htHeGLt1+x5TTL3NX0XJG7oaj3tDm
Content-Type: text/plain; charset="utf-8"
Content-ID: <0D06094E7388E24CBFEE21C338D7819D@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14a7d572-874e-410f-3cef-08d781dda162
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 04:08:39.0370
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rjpiUzMYD/5O6DAV4F4Xj58+dRYyWxCyti8GL8wrKQKb56/+jXlM3MWo6HA96IQwpVUe4QK1PrfkY114WhTpAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR05MB7070
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCu+7v09uIDEzLzEyLzE5LCAxMToxMyBQTSwgIlN0ZXZlbiBSb3N0ZWR0IiA8c3Jvc3RlZHRA
dm13YXJlLmNvbT4gd3JvdGU6DQoNCj4gT24gVHVlLCAyMDE5LTEyLTEwIGF0IDIzOjEyICswNTMw
LCBBamF5IEthaGVyIHdyb3RlOg0KPj4gVGhlIHg4NiB2ZXJzaW9uIG9mIGdldF91c2VyX3BhZ2Vz
X2Zhc3QoKSByZWxpZXMgb24gZGlzYWJsZWQgaW50ZXJydXB0cyB0bw0KPj4gc3luY2hyb25pemUg
Z3VwX3B0ZV9yYW5nZSgpIGJldHdlZW4gZ3VwX2dldF9wdGUocHRlcCk7IGFuZCBnZXRfcGFnZSgp
IGFnYWluc3QNCj4+IGEgcGFyYWxsZWwgbXVubWFwLiBUaGUgbXVubWFwIHNpZGUgbnVsbHMgdGhl
IHB0ZSwgdGhlbiBmbHVzaGVzIFRMQnMsIHRoZW4NCj4+IHJlbGVhc2VzIHRoZSBwYWdlLiBBcyBU
TEIgZmx1c2ggaXMgZG9uZSBzeW5jaHJvbm91c2x5IHZpYSBJUEkgZGlzYWJsaW5nDQo+PiBpbnRl
cnJ1cHRzIGJsb2NrcyB0aGUgcGFnZSByZWxlYXNlLCBhbmQgZ2V0X3BhZ2UoKSwgd2hpY2ggYXNz
dW1lcyBleGlzdGluZw0KPj4gcmVmZXJlbmNlIG9uIHBhZ2UsIGlzIHRodXMgc2FmZS4NCj4+IEhv
d2V2ZXIgd2hlbiBUTEIgZmx1c2ggaXMgZG9uZSBieSBhIGh5cGVyY2FsbCwgZS5nLiBpbiBhIFhl
biBQViBndWVzdCwgdGhlcmUgaXMNCj4+IG5vIGJsb2NraW5nIHRoYW5rcyB0byBkaXNhYmxlZCBp
bnRlcnJ1cHRzLCBhbmQgZ2V0X3BhZ2UoKSBjYW4gc3VjY2VlZCBvbiBhIHBhZ2UNCj4+IHRoYXQg
d2FzIGFscmVhZHkgZnJlZWQgb3IgZXZlbiByZXVzZWQuDQo+ICAgIA0KPiBUaGF0IG11c3QgaGF2
ZSBiZWVuIGhlbGwgdG8gZGVidWchDQo+ICAgIA0KPiBBbnl3YXksIHRoZSByZXN0IGxvb2tzIGdv
b2QuDQo+DQo+IC0tIFN0ZXZlDQoNClRoYW5rcyBTdGV2ZSBmb3IgcmV2aWV3Lg0KSSB3aWxsIG1v
dmUgcGFnZV9yZWZfY291bnQoKSBmcm9tIDNyZCBwYXRjaCB0byA1dGggcGF0Y2ggYW5kIHNlbmQg
Z2xvYmFsbHkuDQogDQotIEFqYXkNCiAgICANCiAgICANCg0K
