Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D44367AFC5
	for <lists+stable@lfdr.de>; Wed, 25 Jan 2023 11:35:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234899AbjAYKfA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Jan 2023 05:35:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbjAYKe7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Jan 2023 05:34:59 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 070A246703;
        Wed, 25 Jan 2023 02:34:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W9naxB+H1zgmSwfMDVhqXQjyusxzrXMYS3LmmIGngghfJNHspiGtEo4VLoD/KukS9enZY2hpYfVLjxLoMc39WPAc/Rqm3GELJLh7saCbUyYUyLiZ2PdCHm1qmcvUvCM0sADjb33qcg5Lu3oTAEniX2qWQYfSz8iQBcmGaF74iNQpXRdKgBMbupi1CrV8C761/Ufr+Sm+KzEQ6WTxu7DRVi3b1Lh6SMLjNu+viKvTEs+p67D/8+iteiYfE4uZ2HQc3rR0JBZHdIetmqwSH3AsF6doKbY1TabSbw2W/mNckpnxl2svXsJgY0hUezOFg5etnBOIRiHQ1d/RAI/nlOlUKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VcaXggH5rFi+8YME6Nv2KSYT7IDrp/ZOXZybfPs0GQk=;
 b=QBpt//RPVSN4yZZVtc6v4IBPnnhosDuHfJjSEj0h/l7Fvju7cNvrGMxyz2hmz4H4F3rzt2RTGf4rN8RuGYOfzW5uYg8N7hjuoWyPDxcJlOlrFItn+A28c6JIph6tteoODU5CFeAcZMLjD6FeoPAEwKp8ZD1KEAe/JEa8HNDJdIb9ZmZYTDfsTuruJeK/LsrwlM8JhufFI8jd2rJomOjC7g12ID+OoiKW6W6SO1YjZKExV5KrPxlYNUBeftmzSzwrctI3QfRHdQpX3HTIxw08NcGGFENODrmkl5DTpdHRFhKstTmEXTJfo1qhjVv5YIpmXfyPpohbYsZhyj/8NsJbkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VcaXggH5rFi+8YME6Nv2KSYT7IDrp/ZOXZybfPs0GQk=;
 b=YCWMl1rjgpSO/0wMDM4XlnVBuzGfYLVRKiOb+LlCF3g6Dlm09mk6qaEp56QaxBpZd2oyJafMisEmTyCDQRfwYQYAUrAlGWyZiVUYQN56kEDh0O4sRNuUXejK3s/FJXKniPMeJTDSJonpvEDtNqOkrn5fQmad8hi1bwSQjbzeBGWl3fXAs8FkLGvfrOQEZD1YskfEq0b7Jf5ySyloM3nS/6cI7HR4ALgIv+cHax9/d5N2gM4ZjTxd6+lMHiNKBFVbpOT896SKCuzwyebe/t+ihCKyhf6xdRNR+K+dpOkcr04y2sqMLqCg1P9XxrvjqGj/zSh3KSUf86VhnAkn10F9cw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 PH7PR12MB6441.namprd12.prod.outlook.com (2603:10b6:510:1fb::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Wed, 25 Jan
 2023 10:34:54 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::5464:997b:389:4b07]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::5464:997b:389:4b07%4]) with mapi id 15.20.6043.021; Wed, 25 Jan 2023
 10:34:54 +0000
Message-ID: <ffcf2438-3029-fdfc-ba68-37e77e5b7ffd@nvidia.com>
Date:   Wed, 25 Jan 2023 10:34:46 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 4.14 00/25] 4.14.304-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20230122150217.788215473@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <20230122150217.788215473@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO3P123CA0033.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:388::11) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR12MB5444:EE_|PH7PR12MB6441:EE_
X-MS-Office365-Filtering-Correlation-Id: 64b93228-f2ef-48ae-5437-08dafebfcc1e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3qknISxEVVdNL1ZNbt0aJcT4kejYbOkLvN1247FFOjAbTf7NXxDgpHIJ0Tqnc3OECXYJy4E+IKvZic63jx7/S/w7a2mMNxtFh9FBbsN9wsqirFNAxNPqlVZcED/iZUB6p/4U9y7Z7WN2RUGXm075ET3qtb/yPzk7ydENq9JoNVozVKuA0NTUzsQNbfgOGKe/H4ej9+i13UyX71NBTKzkyE5HU1zcQ+arjqYtgEPTFPIxfb53T8oX+SYQzWC0P7tKeHunp29qvxAXgDt/jXUAaCpFBCovhzw2pNmwVEJjxJATacncVAHNBLOlwsuD4q5lZYlJTVjj7ig+0VJg0e7NJOgHcQsoEuPCdC52saBkFpNTG7sPszqi7x7t3yMwRqxzY8ylOnoLlmju93ZIqYW4RbWcBQSQ6pdN/YJowNNL+Vmep4m4WWmDy3LQZJ/mKgzrW+ts/QngNp1eWk3bwkNjHYlqjpyd/IIAKDuuDcdZ2Q5oNvgx3vuGoYhx/maZl3QUHxOf1MKsc0ALtSxm2lG9rlxGu3AiuPVOLfLPhcKge9Tk1me+cMQhBIFxiDeC7wxAD74OsBBwbHPrHwy5Od/377vp1Upm01Cm4uZSQOSpX6o+bQWyQ287mdbnLTtoLSfEz1jy/QQUUy4TP2YDq2Ul08UJyMfp/gsvKopJVTrrQN9CRb0Nb2gn8TJv8Pe6ZIIf4vepAJQ0Ruc1X/+MTYW+7fY5Hp8HRYmWVxGepvIpws1XnpZtQ2wzBqbIg7cGXHqbfnoPtwt8VH9KwlZZTEJhpfN20HJeLGp3P12NAiCXUOJGOoLMfjf8qciLQUaqCoV1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(396003)(346002)(366004)(39860400002)(451199018)(7416002)(5660300002)(2906002)(36756003)(6506007)(316002)(6512007)(66556008)(478600001)(31686004)(86362001)(66946007)(53546011)(6666004)(186003)(66476007)(4744005)(8936002)(2616005)(41300700001)(8676002)(4326008)(38100700002)(6486002)(966005)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RXhCS0I5d3B4aXZ4SEltOU9hdndPNDNrcmpKYm5HdkR4ekZXWGNhZGx1Yit5?=
 =?utf-8?B?UGN2amQ3d0dwMG9NVzllRzN0RWNJbm9ZVFlxbUIrVStpWXRiZHVYd2JqRHgz?=
 =?utf-8?B?T0ZLTDIwRmFyQndoS0ppTmtiNU0xaHVDWXpweHRQYkVwNmpkb1RiS1djajJS?=
 =?utf-8?B?UE0xUzhrZU5tZ2ZSbm84R3orY2dqeDJsTFBuVEk3VmpkWG1VYUJyN2FETVpJ?=
 =?utf-8?B?Tk5KbTBiWDNMblQ4M29hM1VxQ016aU5aMWhtWnJEeVRDemhpUjZ4RTNwSDhQ?=
 =?utf-8?B?WU55bDg1c1ZJMnROUG5sZXFRbkJJSWFXeUJqemJaWWFvRThTNUp1Z2t1dWth?=
 =?utf-8?B?Q0NrVS9IbDJnZm1zVHJvUmhWSDMyRG84c2xTZEFHbWpCelY4S3haeHVCdEt1?=
 =?utf-8?B?SlJaWk5qUkNoYmZxN0hZOGlNRzM5eEN3MDE3K1JiTWVDeUdueFNKNGZ6QzBJ?=
 =?utf-8?B?cWZOK2ZpTVFERjZaRWdxYWZPNVRSN0NRTU52cytxWGpMMFFDNmd4Ym5paEcr?=
 =?utf-8?B?eWZRVVMvK0VKdEQwMU81dzNlTXp3L1cweFM0Mk9jRjFsTmduQnMyWHZSRHFO?=
 =?utf-8?B?cmhkRWZGLzJaNUxMdXIwbDZhMW45ZVhvQ0xLNkJuRW03S29uenV4UUlWNHll?=
 =?utf-8?B?bHJMM2prQlpKUmpTTHdmZEhDV2xIVTVKUFdSSUE3bXk2bVJVVmFRSkJSYVUv?=
 =?utf-8?B?RzZmNUNmWTNUMzRyUFFRMGxsSkdOQzYvVHRLTzN3UDRmNURaV29VekRXY3lQ?=
 =?utf-8?B?c3k2QS9jNWtpdDNKVlhoclNPS1hOTHhIV3Y3SDlmLzJhQXBEdnlBNHpYMXRM?=
 =?utf-8?B?SFIxc0tFN3ZZcUYybmp1b1hSMDFJTFlNNGUwbnlHdUN1cndISXdkdllWcStI?=
 =?utf-8?B?V01DRmFrb1k1dzQxWlJ4aDloOWxKREJER0Y0QjF5Nm5qRHNVTEtjWjFuOFda?=
 =?utf-8?B?eHNVWFhmcGpYZHp0dXNTYUZnWEtDNWIzZUw5aE1LNkpzYnJQNHhIa056dmJP?=
 =?utf-8?B?azBBVzJKRCtzeW5ZWUpoWjhrNnNpUGkxMFBRT2RCQ2UrWWhkMTI4cG9CbnVr?=
 =?utf-8?B?NHFiU3lRTDk5eGs2RjNBSSt4eEVEV3B1NjMvSkx6UG9PWi9IZkZxS0RYMEZY?=
 =?utf-8?B?ZXNiRFY4ckJxbU9SejJCaTdhbDcxQjg3bVJaRFR2Mk84YThCVGpaYWVzWC9Q?=
 =?utf-8?B?Vll1aW5hWmpqL0NHM2pRVy9uMThEMW5lVWxSc041TXgzQ0JBdUNCVHdEZGpq?=
 =?utf-8?B?a2xBK3hUTzZSTm1WY3d3T2VvVzZnWUYvTENjY04zWmx2dXRENlZldUgyY215?=
 =?utf-8?B?OFFoYW1qQjh0U3NMUHd6bEhsNTdkWWJ6Q0xqVEE0ajREVmtlUlZ3TGJZZWcw?=
 =?utf-8?B?blRGdG10UE1jNXlDWkg3bUptZUc0OWVNT1J4amlCOUl0b29HcHZ3SVRRck9S?=
 =?utf-8?B?cTF4VWswN09sMXVMUDB0aFMyMGNTb2NNamw0anR1QjFBRlhqVGNrYmxHYzB4?=
 =?utf-8?B?VmhVQ2M2eTFTUDNHM1ZIU1FVUERHb2dMWTFKaWlVUmJBdFhGUk1qK1ROUEgw?=
 =?utf-8?B?UFhxWWtXZDN1YXRDa3FORmR5czZvMUdyb04xTjBuSjFyZlVFR3VVV2kxQzha?=
 =?utf-8?B?aWZ3ZnZKT0YzeTVnOHMwdENEOHZXQmR5bHNzTFVuUlRLUzBqR2lWVGoyMTZO?=
 =?utf-8?B?bnZyZlNiWmc3c0JwMDJZRittMWI0Umt0UWZDQ2RoVWJaeWpVM0c1TEM5Vis5?=
 =?utf-8?B?cWlBMFR3dG1iUS85SGJ2cExsWHl1eHBKbWd3enpYaFdpaGFXdG5SUzBxMDNX?=
 =?utf-8?B?UTlhQktUQXU0c0FNTjltVGV1NFJxN29URWxBZEdnVVBkUUNsZzluRE5TSGMr?=
 =?utf-8?B?TVhGbjlPVjJWbXNNOS9JNEF4aVo2ZHRaTlk4YjlGZXVBandEMkRNVFBPQ3RD?=
 =?utf-8?B?OTVTVDBZc3VHcXA5TW9md1V0czFmQU11dXdCaFFXZ2FpOCtCWE5iZS9NNXBq?=
 =?utf-8?B?SjdJalIwc3V4RVVFYnpOYnBYOGdxRUdnVnZScmFoZHpWeSt6QldHQVdweGxV?=
 =?utf-8?B?M29Vcm1reisxSnFkNXJvVUdQdmRuMC80MEc0RmYvTTBmMlNOQkFYVGxKTEkx?=
 =?utf-8?B?NnJpT21HTmpvWWxSQkI0U2w4N2EvTkNBaFNKNEpPZG9TdFYzRlZNdkVUTmQ4?=
 =?utf-8?B?MEhUUnluY2xjWlBWYUROYkNsWUhsdWd2aXRVcDZMaUYxUUpRMEFQYW1MMnkx?=
 =?utf-8?B?a2JiZ09IZUpIeVlOZWRtM0M2VjlnPT0=?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64b93228-f2ef-48ae-5437-08dafebfcc1e
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2023 10:34:54.6532
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VzLnIpg/qb/kbyFD4Y8uJImKZ/L2dq/mp4jFcsT7UKoqaO3EJjXx6Q7sJlbSbA5vSVCOYspv9Vwh2T8UUgTh6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6441
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 22/01/2023 15:04, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.304 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 24 Jan 2023 15:02:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.304-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


I am seeing some internal infrastructure problems this week causing 
issues with our builders and so only have partial results at the moment :-(

Jon

-- 
nvpublic
