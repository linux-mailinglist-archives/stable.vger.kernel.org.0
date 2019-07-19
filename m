Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1469E6E3B7
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 11:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726077AbfGSJtM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 05:49:12 -0400
Received: from mail-eopbgr70089.outbound.protection.outlook.com ([40.107.7.89]:17605
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725794AbfGSJtM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 05:49:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AoeAIG1q8Yuk1+/7wTJgH3pLzn5ZtV7AOV4Al25NMEdLW0AgBbyZVYgPm5kc8grGYssj6PbQ5xYqweFwpKLlkyU98Gpxw1lYpIpAklQTZKiRRIKm3Lgijq+mM95HNZdlLmWWlvRdhXi2qZL6kcVxXrNIIZSawLGWWZdkbb29D7yjSkE5+GhuDB//tpoyiBC1dI+EzwXTuAoqhcBOXB7sm03EIt9kLXmU5xFBj4uFonbjIWMiwm2CfKAS7PO+EfR6ISS9cR0m7hRogN/uWhPzpA3LLRDRxCP0CYV1w4V5Nk2CeQoXjs8KWkiCN0JD1KQvy9KXJDm2X3UktWgDBqP/qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MHmXGQ2BpOIrzVP1ZvRk8Ym9zVbJRhkCUAVeYqQXEq4=;
 b=dngsDWUr6e/EQCaizmwKILs/q1ZjqgCqtNCS4fSPA8NX7Ru+cARJPDFSHRLsU2sqSWrdbZAEaDRGUe54u9sN1u8pwlSmElY4CsDCiol/SjUzKemSJCxqCJOx7Z2GJ4x/shBQjUe1s0vwo3U9nE0fnQ0OPhPuWWNFikgoQfHthdDqrk4xi7Y5bL1DZsB4v4XLrCtGm7nEjvojdcw/R4oYC41u/9PrLHLv8rptw1Ci27WL4pux8LvQRxuVEpnNEsA5ZVUKVmw7IzeHoeRVDdN4ozIrGAyaEmr5Qr8FSVKNqo49Zcrf2VG2no4trumgwJGxO88cToZT+0xN7m3qDH3TQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MHmXGQ2BpOIrzVP1ZvRk8Ym9zVbJRhkCUAVeYqQXEq4=;
 b=LDgVGGENxCNEWgaDAtWlE+p0bNhwtPTHkUrUiMRdjU9jAFVqJ4u28fP/oYiTRQXWD/wvNVA2Yp6oiYif/MiZ9FdCQAFD5j/ZTZX/at8swTm3AN2W+yjGALut+nyDdi38MBTZw1Xb8I6kL5jLoEhpdJ27mpS4VgfKqT9jl5pNDVI=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2766.eurprd04.prod.outlook.com (10.172.255.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.14; Fri, 19 Jul 2019 09:49:08 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10%5]) with mapi id 15.20.2073.012; Fri, 19 Jul 2019
 09:49:08 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Sasha Levin <sashal@kernel.org>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC:     "David S. Miller" <davem@davemloft.net>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2 01/14] crypto: caam/qi - fix error handling in ERN
 handler
Thread-Topic: [PATCH v2 01/14] crypto: caam/qi - fix error handling in ERN
 handler
Thread-Index: AQHVPcSpEBYt6s3Mi0iqUk4p73ULPw==
Date:   Fri, 19 Jul 2019 09:49:08 +0000
Message-ID: <VI1PR0402MB34853BFAD7E6FA8ACE50027B98CB0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1563494276-3993-2-git-send-email-iuliana.prodan@nxp.com>
 <20190719004525.7D8792173B@mail.kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8da56af9-20e4-4a0c-14a3-08d70c2e581e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB2766;
x-ms-traffictypediagnostic: VI1PR0402MB2766:
x-microsoft-antispam-prvs: <VI1PR0402MB276614048A30F937D278E49E98CB0@VI1PR0402MB2766.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:635;
x-forefront-prvs: 01039C93E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(396003)(346002)(136003)(376002)(189003)(199004)(91956017)(76116006)(66946007)(14454004)(66066001)(54906003)(6246003)(53936002)(66446008)(2906002)(66556008)(66476007)(64756008)(8936002)(256004)(68736007)(478600001)(44832011)(81156014)(4326008)(305945005)(74316002)(7696005)(5660300002)(7736002)(486006)(52536014)(81166006)(6116002)(25786009)(316002)(86362001)(3846002)(4744005)(33656002)(9686003)(76176011)(55016002)(8676002)(6436002)(446003)(476003)(229853002)(99286004)(71190400001)(102836004)(53546011)(26005)(110136005)(6506007)(71200400001)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2766;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 8lQqsLV908E5JDdmHgJRAdmjZIcltxqoU0vs/zAzPinAV9X5LkOTE5AhcshSSQ96R50BHqJ7ti8jxRPsoT0y3PtNwfpSXNeJw5/jhgvZWQPZHv5imzSqXMEjVAc0P3dggTk8fmh0ZZiJJ9T+SO9el9X4IVWey4ZHd86HCXFGprVovfNhDZIcaPI/BYALqX1QJvK8pf+BEmrjfIG+dn6FltTkhTju3hQ3rPEtyCXtK7UVrynvkFC4nBxbsUGZuqdYN0CDSBf0cDAHptdbxULrG2RX0oRVQHB2EA5Uvl/8JVbuSzKvMNOaeJsHtbmlgc7dls+57fOcSOmgTPXF9kMHeTU2G1Y/F868VygIz3jJEhxpjF5z1kUfuR6pICWdsiXvdscAP+vUWHWZ77lOFRKo++go2wx1y2zuQwzP8qWEyxw=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8da56af9-20e4-4a0c-14a3-08d70c2e581e
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2019 09:49:08.1340
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2766
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/19/2019 3:45 AM, Sasha Levin wrote:=0A=
> Hi,=0A=
> =0A=
> [This is an automated email]=0A=
> =0A=
> This commit has been processed because it contains a "Fixes:" tag,=0A=
> fixing commit: 67c2315def06 crypto: caam - add Queue Interface (QI) backe=
nd support.=0A=
> =0A=
> The bot has tested the following trees: v5.2.1, v5.1.18, v4.19.59, v4.14.=
133.=0A=
> =0A=
> v5.2.1: Build OK!=0A=
> v5.1.18: Build OK!=0A=
> v4.19.59: Failed to apply! Possible dependencies:=0A=
>     94cebd9da42c ("crypto: caam - add Queue Interface v2 error codes")=0A=
> =0A=
> v4.14.133: Failed to apply! Possible dependencies:=0A=
>     94cebd9da42c ("crypto: caam - add Queue Interface v2 error codes")=0A=
> =0A=
Indeed, the dependency is correct. Thanks!=0A=
=0A=
> =0A=
> NOTE: The patch will not be queued to stable trees until it is upstream.=
=0A=
> =0A=
> How should we proceed with this patch?=0A=
> =0A=
In the next version we'll remove the # v4.12+ requirement and=0A=
we'll separately send backports once patch will be merged upstream.=0A=
=0A=
Thanks,=0A=
Horia=0A=
