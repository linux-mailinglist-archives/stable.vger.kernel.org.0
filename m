Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1026E510EBD
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 04:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234440AbiD0CYt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 22:24:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233257AbiD0CYs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 22:24:48 -0400
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2137.outbound.protection.outlook.com [40.107.117.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCC9DBF505;
        Tue, 26 Apr 2022 19:21:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ops0N173Yd/6gq2lvj8N4a7Ky/DJQBKkemIc67CsOUpNwHZnJhxrNVQl4MeAYMjefMf2yZjuTprdf4mTAUovG8c96OFK28o+wTmONmg8pPkgXeOzpLiSfGHCsWdS6We3tfVn/VxV2fgmq46KJ8UGM9QaVrwgHD6WRs9US1an5drfn8qnL4XqlPQgzP4xRtjmsLjJEj/WszIPaNTAVA+GB6+UUVKevLVcM2E/GAkhZBGwCDnaTE9uxLglDdFgX7+9bfwuCRITUyJKPLff0LhcHS4RQIupWrEHC1QFoCFlTHIqcSrGRVPT9CYi9cBSHgCmBhaGOt7mwIDXSkIcBQHkEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+XNQQ04IH/uy79+ONROzeedpDiG0XTf8ztjnX1eAoKo=;
 b=PKi86t0rWs/lMCHjQ6njK21+sDrregmyw0FAEm8zc5m4eKoABf40ze2NrANPXW9aWQwgKjl2trnsiHGFQy0NL0nfft0277bieOiafzFInKYrJUTvUE1tYblMV7wqXj9nJWtE0luqXr13QkaJkIaXiU0NUd08C+OWyhyAC+t9q2bxVn4VsGBc5dnV1jYR8A1dooSMpjxN7AgUOZ40Q63/pFWs68Pw37eCp7koIfEWZb4sv4J6rZYD4+bl2Dqz3fG8mwFlWmnySqORkYwk7Ektwc169yjqYzedCIneeVTPaMJz/4DsZHcmaqGkmB2rcN+zeYC/WnxlJK4HEaPe3hNF7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+XNQQ04IH/uy79+ONROzeedpDiG0XTf8ztjnX1eAoKo=;
 b=CuJxjJ5JjuuPRYvZGrZCZ1OcRP4pNVrRRad+A+ZVF9rPJ+C/FSRHumL9vsnhJE5KBXwkSAHHF0b9J2Gxg2ZeHgmD4FAAR2PBOc0L9hmQ4BveRNUEDrZOQJNECR3X6UbKVYwgXePiGaFE557QbKaOl6srym9zccMOD56YgD8tOxc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com (2603:1096:4:78::19) by
 KL1PR0601MB4340.apcprd06.prod.outlook.com (2603:1096:820:65::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.12; Wed, 27 Apr
 2022 02:21:33 +0000
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::4591:4f3e:f951:6c8c]) by SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::4591:4f3e:f951:6c8c%7]) with mapi id 15.20.5186.021; Wed, 27 Apr 2022
 02:21:32 +0000
From:   Wan Jiabing <wanjiabing@vivo.com>
To:     Hartley Sweeten <hsweeten@visionengravers.com>,
        Alexander Sverdlin <alexander.sverdlin@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Nikita Shubin <nikita.shubin@maquefel.me>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Wan Jiabing <wanjiabing@vivo.com>
Subject: [PATCH] ep93xx: clock: Fix UAF in mach-ep93xx/clock.c
Date:   Wed, 27 Apr 2022 10:21:11 +0800
Message-Id: <20220427022111.772457-1-wanjiabing@vivo.com>
X-Mailer: git-send-email 2.35.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HK2PR02CA0160.apcprd02.prod.outlook.com
 (2603:1096:201:1f::20) To SG2PR06MB3367.apcprd06.prod.outlook.com
 (2603:1096:4:78::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1b5be308-110e-47f8-d56a-08da27f4a4ec
X-MS-TrafficTypeDiagnostic: KL1PR0601MB4340:EE_
X-Microsoft-Antispam-PRVS: <KL1PR0601MB43401D7A34785288D0F4F69BABFA9@KL1PR0601MB4340.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GF3CW2QGNsQ0P7kBlOe9X+xRfCEMVid40YQGHNKyfTgrjrnISCamjDoasZyfsOEX6bbczlJWXGqJmAutZctFdPttlCTQr9uJ+WmH0ngdKTlaBRKHLIZSVQrBYHAaJb7S/RcDkcdexp9oVRbOlmM3+ellKTj4mSK2PgaBYdsxyAAJwLcDymPLFDMVl3BZ2P3wgCfvxJ9HB+bwERp4qPwKvou83zzJZfh3zi67C0g6MkQfkzay9Jo3yw9aT/JBmR0ut8fqS1XvhkENOthKRAIQz2OCNE377KnCcRqiE7pbdEc8LpthziY9tDpBrR6o0qTjPvby/xxU1PKLZ9zxKsyrupIwz5RX34Fp1OjxViWGczaX8LHmwPKTCsooD7QBADeSIZwqnEj6M5DT++zrmNZKnOc0HJvtL1+fmoCNnaeGkys2cofI2y1PT6eiMVhxFq5cawx+xIbBCubhHwxHlluLKI2XEWKXUsFYpw0td7ozCkZtePmoTTaoykBUeMg6U5wKvulJh13GK8SEJGvhI5Yx3FcMndL0CKdaqAV72CMO/wcryvvY9BuBs8kjhlRYjreic+U2KtjSIyPuTC1KwRFjjIlO1aX00gH3NCRacuwpb7B1qQzsSn0wJK7yYiIuUTO9f8AGM0UzKQDVS/urONTRz/MKmhHTqpJPfvWXvyk2D8WoMwOh5ePZZ66WUnaAPK6MpcH9dAZ8jYnR24xP7MWc7tAOSwwH0wRikeVoLMbXA8RL0Jd1X8nfalMwbq6xF9STWIZdUXsHrK26q5PrHEC5VFfCSmaOMYFiRJiNb3iJHVk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR06MB3367.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(66476007)(66556008)(186003)(6512007)(8676002)(4326008)(86362001)(2616005)(52116002)(6506007)(36756003)(26005)(1076003)(508600001)(107886003)(6486002)(966005)(6666004)(2906002)(110136005)(316002)(83380400001)(8936002)(38350700002)(38100700002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mDonjTPvLYtOEeoxEqVh7ZA5aHMIVWEJY5d0nc9O9ddnMtDXlQxJroq2x7j3?=
 =?us-ascii?Q?iBQmH/8gwInjEtU0/pTlK4/EOEv6yaYrFMHjf6bATkmhHfwIbbFUVWcAWDSw?=
 =?us-ascii?Q?pAd221lIEFrENgLsDXNyQQT/mpmN0n4Qng8Rwh+M7ba23XJAk477cwKgEZE7?=
 =?us-ascii?Q?lfemFOLA3H3c7rkEGOa6JXfOS6DjNfUg08NlMcKosrKnVKHgM3yPhcSeAhRV?=
 =?us-ascii?Q?q2AueXu++ghfVKS5g5cViv2N16DElr5iJepDn8Ts1iWkE7oONf1/nUL6jFbk?=
 =?us-ascii?Q?+4zpm5o6m9g6Z/cg/LO4XwP9tBIXZzHKKYXTyJz9MM+nUr6CoqdK9NIOsG3H?=
 =?us-ascii?Q?vtfglTtoC96KuA0tpkr7Vby1kyxEqX5jwxR37ppo6wx+yx/89HlWYzOHISvm?=
 =?us-ascii?Q?IqniPfG2rQ+JaT9YoiU3DJHWdM0bgCy7EdLX/eTRT2lN45+pZD8nB1v2/di4?=
 =?us-ascii?Q?0t9uDTx0Fckx7FNMbSYOjCrb0wXtcYVrnGmpSSOXwCSB/BwlanmEyEAZlRhI?=
 =?us-ascii?Q?EVxGjDizAFpZLn8afe3EkV5hNSkioPpWD1WriILoHfP+cEiu+mwTENFH2Lny?=
 =?us-ascii?Q?XswoocJE3tQmfrZh5q0ZNUMxaibncGV6x8f05B2YGUIIcyQ4Q2MI+UiOpwIW?=
 =?us-ascii?Q?ioaqSYH0GdK0nD2STIlrin4mdUjttiLdj4ai6rOWpfr9yFJCMNXVsmLa5dIy?=
 =?us-ascii?Q?I9Uz790ge+z5lQb9BtXQTu5b9kZpHA+fKAznVdaIy7WzSL+UCXuj1o3iR41a?=
 =?us-ascii?Q?6SoeRJng96Af7xW+JOurMnDj0k4a1idkZnQGIkGJVXEWq/aJ1y//2kZ93sTU?=
 =?us-ascii?Q?pgNIXibtLI8HeV6pOUxyBpgj1XWAmJa0l0lp8C4YJMXNe+Csj6/0phlDOG8S?=
 =?us-ascii?Q?B+iCb2n03KInUQ3hJA1IOfoq8UMb0C7HpdmC5M8b69Acep/+Y/CB87uM0Ct4?=
 =?us-ascii?Q?Kw3oWdnxCc6guPqNabBTuKQSUC4pOceR1cBqVSURAwHvFlcAM1TRQs5qSz61?=
 =?us-ascii?Q?FTZhss+D7uMIcHPAFIR5iPDUaIzPyvtGvlReYGcRjokjVkzBwgWdaq3tfZXm?=
 =?us-ascii?Q?uCujIpsOLti9N9B3ytos62lBJFXQCWDHTYor3OdWg2IaXK0HoLXdEMGEtmeQ?=
 =?us-ascii?Q?m13KJJX1ndNWD8zWJHfkxBu0PgnwxcTQwEnb7u9nl1UJwvmD1mN5fY3JH6wV?=
 =?us-ascii?Q?zDSRWoRgg8brdrs0MwfyT2HPlQsYbP07+RnTihglHjss6pdieG0i6FIrf0TV?=
 =?us-ascii?Q?E2pEQY1f3SkZSb72iNdo05qrT+MeAaa9ksnaNGL2RqConQ13t7+9UlYtPUeJ?=
 =?us-ascii?Q?KQux0R8fzmNuLxNqaS+xcBhWw5hDbRMM+DzvUJgTcTa56vmVX4zWv4cyjDEq?=
 =?us-ascii?Q?S8sJESZRHNkSbZ1OCk8Q15MvZFJ59MtLjRTEmH5V1gRYNmnbbLtnTF+92CNL?=
 =?us-ascii?Q?jnOB8ee1W+OZytCrWNHb+NztE9XWCR2QJi7IP8RGH1TsRt7x7Gp5ZYEjH5bL?=
 =?us-ascii?Q?suaCwroIKS1yLD7P6bxlE/+rgfM1N7eTQkPeU6Ux5OjabEsReaoFMC5PVyYh?=
 =?us-ascii?Q?BkFBglKGbC0UFGNydl7NmzsAICelJJDEZt1ebLZnlAN8KssS/RIMkpG5ohai?=
 =?us-ascii?Q?pvS6+D8VA/JTIKuQ7Kv5m24MgHFt2Q8jnDXeJLwysA4KKdbNtkLHC3d75ja+?=
 =?us-ascii?Q?QZjAw/Hh1+R7UPLAGnkfi2bT9XZ8zQkFFH2fr07tA/EoMhEsI5XBf0WqZkFc?=
 =?us-ascii?Q?MLQpQt12oQ=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b5be308-110e-47f8-d56a-08da27f4a4ec
X-MS-Exchange-CrossTenant-AuthSource: SG2PR06MB3367.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2022 02:21:32.6021
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9L4bTgkwVRr6xzIsDj3dqkjv9PtWX1Lq0GMB/YyLo2TChj4+6Z4PKaEDrRHOdFudhf2E932ClPJY7Uz2kBxzjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR0601MB4340
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix following coccicheck errors:
./arch/arm/mach-ep93xx/clock.c:351:9-12: ERROR: reference preceded by free on line 349
./arch/arm/mach-ep93xx/clock.c:458:9-12: ERROR: reference preceded by free on line 456

Fix two more potential UAF errors.

Link: https://lore.kernel.org/all/20220418121212.634259061@linuxfoundation.org/
Fixes: 9645ccc7bd7a ("ep93xx: clock: convert in-place to COMMON_CLK")
Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
---
 arch/arm/mach-ep93xx/clock.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-ep93xx/clock.c b/arch/arm/mach-ep93xx/clock.c
index 4fa6ea5461b7..35f3734e512c 100644
--- a/arch/arm/mach-ep93xx/clock.c
+++ b/arch/arm/mach-ep93xx/clock.c
@@ -345,8 +345,10 @@ static struct clk_hw *clk_hw_register_ddiv(const char *name,
 	psc->hw.init = &init;
 
 	clk = clk_register(NULL, &psc->hw);
-	if (IS_ERR(clk))
+	if (IS_ERR(clk)) {
 		kfree(psc);
+		return ERR_CAST(clk);
+	}
 
 	return &psc->hw;
 }
@@ -452,8 +454,10 @@ static struct clk_hw *clk_hw_register_div(const char *name,
 	psc->hw.init = &init;
 
 	clk = clk_register(NULL, &psc->hw);
-	if (IS_ERR(clk))
+	if (IS_ERR(clk)) {
 		kfree(psc);
+		return ERR_CAST(clk);
+	}
 
 	return &psc->hw;
 }
-- 
2.35.3

