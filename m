Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE55607ACD
	for <lists+stable@lfdr.de>; Fri, 21 Oct 2022 17:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbiJUPef (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Oct 2022 11:34:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbiJUPed (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Oct 2022 11:34:33 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2135.outbound.protection.outlook.com [40.107.20.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FAB029815;
        Fri, 21 Oct 2022 08:34:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=deff8E3+n14d/ifocU8evORG/mv/i+ggXvqyHK0D9b7kHqoxPIuFWC86+lKJ3CpVFFXydc8zY1eCtl/bnwtsrnW7VBqh1P5/vvNyNX4APd0SL/egDjq0wPS908pAEKRsfJwBut1+5pNgSc5F7e2vz1eVc8W6HYxYV7BbjCBqw1U1km5f58jLkBEg6DuvFJ/CHkXJRhftXPvmGzHO+L1TYyLoue9NbcNVocse+MfaryFXEQRA+IqFBvGDD4okaeva6NZr7A31lUuErN2C8uABtzk9qRjP0mb5kBCwnsRoI8451fqKA3Rk5TBQPjEHFamrmx07HY+a30FcyZH703Nwjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6IR26zvGQfYXSBKJCweO48Zc6askbHt7qx2j8/ElUvU=;
 b=i0BuBY0XzvPECjFWBdF1hDemk0FUbJjZvdH5IkuCdXRyUrmMOgQJslWjGYBM0x4GbzkT0Zemhd0mpnJTidRfoMCxxrHlc/veWuB5H08bvkEJzbZ5Ckc6gkmnHW8KU2NDfksIUTYgCIzOyCd4P8SgCz+zCL30GqMfSgZH6yG+kDc/f5vA7FsvipTORYU3iHX7vF5QJoh/bf+hcye4fudTvdYtiq9RwH8U8Bci2voxtdjBnhaZIZpdI2aC7zZiahycU7H2pxRZWDE2tn6or5qBWy5RP3zpXZ/FrB+XOMR93oSnPnPhbpP95dmi4siEo1oNiq3MPwsJtN4am4r7wFiCHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=concurrent-rt.com; dmarc=pass action=none
 header.from=concurrent-rt.com; dkim=pass header.d=concurrent-rt.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bksv.onmicrosoft.com;
 s=selector1-bksv-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6IR26zvGQfYXSBKJCweO48Zc6askbHt7qx2j8/ElUvU=;
 b=RqsdNJSUDUM2LU2nQnMKNpO999iKcsvw2RwGYnlIaNxQHqXcvJPqrPebP83VHm+eOgbiqwOL5lFe4F9zc7LwpGTe4p8sO8kJ88GXdORCSVULFv+JtoEdO9YWZRtos86NSeLy7aGu/Pq2pjPwToU1lJoq4i1hgTgWzUplOEjC89g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=concurrent-rt.com;
Received: from DB8PR09MB3580.eurprd09.prod.outlook.com (2603:10a6:10:119::23)
 by AS2PR09MB6079.eurprd09.prod.outlook.com (2603:10a6:20b:55a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.35; Fri, 21 Oct
 2022 15:34:29 +0000
Received: from DB8PR09MB3580.eurprd09.prod.outlook.com
 ([fe80::c48e:11a3:c89c:f655]) by DB8PR09MB3580.eurprd09.prod.outlook.com
 ([fe80::c48e:11a3:c89c:f655%7]) with mapi id 15.20.5723.033; Fri, 21 Oct 2022
 15:34:29 +0000
Date:   Fri, 21 Oct 2022 11:34:24 -0400
From:   Joe Korty <joe.korty@concurrent-rt.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] arm64: arch_timer: XGene-1 has 31 bit, not 32 bit, arch
 timer.
Message-ID: <20221021153424.GA25677@zipoli.concurrent-rt.com>
Reply-To: Joe Korty <joe.korty@concurrent-rt.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: BN9PR03CA0236.namprd03.prod.outlook.com
 (2603:10b6:408:f8::31) To DB8PR09MB3580.eurprd09.prod.outlook.com
 (2603:10a6:10:119::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB8PR09MB3580:EE_|AS2PR09MB6079:EE_
X-MS-Office365-Filtering-Correlation-Id: c05c053d-a16d-4c7d-4543-08dab379be79
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G1Fo3kQHUzc7QNODtDfr9cAXAZ8BAQDkcYqqq1J3sAM4IsaP9QN4nnEcZkHQL4ca41FeTOPlImlXYB/3ijPSQd9eKQ+iUZ0KZylsJIdhqei9D+kMKi8hqvy1U2Um3F7lXCSZbpJTYJI0jbnaLbmUEmj+KYzZwDH0nrb15exSmLa5zbvtQd3Xt8sJWrEsTli4rQHve06Q6AmOT6/V8kw5nPaa7tOik/W40kUXvdNdRW3KSHAUhaX+k/6/+8PmuKt3qqU2NtDdvfIHEZ+GyZA6xWeY2PYskwZrUyWJhN3yoSxPHn7pSJjl3xX0x6XY9ltZyZBymmNr8wje+RZhPFrRyeON7bFMoVmFMmosLrQnZembXTT/RGCe406OFgG+bw3qYvG2GGQprKM+pEhbvRDRD1S9eLzJexbd1lvY7AVyfsgUDxuuMcgFWMmINAilFUG6W7uL5++CE22EcT4rK7VxABvZe6PLpo3lMhy7ct2gvb0Yy545Ti/Kb67a/+a+sqwEFyWXG74R0UHxil6gzeSOpGtczVfrit57HtbKR7Ni6cYPAH4QPnU6qsaVxCv14jAPbmnEu0GqSjoSxK3zWYZl3bUSYKCxc8v/KVdtjRCN0cD783+SjevmEvsWtrjvcX8OBkC1DFKrdpIPc0SeM5BEFbGbjcxMUH/SJRXl83qsr+HhTPCHEE7lGCeHso43SRnnk5MwhOyJ2PkR6OwhQ5pk/0V38SyZlSOgeKOjtSpI4rTgiYz6ayQEDTpZnJj3A0lsmHsaGkffjun8X5B8AdtGpg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR09MB3580.eurprd09.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39850400004)(376002)(346002)(366004)(396003)(136003)(451199015)(6916009)(478600001)(316002)(6666004)(6506007)(6486002)(66946007)(66476007)(66556008)(4326008)(8676002)(3450700001)(41300700001)(8936002)(6512007)(1076003)(26005)(2906002)(52116002)(186003)(5660300002)(44832011)(83380400001)(38100700002)(38350700002)(86362001)(33656002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hw3Y8t1OsW5eg1p50x96xJCDx8uWqUoWSy3huFbfsA5zxGmvXQBOLFikZJAN?=
 =?us-ascii?Q?NYlMVLoh0yCzQFnWbXs58kMKwTg85Y6W/ODEgRS3Dd5wtuydO8jnBhDC2hjg?=
 =?us-ascii?Q?7FyGgDNpAS2NLn0ziQJQttAO/1FBTheE2Dg2w8EpiUH9RoDmlNULduxaQMtO?=
 =?us-ascii?Q?46IhCSSnnIwT9mgf3gApuF/g9puu38zSghRFg09bKjP9+gmcQQFm68TVfvDD?=
 =?us-ascii?Q?GaqK8PPrp9TPfKpPLeutgMEmy2UgJVKuL2UAokNer22CIRmcVLTigEihna4N?=
 =?us-ascii?Q?LOF2L6EJWf1U6tMfp5oClC2eWanh2oaa115LoI+mtXXc4DWJOCEZSF2jLPN7?=
 =?us-ascii?Q?tzDqisTlbmn5sKyAOvvOeBR5jJsWMm5kO6tleMUFFERe0/XF3VgGTdOkTWc8?=
 =?us-ascii?Q?ocy2Xgd+vg2wo0nmhlYTXDbWVwG7+iifc6nAHgB1K5rs2oWEz7M8XY4+1CDL?=
 =?us-ascii?Q?o4osTrV3RB3VKRM04ifWg/mpdIRi7Vvj1AkOGtKBkv9wXXtp2yzIe9PFGvIW?=
 =?us-ascii?Q?d1UGDcGBFKd9daC2ccP6yc0oe3s9D8VjiF94yi0CriTPFpZebP+TsbLFyzSm?=
 =?us-ascii?Q?FbogQKNaWsZ3FIJfahltkssVYWQJAATIP3dyG1xtVHp5Oaii1MO9XWs6hIkX?=
 =?us-ascii?Q?1VVg2MQHu6Sp/sANJ4KShzM5smV6nPjIpVUU8j1jbpe1Sxreq0MUXLrJTJXJ?=
 =?us-ascii?Q?Gr6LdxNQOG06bFtBW6fIIuww0HbXiClhrFkRuPyhszEHhWZUSZddrdEk0JDp?=
 =?us-ascii?Q?N5c9Qo0rg0TGel8sTOYrjS2C3zL8W/D1AN6PqdS9iZdNUQddNfDH9p6WiqVK?=
 =?us-ascii?Q?fZC8HxjQjSt1LhtEhki+bfWkJlVYilKYPXO6Pj5SOfD0nEZbgywTEjJ9Kq54?=
 =?us-ascii?Q?sVfdGX2Hduw3dJO8Dg68Wjw272hLEpa29oalBaNAvy84RKAkVwdAPHzy6RaW?=
 =?us-ascii?Q?4haUGocB6UycWrUGHEM5eImBELy/r4o/78xzF/TtG5vaAcHO99mExiIC3MAf?=
 =?us-ascii?Q?VG5dQrrwHJc2pvlXh4Im8u6wBzH6Y/k9BQTVwOIyxW6lq10Xy7ZHtwOdfBhs?=
 =?us-ascii?Q?wxrwY9A+FYTOXHoX3r8YrsRvpo13x1PjsX7Xc+LpL7c6UH14LuusdgEd15Bt?=
 =?us-ascii?Q?P1igyO4d7xE26X741H25hfB3Fa7uecxyRGInphKwoASJRZmEQ8d7KcGOEXwE?=
 =?us-ascii?Q?d/tQ98LEXcQXkyF7Dov3Onmu5lI36FOnAd4eNGZddRuGXDxbRlm0ipfZPLoX?=
 =?us-ascii?Q?sTf+Wa35r1Ivohi77rhifnQyvxgcpd276CMyqwYm7MlKL9/ipjRof7xQrCxy?=
 =?us-ascii?Q?9CMF6dh5wNmR3flnil0wPzTHmfytbnP8umlaKrREzu81nAvLx4icMP4dQleV?=
 =?us-ascii?Q?+o/Cf8NZYEPxiNWp1z8XFVzmoWyWyubiFJcF/dPOEF2lW9L2RaOKdkYur4RE?=
 =?us-ascii?Q?sVmaJu4eZiIHJGuUVD7cLtKpBDQtEcNGu9GZVQjjvumBNCXMmEBYPyplaZIG?=
 =?us-ascii?Q?TTe2pz5LxHhKzwOosYQoigvE+LKKiW3WzGuCJWsc/FGkkxiWGb/5L1om3YjN?=
 =?us-ascii?Q?6P+w1mJ3Wqk/04OLxdg80Ou3PxDyikLKvBrCnRquYPSJLwqpcrsHIMIFLpTv?=
 =?us-ascii?Q?Rw=3D=3D?=
X-OriginatorOrg: concurrent-rt.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c05c053d-a16d-4c7d-4543-08dab379be79
X-MS-Exchange-CrossTenant-AuthSource: DB8PR09MB3580.eurprd09.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2022 15:34:29.5160
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 6cce74a3-3975-45e0-9893-b072988b30b6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Trsj/awzwBjkABz8ZT6mzhBFWMBmXgLpQlUJB39alDXojWgvM73W6EQ9YsfQ6vE9HjDstoN78OFGOj47lTVoOaxLXm4a/DLPYO3EiM78k7o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR09MB6079
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

arm64: XGene-1 has a 31 bit, not a 32 bit, arch timer.

Fixes: 012f188504528b8cb32f441ac3bd9ea2eba39c9e ("clocksource/drivers/arm_arch_timer:
  Work around broken CVAL implementations")

Testing:
  On an 8-cpu Mustang, the following sequence no longer locks up the system:

     echo 0 >/proc/sys/kernel/watchdog
     for i in {0..7}; do taskset -c $i echo hi there $i; done

Stable:
  To be applied to 5.16 and above, once accepted by mainline.

Signed-off-by: Joe Korty <joe.korty@concurrent-rt.com>

Index: b/drivers/clocksource/arm_arch_timer.c
===================================================================
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -805,7 +805,7 @@ static u64 __arch_timer_check_delta(void
 	const struct midr_range broken_cval_midrs[] = {
 		/*
 		 * XGene-1 implements CVAL in terms of TVAL, meaning
-		 * that the maximum timer range is 32bit. Shame on them.
+		 * that the maximum timer range is 31bit. Shame on them.
 		 */
 		MIDR_ALL_VERSIONS(MIDR_CPU_MODEL(ARM_CPU_IMP_APM,
 						 APM_CPU_PART_POTENZA)),
@@ -813,8 +813,8 @@ static u64 __arch_timer_check_delta(void
 	};
 
 	if (is_midr_in_range_list(read_cpuid_id(), broken_cval_midrs)) {
-		pr_warn_once("Broken CNTx_CVAL_EL1, limiting width to 32bits");
-		return CLOCKSOURCE_MASK(32);
+		pr_warn_once("Broken CNTx_CVAL_EL1, limiting width to 31bits");
+		return CLOCKSOURCE_MASK(31);
 	}
 #endif
 	return CLOCKSOURCE_MASK(arch_counter_get_width());
