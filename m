Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAC24451A58
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 00:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353707AbhKOXhf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 18:37:35 -0500
Received: from mail-db8eur05on2048.outbound.protection.outlook.com ([40.107.20.48]:32864
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1352033AbhKOXfd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 18:35:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D3stNcj3BiKNi2KCdK7pKYJioYfIV+/Y4z/dcBN3F88q3A7yUSy7dRUcvpO0rJDk/4suq9fZ57prslE+piaNSVK/GSWG+DXVMYcVw5sKMipokc21h7KTJUvdcrxk6rKEuHr/CG3ANn2T3SuexIRL3ybWoFD1XNUlnn1WOFUYaGL3J3/w/O2FaX5fyCUj2cQSiA9aZkqjNVVYrsxU/37RzyMxtkpQ3YS1gdefT32AATJOg7HpDBkwtGx9QoagZ3triV9InVbpf7I4vwGx0yNqLty/rroe9nTtV5++7wCPEgjMPDPqxxBDeTGlF0YFrVq4inHq/RHZcU6AJWVQkgC0+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DmvmvFerTWKYS7I5UsfNBmd/QX9EQGU/NDkeuozEOw0=;
 b=lggc+j3pACfrsgokJufRltndcR7CcjVCjhrOy77sllI9PKO0u3cIgePfLkcgPizdBayv3rMZJHNLSwdY6t2MChsSzaLJ6iXrWs1d7Hl3rCv5XLPNYcZ5rKDIVeTdRoikK9StmGucQyDojrXgN+VMhN/nyDhlG0QJS4i5kBGrjN0PHt1MhDzTgtkQF8UEZRN72Mz/ongsVX0/BSr6dIGKcEoOR1XRBdOoJlqnYMlFsYi4NHCvfpJCtkQlnyjNTN1qMwd+0HRL1hTYVxP+aplP+T97ekXozZJDm4RDwIdtTydNbo0cuAckMzA7Y+v2oB68jn+E2qHqyBQ0ocPl/Ls8+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DmvmvFerTWKYS7I5UsfNBmd/QX9EQGU/NDkeuozEOw0=;
 b=sMX8j6X9H0/MJ5wjQu/43vVRU75LlHqp4QWwzRIFZpGurdXiMnnCqE7aTfQJP2LRDCu9Bi3AXI2r4aUyilZ3MFwhNxls7oiGuQqqShWVZPa2/r6HYosPyKzuvSkM9x8d253EFbgdDuawfNYqV+rs7rtPx7XGO+txjOQlD14V53w=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6015.eurprd04.prod.outlook.com (2603:10a6:803:d8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Mon, 15 Nov
 2021 23:32:35 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4669.022; Mon, 15 Nov 2021
 23:32:34 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Hauke Mehrtens <hauke@hauke-m.de>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.14 309/849] net: dsa: lantiq_gswip: serialize access to
 the PCE table
Thread-Topic: [PATCH 5.14 309/849] net: dsa: lantiq_gswip: serialize access to
 the PCE table
Thread-Index: AQHX2ktAvpo9H001t0eRmU6FE7wP6KwE6IMAgABVCAA=
Date:   Mon, 15 Nov 2021 23:32:34 +0000
Message-ID: <20211115233234.3or3vduhx4bgcebt@skbuf>
References: <20211115165419.961798833@linuxfoundation.org>
 <20211115165430.700038680@linuxfoundation.org>
 <511fefcb-9cad-bba2-e267-710994874097@hauke-m.de>
In-Reply-To: <511fefcb-9cad-bba2-e267-710994874097@hauke-m.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: afd981aa-2e19-496d-e65a-08d9a89033eb
x-ms-traffictypediagnostic: VI1PR04MB6015:
x-microsoft-antispam-prvs: <VI1PR04MB6015B829801C122664EEEEA0E0989@VI1PR04MB6015.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: X3GOysOSsKK+/EwGer/Gvjp9eidBl217sc2R9jQm5zdBFWLBwHhtpnn2toFAgkEO3/S6poYJnlhVpK8bPw501S5VCclOKsaP/g8DRH2paP67wvoGhuHf8aH7MydVJQhbOpS+W+XM6l7TXRt3CUIduQ/jBz4nqgP2ZX7Rij7jH0zGBCRhp8kD1WEzNOZSm6yeA5nNCaBS8XoEXtqEmow4F11ERocAl8AYBtHCDYOnY7AGnBNkMwHg+rVFFQztQ2cagKahJHXnIJSau3Gerx0h1NAGzZYJIZeOISPwg95dE3gSm8wVbcACfmACbwjWf0j3XkrLavIHpCO4RB6cb9qzwErCwVlci/N4/+Yie8HHogDaAVP05RzF0tF1fjxdX82BrpYfH5v9riT8de1TzOFhAFwUEzILwTDdTbdjgYTLCf7OB9++tJVKr5xC3U/Ws40M0csMlM0ZOeW3QKIUbH+JSnicoeC1WHHVNusPsAo/8YL2Yv7lQUl+vyKoWXL1iHFDC16yZAP6tNlQXOcOY7ZsztltfLr2bTfcqnNtoUA+3w4leT4tIfhMg1KqlcC9vmSBRGnIjc+8efskCe4JtuhFlcxgvH4WGHVHfgBFo693UT4X7SM6u7pl502qbhAousM0SYm/SUWHCCZbBlMIygLIpdCYPJZWqmSsvENQI6AT5IZIg8HrzXJDEVpA4ntLw+/Mw0VI8sefbZpqKXLZzwgUlw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(508600001)(6486002)(53546011)(54906003)(6506007)(316002)(83380400001)(66556008)(6512007)(5660300002)(44832011)(38100700002)(186003)(26005)(38070700005)(2906002)(8676002)(66446008)(4326008)(1076003)(33716001)(76116006)(71200400001)(64756008)(66476007)(8936002)(66946007)(86362001)(6916009)(122000001)(91956017)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4YctOAHlUYhK7LeCFwJY1xB4S3/cU+3/LKQtNTTzv+KDrWzZbr+1KjZiPJnI?=
 =?us-ascii?Q?/Eu2kUJMzV2y6u7mxjKYtNFFqfFR803fmVb1nnUpUAQa3KptPagz0HrPuNmk?=
 =?us-ascii?Q?wThcxDVRy3K26lDfofwebCOyzY2sejx5Qjx0KOOtJsavX52CWAjdJmmouHBG?=
 =?us-ascii?Q?8nsjPSSTUljYxfznpTzGzz9K4m0fMDC1T0QPCqTx3lLVSDAqh1bLES8DLoJe?=
 =?us-ascii?Q?MF8URi9nnK9QZZ0LatttMXP6QrXZN+J4K+R2lfFHHKuQ2oIdpNDCd0AvlYw/?=
 =?us-ascii?Q?HDO5arblhInF+saEGRv7JAHFqKIXOn5BXcI1HrzLYCGlqZg+aXpzTRMJnmnV?=
 =?us-ascii?Q?qHtl/t42zoNYaDoxjWZlsUo4isnSO8fUpE4zKEbUaLnQcRwLUIEt2/lzRoGo?=
 =?us-ascii?Q?2WIjOi8bQkrosA8TfcLvdQnjwTPpp0aZurZuGq4igbr65pezz+oCSqVwPSgK?=
 =?us-ascii?Q?lVkkAx0uFO8bvNQFzYQqwhog5hN6tg1ogdLdf+0omLARfOCbIlvdAsa8iAYx?=
 =?us-ascii?Q?cSG75bLB7Dyook9ZElEo1yA1ZbIj1x2r5oCwHzLT4+w8UT8waf6oeJEgbOR1?=
 =?us-ascii?Q?+G0WICoJ+paESIL5G+KSMGaOMm4RruECsLy+dENIuNPy1KV1OeK7sZyJsFtz?=
 =?us-ascii?Q?eroDmlbuc8v/NOYiwKj2ZR7TXycZvznfoAlkm2KBuDhK7RRdSx2i76XwelT9?=
 =?us-ascii?Q?JMj2Suw8evBqwfeU/E7zlQTcnHg8OCy81QdAMJopJlUcks2amDdbyoF4klyi?=
 =?us-ascii?Q?U5oLzLwLx4jEQ74dsohIfP4BzL+Wv3GnOZSFoWPmyI9wBRMGRWDNhRl77N4F?=
 =?us-ascii?Q?eEFLMyLXVuk4AmyJyD/GmzOUMOu8w0JcQquZSMi7N5HdOMaW2d4gvIm1GWQb?=
 =?us-ascii?Q?9TaVCv7ZIYHIWHlPhKpkLA6HPBfMac6b62ZLpO3RZGoOphlR43LoHBbN2BHp?=
 =?us-ascii?Q?yFMi8e/xK6ixBRDy6KTFjXbKjticuazLu1/s5nmDo0jl6zBBpzEO+9HwxjqG?=
 =?us-ascii?Q?uT7Ctu9ueVowyt6mYIZ50bsDhBS0X2uIHzd5K8hdWNn2v1q52ip3Qu6P6WoZ?=
 =?us-ascii?Q?9gfPGm1On7MYpZseBo82wfW/FiVebBCC7AY6dksVmJppaKA/aLwdMmZu6ZLy?=
 =?us-ascii?Q?WfQV5jQa7NXp1gt4YPO0wS4Xm/TGvLy9uuV0mHtdwUom4xaEXj5aLlfoCx/Z?=
 =?us-ascii?Q?W1J8YpXEn248VjKuD+6obmhe0LFK7mZUqMrSmIHNuFUspIcSfNBgmrPO+PGB?=
 =?us-ascii?Q?L9oqAnyO4cmR2XVRoA9Ofyo5VJHddJzltFJDq2WEvaWXSxn6aMBeTbSuBIbQ?=
 =?us-ascii?Q?borXzGlxoEZkrnrBDR32IXaMOzkgIxVZe5n31CkkUp7jITTJAcDHLftKnwSj?=
 =?us-ascii?Q?bvb3j4LnAOZsqdZ79aaOhRScR0e34/f05KqxV3Tg27T0XFKPHKlJu+jJaqNA?=
 =?us-ascii?Q?2ygRSHQujN9qBd2zUdOBMQSuzgFefs/n7sk2vM2ese0LTEpHKf89GnIPubnF?=
 =?us-ascii?Q?2DDFL5ERFRUkOVYQKD+nRzPRbpOverOhY+w+ba2gOjyJWLLA1GOA/9xrgRpr?=
 =?us-ascii?Q?m4pfgGAeQuhR/VpH0TQ4u1WDESRJe/sf/Pi2WsbddWCyKsQV1EqDoU4dzmxd?=
 =?us-ascii?Q?qW0lbJY49860CqKMsNdbucM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6A12A54D7CA70E4F9D8B9920C7F36D79@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afd981aa-2e19-496d-e65a-08d9a89033eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2021 23:32:34.7791
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /596MrW9qrtkd7zTStkS4+9ueuLDrrYFzequpLB9bmbsUIbhaIzlNZRQLEizbizyCDg8gs7eQh4IDVj//eWdzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6015
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 15, 2021 at 07:28:14PM +0100, Hauke Mehrtens wrote:
> On 11/15/21 5:56 PM, Greg Kroah-Hartman wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >=20
> > [ Upstream commit 49753a75b9a32de4c0393bb8d1e51ea223fda8e4 ]
> >=20
> > Looking at the code, the GSWIP switch appears to hold bridging service
> > structures (VLANs, FDBs, forwarding rules) in PCE table entries.
> > Hardware access to the PCE table is non-atomic, and is comprised of
> > several register reads and writes.
> >=20
> > These accesses are currently serialized by the rtnl_lock, but DSA is
> > changing its driver API and that lock will no longer be held when
> > calling ->port_fdb_add() and ->port_fdb_del().
> >=20
> > So this driver needs to serialize the access to the PCE table using its
> > own locking scheme. This patch adds that.
> >=20
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> > Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
> > Signed-off-by: David S. Miller <davem@davemloft.net>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >   drivers/net/dsa/lantiq_gswip.c | 28 +++++++++++++++++++++++-----
> >   1 file changed, 23 insertions(+), 5 deletions(-)
>=20
> Hi Greg and Vladimir,
>=20
> I understood this is only needed when we apply the complete patch series
> from Vladimir. This would only be needed when we also apply this patch:
> > commit 5cdfde49a07f38663c277ddf2e56345ea1706fc2
> > Author: Vladimir Oltean <vladimir.oltean@nxp.com>
> > Date:   Fri Oct 22 21:43:10 2021 +0300
> >
> >     net: dsa: drop rtnl_lock from dsa_slave_switchdev_event_work
> This was added in v5.16-rc1.
>=20
> Without this patch the sections are protected by rtnl_lock().

This is correct, this patch does not need to be backported, and unless
it is needed for purposes other than fixing a bug, it should be dropped.=
