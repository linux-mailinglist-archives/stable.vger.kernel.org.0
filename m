Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47E7248DD72
	for <lists+stable@lfdr.de>; Thu, 13 Jan 2022 19:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237462AbiAMSH0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 13 Jan 2022 13:07:26 -0500
Received: from mail-eopbgr90080.outbound.protection.outlook.com ([40.107.9.80]:13136
        "EHLO FRA01-MR2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230329AbiAMSHZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jan 2022 13:07:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XYwv5VIbhFQa/1TviR5KJfPnD0yIkPZY6wxheF3B2rZGNYOG2H55CgcVG0zw5QtN32mIiJEHgbjxjHtD6D3RJsSDVX5VilvfMf11OWzzHsTt+abgplMb8UY/xNumfkUjTl8mTNyW0ZxDJ6OkOJZDfFLpTrhe+zWDo/aneSoiMbSTynt1zBMrV0h4QCYS9aeYjhaGsZ3DCgnOXANdo0quB7qMn+Jf+vSRO0xEIwWk33o52NnJj6zFYqZpy+Xx5nt/1wrRlqfqBuSS4GyoQ+ttw9mjWD0eec/cxsoHWR/iBZ/oaxrz9zj159TSBs+3X22yHYq+U9C9hYD+Sgab3VBk+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WFsCqJvZnvFgLUmkb94xyNLOtUw6zUBRPZiAaOBGaf4=;
 b=maLOw05JWEQ0cL88a8nZdu4lZJ2LfOH55th1tlO9K37Uw1z3bcd+JIfDPs0ZM6yB+JmOKgbPVOrCTecdve5gHgFqY9ga/jYH/Fx0JF/xqBLQwTbicqaZnZHrgoBt7ctplmIJs0ygXlTbOLEOstushEa05bqmgJ5pWMn6b5C6/PF9iiFidDKCSv90aCg/maEhe/HqK8OSSfYYFdinH683yuGXs+wqs90Q1ZUTP/6V64EIBUq6/zVajqYyCrMLG0iF96/eS3Tji67A/Y9PASXnDu4z2hnIJoUzHUDFhM1kAdBi5d+UqAKg0ntHhu94dxIrg9ysHWTsjx7lINIQPpv8AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by MR1P264MB3954.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:24::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Thu, 13 Jan
 2022 18:07:23 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::9d4f:1090:9b36:3fc5]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::9d4f:1090:9b36:3fc5%5]) with mapi id 15.20.4888.011; Thu, 13 Jan 2022
 18:07:23 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>
CC:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "Dmitry V . Levin" <ldv@altlinux.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH] powerpc/audit: Fix syscall_get_arch()
Thread-Topic: [PATCH] powerpc/audit: Fix syscall_get_arch()
Thread-Index: AQHYCKhqVymj08QpN02Rq4/+9C4x7w==
Date:   Thu, 13 Jan 2022 18:07:23 +0000
Message-ID: <8196844f811cbbb43f03ae2d6caeab018375f2ff.1642097225.git.christophe.leroy@csgroup.eu>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 45b57d32-8986-4876-0151-08d9d6bf8c92
x-ms-traffictypediagnostic: MR1P264MB3954:EE_
x-microsoft-antispam-prvs: <MR1P264MB395468CA70F7CFA405B18F85ED539@MR1P264MB3954.FRAP264.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:121;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AdRhu236TQ3fJ0K9w+TCBveh/Uiyf3Mnu6Gf1PZqfATYBTQcvuRrQYvcTnecqZgSI0YH6r6tHVUeEgvP1ix60IFYaeCf8ww96K5G0goXdetikkK4uxuD2M8mRLmm4FnmkC0mVafxn7TylKI/RpTqs/tKgVzZRecjvCQsu0vGkhytZjqJxo0hRiTSshFxDV7nq+pLIV2BFVbKcTWERI7apxPGvsI7S7ZWmiJnfy80uoJ6XYvkaPjO/i2NCIV/vkM221jtyroQ9cU9WBbHykbe4jN0Ten3nRTAFlleAcuOWmWW8Paqq5nNlPyBeA3V6x5egWFcST5H+cHmCBRZ+HCa/zSBhfxeJq0Hg3zkspH3CnMWdE8pNCbuj5PxZVCUNDOy6M9mkPEH8u2NWlG1nRvgdXc81lPZZTdSv7rKwWvNbO33z8JPGDOx0kp/HmUV90Njx3ryy+pL4xemtbksEwfAkYcGuuGV/B0cfuv+roM9/FLXC1yHKlkHJQ+uQHGWFSLtNntSQMuXEA5S2WkK2YSUU4FeJbXk1E2m7L1G8+NHHM8yny06POz+A04xMrZFWH3Es/gKLVwaI3vWknzPRVvQR8b8FdDElV/wEqhjr96x5T8EMj2O8ywXsKzQMc9QAXLW//gbrNMESNCTWuUZ5/TQhctmUVAqshutG7Ydq9Oj0JOFc8Fq62ra2O9QPs8cMvyIBTcY/ed4Fh9B5lAxqG0xVQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(38070700005)(66946007)(54906003)(110136005)(76116006)(91956017)(316002)(186003)(6506007)(64756008)(66446008)(66556008)(5660300002)(2906002)(2616005)(26005)(66476007)(6486002)(8676002)(8936002)(508600001)(71200400001)(86362001)(36756003)(122000001)(6512007)(38100700002)(83380400001)(44832011)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?+srYGOQ/M8g5UvB1hUdBS7Ivl/TqqgtT2PFGxWGJcZkOBp4glVsQ6SoY/l?=
 =?iso-8859-1?Q?L5nL1ymSkKSx4jRZCgtIUJzc9Zi/csDvH9Tb1T1Y/sRGzfReSrttz/wB8y?=
 =?iso-8859-1?Q?2Dcq2FSVjpk9kEI1m9WOMSd7FO3DdaBxXg68jF/hwhoLJjb5LlmU9kBHGy?=
 =?iso-8859-1?Q?anF/fyQ8hhOp697vzf6VYm7ulgDbbNTV6bZJ0olA4mnsSMugc7ZJh2h08h?=
 =?iso-8859-1?Q?D/kCrKPD7QG0irsLfzXvuD0Vu36N5Dh9bFOoMqpPvU1IrUXZEotfuXe+lF?=
 =?iso-8859-1?Q?T3XRuZ3sjn0d/mN44ji37REybTqxPo49VfIcer8xV5WLIg3P5rDV4Zw+gc?=
 =?iso-8859-1?Q?zx+UwG9gVXr3Y6maPhGhi7oWuMi7ylXEQrSSx9IP2qrG+YirLg0K0H35WE?=
 =?iso-8859-1?Q?tyikhSlZAiFcY+qbvRn2aEj1WoU/7MUuawqxL2eL0FYqD41MY/95rV9UZ+?=
 =?iso-8859-1?Q?7WvUrNcv1ZnxjsVO7849qLqJJg3/wYFrG9GSDOxanrPoHbJieU4f09qzpl?=
 =?iso-8859-1?Q?pfNoXrLXu77cbHG1DqvRC3JV9MfVRGoggODEicWo7KIz/NzZdT9LIkry/B?=
 =?iso-8859-1?Q?dzESDrF2qnn8FR+W5R/bGDP6uKmXYZO0kGkVLxIb0s4dHLFhVTfZ+M/BjJ?=
 =?iso-8859-1?Q?mT19cvgggStVlNHKhX3K2RohMxl/lma65xvtEkxRhbSQ68CK43BNtRUdb4?=
 =?iso-8859-1?Q?FEBOUGQLC6MBNeLF52ZPQRra4OakKKKWJFYF7Nll1m0mGIOkdXCqgaA6CE?=
 =?iso-8859-1?Q?yOrg7s1qMBl908ObJ0RUwQi1AayxCtGh3UAdfoIbFr+mKbuw4jlaKVR76U?=
 =?iso-8859-1?Q?fF53k04skyYEUiHbFKcbytTK/X8jR20EpWECkyg6bD1T97NnlB//MtifGb?=
 =?iso-8859-1?Q?NQVho6n8xky3/0whIHmv5MhO5r20j9+dhgGyapWsR6sq8oy1eFF4vV6ezz?=
 =?iso-8859-1?Q?OW/LFzpmf7S4uw7NagsunSZR70DJkKbeEot2ryx81EyMzoTMtJJq6XOpKl?=
 =?iso-8859-1?Q?h3M0pM3Y2YpvC7XPpGPEZ5qb2S8rFnyaLdi2tdJGnQUqXTYDDcy1pJS3cF?=
 =?iso-8859-1?Q?gsrUA7HOCYLlBBuTrMh4ZDUnCbV03bfrcwrc95PDEH9jXs52O4H234b8dH?=
 =?iso-8859-1?Q?OpxQKs6pWVgwPQ9B2ctIPZn3SEY+CrEUxvyMKIb0qOnXmsBJLGbISo6EqP?=
 =?iso-8859-1?Q?I7U6X2lKPwlMdm0qKl+1o2qnogJUfZTtJp20VLaolfjLZzETmdwfmrgz0c?=
 =?iso-8859-1?Q?KNwgOH5ydKzdJ9twu5DHLt6bjbdrTCLq/iaQhcDBVu12iTxpAk6TFjZxX2?=
 =?iso-8859-1?Q?ztzrDOY1tbyVYrgQdFQYHFUKk1G+Ce4A2ZufPcTNQ3vbAipF0DWfRt8ssH?=
 =?iso-8859-1?Q?2PrYbJO06WT/CTFR09TFAAlQLk1F4YSumzxidwPrceq70d/yecejB046Lc?=
 =?iso-8859-1?Q?/B+2idaFsctwT86c7rRAeJNJHbYTI7JJ82i6Aq2brCoYn18OqTUV9XP9YX?=
 =?iso-8859-1?Q?SdHRCocmi+e3XxqLfmBYSi72/W3q05emol4nWdll65QLEIjYC3ZNLaQ2k+?=
 =?iso-8859-1?Q?hM5r5vO9EFZ5yJOwv+BVI+w0+w+U5oXdT+WPS6KrRo6eCY0sIriq1VwT/f?=
 =?iso-8859-1?Q?aimt8bQSGay+NdswO9DGnOgnZxnd2lw20umR9aHC2DcM9H96XiSJeskGun?=
 =?iso-8859-1?Q?wsAxzbp4ftccxZhcKemDywZyoMcXv8cjS7NaZGa7OmMIlH+gobScGHi0en?=
 =?iso-8859-1?Q?Zxldto9ddv3HRzUEL0lcw4jQI=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 45b57d32-8986-4876-0151-08d9d6bf8c92
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2022 18:07:23.4487
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cWR4yTdM6ALrH7quBtrhwOZxc/6ciyPmVoNKiYEzyxBhkSOYqeWUnvsKTgH8DqmGLy8lSIN1kdK0UYlWYukNvIb8aCCupZE0EmEfOObigGk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MR1P264MB3954
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 770cec16cdc9 ("powerpc/audit: Simplify syscall_get_arch()")
replaced test_tsk_thread_flag(task, TIF_32BIT)) by is_32bit_task().

But is_32bit_task() applies on current task while be want the test
done on task 'task'

So re-use test_tsk_thread_flag() instead.

Reported-by: Dmitry V. Levin <ldv@altlinux.org>
Fixes: 770cec16cdc9 ("powerpc/audit: Simplify syscall_get_arch()")
Cc: stable@vger.kernel.org
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
---
 arch/powerpc/include/asm/syscall.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/syscall.h b/arch/powerpc/include/asm/syscall.h
index 52d05b465e3e..32f76833b736 100644
--- a/arch/powerpc/include/asm/syscall.h
+++ b/arch/powerpc/include/asm/syscall.h
@@ -105,7 +105,9 @@ static inline void syscall_get_arguments(struct task_struct *task,
 
 static inline int syscall_get_arch(struct task_struct *task)
 {
-	if (is_32bit_task())
+	if (IS_ENABLED(CONFIG_PPC32))
+		return AUDIT_ARCH_PPC;
+	else if (IS_ENABLED(CONFIG_COMPAT) && test_tsk_thread_flag(task, TIF_32BIT))
 		return AUDIT_ARCH_PPC;
 	else if (IS_ENABLED(CONFIG_CPU_LITTLE_ENDIAN))
 		return AUDIT_ARCH_PPC64LE;
-- 
2.33.1
