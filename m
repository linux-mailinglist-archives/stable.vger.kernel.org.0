Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3CE19E2B6
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728859AbfH0Idb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:33:31 -0400
Received: from mail-eopbgr800057.outbound.protection.outlook.com ([40.107.80.57]:18896
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726071AbfH0Ida (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:33:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JR9IdzLMOHknWWaEiZiRctLxwfschVNB/8qjg8AEu/puwIxJuuI7Rcmc7FPR0r/QsTE8tBjvR+VkTjQWUBMIZm7qXyZnqdBx/sKkgYln6C9myqmW4p3MB/D8yu9FJF2rKTqH8bbC09iZKS8NAQL1gT5mkAIEjOhqS1gK/LsdLFkduHL5sflIPrYejrtkngkENylWChU/pInCF1afLYCfIiR9xWluPxqD6+l3iy+GMU3fgLn8DXh7Si5dyADpdGwXy8rjwJTdlYzLNZ9HCkzVRA5Z1Bo2nfq79phzlA9DqiJnp5sQ8qxbJp/yi81VFhi1Y9WS4cv6kyOywKnfM/AiHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=itdaYzv3l9cbwgDc3kcPz+5xkL8u6FCXukC7lJuOJFo=;
 b=hHeAPderXxxI3ZYKHaQoSUbCU7/3riuBxTnnXFH8dhznsRAQzkKKFSGrvral79Gw6TWTui1uriEIUZLFZjCfNglSsmxsCeMZfRz+JrF7miL4+8fdqyARjSYk0r5orMaTxJ+eGpQ1trXH5ecV9iJfT9vctic/8BuV4m6U4PcouPbsB8RQ43OGKRIHDxkBu3DUOlKnHAWQZjzihH/lMnAOP3Eyk1GpFJEoQOK1+xOS92NQzJ+XCYkiRKeD04GnqdxwvB7YhE84OPPwH4su4JHua5y7GjtPtrBbUWSeYxosJS617MzMDSFuD253O42/csGh5nmwioyZmr1jgZjsEkj6Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=infinera.com; dmarc=pass action=none header.from=infinera.com;
 dkim=pass header.d=infinera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=itdaYzv3l9cbwgDc3kcPz+5xkL8u6FCXukC7lJuOJFo=;
 b=PxqWAg1o5ZmR0dn7Tb8oBhued/c3Pym9EI79T9gCzLp1XfxqLaMPBBvHqtI5rbypzazGxIzLEPJ/jMPpfLhIAybGy5iQbskHduW9OegUgpB5Yxk7VtKjWvwrBuDgDg6Sj0Q2X2IjHNUlakoJrareUjBhPZJIhjc+fKH5kchFoy4=
Received: from DM6PR10MB3548.namprd10.prod.outlook.com (20.179.55.82) by
 DM6PR10MB3051.namprd10.prod.outlook.com (20.177.219.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.20; Tue, 27 Aug 2019 08:33:28 +0000
Received: from DM6PR10MB3548.namprd10.prod.outlook.com
 ([fe80::fc74:7d8b:ad3e:7b8b]) by DM6PR10MB3548.namprd10.prod.outlook.com
 ([fe80::fc74:7d8b:ad3e:7b8b%3]) with mapi id 15.20.2199.021; Tue, 27 Aug 2019
 08:33:28 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH net] ipv6: Default fib6_type to RTN_UNICAST when not set
Thread-Topic: [PATCH net] ipv6: Default fib6_type to RTN_UNICAST when not set
Thread-Index: AQHVXLIZy/K5JiGguEabjs4Jnc4A4g==
Date:   Tue, 27 Aug 2019 08:33:28 +0000
Message-ID: <8dad6e3cf2e6cb0086b0a6f75ccdb44822a15001.camel@infinera.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Joakim.Tjernlund@infinera.com; 
x-originating-ip: [88.131.87.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 185d0a00-637b-48f3-72c3-08d72ac93c69
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DM6PR10MB3051;
x-ms-traffictypediagnostic: DM6PR10MB3051:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <DM6PR10MB3051D12E0B2EF733157A0A39F4A00@DM6PR10MB3051.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 0142F22657
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(376002)(396003)(39860400002)(346002)(189003)(199004)(99286004)(8936002)(76116006)(66946007)(6436002)(2351001)(5640700003)(66066001)(6512007)(53936002)(25786009)(91956017)(966005)(14454004)(478600001)(6506007)(6916009)(316002)(64756008)(118296001)(66556008)(66446008)(66476007)(186003)(6306002)(558084003)(36756003)(81156014)(7736002)(256004)(305945005)(6486002)(86362001)(5660300002)(486006)(71200400001)(2906002)(71190400001)(1730700003)(2501003)(476003)(81166006)(8676002)(102836004)(2616005)(6116002)(26005)(3846002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR10MB3051;H:DM6PR10MB3548.namprd10.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: infinera.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: xkHGZPSybeVdQKmbDrcmPj2Ef0afZX/C8mo6svIoXdhWOaJ3ADIYkt8I4S/WvUjHxHWw5ojgwmed6uLPJW2KvgT/hCArrsbvV1kt5vt67f0P/RNLjFaDRfiMydoCKAH+V0wXFsKeHCx5UTlpLK1ipWHzje0YBo8KdAYLyZUm2Ra/TPVKupoaaFNUZJkRwZKYhzfTQe5JIjderE8Y3MxEKiHaaHcvzhu3X5gZS1lLlrsfQsg1CnkJ/VoS9j4XPq0thJPz5YlXaHVsXoEiExEWwk5JgozddwxeWaXFsyTRPX/Z41z22etLgDr2aOzRqZD+99P3fwAbliyyZPElQrUKOvomFo27T4hup0d9UmmoK4yh14h2ZhEYcYqp9ntKBl6n8XceLBglM/xBx+TXicsGbUpMsjYFXMuOj31TOBX7PJQ=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <1E99DA37189C79488870E52E09F72CD8@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 185d0a00-637b-48f3-72c3-08d72ac93c69
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2019 08:33:28.3822
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BSypJodXbwA5PfoF8Jn1/9ioJ0DC69IUCx6dggEyPOYHoENuy4R/DZ/uZ/5T+p2w4yeCh4Mpfj4V/VXkYWoDGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3051
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SSBkb24ndCBzZWUgdGhlIGFib3ZlIHBhdGNoIGluIHN0YWJsZSB5ZXQsIGlzIGl0IHN0aWxsIHF1
ZXVlZD8NCmh0dHBzOi8vd3d3LnNwaW5pY3MubmV0L2xpc3RzL25ldGRldi9tc2c1Nzk1ODEuaHRt
bA0K
