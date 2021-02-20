Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9B932043B
	for <lists+stable@lfdr.de>; Sat, 20 Feb 2021 07:38:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbhBTGiI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Feb 2021 01:38:08 -0500
Received: from mail-eopbgr1310127.outbound.protection.outlook.com ([40.107.131.127]:64881
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229476AbhBTGiH (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 20 Feb 2021 01:38:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mmwyukeuidjk//jSceoLN/q057YmVK3ShCaEV02xzOOb0Q3ytJ9ulACXTHUuF++Vcq9lJB816gLOOyvxfSLC3CCx4TYS0sULgwwD2z5Dq9yuCe5Bb2WN+1zLkjXqHyH9NGXh//9ApD9lOAr1XLWOl+PL7crljY9eUkxLCiAR5I5nmLl3bQN3YujLUPzLiFxJ8CE2ECawgs3XeBsMnaZQzy9sJvBVEAopgP5lnWnwrAVC1/zodbGSF29dBOsxPQUqP8vSiuIG5/1RhX2Y/lH5u7IRWYG1B/1lQtLpz0LQQRf74Sb5ys1w4GstYPkj5pwUDm3rqlbLhkpa6rYnbouLkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tHQlEjKDMg93WT5diHuLi3g3fwjSnHSPxljt8c6q8KA=;
 b=cY/7Kwyj98ajLcp6rMw1MBQYBvCyvJyRYOF8i06Y0+42zprz9CriaeCgpXKEC0jtRMl+uLxruo/xtJkFcfrgkDcgOGvU7GuWHeE3lStFh2G4kxc8HCZzc+I+W0WTwIxu2exRDmIo4dZLwrK8tVi8kVXGtzSra3oDp6/JV49H6gTYh8b5zpFRgk5Bk8VvgWyF+WH+dNFzLSALuQSdndGe/Zj1nIg/uVoO5z5K8eP7kbOK8CAO9N9yO9HNl9ORWl+2xdk7s/OCQjDrvS24EHaUV6s23Feo0VMQvDDEVnLY6Et88Q2kewSU0/f7i4/fqqpP2DOlLuhGs5RLRsAD5LZoZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cipunited.com; dmarc=pass action=none
 header.from=cipunited.com; dkim=pass header.d=cipunited.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=cipunited.onmicrosoft.com; s=selector1-cipunited-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tHQlEjKDMg93WT5diHuLi3g3fwjSnHSPxljt8c6q8KA=;
 b=yTADh/TXRccyhO60+pV7fs8UQZlRYN3eVwhpNlgoBY8NT+I08ZNcr9vkn8N3ASVEj9IB/2jGU16QO1xqtHBSmg03whuXhg5lTuCo0eBeMebOJAqiQJW4QE6yB7GM17o+wCTUiZsRuPWslYfuRv6pps+r6Z6RWTZ74jnUp2sw/oY=
Authentication-Results: alpha.franken.de; dkim=none (message not signed)
 header.d=none;alpha.franken.de; dmarc=none action=none
 header.from=cipunited.com;
Received: from HKAPR04MB3956.apcprd04.prod.outlook.com (2603:1096:203:d5::13)
 by HK0PR04MB3042.apcprd04.prod.outlook.com (2603:1096:203:83::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.29; Sat, 20 Feb
 2021 06:36:31 +0000
Received: from HKAPR04MB3956.apcprd04.prod.outlook.com
 ([fe80::b5d5:d70f:ed37:984c]) by HKAPR04MB3956.apcprd04.prod.outlook.com
 ([fe80::b5d5:d70f:ed37:984c%5]) with mapi id 15.20.3868.029; Sat, 20 Feb 2021
 06:36:31 +0000
From:   YunQiang Su <yunqiang.su@cipunited.com>
To:     tsbogend@alpha.franken.de, linux-mips@vger.kernel.org,
        jiaxun.yang@flygoat.com
Cc:     stable@vger.kernel.org, YunQiang Su <yunqiang.su@cipunited.com>
Subject: [PATCH v2] MIPS: use FR=0 for FPXX binary
Date:   Sat, 20 Feb 2021 06:36:15 +0000
Message-Id: <20210220063615.10271-1-yunqiang.su@cipunited.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [60.247.76.83]
X-ClientProxiedBy: HKAPR03CA0022.apcprd03.prod.outlook.com
 (2603:1096:203:c9::9) To HKAPR04MB3956.apcprd04.prod.outlook.com
 (2603:1096:203:d5::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (60.247.76.83) by HKAPR03CA0022.apcprd03.prod.outlook.com (2603:1096:203:c9::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.10 via Frontend Transport; Sat, 20 Feb 2021 06:36:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c990e99-19a0-44ab-8314-08d8d569dc13
X-MS-TrafficTypeDiagnostic: HK0PR04MB3042:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HK0PR04MB30423F75218B835BD7928317F2839@HK0PR04MB3042.apcprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BWoIrv8t8T4v9jIg0E3nUvN8GbkY44oY+WAiXHb8rAcqo3poKqW/8RubP5tK1i6siB6078looTPf4oF74MWpjKKsN7t5UXarOx+lCgUhSywa7wjqu2BFI8s3WpC9IL7D/AFTN4O+38Ta2k0R1+nIvGRMDl+/2N9pwUgr9RcMDs3YXSYfUony1aCc4WpmPQLzsQD943vy6egZOBApFaSlE7oFDF2K/+sbh7V9t0ecPxw2yldC8CSmuXjP+a8SfgRIPpxD1EKojigzBBRyLLktPVNAnac3rU71cI+dxdvAAvc/JqefnVedeNsvMux+AYUL/kR4McCxyYTp+yhTu6J4nTnk+ZJhqok8V3g0ROPITvwRPn4+SbqCTe4cY68eRcGFLM8l8R6rZ/AG7gnFztvniMXY1B9hLeievxfxvlL3eIHseucvxva9zJMb61ZCfeJ6bmZtHMaSMQ3NFbQJsEOdqw7lsu9dLXZZhShj4CrHWW+rpZ58TYqqqPsZZrtmXYnMRL0xTXkoMAEI/GlqZf7CLoxCFHSARkhkd/goEVkHfIXNnCuNUJCi1mLbAu0ibDZtPfcws7+wTJy7HCffJhwCzFVJ/brh0beyqBT7KGvtHolrwacqAox6Kyjd77PA4oYgdlurIhis4gQ26PfPAzlzHg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HKAPR04MB3956.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(39830400003)(136003)(346002)(396003)(66476007)(2616005)(956004)(52116002)(2906002)(6506007)(8936002)(5660300002)(1076003)(4326008)(36756003)(16526019)(66946007)(6666004)(8676002)(186003)(69590400012)(6512007)(966005)(107886003)(478600001)(316002)(26005)(66556008)(6486002)(83380400001)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?uGHJdihMgwf4aPQJa0HSPFx6BA38rgj7l+c7JRjTJsjUle+3nQHbUnTABao5?=
 =?us-ascii?Q?lm9MzT3q849cVeL++ojXCnuDHHzv0RCxo7iOsiP+nlmz2TqHB2VGBi6GTfZJ?=
 =?us-ascii?Q?9cQ3ABy7iZMl7/+QbPZXP73BPXf0rNgBc8nFHvnNpoUDiYZxJHIIcdcIBItU?=
 =?us-ascii?Q?ajYXamk0HwYTLAHgxxEiKUsvG2o6dsau/39dUHEszHpfgA/ZoPGXfDf0yBd6?=
 =?us-ascii?Q?SHYx7YnfuB/IBtofPnToSCEROvUbVYBvQKkNHMPvUnm2EOhjhBd5Ss75e8t1?=
 =?us-ascii?Q?uosUq4c++xoYbRFHMQuUV1QQGL30ZvCl/aq8vCgNKyJdZkXNZT5tb6WBgUPM?=
 =?us-ascii?Q?7rEmZRmlsSQ34oEzDAT9Wm40RHa4roYWctOlBPGqT8IS62NLChqlAiiRakdJ?=
 =?us-ascii?Q?kFBTPLjS4TEXqsC7ZMQZ4juRHiLA5G8lsBmsCIryK33+fXdNS4BUomEhm/5q?=
 =?us-ascii?Q?PGVnfVLT+Vws/9aQgf3ER9P/syFKmwxd6CkTP3YZYcf67cMsFj0viDffESlF?=
 =?us-ascii?Q?Djc5VYMuxPpdqJqeaiyOH0dh/qoITxiH4Lw65OWRY3uNPZ+Ar7jWPKpqTzCW?=
 =?us-ascii?Q?R/S6+CCXng+koNVcqkamgEKDlflfY/Gm0E2vc18l7ThTBW49pPXQ9Nge2JwF?=
 =?us-ascii?Q?EHMFp9XZttbGLwNGZ183fB/bx/A5CxX5OvpFzEahXIa8/DKVgDs25gTDKPmq?=
 =?us-ascii?Q?0KAfWlu73Age6CibRPhHXIi+tYIA1JUFAZWBqxU/ykaBGArHtS26swlVCWbl?=
 =?us-ascii?Q?nHbSTMQoPX+0MwYXNGwOAvElpUYUSNb0hl5TqYPmpUtjZhN8ISOg4YuPry8y?=
 =?us-ascii?Q?rnvXNlkKNowkNVh5u5a8T1VKR3HnT40zdoaAQDBM/KS9L6m2/jQ2bhkDSAlB?=
 =?us-ascii?Q?2JkdWzjOS8Zhv8m/b7GMQn6jJjGOXZYSEDKiFQ34jmP19tv53cdt74A8uQqg?=
 =?us-ascii?Q?xMmm8Rw8dg0PVSI6jwUFAVlAVxLge4IvzJr/7CDafkGxYqG18bJPmlv50Vos?=
 =?us-ascii?Q?wSEgQ14VPm81zNfRPw205tcguQEBKDL2KNaV/A4fUvGYukWek0fqauMSThG5?=
 =?us-ascii?Q?UKfu/nkOTrpykWuQHKqZwB4DmHWveRaHnQ5VXx2foAiMTsutNuBJy/FzFZpk?=
 =?us-ascii?Q?ZNNqXmwUduykohSTurk8pGNzX6gqC/TqT4qzR+mJD0+KGkIWOCndRW1/9hC9?=
 =?us-ascii?Q?6R5gguQLclWa/6S4giW4dMfjGoSMo7Oceo4yA4BtW6dkdGK9X4ZMTAybbEgb?=
 =?us-ascii?Q?BF2Scg6Bqv6R5mnYt1gPY8ZMi7GnkKbGlPsihkar9h0dmOj5mrpEoxhsb1Lk?=
 =?us-ascii?Q?8z4xc1YxrEkFwm876UBfoHfG?=
X-OriginatorOrg: cipunited.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c990e99-19a0-44ab-8314-08d8d569dc13
X-MS-Exchange-CrossTenant-AuthSource: HKAPR04MB3956.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2021 06:36:31.5136
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e31cf5b5-ee69-4d5f-9c69-edeeda2458c0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +SelSxm5RGEndqtGC5JfMpSdhZCyzbps05wpRt7irKeyr6Qac9C3iqcpNhjj2y+LiAR5OYPhSOLJlkRiH7OgG/5d+xMW60hrgjaKl0/E3RI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0PR04MB3042
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

some binary, for example the output of golang, may be mark as FPXX,
while in fact they are still FP32.

Since FPXX binary can work with both FR=1 and FR=0, we force it to
use FR=0 here.

https://go-review.googlesource.com/c/go/+/239217
https://go-review.googlesource.com/c/go/+/237058

v1->v2:
	Fix bad commit message: in fact, we are switching to FR=0
---
 arch/mips/kernel/elf.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/mips/kernel/elf.c b/arch/mips/kernel/elf.c
index 7b045d2a0b51..bf798ce0ec0e 100644
--- a/arch/mips/kernel/elf.c
+++ b/arch/mips/kernel/elf.c
@@ -234,9 +234,10 @@ int arch_check_elf(void *_ehdr, bool has_interpreter, void *_interp_ehdr,
 	 *   fpxx case. This is because, in any-ABI (or no-ABI) we have no FPU
 	 *   instructions so we don't care about the mode. We will simply use
 	 *   the one preferred by the hardware. In fpxx case, that ABI can
-	 *   handle both FR=1 and FR=0, so, again, we simply choose the one
-	 *   preferred by the hardware. Next, if we only use single-precision
-	 *   FPU instructions, and the default ABI FPU mode is not good
+	 *   handle both FR=1 and FR=0. Here, we use FR=0, because some
+	 *   binaries may be mark as FPXX by mistake (ie, output of golang).
+	 * - If we only use single-precision FPU instructions,
+	 *   and the default ABI FPU mode is not good
 	 *   (ie single + any ABI combination), we set again the FPU mode to the
 	 *   one is preferred by the hardware. Next, if we know that the code
 	 *   will only use single-precision instructions, shown by single being
@@ -248,8 +249,9 @@ int arch_check_elf(void *_ehdr, bool has_interpreter, void *_interp_ehdr,
 	 */
 	if (prog_req.fre && !prog_req.frdefault && !prog_req.fr1)
 		state->overall_fp_mode = FP_FRE;
-	else if ((prog_req.fr1 && prog_req.frdefault) ||
-		 (prog_req.single && !prog_req.frdefault))
+	else if (prog_req.fr1 && prog_req.frdefault)
+		state->overall_fp_mode = FP_FR0;
+	else if (prog_req.single && !prog_req.frdefault)
 		/* Make sure 64-bit MIPS III/IV/64R1 will not pick FR1 */
 		state->overall_fp_mode = ((raw_current_cpu_data.fpu_id & MIPS_FPIR_F64) &&
 					  cpu_has_mips_r2_r6) ?
-- 
2.20.1

