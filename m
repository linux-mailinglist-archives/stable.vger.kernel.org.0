Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C892588FEF
	for <lists+stable@lfdr.de>; Sun, 11 Aug 2019 08:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725863AbfHKGRQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Aug 2019 02:17:16 -0400
Received: from mail-eopbgr80051.outbound.protection.outlook.com ([40.107.8.51]:42211
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725810AbfHKGRQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 11 Aug 2019 02:17:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q6QRf7pP+/fngsCExkhYyxF585mWIefWK2umtgDBbklIVtQ0Fzc8tQSbiYwv8Ga33kAgtewfGYVn3WcOAPF7cDXhfWJV0nMpzmHUPXulU8+UdxZMJBM3QmMZ/xpb+mKKGhRKITrCcd/cCMio+G5inFYOJ9As+6NA1W9rjQOO9x2xk1T2uxHbcwu4hFFuXG+KTg8PkTL362s4m1e9vwqsoR1Py4zpWThFU0+a0uvvUTgC1RFvsHNL0LxzF1sAhUCKwynmUr3O+9C2SZSF7XCKcL54pJH3mMlqY9n0bRB8rb+CGCJ8fb63BjBohtGwbakCaEfXYq5uViXnGIqxB0HxKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6DUhTzwJf8Io2rLCQO+HDLF1OyB00srAAcm976Gfw74=;
 b=Zw9h3A0y7czGsPws3MMQpUY9Hj4yX8DV0jrdHEbBV3/SdvtHIEH8bCUP/yYDm4zDQzKhMS4dcj/Scl1QRcjDroGeqDk0+IK05Jo6+2ZOp61r37TucwaUlkaqX9xgZi7Ak559NChKe3W0LJmDOgL8v/Tu69TKYL+h/ia4rCn50Lltbiz2lHHdfi2AMO/DjxZ1Dd80DishM+CPoSZZQh6gNm+CLtz5C7QWxkq6kqvJRZ1btLzu5JqA8cONvSjThqeTpEZf+zFIzjM/7TiaqUc7KXPVog7M1mBlyWMatnENRa3gzSvM7D/T7nDoELLrzJ/+x746Fml8EGkMhFWpmSk7Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6DUhTzwJf8Io2rLCQO+HDLF1OyB00srAAcm976Gfw74=;
 b=Vs7oS3CCegA3N4uRJyyZnOPlhJ60iuqgXmwc/3ZkP4KIu0RnXur+pgtWcf9JVfNrSMPR0nJYUXDkyMoVnMaf/6VKkN6IYyrkC3HCvQ/bTgw2D8HrMj76dncL42RUUIBnEpOm9s+40xDsb9uBGw6n4/JO7V7ZY0apFbnptWeUpQY=
Received: from AM4PR05MB3137.eurprd05.prod.outlook.com (10.171.188.155) by
 AM4PR05MB3236.eurprd05.prod.outlook.com (10.171.186.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.18; Sun, 11 Aug 2019 06:17:12 +0000
Received: from AM4PR05MB3137.eurprd05.prod.outlook.com
 ([fe80::a1bc:70:4ca9:49f6]) by AM4PR05MB3137.eurprd05.prod.outlook.com
 ([fe80::a1bc:70:4ca9:49f6%7]) with mapi id 15.20.2157.022; Sun, 11 Aug 2019
 06:17:12 +0000
From:   Leon Romanovsky <leonro@mellanox.com>
To:     Pavel Machek <pavel@denx.de>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Edward Srouji <edwards@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH 4.19 36/45] net/mlx5: Fix modify_cq_in alignment
Thread-Topic: [PATCH 4.19 36/45] net/mlx5: Fix modify_cq_in alignment
Thread-Index: AQHVThzUf1ywxcty9kmSJ0G2vhImXab0QHqAgAE8HQA=
Date:   Sun, 11 Aug 2019 06:17:12 +0000
Message-ID: <20190811061710.GE28049@mtr-leonro.mtl.com>
References: <20190808190453.827571908@linuxfoundation.org>
 <20190808190455.839364156@linuxfoundation.org> <20190810112544.GA6147@amd>
In-Reply-To: <20190810112544.GA6147@amd>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0096.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:18::36) To AM4PR05MB3137.eurprd05.prod.outlook.com
 (2603:10a6:205:8::27)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=leonro@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 334253fa-eea7-45a8-973a-08d71e238c4c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR05MB3236;
x-ms-traffictypediagnostic: AM4PR05MB3236:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR05MB323609AF0F4DE52313FB106FB0D00@AM4PR05MB3236.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-forefront-prvs: 0126A32F74
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(136003)(39850400004)(396003)(366004)(199004)(189003)(66446008)(64756008)(6512007)(5660300002)(446003)(66556008)(8936002)(4744005)(186003)(66946007)(9686003)(476003)(11346002)(71190400001)(71200400001)(1076003)(6506007)(52116002)(386003)(6116002)(486006)(3846002)(26005)(2906002)(102836004)(14454004)(86362001)(66476007)(76176011)(256004)(8676002)(6916009)(4326008)(229853002)(478600001)(6436002)(6486002)(33656002)(81156014)(81166006)(99286004)(305945005)(7736002)(53936002)(25786009)(66066001)(107886003)(316002)(54906003)(6246003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3236;H:AM4PR05MB3137.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 7Mrg7ZDDblwu8Rcc4uVEkI7QRxPQlJYAIhFdR5dd3M9x4KbFc//5nnx1xwYaXDD7ua3Ctx5TXAP4lrHyNJhcHMG8CGx6Q9aO+55aaP2ELT00eq6evVAx6YwRP+WJXlwShNoZ95hk7MWmzMsdqLk1tF4iPqQR4iohbUieTFMtFiusnjWvWIw1JusMhtv++tBpd4WCoTXsM2CUyLdoKsyzvvwJ9SPbkro0YMvSdrqCXuVKL6ni5jO1RN17D/DppTxSS56jTAZnCy3K26iHlYO1m1rnrQRHvupcmlHIETEf2GrsKYA1U9aRrDL3ZQqqcixTm74BwaEomdYCIj6t7/PwBaUNJ0Ww70zDGOsFuBTIUe3bDKVpcCMJ4MTqRjw2xhdSu0Ft8hU+5mUYNjlhJ5Vo8CIXw+nO8iRNBKvnntPv0RM=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <931E8E9B11E9404E823EFD591D40EEA2@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 334253fa-eea7-45a8-973a-08d71e238c4c
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2019 06:17:12.4981
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lf9cYTrUovgnsiQ1wcCLL3zqU75rHdpuVe/BPBeMZfr+v9jJWI634XSr5CDBZM2K7RIi8FUHiH3ETiW+1di94Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3236
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Aug 10, 2019 at 01:25:45PM +0200, Pavel Machek wrote:
> Hi!
>
> > From: Edward Srouji <edwards@mellanox.com>
> >
> > [ Upstream commit 7a32f2962c56d9d8a836b4469855caeee8766bd4 ]
> >
> > Fix modify_cq_in alignment to match the device specification.
> > After this fix the 'cq_umem_valid' field will be in the right
> > offset.
>
> Is it neccessary for v4.19 stable? The cq_umem_valid field is not
> there, and it is not needed by subsequent patch.

The change is in hardware specification file which we prefer to keep
right and upto date for our partners who use stable@ trees.

Necessary - no
Beneficial and useful - yes

Thanks
