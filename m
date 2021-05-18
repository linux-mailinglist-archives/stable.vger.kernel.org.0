Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE78387A64
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 15:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240909AbhERNub (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 09:50:31 -0400
Received: from mail-eopbgr80083.outbound.protection.outlook.com ([40.107.8.83]:40030
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231285AbhERNua (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 May 2021 09:50:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZSa0X1eK9KkZhnnMxeiLe3gRYSd63py0oj9pUubBBDEFX05IAqosamHtiN4KU+H81xF6GclAnTfJ0Z8K35Hb2nyNvsWF3+vh52m0Dck8175KyrzWRfxBMnPFnF1X9ImB1T+Pbo0QPtN4YDkVytr+Turyy99emMLOsIumw88XdPS65VFEfHYAVWUyMP3uFEFV9Sv+79CopkEizab+EwIgq0RdSGkbuZGORsRxIQxAlCpNK0O7ymuhYWnen6ycCATIIBbSuhrL4PGBuzbivCaWq5YimumM0JuVwZ4CJ8rvEI5Yk8JEzwTg0VWv9zItS6tBHNp1qLyfawxrc4fOTIwetQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S5CC4vWadh+hrab6Lsp6tHbdcF0IRjQFyu+8rcjEL80=;
 b=kVy62HTLQoaeZBCKMVk6wr6d1BMmC8RJuXtpHIiXezYGh8kPevQf1Amk0xTqunZfrkqSl8+8LDAwXtsmFYfDQs8A/tydnZzi9jE3ay8L1Y3sNcg0nkpQCqgA2jf/v+sKbjMNKpMFDW6JQeXBepQlVr3F56vtdGxyRQ+JX8s+rhXzO7/YR6zKkFjgwqoAmO3iBjE7EirJigTnF3xsY5c1+U6gXXwbyn/JhWcUOJ3xZv5VmDozCcRtzwKrsssCXvH8GblojghK7yj2LjxoNhb0tFPw6xS32BwXn94/BfZ2NCQ4qUKayMw/j3dc4nEi06rJIM1PMmDEHvxc8jFiSG8fXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S5CC4vWadh+hrab6Lsp6tHbdcF0IRjQFyu+8rcjEL80=;
 b=ncE9a5ixF8pdK1xRdyvaQJjJIHiPmmwYMrxH9BwJFpR31M648drPIfz/Sp0AZk2Cr9+SSLuaKTh3KRi8C0f7VkCNYRRpRKpp/lRGy2Dh+M32gPT6rxbzIuQwGNsmLut0+THvKwVQW+q9xJaZng5HWVR1figIuYBHz0RcbySp2jc=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2685.eurprd04.prod.outlook.com (2603:10a6:800:58::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Tue, 18 May
 2021 13:49:10 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4129.032; Tue, 18 May 2021
 13:49:10 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Rudi Heitbaum <rudi@heitbaum.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.12 081/363] net: bridge: propagate error code and extack
 from br_mc_disabled_update
Thread-Topic: [PATCH 5.12 081/363] net: bridge: propagate error code and
 extack from br_mc_disabled_update
Thread-Index: AQHXSyXz39k+T2AuW0mkDF4mKAdj96rpK1SAgAAEIICAABNngA==
Date:   Tue, 18 May 2021 13:49:10 +0000
Message-ID: <20210518134909.iak6mdnscrcbzm6f@skbuf>
References: <20210517140302.508966430@linuxfoundation.org>
 <20210517140305.339768334@linuxfoundation.org>
 <20210518122449.GA65@ec3d6f83b95b> <YKO1jx78HibCUDkD@kroah.com>
In-Reply-To: <YKO1jx78HibCUDkD@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=nxp.com;
x-originating-ip: [188.26.52.84]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 442758ce-80a9-49b0-21d0-08d91a03b6e4
x-ms-traffictypediagnostic: VI1PR0401MB2685:
x-microsoft-antispam-prvs: <VI1PR0401MB26852C76E627CB480DA4F21AE02C9@VI1PR0401MB2685.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:989;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5W67PXZKRUnumBt6+6TmrCYgn2ZDVzGk7YX+QZDAoAM6zsPFwFGQjHKUGI5dnzi0QN8yFf8pENriNmbGZC13WKFs+WPbYXVpuJbsA+A2FkCU7N+RYy9LAD9CrI+oyeh5wKKeSN9Rl/UbY9sB3JF6k+zxDXEjsY/W8CWHpq9pKzDzcYx7hq7h2wBPmr65wHEbyNmIgXsOx7yB16oB+EUjWr0kZeDvDO43IdA1hWGTRZkpm7CQ1VLmS/P/h3riQR/mu4YqLQV+iAPxfsXaef07i/4Jlua9z0aKeCu/gduNvorwoKJj5jfm+QquYXu1Wa2uF+nQcXRtTpz3PSgKpT+ZVR4NvYsaeLWscwcZe5UzLVT44atahgsH0nSWHS26LnaTZSHpQnFok1lWO75dGaGs593n0d2oIcoHm7enUE1S2vX7A0F+PaR0aWTATDv4tEoPwg1ZCxva0g0V6poz1fpkIMrCOhX+3HSwv5rHTR4mq6crIxmm8Zp1iOdosdPrGBaAKdJXlVtNFPRPaMeJUzFjltMX4lV74Pkvvlh8ymGAmRCcpRyFmRd3JU3EFtH+Z9NoVCDB7BF7rIPQhlhx7bCi3XIKEw3x6W8H0GIaKkE7z20s0UMj1dzd0Pv3oT5Ulr6gq3kFLtcjAbOiPjmVyt79tFxZuhXVls8R+Ywq9sggNO+bUH0jc+Tc5R5IPUPGSuBx/8qiEmA+WtHC+mroxULcdz78ovD4cpksPR1QjzbC0IY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(39840400004)(366004)(136003)(346002)(396003)(376002)(6916009)(8676002)(83380400001)(186003)(6512007)(966005)(9686003)(26005)(6506007)(122000001)(5660300002)(4326008)(44832011)(91956017)(76116006)(2906002)(38100700002)(66476007)(64756008)(66556008)(66446008)(316002)(6486002)(66946007)(86362001)(8936002)(1076003)(54906003)(478600001)(33716001)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?azfIS48aI/7coXLzksvyyeDhLbJJEetKlT7ggV9IEvGq+EeG9MUzzgMt/xFq?=
 =?us-ascii?Q?0znjlZZTIQbIy0cPk2UTbBywdjidqDuyeYtBbimNWpFS9XdiPukWSg50nSHV?=
 =?us-ascii?Q?/tazq3SHe0UlT433WmlpVYu5EFDkFGtwUvmPQVEka2dbohiQUsM7POePkIzF?=
 =?us-ascii?Q?L4SUqYgvSifb4i5mnrGFfnwrB2cAudWrF5efrcZHCWW7zFUB9IIgDsHWC7hr?=
 =?us-ascii?Q?lnJMM0hwVIWQNLri4APlxUFso+QpsvG5EywQnYSdb1dS9vBC8sX1wixAe4lr?=
 =?us-ascii?Q?tnht9fH6FllnffPueW+7q4o+F5JxWVUlJgqLHLalv+OPZlwttFcOkxCb5YuO?=
 =?us-ascii?Q?/sRpymku+XkVTiaYbgasRFwBn30f0VN1gdNs8ShUPu+24IwJuRY/6RmGPqBe?=
 =?us-ascii?Q?nLvFVmSGPjOgm4y6mvIe+A+P54LOkd2HG+RWdDGKufEU8O5MvAMeXG1Bx7Si?=
 =?us-ascii?Q?Ti7x64XVpHuBQVOQTYoVxzfcte2hcZUKoX+/Fl9XDm1BVDliAvMllPy8dBDL?=
 =?us-ascii?Q?JLftJgT/81Hmy56qtBnYfS6rxrQXdopSpAzDMg4O1jqHNatA4gQuiOCwWxRB?=
 =?us-ascii?Q?BTAiyBiH8Kce5NXz/DW8nztiD4T96ZfAqAdqfGmXx8uqDvx0t+l9otoVcF+a?=
 =?us-ascii?Q?z+Td00omtpSSQVsM6VBRNMj0x6PVMR+dMTIUnm0Ki8EQDc2mSSc0rxHWUWND?=
 =?us-ascii?Q?MLfwAWqUH8/u3EayPz2HPt18CVaEDsnlgxGGp1OrVFhSo+7gw4Ae0nG9VTpm?=
 =?us-ascii?Q?L5XXl/Ss3f20Ug5RE7/JqHWIbwJd88USZee46S3lsfgohHHGA70oVc6MxjD1?=
 =?us-ascii?Q?AYw6hkYZzZJO7i2bJaJZR12Hmlt4zmSW3ic4/AugpL8SvSd+bRfDkI7GYA6R?=
 =?us-ascii?Q?NFXpUHZJLgJHLTLYwsTh1g0351ung3R5Jw1el2nDE0Ug1frUoGLnd4vWLuZs?=
 =?us-ascii?Q?W/ex/47B48YOCDVWVPPfCK16AABpLTOZGDPOn1MeEHUfTJDHHqv3zgxfZwR+?=
 =?us-ascii?Q?bHp0OyPeK3/As2hQzSjIEgNWxU1Dk0EpWlgrTqtD2KavBL/r8DOE3RnZiDWF?=
 =?us-ascii?Q?iRTxT6HdX+kD+OGaFmcB1elU4Z7t3VWR2QF+Nr3Owh3J4mbhj09t3/a1EI6I?=
 =?us-ascii?Q?mLkiFCQDgmPTiF9rkwDIeX5jiCjA/K8sJnpDatwl1rCgCJOOiwOxUAPI0qEK?=
 =?us-ascii?Q?V/6+HnQCAWFM5OvIGLxQa3e+kRnis0BcmgA2Ni8HQM6NSw14A22zBQBt0GqY?=
 =?us-ascii?Q?WS1MKhq1Ur4dvRqYjjbo/37k2r9hjA/KKNfK+KRidWG6DfknvSG0eJKtYEh2?=
 =?us-ascii?Q?YOW+uzXm2waUiGzspq5ct1Zu?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <17EE8D362C73F9419BDBFA28D17BC493@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 442758ce-80a9-49b0-21d0-08d91a03b6e4
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2021 13:49:10.4024
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DvYfArVFIBmQmBJzyHwUKWq/4LXQudWQgCeJ6s4TKGwVN4ndGG5tcakyZrMDTHZ/izuRXfC9w3nnHeWE/PO1Xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2685
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg,

On Tue, May 18, 2021 at 02:39:43PM +0200, Greg Kroah-Hartman wrote:
> On Tue, May 18, 2021 at 12:24:57PM +0000, Rudi Heitbaum wrote:
> > On Mon, May 17, 2021 at 03:59:07PM +0200, Greg Kroah-Hartman wrote:
> > > From: Florian Fainelli <f.fainelli@gmail.com>
> > >=20
> > > [ Upstream commit ae1ea84b33dab45c7b6c1754231ebda5959b504c ]
> > >=20
> > > Some Ethernet switches might only be able to support disabling multic=
ast
> > > snooping globally, which is an issue for example when several bridges
> > > span the same physical device and request contradictory settings.
> > >=20
> > > Propagate the return value of br_mc_disabled_update() such that this
> > > limitation is transmitted correctly to user-space.
> > >=20
> > > Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> > > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > Signed-off-by: David S. Miller <davem@davemloft.net>
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > ---
> > >  net/bridge/br_multicast.c | 28 +++++++++++++++++++++-------
> > >  net/bridge/br_netlink.c   |  4 +++-
> > >  net/bridge/br_private.h   |  3 ++-
> > >  net/bridge/br_sysfs_br.c  |  8 +-------
> > >  4 files changed, 27 insertions(+), 16 deletions(-)
> >=20
> > This patch results in docker failing to start, and a regression between
> > 5.12.4 and 5.12.5-rc1
> >=20
> > A working dmesg output is like:
> >=20
> > [   11.545255] device eth0 entered promiscuous mode
> > [   11.693848] process 'docker/tmp/qemu-check643160757/check' started w=
ith executable stack
> > [   17.233059] br-92020c7e3aea: port 1(veth17a0552) entered blocking st=
ate
> > [   17.233065] br-92020c7e3aea: port 1(veth17a0552) entered disabled st=
ate
> > [   17.233098] device veth17a0552 entered promiscuous mode
> > [   17.292839] docker0: port 2(veth9d227f5) entered blocking state
> > [   17.292848] docker0: port 2(veth9d227f5) entered disabled state
> > [   17.292946] device veth9d227f5 entered promiscuous mode
> > [   17.293070] docker0: port 2(veth9d227f5) entered blocking state
> > [   17.293075] docker0: port 2(veth9d227f5) entered forwarding state
> >=20
> > with this patch "device veth17a0552 entered promiscuous mode" never
> > shows up.
> >=20
> > the docker error itself is:
> >=20
> > docker: Error response from daemon: failed to create endpoint
> > sleepy_dijkstra on network bridge: adding interface veth8cbd8f9 to
> > bridge docker0 failed: operation not supported.
>=20
> Ick.
>=20
> Does 5.13-rc1 also show this same problem?
>=20
> And thanks for testing!

Did you backport this patch too?
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/=
?id=3D68f5c12abbc9b6f8c5eea16c62f8b7be70793163=
