Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 359AC21640
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 11:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728930AbfEQJ1F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 05:27:05 -0400
Received: from mail-eopbgr80045.outbound.protection.outlook.com ([40.107.8.45]:27975
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728922AbfEQJ1F (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 May 2019 05:27:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dH2LZqYg28n7uTddDesQ4vwUo5oGGn5zF4U/1PRlVIY=;
 b=G654H8zYD3VS+t4fYsnqBP1Z5CQLP/fWOcRK3rOB0Spp5L8PxjulTzOydv3Pkqx8evCs+iJXiYBl3Afb4vGwPvIV2Ny6Teb8TEk4xdZlT/JHcwOGchuHIb99Ah7s7ybH+Ve0uqsSCzQZzFCsFoDwyoPKA3nH0q+u40HlWH4GOhE=
Received: from VI1PR04MB4880.eurprd04.prod.outlook.com (20.177.49.153) by
 VI1PR04MB2973.eurprd04.prod.outlook.com (10.170.228.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.16; Fri, 17 May 2019 09:27:02 +0000
Received: from VI1PR04MB4880.eurprd04.prod.outlook.com
 ([fe80::d9de:1be3:e7e6:757f]) by VI1PR04MB4880.eurprd04.prod.outlook.com
 ([fe80::d9de:1be3:e7e6:757f%3]) with mapi id 15.20.1900.010; Fri, 17 May 2019
 09:27:02 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>
Subject: RE: [PATCH 4.19 042/113] ocelot: Dont sleep in atomic context
 (irqs_disabled())
Thread-Topic: [PATCH 4.19 042/113] ocelot: Dont sleep in atomic context
 (irqs_disabled())
Thread-Index: AQHVCxCoh95StDwt4EaQOEY0AHPDXKZu+5YAgAAJm2A=
Date:   Fri, 17 May 2019 09:27:01 +0000
Message-ID: <VI1PR04MB488053E08D56380DBB6EFB05960B0@VI1PR04MB4880.eurprd04.prod.outlook.com>
References: <20190515090652.640988966@linuxfoundation.org>
 <20190515090656.813206864@linuxfoundation.org> <20190517081642.GC17012@amd>
In-Reply-To: <20190517081642.GC17012@amd>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=claudiu.manoil@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a7ec9e43-a86b-45fe-7b42-08d6daa9d1af
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR04MB2973;
x-ms-traffictypediagnostic: VI1PR04MB2973:
x-microsoft-antispam-prvs: <VI1PR04MB297318122DEB9183C5A75E11960B0@VI1PR04MB2973.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0040126723
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(376002)(346002)(396003)(39860400002)(366004)(136003)(189003)(199004)(13464003)(6246003)(99286004)(33656002)(86362001)(229853002)(26005)(14444005)(256004)(68736007)(102836004)(14454004)(6506007)(316002)(7736002)(8676002)(2906002)(81156014)(7696005)(52536014)(74316002)(81166006)(76176011)(44832011)(186003)(66446008)(66556008)(64756008)(71200400001)(66066001)(76116006)(3846002)(54906003)(6116002)(11346002)(25786009)(110136005)(486006)(9686003)(446003)(476003)(5660300002)(478600001)(71190400001)(4326008)(305945005)(53936002)(6436002)(8936002)(55016002)(73956011)(66476007)(66946007)(192303002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB2973;H:VI1PR04MB4880.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: +kaY+VE3wJU6oMk/dLZjqgNRxrkQH7/alVGsqPYDPr1Q7IcehDbbn4KkHEcdt833/lM5LpONvWnnezg3VVSNL0J5zFuvSI8lmwleshDrL8EivunBYnwHITLrsXxUCUkVwmwz7vMI7HYLBsZLJRzJtYVS0NxiNHOu9K5X0qj+T/BH2BFnNNTxtxJm8hI2dPApnbOd24KcdKlAxVOBeVz1LLZVivm7Xk2fNF/d34ohgTknt+B5iFs3CNWZ4tNDHTyodIjlsPoWwTIIyUcxoFmkCoXSv+D2iQRI9zLRpnYxaP+0miVNP2Eg/MPO8zU6JHBk0egr+8RrJ16LyWYUS5cBmvy22nyFCEhNg2A+0JR1VKeWZXxSQUCm13ROvoOSdKR2M0SakudGeJzaf0O7ZTMWYwYa2giy+owhpD0HAjebsMk=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7ec9e43-a86b-45fe-7b42-08d6daa9d1af
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2019 09:27:02.0021
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB2973
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



>-----Original Message-----
>From: Pavel Machek <pavel@denx.de>
>Sent: Friday, May 17, 2019 11:17 AM
>To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>Cc: linux-kernel@vger.kernel.org; stable@vger.kernel.org; Claudiu Manoil
><claudiu.manoil@nxp.com>; David S. Miller <davem@davemloft.net>; Sasha
>Levin <sashal@kernel.org>
>Subject: Re: [PATCH 4.19 042/113] ocelot: Dont sleep in atomic context
>(irqs_disabled())
>
>On Wed 2019-05-15 12:55:33, Greg Kroah-Hartman wrote:
>> [ Upstream commit a8fd48b50deaa20808bbf0f6685f6f1acba6a64c ]
>>
>> Preemption disabled at:
>>  [<ffff000008cabd54>] dev_set_rx_mode+0x1c/0x38
>>  Call trace:
>>  [<ffff00000808a5c0>] dump_backtrace+0x0/0x3d0
>>  [<ffff00000808a9a4>] show_stack+0x14/0x20
>>  [<ffff000008e6c0c0>] dump_stack+0xac/0xe4
>>  [<ffff0000080fe76c>] ___might_sleep+0x164/0x238
>>  [<ffff0000080fe890>] __might_sleep+0x50/0x88
>>  [<ffff0000082261e4>] kmem_cache_alloc+0x17c/0x1d0
>>  [<ffff000000ea0ae8>] ocelot_set_rx_mode+0x108/0x188
>[mscc_ocelot_common]
>>  [<ffff000008cabcf0>] __dev_set_rx_mode+0x58/0xa0
>>  [<ffff000008cabd5c>] dev_set_rx_mode+0x24/0x38
>>
>> Fixes: a556c76adc05 ("net: mscc: Add initial Ocelot switch support")
>
>Is it right fix? Warning is gone, but now allocation is more likely to
>fail, causing mc_add() to fail under memory pressure.
>

So far this contributes to fixing a kernel hang issue, seen occasionally
when the switch interfaces were brought up.
Other than that I would look into improving this code.
It looks suboptimal at least.  Do we really need to allocate whole
struct netdev_hw_addr elements? Can the allocation size be reduced?
What about pre-allocating enough room for ha elements outside the
atomic context (set_rx_mode() in this case)?

Thanks,
Claudiu
