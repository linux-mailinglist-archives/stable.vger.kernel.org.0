Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E82112AB512
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 11:34:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729343AbgKIKer (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 05:34:47 -0500
Received: from mail-eopbgr80123.outbound.protection.outlook.com ([40.107.8.123]:15172
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729351AbgKIKer (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 05:34:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nQut3qcI7k0nuqbULnSp/J1ENHlOyrz/bVL/t0qgjPNKWDNV8em5gNhJvC4G9kGDqOTJFLo9f1ZHv0ivrp/0yfp6Ymd2SwnjXmjl5MoRxfZ02fmASeC4gGV+TulkjdaptxZV/e9BXNeE2odgbKR1Wp3ZyatGRQCaDYI9Uv/iDsF+kkPbUIpl0P1aZN9FMUGclOXpFnsKunPBg2a8KJ+Jc33D4vWhvdY/w4GdilcOpYNKQ/7QIJJvBqy4NcrygE9ULBKo9tC5FJuBkKCEPg+Joy7GXNWpzI8lLEJbOdoP6SrRaa2SL3zE+Kz0wT1r8LPmS5VKZRejd8L/QrauMrqT9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eAbAiSnkWhotYlrpinFaifNYPAUBgEDNzNllFi9kRds=;
 b=MWHqRgs0hENdPUetA8+zcxnM23A+6es0r0sg+vpwykYR3W2qnC8c2FPQxrfbRkvXmicKw4C4+8sBP3ZHibXExLE2vLaa7z6jrJymQahz64KI12oIwWLl+PdJr2QbVkQSHsF3iaB5hI8LuMxx7AI/q7o2n4ZFsgKQFGTx7ZvunCl80Gn1gplzR4HTF1B/KPNMvVwuxHs7Zb9rThJ9nMO1H+YUEJkSUMVz30BluxfJrzK81njVjMOSy7hko6fr6G9a4eBKpi1qkzFc9u4q+JZi4c5kT4dIjy1Th2orMSPc6YGCVmPIAFE14hQR8FNJ+72CEDVJxFxvmHXNBQoPvMbd8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eAbAiSnkWhotYlrpinFaifNYPAUBgEDNzNllFi9kRds=;
 b=qpQnI+pN2Vz4cyEMdJywRJABVobNoCGYWI4sJFn7ucJ9a6NgyT6X+yKs3i8ElNEYZ33b4nOfv+lmjovK5hmiBqUVpHnO2+pk8EKVpx3JTMpxAUymXBRFDabPzVa2aO+H3lcTrBgjZx4BWgZDO0rUR0cLJJ6obJKhCoslh/K4McE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nokia.com;
Received: from AM0PR07MB4531.eurprd07.prod.outlook.com (2603:10a6:208:6e::15)
 by AM0PR0702MB3827.eurprd07.prod.outlook.com (2603:10a6:208:1f::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.10; Mon, 9 Nov
 2020 10:34:37 +0000
Received: from AM0PR07MB4531.eurprd07.prod.outlook.com
 ([fe80::d527:e75b:546c:a85b]) by AM0PR07MB4531.eurprd07.prod.outlook.com
 ([fe80::d527:e75b:546c:a85b%6]) with mapi id 15.20.3564.021; Mon, 9 Nov 2020
 10:34:37 +0000
Subject: Re: [PATCH] MIPS: reserve the memblock right after the kernel
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>, linux-mips@vger.kernel.org,
        Paul Burton <paulburton@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20201106141001.57637-1-alexander.sverdlin@nokia.com>
 <20201107094028.GA4918@alpha.franken.de>
From:   Alexander Sverdlin <alexander.sverdlin@nokia.com>
Message-ID: <1d6a424e-944e-7f21-1f30-989fb61018a8@nokia.com>
Date:   Mon, 9 Nov 2020 11:34:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <20201107094028.GA4918@alpha.franken.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [131.228.32.166]
X-ClientProxiedBy: AM0PR07CA0035.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::48) To AM0PR07MB4531.eurprd07.prod.outlook.com
 (2603:10a6:208:6e::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ulegcpsvhp1.emea.nsn-net.net (131.228.32.166) by AM0PR07CA0035.eurprd07.prod.outlook.com (2603:10a6:208:ac::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.10 via Frontend Transport; Mon, 9 Nov 2020 10:34:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0887c29f-4f49-490c-cccd-08d8849b0e73
X-MS-TrafficTypeDiagnostic: AM0PR0702MB3827:
X-Microsoft-Antispam-PRVS: <AM0PR0702MB38275CF49254510A4A8080AF88EA0@AM0PR0702MB3827.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y9+jRSBJHEKGjq5oqcRr+EAl37INLy+K73HKYYN+jYhJA4k1xX4NMC7XT6irBY6wGkw9/w6V+hUDB4FG6ZfkYfn/LbEX+H1cWnevUh1PBbbEgUFq/8xGFaybe5FdGwCJIb0D8F9Ai5BQEzFlWnnnt5YhwIrHDzj3dawM/tCoGiIzqtgtQfT6Az1gz/ZO1A3Vt8pXN8GSLN7dUFLP24aVdrYkSQhWJ+ZSfiEneFqoBkYMGAVYvFMfO01E4Kg0iFEUsou4j4FsUxlU2zBBgPzduPx3jqxKXsCTn2XVjw/pGJRh+TMTnqmTDyTIRqWAKDkodFmBcXpcjVQr1xseEEFMf+qzVaeAzgXacLBXi48abpa6ySbmxQEoUSJoPEug7YMQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR07MB4531.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(136003)(396003)(376002)(346002)(83380400001)(26005)(6506007)(36756003)(52116002)(478600001)(316002)(186003)(2616005)(16526019)(956004)(86362001)(53546011)(54906003)(4326008)(31686004)(6916009)(8936002)(6486002)(66946007)(6512007)(44832011)(8676002)(2906002)(31696002)(5660300002)(6666004)(66556008)(66476007)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: Z7MmD7jbgp7B36SI/bGRhYN+o+1S60Puk1YOYnm2tIBml2kCHtEfd0bWra3rwk32VBMBD/PIy7dtbkyPGTjcg9bYrJwzVo0lCzCYFmMD/w6k3bLzcS2z0dMXQG3+XwpAhfjUhjA7Yrm93d19WuZSGoJcEnihEDhJXW97NhmzCa+n5sDO5euBoGsw5lVUC5bZnxGc5rAqsXyNJ/4fApCjYBoyW0j8rFKq+Ji8hRb7z8AEtAm7nmrHqcfV6n5acF69sFnJ37LsB9vOnjZLlKCt1sQcmy9aW3cO22hC6n/1q5zQlgGcv3ahyQojRjL6eON+U/NUvFHhCeD7IXeB1elslUb30pRk2CLwOObXRwuKmjs4Eq4QwsP6Avk8e/wA+Nmq93RSxpDhPPVHE96J0hkBUz0IK6P3NjVqC5dEDpoH58dMMghUI5IypNylTWX577vLruNeCzApoQB/1DcI7Rfa9UVFmCQpHSnG9ETHy7k2JP8mU0StE364UmCii2WZHhmhoqtcH+N1xZN1MakRtxSE9auHyLS15uzmWyVsgicQSr1lWqIwKSRbJo/jZv86wxTY0Wt7MLIvr4Nbrq8B+SW33UEK/mQ1tmTuElPNY/jUtOD+kqsJdUq4b6YlixVlIvhK4A+Ny8MzHZ6GJYklvBVNq2GmtZ2ZH7os2DwF7+qNu2sJH3pxdiO81AE3ieFT9hTe9Y/rUAeerqWediFt5NVtxJ/RPQvT8/kBtgLRrBLWRZ6A9ubZfUcuFTNJlTGD1V+sF50EzF0cAbkggzrnMf0iOfDfPwnXwxkmZJ7don1oJxaC+0I9Hv/H2fGduT827Twgmm0nKEXYfWMU09BJl0ONxg2bbR0p+ux6Y02fTd2GyOB4ChJA6nJVoITzL+cHRBpHgBfxn5pnIpDEdAcybuc7rw==
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0887c29f-4f49-490c-cccd-08d8849b0e73
X-MS-Exchange-CrossTenant-AuthSource: AM0PR07MB4531.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 10:34:37.1919
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3HumQkE6MMW8zC5wwWs2Iyuiymx8R8f5BqYTeo6+Hyi3HvsoD4HcFG3mS7q09BCqykusbcVyiYi/sUuQG5BtlBEK+I4MreqIm/JuKOPNIU8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0702MB3827
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Thomas,

On 07/11/2020 10:40, Thomas Bogendoerfer wrote:
>> Linux doesn't own the memory immediately after the kernel image. On Octeon
>> bootloader places a shared structure right close after the kernel _end,
>> refer to "struct cvmx_bootinfo *octeon_bootinfo" in cavium-octeon/setup.c.
>>
>> If check_kernel_sections_mem() rounds the PFNs up, first memblock_alloc()
>> inside early_init_dt_alloc_memory_arch() <= device_tree_init() returns
>> memory block overlapping with the above octeon_bootinfo structure, which
>> is being overwritten afterwards.
> as this special for Octeon how about added the memblock_reserve
> in octen specific code ?

while the shared structure which is being corrupted is indeed Octeon-specific,
the wrong assumption that the memory right after the kernel can be allocated by memblock
allocator and re-used somewhere in Linux is in MIPS-generic check_kernel_sections_mem().

I personally will be fine with repairing Octeon only as I don't have other MIPS
targets to care about, but maybe someone else in the MIPS community will find
this fix useful...

-- 
Best regards,
Alexander Sverdlin.
