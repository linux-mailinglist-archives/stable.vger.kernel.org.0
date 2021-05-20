Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF77C389F2D
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 09:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbhETH5N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 03:57:13 -0400
Received: from mail-eopbgr50112.outbound.protection.outlook.com ([40.107.5.112]:15173
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229534AbhETH5N (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 03:57:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UGiZkoEl3kJ6VZNiS7epDHvR1shVHX0Fe6+q9ePv4GtuYDkJiG4DWAPD4hdAOIk6nwBFq8XFtS0oZbyBDNx9IAOFpRwWya5Alp5MmNHeIEDxHbPPuVdm0MiI3aSe4AIbfi8sPtEziI8IKR0bCgBd/rxhd5uQ5dqq+KQvizTcz5KOLtBm9UMkpG7ojAxMpD8iCHeJHlx43mvk4vq+f0ea0s95TD+P7fUJqYh8Mp7d4681sU+xJ1amZ93rGuPTZ3Gz4aKJbCxLQQJMnUk+pBONkcv0PUL+5H05n9zJYzbSm4Lv+vjRViOFngd07hWdVmGeAOr+Y8QtXB3HKv/Mw4o22g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DP0yXe2WvbwJxdJ8p5RsUThT7TojzmJ0WwvHy6Zs+PA=;
 b=ixTorlOKS36M06VzN87qZn2IK7g1GIEwrRD6RZE8XcQA5XlIxwsKJ+uuxuAe1xEXu6R8EHe5H/x+V7FdELUWD2YC/4m5eguSTmNe4Q+EjHpzC6Asm86jEwQivMjuXsTNF14Bja7MjNzbfw1Hnyv7WI+alETonSGloAtnnbgdjOyRM6reEMXjrZemmG+/X1jjQOQJ2uGXeFwhBizinQ+uLeZ+cQjYAnnlnJGbIYf9owFdYn73sGjDp85iij/gLYdJ9Af1tztpEgLJcPR8Ik/GVxHG/QRcOwWKbd/NYGSgeE8wg78G2Pvp0iGVpEO1/GZVWnYEq3oOumspHGv/kjdQ6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DP0yXe2WvbwJxdJ8p5RsUThT7TojzmJ0WwvHy6Zs+PA=;
 b=zMMMTJIIQTppGIdx1DTGPpGSClvqJxIe5XSyLnEFRX5PpV9nJJ1PFItHQZlbUZSG73zrqJJIHxS4G5okUYg7aQp5YMH1+9u4W9vc5TdEO4iG3jJoneR9QofEerA4qHUCPzdq8PxVcbN7FDcH8oq4Anukz1XJpp6zgrk5f/HbC5o=
Received: from HE1PR07MB3450.eurprd07.prod.outlook.com (2603:10a6:7:2c::17) by
 HE1PR0701MB2458.eurprd07.prod.outlook.com (2603:10a6:3:71::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4173.11; Thu, 20 May 2021 07:55:49 +0000
Received: from HE1PR07MB3450.eurprd07.prod.outlook.com
 ([fe80::85ed:ce03:c8de:9abf]) by HE1PR07MB3450.eurprd07.prod.outlook.com
 ([fe80::85ed:ce03:c8de:9abf%7]) with mapi id 15.20.4150.017; Thu, 20 May 2021
 07:55:49 +0000
From:   "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "sashal@kernel.org" <sashal@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH 5.4 020/141] ip6_vti: proper dev_{hold|put} in
 ndo_[un]init methods
Thread-Topic: [PATCH 5.4 020/141] ip6_vti: proper dev_{hold|put} in
 ndo_[un]init methods
Thread-Index: AQHXSyvID4QdV5zjzU+tpRlKYqDNHKrr6OkAgAADIoCAABi0AA==
Date:   Thu, 20 May 2021 07:55:49 +0000
Message-ID: <c776ad9a2695c14a65e63796fcfd11e877b9d92c.camel@nokia.com>
References: <20210517140242.729269392@linuxfoundation.org>
         <20210517140243.443931506@linuxfoundation.org>
         <5520be7988fb894c0f4a7c9d7031410c51fcec1c.camel@nokia.com>
         <YKYBS0W1vh1949rK@kroah.com>
In-Reply-To: <YKYBS0W1vh1949rK@kroah.com>
Accept-Language: en-US, en-150, fi-FI
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.4 (3.38.4-1.fc33) 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=nokia.com;
x-originating-ip: [131.228.2.3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7186e93a-a293-4276-8aaa-08d91b64aed7
x-ms-traffictypediagnostic: HE1PR0701MB2458:
x-microsoft-antispam-prvs: <HE1PR0701MB24585FBBF862740374BB7722B42A9@HE1PR0701MB2458.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1148;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mZcn9czv+eKIbjxQuUWhx2xRHXi92wthJNOWtFY1NbyLjBXGXKxBE9qyqteaeBe6vdbemQGqucZ9QykGEg+XlxyQbrz7FAEzm+AzlEzrLl8NkcqiJIwsRUWn5/S+vcBLMtENFZkQD5JeFPj0klwVbJ0cbqZ0e1jzzNC/BSZD5TC6RTaSRSgJYmP76lGqhJzmskVpTYzfpEooHhnfEH1zA2jIOW6vnuzgw+3rfAUE38RjtOWLOG781RSjcMTFXmZsWPQvrcrxjpMV1K+kuOeRqZZDFR2XCDImcUyWraBaphShQqRE2IusTkb15gbw/7mezCup+FPjmYa8uAUD4UDqhnrfZ5+feXfRrG59ekZ+T1mxhpPgkMk4lYAx+1R5L+OpBJVcjCcT0tayfmVvxdhf3NNABkc0ddxuezBOKwcu9gDr57JhRQ0NgW75jd4DRo2FWmSzhuYT5JgUTwsZuNio5L4csOfspBEHZXGulHkdjXcAwFSj7u6xL8nhG/fNQm0Zqp0UvbJtTfZHxVtvEVtz0moCnhPOCa2lPsXs9fSUsOThzqSIIPSEaQUf1ABOpddM1q7v5IJhXLoI2er8RjKLtsaJisHFojq/rpjlNoJpsQY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR07MB3450.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(346002)(376002)(396003)(366004)(6512007)(316002)(6486002)(186003)(478600001)(8936002)(8676002)(6506007)(54906003)(36756003)(26005)(71200400001)(2616005)(66946007)(66446008)(122000001)(38100700002)(66556008)(66476007)(76116006)(64756008)(6916009)(2906002)(4744005)(5660300002)(86362001)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?M0luTWo1Umk0dGR2QStramFPU2t0TDZqWDVaVUYvMWtLWjgzanBreGVSSzQv?=
 =?utf-8?B?cENuZm5XMC9wYnAvRHJucGFUVUMyVkZQdGtSOTZXOXd4YjZNWFpMcEt2WHNs?=
 =?utf-8?B?ZDJFZWxTNlFpUlhrbmg3Q0I0em9DYkxoSTlxNG43Y3lJK1VMeVhySnhYc1F1?=
 =?utf-8?B?SmZ4TEtnT1NRNXBXUm02dGRTbzRqV212ZVdxS081TmNxaUtMMXpEU21tcmli?=
 =?utf-8?B?R0prQWhlUW5teUVQN0NJdWhLcG12bUtnYnQwNjlJckJVZEtiYWg0ZU5Hcnc2?=
 =?utf-8?B?L0FiYXZhYkczK0xwUGFSSGVsUEpISWlMYVRnSmZSRUxPYnBNUGFnUXpGTWw3?=
 =?utf-8?B?anlRT1h3cFJjSWZxUWQxT1oxL1EwR0FUcUxKL1NlL2V4UUVqTG05TWRYU3p5?=
 =?utf-8?B?ZUtjcWJTeGtuQXVaS3pJVmhIRUo4a2Eybngzb3BPdyt6Y0pUcHFicytLRVNJ?=
 =?utf-8?B?bW85NmQ2RTdQREdEY3pVZFZvQmJiNC9oNUNoNlFsTWU1ckl5MzF3M3FDMnVl?=
 =?utf-8?B?VGZ0NW9zYW5WU3FVVHcvTjJZek81ay9vejBkQ29Kc1BNYVNFYXIySjhVOCtL?=
 =?utf-8?B?TFFZSy9YUEYxL2pZWGN5cUVGVTYyQzlQTkdjRkZCL2d5eGxYRS9EM1NKMXd4?=
 =?utf-8?B?V21HcThIRnR2MU9lUmpzTEhBN0N5QU5QTmY4YUdGWnVMNnRLUldLTXF0akxo?=
 =?utf-8?B?a2hrTzI0NldUTldFQkFQRzZxQlhLTEhkYUZ3VTduNHJldGhQckEvUkh5S3Iy?=
 =?utf-8?B?R1ZFTmVuL0hIQVhwS1RTTWV5enZaaWJFeUtCYkdOekNIcHJ6OCtPaUNwU0U2?=
 =?utf-8?B?VEdsdjdhUFI3Y1NWMkpiSUNTTFpaQ09IWWx1eXBvTWVOQ0t1TmlKZ2hZN25n?=
 =?utf-8?B?VDQ3U1dvSG9YN0RXdjdMejYreURLbHVEZk9VSzExOTBaSTdXbnlXdzJpdm54?=
 =?utf-8?B?YlpYYUE4K1Y2SklsUkRRdFVZL2NBak01a05uSHltTWpmdC9BUVF5RSs5K252?=
 =?utf-8?B?VzhMNFVjQVRRaFB5RW1oWThMSkZNUzB2a0tnZU1TZUU1MFFNREpubHRrM0Yy?=
 =?utf-8?B?ZjNUMitQOGl2ZXZaMjdDWW9QSkEzOWNrN3dFenlRNzA2TnJqMElOdVQ2SlZX?=
 =?utf-8?B?TEJNRUw2c0VqemZ3KzZYOFR0Q0N6SDVlcjFobFRWend4WDBXVmNlMmpJcjdQ?=
 =?utf-8?B?ZmFzQkFock96Ty95TWdQdnQwejd6ZThtSDNUSEhleXZsOURPb2phN1VVdFB6?=
 =?utf-8?B?Nkl0Q2VmOEg1c2twSU9IMHh3NHRNNE9EK1l6ZmZlTmFUb1NMek84MVd4ZElL?=
 =?utf-8?B?dzJqT3VCTnpEMUU5WVlzUmNXOStzYjFwV29XNkNhL2UwLzlla096Rm05SXlB?=
 =?utf-8?B?VFpGVTkrVkhQV3gxYklJRTZzellqdHM2c1pTR1J3ZGE4WkZ4MTdwQ2d3VE1E?=
 =?utf-8?B?SVZHbzdoam4yUGFjcmdMdkxaMHBObi9NdVRYSUFtL211YjVZZmZLVjExVW9P?=
 =?utf-8?B?SEJjcGNwMGU4QkpRcWJuRnpTeHlobERzZkdGMDhvamdrcUQxMlljejJCYTBk?=
 =?utf-8?B?eG9uR1pTTnlSRXIySVQvQjFhK2lhd01tcHBCbG1kak5qODNLMFNGR3hnQWxj?=
 =?utf-8?B?aWNIV2VZbmx6YnZyMVNlZEtTSkZhTHM2OG5aSzhHMXZNTlIvcmtySk1oYUty?=
 =?utf-8?B?bTBUM053aHNkeEZUVFhlQlYrMW9sdW4wWHlmOFNvZ2dLbFBPMEJVUTRYczBk?=
 =?utf-8?Q?CH2behfKo9XwKNvt/H1d202Rem3VlLlWPbqrMj4?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <EA8A38AF6D966F43B2750F545B59E98A@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR07MB3450.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7186e93a-a293-4276-8aaa-08d91b64aed7
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2021 07:55:49.2657
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bXDKB865KTGslaiJCny7oXkpIU7yzT7aoWlssDFpVEsQLzUc9Mho4+jYRtaZ2jIBk83VEB3PtGMOUzHtp7EfFR8VWzSzVlZDycycez1SmPU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0701MB2458
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PiBJIGRvIG5vdCB1bmRlcnN0YW5kLCB3aGF0IG5lZWRzIHRvIGJlIGRvbmUgaGVyZT8NCg0KU29y
cnksIGVtYWlsIGZvcm1hdHRpbmcgZ290IHNvbWVob3cgbWVzc2VkIHVwLg0KDQpQbGVhc2UgY2hl
cnJ5LXBpY2sgdGhpcyB0byA1LjQueToNCg0KICBjb21taXQgMGQ3YTdiMjAxNGIxYTQ5OWEwZmUy
NGM5ZjMwNjNkNzg1NmI1YWFhZg0KICBBdXRob3I6IEVyaWMgRHVtYXpldCA8ZWR1bWF6ZXRAZ29v
Z2xlLmNvbT4NCiAgRGF0ZTogICBXZWQgTWFyIDMxIDE0OjM4OjExIDIwMjEgLTA3MDANCg0KICAg
IGlwdjY6IHJlbW92ZSBleHRyYSBkZXZfaG9sZCgpIGZvciBmYWxsYmFjayB0dW5uZWxzDQogICAg
DQoNCkFuZCB0aGVzZToNCg0KICAgIEZpeGVzOiA0OGJiNTY5NzI2OWEgKCJpcDZfdHVubmVsOiBz
aXQ6IHByb3BlciBkZXZfe2hvbGR8cHV0fSBpbg0KbmRvX1t1bl1pbml0IG1ldGhvZHMiKQ0KICAg
IEZpeGVzOiA2Mjg5YTk4ZjA4MTcgKCJzaXQ6IHByb3BlciBkZXZfe2hvbGR8cHV0fSBpbiBuZG9f
W3VuXWluaXQNCm1ldGhvZHMiKQ0KICAgIEZpeGVzOiA3ZjcwMDMzNGJlOWEgKCJpcDZfZ3JlOiBw
cm9wZXIgZGV2X3tob2xkfHB1dH0gaW4gbmRvX1t1bl1pbml0DQptZXRob2RzIikNCg0KDQotVG9t
bWkNCg0KDQo=
