Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39C584CD085
	for <lists+stable@lfdr.de>; Fri,  4 Mar 2022 09:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232134AbiCDIz1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Mar 2022 03:55:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbiCDIz0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Mar 2022 03:55:26 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2065.outbound.protection.outlook.com [40.107.94.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D99819DEB2;
        Fri,  4 Mar 2022 00:54:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hn8wcRvhNK2pDXNMoWtzA0IxQyEZpqG/jIM4ZIfUq3ocrepCdchydmVd9+2j8BYwHLaD/HTkiwklAJ3saqSgXy+Bdil96vZP2A9VZeTQfVJag9a5xHq2RWPTkAigqoVex3qGECCh9Fir0XMuaN1TaLUldtp+OCXdwpWHiqSrYe2+lTeZ/MIgUqzmjpfsC51vA+07vdhq99bpXly9E+d3crJ6x0/Y5vCMD9YRnOJhwK1ZTwxyGC2rPeklaXDLihXHa0/8AYgxJWz2ioNZ/0eJSoBMS/vQAXx/mlbThmdJL5oai92buhRp6Zdol4ryRRkacwUq+jEbVZbvh66CI2/VnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/r+MatPPCy0pohx0s7qXFkl3DnCYd4LOmBIhKQGzTS4=;
 b=Ru/EosZHrGV3Y5/vsEQ9DYkSsFuJJcB64LDiSNZrTc0QbQ/8VtzL+UrpIsZFMEyxlnCwF6Eh1zz5AecBP8qwdA7bPi4FtkfR1NM2oHaEVlD9RrGoH9ar11Zk+NpOmr/7VOTd26W6MUH1ELcBTbDxVd/c2jYWFVKXOI5IcHdaxG7ivDXi1ArBLK4g+71HPxf+NeewYTiaPor1y7MdalyCXNrcGA0JUyzusUgS69C2aHdKtRaBFAlrxyqNI1p2/4wR9dEsoXxT50aacJJKVBhzNOF22e9ZEB584kZB8+aa4X141W9dGSluTQsGyfW+q9iK16eOUtdwGUoLWmNLbqQ0kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/r+MatPPCy0pohx0s7qXFkl3DnCYd4LOmBIhKQGzTS4=;
 b=a6DoSsZEZtD/v1865SsRnVaoEfwjvgLyrZcdSUaUZVCnqfXgvJR0x57A1py5RsPYRtACBrq/Jcivl602kYzvFMmhvEZnPOXxmIb3q1e9vSCF7ZoLbFWX8aRSp7rJ2QYqERwhtsejnzngr/USwBSrdz9cvy+tB9uVrC71GsCcxTg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BN8PR12MB3587.namprd12.prod.outlook.com (2603:10b6:408:43::13)
 by CY4PR12MB1816.namprd12.prod.outlook.com (2603:10b6:903:11c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Fri, 4 Mar
 2022 08:54:33 +0000
Received: from BN8PR12MB3587.namprd12.prod.outlook.com
 ([fe80::e03f:901a:be6c:b581]) by BN8PR12MB3587.namprd12.prod.outlook.com
 ([fe80::e03f:901a:be6c:b581%6]) with mapi id 15.20.5038.014; Fri, 4 Mar 2022
 08:54:32 +0000
Message-ID: <dbb0f319-5e54-8a86-fcee-2c88c9891898@amd.com>
Date:   Fri, 4 Mar 2022 09:54:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] i2c: at91: use dma safe buffers
Content-Language: en-US
To:     Wolfram Sang <wsa@kernel.org>, Michael Walle <michael@walle.cc>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        stable@vger.kernel.org
References: <20220303161724.3324948-1-michael@walle.cc>
 <fff424e7-247c-38d8-4151-8b0503a16a7d@amd.com> <YiHIIjSs03gDJmHV@shikoro>
 <4e25e595-cccb-0970-67b3-fc215bfd5b14@amd.com> <YiHRGa5bDJAuBuHj@shikoro>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
In-Reply-To: <YiHRGa5bDJAuBuHj@shikoro>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM7PR02CA0015.eurprd02.prod.outlook.com
 (2603:10a6:20b:100::25) To BN8PR12MB3587.namprd12.prod.outlook.com
 (2603:10b6:408:43::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 907f7b6b-a15f-42dc-00b9-08d9fdbc996f
X-MS-TrafficTypeDiagnostic: CY4PR12MB1816:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB1816671B2E3CC1947950AAD683059@CY4PR12MB1816.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NQg0o6ElwuDjAF2zwxdianzTthERJcOkdffV3ZU0m3/ilSQqPTOIprbpmkFlOAfd0Hy3YZl5sHB/EMfY1wJIMGuO9umQu25AU0jiggjGTxs4xUxQ5TdmlzJqKxsd8mrzEI/ipA4fblN7ZMiMLDX55Plczt8bFTO2TMwQ1p9/vK1jyK21uvC4EuB+FunC3pBPgAEvAlfvkvzyNAY9LSYwMF46JLG4+u2WBRA6tqpPTYe0aWNA0el6ESCHmGf57GFbyYLtmu5zu0dcsWrBfJNUHqWkSJGj6fo8o+aqd1PhJXQG/TTL44720ZfTFgod4T+SD9+R9EoATqPyP8TclBMnAyEsWgShpE84bKAu2Q43esQbaII8XTjvwNNyY2IpcskjX3bcG/rlXTyoUExHuFwhnUOvoqKBw1gfwG3yH6f6agW5D2hLjuMERHSkIGmqGOz3POgDiZA1rwVEqsrDvovLqJxmV+DChbyQLOqxF1xwPJ5Pqp9RUza3Xi+RBDoNPK9ZpWp1kekpaVhLJ3rmXSA5MniUAV0pnvsdr8vddb/DIDfZ74/Z8N2WuCXLRxHxtyDFYGxSi+DdMiaPcuh61up+yDQ7Upv1tokFgEDm3neSjvcw/e4L+wzDIBz9KzzNcSh39CFjgtMQ7MyLXhQ5Bz2KBAaM3uxn/JyFUR0bd0uyOC1OcI9hkDxApwmh9qk/gfNHUt50FPG86nD+blTiiB8GU9d/UtDFYUVhx04god3ibTZRoM+n2gr1d//Wz37wqNdrWaWiBHYZWjDDUIlMMCKW3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3587.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4744005)(7416002)(31686004)(921005)(8936002)(36756003)(2906002)(2616005)(26005)(186003)(38100700002)(316002)(110136005)(6486002)(8676002)(31696002)(86362001)(508600001)(5660300002)(66476007)(6666004)(6512007)(66556008)(6506007)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z3BMSWUwNFV1YlNUdUtIcWJOdUNZaCtyejk4QTZzSUtaOGJRRERHcFFBb2t2?=
 =?utf-8?B?YTVtc0NvVjV6c2lRUHNZdlpQc2d5dkNyL1gyQlB1TUcwM09Wei9IRU0xTGNE?=
 =?utf-8?B?K2E1SlhWQXN2bVBRdzVJV2lyNFp3M0dlSTZ6ZkZ6cnRuN1NmTzdhakUxQkk1?=
 =?utf-8?B?V1pQSUpkT1IvdnN2L3NQTmlBbVZLdGt5ai9ZblVGaStwN3o1ZzVUSCsxTnRm?=
 =?utf-8?B?K0syVHJVREtDblh4SFZBaFlwdjNIVnBob213VlhUNHBVSlJieXlNY0xYWnNX?=
 =?utf-8?B?Z1R6RllEcnRVbnNlcjZjS3VqNVZ4THo2alMyZHdCRzVXVzA0V2pHeTU5OW5s?=
 =?utf-8?B?cEc5WGtqSkdpdVJ4Sll1Q1JtVURwQlRWMWJWaVVnemZYZHFTREpmdHNrY2w5?=
 =?utf-8?B?TWxhbmJQamNOR0xkdVVTOElSQjMxWFAxV0E1NGpHb2tpTDJrWDhxUTNjbTB5?=
 =?utf-8?B?TEMzVzY3YnNWdDlWa1ZhY0ZuRUpKc3M2djdUNFB6elJCOGM1TWRkMDFEb2g5?=
 =?utf-8?B?elBMM1FHdWMzcGJhMGN5NGQ5cUZZd010MW5tNmhmaTRVRzVjaCt6cFpBMGdQ?=
 =?utf-8?B?aUxLM0dCcEp0M0NBcWozQkhLK3BvQjhFMUJmeFNDL1pFWENOcnBJejBaNjNB?=
 =?utf-8?B?Y0hxeU1zN2N0MWhTTGNhWlZ6WGlXWXBaU0RzWkFwdlRRUnVvZXkwQnhnNzF5?=
 =?utf-8?B?VituaEw1TVFSWEQ2Wm9JMlYyajg1TVhBRXpiSDVlV3BENlFsUFNkUXM4Y05u?=
 =?utf-8?B?N0VTRlJLOHFEelVRZTJmMTFPY3BkYnRZYVZneVNFNVpTYm01RmZrVVNITDdJ?=
 =?utf-8?B?ZG9BMWQvcUlwZC9oVUpLbnVJeVNlanRQNTErNGpVdE9PQ1AzTDVrUk8wclZN?=
 =?utf-8?B?bC8xTHJ1LzlEMWFRbFlMcVNXYzQrdmZZWnltSlY4WnU2TnBpSWxPVHdGSEZ6?=
 =?utf-8?B?L00yeW5GYVdsWWlrSXVneThYYU9sejdHY0FxbmJDZ281UlJoVkpyNC8xV0dn?=
 =?utf-8?B?Q0xuM0JHVzBPaVc5eVFBMTB5RHlZWXRtTjZtWGxDSHdSVDFINE1hN3BXaE9T?=
 =?utf-8?B?dTgzM3AwQUVlU2d2c3RwVUdXalJvdEpIMCsvbHd1WGRIeU9WV0FDa2UyMmhU?=
 =?utf-8?B?MFoyZzNkTnpjbGFYOG1DSmUyaDFiUTcrWFhBd2JmQ04vcElkWjJIR01RK1Ru?=
 =?utf-8?B?MVp6WFFEdEgzZ2pSUEVlOEppOEVnWnczUGRzeENUODBkNDduN3hQeTJmNlRz?=
 =?utf-8?B?QnU2OW5Wa1NDYWhhMHI0dTRHRk5IbzJEQUtFdlU4ZUY3N1o4bVpMU3U1K050?=
 =?utf-8?B?a2hweWF5eVBidEVOalBVT2RpazVhMlFVTE4zWFBDdlhaNjJNcDcremRNZmpV?=
 =?utf-8?B?QjJEU2FqSlVEb2FyK1Z6dFdkNEcyZVl3U0tqQml5NVlmb0FkYVUrUHJQY09i?=
 =?utf-8?B?OWJSRmcyOHVQU1ZoeFBhUHoxRUlWUVVkZHBVU1N1ckh4MXlmdnNKUWIwVTRD?=
 =?utf-8?B?WHQ4U0dUYzlSZXZMaHQwdmNiZVhXQTBuSXdsK1NEMERMRHZoZC9Ybm1ETmNC?=
 =?utf-8?B?YVU4dm9kcmcrazBmaW5vV2FYY3hpKzZKYUNvVVE0Vm9YMEIyQ1h1eDQ2VnNJ?=
 =?utf-8?B?ckVDTk9hSmhDNHhxOG9xWEd1ajBzYzFGbmd1TnJaSi8yZHVWcm9nQVpYVmc0?=
 =?utf-8?B?dks2ZVZrams3a2o1WW9jVjFsRStJSDdVaTFNNW9TMVJvbVQwT09KaWdpb29X?=
 =?utf-8?B?K05peXhLbzNIQ0k0dVpLb01jQnF0cTBORWIrbXQweGhWQ0p5NEJsNFhpMXJP?=
 =?utf-8?B?WXZIMWNnV1VrWG15YzRJdXc0N1B3OVRSZVVnNFUwblNvSVhsc3VuTzhFUWhU?=
 =?utf-8?B?RG8yTVNNcnpMOFVSTFhVeWdOZGpYQnc5bEo0VWhOUXlZVVcybER5aGdWUCtp?=
 =?utf-8?B?VThDbnJydGgralo2Um1ZTkQ5WHpRU2tWTXBTTHJIL0N5T0xKWGp6a3ZUSUp5?=
 =?utf-8?B?c2k2WXZlbnlXUVF5UWFLOW56aFJkQW8zbXA1QmttRGV1ODdDWGkzemZyVkYr?=
 =?utf-8?B?ZllsNFhCdEV5OFkyUVdlelBLUHgzZjdPNnM5WlVTVGNzWUYzdU05QjNRUnl6?=
 =?utf-8?Q?riMg=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 907f7b6b-a15f-42dc-00b9-08d9fdbc996f
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB3587.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2022 08:54:32.2315
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KzoCr3sb31YDjLEqJIDLukpBXIVC1OrdSk0616uWIzt1zepnbTv4js9TnZU03/Dj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1816
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 04.03.22 um 09:43 schrieb Wolfram Sang:
>> I'm getting quite a bunch of unrelated mails because the regex is not the
>> best.
> I can imagine!
>
>> On the other hand the framework is used in a lot of drivers and I do want to
>> be notified when they mess with their interfaces.
> Sure thing. I am convinced the regex can be improved to ensure that to a
> high degree. I think it is also less work for you than asking people to
> rename their variable all the time :)

Well not all the time. It's just that you absolutely hit the nail on the 
head with the name.

The local variable for the DMA-buf handle is just nearly always named 
dma_buf or dmabuf in the drivers.

Christian.

>
>> Going to take a another look at that when I have time.
> Thank you!
>

