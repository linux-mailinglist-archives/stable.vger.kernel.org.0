Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6492046B2BC
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 07:10:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236598AbhLGGNk convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 7 Dec 2021 01:13:40 -0500
Received: from mail-eopbgr90057.outbound.protection.outlook.com ([40.107.9.57]:41232
        "EHLO FRA01-MR2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230094AbhLGGNi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Dec 2021 01:13:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HwuaD8teop10cP1DuWyDvc33sPQls/rbukseV9TBplgo2oizqruDz2pimaRWbPokc68YwzdNXd39S6QH/ud9VG5DiEMw0FAsgsDsPiDszoyHyTnhpsQ0QYkHLhLsFifJRRnctqRYarYA36fPEwJgnScGXeYZ6V9jH9F5CSHkkhXqP/XxCB3ndQZXu2EW3yQGUzJLzUVFPVh22AicOicOpFGogev+gMgBzDQbas00Em62Mk16YkxvBb9IXt/5eel7HiHQ8USKNhxU4xDYqjQaGTi7zzgsXmj51ngaG7BxBhZxT/ZEOmY8cGk5A6ZOdN/BaEkC/Beyn/ZYUP4vYBtyCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kBhHST/mJah0ioKrpv3VvMdLXcfxbV+3+sQYSsfniI0=;
 b=KXK61T24aQEVEOgY6yIB6tzDPG7t+jl/OhvkLXqsgeOIkjTNh5gqeef/oH/Bp2jz+7/bZ0uR3uI7zx3hdvnJ/B4CQefoTaMkAcc/RcmCaIO1L/2UBfutWxInKxdGjhft69MQTWuE25IVrIrVLmCcE4tWOY+8haDSmgLQCDD5+WjwXkKNehWWsRdeUWRNJ83JiBjwarU0R/6zSv7OqQkep7EHcPlbzTqdiV6whwGFbzlNX7QK2QatKYBLC7quWR1XAz2KaegeY0gGLDXgWD28mDmMGRBr4CjrP7ejW0iLyPkNs4lk6ifm/1vg52Arhxv4MafAJp8DGIudyVj6w8RSwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by MRXP264MB0808.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500:18::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Tue, 7 Dec
 2021 06:10:05 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::fc67:d895:7965:663f]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::fc67:d895:7965:663f%2]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 06:10:05 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>
CC:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Maxime Bizon <mbizon@freebox.fr>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH] powerpc/603: Fix boot failure with DEBUG_PAGEALLOC and KFENCE
Thread-Topic: [PATCH] powerpc/603: Fix boot failure with DEBUG_PAGEALLOC and
 KFENCE
Thread-Index: AQHX6zEUm45+sm7WYEq1/qYEgOJsjA==
Date:   Tue, 7 Dec 2021 06:10:05 +0000
Message-ID: <aea33b4813a26bdb9378b5f273f00bd5d4abe240.1638857364.git.christophe.leroy@csgroup.eu>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e29c33a8-a917-4a3f-8e06-08d9b94836a5
x-ms-traffictypediagnostic: MRXP264MB0808:EE_
x-microsoft-antispam-prvs: <MRXP264MB0808CC25718CC86DCEA3E0DCED6E9@MRXP264MB0808.FRAP264.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:1247;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pXp0uNdQGoa4CqZAn0UAKbOQLjKxwIAvlAocVqGddBdkwuoN7C1jBKyKk9wG7V0mLG/MvZwgnCoXDO65DL1RW5VjETzXtvfNOJYswaJrMpHOXjYs+d9G+qJ7vZGbduhq1AkwgGq793bDt45fyBOFijo9/4jV8lbrp7jua/tkvXn8dE8ytztRF4akvLyLRG8EpuOz3UQpl1UR6ZGfFdSjig1vUxLjM/yN+pNX3+wYfu18gpJhAILhG04x+OuE2zFUkyWfIjzDUzDwBujAL7Pxo4jnRMaMqjgIICvi+NvES4bkiwVUCQHT7GnZJWrTTlR6FXwj3vVClGwYkz8gJpbScbROhvAfQcsEGNX/6oVilY2DUFjVPfqsc7B3pYNbg5+PQQrzsLYPSXW9EvuYLtp3ilqnugxLQJT6W1WdRpU1xFEJFjZ1yqJ83xgacy69Twt6L0DUInp0yxrMQvcKtxwDVjrAfMqKcvVyn/h47e6EaVIfbdTfhvPlSe3K15PVNQi0ONt2jwrpD6Rp0zZyGpcjMg3H2yGo3wqbfsoiK6HxQgIwC8fU8KDOCOg6ko5J3DSx9V3wbd6GD5XquLVfotEypnyvzkEWVAYEdA/vq9UFP9d39NbaeRhyN+PA5PzDpgvPiMgYGtXfjgRY0gtRTzNid0jUFMcCZ6vu5nc1X6zmfWVU4/2Xhi2Ty8P3FClAPu+nzfXFdpwzVVahmJeDM4yK5A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(4326008)(36756003)(6506007)(71200400001)(83380400001)(38070700005)(38100700002)(5660300002)(8936002)(86362001)(66556008)(2616005)(54906003)(66476007)(66946007)(8676002)(91956017)(110136005)(76116006)(64756008)(44832011)(66446008)(6486002)(122000001)(508600001)(26005)(6512007)(2906002)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?swf+JEovetKMpevzwOxPNqQnQNGqWDQ45AukTHhsJPWHkTrpMM2nzPve1r?=
 =?iso-8859-1?Q?Vu7kzIlUG9MMVIlUn2942aJ+WaaRht7MXpL/BYq9O7Mj3xNdWAJRqbPMTR?=
 =?iso-8859-1?Q?06mqAPLWF4PsLHpB544KoR1rQdwUo+Ir3R1Se+e07HHfxnNEkZ54kMw9Cf?=
 =?iso-8859-1?Q?xfkGUXUPLjK0OrApmg+uJaVH54s826bR7xbF5O8pEFbkpZY4eX2gNItbAa?=
 =?iso-8859-1?Q?/vvXwzmDq7mE25jk6q/q72zuz7mIpmLlKvfLAKmdGqQVBMda8xo7gPgdzz?=
 =?iso-8859-1?Q?O2Yi7HGtlABQqjJPw9ALUKulXDPVcMvW//sowKZJabxu/dXaBmtoHo7+Ca?=
 =?iso-8859-1?Q?QjV1Wrq8D3GfVCZ0Odlq8rcpwPCPWsIo5MJOFworIxUsHHNYhfpYRzSkiR?=
 =?iso-8859-1?Q?7j/FWT647YrcU3I8/pS8YsH+x05JC3Kq7Bc/cuyrm0nFHZ38JIj2JawYGS?=
 =?iso-8859-1?Q?0G397jXRRTu6ZjC5Wz7T2OUgw4bp2a7cs1+LOakWXsnHs9pvPD2LWrqrS/?=
 =?iso-8859-1?Q?Ov94o/ikm8Ya57+kT9gq5qdVwLDrbciAS5oZLj7JuzYblI2GFVAKQ0EbJw?=
 =?iso-8859-1?Q?nn5I3Ph+Q+/1aisSdjfkbNw4i3rvrTCaYnJaW/uArSqJntuKvHcHGT8EBb?=
 =?iso-8859-1?Q?CDGABfWuY6Qhci9abMkn2rx0aOctBaL/iA5gjaGkwsg2MLuPNygf0a1lth?=
 =?iso-8859-1?Q?UwIkAel56VnfuGB7UTKxSv07rARv9DQMZiCtZAxTASGZZ1xpXcLfrFjC71?=
 =?iso-8859-1?Q?83X7TKA40xvUpn6Kqr6LT2Nfp94SpPVdhhykDkGi0VtckRVjD5QZEy4mp1?=
 =?iso-8859-1?Q?p7xEF0kZYLnUQIbFd4g5DhlTBUOwyGzPFk4rbboS0foHKx+0vRRAMm3gXu?=
 =?iso-8859-1?Q?TsBniKSgfJquzOiJmXIT/epraKW6Xe0DOPJaNn45u9YM6zBNgj4g9LIfjP?=
 =?iso-8859-1?Q?gt0yQ1flwnLNnPSJlyXDdYkXwwO9YEg42MJyMnacPbRcnrxtRF53IbYuH7?=
 =?iso-8859-1?Q?zI673XrScgOnDdfNYGiR9ilGmD5HkMh/+bs1VaIP2BSBxYpn1HVVZu69h2?=
 =?iso-8859-1?Q?uP+wtfgTcYXIqbVtRU/N4plT03GgfLAV1io6nQdIW5ImAjUr4YJohSChzx?=
 =?iso-8859-1?Q?BesF1e8nLc6+DnmVnK8qndirGr3f1Uav3R7B4I1+xsmkt29UOlxO7dW+5B?=
 =?iso-8859-1?Q?wATswg2pvDOTyKHpUrj8zFeZ8lmp3Rmy00TCJFN6w1MOWfEv9/ujeR1n0i?=
 =?iso-8859-1?Q?GKwS7VLCAkeN9i0bnv9mB/NLQtkoHDiBwTnB75wEu2248A258qudgZYSdu?=
 =?iso-8859-1?Q?cf5XTAmMPmiGCp0/MBUQ++n7PXcgcD/zwUijshzrYZ6d3UWlUV0itvM2aN?=
 =?iso-8859-1?Q?eExfgGVhBAzL1xegXSmQQKoMmyLVteCwpHR/3nYs5xIjuVYNpyjUALt9yQ?=
 =?iso-8859-1?Q?ZBD5X9VuiXYRUGPH7RscoRExX0hjMMJTGZ7mZwTi6hiHX3Ie79qzmggQIP?=
 =?iso-8859-1?Q?J2te0ngOZ5sBH/xhkjb1WqWQxTFJrGnN5cL4V0T3h/Nev3cynPiuFqgfYE?=
 =?iso-8859-1?Q?/QCLOFl1eiwEUfYFWxlt4vdhxJYTzuUUUyLVrTPgV0ym+svay71sZZ0a+y?=
 =?iso-8859-1?Q?cFGdfWBsreVikgKaEmEOQLt6VNfo1+LKpsIar4fVmdutQwpj9iIJoIYUaA?=
 =?iso-8859-1?Q?5/3nwuCLNNmjMSd7656VPjgDvoSV8BcuFlRi2hSWWKf99h+Q/YbTESwNOf?=
 =?iso-8859-1?Q?b3YYy/129jO+tR3xD1Pgwu5ps=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: e29c33a8-a917-4a3f-8e06-08d9b94836a5
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2021 06:10:05.4193
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Fp7ahaKA/V71njNBYxht/5H0y0yQZgxQQdsTD5ao946U7IDd2BRX/Jy7RYwaC6UrslRT6klCXBMflGxIDHph7+ApSGe31akZVHXFLfc0lOo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MRXP264MB0808
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Allthough kernel text is always mapped with BATs, we still have
inittext mapped with pages, so TLB miss handling is required
when CONFIG_DEBUG_PAGEALLOC or CONFIG_KFENCE is set.

The final solution should be to set a BAT that also maps inittext
but that BAT then needs to be cleared at end of init, and it will
require more changes to be able to do it properly.

As DEBUG_PAGEALLOC or KFENCE are debugging, performance is not a big
deal so let's fix it simply for now to enable easy stable application.

Reported-by: Maxime Bizon <mbizon@freebox.fr>
Fixes: 035b19a15a98 ("powerpc/32s: Always map kernel text and rodata with BATs")
Cc: stable@vger.kernel.org
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
---
 arch/powerpc/kernel/head_book3s_32.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/head_book3s_32.S b/arch/powerpc/kernel/head_book3s_32.S
index 68e5c0a7e99d..2e2a8211b17b 100644
--- a/arch/powerpc/kernel/head_book3s_32.S
+++ b/arch/powerpc/kernel/head_book3s_32.S
@@ -421,14 +421,14 @@ InstructionTLBMiss:
  */
 	/* Get PTE (linux-style) and check access */
 	mfspr	r3,SPRN_IMISS
-#ifdef CONFIG_MODULES
+#if defined(CONFIG_MODULES) || defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_KFENCE)
 	lis	r1, TASK_SIZE@h		/* check if kernel address */
 	cmplw	0,r1,r3
 #endif
 	mfspr	r2, SPRN_SDR1
 	li	r1,_PAGE_PRESENT | _PAGE_ACCESSED | _PAGE_EXEC | _PAGE_USER
 	rlwinm	r2, r2, 28, 0xfffff000
-#ifdef CONFIG_MODULES
+#if defined(CONFIG_MODULES) || defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_KFENCE)
 	bgt-	112f
 	lis	r2, (swapper_pg_dir - PAGE_OFFSET)@ha	/* if kernel address, use */
 	li	r1,_PAGE_PRESENT | _PAGE_ACCESSED | _PAGE_EXEC
-- 
2.33.1
