Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A16D3BC80
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 21:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728317AbfFJTN1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 15:13:27 -0400
Received: from mail-eopbgr780138.outbound.protection.outlook.com ([40.107.78.138]:21120
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728276AbfFJTN1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Jun 2019 15:13:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=TiyfKN2FB9T8O/ayxY8vt9saIri5+cTivPOQWWOjnX584jcmefsz5mo1jFoZUkD02SnPtYmZgF4hPe70EVA/Cy0a9kd1QUAl+SLgHwJ+YLNOyv6AAFfYZ9BMhyargxdDgIsQo7FHaioocVGZSmj/9XVDI5C5aXJDoJA6cFGYezM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gsr+P6cOyLutjR0lZqCuqq3FdbnrdXtSEFCQ4HbaGHc=;
 b=DSjHGjnfubu3SBlD/KoI6hHfQizvGgwcO4Y4gcmgsFbqgQFQ0572+pq2YBm2TviC1+i8+pMTxMIcadj8+rAjOiFH4VefAabHKWZjSmMdIb2BSsMyYdnj+2jr2XarQakFEW/Cza6WNm25D5sYbzqySkccU5zfYttMD9M7NChQisU=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gsr+P6cOyLutjR0lZqCuqq3FdbnrdXtSEFCQ4HbaGHc=;
 b=Ym7rXJL2pyk3+ZFxnmWlng2bD0PKQUuh7P5JNpvgFzFLWDESIK3OhbnrPQPrD+Xj1sWSeMQ8rZGhDlF8aTSnAAWbfgEWlK68xo9JQdChJ9t+PwJqY2QNUZfkiHzY2Vkba/TSf85Ht2p/irvJWCWHuiPUT5P3C5xJez1iwergCGk=
Received: from BYAPR21MB1303.namprd21.prod.outlook.com (2603:10b6:a03:10b::21)
 by BYAPR21MB1365.namprd21.prod.outlook.com (2603:10b6:a03:10c::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2008.1; Mon, 10 Jun
 2019 19:13:24 +0000
Received: from BYAPR21MB1303.namprd21.prod.outlook.com
 ([fe80::d98:b97a:40fb:767b]) by BYAPR21MB1303.namprd21.prod.outlook.com
 ([fe80::d98:b97a:40fb:767b%8]) with mapi id 15.20.2008.002; Mon, 10 Jun 2019
 19:13:24 +0000
From:   Pavel Shilovskiy <pshilov@microsoft.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Christoph Probst <kernel@probst.it>,
        Steven French <Steven.French@microsoft.com>
Subject: RE: [PATCH 4.4 041/241] cifs: fix strcat buffer overflow and reduce
 raciness in smb21_set_oplock_level()
Thread-Topic: [PATCH 4.4 041/241] cifs: fix strcat buffer overflow and reduce
 raciness in smb21_set_oplock_level()
Thread-Index: AQHVHuRr/qIHTPIzFki/7touvMYvRaaVQkzQ
Date:   Mon, 10 Jun 2019 19:13:24 +0000
Message-ID: <BYAPR21MB130347F749FFEC7025DA5710B6130@BYAPR21MB1303.namprd21.prod.outlook.com>
References: <20190609164147.729157653@linuxfoundation.org>
 <20190609164148.958546130@linuxfoundation.org>
In-Reply-To: <20190609164148.958546130@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=pshilov@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-06-10T19:13:23.0872933Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=af47bb5f-d1a3-45e2-ab94-e5af5825fd55;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pshilov@microsoft.com; 
x-originating-ip: [2001:4898:80e8:b:5833:e509:4f11:8dd5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7b9d629a-73b9-44fc-82a1-08d6edd7b617
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:BYAPR21MB1365;
x-ms-traffictypediagnostic: BYAPR21MB1365:
x-microsoft-antispam-prvs: <BYAPR21MB1365617ADD23303BF2520936B6130@BYAPR21MB1365.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:205;
x-forefront-prvs: 0064B3273C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(39860400002)(366004)(376002)(346002)(136003)(13464003)(189003)(199004)(446003)(8936002)(8990500004)(229853002)(7736002)(305945005)(476003)(74316002)(110136005)(53936002)(11346002)(8676002)(86362001)(81156014)(81166006)(256004)(10090500001)(54906003)(486006)(2906002)(22452003)(99286004)(55016002)(76176011)(68736007)(7696005)(9686003)(52396003)(6436002)(316002)(10290500003)(6116002)(107886003)(4326008)(71190400001)(478600001)(186003)(71200400001)(6246003)(46003)(25786009)(14454004)(53546011)(33656002)(66946007)(64756008)(52536014)(2501003)(102836004)(5660300002)(6506007)(76116006)(73956011)(66556008)(66476007)(66446008);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR21MB1365;H:BYAPR21MB1303.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ZBJ+J5l024iUhLA3B++4layCZzV8CA07rQN+XRmCBZqVPG2oSfMgrtwvFfaeZ3E+2m4GyhNeZ/9TfMNutgykZ0VJCnyhH8B8dUFayMjGHi+yhbVmsYINLDEjhflaH0Gry7FcTGD8trViFQHjNTpO9L5yDbc+Oi2G2YxMI66IITITgzmQuAWac1e2572+gk5ENOyy0JrLZ3nc+INvQVWsQI21+6HgpnOLEWPr79/4m3jHsqlMlOg0SEINf1OlWUxTjUrSFpBh4Qim1Ylx8mFzpLtxvi3vXkG+X23IuQ35fCv2b/setIgfOK1rUznY7ZCmVCxz0L/sFT1SNPIp4s4DxRtrpfe8/kJR/xPSWT+n2K9pSINT66g8cXYU/IOljIj+X0LMHcEFESRc6fdm9okZFh/vgGdcYf6ts/p1eClxwpw=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b9d629a-73b9-44fc-82a1-08d6edd7b617
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2019 19:13:24.6620
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pshilov@microsoft.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR21MB1365
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogR3JlZyBLcm9haC1IYXJ0bWFuIDxn
cmVna2hAbGludXhmb3VuZGF0aW9uLm9yZz4gDQpTZW50OiBTdW5kYXksIEp1bmUgOSwgMjAxOSA5
OjQwIEFNDQpUbzogbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KQ2M6IEdyZWcgS3JvYWgt
SGFydG1hbiA8Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc+OyBzdGFibGVAdmdlci5rZXJuZWwu
b3JnOyBDaHJpc3RvcGggUHJvYnN0IDxrZXJuZWxAcHJvYnN0Lml0PjsgUGF2ZWwgU2hpbG92c2tp
eSA8cHNoaWxvdkBtaWNyb3NvZnQuY29tPjsgU3RldmVuIEZyZW5jaCA8U3RldmVuLkZyZW5jaEBt
aWNyb3NvZnQuY29tPg0KU3ViamVjdDogW1BBVENIIDQuNCAwNDEvMjQxXSBjaWZzOiBmaXggc3Ry
Y2F0IGJ1ZmZlciBvdmVyZmxvdyBhbmQgcmVkdWNlIHJhY2luZXNzIGluIHNtYjIxX3NldF9vcGxv
Y2tfbGV2ZWwoKQ0KDQpGcm9tOiBDaHJpc3RvcGggUHJvYnN0IDxrZXJuZWxAcHJvYnN0Lml0Pg0K
DQpjb21taXQgNmE1NGIyZTAwMmM5ZDAwYjM5OGQzNTcyNGM3OWY5ZmUwZDliMzhmYiB1cHN0cmVh
bS4NCg0KQ2hhbmdlIHN0cmNhdCB0byBzdHJuY3B5IGluIHRoZSAiTm9uZSIgY2FzZSB0byBmaXgg
YSBidWZmZXIgb3ZlcmZsb3cgd2hlbiBjaW5vZGUtPm9wbG9jayBpcyByZXNldCB0byAwIGJ5IGFu
b3RoZXIgdGhyZWFkIGFjY2Vzc2luZyB0aGUgc2FtZSBjaW5vZGUuIEl0IGlzIG5ldmVyIHZhbGlk
IHRvIGFwcGVuZCAiTm9uZSIgdG8gYW55IG90aGVyIG1lc3NhZ2UuDQoNCkNvbnNvbGlkYXRlIG11
bHRpcGxlIHdyaXRlcyB0byBjaW5vZGUtPm9wbG9jayB0byByZWR1Y2UgcmFjaW5lc3MuDQoNClNp
Z25lZC1vZmYtYnk6IENocmlzdG9waCBQcm9ic3QgPGtlcm5lbEBwcm9ic3QuaXQ+DQpSZXZpZXdl
ZC1ieTogUGF2ZWwgU2hpbG92c2t5IDxwc2hpbG92QG1pY3Jvc29mdC5jb20+DQpTaWduZWQtb2Zm
LWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+DQpDQzogU3RhYmxlIDxz
dGFibGVAdmdlci5rZXJuZWwub3JnPg0KU2lnbmVkLW9mZi1ieTogR3JlZyBLcm9haC1IYXJ0bWFu
IDxncmVna2hAbGludXhmb3VuZGF0aW9uLm9yZz4NCi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tDQoNCkhpIEdyZWcsDQoNClRoaXMgcGF0Y2ggaGFzIGJlZW4gcXVldWVkIGZvciA0LjQu
eSBhbmQgaGFzIGFscmVhZHkgYmVlbiBtZXJnZWQgaW50byA1LjEueSAoNS4xLjUpLiBBcmUgeW91
IGdvaW5nIHRvIGFwcGx5IGl0IHRvIG90aGVyIHN0YWJsZSBrZXJuZWxzOiA0LjksIDQuMTQsIDQu
MTk/DQoNCkJlc3QgcmVnYXJkcywNClBhdmVsIFNoaWxvdnNreQ0K
