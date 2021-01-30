Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA1453096BC
	for <lists+stable@lfdr.de>; Sat, 30 Jan 2021 17:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231386AbhA3QZ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Jan 2021 11:25:57 -0500
Received: from mail-vi1eur05on2119.outbound.protection.outlook.com ([40.107.21.119]:30305
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231394AbhA3Ogz (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 30 Jan 2021 09:36:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NzMWTkxLrkiC3d8Q8/aTzl4MMv6hucpMFplXusYwNggXTpH+8+2CKPqOF5dEvls48riDd97We+/oOj1AaNwUJRH/92JyyaRmrsm4Ka7GaIx6SZdmiZ/1CeDCRCbtehfgwZC+P9k+PeKlgZ3960Ab5xMVui5n4JN9tE3CcrQei/lyzpNOFI4GSpdkUKP73orm/5ODQAhCMhdhdovnIDygJTlnOaY4WVYczD+DaEedJ44on9lXl05wN5j1oOHo5fGgFWXhBis6O8Khi4EjO1Y6FhfnaCaf9A6so2HUfIJePlo5nbUGfZMjp2H5bfHMqsvy1AulTOgznYP1+kfYhTSsgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YRZUeqSyKjUVAMbC9EnBVD06J5pPCNa6Ry/HrvZEvA4=;
 b=VL5zulM2SVUPU1Kb+5+y55sVFAZHazWXzqEKNShGbnCGDQPs59MWn+f9qXSoHkzP61KG/+UaWIl8MjivHxE6JZ/5kfCGgJTYqeRqFsSzGlKJICN4HnCAX4RSsqXQg/9iG99GxL9NwQQv/TMgRxmVyY2FyFO72L4ajQjc5Mfk4L14ZG3L3mkx58eQ8Fydyj0sgOpZSNiHFlRiQQtcAOrYs3s4N8zjc7S15XfzeVTbTII2BWAxbahRhkAYxooyCq6hLToZkyIOT2qDE5xn8CTA9BhzMhYXh7fvMnBpnDXHD82TioeLD6yJQexnnGjmyeVYLJks/DgfustN6U3S6DBW4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YRZUeqSyKjUVAMbC9EnBVD06J5pPCNa6Ry/HrvZEvA4=;
 b=HFl4lebcaNHZcpAsTGk+gNZtQBsvMT/Fiw1q5Q3yOSklDM6ZdLxfgyvyPf6qoT0qlLjGRiRD6+9dzO8GtdJ4agLdDgnD4C+Cs31gLs+JCeQaaIDvtRtdHSB9MEHQJ6f+pZB9GppgOv2IEHPFhSGpOSTA96QqvCQisL7tjtqZYUQ=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM9PR10MB4434.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:273::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Sat, 30 Jan
 2021 14:35:54 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::58b2:6a2a:b8f9:bc1a]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::58b2:6a2a:b8f9:bc1a%3]) with mapi id 15.20.3784.021; Sat, 30 Jan 2021
 14:35:54 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Mark Brown <broonie@kernel.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        stable@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] spi: fsl: invert spisel_boot signal on MPC8309
Date:   Sat, 30 Jan 2021 15:35:45 +0100
Message-Id: <20210130143545.505613-1-rasmus.villemoes@prevas.dk>
X-Mailer: git-send-email 2.23.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM6P194CA0034.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:90::47) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prevas-ravi.prevas.se (5.186.115.188) by AM6P194CA0034.EURP194.PROD.OUTLOOK.COM (2603:10a6:209:90::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Sat, 30 Jan 2021 14:35:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ecb73bbd-d2bb-474d-1b01-08d8c52c594a
X-MS-TrafficTypeDiagnostic: AM9PR10MB4434:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM9PR10MB44349F6AFA2373016FF476CB93B89@AM9PR10MB4434.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kCI/uOpfq4SD+UGOFK+waTys5Rv0ACNojBMU/aoCk+73O09IvTM+Mx8TfGilnehy0NxLdpNnMcnM/tC62XrVblxFlPvcCymSBAFaxRvve+n6ATcD6ZVqSf/LfszeAY9N9L6M5U05Ua+ExdahUAbz0oNxvUFDQMWKlhKm1oCY24rmIdfNwMaxaAmvA1g1Iqq4x9oyN/d+SJBaikrNK7/kdBFptpTNIzF+MRhS4f28fEcfSjbwhH2VrEyyDKtXFgA97wolgwtUrib5qg0Pn5Q7FN7H9O1epLroEOz1Fn1HypOtE/oyX0Jxlz4XyrpKzA/528fXwwIPQAtVJfIocRH5m5iVrGMh5OMzSdvyiogxyQfugBbVYk6YeybMESka+eb3gqzp5GL6NAEryUpeYoqh9HWmSXO5fVsk8sq5+mbyFDvQdhocFvZN1Bji65+5F4R/dCdkZZvgDulDt5iGnSemJy3QvjxhqvDlPLSOVKyqFLopsqwxEdjeqalvhA3YfsgaEiWsf2Q/7SSQLuI5TB3CCw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39830400003)(136003)(366004)(396003)(346002)(376002)(2616005)(956004)(110136005)(44832011)(86362001)(16526019)(186003)(26005)(8936002)(478600001)(52116002)(5660300002)(316002)(6506007)(4326008)(6486002)(1076003)(6512007)(83380400001)(8676002)(8976002)(66556008)(66476007)(66946007)(36756003)(2906002)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?m+qWT2iw6mFZ7OevyzvHuSBsP8QmHrbkylcP1T+BaCN7NahjvXYTC7dAx8Qs?=
 =?us-ascii?Q?tGYqk9d86kYkgnt8gkChPcEgZCI6GzK4WaoIqcQa27SSsoufnck90CRnEK+b?=
 =?us-ascii?Q?+M2FLB7Yi6GTlTySDTfABw4F0dO4LbFtApRduZ3mZvThfklJ5bT/Spg9dCo+?=
 =?us-ascii?Q?BeYC7GYVPi0jyI67aXKWC0760zci0JIT+CkQYfhh9xbxq+ghm1maCHx0IN/b?=
 =?us-ascii?Q?3MqVdmJTtznxQ+Mx3FbH7Gl5E8G5J+/wrLLXj3yWdCBO0rZb21w7Uu+R/ns4?=
 =?us-ascii?Q?kHxL+C8E8nkB8J9kZBlafB+DN+9KTVp1fBMcXRARkH7PrgrNgCygeWqZ/RG4?=
 =?us-ascii?Q?8827HQx/3Qh1/86m6RO4yzaqTp+mREV5oknBv3iBJQ6WT0Ar7XjFyJA5trW5?=
 =?us-ascii?Q?1+NDX1teEHqEZjPg9uKq6JsCHs8uvwy3C9DTDoafev/H5HqJI1QFNz35u1sa?=
 =?us-ascii?Q?G3StSbgN4jZFSddNLxHcrX/9uXHkmEfylq3yHWVYN3bc5B3DptC8XBUQ2l5/?=
 =?us-ascii?Q?L34ETgQ6LbZ/UXTtgIMVJwGTDHXgH4gFoy7NAQFOrWBAQex91kShZEyEmhai?=
 =?us-ascii?Q?dpWnKA5SCZfzPZX4Sbiz5tg5r+paQSgRXTyPRX+mrxwZ/tKWupX7Y8opmf68?=
 =?us-ascii?Q?BmOkeY0EWHCMTxL3wr2/40EUtQm+ILemCqtFFN6zAmzvxuCkXesrTsw+Vi6p?=
 =?us-ascii?Q?5NJNWGn9vDx71F2i6Us74Fparhu6L6f6d2oP+xh59VKOqF8/LRNazlfxqJit?=
 =?us-ascii?Q?IvlIm5ouQAiRk3wH8YigngNipmvzMKKiru3K3tXMH8e3U5WJK/q6FwqWu3w9?=
 =?us-ascii?Q?Sg1FGtSgBgkSdDzt9qoqNrtlbqHzybG6MK0gfrKCdBIU9VJ1Btt6Vrgi8Xxi?=
 =?us-ascii?Q?XV7qqvlsrKyEjSQpFBMmDoK8ICkOmGn9K8LCe9WgfxceGDdH/8aFT9oed899?=
 =?us-ascii?Q?pGVhi+MFQSIXPW4LcnrZcFlej+niGtebFizzoUxHOgTWt9Qf6Wtks9fjts+k?=
 =?us-ascii?Q?4voAbYeUS3TagqvvlvWeXLQAndNrL7QO56YzCuPwPsmF/giQ6tEBtRyqmiCf?=
 =?us-ascii?Q?CuIzO1TK?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: ecb73bbd-d2bb-474d-1b01-08d8c52c594a
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2021 14:35:54.2215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i4XG316i3GVFIRA+BAZpHrGAq4RhFEOvrEogJt7PLYH+cOpvMFEHqIABeMFOvZXVEQnN6Cef5E/zFXMZG0vNGvbxabRKGlVUyrKu/6TLOUI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR10MB4434
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 7a2da5d7960a ("spi: fsl: Fix driver breakage when SPI_CS_HIGH
is not set in spi->mode") broke our MPC8309 board by effectively
inverting the boolean value passed to fsl_spi_cs_control. The
SPISEL_BOOT signal is used as chipselect, but it's not a gpio, so
we cannot rely on gpiolib handling the polarity.

Adapt to the new world order by inverting the logic here. This does
assume that the slave sitting at the SPISEL_BOOT is active low, but
should that ever turn out not to be the case, one can create a stub
gpiochip driver controlling a single gpio (or rather, a single "spo",
special-purpose output).

Fixes: 7a2da5d7960a ("spi: fsl: Fix driver breakage when SPI_CS_HIGH is not set in spi->mode")
Cc: stable@vger.kernel.org
Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
---
 drivers/spi/spi-fsl-spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-fsl-spi.c b/drivers/spi/spi-fsl-spi.c
index 6d8e0a05a535..e4a8d203f940 100644
--- a/drivers/spi/spi-fsl-spi.c
+++ b/drivers/spi/spi-fsl-spi.c
@@ -695,7 +695,7 @@ static void fsl_spi_cs_control(struct spi_device *spi, bool on)
 
 		if (WARN_ON_ONCE(!pinfo->immr_spi_cs))
 			return;
-		iowrite32be(on ? SPI_BOOT_SEL_BIT : 0, pinfo->immr_spi_cs);
+		iowrite32be(on ? 0 : SPI_BOOT_SEL_BIT, pinfo->immr_spi_cs);
 	}
 }
 
-- 
2.23.0

