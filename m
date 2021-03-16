Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7A033D93A
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 17:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236190AbhCPQXd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 12:23:33 -0400
Received: from mail-am6eur05on2063.outbound.protection.outlook.com ([40.107.22.63]:10209
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238656AbhCPQWk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 12:22:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VZPPJqf/YU+wroa90QOTLq60GvOmMTAGcrOTsVkLyKVd/lGfzEm6k/+9DUcIA4v7vGX9RP9tRLkiUIYJjn4/AfDlTW0w/TzE5i5bj/R0j2rfFt6OAymf4p1lFe6JQ6lRD04Gw/yqAA7A9oatP5slY2Stnw5e+NyND+LGrbPnKJIsxcpDFbwHKc1e9h2bHC1blRd1vZvMg82s5u/oMqxiTcLb+9PXoSUSdrKF5RvXATKraDRaH7g8NrypKiAzWovAy7gnZjZrrox8/cpLCc4Va8/jHH+kCO7BzG+yUgLS8XGpFmyWD2DsdLb/N9sgf9Rr52mxg0O1Uqz4cKJdpLSC8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MQG5F380bs5dNm8G1TDnJ+4QZ5S3hkHgqAJcpNYeKvQ=;
 b=NbQOsTLnEip0lVrtKhsVMmbeXUs+qUyt5l3rdIkfD0qQAzODzNxbOpu+CRxr0Pr2wtRlfrNBDY54pPvDPORXslm5XEU+oruSURYJkoXK9nvuEh5Bq4piY0iAjtVBnMBmcs1GuJbIoQBNbfE77Y4fy0xWlNtPcWUcV98RTUFg/M43HEj+jz4M6lncioABrI7V46/IB9dUe1i6L40D/7F0m7GLeJ4hk6D5byC/iCamf5CWUIRbbgP195O1yM36xgpWAbQzhmQh+56Om6SpeNnH4cP0ym9CszPOKl5+hXV0NXxIb3QxF1q2pcbnA/QXuu2ccIEIasqgVrnkxW2rlISUmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MQG5F380bs5dNm8G1TDnJ+4QZ5S3hkHgqAJcpNYeKvQ=;
 b=YGs6xZDUKCCUUSXwKWqaX5TykzrgId0zlDZ1refrCVcYgYV3q08lf7lLjvey6L+C/RbsaSIPjpzklf6ZcjnSO/3sCJ6WyfsFshR6cer9IRVrqI6D57o5r4v/EmeWSwZLaWAD4sWupU3x5cv25p7E0UdfwG1tE0XqqbvBxnK3eUs=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6702.eurprd04.prod.outlook.com (2603:10a6:803:123::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 16 Mar
 2021 16:22:36 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f0c0:cb99:d153:e39b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f0c0:cb99:d153:e39b%7]) with mapi id 15.20.3933.032; Tue, 16 Mar 2021
 16:22:36 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     Sasha Levin <sashal@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Christian Eggers <ceggers@arri.de>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH 5.10 113/290] net: dsa: implement a central TX
 reallocation procedure
Thread-Topic: [PATCH 5.10 113/290] net: dsa: implement a central TX
 reallocation procedure
Thread-Index: AQHXGaN2cgk//PsOv0majfm9qALwkKqFdyuAgACk4wCAAIhOgIAAJKWAgAAE3gA=
Date:   Tue, 16 Mar 2021 16:22:36 +0000
Message-ID: <20210316162236.vmvulf3wlmtowdvf@skbuf>
References: <20210315135541.921894249@linuxfoundation.org>
 <20210315135545.737069480@linuxfoundation.org>
 <20210315195601.auhfy5uafjafgczs@skbuf> <YFBGIt2jRQLmjtln@kroah.com>
 <YFC4eVripXbAw2cG@sashalap> <YFDXNxW9w25n/51o@kroah.com>
In-Reply-To: <YFDXNxW9w25n/51o@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=nxp.com;
x-originating-ip: [5.12.16.165]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 56529899-83d5-4f84-5378-08d8e897b640
x-ms-traffictypediagnostic: VE1PR04MB6702:
x-microsoft-antispam-prvs: <VE1PR04MB6702ED005073569801EB3CBEE06B9@VE1PR04MB6702.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WrTNbI6np11n5BiBKFmje0uk//Y8MuciPDp4kSnqy6t0LF5UV8Jih8mkaQYl9zlQd6PUhaA22fKGq0ry+UwZLALnYEliHjc77f0EOhE+CmFWYZRGgAfprgbaU6UUsmWSujfBI6bReN1+rodcR+1TMAr5q1Y5z7IDQSgQfHla/4qIr0hCrmdssHYJA6JntsNDr8FVMekzyc4thCWDaKQYgpdp4pwmeY6G3y9/JYirQGqvspa2oaR/DJEAX4jj5tLqENJ+kv+uJ8DxduRZeZTclUMrFmZJnkeCqQDjy97eTq4mNXOfa3SpkYwYRr0SfbrrIdg/a1WCdIracSZiCuynjQZp65OPtXfxHfdZVW10t9QdJ1zvz29KXztjkSJV+wD/453ttefDDlmH1CCV18pr3R7y3iwRqoFQuVaLyBOO08tRUuLvQD71b/l/khtSJeGHLXSDpnndUGWC8aZltSSeA87/XfBxCQo0D9iJHikXpmzHp1uIwXe9yI0/C8YMxkZwO/PdLTIxIyKPZtnS07DqRYZe2ABa6VssWVXuca7QVVsBq/LdtZC6ZqngGhFy+Ex0xx6HBIfRLoikjVLSHZSSpw8BtoWwcSevavmT+aIUK3oPp4zl++/38ArCM5PNNkAHUZ/dd83PZi1SGQNr4opTjA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(136003)(39860400002)(396003)(376002)(366004)(346002)(1076003)(4326008)(6486002)(76116006)(186003)(66446008)(6512007)(8936002)(5660300002)(26005)(478600001)(9686003)(71200400001)(8676002)(7416002)(66556008)(6916009)(66946007)(6506007)(86362001)(64756008)(966005)(44832011)(2906002)(33716001)(316002)(54906003)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?NOBloBpiG/d701o9HH2VVC9G2wwszh9xoY2oQuHrXySsAnjvIQ5zpUPnqY/q?=
 =?us-ascii?Q?7uiGFC5V4JaDcb78P4YWecPNQlRB80UJYQDBlaZohSOp0y822j8DDY81zdj2?=
 =?us-ascii?Q?x2Ir48X8x0kxNsw0DV399/ODvU2wTVfllD1P813qn7MMbsQ2ZnXXtBigRdpb?=
 =?us-ascii?Q?z+39hwOMyVCdhe+wiiJy3+cLLap22mmVoTyTx/lIa5oxZz3Od1iw/53ryC82?=
 =?us-ascii?Q?tMYJLCvgNwW4GdUGHm8UqzQ1HMH6oL3Hi4rZHgFiV1T+WET/EDrWj639uqLe?=
 =?us-ascii?Q?nzmxTtMB1H5KxglNWwLdzvPlXOWUv09oJDtpNg+VqWgNahmoWfuYdk0tmwSJ?=
 =?us-ascii?Q?XTqpS2GY/fbWga33M0k0MBrnCbPEU4lbDQaey2ZrDJEr6OZn+ZncngYb2pnl?=
 =?us-ascii?Q?+nOqN2J2tO3kAQZGcTO2SRNMaXo7b7nvpLZ3ZB/6VRLO/+PW4bFxPiUZXpnI?=
 =?us-ascii?Q?+KF0zjeZMpGKyrY2d31/YNr/2QTxDX1kD5BsXTNukBHNg9++b18nJhGC8E43?=
 =?us-ascii?Q?iQzci+hMQmATGsMlNLnA5JPEvlKoJTWaYua0bHzcMPiDzaWmIDQ4A/byFz/b?=
 =?us-ascii?Q?la4cxa57SNn+WVUDGhPCvHLsAZiNVGxQ+wf60kJTqtqWTHLKXj3EF1INGKNP?=
 =?us-ascii?Q?s0ePtYJopZXR6kEdmo/6G9QI+3i29GCm8/tI9wNe/0ndZ07WQPVXI6ZEtghe?=
 =?us-ascii?Q?pVxZ9VofVmHwMMvWv/I5HPYO99sFsB6CYzi1H1HM6GPNLfp7y7nziLC6+1we?=
 =?us-ascii?Q?Z/qu4ZOSVZnacfQv2K2YbuvMY4sGU8pNzaIyVjzMUmEXbUNiXjOkDvANtErU?=
 =?us-ascii?Q?rExU5/MNtp+iq0XjaR2cujwtTqa3fMRBOOqvLNKiWcVGC4dVLU5eTrbqm1ce?=
 =?us-ascii?Q?aJGmu913CK6R3mPdh7xgxZMgTTFHoa5TKzeRhgUzY+KaMI4X3tXlMJD/LLCW?=
 =?us-ascii?Q?+7u9Sb82AneQ11KLXuhZ7KQ2C9lRKdrIZwlpmAr1hDs7llKGSRDUz1Vr4Ily?=
 =?us-ascii?Q?qe8jSs/KK9GAWar+aawqjwSXWTdXMZ4ZoagmeWnVRW9YhITk3t+hXzq34Eoa?=
 =?us-ascii?Q?B3kiLTq0icb2J2RzJq86n6d+QYv6uCxhlMqv38XInI3Q/96bwEaeeTWf7YJ+?=
 =?us-ascii?Q?Yggitb//JP5d7v7voiPG3rIWA6ZtzHRy+fubd3L7dvlHD0i2CFC4MMCkCbS7?=
 =?us-ascii?Q?5BytfHisfVetT851//mZDL5Wuqf/TOd2DOqLwdzGc4R7ldu0lvEtWunoVzqe?=
 =?us-ascii?Q?VeN9d9oMEmB8kJVs4q4LEm4bwI8HhqTSA3KK3yRizPx23PhhxDCHo5ZAUAqy?=
 =?us-ascii?Q?adyx13epFy5M0dPl+YRuByWb?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EEBDD465BF5A8A4A965E43091224921D@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56529899-83d5-4f84-5378-08d8e897b640
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2021 16:22:36.6540
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MX9NSo2EBkyv3jOiDpiAFPDRwkOc5Xrx5qpms/RzivNwBZwc/rIWkQkJBcv/6MSAxLU3E5bAaUwtyE4wdNZ+KQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6702
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 16, 2021 at 05:05:11PM +0100, gregkh@linuxfoundation.org wrote:
> On Tue, Mar 16, 2021 at 09:54:01AM -0400, Sasha Levin wrote:
> > On Tue, Mar 16, 2021 at 06:46:10AM +0100, gregkh@linuxfoundation.org wr=
ote:
> > > On Mon, Mar 15, 2021 at 07:56:02PM +0000, Vladimir Oltean wrote:
> > > > +Andrew, Vivien,
> > > >=20
> > > > On Mon, Mar 15, 2021 at 02:53:26PM +0100, gregkh@linuxfoundation.or=
g wrote:
> > > > > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > >
> > > > > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > > >
> > > > > [ Upstream commit a3b0b6479700a5b0af2c631cb2ec0fb7a0d978f2 ]
> > > > >
> > > > > At the moment, taggers are left with the task of ensuring that th=
e skb
> > > > > headers are writable (which they aren't, if the frames were clone=
d for
> > > > > TX timestamping, for flooding by the bridge, etc), and that there=
 is
> > > > > enough space in the skb data area for the DSA tag to be pushed.
> > > > >
> > > > > Moreover, the life of tail taggers is even harder, because they n=
eed to
> > > > > ensure that short frames have enough padding, a problem that norm=
al
> > > > > taggers don't have.
> > > > >
> > > > > The principle of the DSA framework is that everything except for =
the
> > > > > most intimate hardware specifics (like in this case, the actual p=
acking
> > > > > of the DSA tag bits) should be done inside the core, to avoid hav=
ing
> > > > > code paths that are very rarely tested.
> > > > >
> > > > > So provide a TX reallocation procedure that should cover the know=
n needs
> > > > > of DSA today.
> > > > >
> > > > > Note that this patch also gives the network stack a good hint abo=
ut the
> > > > > headroom/tailroom it's going to need. Up till now it wasn't doing=
 that.
> > > > > So the reallocation procedure should really be there only for the
> > > > > exceptional cases, and for cloned packets which need to be unshar=
ed.
> > > > >
> > > > > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > > > Tested-by: Christian Eggers <ceggers@arri.de> # For tail taggers =
only
> > > > > Tested-by: Kurt Kanzenbach <kurt@linutronix.de>
> > > > > Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> > > > > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > > > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > > > ---
> > > >=20
> > > > For context, Sasha explains here:
> > > > https://www.spinics.net/lists/stable-commits/msg190151.html
> > > > (the conversation is somewhat truncated, unfortunately, because
> > > > stable-commits@vger.kernel.org ate my replies)
> > > > that 13 patches were backported to get the unrelated commit 9200f51=
5c41f
> > > > ("net: dsa: tag_mtk: fix 802.1ad VLAN egress") to apply cleanly wit=
h git-am.
> > > >=20
> > > > I am not strictly against this, even though I would have liked to k=
now
> > > > that the maintainers were explicitly informed about it.
> > > >=20
> > > > Greg, could you make your stable backporting emails include the out=
put
> > > > of ./get_maintainer.pl into the list of recipients? Thanks.
> > >=20
> > > I cc: everyone on the signed-off-by list on the patch, why would we n=
eed
> > > to add more?  A maintainer should always be on that list automaticall=
y.
> >=20
> > Oh, hm, could this be an issue with subsystems that have a shared
> > maintainership model? In that scenario not all maintainers will sign-of=
f
> > on a commit.
>=20
> So a shared maintainer trusts their co-maintainer for reviewing patches
> for Linus's tree and all future kernels, but NOT into an old backported
> stable tree?  I doubt that, trust should be the same for both.

Greg, the problem is that we have the following maintainership layout:

General networking maintainers (David Miller && Jakub Kicinski)
-> DSA framework maintainers
   -> DSA hardware driver maintainers

But there is a single tree with mandatory sign-off from a single
maintainer, and that would be David or Jakub. And in rare cases it may
happen for patches to get accepted without the written ACK of any of the
sub-maintainers.

If the question is whether I trust David or Jakub to pay attention on
why are 13 patches that don't fix anything being backported to stable,
and then take the time to check/test whether anything is going to be
broken in subtle ways because code was backported in places it was never
meant to belong, then yeah, sorry, but no.

In this case, things could have gone a lot worse: the model you're
following makes it possible to backport a breaking change into a
subsystem and the maintainer can never find out until there'a a bug
report.=
