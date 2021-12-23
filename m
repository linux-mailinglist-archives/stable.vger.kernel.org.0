Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4396247DF7C
	for <lists+stable@lfdr.de>; Thu, 23 Dec 2021 08:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346801AbhLWHVY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Dec 2021 02:21:24 -0500
Received: from mail-eopbgr70111.outbound.protection.outlook.com ([40.107.7.111]:53319
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235223AbhLWHVX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Dec 2021 02:21:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GE9xjeK8ySiCnxlTG4RQvLRG4KUPilD8X8MM2sNmkOd4UHwGMroqN5N8681OlVhvNfe+N8HLeud9rb23XQLrs8xjlWzlsMgqI3ik4BiicFz6IL6bLaCP4tOSc7wuEEarQeiVm0amn8DO+yZbzJiEF6GSdrbRNkadNRNJjOkgRHszIWKfl6SJYK1k5pXFsaPlXCJDp3B5F/USWYRptTpceHI937K2PPT4/EsiCUEF9FFXPQ+tKME1PWBQOWZkp1GLEsMIntugZI0flIB2vtm/FdLMPZ5oPveRWiISm+e38HW34MgbEmm6/LauHWQ737NopqDUEhm429KE/AD5G3xObA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5kJeGaPsy5tTXCZd5+pbLAcBEUqRCThMoJVOIOdzUME=;
 b=jdspNZCsUp71hC9At/0TIby36/jl34OVseyBHqie8wqKDNvZrZXq4Ses2A/Bs3qmdiZA1fywT1VeGbujlx9Z4wZ960B8eJ1D9qnKwxAZpmErfWqYv8P4vWw9yGTC1QqtIevAmUmSe09/ZIB21s72GzKsuaXhhdsFs8mW7VjSSL8/hi7cjXZNw4G2zxhf8Rz+dR3GUwYfVtL16fr4RiRFN8Uj8Z1JkP/15IMD0sMSSCGT358C7UNLMo4VThAZ+HVh7vtgiTWjoJPU6euR4OR8nuBgySoSYvB0nGqi7oRuphIWq2qozTIOUmO4yc1sXpxI+ROYoyCZ+wQlERj1L1+q6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5kJeGaPsy5tTXCZd5+pbLAcBEUqRCThMoJVOIOdzUME=;
 b=eGujpbaUce14NuyBJQaBa3qwg2qDSup7J4n43DCTWcSTF3OUmDEBWOZE+vtkM9vqIyJ8O5FBw+54dPAariaAlQ4/cPWb7OOnrU/VyqbqqaobURdrNjCVsy6IzarqnZt7ecDo2PgbKowkmxm4u7W5fCgkwiQhPp9JhpaU36Gyvw0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from DB9PR08MB6619.eurprd08.prod.outlook.com (2603:10a6:10:257::21)
 by DBBPR08MB4332.eurprd08.prod.outlook.com (2603:10a6:10:d0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Thu, 23 Dec
 2021 07:21:20 +0000
Received: from DB9PR08MB6619.eurprd08.prod.outlook.com
 ([fe80::347f:d385:ec53:75aa]) by DB9PR08MB6619.eurprd08.prod.outlook.com
 ([fe80::347f:d385:ec53:75aa%7]) with mapi id 15.20.4823.019; Thu, 23 Dec 2021
 07:21:20 +0000
Subject: Re: [PATCH] mm/util.c: Make kvfree() safe for calling while holding
 spinlocks
To:     Manfred Spraul <manfred@colorfullife.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     cgel.zte@gmail.com, shakeelb@google.com, rdunlap@infradead.org,
        dbueso@suse.de, unixbhaskar@gmail.com, chi.minghao@zte.com.cn,
        arnd@arndb.de, Zeal Robot <zealci@zte.com.cn>, linux-mm@kvack.org,
        1vier1@web.de, stable@vger.kernel.org
References: <20211222194828.15320-1-manfred@colorfullife.com>
From:   Vasily Averin <vvs@virtuozzo.com>
Message-ID: <3ca4dec8-f0bd-740f-73c8-34fc6fc1cf66@virtuozzo.com>
Date:   Thu, 23 Dec 2021 10:21:18 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <20211222194828.15320-1-manfred@colorfullife.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS8PR04CA0100.eurprd04.prod.outlook.com
 (2603:10a6:20b:31e::15) To DB9PR08MB6619.eurprd08.prod.outlook.com
 (2603:10a6:10:257::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 57abe299-54a1-40b4-7bf6-08d9c5e4d105
X-MS-TrafficTypeDiagnostic: DBBPR08MB4332:EE_
X-Microsoft-Antispam-PRVS: <DBBPR08MB4332AC9205ED0BD5EC01B3A6AA7E9@DBBPR08MB4332.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 65u5ho2xktnoUTIS0Mv5KZbv7sBOvtvu/3Ree12XI67DTdkwjqOcz3NaXrs3S8yRyn1L16mg31k+JCgMYombPsZjYFa6NXUo8z4/BccxZrrcAq2GKZ9hDezySZRKOCKztjTfPJdi3x93ZXyXICS0lZIFVmj+qsNi9SYVEYf2M+PzRGwhtY1a2oTduatuavqoWj2Pu9UlM4BtatYIAg3Qhnu1CArRQAembcb68/8wzPi4aPYrKSJGBznRvd6fnTXErTA3DhUoJ9HoDplJp9h55iGvEmbwOL9mEZxZ3R/FCi8L9yZcp0BWYRlPjR6i9DYIGaLbel3MeoP1US5j3aApJLBcY/isSnoASESHkOU1spWWWUbHs7+kmFAfOTEzYlKLOP6/RyX3savzAHwZMSyem3M2B9ORuXzb+peaiTrgw9+kXTCfFG6833DAo2u9s1FfAGz8Mkp4BXlm5TKPda2Q2H2P9RKzXWe02xn8KaIdVVT/ZeBBOI5JY6IFimx4xDcg29bRbzOdbps9LOeTV29QSqzLVDFfq+LYPA3PQv8AR4xViyXZ81YPvny93ofsm/mM55UDz42eYTmffq5OK4KTO9bFTmVeye7W+OJHm/btfcpJSsvD2o+1PBSwr26WWduPOlgpIogH63u9LWjyBBqVT7V0wMMh5b03lugiZ/bP7kR7P9NStCg2Ea+/qYZgvd7h2y6bIxwsshrneJuX1+TuNUkyCIm6crRoHMftF9N2wRl6GVYDWJNuFZq26JYVFlXMJvI+q6mtTkfN0USAOiiDI+pO/zI3GnBSBJOkfeH60/83r3Z0raYRio9S+bT2kzfA7+vo0LfPIRw81C2XWcu8ww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR08MB6619.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(6506007)(966005)(4326008)(86362001)(31686004)(8936002)(6512007)(2616005)(186003)(66946007)(5660300002)(66556008)(508600001)(6486002)(110136005)(66476007)(8676002)(7416002)(53546011)(26005)(38100700002)(36756003)(31696002)(52116002)(316002)(38350700002)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bmU1aTI2NWl1aXBOd2ZQUWZKSXk5NXN2R1RXT29uZy9UZ1BMeFg4WElmRTZy?=
 =?utf-8?B?U1gwQ2d2dmhWbUJiTDJxc3RJQlp2ejZPUGIyaHRlT0FweEFpbzZpQnBrTStq?=
 =?utf-8?B?UmVOdUVMYzBTZWpPZ3RSVTZtV3pEenZVNE4xMzRaYjBmOHRCNGc0NkI5ZXpi?=
 =?utf-8?B?VHJlZDRSUEo3dVpuOVcwNkoyTHJpSUJlbjdJdzVtZ1BIWCs4S3diRkRrZ2NW?=
 =?utf-8?B?TndvaDIyS2xqME9TMGtGaUFGdDh5YndJemorUVptYnA4WG1uWUx0U3Y3ejlK?=
 =?utf-8?B?QVFrVmNvWU52dnFDMU9adGdnMTZsMGRYcUJaY05YQy9UQmE2SE9rN1BwRWpD?=
 =?utf-8?B?cG9LQ081cU5EUzBLeVB6S0ZTdi9jSDVheFBGNXlZeGFPeU8rNzJPanZtbVB4?=
 =?utf-8?B?aTlxQWRBM2h6b2tuU0pzd0xjL2ZJeW92QU8wQTRRMG5icXdsTTFtMDZzdkFQ?=
 =?utf-8?B?MzV2emorS0NSRTVmeWRLUTZXSnl3UTN0QzFKZjlZRkZCODJnNTFUcVNCRXU2?=
 =?utf-8?B?WGhoVFFmWnpWSWRDeGlORzluZi9rR1YxUjZNZFBqcVpyOHBCVDM1MkFVQXc0?=
 =?utf-8?B?TXFia21oM1VyS3A3RkI5S2FWK1JEQ0t4Vk5rQjBkS3pnSFV4eks2SnFNTElu?=
 =?utf-8?B?bG8xVFZoa0ZmV2lIZk5JRkpuZWZsR09DRnd6RXM0VG8xT252bEFDVGcrb2tn?=
 =?utf-8?B?Nm51ZlpFNlNGVTl1WlVScTJNODI0eWRvMlplTll3VjhVNHdQSE9hTERYYXRj?=
 =?utf-8?B?OHFKenVaZjVUQjNQY3dNTUtxUDVEM1l3SDZVckR0T1NhSUwrNklBRnZpaGxq?=
 =?utf-8?B?RzhpcGtITkpNTFVWa0RnVmtEUlZsdk0xMlVoOEt2MjdWMCs5YVp5K3V3MzV1?=
 =?utf-8?B?dWtKcDl2VXJzYWF4UklrM2NVekdtOUVOUjlQVXVrVE0xY0RxTksxNjBRRE1D?=
 =?utf-8?B?ZldwQXVXeDNNTmlndGRmMkxCM1F0end6dldpVEQ5Z0JXRDN0L0x4dm9yZE1K?=
 =?utf-8?B?SmRvUC83NVN1bVFyWnlFY01SRW1SNHQ3NUdnSERjam1YTWM1Q01rNjI1eTZr?=
 =?utf-8?B?ZnVmWlpqSUI0Q2lxSHJHaVRrRk10eG1KMXFJd2liM1lPdEE5NWtscERZSzM0?=
 =?utf-8?B?Qm1mK2lDTzB2UDdWMmV0TmkrT1dtNlNCVmhLL1JXQUowNUNYd0hEQ2VtOG1q?=
 =?utf-8?B?MlF0YWQvdFR0WU5vTlk3dDExVUkrTzBhVlhyWDlLdVdwVmErZno1YXdLcE1I?=
 =?utf-8?B?MjRIWXVoWjkydytWMUNieTZ6RDFpQ1ZSR2JMSG5YUUFQeE1lM0swNDlYUm1P?=
 =?utf-8?B?MC9uanRPYUtKSHJicWMybGhqZ3o5NThGSGJsZUxLdm1IbXhzZndSaXduWlZW?=
 =?utf-8?B?djJEUFRldkdCM1NnWWV4Z0s1VGtFSnNDQUZYY2ZrRjl1eXZYaFc3VmxDZE9x?=
 =?utf-8?B?dUtnSjJENW1OZ0tPdFgxdlhwd2xwMmxvVWZoNmtFbUR0dXMrWlpLR3E0ZzRl?=
 =?utf-8?B?azdkYUhTQUMzSER2dmVmZW5uTzFmZHQxREZMVHBXSDNLMy9ockgxZnFUTTVp?=
 =?utf-8?B?ZVEyREpBOTdsaitpL25rMy9seXJ4S2EwVmJiYnAyZ0dTclBLcWx4RTJ4Kzhv?=
 =?utf-8?B?UXpWSDBWV2NVYjErMm9lS3JadmcwakJjRUgwSG1hSy9ORHJIb0RSZ01NN1Ey?=
 =?utf-8?B?b0RnenhHWEFsbGtNbEFOWDIzOTRtQ2NOTWd1NmVFN09jVzMrdTU1OWpEZG5C?=
 =?utf-8?B?Ny9MRjJHUi9QM1ZQUmRJVU1YNGZjNzRoWmNVU3hHRE82RzdDcElqSDlwTThi?=
 =?utf-8?B?TEpMS0ZLSmZBRjJRQURjNUNWVmZWdWZwajNkelA1U24yZkptZytEMHV2LytE?=
 =?utf-8?B?ZjNSUHVTU0dYMzBCcFFDSk53aEZxcUk2TXc2a29BUkd5Q1REaDQ5eWRtWVhq?=
 =?utf-8?B?cmRadzh0Y0drUDJsVFVDKzVabm43VFJTYnFDczVWdEJrN0pnS2VHRlhnSkNk?=
 =?utf-8?B?a3JPYzU0cUxDa2FPRmdodVBWb21udWtsbEdtUkk3T1dWdHZ3RUpXalpSd1Rr?=
 =?utf-8?B?b3c0dmhiL1JyZ3ZTYUJJaGRRT2cvZ3ZDWGhVQVlpYjdLTFpmTWpCZVRjWTRq?=
 =?utf-8?B?SWpZTGx1dy9kajBSd3dxblNFL3BqcnNDcTlSSW96Ri9KNmFuVEtNMDltMTdM?=
 =?utf-8?Q?LQl6O3YaQLAhop5G3/1aYfY=3D?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57abe299-54a1-40b4-7bf6-08d9c5e4d105
X-MS-Exchange-CrossTenant-AuthSource: DB9PR08MB6619.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2021 07:21:20.2765
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SR+MQIzryvydkC8bIwVEMm6yIJNrsU2r7EZpjKpK5lpURn15OY5KRFccxImmXc04djIf47UOlxdnmEKVZJD6FQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB4332
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 22.12.2021 22:48, Manfred Spraul wrote:
> One codepath in find_alloc_undo() calls kvfree() while holding a spinlock.
> Since vfree() can sleep this is a bug.
> 
> Previously, the code path used kfree(), and kfree() is safe to be called
> while holding a spinlock.
> 
> Minghao proposed to fix this by updating find_alloc_undo().
> 
> Alternate proposal to fix this: Instead of changing find_alloc_undo(),
> change kvfree() so that the same rules as for kfree() apply:
> Having different rules for kfree() and kvfree() just asks for bugs.
> 
> Disadvantage: Releasing vmalloc'ed memory will be delayed a bit.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Reported-by: Minghao Chi <chi.minghao@zte.com.cn>
> Link: https://lore.kernel.org/all/20211222081026.484058-1-chi.minghao@zte.com.cn/
> Fixes: fc37a3b8b438 ("[PATCH] ipc sem: use kvmalloc for sem_undo allocation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
> ---
>  mm/util.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/util.c b/mm/util.c
> index 741ba32a43ac..7f9181998835 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -610,12 +610,12 @@ EXPORT_SYMBOL(kvmalloc_node);
>   * It is slightly more efficient to use kfree() or vfree() if you are certain
>   * that you know which one to use.
>   *
> - * Context: Either preemptible task context or not-NMI interrupt.
> + * Context: Any context except NMI interrupt.
>   */
>  void kvfree(const void *addr)
>  {
>  	if (is_vmalloc_addr(addr))
> -		vfree(addr);
> +		vfree_atomic(addr);
>  	else
>  		kfree(addr);
>  }

I would prefer to release memory ASAP if it's possible.
What do you think about this change?
--- a/mm/util.c
+++ b/mm/util.c
@@ -614,9 +614,12 @@ EXPORT_SYMBOL(kvmalloc_node);
  */
 void kvfree(const void *addr)
 {
-       if (is_vmalloc_addr(addr))
-               vfree(addr);
-       else
+       if (is_vmalloc_addr(addr)) {
+               if (in_atomic())
+                       vfree_atomic();
+               else
+                       vfree(addr);
+       } else
                kfree(addr);
 }
 EXPORT_SYMBOL(kvfree);


