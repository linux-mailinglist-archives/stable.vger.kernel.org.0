Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC04395792
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 10:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbhEaI5a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 04:57:30 -0400
Received: from mail-dm6nam11on2061.outbound.protection.outlook.com ([40.107.223.61]:40801
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230462AbhEaI5a (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 04:57:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n3d6k7a3A1aruf0HUTz5El5ivPJS6N1zAWvxX6nSOrT3zQy2lQZl9EvwQ33njxqE5YU0mt0EUN8EkHN7a3PJ8HwQAI/kDg4NC4quKENo/2w3EcOYjCKRFzknJ5XdsLr6/SmS9WjPBdaS4vU8fP8gut+ROF9/JWAmjIIy92UJQqrgWsyQYBUK6deT9YjZkdGdOAWN89Rej/L38AnVoFIAFA7qtQCwww5IbX5qCJjlw0x3X/Izutm/SRizVUKhY8hmBbbKxWj5vXHRn6u39skTFxZgnLA+45EZ6qtchfNDrJM4+tfAV34Bfbz7JLMySuHnhU7ZymR5KxOjSw75TtN8+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/htSl0MYARa+8GQBgvvKXM6dGKkum5beCddfDleiJXA=;
 b=RPtP0eoDv8LS5KsGA7LvC617naM3V7ynEGwraxnWVSRYNuQUT7gxOJ8rTQeo3r7imF8qKJan5sAALrWYxWiXaOzkmFyoJOf8KnEzirfZh6EtqTLAFm7vi3tBSCtUNIt8K8qo7LueBmMtFGZZ0ycitcRzGunn+uJ//WmB7yk9QPoq2Xy2B9yE1L2DzBzJ2xTjLz9ffaN5HnBJrVIXLP8y6YPXef9Th1g2vCg3m/wFyaOQ9Ph36YJuZatVDZkXqeHBPMVoGGH8yMW92e9U6/pWPdrRKtHL7acPMgTqAvp7Qidn7m4ubAX3dtTDEF1hYcBd32H71RNc1JG9RVUYm2+mEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/htSl0MYARa+8GQBgvvKXM6dGKkum5beCddfDleiJXA=;
 b=TnVScShKfbpK7aBUtv+YHaoHauDuyoFZzsZqTAmYp0G+j608Wla0suq16kDEDRHw855PwsZO8M1XTQ0UIICsYsyvWkLC0/Mm8TdZoTcbhTgCshX4RX+Dy8McG7UvZncjPzkqmxg48UByv1Y6EozeYdyU/CkmD3QbWqfW3ZPWEiI=
Authentication-Results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=synaptics.com;
Received: from BN9PR03MB6058.namprd03.prod.outlook.com (2603:10b6:408:137::15)
 by BN7PR03MB3460.namprd03.prod.outlook.com (2603:10b6:406:c1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Mon, 31 May
 2021 08:55:48 +0000
Received: from BN9PR03MB6058.namprd03.prod.outlook.com
 ([fe80::308b:9168:78:9791]) by BN9PR03MB6058.namprd03.prod.outlook.com
 ([fe80::308b:9168:78:9791%4]) with mapi id 15.20.4173.030; Mon, 31 May 2021
 08:55:48 +0000
Date:   Mon, 31 May 2021 16:55:38 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc:     catalin.marinas@arm.com, elver@google.com, mark.rutland@arm.com
Subject: [PATCH stable 5.12.y] arm64: mm: don't use CON and BLK mapping if
 KFENCE is enabled
Message-ID: <20210531165538.60482a70@xhacker.debian>
In-Reply-To: <162229637024181@kroah.com>
References: <162229637024181@kroah.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.147.44.204]
X-ClientProxiedBy: BYAPR02CA0059.namprd02.prod.outlook.com
 (2603:10b6:a03:54::36) To BN9PR03MB6058.namprd03.prod.outlook.com
 (2603:10b6:408:137::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (192.147.44.204) by BYAPR02CA0059.namprd02.prod.outlook.com (2603:10b6:a03:54::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Mon, 31 May 2021 08:55:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: edef67fa-3b63-4dd7-e824-08d92411e249
X-MS-TrafficTypeDiagnostic: BN7PR03MB3460:
X-Microsoft-Antispam-PRVS: <BN7PR03MB3460CE7F058F59AAE7946733ED3F9@BN7PR03MB3460.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LNbjpwjS//nPJcYuyBieLT/N+OWshU0pV3AkgggeyNR5+UzssGLlCEsCB0PjSgq7FE8Ak9GonLSv665ZVdNPRE8Tg97pmi3+JXqpeo6H2Dl4VCtVjAbJf35yNl9hRCM6AVtLz9v1l5HF3mHHQtzhrmx57TkOwjSfUrDT/9SOjgXUqUGRBJtyKUbkWE6ZmvyUuMSGrkyqm0bMi+1fOiRbn0x6+UfTPHyIbrXq6wXsI7y/u5Bh4CtI2DuurWNoxdenB0uS+ylmIhU0wsMd3CwHNhfhFDnR3/PyY3ptWvwoiaTR6pK9IrdCLqzsC9MDoEyRNWxDgR9+VxXYuJYHA9iq38drkhMWESxbCXvkuVs/2B1We18CLesvUF1+l0ogAmnE3FwjiBLzxDKCQtr4t0FvHSf7MMK8sWLFJIm/LvJTFkdPxysDD4zpuEVzG7Ey1QpbCgkkyI5eoe4ivvtD4+aW0LtmWBUIFWIfZj35M0RSMnEavBymJyWSJCn0wMk5gaRvCwJ240y8wBuhUAURPuRIWD0HlYzfzUx7o7/eBTV+FMB5Gk0TJ3KcIOvk5tCoRxdj4/LCeZ2ielDRS6sBed/bkrr3orsQBc0k9I7DlMQSWX6Q8VDP2Fo4CCssRtq/HPaGTCEY3ejwerxQ3UQ6y2LvN7NM3SMA5ygM+V9NbRSumqdou9lr6Wjb9Zrf2e7yanVjyHnz7seFMa6qgceQmwSL1VstFxHFxejPM7K5rbPirwwIAY+X/kC2BUaJq+5c1K3IjvV8+u5r9zrbOaUVJkKomfWd0+ECshViDb5+sv/U8Ac=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR03MB6058.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(376002)(346002)(366004)(39850400004)(966005)(9686003)(2906002)(6506007)(52116002)(7696005)(478600001)(6666004)(86362001)(4326008)(26005)(316002)(8936002)(8676002)(956004)(1076003)(16526019)(186003)(5660300002)(66556008)(83380400001)(66476007)(55016002)(66946007)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?dlEEqenyLF4P5i5dSVpEDbor/9ZriBgUsljwyKSJDLFwU95Z2v4DuOVIshPO?=
 =?us-ascii?Q?2moQaj9o3m/Hh8l9t+XFA6Trkz6pyJQEreWpCM+MK9Vj6Ln9lOgvTVXHLGz1?=
 =?us-ascii?Q?s0mkdt2xU95+Cu1ZnF1O+6x4siPuzFzGFaiseA4y4+YAjVA9UgdmxpvLsHEs?=
 =?us-ascii?Q?RJFi+VwpE7jQIFlxnN57p1QhA3fP6u+kyTtH+A2rflDYg1QPHtgOxSg+Dryw?=
 =?us-ascii?Q?7FUOQDxNcoLxANHdIEbw2Cvji0adaaOdMRARzwoqpTM71Srrqy9adXBgoJGx?=
 =?us-ascii?Q?V1b15pukaIHz9BXX1aY33Kt2rCG5nfPoDBfY1PMdEgVUfsTbRvWWKSq6h2Wz?=
 =?us-ascii?Q?D8HYRrKqgrvfSYTfjcfp4vY3QmtKv2XzuOK/LO9yGPV67ROWTUume5eAzOba?=
 =?us-ascii?Q?bqTE53LAp00fsRwxbjMITZROZ1/xFOErKApOCY/GGzIImPR6drMbDhUVCtsJ?=
 =?us-ascii?Q?Q3H+1dJBz6Ij4Pk9NB1gDxklhZnIn+kyFaxSZ0en9ho0bUnxw9QUDkCZCwXB?=
 =?us-ascii?Q?4hgrP6cFHPoNobbfbYgChDZ9wN3nNabhKv9hP45GXfRhnTaEdemR/YM4dSRN?=
 =?us-ascii?Q?yiETDgPwA/yxf7HWjMggwmfmQaIosTsgNgEi9LAclLwN+IOFUPdRCDi7aX23?=
 =?us-ascii?Q?9/ZcanOMyMLf0T0Wbmr29nC26xA4LKKtnecF/opxLIDJj+2NImiX8Vcz9Syb?=
 =?us-ascii?Q?FuvNy+0q4KFO1w263j658FWpX1AoSJ2tmUIGRw6B0vE+EN3bjUGWW/AhExD8?=
 =?us-ascii?Q?TgQcPUYRkLXSw+ABhjgO4J1x/IlsrOtvNXuhhv1hle44OD294TkOMnDS0YAb?=
 =?us-ascii?Q?SHrOL2eRTlA0gHZQp15USpH15I9F2uW1mcUfPS7NTjYqI3TLXH7fi1yIVlMk?=
 =?us-ascii?Q?H6/N6BOnhp00N4WupqY3odxUZ3GD90h16WLNCWDoT5QrE/EIRKIhLHhhhRhm?=
 =?us-ascii?Q?+o7NIRJOcTvR4PDi47jTz3wGVTV300l6GYU8p2bXfaMGBpq8CvRwb/BDvNJl?=
 =?us-ascii?Q?WXRHTrUz7iMmjs5XgZPOHXhA90b3HMtr7nZhN5uUhJhaBCR2/54k06h7rhJo?=
 =?us-ascii?Q?QKf8lyrXhiLjql/1XX81+SLs6LTzkJ9yFZnBQQZeex17td1rzCLUA1gKyLZy?=
 =?us-ascii?Q?vfa6Pnlv119995GK+CwbDJAtTJzhdDrorj4KxqSVpszhOg/06fnyNnfi/u11?=
 =?us-ascii?Q?kFpVjzGYKWXeHII2lAq9C7+j8RjH76I89p0DjCHKDC+jOIiuRZ2Ci/UqRQAa?=
 =?us-ascii?Q?Tf4wccwBn/F3U+1gtzeXaLM9mpTKIMKA37R5ylZJ6UwryoRuhCBgKFn9/mUs?=
 =?us-ascii?Q?0dNj3ZBlRuB7/9hI2Va/0FJm?=
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edef67fa-3b63-4dd7-e824-08d92411e249
X-MS-Exchange-CrossTenant-AuthSource: BN9PR03MB6058.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2021 08:55:48.0438
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iufpJseOpKPBAgZ/MXjTZyoAxtn7Yl7YgJeqQ2/2fvaiY/LY2CNfvgfPN4L+rEdxvRwcRv8nJPQbfFiUzfGyrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR03MB3460
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit e69012400b0cb42b2070748322cb72f9effec00f upstream.

When we added KFENCE support for arm64, we intended that it would
force the entire linear map to be mapped at page granularity, but we
only enforced this in arch_add_memory() and not in map_mem(), so
memory mapped at boot time can be mapped at a larger granularity.

When booting a kernel with KFENCE=y and RODATA_FULL=n, this results in
the following WARNING at boot:

[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at mm/memory.c:2462 apply_to_pmd_range+0xec/0x190
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.13.0-rc1+ #10
[    0.000000] Hardware name: linux,dummy-virt (DT)
[    0.000000] pstate: 600000c5 (nZCv daIF -PAN -UAO -TCO BTYPE=--)
[    0.000000] pc : apply_to_pmd_range+0xec/0x190
[    0.000000] lr : __apply_to_page_range+0x94/0x170
[    0.000000] sp : ffffffc010573e20
[    0.000000] x29: ffffffc010573e20 x28: ffffff801f400000 x27: ffffff801f401000
[    0.000000] x26: 0000000000000001 x25: ffffff801f400fff x24: ffffffc010573f28
[    0.000000] x23: ffffffc01002b710 x22: ffffffc0105fa450 x21: ffffffc010573ee4
[    0.000000] x20: ffffff801fffb7d0 x19: ffffff801f401000 x18: 00000000fffffffe
[    0.000000] x17: 000000000000003f x16: 000000000000000a x15: ffffffc01060b940
[    0.000000] x14: 0000000000000000 x13: 0098968000000000 x12: 0000000098968000
[    0.000000] x11: 0000000000000000 x10: 0000000098968000 x9 : 0000000000000001
[    0.000000] x8 : 0000000000000000 x7 : ffffffc010573ee4 x6 : 0000000000000001
[    0.000000] x5 : ffffffc010573f28 x4 : ffffffc01002b710 x3 : 0000000040000000
[    0.000000] x2 : ffffff801f5fffff x1 : 0000000000000001 x0 : 007800005f400705
[    0.000000] Call trace:
[    0.000000]  apply_to_pmd_range+0xec/0x190
[    0.000000]  __apply_to_page_range+0x94/0x170
[    0.000000]  apply_to_page_range+0x10/0x20
[    0.000000]  __change_memory_common+0x50/0xdc
[    0.000000]  set_memory_valid+0x30/0x40
[    0.000000]  kfence_init_pool+0x9c/0x16c
[    0.000000]  kfence_init+0x20/0x98
[    0.000000]  start_kernel+0x284/0x3f8

Fixes: 840b23986344 ("arm64, kfence: enable KFENCE for ARM64")
Cc: <stable@vger.kernel.org> # 5.12.x
Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Marco Elver <elver@google.com>
Tested-by: Marco Elver <elver@google.com>
Link: https://lore.kernel.org/r/20210525104551.2ec37f77@xhacker.debian
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/mm/mmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 5d9550fdb9cf..bd4739baa368 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -492,7 +492,8 @@ static void __init map_mem(pgd_t *pgdp)
 	int flags = 0;
 	u64 i;
 
-	if (rodata_full || crash_mem_map || debug_pagealloc_enabled())
+	if (rodata_full || crash_mem_map || debug_pagealloc_enabled() ||
+	    IS_ENABLED(CONFIG_KFENCE))
 		flags = NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
 
 	/*
-- 
2.31.0

