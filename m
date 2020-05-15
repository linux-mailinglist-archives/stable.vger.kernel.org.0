Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 474E91D424A
	for <lists+stable@lfdr.de>; Fri, 15 May 2020 02:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728176AbgEOApv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 20:45:51 -0400
Received: from mo-csw1114.securemx.jp ([210.130.202.156]:59580 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726170AbgEOApv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 May 2020 20:45:51 -0400
Received: by mo-csw.securemx.jp (mx-mo-csw1114) id 04F0jgGh020975; Fri, 15 May 2020 09:45:42 +0900
X-Iguazu-Qid: 2wHHbNmoGMHnGCmPdh
X-Iguazu-QSIG: v=2; s=0; t=1589503542; q=2wHHbNmoGMHnGCmPdh; m=CIv/WuvnLP0cEQsaDuSuQUiepBDENTA+WDJwM6NL6GQ=
Received: from imx12.toshiba.co.jp (imx12.toshiba.co.jp [61.202.160.132])
        by relay.securemx.jp (mx-mr1111) id 04F0jfTr019797;
        Fri, 15 May 2020 09:45:42 +0900
Received: from enc02.toshiba.co.jp ([61.202.160.51])
        by imx12.toshiba.co.jp  with ESMTP id 04F0jfA8001778;
        Fri, 15 May 2020 09:45:41 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id 04F0jfBs006066;
        Fri, 15 May 2020 09:45:41 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AaZahPcZ+Pr/haabQnY8tCOqzaNGYlgTPik4dQKdAmK9WC38vs+X4uoeIZYh6kQz81fwXWCKBK7n+w0VhMPWI0a37449+X9Udh1s4Bprc5O1mFjx0oQTdfzueKueUjWZq/NOEc5X3pqcfROFW9s8Hur7Ozb0EqW2Cuw8oX68LfL2y7G1WwJv7BJW5dUI9KARvEApBlPTARCMcrKfn+580ftV0mL+KLn9XZOtH51NSRWLeJ3vowUxqorpQj/G73Oz6OycCA3WhPRT9NuRP9ySGKRKXAtDnzjPRmPg0Vro17u2RakSqfjtPnOMu4H+SL0zaWZ87x68zWP/vfv2e/T8Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tcs2B+pTWy/6ve+u4U/JoxE0pDDjXaGO9Vpbnsn2N6w=;
 b=Mv45MAssg1hnnqJrH3pIgi/L01PtiYo87rp4qtJPGHJjfAPZKmd5Cnj0oeO3xw1M0ltTPXTcq8QHJI5x8pcz4uLnl9nZWkcmKX7X09OGcYdf1FuRqn28l0TEi2Tg+MWNo6Sgkk6uAnlgIyywtiOdg2c36w3sSnwiycnc29tYLykeJbalX3XE1RoOzeTMEL7DM4obm5Fv+TT9WrGhFaahw+V0ZNjgN959MA6BPqzmozYyV0hDwZByZcysd1jFLFGdn8XwtJSkW98ETZWMoSt2GABviyccbmrjLPc5wC7AEQqR9cF/qvn0j3lW+6zJvZ1rXFGPC0Gd6AOY6ybScugGYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toshiba.co.jp; dmarc=pass action=none
 header.from=toshiba.co.jp; dkim=pass header.d=toshiba.co.jp; arc=none
From:   <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     <nobuhiro1.iwamatsu@toshiba.co.jp>, <stable@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>, <wuxu.wu@huawei.com>,
        <broonie@kernel.org>, <npbuhiro1.iwamatsu@toshiba.co.jp>
Subject: RE: [PATCH for 4.4, 4.9] spi: spi-dw: Add lock protect dw_spi rx/tx
 to prevent concurrent calls
Thread-Topic: [PATCH for 4.4, 4.9] spi: spi-dw: Add lock protect dw_spi rx/tx
 to prevent concurrent calls
Thread-Index: AQHWKlGpXhsRMHusfECINEYEZNjyRqioTwvQ
Date:   Fri, 15 May 2020 00:45:18 +0000
X-TSB-HOP: ON
Message-ID: <TYAPR01MB299075478525B5F04494D49C92BD0@TYAPR01MB2990.jpnprd01.prod.outlook.com>
References: <20200515004056.1069809-1-nobuhiro1.iwamatsu@toshiba.co.jp>
In-Reply-To: <20200515004056.1069809-1-nobuhiro1.iwamatsu@toshiba.co.jp>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
authentication-results: toshiba.co.jp; dkim=none (message not signed)
 header.d=none;toshiba.co.jp; dmarc=none action=none
 header.from=toshiba.co.jp;
x-originating-ip: [103.91.184.3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fac31f94-78d9-4d60-0781-08d7f8693d8d
x-ms-traffictypediagnostic: TYAPR01MB3151:
x-ld-processed: f109924e-fb71-4ba0-b2cc-65dcdf6fbe4f,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <TYAPR01MB31518A3E45831F0F3D87B0B692BD0@TYAPR01MB3151.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:224;
x-forefront-prvs: 04041A2886
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: u32xPmImMhKUbJJM8+F2yn/WMfqd+HIDhMRr1We072YK9D0yM+SzTmIgnnPZJ/SH4Aa0j6bdlrDASCMvACh5LoPZtceY66YEj43vixsJ1O9/l0S++wUFCvJmXMbJtKq2bkPqhxlPVUaqW05d9RmNLBppZhfK0c0oB8llazwA+xWpKgmVTVGaR4gj+Cweg/jBxeMxlz9zm9arNBjszuR+tzzUUg6st5LCoBjoLGpu4zvzO1hEG75rikuWR6UrwbhIyXCyHO2a6JLbQzuFK+WhUX/cosAUrg3FBvxPmQA3yPDcHOMep+1ChSO4lkfHWX+zgy1F2Oyk7CGz0/yVYzkcr+GMtaNUVvu6UMrQT0OHNV+6h/O9fDUW3BHcH5xiV6NZ55t66aAfvUonQYJ7EapG5lH+b74MBaEqKlNhm+JUyiKHh+vLIYvkqcTmqMl1yD4UzTcxj9vi3HJp9bRCFwPZ8wcO8YE6DAlFj+IST3fX7aLZYj1cKYCWqeAgdZh1ijqiF9XIxyRg3r4hN8Mz1b9+0w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYAPR01MB2990.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(366004)(396003)(39860400002)(346002)(26005)(316002)(64756008)(76116006)(66476007)(8676002)(8936002)(66556008)(966005)(5660300002)(478600001)(66446008)(2906002)(52536014)(33656002)(7696005)(54906003)(9686003)(110136005)(86362001)(66946007)(55016002)(53546011)(186003)(4326008)(6506007)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: gCc4Vi/OAAMMD4JkUTfdnUL1sRM47F+rfdeGd5U+dNnJiO15gAggOO0ZLIIPaQ4gvdwzS+eZm+7pjaXSzruGFhTu0mrrOtHZYLSqzO3LGxDsF1nVdV7eSGR9M1nMxeE2tXJHuo+vyFHALkUgxdU0hRNTNjWvUyLYES6M3ZSHyMbCn6tGRM2RgetshRYKtoFqzkuy2uxBwIV37T80bJmWrVH5by95XECEZcSEjdtuEWtWm3cY15FWrCCOOlNIlnlFSKmFLeOTKXAUUuFr2yPPV0/SxVPO/Hc1qEj1nXFL6M/vpmqVRT3aDifzON+kUSOb4/zBtDZ5YntRxJbZznZKzaTjQxczm4i/1nKUOOqqyh/7WK3+BOjUvtX5j9nEGjDWC1KRgNVWZBAorjhfYxjLENke0VlESl3gtkwrsbMCs1qDRQC0V2CdGRnHMPwtBeIpNm8+9aZhkuh+ksUSKgegxOB2ehWDLes9z6H2GeQszSg=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: fac31f94-78d9-4d60-0781-08d7f8693d8d
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2020 00:45:18.2794
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f109924e-fb71-4ba0-b2cc-65dcdf6fbe4f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 91ZatPvZ25MMB8ZncAYssToeMICrcLL/31UItol5D1Y83CFSR4PJ8PPd3xFO1i9/ZC5YykZgVdM0CTjg7QUU8Wq9CS1k0t13Xva7/EQ6WeQ5vnqwGMj7gkQVKc8/zcXn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB3151
MSSCP.TransferMailToMossAgent: 103
X-OriginatorOrg: toshiba.co.jp
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

U29ycnksIHRoaXMgcGF0Y2ggaGF2ZSBhIHR5cG8gaW4gbXkgc2lnbmVkLW9mZi1ieS4NClBsZWFz
ZSBpZ25vcmUuIEkgd2lsbCBzZW5kIHYyIHBhdGNoLg0KDQpCZXN0IHJlZ2FyZHMsDQogIE5vYnVo
aXJvDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogc3RhYmxlLW93bmVy
QHZnZXIua2VybmVsLm9yZyBbbWFpbHRvOnN0YWJsZS1vd25lckB2Z2VyLmtlcm5lbC5vcmddIE9u
IEJlaGFsZiBPZiBOb2J1aGlybyBJd2FtYXRzdQ0KPiBTZW50OiBGcmlkYXksIE1heSAxNSwgMjAy
MCA5OjQxIEFNDQo+IFRvOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+IENjOiBncmVna2hAbGlu
dXhmb3VuZGF0aW9uLm9yZzsgd3V4dS53dSA8d3V4dS53dUBodWF3ZWkuY29tPjsgTWFyayBCcm93
biA8YnJvb25pZUBrZXJuZWwub3JnPjsgTm9idWhpcm8gSXdhbWF0c3UNCj4gPG5wYnVoaXJvMS5p
d2FtYXRzdUB0b3NoaWJhLmNvLmpwPg0KPiBTdWJqZWN0OiBbUEFUQ0ggZm9yIDQuNCwgNC45XSBz
cGk6IHNwaS1kdzogQWRkIGxvY2sgcHJvdGVjdCBkd19zcGkgcngvdHggdG8gcHJldmVudCBjb25j
dXJyZW50IGNhbGxzDQo+IA0KPiBGcm9tOiAid3V4dS53dSIgPHd1eHUud3VAaHVhd2VpLmNvbT4N
Cj4gDQo+IGNvbW1pdCAxOWI2MTM5MmM1YTg1MmI0ZThhMGJmMzVhZWNiOTY5OTgzYzU5MzJkIHVw
c3RyZWFtLg0KPiANCj4gZHdfc3BpX2lycSgpIGFuZCBkd19zcGlfdHJhbnNmZXJfb25lIGNvbmN1
cnJlbnQgY2FsbHMuDQo+IA0KPiBJIGZpbmQgYSBwYW5pYyBpbiBkd193cml0ZXIoKTogdHh3ID0g
Kih1OCAqKShkd3MtPnR4KSwgd2hlbiBkdy0+dHg9PW51bGwsDQo+IGR3LT5sZW49PTQsIGFuZCBk
dy0+dHhfZW5kPT0xLg0KPiANCj4gV2hlbiB0cG0gZHJpdmVyJ3MgbWVzc2FnZSBvdmVydGltZSBk
d19zcGlfaXJxKCkgYW5kIGR3X3NwaV90cmFuc2Zlcl9vbmUNCj4gbWF5IGNvbmN1cnJlbnQgdmlz
aXQgZHdfc3BpLCBzbyBJIHRoaW5rIGR3X3NwaSBzdHJ1Y3R1cmUgbGFjayBvZiBwcm90ZWN0aW9u
Lg0KPiANCj4gT3RoZXJ3aXNlIGR3X3NwaV90cmFuc2Zlcl9vbmUgc2V0IGR3IHJ4L3R4IGJ1ZmZl
ciBhbmQgdGhlbiBvcGVuIGlycSwNCj4gc3RvcmUgZHcgcngvdHggaW5zdHJ1Y3Rpb25zIGFuZCBv
dGhlciBjb3JlcyBoYW5kbGUgaXJxIGxvYWQgZHcgcngvdHgNCj4gaW5zdHJ1Y3Rpb25zIG1heSBv
dXQgb2Ygb3JkZXIuDQo+IA0KPiAJWyAxMDI1LjMyMTMwMl0gQ2FsbCB0cmFjZToNCj4gCS4uLg0K
PiAJWyAxMDI1LjMyMTMxOV0gIF9fY3Jhc2hfa2V4ZWMrMHg5OC8weDE0OA0KPiAJWyAxMDI1LjMy
MTMyM10gIHBhbmljKzB4MTdjLzB4MzE0DQo+IAlbIDEwMjUuMzIxMzI5XSAgZGllKzB4MjljLzB4
MmU4DQo+IAlbIDEwMjUuMzIxMzM0XSAgZGllX2tlcm5lbF9mYXVsdCsweDY4LzB4NzgNCj4gCVsg
MTAyNS4zMjEzMzddICBfX2RvX2tlcm5lbF9mYXVsdCsweDkwLzB4YjANCj4gCVsgMTAyNS4zMjEz
NDZdICBkb19wYWdlX2ZhdWx0KzB4ODgvMHg1MDANCj4gCVsgMTAyNS4zMjEzNDddICBkb190cmFu
c2xhdGlvbl9mYXVsdCsweGE4LzB4YjgNCj4gCVsgMTAyNS4zMjEzNDldICBkb19tZW1fYWJvcnQr
MHg2OC8weDExOA0KPiAJWyAxMDI1LjMyMTM1MV0gIGVsMV9kYSsweDIwLzB4OGMNCj4gCVsgMTAy
NS4zMjEzNjJdICBkd193cml0ZXIrMHhjOC8weGQwDQo+IAlbIDEwMjUuMzIxMzY0XSAgaW50ZXJy
dXB0X3RyYW5zZmVyKzB4NjAvMHgxMTANCj4gCVsgMTAyNS4zMjEzNjVdICBkd19zcGlfaXJxKzB4
NDgvMHg3MA0KPiAJLi4uDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiB3dXh1Lnd1IDx3dXh1Lnd1QGh1
YXdlaS5jb20+DQo+IExpbms6IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL3IvMTU3Nzg0OTk4MS0z
MTQ4OS0xLWdpdC1zZW5kLWVtYWlsLXd1eHUud3VAaHVhd2VpLmNvbQ0KPiBTaWduZWQtb2ZmLWJ5
OiBNYXJrIEJyb3duIDxicm9vbmllQGtlcm5lbC5vcmc+DQo+IFNpZ25lZC1vZmYtYnk6IE5vYnVo
aXJvIEl3YW1hdHN1IChDSVApIDxucGJ1aGlybzEuaXdhbWF0c3VAdG9zaGliYS5jby5qcD4NCj4g
LS0tDQo+ICBkcml2ZXJzL3NwaS9zcGktZHcuYyB8IDE1ICsrKysrKysrKysrKy0tLQ0KPiAgZHJp
dmVycy9zcGkvc3BpLWR3LmggfCAgMSArDQo+ICAyIGZpbGVzIGNoYW5nZWQsIDEzIGluc2VydGlv
bnMoKyksIDMgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zcGkvc3Bp
LWR3LmMgYi9kcml2ZXJzL3NwaS9zcGktZHcuYw0KPiBpbmRleCA4N2EwZTQ3ZWVhZTY0Li40ZWRk
MzhkMDNiOTM5IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3NwaS9zcGktZHcuYw0KPiArKysgYi9k
cml2ZXJzL3NwaS9zcGktZHcuYw0KPiBAQCAtMTgwLDkgKzE4MCwxMSBAQCBzdGF0aWMgaW5saW5l
IHUzMiByeF9tYXgoc3RydWN0IGR3X3NwaSAqZHdzKQ0KPiANCj4gIHN0YXRpYyB2b2lkIGR3X3dy
aXRlcihzdHJ1Y3QgZHdfc3BpICpkd3MpDQo+ICB7DQo+IC0JdTMyIG1heCA9IHR4X21heChkd3Mp
Ow0KPiArCXUzMiBtYXg7DQo+ICAJdTE2IHR4dyA9IDA7DQo+IA0KPiArCXNwaW5fbG9jaygmZHdz
LT5idWZfbG9jayk7DQo+ICsJbWF4ID0gdHhfbWF4KGR3cyk7DQo+ICAJd2hpbGUgKG1heC0tKSB7
DQo+ICAJCS8qIFNldCB0aGUgdHggd29yZCBpZiB0aGUgdHJhbnNmZXIncyBvcmlnaW5hbCAidHgi
IGlzIG5vdCBudWxsICovDQo+ICAJCWlmIChkd3MtPnR4X2VuZCAtIGR3cy0+bGVuKSB7DQo+IEBA
IC0xOTQsMTMgKzE5NiwxNiBAQCBzdGF0aWMgdm9pZCBkd193cml0ZXIoc3RydWN0IGR3X3NwaSAq
ZHdzKQ0KPiAgCQlkd193cml0ZV9pb19yZWcoZHdzLCBEV19TUElfRFIsIHR4dyk7DQo+ICAJCWR3
cy0+dHggKz0gZHdzLT5uX2J5dGVzOw0KPiAgCX0NCj4gKwlzcGluX3VubG9jaygmZHdzLT5idWZf
bG9jayk7DQo+ICB9DQo+IA0KPiAgc3RhdGljIHZvaWQgZHdfcmVhZGVyKHN0cnVjdCBkd19zcGkg
KmR3cykNCj4gIHsNCj4gLQl1MzIgbWF4ID0gcnhfbWF4KGR3cyk7DQo+ICsJdTMyIG1heDsNCj4g
IAl1MTYgcnh3Ow0KPiANCj4gKwlzcGluX2xvY2soJmR3cy0+YnVmX2xvY2spOw0KPiArCW1heCA9
IHJ4X21heChkd3MpOw0KPiAgCXdoaWxlIChtYXgtLSkgew0KPiAgCQlyeHcgPSBkd19yZWFkX2lv
X3JlZyhkd3MsIERXX1NQSV9EUik7DQo+ICAJCS8qIENhcmUgcnggb25seSBpZiB0aGUgdHJhbnNm
ZXIncyBvcmlnaW5hbCAicngiIGlzIG5vdCBudWxsICovDQo+IEBAIC0yMTIsNiArMjE3LDcgQEAg
c3RhdGljIHZvaWQgZHdfcmVhZGVyKHN0cnVjdCBkd19zcGkgKmR3cykNCj4gIAkJfQ0KPiAgCQlk
d3MtPnJ4ICs9IGR3cy0+bl9ieXRlczsNCj4gIAl9DQo+ICsJc3Bpbl91bmxvY2soJmR3cy0+YnVm
X2xvY2spOw0KPiAgfQ0KPiANCj4gIHN0YXRpYyB2b2lkIGludF9lcnJvcl9zdG9wKHN0cnVjdCBk
d19zcGkgKmR3cywgY29uc3QgY2hhciAqbXNnKQ0KPiBAQCAtMjg0LDYgKzI5MCw3IEBAIHN0YXRp
YyBpbnQgZHdfc3BpX3RyYW5zZmVyX29uZShzdHJ1Y3Qgc3BpX21hc3RlciAqbWFzdGVyLA0KPiAg
ew0KPiAgCXN0cnVjdCBkd19zcGkgKmR3cyA9IHNwaV9tYXN0ZXJfZ2V0X2RldmRhdGEobWFzdGVy
KTsNCj4gIAlzdHJ1Y3QgY2hpcF9kYXRhICpjaGlwID0gc3BpX2dldF9jdGxkYXRhKHNwaSk7DQo+
ICsJdW5zaWduZWQgbG9uZyBmbGFnczsNCj4gIAl1OCBpbWFzayA9IDA7DQo+ICAJdTE2IHR4bGV2
ZWwgPSAwOw0KPiAgCXUxNiBjbGtfZGl2Ow0KPiBAQCAtMjkxLDEyICsyOTgsMTMgQEAgc3RhdGlj
IGludCBkd19zcGlfdHJhbnNmZXJfb25lKHN0cnVjdCBzcGlfbWFzdGVyICptYXN0ZXIsDQo+ICAJ
aW50IHJldDsNCj4gDQo+ICAJZHdzLT5kbWFfbWFwcGVkID0gMDsNCj4gLQ0KPiArCXNwaW5fbG9j
a19pcnFzYXZlKCZkd3MtPmJ1Zl9sb2NrLCBmbGFncyk7DQo+ICAJZHdzLT50eCA9ICh2b2lkICop
dHJhbnNmZXItPnR4X2J1ZjsNCj4gIAlkd3MtPnR4X2VuZCA9IGR3cy0+dHggKyB0cmFuc2Zlci0+
bGVuOw0KPiAgCWR3cy0+cnggPSB0cmFuc2Zlci0+cnhfYnVmOw0KPiAgCWR3cy0+cnhfZW5kID0g
ZHdzLT5yeCArIHRyYW5zZmVyLT5sZW47DQo+ICAJZHdzLT5sZW4gPSB0cmFuc2Zlci0+bGVuOw0K
PiArCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmR3cy0+YnVmX2xvY2ssIGZsYWdzKTsNCj4gDQo+
ICAJc3BpX2VuYWJsZV9jaGlwKGR3cywgMCk7DQo+IA0KPiBAQCAtNDg4LDYgKzQ5Niw3IEBAIGlu
dCBkd19zcGlfYWRkX2hvc3Qoc3RydWN0IGRldmljZSAqZGV2LCBzdHJ1Y3QgZHdfc3BpICpkd3Mp
DQo+ICAJZHdzLT5kbWFfaW5pdGVkID0gMDsNCj4gIAlkd3MtPmRtYV9hZGRyID0gKGRtYV9hZGRy
X3QpKGR3cy0+cGFkZHIgKyBEV19TUElfRFIpOw0KPiAgCXNucHJpbnRmKGR3cy0+bmFtZSwgc2l6
ZW9mKGR3cy0+bmFtZSksICJkd19zcGklZCIsIGR3cy0+YnVzX251bSk7DQo+ICsJc3Bpbl9sb2Nr
X2luaXQoJmR3cy0+YnVmX2xvY2spOw0KPiANCj4gIAlyZXQgPSByZXF1ZXN0X2lycShkd3MtPmly
cSwgZHdfc3BpX2lycSwgSVJRRl9TSEFSRUQsIGR3cy0+bmFtZSwgbWFzdGVyKTsNCj4gIAlpZiAo
cmV0IDwgMCkgew0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zcGkvc3BpLWR3LmggYi9kcml2ZXJz
L3NwaS9zcGktZHcuaA0KPiBpbmRleCAzNTU4OWEyNzA0NjhkLi5kMDViMjE2ZWEzZjg3IDEwMDY0
NA0KPiAtLS0gYS9kcml2ZXJzL3NwaS9zcGktZHcuaA0KPiArKysgYi9kcml2ZXJzL3NwaS9zcGkt
ZHcuaA0KPiBAQCAtMTE3LDYgKzExNyw3IEBAIHN0cnVjdCBkd19zcGkgew0KPiAgCXNpemVfdAkJ
CWxlbjsNCj4gIAl2b2lkCQkJKnR4Ow0KPiAgCXZvaWQJCQkqdHhfZW5kOw0KPiArCXNwaW5sb2Nr
X3QJCWJ1Zl9sb2NrOw0KPiAgCXZvaWQJCQkqcng7DQo+ICAJdm9pZAkJCSpyeF9lbmQ7DQo+ICAJ
aW50CQkJZG1hX21hcHBlZDsNCj4gLS0NCj4gMi4yNi4wDQoNCg==
