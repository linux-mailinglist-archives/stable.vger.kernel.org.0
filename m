Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E985C1F7229
	for <lists+stable@lfdr.de>; Fri, 12 Jun 2020 04:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbgFLCU1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 22:20:27 -0400
Received: from mail-eopbgr140054.outbound.protection.outlook.com ([40.107.14.54]:1529
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726305AbgFLCU1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jun 2020 22:20:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MuaEIbIZwv9q8G275p29KcRNdXwWk8qXP1xXKwVMFieMYJmRotY8fo7kcHPOA/lcObgP7yge9XsU6gbGRUHo31J5a3dvkfnovjSWZy3jIZpi3j9Y12ESL4W+NW7J4+KQvc/BN2sn435RyTsiTMA/AwjNC59SB0uv+UntvlAyDYtei4BxNYmxdrk4IMvzGGbFtUGRi9u/jxiPG9/QmNKg3zAttPXdAFgQTO3lAMY8bP5kTNQHq3QCSSTaHhOZ5bZxVRDNU3J9agqk+X8TGoZTITvFnVQ4QqwCwqh5MRVpukQ/uQsPfEUoBB8XSpstLtP2sgfSya6Kj0hXBQ/kHuUtQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rqL1/6L2dZocGGnJXwRmXodAiDDCtcA4wR0Eko6VDXs=;
 b=XI92biUohEpLcBjwafcDy06moAd7HlkHYh23awPQOrX0EwPUVaZQjTUckGj4hLlT9QBRcGkMubuPgmmQg9sbkg/mj/Ed/OhfEvVSyeYMUbJXWiLlj0Ge2JZ07jtRiZCI+MU7yjMs/s7nEaGFdmPehiKE/XZk5mYT//ByxN/BB1BFeYGYIxv6rzTCg4Pdh18G2mepyzVy73lrrKE5K+K0YNppO010+3gVg5nOIkLLrX9s7r1KhWnVgP8HPRYWo8bi1SCgSW9PfzqJlFaccRHl7uOjgYZRSJgCZgLfzK4tRGfYzYCKjLg5xNFuKVcY/cAdGWRQbr3/PVh9ex+UGh3/pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rqL1/6L2dZocGGnJXwRmXodAiDDCtcA4wR0Eko6VDXs=;
 b=Io552wD3rVq3qDcnylNnVUMAC0TggTu+Clo3K1rZ6K9LxS8wDiwdTl78IBk1qDXH/xuRZwCOSDQE1X6BCjvpgBjRY3DkrtMZqceLQmq983DScXHSvoALkpksXRXge8J4yVs3HBJggwjs3fnT4fE+UuZo+nSQOZpwg5O+TVyc9UQ=
Received: from VE1PR04MB6638.eurprd04.prod.outlook.com (2603:10a6:803:119::15)
 by VE1PR04MB6352.eurprd04.prod.outlook.com (2603:10a6:803:129::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.20; Fri, 12 Jun
 2020 02:20:23 +0000
Received: from VE1PR04MB6638.eurprd04.prod.outlook.com
 ([fe80::5cc4:23a5:ca17:da7d]) by VE1PR04MB6638.eurprd04.prod.outlook.com
 ([fe80::5cc4:23a5:ca17:da7d%6]) with mapi id 15.20.3066.023; Fri, 12 Jun 2020
 02:20:23 +0000
From:   Robin Gong <yibin.gong@nxp.com>
To:     Krzysztof Kozlowski <krzk@kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Angelo Dureghello <angelo@sysam.it>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Peng Ma <peng.ma@nxp.com>, Fabio Estevam <festevam@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] dmaengine: mcf-edma: Fix NULL pointer exception in
 mcf_edma_tx_handler
Thread-Topic: [PATCH] dmaengine: mcf-edma: Fix NULL pointer exception in
 mcf_edma_tx_handler
Thread-Index: AQHWP/NB2exjiYlMX0OoWLZ0jRl7cqjUP9EA
Date:   Fri, 12 Jun 2020 02:20:23 +0000
Message-ID: <VE1PR04MB6638DCDB48DF10410C983A0A89810@VE1PR04MB6638.eurprd04.prod.outlook.com>
References: <1591877861-28156-2-git-send-email-krzk@kernel.org>
 <1591881665-25592-1-git-send-email-krzk@kernel.org>
In-Reply-To: <1591881665-25592-1-git-send-email-krzk@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6dcade02-7c75-43c2-0953-08d80e7729b2
x-ms-traffictypediagnostic: VE1PR04MB6352:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB6352BB21FF790CC30556711889810@VE1PR04MB6352.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0432A04947
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UkpHv2n073X/ejG79Oy3E6VDm0MQTYftXmm/SbnRqBOML2WNZoO/pW3cmuEFCpRE75eFe9m7irku53EqU54f2nFfX7bR2Q2WY5osw535RnVegwfU9cs/lssIXtQXd5zbAPdXFtPteQVcaqMhFYRVF4Nphh/qkxoz7edzs6tZu5CIjSt7UdUwcV/2LFniwRJBTyUhf7Y7UuBaB0cLeUGMG4GmTSD21FvziITaHB/tbDLXAVLIuBu8lbwKygdhxFDhLsgkXF6Hn+iTYT75EMYOaiSglReO6AeL1Xxr1K0KRSjq1zznPj+X8nNPMYL+Wy7K6x2tS2Www+PNtmbNSdWtFA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6638.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(39860400002)(366004)(136003)(396003)(376002)(186003)(26005)(4326008)(83380400001)(86362001)(8936002)(52536014)(8676002)(478600001)(66556008)(5660300002)(316002)(110136005)(2906002)(66446008)(66946007)(55016002)(54906003)(76116006)(33656002)(7696005)(71200400001)(6506007)(64756008)(66476007)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: zuVVa60j9Q4cUMO+drG4PwvQiPeKiTg7PYUJ11LBMRm5ntosv9EENawLXx8AaAbxYtQ9fElkENsirrMfO98pyZfgMO9AkJcr/pi+LTuTqKrxYIG7lw8WK/dkZIo+NVzdXdz+4Mjp9deNBp3LrBUBRusEYr9qNrIOcqD7MAHgLCf2a/gZJdi0Hg+URSzVMXQaegBaj4lXTT+YTmx9mO99nQ8xHe5VJGRaUIWNe5nAFq/kjVrCMC57aAAQLMe/BhZFSZfPXtpts0zzqdaXT6UNLV7G6JmylPP9z4YMEujyb0RxCxWE1BL0Ew8N8/eemPtdukvDmwtaJ9jBdDzR8oMUdGt+Gm2rbc0T/wucxwPWDbYDVibU69uor9mVBM4iwGMbYTF4Qf8CWtUFFeEiaeOIQ68G81ck9h9h9NKs9ET4t6nWHVzluJl9iTiuifLNbn2jDCwjmtRMHif5Ng00i1HqO7LTrFajr3rhw1ggDXNIB/s=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dcade02-7c75-43c2-0953-08d80e7729b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2020 02:20:23.4786
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g1SuwCW7ubXaxuVbK2stBYLNIg5ZY06YB05jltZ4KvN9R7nMufI0CWf8crIRx+a31lG2VvmiK/ftmlQbcKo7HA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6352
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020/06/11 Krzysztof Kozlowski <krzk@kernel.org> wrote:
> On Toradex Colibri VF50 (Vybrid VF5xx) with fsl-edma driver NULL pointer
> exception happens occasionally on serial output initiated by login timeou=
t.
>=20
> This was reproduced only if kernel was built with significant debugging o=
ptions
> and EDMA driver is used with serial console.
>=20
> Issue looks like a race condition between interrupt handler
> fsl_edma_tx_handler() (called as a result of fsl_edma_xfer_desc()) and
> terminating the transfer with fsl_edma_terminate_all().
>=20
> The fsl_edma_tx_handler() handles interrupt for a transfer with already f=
reed
> edesc and idle=3D=3Dtrue.
>=20
> The mcf-edma driver shares design and lot of code with fsl-edma.  It look=
s like
> being affected by same problem.  Fix this pattern the same way as fix for
> fsl-edma driver.
>=20
> Fixes: e7a3ff92eaf1 ("dmaengine: fsl-edma: add ColdFire mcf5441x edma
> support")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Reviewed-by: Robin Gong <yibin.gong@nxp.com>
>=20
> ---
>=20
> Not tested on HW.
> ---
>  drivers/dma/mcf-edma.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>=20
> diff --git a/drivers/dma/mcf-edma.c b/drivers/dma/mcf-edma.c index
> e15bd15a9ef6..e12b754e6398 100644
> --- a/drivers/dma/mcf-edma.c
> +++ b/drivers/dma/mcf-edma.c
> @@ -35,6 +35,13 @@ static irqreturn_t mcf_edma_tx_handler(int irq, void
> *dev_id)
>  			mcf_chan =3D &mcf_edma->chans[ch];
>=20
>  			spin_lock(&mcf_chan->vchan.lock);
> +
> +			if (!mcf_chan->edesc) {
> +				/* terminate_all called before */
> +				spin_unlock(&mcf_chan->vchan.lock);
> +				continue;
> +			}
> +
>  			if (!mcf_chan->edesc->iscyclic) {
>  				list_del(&mcf_chan->edesc->vdesc.node);
>  				vchan_cookie_complete(&mcf_chan->edesc->vdesc);
> --
> 2.7.4

