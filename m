Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC272EEDFC
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 08:48:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbhAHHsH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jan 2021 02:48:07 -0500
Received: from mail-eopbgr20108.outbound.protection.outlook.com ([40.107.2.108]:34117
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725965AbhAHHsG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Jan 2021 02:48:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=caO2zuac1RHvla9wxx79zryxcQWrEuG/Nbr22OsG3upbs3kuuPwkhnfoDqKTMYYXHUhYpvZ//xTddj6LdWoqsEClZ0+UihFacGCBSa7j7wvhDxkxKBhzaiy+NwNjnregzEZJdqknk4ofmQi1hjkr/oKSURaMpZfNI64KeXCoMRG25mageix4sDOaAuBo9XNp6/6jNEGVLYiLXk2ugXzP6kZQRnsIIhGsKJ63jmbJgWI5y3CM6nDJDSdIJx4qtoXEp+rbWCdhQ6ryHbGHMHdi7DhEUrrKPtEeua4VJivFK807Bfu5JGIC/8IHAw4eD7ni7/R376WZiXMFraurjjwcsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9OSew8siE/ghz4yVRQxXA+Um3Gt6Y2OGb7X3DHW+wGg=;
 b=N4w7YIXIaA3OT+fT7qHkftWBGS4mh+MkXA7AfuJ8gKdza0jl/I+lqKWa+/tswaGdI1sUXHzSuEkBBmahvLjXoCl2rmlHAgzfKja7xfgnvqxtcb+t7Qn0Fsw/ij9s2z3+L4OAT0rDXkynAuKo3hSV2hZvlTSpIlH4GSrVdR0ajN/DlCEstsncWsD5uWVcBl+a7ZayMIlyxoAZn9NjizkYcI0lSC8Qh0LR+HG6Aq7eyAS+dkjMxA8kATh+YpvYY4+OZJh3+1AL6tYepvsrBW9nlwS+WVl74vv+eI3z9hzASaP9K0NHqr3tqVIXDfU7Z14AOa8cBvynIw8wolparsBQJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9OSew8siE/ghz4yVRQxXA+Um3Gt6Y2OGb7X3DHW+wGg=;
 b=eITsdoc4QwkM4ektTiUioFmD1F9sNA3IDTsGFXBVMMB1CmEJneE/1WwGunJ2QbkR4JNO7dy26OV1n2xWSbgGAkyoNJY1qGW3E/MqPRDcAyoBXghkFF4vjgeg0aFcumV76ifli6qeJ0Dc43WDNAZWhiYr3OEm+NTndLLepGeEOeQ=
Received: from HE1PR07MB3450.eurprd07.prod.outlook.com (2603:10a6:7:2c::17) by
 HE1PR0701MB2347.eurprd07.prod.outlook.com (2603:10a6:3:6f::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3763.2; Fri, 8 Jan 2021 07:47:17 +0000
Received: from HE1PR07MB3450.eurprd07.prod.outlook.com
 ([fe80::e1f6:25bb:eee:8194]) by HE1PR07MB3450.eurprd07.prod.outlook.com
 ([fe80::e1f6:25bb:eee:8194%5]) with mapi id 15.20.3742.006; Fri, 8 Jan 2021
 07:47:17 +0000
From:   "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "adobriyan@gmail.com" <adobriyan@gmail.com>
Subject: LTS: proc: fix lookup in /proc/net subdirectories after setns(2)
Thread-Topic: LTS: proc: fix lookup in /proc/net subdirectories after setns(2)
Thread-Index: AQHW5ZJ8QIqwgnQ31kmc8+AuyljCEg==
Date:   Fri, 8 Jan 2021 07:47:17 +0000
Message-ID: <935692185a18ab86667e66a85aaed382aa34c3bd.camel@nokia.com>
Accept-Language: en-150, fi-FI, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5 (3.36.5-2.fc32) 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=nokia.com;
x-originating-ip: [131.228.2.25]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 02794038-4b6b-41d6-ddb3-08d8b3a99f1b
x-ms-traffictypediagnostic: HE1PR0701MB2347:
x-microsoft-antispam-prvs: <HE1PR0701MB234751F66F6861F5F721E144B4AE0@HE1PR0701MB2347.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:169;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6iplKah1oxN6zsg32hraGnygJbrNadM9TxV6cIbs+G8XeE7SMrIpKY+cU+ICDWhYSQE9e1AGN9FJU8DWoJ/jm7/wfSVmv/nWDXcW2yVjAFKRChl3ZNrLToRLJWidHAGReZBYnXGpvASxh92bao+n9duxsiLQy9+xGzjO5r8soM0Je4q215KNDQ6eENp4qaGR2qnTB6/CEh15gK/8McAZR6np3Atj2G/4lqYnq3CNJEHxUX6XqSC/gW9UgjD7J7PJ8i0cJijaa31kGDeUzfafC1CE+iP61F/aB9yuW7wmPEiQWCSD89YuWzryZh4k/31Rq1/tXdK1HRvB5xhYaeI/+toMG9P/yu45f2lphIDhK22uuCEkQFxqweuOSskO//cj7RJFBZ4/NRpCnpc6l9NY6w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR07MB3450.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(346002)(39860400002)(396003)(136003)(4744005)(86362001)(26005)(186003)(8936002)(6506007)(66556008)(36756003)(6916009)(6512007)(83380400001)(478600001)(6486002)(64756008)(2616005)(66476007)(76116006)(4326008)(91956017)(66446008)(2906002)(54906003)(71200400001)(8676002)(316002)(5660300002)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?eXZ2Z2pqQlJvRHpxL2w5aFhESk8zNldqeTJrREc0YVJiMUhHeDhEeUdtSStQ?=
 =?utf-8?B?TGI2dnppNE0yaCtBZUJudDI2UzB0VGIwLy84SzFMOVYxUTRLYjhxbjRwSlhW?=
 =?utf-8?B?bDkxZHp1Wk9rbUhBZmV1OTNjSWFsZW0ydVM4SWFBV1JHZVkxNk54Z0hSOVBB?=
 =?utf-8?B?ajNEVU81cklYQy9KUmozM3MxdHhlVC9IRlR6aDFoSC9PK1oyb3VjQWt6aXpM?=
 =?utf-8?B?bXBKTjUxcUp6VnNOYVpvRUF3WU9XUVN2VDhKckEwQkpFYy84R0wydjhJR3g5?=
 =?utf-8?B?VDNxNCtjaDF3MkMyNE9rY3lGdko4dmJ4a3FLUis5UllGUHgwSXppbTlCWnlz?=
 =?utf-8?B?RHpXd2JjZVBlVUdlNXFiL1NQSFBzcnRYbjl3ZVpobUJMMnNKZUF1aGV1Nkw0?=
 =?utf-8?B?Y3N6YUdteWVrSzcvdTFUaDE1S0pXQ01iTXNUUTN2ZGtjZlJ6TVhRN0piaUV6?=
 =?utf-8?B?L2kyL1dCbVlxZGVjNHZUdXdodjVnMHh0ci85OTJvUlV5QnUvWFlIOE0vbXlT?=
 =?utf-8?B?cDBtT25ia3M1WE12aGYrajVpcEd1Ui9tWE5tVVRyMjkwaEE5MmpET3RPRmYy?=
 =?utf-8?B?WnlNQ3dkUWp2THRtODRuVnBmdkZhNGh6a3VnWFJycWwzNDRqanNMZlloaWFT?=
 =?utf-8?B?MGwzbmFZa2VET3VsK1B2WU9mSTdNWjZyUzBwVjdEWW5QdGJHaVh6L0Rta2ti?=
 =?utf-8?B?bmovYldMemNBaG9XRDR5T2paVy8vcVQ4eEJHcW9NSCs3Z09xcXhhT2w1MkVR?=
 =?utf-8?B?aVVHVVh2MmUxRjU3SXk3MUowU3lMSEdrNGZ6VDlJRkN0VTRQM05QbzVVaU90?=
 =?utf-8?B?dmVOckprdVZybDVoVEc2cGRGT3hCdkdvVEd3Yzg4NjFIUEVpeWVIT3RrckFF?=
 =?utf-8?B?Zm9BVkRvZXNrVERzSmxSRExXSjhXY2JrY0lnUm5WK2JXbmorY1ZINFNzZmVo?=
 =?utf-8?B?cHNoSDk2ZWVieFVjUTZSbFZ0SjRQN0VrWFdGTzl4eEQ3MHkwMkFIVVdrbG1I?=
 =?utf-8?B?TlFqNkhSMllvZkNHUnVaeThxVlk5QVRudGx3YTZxQ2R1RTBITTQyL2ozMmxi?=
 =?utf-8?B?eTRSV0JuajJ3dWNkZU1sU2tleks2QU9pcVBEVHYvd0lPQ3JRN1BzRTJNTFRH?=
 =?utf-8?B?V3Y5Mm4vTGI3Qk5MeUdCQTQrbEZOMU02R0JvdG9VdlJVcnJQcFVKaytXR1E0?=
 =?utf-8?B?TXJHdVNhVFdjemg5TG9PalNiRnFvOUtBUGk5eDVpV0Q5ZU1zbmtMeFNCMzhi?=
 =?utf-8?B?bFRGY2ZuNEpPR1JWNDdKZ0c5SU92SFBSa2NPT2tSUUpzZS9pdUh6ckJBczVQ?=
 =?utf-8?Q?Z+VkliFHRn2qccb0FT29kJDPodE370PEKw?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <8B68F2F2A86C264DB3284C0F8C239023@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR07MB3450.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02794038-4b6b-41d6-ddb3-08d8b3a99f1b
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2021 07:47:17.1534
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eQWryYiieC0QeRI+55/ad+1hsK3txZ/rmgILNHSWP2FSGkAeNquMv5XmfUAaNeQjWswRZJ2zQ1mAsO4Nenb3NrQSBpo7i0Y62+Rq2lIGPyU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0701MB2347
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgR3JlZywNCg0KQ2FuIHlvdSBjaGVycnktcGljayB0aGVzZSB0byA0LjE5LnkgJiA1LjQueToN
Cg0KY29tbWl0IGUwNjY4OWJmNTcwMTdhYzAyMmNjZjBmMmE1MDcxZjc2MDgyMWNlMGYNCkF1dGhv
cjogQWxleGV5IERvYnJpeWFuIDxhZG9icml5YW5AZ21haWwuY29tPg0KRGF0ZTogICBXZWQgRGVj
IDQgMTY6NDk6NTkgMjAxOSAtMDgwMA0KDQogICAgcHJvYzogY2hhbmdlIC0+bmxpbmsgdW5kZXIg
cHJvY19zdWJkaXJfbG9jaw0KDQpjb21taXQgYzZjNzVkZWRhODEzNDRjM2E5NWQxZDFmNjA2ZDVj
ZWUxMDllNWQ1NA0KQXV0aG9yOiBBbGV4ZXkgRG9icml5YW4gPGFkb2JyaXlhbkBnbWFpbC5jb20+
DQpEYXRlOiAgIFR1ZSBEZWMgMTUgMjA6NDI6MzkgMjAyMCAtMDgwMA0KDQogICAgcHJvYzogZml4
IGxvb2t1cCBpbiAvcHJvYy9uZXQgc3ViZGlyZWN0b3JpZXMgYWZ0ZXIgc2V0bnMoMikNCg0KDQot
VG9tbWkNCg0K
