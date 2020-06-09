Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D638B1F34BD
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 09:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbgFIHTV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 03:19:21 -0400
Received: from mail-eopbgr80090.outbound.protection.outlook.com ([40.107.8.90]:30530
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725772AbgFIHTU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 03:19:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KWQYsFMLcyeionsAiqrp/ST6Fhx4RRdHts3Tm9hS8ivPfdvhcva1K3QUx1I0U7fPz62/dWV9sx4IO2FH1LCYEASKav5AtB+G5vcXefJ6EIZa0/VjhiSLxb5NTlqV1unnizOYjqwNqyIZ488t53PLVds+AQf7ulzI2irp6bT5HbmMfXofiTpVGeuB11Hm/60wTS5L4tga3lKJrjfMfR1fCAIEUUM1HEDYHgHwCcgX/UYDlvFBZzsXaSdb4hzdWOq2N1JW90RATiRFUyisBYEIBtuAVrUOgMwpT0gdROtJOwR66iTWCYaiiARg3GoEmZqrZFThY7Z+88P6zp8iF04iMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KcsVgAYMMmFbjFB6GoRpFaurjS5r8yI6PiXQYTQz39s=;
 b=j8jgF6P6QHyMerZfO22EfiojuJZmNZ3A4tS+d6dQzNEwWx70mIah+6TsIrpJcylGLZLyxiI9KuWl/LTMVhGRpMbkyTq1aJjwu5lAaOppw8XtUJM0gmgymPnUR95ZuKLgWvQEiDtQS7vzQy1iQGpTi9Rnuh9asEjLfdZl3hDKc23EXda6WgdrcQY1/Dq+XNMibrzknLdkc9qg4CAiUJpNAli/V2OLRs8XtuG4yrndz1X8zVMQm6zRIbUb4UCYdSf9Qmhw54IXAr/s5hTwzrfDAc24nymCtykDGi2AvZM293IQxBwaxepJpuEGh0UcllqvWdzXUaw6EQLmuxz8NlcLPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kontron.de; dmarc=pass action=none header.from=kontron.de;
 dkim=pass header.d=kontron.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mysnt.onmicrosoft.com;
 s=selector2-mysnt-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KcsVgAYMMmFbjFB6GoRpFaurjS5r8yI6PiXQYTQz39s=;
 b=CWbc4wS6F1FDS7ZLHWnLACgpCiK65NIjDnSg5c7Tai9Ze/gIblkniHIYZKXFuBW9lY3WS2xNnVNjdXHVmG5fXrHCq0r73TfaN6dtZEIyZfCrQGGxTo8QaLXupukj7fELaq5vFzrXjsEf/z8zZHXAa24G9PysF6ZoYKntDviVqMY=
Received: from DB7PR10MB2490.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:50::12)
 by DB7PR10MB2155.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:42::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18; Tue, 9 Jun
 2020 07:19:15 +0000
Received: from DB7PR10MB2490.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::acc5:2acd:49a6:5048]) by DB7PR10MB2490.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::acc5:2acd:49a6:5048%7]) with mapi id 15.20.3066.023; Tue, 9 Jun 2020
 07:19:15 +0000
From:   Schrempf Frieder <frieder.schrempf@kontron.de>
To:     Fabio Estevam <festevam@gmail.com>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?utf-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
        <u.kleine-koenig@pengutronix.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
Subject: Re: [PATCH] serial: imx: Fix handling of TC irq in combination with
 DMA
Thread-Topic: [PATCH] serial: imx: Fix handling of TC irq in combination with
 DMA
Thread-Index: AQHWPacakgJZrwZ8pkOomdvwi0/9IajO3f8AgAABzQCAAQF0AA==
Date:   Tue, 9 Jun 2020 07:19:15 +0000
Message-ID: <a5bd8497-16a4-8ef8-a41f-a7ff6cbc73d5@kontron.de>
References: <20200608151012.7296-1-frieder.schrempf@kontron.de>
 <CAOMZO5BHF6ftHVgzKQ29o_G7Y+O6nrbDH1+J5+BYaONz==WebQ@mail.gmail.com>
 <CAOMZO5D0oifxM3H4WoLmJQ72Zo_2uj8X0RcpVadj4wLJYh6BgQ@mail.gmail.com>
In-Reply-To: <CAOMZO5D0oifxM3H4WoLmJQ72Zo_2uj8X0RcpVadj4wLJYh6BgQ@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=kontron.de;
x-originating-ip: [77.246.119.226]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f5341654-a496-44ea-d951-08d80c456a74
x-ms-traffictypediagnostic: DB7PR10MB2155:
x-microsoft-antispam-prvs: <DB7PR10MB215539D14DEDD1E86F1E0D68E9820@DB7PR10MB2155.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 042957ACD7
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: k5joUdcmbzvae1pMrvwPxWDxBtHxEQYNwplpCHQY0d6WujBCb/OQU+2Vd5eEwnxH+gqUP8GG659EgcKdoRRMQ7n95QZZGAYv91SY4R33pt2NMMK6swsvojYTp5uErCb90+n0ybFFWSYrhMCVm19RD+b0AquaT8JWCsNoVNxph10QQdEYXvTtbQfiAKpPkOhga7KtF0Opf25sUa7KFQo+bpuQziqb4t6ljCngLfqlC0JNVP/LyZj3JZ+ebMZu97vMB0DLRbESVzlfKPAG5QE3fY6HhS602sJGdqvcKZB0rvvLFgkXx+4or49KkeXXJmEv927SUeR6FaU7jiE3XkC52Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR10MB2490.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39850400004)(396003)(376002)(366004)(136003)(346002)(478600001)(26005)(6506007)(31686004)(6486002)(6512007)(36756003)(316002)(91956017)(54906003)(2616005)(4744005)(86362001)(8936002)(66556008)(76116006)(6916009)(71200400001)(8676002)(66446008)(64756008)(53546011)(31696002)(186003)(66946007)(2906002)(66476007)(4326008)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: m83yyVcqSHNfSaJlW7h84i5cB55zxrPvHvP3tyRjFZvRiOgqZUChsUazFb9dXK/5YdI60yiQOkhD8aZ4mEz3MGK31CY+FrJGdj1ToVrtrs5iMTDHXe7QFlJ0jAaQWkhUH6+HRJ2j4/6pe+Oft+5K6SCcG5lkDoJ9Wgig9lhtWED2loufzbyNGE97KvyAu9big0Ax/tjRr3qxfH9Dy4UwVv+a2lTHVwOnVRKNSfJKB0seM7u7bSm0JuimKNdMEGzdzJjA7Xzg/QlzrVwG4s3FxrlDYUll5C2LlUNPxecvMNsS6k1IeJcW7smXyLUpj8PfMVDTUjOd2X4QywDbBz+FgeOYPXmxlyPKk2Ci7xS5vqqCbT2sCvDpKRUsFCG+re/zs9HVKMPulf/IUaq+xglCyY/mbqUjghPc3n3n4+ak3a3MAkBUhmxLbpf3eg52iPtPGZparXSgnY7a9ffi6RpDWUhwehs+3bn4LeoOBAK2HSZPXXzHaCZhJfeoKUn9Owoa
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <F32FB4F2C30F4F40A828468EB6F11AB2@EURPRD10.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: kontron.de
X-MS-Exchange-CrossTenant-Network-Message-Id: f5341654-a496-44ea-d951-08d80c456a74
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jun 2020 07:19:15.0684
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8c9d3c97-3fd9-41c8-a2b1-646f3942daf1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1iWPMi/iYUyE9cDEC1PYND81ErY5ln35IGprrXnvYjGCQuwjmIRXefO2w8t2+7cpy0HpicInfs0XpWla5c66XiDC1wLcehiOw/ZYosKDVdk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR10MB2155
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMDguMDYuMjAgMTc6NTcsIEZhYmlvIEVzdGV2YW0gd3JvdGU6DQo+IE9uIE1vbiwgSnVuIDgs
IDIwMjAgYXQgMTI6NTEgUE0gRmFiaW8gRXN0ZXZhbSA8ZmVzdGV2YW1AZ21haWwuY29tPiB3cm90
ZToNCj4+DQo+PiBPbiBNb24sIEp1biA4LCAyMDIwIGF0IDEyOjEyIFBNIFNjaHJlbXBmIEZyaWVk
ZXINCj4+IDxmcmllZGVyLnNjaHJlbXBmQGtvbnRyb24uZGU+IHdyb3RlOg0KPj4NCj4+PiAgICAg
ICAgICBpZiAocG9ydC0+cnM0ODUuZmxhZ3MgJiBTRVJfUlM0ODVfRU5BQkxFRCkgew0KPj4+ICAg
ICAgICAgICAgICAgICAgdGVtcCA9IHJlYWRsKHBvcnQtPm1lbWJhc2UgKyBVQ1IyKTsNCj4+PiAr
DQo+Pg0KPj4gVGhpcyBsb29rcyBsaWtlIGFuIHVucmVsYXRlZCBjaGFuZ2UuDQo+IA0KPiBBaCwg
b2ssIGp1c3QgcmVhbGl6ZWQgdGhpcyBpcyBhIGJhY2twb3J0LiBJbiB0aGlzIGNhc2UsIGl0IGlz
IGZpbmUgdGhlbi4NCg0KWWVzLCBidXQgdGhpcyBhZGRpdGlvbmFsIGJsYW5rIGxpbmUgaXMgbm90
IGV2ZW4gdXBzdHJlYW0uIEkgdGhpbmsgSSBoYXZlIA0KYWRkZWQgaXQgYWNjaWRlbnRhbGx5IHdo
ZW4gZG9pbmcgdGhlIGJhY2twb3J0LiBTbyBpdCdzIHByb2JhYmx5IHJpZ2h0IHRvIA0KZHJvcCBp
dC4gSSdsbCBzZW5kIGEgdjIuIFRoYW5rcyE=
