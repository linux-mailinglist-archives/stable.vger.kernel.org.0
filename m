Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADABB532FDE
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 19:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239991AbiEXRus (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 13:50:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbiEXRur (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 13:50:47 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2074.outbound.protection.outlook.com [40.107.220.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCBFE5D5E5;
        Tue, 24 May 2022 10:50:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bD1AqdJZMVOGYWak/HpeuRfhwA9Lw8tstlsNr8HH4cg87qUB37DuW4CJfodSl4Vk2D0IJ9MdTwKr0+ZsGwvpyD2XexRzlKE9yvMRBhfyO3PsPeP+/U4EvdkbehuUYSjLjDrurtLdLqI9PVQERaXTP2xQ8NA5KE+hjCWQW1Njpq2VYsfzg22iQoyC/b540zF3vB946NK8YstvVK7tKIajAXtzSiPOa3rI8wlXS5IPVh2uod1V3auwllI2w/D03NKTVkwb92HaarviIf64TWyZl3jMEy6XdRZzO4F954NRev8HUOolstHiNOUedOjfYx2Te1fkMKF00lBAx/pq449GAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=317fEZYYmhKP/WqFc7raA1y3kQoD987QzRvB9kqW5Dk=;
 b=QbT2uw3mh2ujOFRan7tHLKsnOR8r2VPLDIQcFQwfXZ86z4hjoObCjA0PfyF/7ZayNbV6+qhTii8hTWvIyTl8spDQ+PukYgjx5ibDNPUdK7V2JpWU2Su5x28cDd6YVO0GGXrEzSKu52mLyfL1bvpmeSlU1y9d8+snsoaglS+G0wNeRLQpdPb95lXOMqI51blWF/r1HUA1X8fbABLYbeBNFd6SbSRrURo3LGyrAWYGuM/ahZtNbHeK7gIq2XZF0c1OUO3PSK15fvY4KaPPqZTkuQQ+XUuhfcT552vpu7U6AxYatVrn8yhDhBYTiUx9SmkwCor0JsrFr1fOJ09PPuOpQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=317fEZYYmhKP/WqFc7raA1y3kQoD987QzRvB9kqW5Dk=;
 b=ul+mh2oSIu1+azlFPm0bCCwpcRxnUUeVUpn4nEyFpoiJh7EG4qOLxm6KavEZBWdzWrviZ9Kewg2jOVfnv9sf2Fcu3Tn1kxllfFekiqMbMdRZGO6aSO2IzVRZQNjCAEBQFgo3uTAzt/DnzVKcVX6keZ8Siq3KoGei2gHqmsJDvlanTQKoS3d2TEX1/gExCiPb6/Kla5hxATNO1iBX06/LGiWC/WE7gyWcDYpEUXA/HX4lL92sDasiT0B8+HBcZrURAb/AYiTtqfYXgW/hoxT/e5mRZrHWZWAZRwNsEw1FIZAXzBtq7XVAf7pNtqqXxJR3lWkFXAlnyifowuDt7LGEeQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 CY5PR12MB6035.namprd12.prod.outlook.com (2603:10b6:930:2d::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5273.23; Tue, 24 May 2022 17:50:44 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::f954:6840:ce82:c54f]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::f954:6840:ce82:c54f%4]) with mapi id 15.20.5293.013; Tue, 24 May 2022
 17:50:44 +0000
Message-ID: <97cf35b5-1286-91a0-c0d4-df7fe8a983e6@nvidia.com>
Date:   Tue, 24 May 2022 18:50:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 4.9 00/25] 4.9.316-rc1 review
Content-Language: en-US
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Ard Biesheuvel <ardb@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20220523165743.398280407@linuxfoundation.org>
 <6f4034a5-f692-8a64-a09d-8bfe49767b78@nvidia.com>
 <YozK4DvamHBJ1qdX@kroah.com>
 <fbeb9833-4166-1919-e6ab-9ac7625a21d6@nvidia.com>
 <Yoz0Xv59MrUwFkMT@kroah.com> <883fc4cf-dce0-a433-5cf7-7de68be17ffb@gmail.com>
From:   Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <883fc4cf-dce0-a433-5cf7-7de68be17ffb@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0046.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:152::15) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 67dd05fa-f7b5-43ee-9a7d-08da3dadecd9
X-MS-TrafficTypeDiagnostic: CY5PR12MB6035:EE_
X-Microsoft-Antispam-PRVS: <CY5PR12MB60356010C95F7449D592439BD9D79@CY5PR12MB6035.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JWyGmu8ysUiP8Em77zproqU8tW2vCdTJ/AACyFlLhUPfqedYpFC/8nyXmzc/J50lQRMep52CxizrUKl6plmqhJFeWojVwB7MFarJLcMwAYlly7B7sQGbaSmLivznx5F63FvtoGz2wOOznQbbn1+n3794hr45YVATvnriZkDFzkRfISNMf4IKvp54GUB45rqq9btGYIbe0QMv0OEwWFZyBcJz4hTp/AEsLl5tprIzyC6enmny0ot0djplu35zGFQukPYiztDhI1udDwLKMq5vvg3KzbDZ439n5DNDU4f+989xUp3VitcNvpQ7NMJuDD3e5pyzlc0xKZf8SUo33EUgPNqKqyTUbnRxb7Z0n+lBj/vVOQiqBziZOv1EENQewB5CnGBOawcrRWCTahETWRFaieuZoDNTB7Mj5hz4LdgmxtqngztjfhjEEJyStZEAEof8XqSUVYMKmkW8u01tNF794wWVpZYw/vTeT2OS7IpPmxTTmQM7L1aP4qfHqFN6I8rmAEIQfNNRTmynJ+c+qJ96yMAwNPSLklBAaC7B/VpV06RdQ0eQkm6+pKRIuIMOdCP7t7wsalmqcyeZqWHedVqh+Mr3vFAfcm1LN+ghRG6TNygU4x5SMsnQjTBsxcYtDlU+QAY/9OeE2aCQimHSgKQ/NmDS6G7fqxb72Q/JifWOjIyD+kJJjS2+1d/oKSYpygPKhSpIeTlzLtdh0+P7n7gAqfS9W8cXuhuFZu65PkHTkQGkMKfRV5D/eUChd+aa4oXi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(66946007)(5660300002)(7416002)(508600001)(38100700002)(31686004)(4326008)(2906002)(110136005)(6506007)(66556008)(54906003)(8936002)(8676002)(6666004)(66476007)(2616005)(55236004)(186003)(316002)(26005)(6486002)(83380400001)(31696002)(6512007)(86362001)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N0Zpc3dPR0Z1Q2J3ODIxbHBkdkdHV1ZqZStjcExRUUR5ck0zS2NSbGN1aUVx?=
 =?utf-8?B?YzZtNnl6dVBnaDV0SWtKZlNkUklhNDk2MUFIWTdHdDIxaU44Qk1OL28xcWVh?=
 =?utf-8?B?ZDlIcm1oQWZxK2JZWDk5ZmxUb0tabWphQTg4UjFoeGRwOFF4OTQzL1pDT0Zj?=
 =?utf-8?B?ZWJJVlNhWCtzNi9OOUhBcDhaZk1YN0lZbVp6NUlOemlybWJzMFJaSWQvY2p1?=
 =?utf-8?B?L0xlVTd1d1JrTGZBTmFIWUI1dkVFbVd5cVBZeTcxR2h1M3NyL2JBbEhQbWR4?=
 =?utf-8?B?cDR1KzlRRk03eXd1Z2d5c3Y4TmVxYS83QzdiQmNtM1RuZ0pxcVFqNFV2bVhq?=
 =?utf-8?B?Qmo0TkIrM0ZOdkVrNEMrMjhwTkZtcE5wR3JLeUljRFloR2lCQmVVTmtpTmwz?=
 =?utf-8?B?aTB2Y2dhL0djWFhUUGhsSGk2TG92WHNEcVlDOS8yYnFqZVBxZitlVjAwcnRS?=
 =?utf-8?B?cTdBMC8zKzhDMEt2TEFkWEFrNGJPeXJ3WEJublJiYS82NW4yS2Q5MWdRUmJr?=
 =?utf-8?B?SWxMWFVER1REc2tXU0ExTHUxbFgxa3pLR2NTU0kva3l4L01VY2xrdmNGeU1n?=
 =?utf-8?B?QUxaUlY2UDd4M3RObms2QnF0SWZyZ2wvWUozaUIzaEV0a1pqbTRqWkRKY0ta?=
 =?utf-8?B?c1VrSHFEOGNTT1NwbmN5YTU3M3l0TmdQK0V5SFN5aGhGbm96dERiRythM1FV?=
 =?utf-8?B?WWs3YzAreEx6Nk9SN2dEaHlPN1NIUUprK1ZkdTZkSnRNL3ZsSHl6RXNLejlC?=
 =?utf-8?B?Zk9FeEtmLzd2ajVjSTRZZGpQRTh4cWxqZGdYVUVUSkJ5akJzcXVXbnZjdXBL?=
 =?utf-8?B?MlFGQ1FzY3hFOXdCM3pQZFVrWW5USjBua0VxTitwOUtzd0F6aW9jZHo4Z1F3?=
 =?utf-8?B?NkdTMktzUW9reDZLcVo2blRZZFR4WTFEK0thMyt5bTYvYWQ5NGtzNEd3NG05?=
 =?utf-8?B?eTdqbjI3RGVIWjhLUXBZMlRDWkE0UGhodlNTV0YzT3MvY1Ntb1dHcjlhb1JW?=
 =?utf-8?B?S1c4WXpQYUNablQyczJmZ0pLdFhlcDlwaGx1ZElYN3BVNmxCUktSNDNYZWx0?=
 =?utf-8?B?NW9Oeld0YXVndmMvaTJFQ2pCNWVsSVBOOXp2bXQ4NDZaeXdWSS8xSDI5Qk0w?=
 =?utf-8?B?ZnRudEptZk5lY1NPRUNOWGk5VVUzcjVWaVZTL2xSSjdySk9ob3FSZWxoeXh4?=
 =?utf-8?B?SmZvQkVCWTMvNkZwUS9xUDF0L3l5RDFjNnBlYWUzY0xCejZwUCtVVlp6YXIv?=
 =?utf-8?B?YjRTUzdKY0pYQ0FJOG9GVE5BUW5RWDNHUUk2aFI1OFFPZ1lWbWNwQjFrYU5L?=
 =?utf-8?B?WWJjaE40OTdJMlAwb3FRemhoQ3UwZmpoTWZwaldXSlNpcE9ldnJzK0RTYUVV?=
 =?utf-8?B?WnhTcnZ6YWltYVEzN242clpqOXBjZk52elVqb0wxalBVLzhCbjk0RU1ON1RY?=
 =?utf-8?B?NXZpMlYvNlArUFVXT09zVGtnbzVqVlAra0NxZ0w3aEhKOTRhVmwrZjhUUWY5?=
 =?utf-8?B?aDkzSkFMQStVNyt5RSs1ZTc1Y1AxdU9kYlpJVS93bjh0L0lwZTFIMnpFdFlB?=
 =?utf-8?B?VzRFelRQeFZzclYrVjhocmt0Rk1zZjhIdDJRYVpQSmhjSW9EZUNHWkwvYVhT?=
 =?utf-8?B?WU1tMmFudnd4dUx2a3J3N2F4S2ZOdzIxSTlESzRKNzRjU3hSblIrMEJodXM2?=
 =?utf-8?B?ckhQSmR1VzVKTTR1eDI2NkdCSklXY3EvUER5SEtUeHJabXRyQ1E2SUZwMGZP?=
 =?utf-8?B?VG5LZjNSTlBYRGZGM3NjdWt0M2xTcUt0RGN3QlBTNTZMUXlnaXd4cHB6L3dU?=
 =?utf-8?B?SGRYdGk3QlpjUXd4Tzgyc3lvc1BNUFdiMHpJaWttZitHcGJRTnUwUUZLQWxh?=
 =?utf-8?B?ckNGNjZXNnpFTEY1eEZiNFZMNm1mZTZFNlJoUGlyMDZhNUhUTEFkZlg1bTZY?=
 =?utf-8?B?Qms1cWI3ckh2WVNBUjlyZWU0cUdjbGdLNnF5MWQ4STYwWkJERDhpRnovQmMr?=
 =?utf-8?B?OHgzNFpaVUVhOW5ibndQVnJXU0pwMldMcXJJWGZpaktuMFh0dFBFWEpQVTJI?=
 =?utf-8?B?OUtTZ0ZFOWprNlNWbE85NmlkelkwdnhtbzlwVGlHNXh0VEFhbklxaGZlNjVo?=
 =?utf-8?B?a3FjTXJpci9XSVlGSkhYRVRIUmZWeCtaaXhDRGFTSEhyaXB5OWo5c2RFVkEr?=
 =?utf-8?B?OFMzT01lS3hGT3VmcWNwRlhqQzRDVFl5K3dVTC84ZGEzNXFYSmxDMTE0UGpU?=
 =?utf-8?B?NkxmNXg2eEVvWklYVjVSdDVSOTJKNDFUUnd4VXVpMlBRajlMc0hZZWZiQ3Fh?=
 =?utf-8?B?NTJhaFEyMlhNQXVKdm9wUTlTckc3VUhJTkVjM25VNVAwQW5qUzA3TDhxcnh1?=
 =?utf-8?Q?+cVRUhm/BrZmANtk=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67dd05fa-f7b5-43ee-9a7d-08da3dadecd9
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2022 17:50:44.0072
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5rHpGwnQ/WnA4Sw7FdJ/0Cet7oS8ZPT9W/OWnx56w03Yrv4jUjoflLOAHCG05QKfjaWIMmg86FHTlBSmDsmGug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6035
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 24/05/2022 17:30, Florian Fainelli wrote:

...

> Jonathan any chance this is Tegra specific? Our ARCH_BRCMSTB SoCs which 
> use a Brahma-B15 which uses nearly the same ca15 processor functions 
> defined in arch/arm/mm/proc-v7.S reports the following *before* changes:
> 
> [    0.001641] CPU: Testing write buffer coherency: ok
> [    0.001685] CPU0: Spectre v2: using ICIALLU workaround
> [    0.001703] ftrace: allocating 30541 entries in 120 pages
> [    0.044600] CPU0: update cpu_capacity 1024
> [    0.044633] CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
> [    0.044662] Setting up static identity map for 0x200000 - 0x200060
> [    0.047410] brcmstb: biuctrl: MCP: Write pairing already disabled
> [    0.048974] CPU1: update cpu_capacity 1024
> [    0.048978] CPU1: thread -1, cpu 1, socket 0, mpidr 80000001
> [    0.048981] CPU1: Spectre v2: using ICIALLU workaround
> [    0.050234] CPU2: update cpu_capacity 1024
> [    0.050238] CPU2: thread -1, cpu 2, socket 0, mpidr 80000002
> [    0.050241] CPU2: Spectre v2: using ICIALLU workaround
> [    0.051437] CPU3: update cpu_capacity 1024
> [    0.051441] CPU3: thread -1, cpu 3, socket 0, mpidr 80000003
> [    0.051444] CPU3: Spectre v2: using ICIALLU workaround
> [    0.051532] Brought up 4 CPUs
> 
> and this *after* merging 4.9.316-rc1:
> 
> [    0.001626] CPU: Testing write buffer coherency: ok
> [    0.001670] CPU0: Spectre v2: using ICIALLU workaround
> [    0.001689] CPU0: Spectre BHB: using loop workaround
> [    0.001705] ftrace: allocating 30542 entries in 120 pages
> [    0.043752] CPU0: update cpu_capacity 1024
> [    0.043784] CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
> [    0.043813] Setting up static identity map for 0x200000 - 0x200060
> [    0.046547] brcmstb: biuctrl: MCP: Write pairing already disabled
> [    0.048121] CPU1: update cpu_capacity 1024
> [    0.048124] CPU1: thread -1, cpu 1, socket 0, mpidr 80000001
> [    0.048129] CPU1: Spectre v2: using ICIALLU workaround
> [    0.048165] CPU1: Spectre BHB: using loop workaround
> [    0.049398] CPU2: update cpu_capacity 1024
> [    0.049402] CPU2: thread -1, cpu 2, socket 0, mpidr 80000002
> [    0.049405] CPU2: Spectre v2: using ICIALLU workaround
> [    0.049440] CPU2: Spectre BHB: using loop workaround
> [    0.050613] CPU3: update cpu_capacity 1024
> [    0.050617] CPU3: thread -1, cpu 3, socket 0, mpidr 80000003
> [    0.050619] CPU3: Spectre v2: using ICIALLU workaround
> [    0.050653] CPU3: Spectre BHB: using loop workaround
> [    0.050722] Brought up 4 CPUs
> [    0.050738] SMP: Total of 4 processors activated (216.00 BogoMIPS).
> [    0.050753] CPU: All CPU(s) started in HYP mode.


Does your platform support CPU idle? I see this being triggered
during CPU idle transitions ...

[    4.415167] CPU0: Spectre BHB: using loop workaround
[    4.417621] [<c01109a0>] (unwind_backtrace) from [<c010b7ac>] (show_stack+0x10/0x14)
[    4.430291] [<c010b7ac>] (show_stack) from [<c09c2b38>] (dump_stack+0xc0/0xd4)
[    4.437512] [<c09c2b38>] (dump_stack) from [<c011a6c8>] (cpu_v7_spectre_bhb_init+0xd8/0x190)
[    4.445943] [<c011a6c8>] (cpu_v7_spectre_bhb_init) from [<c010dee8>] (cpu_suspend+0xac/0xc8)
[    4.454377] [<c010dee8>] (cpu_suspend) from [<c011e7e4>] (tegra114_idle_power_down+0x74/0x78)
[    4.462898] [<c011e7e4>] (tegra114_idle_power_down) from [<c06d3b44>] (cpuidle_enter_state+0x130/0x524)
[    4.472286] [<c06d3b44>] (cpuidle_enter_state) from [<c0164a30>] (do_idle+0x1b0/0x200)
[    4.480199] [<c0164a30>] (do_idle) from [<c0164d28>] (cpu_startup_entry+0x18/0x1c)
[    4.487762] [<c0164d28>] (cpu_startup_entry) from [<801018cc>] (0x801018cc)

Jon

-- 
nvpublic
