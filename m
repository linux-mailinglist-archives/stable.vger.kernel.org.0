Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4BEC33C732
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 20:56:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233829AbhCOT4J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 15:56:09 -0400
Received: from mail-am6eur05on2057.outbound.protection.outlook.com ([40.107.22.57]:52512
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231510AbhCOT4F (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 15:56:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YvkDWQ7+zNBtrP4Bg960sRoPQDfSzVQiiwfizyuZM/Bmy+tbAznQyXFGPlfFipor4B5F7F2ZLL/ZPqzcVJSVIpNdh7epf2BHDE39BL0mAtGUZlbgDxeFFGd87x4xtxHvNn64j/7hAwMiy+Ggot9Gj6GS9wQRr3R9ROmqZKhdhju4flJQEJunY52eD7G8vanQHE5d22vj7IyIznOSJGAJlwSv9d8wOEbPy4/lGejGOCVI3hAShaBwGQQ1msKIwDHRt3qsx0UqMLpoVtmn+69XGO8h4qosv5y+IMtt8ydA1dp0w6o3uUO2BGJNOnRQGWDrL9jvFSIZWCGTU3PeHDhIqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/qlicRlmXprNJ3J3fEuy8spECQXZ0yQjtlKsQK4z5kM=;
 b=Kqofy8s7qPC+Mxv9lNF7CFZWEP49C7kIKCZlI7qznHHmdiwRsO2A5T5kZtDO4dG3hQNaqZN4Y4n645Oy0CVDViW+O2yO5yThvK/JTcQ43VOCdFz4WMpijZh/4fuZ7+CrkdiPoEjv/oqCQtNhR2Vn713hx9eM9UfZ3wVtIKcbdIONa25FHmdLCWQTUI3MIDyLVaoFl8eNsZILdcjMBjvfqh/98UG+Dz3WO0v1yNnMgMmUGfp/H+6WDF2sT37C2ht8EeeRZY/6TevFVWePfpbUPOjYCpXAzDwgYcA6XPM+++ZSxb6/THbSGAggWIc7RxNwmA6nbrO6aReAERaxVDZ3PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/qlicRlmXprNJ3J3fEuy8spECQXZ0yQjtlKsQK4z5kM=;
 b=QE8d+KSbQjdpPt8sLOSk3giTQ71XaPl8Faxk++TrJ4vVZD9q/tg34BLWLv/CHbkInPFq9siswTmGaaT3zpqZDlcjxCgdKdIoVXCUUqBka9EJYhoSPlypG2Tq1oDbn7mzGqZ4vfRms6qL9tp09RsTtXBUqHLwgqKDy5e6XOiYKLU=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6125.eurprd04.prod.outlook.com (2603:10a6:803:f9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Mon, 15 Mar
 2021 19:56:03 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f0c0:cb99:d153:e39b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f0c0:cb99:d153:e39b%7]) with mapi id 15.20.3933.032; Mon, 15 Mar 2021
 19:56:02 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Christian Eggers <ceggers@arri.de>
Subject: Re: [PATCH 5.10 113/290] net: dsa: implement a central TX
 reallocation procedure
Thread-Topic: [PATCH 5.10 113/290] net: dsa: implement a central TX
 reallocation procedure
Thread-Index: AQHXGaN2cgk//PsOv0majfm9qALwkKqFdyuA
Date:   Mon, 15 Mar 2021 19:56:02 +0000
Message-ID: <20210315195601.auhfy5uafjafgczs@skbuf>
References: <20210315135541.921894249@linuxfoundation.org>
 <20210315135545.737069480@linuxfoundation.org>
In-Reply-To: <20210315135545.737069480@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=nxp.com;
x-originating-ip: [188.25.219.167]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b45f6d9c-9ee3-42b2-44ce-08d8e7ec5ce7
x-ms-traffictypediagnostic: VI1PR04MB6125:
x-microsoft-antispam-prvs: <VI1PR04MB61257C35AB429259ED32CA4CE06C9@VI1PR04MB6125.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 92s0hE/5aKSFxNE7YCSTxxqFSHJpHQ3uQd87Awj+9wqJs8MmwFgKPgDoeQOcd6l6gp5QO0q+t+F0zc7coc6MsR+qd429+y/3NfFrdmUXxLGFiLnSAoQR2sVhLFGCuJRPXKIs3QbpK73RA5dbEQKdzdk+nB3Ymu/d7ef9B8VfaD844+tjFsvRYfoqt3+G0TkMJbL5nZt6gJk4P/Z5YPQLJd1+TDELNM1W+BT4+rBBKweYZv9C6mV/xHZ59wYVta562bwmMxMchqzofyzqmVvl+IfHlmPVwIYcgvw0o/U7KasxOraubignwz4CEkAsMat1SFavdEjMAacUeSjIh6a8xQUjAP51x0gaL4gp6vEmhocTaJfT0OLh/HO/n+CxV7/skU8DOVon82vR/6Foqh+GtLCm8AQka/Q8jSRYmFhsvSyvnwWTmGqrYvdl1c+l4sOj87wAjydcRKXmfK/kOA2GENT0/aDa6DeKoGuKPF3uC3PL3ZpQ8FiobactM/dJyLHmMLswVQKL+WB35tVjnyWPv7l1ypPDbPNlx3rFyAbxKunVsXpOSkMPOM7SuYZu+Ps9m8bhE4ECJwWoQxa1xVlNmPlPYiGkE1kQt2ZVo/b9Wpdzlgauhx8WMetQi5x23ZWkZ4fqBe5HzU0dxsrkqac6+Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(136003)(346002)(396003)(39860400002)(366004)(376002)(966005)(6486002)(7416002)(86362001)(54906003)(76116006)(8676002)(8936002)(110136005)(44832011)(33716001)(6506007)(66446008)(478600001)(66556008)(316002)(5660300002)(26005)(2906002)(1076003)(91956017)(6512007)(66946007)(71200400001)(9686003)(186003)(66476007)(64756008)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?IqAFrQxxzIXwuvMf1vrcscmroCVNUelpSzDlbz/4MukPHiCYTbrqCSzhJwGY?=
 =?us-ascii?Q?pVVClW28errFe0Wn2TpK1/bXB41DfhBwiRQml8mg6HfLTnB/HH4dUV8kCH/b?=
 =?us-ascii?Q?439Y/AHeDcaF4xF+5P/n42QYPSaQNPA5yseNlI3oJ5wvRfXfIfjueoXTlvLw?=
 =?us-ascii?Q?JZ5poSnV704eLbydBppLXKel/BlBTHdJBZ9g5om+C/5I8zJGBs2YuvCULxPf?=
 =?us-ascii?Q?WZqKI11PEM1TOQVD0sgfv8l/oOP9TFpllZ99P7BtxAcXRGAGhY522epxffba?=
 =?us-ascii?Q?fi39Iz3GoadDMIABSxJX/DRFPfviao0XGfCneVDlDJtZRQZX2kE2L0JZ1o2o?=
 =?us-ascii?Q?s8+qPDu7lhRyyYM/xZRSRahdyT9GB60C3hVDg4iD+32U3vWYY/06jpQcWF+G?=
 =?us-ascii?Q?tb4O1gjWZoMWVIVq466FYmfbIlDKvVE/o2uMu6wF8yi4veOJCrCsUhUDRSYK?=
 =?us-ascii?Q?/zJMunurTtH6Rjp906UW4KPHGYopM/ElooOT8xZdouEBxORZ2LgG+pi9qbtu?=
 =?us-ascii?Q?y2+MezfH1mD7JjI00nEzXwyQvRv7mGGlSNtvX6EZAGVp3LRzAUGoTjO83TV2?=
 =?us-ascii?Q?3J1/LaRQsQzQa7/r+PzBqYKKH0sCKd11gXOYiEJB1BF1L6yUb0fxsvjrzLZH?=
 =?us-ascii?Q?4mgtJrG6tb5qmNWGZjeQIN8F6bvoTVjeM/TYaF7SHkHYBWRyETDyPlszINXz?=
 =?us-ascii?Q?nRd/fjqBixmEGAD8AA38EYECBKFrl6PEepAk5czj/7T1/h1K178rJ7FNbZ2U?=
 =?us-ascii?Q?zobAs0DvRHQeZEG1lY0qk2zTJxB9h2WtPqJRTXDhzPZHOKlg7t/jxFmZnw5D?=
 =?us-ascii?Q?e7ExlY7vAjlrhU2pQS2LACi2a2zu7sRjEPY0868M/HkOGj1mmnVg3DuhIwmA?=
 =?us-ascii?Q?HWb0v+BFNxDvHLAG3ufCoINKY0VN25UJHlFluOmhpdxuPrdVj+wyXxZGiIyC?=
 =?us-ascii?Q?/Ld0+Rs3V71Xy61sTbuqKOCwApX/yYhWgVvTueUJ24nRhuJ/YV4OkuwlGSEQ?=
 =?us-ascii?Q?tu2enlNrJMSxBNnxHpfoEqh6Vt8DYWxzM8k8DlhLLG55kOOjMQTaJzVbs9da?=
 =?us-ascii?Q?a3jPw5Bmxtn4cjBOhjhtBiZhU4wg4t01nPY4+AleEnzIBSr53YKpWWTIvmV/?=
 =?us-ascii?Q?nEDeIryuYIN6ESi/pfS1Wh06nFM/d4kW5w5qXwinOYUc5NG/DutaoH4V3tYi?=
 =?us-ascii?Q?Yma8QZ8bnU0VAbgyzE+8Nfd1M6cdunt5E7tbJ+Nqg5hOF56KAkeFHdvkKzbC?=
 =?us-ascii?Q?AY6mJfka1pHqpFuP+rJw1zsloL9/O7PunkNFUA6nLjl3u0D7zDchKQhyTCQ0?=
 =?us-ascii?Q?9vrquyrNKNtW9KKDxVM2P2fxBZppWfVyz4NpHcP1dE4/Rw=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D7BD0FC74471ED4189A17E79FEA90D2A@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b45f6d9c-9ee3-42b2-44ce-08d8e7ec5ce7
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2021 19:56:02.8384
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OVBz10HYeFbJj07Rktxxdr9COa1KWG/bIxLFWsrC+ugEZ18ZNvo+g5qgQ/norsvSJ4KIYWtdgqzYxJ1DbAe7bA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6125
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

+Andrew, Vivien,

On Mon, Mar 15, 2021 at 02:53:26PM +0100, gregkh@linuxfoundation.org wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> [ Upstream commit a3b0b6479700a5b0af2c631cb2ec0fb7a0d978f2 ]
>
> At the moment, taggers are left with the task of ensuring that the skb
> headers are writable (which they aren't, if the frames were cloned for
> TX timestamping, for flooding by the bridge, etc), and that there is
> enough space in the skb data area for the DSA tag to be pushed.
>
> Moreover, the life of tail taggers is even harder, because they need to
> ensure that short frames have enough padding, a problem that normal
> taggers don't have.
>
> The principle of the DSA framework is that everything except for the
> most intimate hardware specifics (like in this case, the actual packing
> of the DSA tag bits) should be done inside the core, to avoid having
> code paths that are very rarely tested.
>
> So provide a TX reallocation procedure that should cover the known needs
> of DSA today.
>
> Note that this patch also gives the network stack a good hint about the
> headroom/tailroom it's going to need. Up till now it wasn't doing that.
> So the reallocation procedure should really be there only for the
> exceptional cases, and for cloned packets which need to be unshared.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Tested-by: Christian Eggers <ceggers@arri.de> # For tail taggers only
> Tested-by: Kurt Kanzenbach <kurt@linutronix.de>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---

For context, Sasha explains here:
https://www.spinics.net/lists/stable-commits/msg190151.html
(the conversation is somewhat truncated, unfortunately, because
stable-commits@vger.kernel.org ate my replies)
that 13 patches were backported to get the unrelated commit 9200f515c41f
("net: dsa: tag_mtk: fix 802.1ad VLAN egress") to apply cleanly with git-am=
.

I am not strictly against this, even though I would have liked to know
that the maintainers were explicitly informed about it.

Greg, could you make your stable backporting emails include the output
of ./get_maintainer.pl into the list of recipients? Thanks.=
