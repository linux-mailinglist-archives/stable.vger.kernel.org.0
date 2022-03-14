Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9254D8685
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 15:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238374AbiCNOQE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 10:16:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231273AbiCNOQD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 10:16:03 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2082.outbound.protection.outlook.com [40.107.94.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB1E46443;
        Mon, 14 Mar 2022 07:14:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GbAcfVpOu5uYS2RIXS/ciQZzH5LUrymaFDv/7Kfc6nf0Byi2zjeHJMWAChP/p+DJmLbdl0D8XE2ew0orRVfH+jjZSq8pMk8Ff86G8SfzQvSYYSDBJncR7h70J7Q517CwUOtY+7ExHJ5zDT1gm8PnTw4//3dBxRbQFPt9lKWvyphc1h81DyslJ5t9hdkzf2JGAyrhlo0FJvrBi76WzIF5w8oNy/8hr5wRTjrTyvx9Xmskh3cAu09whBTg5Nk8DI5cQ7pPKRwd5mEleHANk3Uq5+sePZL+wNeBULM2MZHg2yF3imn0ba5d09ZlQIbIrlx7vqQOvTHpbRkF3kCW5DyuDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+gJHKDr9NWeifnjG/BY3mPABz75qJc/iC1roVM+yU8s=;
 b=CdOGeZsCmx3VnhXi0dUPTmHxIKHt3KErUN+vPUNAdhqG0PFdxprioMrgcGbr/6oWwrPqnEa8glzkp0H1tYb53VcD/K4M2zoJmnZBt6XlmyTWVQvK62mlLJbjkpl8sWJMa/cR8llH0sELVI9a6qUXxfaz22dfxzz0yGfyV4YA+6YiiLz5gtonveM9aI1xlNTG9OMjZUZ1tpt/SsoU6gUJxQ9ZO49ujDr6YC+NFHxUeIUdadqAvilI9MejGJlL036oL0pmYaz6kxMA1sE9XnZkH7UpM5EGw5ZDylFuoo5NAjPjecC4BI3hBAvITRVigFopnmVsinNWNdxfY7yLWt1nXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+gJHKDr9NWeifnjG/BY3mPABz75qJc/iC1roVM+yU8s=;
 b=JyfAWNUQYuheqIoHasDOgWd2fkyXY1gXKp/GLHopJ0t8PFOguHmUYgm0nKI4B0giDlBzea5BiNXt5UufYrhLfAASkw+wlC67sjj+eR9XAQUvnnsSTCQWFaOu0g1+fqWRShn64+DUCtHKrNjWQEyixBze+hKd5thlzuKW4BssfgW9bhrkC5zKTAyt1/K/pe0A/cuk5l6/bzyR6QNkU6conwzr7veiQzN+TwGe0HRqzocxqLSM0/+HSaYrfnXOdvWiK9Zt6vlxQhLANN9JmfsJwND0GvRZhJf/V7cxG4rpkIkwLbSmdy9itA6uxxiuFjfh+Xs9fEbd9Y2aT7kJz9zmUQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 CY4PR12MB1381.namprd12.prod.outlook.com (2603:10b6:903:42::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5061.25; Mon, 14 Mar 2022 14:14:51 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::88c:baca:7f34:fba7]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::88c:baca:7f34:fba7%5]) with mapi id 15.20.5061.028; Mon, 14 Mar 2022
 14:14:51 +0000
Message-ID: <ae60e4a0-3333-1ad7-1ac9-62e6ac3751de@nvidia.com>
Date:   Mon, 14 Mar 2022 14:14:41 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 4.19 00/30] 4.19.235-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20220314112731.785042288@linuxfoundation.org>
 <0ac87017-362d-33e2-eace-3407e0891a94@nvidia.com>
 <Yi9LlP+x2swdsrbE@kroah.com>
From:   Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <Yi9LlP+x2swdsrbE@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS8PR04CA0076.eurprd04.prod.outlook.com
 (2603:10a6:20b:313::21) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3e4f368c-d4cf-4a6f-f18f-08da05c500d7
X-MS-TrafficTypeDiagnostic: CY4PR12MB1381:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB1381A0B278BB34388EECE26ED90F9@CY4PR12MB1381.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UFd0nSVYwJK9vlERdXeaxL1SJ+9/ybzFCoGHcuHE9SdvPslwA91gEtDn5Rjx52SOJG3yJ+ucmNDrufvTyRXx8J5cG6S/zSw6bYJC8zrCCm7aR2zkurBvfdFn/RsU3662BfsW2yhSfNCtf6NyV0g9Q6+V3W3T/zRcWvbqn2549xEYw3h8/05180QL6T9LMZZvXz33MYWP2VzywsoaazBp2+Y4ptjnCA/KW3rMtL+4FvSHn2avUHhssMRkOD7lQD+/TErL5NiaNQJQfRejmaZJXTNP77SP1UXcVGL/CCDl+K++cR2kE32wL1Ob1nwKD3juQsDu4do8IsaKdHgRVxDF2SrMTIRhEA71n4HMeMHgrPKvDgmpqxWiLPF1K1zEziFDqOr4d0Po/apEx+gdM20/kLMhQC4feHhmrx1Gq00ceJcu5m2oKUbDDTUPmbgK6+8EMTJi8U3CGVPkG1qmXklJzkakcvLEHKjHSEmM8q6jqOtqb/bsgPAQlun2AHGXp5aZzFuSxOi5hcA8sLKGFnpcRCc21zV5C2oKaA9gNVGNSFVzEFRSp2g1IqakW0Dl27hcRJvQ4UBlUsNOVBG0kTWI62kwQg/f4MTXURAdrtKepz8bh2PNmlQ2M2niFN4SRK6k+MV26RN1yh2CL59TTRl1NCQkiAB43/Z54Wb+lNhKMPlGazc7hqeIZJlrMZ93iZdH7aaYxwnvFEKFpX9Dd9m1EAIFXzJGYaR+zmsw4D3zQ02HmESuiZuXwrW9f4l9KzxwpUOVp9gfJz6bJrWn/upJLXOBDgOY89Y2OFR6mpPgVWlfXxK3CPRyZwxYtu4cFi33nlun/tZVimqrkaaR/Kpc0w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(55236004)(2616005)(316002)(8676002)(26005)(186003)(4326008)(6916009)(6512007)(86362001)(966005)(6486002)(6666004)(6506007)(53546011)(66946007)(31686004)(2906002)(5660300002)(66476007)(66556008)(508600001)(7416002)(31696002)(36756003)(8936002)(45080400002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cUlIaTVPb2U3TGxBdjUxd21TUGdJd3VabTNUTHVOV3FUZWZOcVYycUg4S2Vu?=
 =?utf-8?B?c3pJU0lRNlpkKzJ5U3dqOU1OSmIwSVFrakhiZzlIYU5FTFhKdnBFckEra1FJ?=
 =?utf-8?B?b3lOV1lrN1dHRXJrTURySFI3ZHIzMWl4NlppWmJ4Q1lDRTAzSE8yMCt3WGp4?=
 =?utf-8?B?ZTI5SExFVVNpTDdzVWpNZFJ4SFNOT2JUdkE5NmkzY1R2ZlpqT2l3Zlh3d0Z5?=
 =?utf-8?B?TnVxMUhHcHlSTWM0REloVnlHUWo0QUFkN3NpNndRcnpYRTJEL2g1cDZsOTFi?=
 =?utf-8?B?dVFtRS9ob1RDSVFjK2xtRWRxNEFoeERCYXRiS2kxVDF1N1FsYnNLRFZnQmNp?=
 =?utf-8?B?dW9Yc1lNS2MrTXkweEJYQjlzT3RyaHdPUGdGalVPaGVvMEc0YWNUdXdMZGpP?=
 =?utf-8?B?YXlEdWZYTmlycis4M0VZUTlldVlxaFVUVDluNGJNRldBK0F3QzRaRzU3Mm1F?=
 =?utf-8?B?bldnd3dVekQ1OWo4UDZ0cURLcFdBT2sxaFZWcGpQNlpvYVV5OG9YNWw0czVL?=
 =?utf-8?B?aUpxL3BvcXFSdGtSazRPM2wrZmFjUU03cnJGcDR6Z1NHWEFMK3F6cmt4SXBq?=
 =?utf-8?B?TG1HMTd4RlBwaTJpalIzbW44RzcvS2k1c1FoYUg2aGNoVWNCdmhRTjd3Smow?=
 =?utf-8?B?Uld1Z01zWm4xWStveExhb01IMjdEYjZKdHFtK0tSdkdvYi8xVUtTOHU1QUs4?=
 =?utf-8?B?Z2EwVHFYTndyWjBUQWFHdnF3eXdHT0pPYVhYTDZ4M2xDNXI0ZjU0Z1BHbXJz?=
 =?utf-8?B?cW92SFNTTndsbThvUDgwaUdQOVlsaEUzbEtEaThoUWNoS3prWnVJeFpHR3Y1?=
 =?utf-8?B?cVI0SXdmSEp4eWYzRU1mVCtCelh1UVZIanpXeFY4eEhpYTFNcnpJbzJtN0hq?=
 =?utf-8?B?Z2h6ZjM2Um5oQ0MvbmNVa2tEVlBVanIyelpVN001RE5CRm1uOFl6dEs3b29Q?=
 =?utf-8?B?cXNXT3RFcHU5eURFS3pjdW9Gd3VnTnhKWlFnampscTUzWk1wbnBLSFE4akJW?=
 =?utf-8?B?QjkvSityRTMwb3Bzc0ZmcGxXV3pKTDg3WDRneGJTNVYzbGk5RmNET2ZKcWdT?=
 =?utf-8?B?dWEwcmJQbkhHM1J6bXBkcGt5c0ZlYlhzci9rWHBremNlZ2FNNDUyOHU2SjlD?=
 =?utf-8?B?enVENndjUVkwUEZ4KzNTcDlVTW13RVJ4cTRyanU4ZmVSOGtnbzJZMU9FQXdP?=
 =?utf-8?B?RktNU1B1WUtOVzdGeHRPS3F6bHVWeTdJbmhNZHlVeEwwM05qcWt4NVJmWXk0?=
 =?utf-8?B?MXRnV0hYQnJUb0F4VHk1VEErRnE2cE5LbmQwMTc0OU9uVHAzYkE1VS9JT2VI?=
 =?utf-8?B?Mk1LVE5qMXkrb0dTSjc1c1M2RHowUE5VUlhPbWo1elRFMGJNVHlUNllEa2NC?=
 =?utf-8?B?amZtalRhemh6RVJFMlFQQjA4NDVmVzlCNVVqVWtOTWRqVWRmNGJITHlnYVAw?=
 =?utf-8?B?YXRQK0VwVWFvV0dOR0IyWlFpTzBXRDV6TlRVNFpFUlM2V0JBU3BDNm1MZWkx?=
 =?utf-8?B?QzhBUlM5eTdGMTJ0Y05rbkJKUWdiUVJ0cHIxNnRReElkenV4USswRXZTSk1G?=
 =?utf-8?B?dTNjNW5MZjh5Mm5YNkV0aFNIVEpGNU9Fb3JIVURJMUFyQ2o5NUs1Q2hPbzFG?=
 =?utf-8?B?azRVWTV0YVoweTA2TDQyY29aQ3RsVFh4RDRyc2ZVWXpCR2tENU9NUVZlWGQ1?=
 =?utf-8?B?TFl1VVVOZkNRbGNuRWJXOWZ1c3ZnMUNacG8wait0UWZhWGw2a1owWkRuUTVm?=
 =?utf-8?B?cEF2R05TbWk5eVk4S3IrcEl6cWVCWW05QnVUbmgxS2tqRjM1c3J6ekg4VDJN?=
 =?utf-8?B?bmlhVE5FYXNpK2IzaEJ3RW14U2NWazQxcXo2eFFEM1EyV244a1A3b2M4bjRk?=
 =?utf-8?B?TDdEc09McElQZWZod2ZYWVhzeUw0U0NtME9SZ2l0OWRNZzNzUmRGWTQ4OWFJ?=
 =?utf-8?B?Y0EvdGpjY1lyNjQ4a0xpMzM1T1BIN2NEeCsvbnJlUE56elZ0bkFPWGdHVHI2?=
 =?utf-8?B?bDQrazNIL2VnPT0=?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e4f368c-d4cf-4a6f-f18f-08da05c500d7
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2022 14:14:51.0787
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TQdGXoz6TtGyUsorzfJjkDnxCOckHleRMz2u7cxRkABx0bId4ADMsCSAdnPZeiTpquplZI+G0UrHhE1Lg0JvZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1381
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 14/03/2022 14:05, Greg Kroah-Hartman wrote:
> On Mon, Mar 14, 2022 at 01:58:12PM +0000, Jon Hunter wrote:
>> Hi Greg,
>>
>> On 14/03/2022 11:34, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 4.19.235 release.
>>> There are 30 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Wed, 16 Mar 2022 11:27:22 +0000.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>> 	https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fwww.kernel.org%2Fpub%2Flinux%2Fkernel%2Fv4.x%2Fstable-review%2Fpatch-4.19.235-rc1.gz&amp;data=04%7C01%7Cjonathanh%40nvidia.com%7C31eb601c0fb5484081d008da05c3aaad%7C43083d15727340c1b7db39efd9ccc17a%7C0%7C0%7C637828635201758957%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=qkVZnVBxsP8BHFANdvt6NDk8btMPekZoMolKI%2FHK1Zw%3D&amp;reserved=0
>>> or in the git tree and branch at:
>>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
>>> and the diffstat can be found below.
>>>
>>> thanks,
>>>
>>> greg k-h
>>>
>>> -------------
>>> Pseudo-Shortlog of commits:
>>
>> ...
>>
>>> James Morse <james.morse@arm.com>
>>>       KVM: arm64: Reset PMC_EL0 to avoid a panic() on systems with no PMU
>>
>>
>> The above is causing the following build error for ARM64 ...
>>
>> arch/arm64/kvm/sys_regs.c: In function ‘reset_pmcr’:
>> arch/arm64/kvm/sys_regs.c:624:3: error: implicit declaration of function ‘vcpu_sys_reg’ [-Werror=implicit-function-declaration]
>>     vcpu_sys_reg(vcpu, PMCR_EL0) = 0;
>>     ^~~~~~~~~~~~
>> arch/arm64/kvm/sys_regs.c:624:32: error: lvalue required as left operand of assignment
>>     vcpu_sys_reg(vcpu, PMCR_EL0) = 0;
>>
> 
> Is this also broken in Linus's tree?


No, Linus' tree is not broken. However, I don't see this change in 
Linus' tree (v5.17-rc8).

Jon

-- 
nvpublic
