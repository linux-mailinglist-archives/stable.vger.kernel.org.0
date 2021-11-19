Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2C0B456B7D
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 09:16:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234336AbhKSISZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 03:18:25 -0500
Received: from mail-eopbgr00100.outbound.protection.outlook.com ([40.107.0.100]:37102
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234201AbhKSISY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Nov 2021 03:18:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jp3+fKAsC1iLvEodKlEJcpYq+khuIszPBa1p+EodRlNHgMokU/gm7XRUepO1Lc7lFDp91uCbS8O89Qo6GKcPfROwlaQdZ9MNukALf5bDwHyuCF1TGbIf6pMbeDJ6cKZdpUQf1T7hlzut2HhXkuuNhcdmzNRaoB2c/73qWxE8eygDFrMQtpJtPceJXjrUeumT7WidIjS7W6k+Wcj9d8GMHTmDaU9hBXWziZaZTfiOyuIZbNa8mbhxrbp9KYj8Y7Q1yWBNJoLY/oL6CxElio6V4SfN0TZXvii8UZpXP2P1b4Oc6dzPpQX5oqm7nGLj+Mx+XZcTN3Nnrh7LqKF+y+q4IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tdzesI3x117myp8ZRXFYQCatI4TCv+wh6JZYpgI96CA=;
 b=KT+2IZ6VMCx5yO1QmsbGVhv7RSLVnbzjaZN3MclQISJ6GvadNAxpUkZvTDyC+XxuztXz6HXUkuBwIAWQKBDvO0WxXzop1KBB8VvXWWjYcKgzBSGkCzbpFExUNvIhLzm4L1/mWFSn9427FfLJBgUOFfHsVrWGda4e03ElX5k6k3CQ/vCc1RV7GUKSuTg88qTjuPKqJhtz7QkSybMzifovZqE2Ka766er+wq5v/kFE8X1Pj+MebUnhcU1JPUzWvMwYgReMWk59YQ3MlDxNW9sM4LCdtG5bKJHVYNHZ7jrUYx2/mcYVIA1u/CymxU+whWiWyHKH1WCu+bRsHl37I3jF/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tdzesI3x117myp8ZRXFYQCatI4TCv+wh6JZYpgI96CA=;
 b=mhzFqVkpwRqFPVB/KrVDfoFvA6xy15LTmfG0xjfwmVRSxqcZ+RxreeCYGKsDx6lTQ3Oz0VVMzz+vexkyR75TbLRHuiHWQLD3vxTRP1JqoQhOxJJZLQXGTV+8V5FgBCX8yIaJ4IIy03IX0wZkZP384UDxmBUY4J9DBA/FaAvsoh8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nokia.com;
Received: from AM0PR07MB4531.eurprd07.prod.outlook.com (2603:10a6:208:6e::15)
 by AM0PR07MB5841.eurprd07.prod.outlook.com (2603:10a6:208:118::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.11; Fri, 19 Nov
 2021 08:15:21 +0000
Received: from AM0PR07MB4531.eurprd07.prod.outlook.com
 ([fe80::555c:9e12:7c:f52f]) by AM0PR07MB4531.eurprd07.prod.outlook.com
 ([fe80::555c:9e12:7c:f52f%7]) with mapi id 15.20.4713.024; Fri, 19 Nov 2021
 08:15:20 +0000
Message-ID: <c5b78f36-ba6f-7a7b-1cf3-48c2f27b2a30@nokia.com>
Date:   Fri, 19 Nov 2021 09:15:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 1/2] mtd: spi-nor: Check for zero erase size in
 spi_nor_find_best_erase_type()
Content-Language: en-US
To:     linux-mtd@lists.infradead.org
Cc:     Tudor Ambarus <tudor.ambarus@microchip.com>,
        Pratyush Yadav <p.yadav@ti.com>,
        Michael Walle <michael@walle.cc>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20211119081147.9895-1-alexander.sverdlin@nokia.com>
From:   Alexander Sverdlin <alexander.sverdlin@nokia.com>
In-Reply-To: <20211119081147.9895-1-alexander.sverdlin@nokia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HE1PR0301CA0020.eurprd03.prod.outlook.com
 (2603:10a6:3:76::30) To AM0PR07MB4531.eurprd07.prod.outlook.com
 (2603:10a6:208:6e::15)
MIME-Version: 1.0
Received: from [0.0.0.0] (131.228.32.168) by HE1PR0301CA0020.eurprd03.prod.outlook.com (2603:10a6:3:76::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Fri, 19 Nov 2021 08:15:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f5196cb0-026a-4410-b29a-08d9ab34ba87
X-MS-TrafficTypeDiagnostic: AM0PR07MB5841:
X-Microsoft-Antispam-PRVS: <AM0PR07MB584188E4BC6A99844C2BD58C889C9@AM0PR07MB5841.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VB2v+25VFHCn2UZ88VpWnVwIDk4LxOWfJsSokQ9ia7vXkusDuE+JDlRbAiBJXR+vpkqHykpT5S0GEPj+OYbIOYtMHNcTDlNys4zvYAcRooCVteQ97mz9MOdXhTxRwMeVmKAS0EC9qccjrmvd1VUvw4HjJuA0eOfZIdpV2t4do7R9k9J6GVfBTQ83aQvRSjcLCwB6wPuwRQAdAVfI+YwZD61kXVgnjhEyu6CCX5N/FCpKE9KIQCfMlAcQeGHm8hnQIJjwrsE41zcZo7h4xK7PJ7UqOQ46eUGhfbf5molQIPeuRONYxwfSnqbJZIroU9KrxBy8Ksd6wv7310tUQRTB+uAwUGZFqITEd7E6gaWk1avrw9K/cyhH99uXLWUFMGcKjPFcWlCMCtLZgbbJzYGU0/jnwoZuY4h5e5c6q2ddrjq44fVtwL1e+Eo7RYYUFhk63N9InffTW+ZneabXJmPuuMnUfWpc4ac568N5sHL2hkOvr8z/d4L05M2JKxhMslQaDMzyfsU/Or3GY5PhO3abD2VRRYXu2M5mnlED927eJoC/ackPhCRc0ka61cjb8sZstBykuoiEGFDJYQH+IPpjsrVBwSpSPowJUB5avDnrlirdZkCIS6GMGUcMbkbZyVrafgTsc1+birDWIBCEpdHS7nJRwEs7UeWXmi6pKgmLKKc/IBbk7YB93JnOoYbwf9lehbNLG8dyY2B8mCXpboLsG6EPWwubUS+um1mvIkqR6p6aj39wWHbr966aLzW5amX5SlP1B6v9ImAmp+wVXsfPo/wIiqbny/7mD11+6OH+miY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR07MB4531.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(38350700002)(44832011)(82960400001)(38100700002)(86362001)(2616005)(2906002)(956004)(26005)(186003)(6666004)(8676002)(5660300002)(16576012)(508600001)(316002)(8936002)(54906003)(36756003)(52116002)(53546011)(4326008)(31686004)(66476007)(66556008)(6486002)(31696002)(6706004)(6916009)(78286007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YkxMRGdaY2dCWGU0TkYza3p2K3pZN2tlRWw5SFJKVWdrRzhzV1prRklKRW1h?=
 =?utf-8?B?SGNEOE52bk92blBYYkk1WStIWlBuRGV3K2IvS0ZUdHVwdTdrSXBqZk83UUdQ?=
 =?utf-8?B?SStPeXN4dUFEeGdKdEMyQUxoQUJ1ejZ3MFdpWnpLRnRaK2VUamI0YzJrZVow?=
 =?utf-8?B?MkVNeXdHa0taWUlQWUdhbG9nU3RXRlBJMnI3Ymw5dDgvb2hVSGU0Zk92YzhE?=
 =?utf-8?B?YmZ1Q2xSYmJnUWM2T1dmWVNuVGFrN1FLV21yYnp6emhFL0hzMU1lNGpXNCtF?=
 =?utf-8?B?NkpCcnVwQngyU3BOdHpCU2ZONVA5V095Mkc5eXVGM0VaQTBkVDFGTXNzMnhr?=
 =?utf-8?B?dDY1MjIzVFRlZ2M5QjFRZXpucitJd2xjR0xWWWRwVEFSVHNDTXZ0R05yZ010?=
 =?utf-8?B?eU0zeE84Y0pQSm5hV2g1Mm0rUkFleEptMDRWRHNHUDhKYkUvUXlwc2Rmaytl?=
 =?utf-8?B?RXJCRng5c3A4RmFGL3F6cjE1U1RBc2JSMlF1c00zeGNSNkJGVE50KzE4SXBy?=
 =?utf-8?B?NURVTFZUTGQxbGZrNXlvRjQ2SldkbXBVVzgrNHFTRTgzckRCZVJxV3MzNEMw?=
 =?utf-8?B?cnZCTmNQbzBVTHhNdmNObmM3ZEZaQVJCU3RiSStTbWJ4SVpiRFNDTk5OVk45?=
 =?utf-8?B?NDRCem04dXl5U25HQTk1LzUwR1JkNDJIRnd6NWhnbWVsMjBXTEZrYldrcCtr?=
 =?utf-8?B?YnpYanFrRTdyRVkwOEtadHN5RHd2NWk0MXVUZGpQYmwvL0c2U0VMS0dkRkZB?=
 =?utf-8?B?MWdSUUhpNGd6RzlRV0FpbjhpY1RueVJIK08rcW9FeWo1cElaWGdDYUtDRkI5?=
 =?utf-8?B?TmF0Y29iYjRBYnA5bDhrV29kazZTUDN5VVVRQ1JHT01rNXpDTkhYSjBsQ1lF?=
 =?utf-8?B?Sm1VQkJ5NUlwd29neGpGdXhxV1NuQzUxbUVVNDRFVkczaW1wWnN2V1h3WWNJ?=
 =?utf-8?B?UXJ4RklFdTQ2d0dTWjNBb2NTdkVQakFaS1V6enRnYzhTYVZ4Nlp3eVRXdXZs?=
 =?utf-8?B?amtjMG1aMWxHUmtYUGJ0dVFlNWZWM1NOaFZyV2lJOVFONU1OcGpiOWEyTm5K?=
 =?utf-8?B?OVlPY042NlJoWS9JYitzdEhHRFBiR2pDUUNVMWpNSC94V3R1eDJBTVpadTFK?=
 =?utf-8?B?NzR1NW5oNGtEeDhoOXVwSUc3RVlWaFhUdndxNUVhK2tkK2pSQ1FQYkJoSllm?=
 =?utf-8?B?aVNGSGVia1NVSWhQU1RYcFlVWmJ4Z3BIN2FmWEVQc2xMVUJZMWMyR2p5ZHRr?=
 =?utf-8?B?cVMyNVRZR1RoV1lwNmVZQWJkWGY2NVlYTjQzMklTUmxnWGNuZlI1VzMya1FM?=
 =?utf-8?B?TFZscmU3VjFKZWdxMFlNV0h3N1Z5dE1wdzJIS05JMGFWQlFBeEpvQVlDVCs4?=
 =?utf-8?B?WE0wMFhzbVduV3JhTW5qNE5jQkgyQk91YVJEZ1NINEUySHdMRllacnBjak5m?=
 =?utf-8?B?bGhocmMvV2lseHU4L1AwSmxvNkFmRjQ5YVZaZWs1Ykg5dHJIOUhIR20zSWpM?=
 =?utf-8?B?UXM0bnF3SEkrbG9EQWl4SGt4TkVDYVhTNVg4MzVCRktOOTNWdzNxS05reGNh?=
 =?utf-8?B?d0Z3WG94QTdsRmJqRE9LaE1mMGd6TE5yZVpWV1dKQVhSRXpDSGdYRElNWmVz?=
 =?utf-8?B?VTRremFIT2E3OE1YV3NFc3ZEd3g3OWt3MlFvZjlNQXBQQnl2WTlMR0F6Q0Zz?=
 =?utf-8?B?TWpKbWxsb25neGhBZUlTMEdLY0d2L2VnZ0NuWXQwVjVUSzkxRW1VL1pMaE51?=
 =?utf-8?B?OC9KcXVqUUh3QTJQTkpJQ3ZpZ3lWTWhEQVVxWld6bUlIQmlFZW9iTkdXU2ZB?=
 =?utf-8?B?MnRaNWQ0eE9QbEUwVUNXMVhHVkdIblBSbDAzQWVCR0hnclA1aTlzM1hWQ0dQ?=
 =?utf-8?B?dlduOUppdjVxMHNjZU45YXJiV212eTVwbjlUejM3RTZZQlgxdEp3ZlJGTkVq?=
 =?utf-8?B?eklmUG9IZjFEbStnQWtaNGZlT0JVWHgvNlBTTDJ2eFd5a3RQUU1HckZrT0hR?=
 =?utf-8?B?dVcxN1FQbGxINXpDRkttQ05id3drRUpDR3MzRURpNXU1NkdIN3phckpTdzB6?=
 =?utf-8?B?QUNPNFI4WlZFVks4cXVQWVY4YUpUSkVRSjllUHRBK2cxZ2ZDZUNxWFp6NGhn?=
 =?utf-8?B?RmsvekcvQldpRW5wS05hSEtpYjlQd0VHVCtiQnNwWEVSV1ZXcUxnMG1BdFUz?=
 =?utf-8?B?cmY2a0dpRTFLZFBoWnNWWmhlelJjendyOThkdW1CbHBybjhZWTNqZDA1Y0ow?=
 =?utf-8?Q?B6Y/aLqHHanG15FUxTMGB2z8PxFubtsxm8FTMX3+mU=3D?=
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5196cb0-026a-4410-b29a-08d9ab34ba87
X-MS-Exchange-CrossTenant-AuthSource: AM0PR07MB4531.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2021 08:15:20.7739
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E5N+j/L0FMf8Zv6Ov6M4ZvmgX1IYNGyX3e+yiTSnxCLwkp+zl4Zizy6cDqVQO4XqHP/Mu4dH7+nPz5chbyWoXzMhoV9kEK/IZt3uNa+uYf0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR07MB5841
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 19/11/2021 09:11, Alexander A Sverdlin wrote:
> From: Alexander Sverdlin <alexander.sverdlin@nokia.com>
> 
> Erase can be zeroed in spi_nor_parse_4bait() or
> spi_nor_init_non_uniform_erase_map(). In practice it happened with
> mt25qu256a, which supports 4K, 32K, 64K erases with 3b address commands,
> but only 4K and 64K erase with 4b address commands.
> 
> Fixes: dc92843159a7 ("mtd: spi-nor: fix erase_type array to indicate current map conf")
> Cc: stable@vger.kernel.org
> Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>

Please ignore this one (typo in the condition).
v2 follows.

> ---
>  drivers/mtd/spi-nor/core.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/mtd/spi-nor/core.c b/drivers/mtd/spi-nor/core.c
> index 88dd090..183ea9d 100644
> --- a/drivers/mtd/spi-nor/core.c
> +++ b/drivers/mtd/spi-nor/core.c
> @@ -1400,6 +1400,8 @@ spi_nor_find_best_erase_type(const struct spi_nor_erase_map *map,
>  			continue;
>  
>  		erase = &map->erase_type[i];
> +		if (!erase->opcode)
> +			continue;
>  
>  		/* Alignment is not mandatory for overlaid regions */
>  		if (region->offset & SNOR_OVERLAID_REGION &&
> 

-- 
Best regards,
Alexander Sverdlin.
