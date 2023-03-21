Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 969226C30FC
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 12:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbjCULz0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 07:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230398AbjCULzZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 07:55:25 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2057.outbound.protection.outlook.com [40.107.243.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52AD29028;
        Tue, 21 Mar 2023 04:54:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=drZMaGQ/RCAN5dFYxbjQQX60ASSwZknMB/ANTU6pO9woyTG+97sXVw1RUaaRXEW2aMshBJw2v+UozZJ1vJ/6rQEaFwMw1qkXDspO/Lm/I3msZTFHfnAl/KsuUI5EVCYNzWmGS6IigPx08LpVa6ngM8jYYMe9zAkpAPnJBIU1sQs9C20lWfo/i7zbSo00LoryYb8buB0jcsgc9QwFhc5z9ExBUKzvtCuWHuzwqQUBahy8+efA+HTrG9Q16JWTKuJV4zZ5/fYWNmlId5HFIjMaVaLylLXQkEFcOKG97LEd4zwmfPKZmYPC3nl+VtGB9wyWYlv/DKQZqVYwmnwcmpo2vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=48IAe7ZoXnQ8nyJX1Z+DWYnEZV+jnW7fE016mwzrDpI=;
 b=R1qQ++bOCwwWpoMbK0QBLL+UGmycKvQ9KJUt3gSpIlkWI9ZoM9o1YnyBhpL5HXJ6s8dNSZwTFxaYqisZZrmGQQF2mDvdlBzyDvg+V3pthtBVv0v2V6wM4FVgsxIBtrbCHUM8rO26xB4gO/gJ3gocB+9g++zlO9qlIGvdrEe+OfCb89xJqq/BsDuq6/DII7JJHYZlyYrvinFJJLoxNafkFi8+CWJ337Mrmgaio6TxBaT4tVyGEf+KMrowLREO073aQQRkNa0IcUOjFPa3bCdIXdUUR41DWyLgPUy2kdEAIv1s1Clkj/dAAgIwIIVAVpBriOtGG5E6d+wzw3nGIxoD9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=48IAe7ZoXnQ8nyJX1Z+DWYnEZV+jnW7fE016mwzrDpI=;
 b=TWHBlZwp2/XrPoXQoiOAO87lltF3cfffamUkpps9PAMZChiz0xGgrTfsCVaZJ+oAEuIvAG8R7fzALwe/9z6GpC76tJkehDtmSjmbxihVVs0ymoepZszJjt/VyA7ESIIiNQczcFKS0LosaSvL4YU/bUe4L44nJzGa5+IIa2wKqWar2Maxso1TYMWllbBf+73yH276AME6/Kk8+kQFrXVUgKHBt/3/yxxeBeypQZ5rssvxlglxgCXm4UBt3m0IqsLJWuOwJfmta6r1rmTyGjUeZ4O0TQF4vdBWzT9+RVTA+utKTHytVA5SyNUvP2QjpkfuDZZjl3OdaHA4pW+DOjY1Qw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 SA1PR12MB7198.namprd12.prod.outlook.com (2603:10b6:806:2bf::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 11:54:54 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::5464:997b:389:4b07]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::5464:997b:389:4b07%9]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 11:54:54 +0000
Message-ID: <be659a31-9e39-826f-6f47-7e875ccebb24@nvidia.com>
Date:   Tue, 21 Mar 2023 11:54:41 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 5.4 00/60] 5.4.238-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20230320145430.861072439@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <20230320145430.861072439@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P302CA0023.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:2c1::15) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR12MB5444:EE_|SA1PR12MB7198:EE_
X-MS-Office365-Filtering-Correlation-Id: 0472b344-a4e3-4ad1-ae5e-08db2a0315b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6CD7Ni1xiOQbALfGZt4XxfesnFik6LD1p5X8hNCkVVCT4STlykU7cHs6YBcGiD8yPOEXmAd1uLlHwHynMQi9h5qZj3hqapLbOmXGePmeOpjcN7Vjsoicemhm/E7cnVPdwyxhKIxcwiFfTUxZHAsly3yA/8HGL2bV72R+/XODA8CKLIDckbVVmSGWid9aGlHGUWMZ+xaq8CoZKxVdNpUONe7VvzBqSFuqrdBvTj351agpwZ7xv/3FwDChk94dZKgajhtLCTB+EvFmnJqDT2xeyTbf9nthXrYUBTGIs7lf5I24Cvz5a4M3Ut2nxsPtg2PKC2V9uXxeSUBH/xn3V6pvLuX8VsA8UQCVH1S+QEuJKgabFxV1hGKijzQt90pDBVnk/jwbZcSJloqQWK3XIi57caV0RrARGwYRHZec3W7non5I6o9PjDgGssa0OjUbzwnM7CEUj8gHKSb8xSk8gISIEwifEwAcYi3DY45st3s3WlKO+QUlamgB+RHNiDhlzkjIYSnL+EbF2wYD/OYSnVJkppewLXnWcx6VgwA3LQeWw3aHVvB/t779rDHjJMOoORdPoWGfHjJ4AyuJvI4tPYmCps9s3GJ1nkzfRBFWv3ok543JEhcpymaJkpJjJi5YL5WBe+0IFU3N4Hf58zxvK6WwJ+MHA96efbmWNWkDJGz6AjCGOrBuGq7+p0k5WlW8IkcnIoJq550Naih9nyN8tovcumgZGu3dn3E5M5A7TbXgPUIzHJwO3oWKU0faYHrSmskB9wj57rS7H7BY1XlMqAlTmQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(346002)(39860400002)(366004)(396003)(451199018)(31686004)(2616005)(6512007)(316002)(6506007)(6486002)(7416002)(6666004)(26005)(186003)(55236004)(53546011)(5660300002)(31696002)(478600001)(966005)(8936002)(38100700002)(86362001)(2906002)(4744005)(66556008)(66946007)(36756003)(66476007)(4326008)(8676002)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Vk55QmRiRkFsUWVwZzN4V0h0cEpqN3pxUzFtODdsWlFQblFSazRkeU1UT1ly?=
 =?utf-8?B?cGIzWFFKbmpiYS9KNlVZNFNIdXBTOTc1RWRQOHFSY2JFNVNRS1lOOWVrTzJF?=
 =?utf-8?B?enRVZWRuekorZGowWnNNK1BjanNIMDVQVytqT1lMQ3pVNnAxR0lkSW1GN0Y2?=
 =?utf-8?B?QS9xMFZXV252czJjMUlRQmppeHNyWHgzVWVoalgvRFpkKy9RMElWclc4QWpx?=
 =?utf-8?B?R2lNY0ErdXZYQTcvYUllS3I2TWhJM3F6a3JuRzExNTU0QVR0aXNMOWtuWDQy?=
 =?utf-8?B?TzVlQlpTWE5aTW1tUEU2MndQaWRiVXoybGhxdFMrUDBoN2hNZHlzWldaL0hw?=
 =?utf-8?B?Vmg1WHh6V0habm84RkphR2FuclRoNFZTUy9BVmJONlNkM2taY0Y4aDk2dStZ?=
 =?utf-8?B?cHlkN1NyYUFneVNieGRHTHFua25VNVRQRy9nQ1p6QnBab0RyNGp6Vmt2Lytz?=
 =?utf-8?B?Wkx0Smw4TUVOL3JUTGtzSkVCU3dwbmx0VTZuK0pJNEdsNDNGWjY4ZmRUMVVV?=
 =?utf-8?B?aTFmVFh5bFgyQjVzYjQzZ3JvRjJVYjluV3hISEpWVHpvWk5EeFplalVjMUJF?=
 =?utf-8?B?czFLdlFpRGlYTGRkQVJZbkdxVEdYZEVkUVZJalNzUGJsZkJGMG91MmdURFBN?=
 =?utf-8?B?c1NhNzZ5TW9RMGVwU0M3VnZGQmtxa1l2alEzSnZVblRoYm82NDMwb0RpZTZp?=
 =?utf-8?B?R2R6R1FEeUc2TmNJNVdacWNtMFJ3RHhFYjIrN2tTUVROSENUM205QnBKdk1G?=
 =?utf-8?B?NXNZTkhoMGgyNnF2NlUwYUo4dWpRdmdTcEp4ZlVkSDZmSjUrWVhlYnJGTDhk?=
 =?utf-8?B?S0dPSU1kclluOTlhMzdEdEEyMm1PeDdJUlBZT0Vsd1NzWFlKRGNPdWpBRHMy?=
 =?utf-8?B?RDczSUgyQlk3UHQ1RnBTNys5TjZkR3JmbnhrUmx2aEJXeXFxRnJkZ3JDU1ZX?=
 =?utf-8?B?TDNHVTB3Y1pQZjlXQnRtblN0MVMvOVZqQTZmcGtqVnEzcXB0U0JDeXBiZ0d4?=
 =?utf-8?B?WkNmb2ZBNUJkTHRoRmJKTUZadlZ0SlZrem5UMVgwRUxRS0pnNW9pRlpldnRR?=
 =?utf-8?B?YnBQTTFkSDlidUZwSkgwdnRTZTJycnd4OEpNdmhDVVNuZWVOSnE4dktRT0Jy?=
 =?utf-8?B?RjdWL3AreUVmeFkrRGcwbmNTelc3ZHBHT3ZVUTh0ZXZmanpheitES3Irbjhj?=
 =?utf-8?B?NHU0NW9ROHBQKytKdVJKdGFjeWxpaWpCN0pnWFdkbVdTVlBEZGllV1NWbjgx?=
 =?utf-8?B?VEQ2UUdUejZ2a05FWDJRTEpFcEZpRnBJMEEvWEp1NDREMGR0aTFQNFd4YXhM?=
 =?utf-8?B?K1N3YUUxT3BuQmJ6b0cxaXpMUk5BcENVY2RBeTFvcDVpZTVla241dnVoN2Z4?=
 =?utf-8?B?UlR0Q1VKVXpmZzZ0bGJ4dDc1aEI2RlpmZEN3MExraTQrS2Z6RW9Wa3I0Mkg3?=
 =?utf-8?B?VUtPN1JNbVRFd2pualFrdytWSG5hWXQ2c0NueW1YNGpjWTR5eHZqTFhZck5Y?=
 =?utf-8?B?ZWIwMDRmcXNISFZYbk4waXIxY0JNb2cyUGVwbVJ2UVM0bEVpenBBQ3hDY3NR?=
 =?utf-8?B?eXA5V09ZcHBqL1V3UEgyandranBHUmw2c2o4bXlTcXJvVmF0UE5pbkVyNDBx?=
 =?utf-8?B?TnpUd2t4TkhLRVFDN3RYYmpXSkhwOEdhTDlXSVNOUWxNU0xHb0pIV3NVdWUw?=
 =?utf-8?B?TEI4bnpqMGJ5czV6Sk9qSms1aHk0ck1FclBtTVJZbU5sNFhFT0lOWHg1enV3?=
 =?utf-8?B?cEZISkRPVHAvRjlNcnY0dVZLZktZOHZGMHNSZ2kzWmptOURFeUxIWm9EQ3hE?=
 =?utf-8?B?WkswaXYrdk1sT01TQm1rZ09KTERqVzAzVUlMRnQyS3BpcG5Yb1hxVEZUSTZs?=
 =?utf-8?B?RVI3eHQveG9kSFd0UkJvR3pMQ2lFWWZQcThRVW5JYzNZU29lZ09EbTJCU0Vs?=
 =?utf-8?B?ZHVFSFlPbGNqWG1ZZVBZMHNEM3d5SzM1MHM1NHdYZlc3cTVWZ0xhNHYvYzRj?=
 =?utf-8?B?WlpKUng1Q3JIWHZHMW9NVVlQZDEvNkRRZU14cndUM2tZQ2pqckdDOVR6Z1hY?=
 =?utf-8?B?NTJXelZEejVxbHRDT0xBa2VWTFc4U2lyQWp0YS9kZVBBbGJ4YThCOUpOUXhn?=
 =?utf-8?B?M0VuZXZZdTlBMmM0TDR2YkhJSUhNSVE5d3hZTnZ0dU9sZmNoZEVaZU5GUHhI?=
 =?utf-8?B?RUE9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0472b344-a4e3-4ad1-ae5e-08db2a0315b5
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 11:54:54.2897
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KGh8ydLVWYo3wl2IwZUsbFsuag4j+/8lxoI63oIq7Q6kbZyhixyGzzDb6AGPOIB4wKYtDsWbwdpEfY/WlvpB2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7198
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 20/03/2023 14:54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.238 release.
> There are 60 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Mar 2023 14:54:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.238-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra.

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Due to infrastructure issues, no test report available, but all tests 
are passing.

Jon
-- 
nvpublic
