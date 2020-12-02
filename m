Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40E372CB58C
	for <lists+stable@lfdr.de>; Wed,  2 Dec 2020 08:12:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbgLBHMA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Dec 2020 02:12:00 -0500
Received: from mail-eopbgr00105.outbound.protection.outlook.com ([40.107.0.105]:36930
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725912AbgLBHMA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Dec 2020 02:12:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cZKWx6zvCNY4ly2RtbAyw//wRfxHHoNRknxMULiJeEuirieNjgBAK62aOf69KYN58NrUe5OLLc8u1V9NnGl7QEfvidPZYw7EtmbTjWBA45pOzDpcg5l3aDbgwgP0QlQp31NYPdbbrOyCCvkSX2Ppuf3wkvVa/VQ7MTgOUh1ULa8m3s8wIILfcbQpWOoL85V0MNbnghMIhY2fGU2CmGrGfd2QLEma45NnCvcf5lRMxw+Iae6unh0lsOUPamXr1Qr+KtrzXEWV+ucwTv1XGNMFCjljod9XaDvjOpphSwrsznJXLHElPKmXmuWnZZumxAoDxn6laNp3NsvUOvJfDuoiig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h9Ff4uluzavrBanx+ZMKSgz0DRRyVzNpX56BZOKaD1E=;
 b=l1/NSZtV4LkxAspRuLmpO760PtTkGP6Htsrn54tn+BmqB7zRmrmeXhtnW7iSa7uAnwtnpwclOQ/m9mL/MYhhBeLvpiPjuyBVKAo0hXfGeE3v+/LWG6J5ayModmkvvZNFE001Pce8VnEPoEGg8a8WscC83PnxCT74jNygcoz/SykEcz5r39396MTVotPWz4hMqJFEsNVvmmbJxzEBw3k0UyLFtcwYBkG9gJDQVqp4yf4eMPIt+OV6LO1/DKOu8bs1XcUkKPV6L1eLueq4dgAfGyxZ9qvinHiFt3ey8zUjNCn0PGpsiVUx7UMfxgPFRsC5svQOvkTt1/TcoY5mbfdHow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=leica-geosystems.com; dmarc=pass action=none
 header.from=leica-geosystems.com; dkim=pass header.d=leica-geosystems.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=leica-geosystems.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h9Ff4uluzavrBanx+ZMKSgz0DRRyVzNpX56BZOKaD1E=;
 b=GNWHt+EUq2ffW3UfUbHsyRBjVYzlVCg2tLuvTARSdf5Rp7R3nEERU9nZtcaHJk0LjHWYmALTFRG/WNekQGzjR8rLVWrg05/8V3119oF9dfOMEM4ClOxxJXJZ03jDN0XoCpiDsweEwF8sB0o4gJvKOUDwWRY9YJsjFPZk7aJwtHc=
Authentication-Results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none
 header.from=leica-geosystems.com;
Received: from DB6PR0602MB2886.eurprd06.prod.outlook.com (2603:10a6:4:9b::11)
 by DB8PR06MB6234.eurprd06.prod.outlook.com (2603:10a6:10:10f::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25; Wed, 2 Dec
 2020 07:11:11 +0000
Received: from DB6PR0602MB2886.eurprd06.prod.outlook.com
 ([fe80::49c3:4b5b:289c:d62c]) by DB6PR0602MB2886.eurprd06.prod.outlook.com
 ([fe80::49c3:4b5b:289c:d62c%12]) with mapi id 15.20.3611.025; Wed, 2 Dec 2020
 07:11:11 +0000
From:   Andrey Zhizhikin <andrey.zhizhikin@leica-geosystems.com>
To:     jens.wiklander@linaro.org, op-tee@lists.trustedfirmware.org,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH] optee: extend normal memory check to also write-through
Date:   Wed,  2 Dec 2020 07:10:57 +0000
Message-Id: <20201202071057.4877-1-andrey.zhizhikin@leica-geosystems.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [193.8.40.112]
X-ClientProxiedBy: ZR0P278CA0037.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::6) To DB6PR0602MB2886.eurprd06.prod.outlook.com
 (2603:10a6:4:9b::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from aherlnxbspsrv01.lgs-net.com (193.8.40.112) by ZR0P278CA0037.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1d::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Wed, 2 Dec 2020 07:11:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 85f97660-a0c5-4266-b312-08d8969172af
X-MS-TrafficTypeDiagnostic: DB8PR06MB6234:
X-Microsoft-Antispam-PRVS: <DB8PR06MB62340FAAB36A00EC19F18B01A6F30@DB8PR06MB6234.eurprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xkhkH2KDes4EMcI1W17BrskGOdZczqCOg/xvDKibJSE/LHSW3ds/DeSNlHK3tL7xsWawdeVy+6HhGq4S1yHsKLPJSDnlTXWYs8oDj/XoBaNxj533tRPa3ujaFPZMb4wqYShDlxGCMG3+MFUU7r29XmNte8faM8iQV21qsgUHEevaBIl3KGoWjJHaltHEWKymt+/TsHa1Ajil6NEi/WNn+Y9ra6kMEFFbOXh+y783pMiAAMtNb5qSKRjdH7X5vN8usQwPuc3fPOI5LvoMASyY+Fw0cFUle+0tI0+7zY0HlM4lLu8BLeaHKqoVlS0h9rylUh5hHqqEDxw9NutiTLXzTiyV6yFC1jy9mtezO7UzCs65ld5oUcwhL6h3cxCeK8J+hLYIQp//mSnQQ4A94AcYfQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6PR0602MB2886.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(376002)(136003)(346002)(366004)(6506007)(2906002)(1076003)(186003)(2616005)(8936002)(966005)(956004)(5660300002)(6666004)(26005)(86362001)(52116002)(6512007)(83380400001)(478600001)(16526019)(66556008)(8676002)(6486002)(66946007)(66476007)(36756003)(316002)(44832011)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?HToZMWI259zZRvtyiplWqupQxx65XF/TJF4EjiAyl/uoU8ZmbT2sC6LCVNEX?=
 =?us-ascii?Q?Uny9xJnKc7ecyY9m5HZtFmAlTSU30y/wq9LXW/J6T7hQNkUMjsjkCXNBLyXw?=
 =?us-ascii?Q?pfUI96ip6e+7VG3tsjO2gGlieD24TTsj0j2njlCr4XeuQlXKWO2NZMLK3Imw?=
 =?us-ascii?Q?YRJlZLH5gnHt7v+h/Yr6M8I14KIwB7dBunQLZnC0uFHHpSTRa1nah0A85ceT?=
 =?us-ascii?Q?lB9ZX77RyEnEJ+FViQfvwjo4k9S3Q3iOMnCOqhRpbdvElk1jkQOJY8d2fxtl?=
 =?us-ascii?Q?FcbSr4cWQEw/SDJ4YQfg75mGHpmjPZHw7RaDOJ/bXSKNyrJEzW9TvC39rm2T?=
 =?us-ascii?Q?AZ6ke5uTioqSNBSY4pAxNa5UiE0Z0aof69yUtahYgfQP7WPaOpGdXfLrAYLh?=
 =?us-ascii?Q?LIFPIoYBr6m6hW0ruoYOx83wVPwchJN08PR8eU5qM7UOXPYdrQrZPmmjS97i?=
 =?us-ascii?Q?WIT5bj1zREQR4Nt5Ge9CBhxSEsCDRIW1nOiDffMdDlv10DSNJpQXziH/4Xg6?=
 =?us-ascii?Q?k44YMuoY7/gZrGje2ErSLQ8iii8JUaYmbGeBmTho908fJTTeLfUsDIgsDRYE?=
 =?us-ascii?Q?vGoOmu+lQy9MK6KOuaOyFkIoYore0aFPuQziPAUiHl8BHrN3pJgs+DSl3VAX?=
 =?us-ascii?Q?JRAV29ZLgRcDxY02KdeAzSr6ROHsTRuPXW/QYB6gvEd9SDtU3CkXjCKpI6bV?=
 =?us-ascii?Q?yA95J+UYF0VOqsyO6LM4lL61+Q5bVeOebYEEPtjmgH2kXNjpto8cwqEl+6mF?=
 =?us-ascii?Q?eETwR0aDAP4z94RP6GWxU4erSp3E0jU3EGPzgWEKr3CJHPLJwKmVig/2Cil6?=
 =?us-ascii?Q?NSgC0nXbZwD5jYcAte19xQy/hK5zkJDsidYrANyq2uVqHzQ1dnSMI0uh3Km5?=
 =?us-ascii?Q?ZaKQQjjmL6cIfp9OYjHb7qYa4VsNDhJKEqzyBUTgPzQQpzOnsWH7Fwe56gD8?=
 =?us-ascii?Q?b6Q2uu2ou2VVmo/jFEnSkwYn+5pqKSrIoUF1HtwFAxzJbFahArnVhtIRM7zr?=
 =?us-ascii?Q?zPbr?=
X-OriginatorOrg: leica-geosystems.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85f97660-a0c5-4266-b312-08d8969172af
X-MS-Exchange-CrossTenant-AuthSource: DB6PR0602MB2886.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2020 07:11:11.4335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1b16ab3e-b8f6-4fe3-9f3e-2db7fe549f6a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: noE13jn8lkytckTME+Rlyo/vbQjvubBxb8lXM2uhljQvxgQaZqcGG0623JWrA1sv+DBT2JPmkybxSodF0tkGWgoRfH5gkFnUuqk1D+z9p88=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR06MB6234
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

ARMv7 Architecture Reference Manual [1] section A3.5.5 details Normal
memory type, together with cacheability attributes that could be applied
to memory regions defined as "Normal memory".

Section B2.1.2 of the Architecture Reference Manual [1] also provides
details regarding the Memory attributes that could be assigned to
particular memory regions, which includes the descrption of cacheability
attributes and cache allocation hints.

Memory type and cacheability attributes forms 2 separate definitions,
where cacheability attributes defines a mechanism of coherency control
rather than the type of memory itself.

In other words: Normal memory type can be configured with several
combination of cacheability attributes, namely:
- Write-Through (WT)
- Write-Back (WB) followed by cache allocation hint:
  - Write-Allocate
  - No Write-Allocate (also known as Read-Allocate)

Those types are mapped in the kernel to corresponding macros:
- Write-Through: L_PTE_MT_WRITETHROUGH
- Write-Back Write-Allocate: L_PTE_MT_WRITEALLOC
- Write-Back Read-Allocate: L_PTE_MT_WRITEBACK

Current implementation of the op-tee driver takes in account only 2 last
memory region types, while performing a check if the memory block is
allocated as "Normal memory", leaving Write-Through allocations to be
not considered.

Extend verification mechanism to include also Normal memory regios,
which are designated with Write-Through cacheability attributes.

Link: [1]: https://developer.arm.com/documentation/ddi0406/cd
Fixes: 853735e40424 ("optee: add writeback to valid memory type")
Cc: stable@vger.kernel.org
Signed-off-by: Andrey Zhizhikin <andrey.zhizhikin@leica-geosystems.com>
---
 drivers/tee/optee/call.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/tee/optee/call.c b/drivers/tee/optee/call.c
index c981757ba0d4..8da27d02a2d6 100644
--- a/drivers/tee/optee/call.c
+++ b/drivers/tee/optee/call.c
@@ -535,7 +535,8 @@ static bool is_normal_memory(pgprot_t p)
 {
 #if defined(CONFIG_ARM)
 	return (((pgprot_val(p) & L_PTE_MT_MASK) == L_PTE_MT_WRITEALLOC) ||
-		((pgprot_val(p) & L_PTE_MT_MASK) == L_PTE_MT_WRITEBACK));
+		((pgprot_val(p) & L_PTE_MT_MASK) == L_PTE_MT_WRITEBACK) ||
+		((pgprot_val(p) & L_PTE_MT_MASK) == L_PTE_MT_WRITETHROUGH));
 #elif defined(CONFIG_ARM64)
 	return (pgprot_val(p) & PTE_ATTRINDX_MASK) == PTE_ATTRINDX(MT_NORMAL);
 #else
-- 
2.17.1

