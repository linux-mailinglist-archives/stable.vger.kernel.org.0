Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A07321964A
	for <lists+stable@lfdr.de>; Thu,  9 Jul 2020 04:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726117AbgGICcz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 22:32:55 -0400
Received: from mail-eopbgr20069.outbound.protection.outlook.com ([40.107.2.69]:65352
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726107AbgGICcz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Jul 2020 22:32:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gQb641/GSd64W/VU7gdhmzpb/B9epufio5FUGd0cf1Swa29Hr4RM/xXChMhR/Ew6GbJRnDN41zxcxWrl7knl7tRaBA2IxYgmZd22gy23i6U0q+VlWDZsKSPyw4dDXgPk+OqsLNJrV41re98RKFIfwi3SmIYXAy62+wMW+crZay19hOl9qnGZJKhg4lTnK+1raJqpcej9w60os9tegUSBfntGTTf/oFtXvtOeTKvOPC5V1KfKU7uQk3GKFy6zD0z7FCamhXoMZys3qrdp8EpkR1KlSqpPxd9ZoXtq2Fb9QhpGp2S/EerBeV+qFROfyySKQbSKtniwtKCR43oL/NSaMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bdh38duKL00rPRAJZq68HviiLbFScmTqXEKTooXC4MU=;
 b=ZawwfzPHpQDKddqMdDTCnSjXAxjRDH9YrOoo7EGq0NHmeuMD+Gmg/YrbZzpuqn3LRPSIqZmzmehsktQ8FxPv3lPO0WEq8QWt0PBJ2lVuyYqqiRsbKEIwHCb2ghhXnYXyR1H3AoJgkNqBF58ly3242jZ4wbd+v5el91G2ynw6llWt3lBUGaHeKxbWsEDdrCz4UHA6pJOfVGwkxs06NI6Yat9qPhU8r3Q1wewyCNcrHsherliESOmOuWuX1EoQ9MNRdGFpfZJOeXF3jTXY+W6F2yrXtStmumY18Q6icbSD/Vtb+BTh/+KVuqunBP/oZA7901YQadoFJpcI4pGAGnwlBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bdh38duKL00rPRAJZq68HviiLbFScmTqXEKTooXC4MU=;
 b=n6seP8Cdr/LTzGvXojy1obsIfA0iaopHPA5IZ5RBY2obuUPckIMK+2CmGTpO3iTZZfyr3wxPMav6707MJrsZt7sQexIrQgAk8txvI3oLi6O0vvokf+NoHLNDGE2XzJLSD60TQZkWmOUBrxWOQKmnb3a/rUNNK17AbI9aL11CE0o=
Authentication-Results: lists.freedesktop.org; dkim=none (message not signed)
 header.d=none;lists.freedesktop.org; dmarc=none action=none
 header.from=nxp.com;
Received: from VI1PR04MB3983.eurprd04.prod.outlook.com (2603:10a6:803:4c::16)
 by VI1PR04MB5871.eurprd04.prod.outlook.com (2603:10a6:803:ea::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Thu, 9 Jul
 2020 02:32:52 +0000
Received: from VI1PR04MB3983.eurprd04.prod.outlook.com
 ([fe80::250a:ccb1:b015:3b38]) by VI1PR04MB3983.eurprd04.prod.outlook.com
 ([fe80::250a:ccb1:b015:3b38%5]) with mapi id 15.20.3153.031; Thu, 9 Jul 2020
 02:32:52 +0000
From:   Liu Ying <victor.liu@nxp.com>
To:     dri-devel@lists.freedesktop.org
Cc:     Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>, stable@vger.kernel.org
Subject: [PATCH RESEND] drm/imx: imx-ldb: Disable both channels for split mode in enc->disable()
Date:   Thu,  9 Jul 2020 10:28:52 +0800
Message-Id: <1594261732-16388-1-git-send-email-victor.liu@nxp.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0146.apcprd06.prod.outlook.com
 (2603:1096:1:1f::24) To VI1PR04MB3983.eurprd04.prod.outlook.com
 (2603:10a6:803:4c::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.67) by SG2PR06CA0146.apcprd06.prod.outlook.com (2603:1096:1:1f::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3174.21 via Frontend Transport; Thu, 9 Jul 2020 02:32:49 +0000
X-Mailer: git-send-email 2.7.4
X-Originating-IP: [119.31.174.67]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ac276883-a114-4e77-c601-08d823b060c4
X-MS-TrafficTypeDiagnostic: VI1PR04MB5871:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB5871A6CC5DD053A6E8EB34B198640@VI1PR04MB5871.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YDTwIpqlvCkQWIMXrd/1Id6ftokDkdtAixUGyzxEed5xmWVpqRPMjq6C0nv6JbWRd5+/uuGI6FRA1zBD4GDOBX5ZoUEQuAx5liRLMtYl6HwOH0h6pNrVgTt1S4dO9R/QOAsr34cDAdRb2nXkVQS/XggTf9jjBvD2WSUoYfQUHnStzuzN9nvPK3m9Mjwm9TUUsY2hfTElamrN/9HYSSadjIDrgxqu0E2JTmIjUsS4yHkMQAv+bn9oagj3DEcnJkLMF1Lc0EZapZZoGDKp3Ayz5uf4r13KVWE/reXZn4FD0wT8HqJ7iX30fFmBVrunnix0rlJ2Yc49spNqCa95Ux2rL+DwTfHYgfiyMano8O64pcD0f0oK/ipcgFHuGuEw/T8W
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB3983.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(346002)(396003)(136003)(39860400002)(66946007)(956004)(2616005)(186003)(52116002)(2906002)(26005)(16526019)(6506007)(54906003)(4326008)(86362001)(316002)(478600001)(6486002)(6666004)(6512007)(8936002)(8676002)(6916009)(83380400001)(69590400007)(66556008)(5660300002)(66476007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 4WEhTw9EL40bhzOipaJVOevRyNYzLdiuxlB0Z49+PrhJkJMqS8hwyi2tBeDdsmpg3dufWBLSwx4Tgm4qFZSMLar4UT+Sz073US79ExRw7YlZgjlEPAN7lcVPjeSaCX5ErIweFfWYlmkRVd4PoBWmbCOCl71q3CtQZpgt2MA6GkVXa1wRhKrfyMOqEp/TbFOdKUGPQTKgzUNNSaCxTYxNzZwe3e6EDCGdaHThq0eMxlvb8rbCmvWvptN79OPsHUHHZ60c9++3kdEPRYtFmntaYcXOWG9ycpg2oCOYqX4bUm/Gun5TjzmT01SdC7GttHbraMBR+wmcEx2lnbwf8na5U+xUySh0mE3Y+qU4uaRHxgbKd55vGqVyxjk6mgn0K4uyJWiLW9O3u408M3RqKnRsFKlBmbiN10Gcx4+iEXTr5aF1QnFBplRs8hcTBayyxQPUFAUQef76PNYZtUvU6PdNq3d0+rLHpRUu54c/DHAH6oCkH4snXjIzvEgkMSgzjk+3
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac276883-a114-4e77-c601-08d823b060c4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB3983.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2020 02:32:51.9778
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dz0aGamajT5B8q1LyM32LHsi9/K0Jg9P8kHAIkkSRig79etT/UfLb6NxbowjATMCw8jihpEBmHqsaESWJfoIJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5871
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Both of the two LVDS channels should be disabled for split mode
in the encoder's ->disable() callback, because they are enabled
in the encoder's ->enable() callback.

Fixes: 6556f7f82b9c ("drm: imx: Move imx-drm driver out of staging")
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Pengutronix Kernel Team <kernel@pengutronix.de>
Cc: NXP Linux Team <linux-imx@nxp.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Liu Ying <victor.liu@nxp.com>
---
 drivers/gpu/drm/imx/imx-ldb.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/imx/imx-ldb.c b/drivers/gpu/drm/imx/imx-ldb.c
index 4da22a9..af4d0d8 100644
--- a/drivers/gpu/drm/imx/imx-ldb.c
+++ b/drivers/gpu/drm/imx/imx-ldb.c
@@ -303,18 +303,19 @@ static void imx_ldb_encoder_disable(struct drm_encoder *encoder)
 {
 	struct imx_ldb_channel *imx_ldb_ch = enc_to_imx_ldb_ch(encoder);
 	struct imx_ldb *ldb = imx_ldb_ch->ldb;
+	int dual = ldb->ldb_ctrl & LDB_SPLIT_MODE_EN;
 	int mux, ret;
 
 	drm_panel_disable(imx_ldb_ch->panel);
 
-	if (imx_ldb_ch == &ldb->channel[0])
+	if (imx_ldb_ch == &ldb->channel[0] || dual)
 		ldb->ldb_ctrl &= ~LDB_CH0_MODE_EN_MASK;
-	else if (imx_ldb_ch == &ldb->channel[1])
+	if (imx_ldb_ch == &ldb->channel[1] || dual)
 		ldb->ldb_ctrl &= ~LDB_CH1_MODE_EN_MASK;
 
 	regmap_write(ldb->regmap, IOMUXC_GPR2, ldb->ldb_ctrl);
 
-	if (ldb->ldb_ctrl & LDB_SPLIT_MODE_EN) {
+	if (dual) {
 		clk_disable_unprepare(ldb->clk[0]);
 		clk_disable_unprepare(ldb->clk[1]);
 	}
-- 
2.7.4

