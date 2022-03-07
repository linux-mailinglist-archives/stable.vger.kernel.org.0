Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 540654D012D
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 15:26:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243173AbiCGO1u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 09:27:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243172AbiCGO1t (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 09:27:49 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2053.outbound.protection.outlook.com [40.107.92.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C7888E1A9;
        Mon,  7 Mar 2022 06:26:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nQ+cm1uFr1HRGTgq77aX2Ci0hVyGakcTOLYcLiiKpBQwJNUr7cT9id/2FolRDmTfIgkkpLMbomXBmF6JlKYDxw/yz/xgFUawMd+iQeAq4RoQVij7kCIQlbGloiw9OcvvNMGCXb5+K8VpAZWr1Y7il6LJCWBq/jQ3F9eKz65uvNfUEBwF2JCKPw4zUGXoiblSyUKZ71EJBvo9xjWCO+oJehoVPhihoQdlBitayOsLRypR2KL0B57Pqa3QXW2CT+9wBCmGc9n8w7GS1ckU4Snd9juPBMjZKPaytuuC26hHtem1Hop+LPCTrc15P+xcnq7W6zRAhztzbBNsLW133noOcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M0qi3YPKO3q2uaCehjMH3YrlAIInVRbkds3nXRujWUw=;
 b=NU+TgplOx0bxWDpUBUC/M0DNeNK9eDnuw24eirBfFOIeXilkczfPgSQG3QxtRDSGhWBnIvLPiEMIEAWC3rF5zV755ByiV4sQrlG69L8Wzcc1tda+OpA9TL+kJgrrhrZAYvMknx4PoCHhuq/oq07dyLZy2OW0by/756OFCaDe9tRYBjjpvSWuPjrZhEjir0VDPFIe+vLGns6e6RdN/jojiOfPAs/WTCt0lvVQG+HDDbDGnw0M65dhQeaJST2KJZDaEgt6yhctnFsRpeZ6ZYwvfUJRsnf7IkzuTCBobSTef6jEkE4xG90H1i32Esrd+g3crUGQimDUBg0HpKp1gLnjvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M0qi3YPKO3q2uaCehjMH3YrlAIInVRbkds3nXRujWUw=;
 b=dlJf0kaaWX09sQz1DLVWfcH6wfhee/Nxm0PeKn50cZG+8YW85KpiJ7QaQIWjHgMaetBjoWSyOzONkmRq1odWwxUSxjQRIirCh7LCUmfF0Q/7/ZHD6fCReE1FKhnVpmymMTnK9aPuSaMnvJVfMrdBkkg4gzYbJhxz+2zms9D8Yh3WdUtIpQg/HlAqiFvmRxuQcOddKwA87gPlBf0YLCv6sjJIFVXGoZBVjlpbm5N23ffB14cyXLYm5y5H8jtTUr+H0FpKMSeORmky4UlNSRuKMuc0tgFE02mMzdKwSoKfdXrJDM49cwy6Rqs0k8vftY9V1TT5Qhq74WuU5fw/hZXvPA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 MWHPR1201MB0030.namprd12.prod.outlook.com (2603:10b6:301:53::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Mon, 7 Mar
 2022 14:26:53 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::fd75:b9cc:faca:22fd]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::fd75:b9cc:faca:22fd%5]) with mapi id 15.20.5038.027; Mon, 7 Mar 2022
 14:26:53 +0000
Message-ID: <195f7801-7207-d317-c4d9-30859ff9cbe1@nvidia.com>
Date:   Mon, 7 Mar 2022 14:26:43 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.15 000/262] 5.15.27-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220307091702.378509770@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0057.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:153::8) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9cf07278-30b6-46e0-9602-08da00468640
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0030:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1201MB00300FB8883CDBC8DA3DBC47D9089@MWHPR1201MB0030.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UwcHWbUfT7lxd3/HykmZfxuuEpL3VYjRJGTBDRFIu+8mTnGrluEz6jwuXYYedwyxtU4kottLaw9ssxWqHB2Mez7HhEjcYz+iYwRDWmg3ksFpVQx+dCix7C2Ifwk2pbfPHMjVRlf0cLlOOJKieoCor3nHecRbOO3HaCr9JF5NK4McnRMEKXfJrZ0FTWYUDg1RWKs/TILtWl8UJ219MtajM6r3sjF4opzn4vv3poSoMYBV4IO880wwwmkv8k6VlIZHZnPYIlCX42SSEsE9XmlzEzJNHwkxSCuc7GDPesYSd/b+QrmUeqIH+SOtKKUT7obkVuV1b2avgq/uy0OMM4DcrfkreZkxXEAPeKtzw8IdcerBETVx+Sdpi1vfOdlIt0FNqP8ZuU8sJuWx5VgOC5bogADK8Fe2Jtt/Z96Ccq0k7j2mJXM3fDzTMDTbscHk3/VhxzjNZ934mKFZPKqlLjiI6ivAsRpsZhGv55IFr7FZ9RPVxArKOFiubJtYo0heiKu5L6NYc+oy8mnjq41S8hBujaIChUzyCcd7eV+hTDDDbRjXRVzrg+z51BU5uB3ZMraClWURYh39IK6k5fprrf8QGIAPq/eL7yVvdnJ5NSZolWh0pD/xHGUzr21sN+0kLiO7S4+kJodroAoGrylRZgd+nNOZduP43BEA7TO+FbF48J5tZsR2mtK8pszJSggEk1NXGNgAceLXtTMM1d4EP3kRRpDxVftlH19Jk+o//QdWmy1WBR1h4RyABk5B7knTkFbz7QdqCihDHKbMs4PeSUVOW5QkQOjZZi0m2WrKvmGzMgncVo5ne8FxkNP6wJRHiEqE0aEjPTYxeqq5MLIYXaj4ng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(2616005)(186003)(66556008)(66476007)(4326008)(8676002)(66946007)(31696002)(86362001)(316002)(2906002)(36756003)(7416002)(8936002)(5660300002)(53546011)(6666004)(6506007)(45080400002)(6512007)(508600001)(31686004)(6486002)(966005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TEx4d0FYajdybHF3dHRrOFZENFU5cytJeENrbnUwOHFlNCs5L2lxK29aUjhD?=
 =?utf-8?B?VjFUSFJUR2hJWTVtWlMyRXk3VWNpUnYrN0ZEWWM2RjgvME5scXRlMnFDZDcy?=
 =?utf-8?B?c0xVV29Gc0hhZ1ZxUCt5ZGY0UjFBUERmU3k3SEJzL01lNjQ2a3pSWUZCMGkw?=
 =?utf-8?B?RWs0dHRvSjc3eHBLQ3hNcjREMGE3WmoreU9aa29lREduMWpqUEwya01nMnBI?=
 =?utf-8?B?dHFqK3gza0ovQjVHVlh6NmVNVXA4c0t5cDFPUlhwSjc3dFI1OGN5TGNkZUtH?=
 =?utf-8?B?dmc5VUFNY1JqSzNNRGkvcG93VjV0SnJDMlZkUjhqMHU2MlBxclhYV2REV3la?=
 =?utf-8?B?QXoxN1k0bWM2bnBjNjIxdTJvRU9ZdC9KeDM0aDNHSUp6YndORVdQSktWSlZ1?=
 =?utf-8?B?dmFpMVZwRmJQWDd1TXhJeGNSNUdTUFJZRnlXRHRNZzM2UVdsZnZ6aURVMlBw?=
 =?utf-8?B?K1NkanpWek52SDhrbzJZYmU5WkFRdGVtZVM0Vk5vQ3ZmL1dJaUt3MHBvRXRm?=
 =?utf-8?B?Q0lGeEpGaFlnK01oU2IvYnBLMUd0aW5laGVFVTlRUEhvMzgyRFV5d2tyTGNU?=
 =?utf-8?B?S0dYUnFoUzRkcVhhRnVXZjBUczZIM2hOZjNoYlpJdG4zcEJHMVhQYzhxbGdX?=
 =?utf-8?B?ZE5ZVG1tS0lhOFJqV2ZYZUJjUC8welR1Nmh3dE1rb2N2ZngzamcxT01PcHQr?=
 =?utf-8?B?a2htVUtJRXliMHV0RUdBS1orK2tJOUpvV0lqcC9TUFhIVjNTVnY2dXFjd0pJ?=
 =?utf-8?B?bEd3d0xMS3BmclMwWXFmNHRSdFo5TmdQazRKQ2hPeDBKdGdzNFFyRUNWVXlk?=
 =?utf-8?B?ODlMaEZmSlVtaHRpaVNOYkRTWHF5azZVYzN0SVBOSkxlVXFDcGk1V0l4Yi9X?=
 =?utf-8?B?T3NHTXhzMnFtTTFHQkJBUG9zckVIYVVOdTN4WElHRGN1OC9mSm4xNmxqSE1o?=
 =?utf-8?B?VUZuUGd1V1k2ZEJGRUJUZHVjQ0lLbnpYdGw3US9MUDdSM2VIWmhwbThzNFZH?=
 =?utf-8?B?eWhDYVJJZG9UeDMyd01tMWFRenFJSkJJbUhkY1pnVFppZ0lHOEpYTWFsTWlX?=
 =?utf-8?B?SnhiQUdyTW1GMDNIZUhzVEhYQUZhT25mT1d1QnB5TzgwOXRmUDZKeERwK2w2?=
 =?utf-8?B?clZ2ZE1qNElsMzAvcG1Gbjd5TW1HRGFaVDU3WHlCbS9WYUMwTStMV1E4c2lL?=
 =?utf-8?B?RWJGUTFZcGMvSDRmK2MwV3pXa2YwY2dBTndDbm5rY3dqalFmYnF4NmEvN2Fj?=
 =?utf-8?B?UUx1K3kwTGtZODBqYzYyV1BWMnFpTzJyRmpiS1V4MVZXR0VxWHV3UmVseUVM?=
 =?utf-8?B?RnFlUjF5UDZDakRueTJZUWxVTldYKzZpVTRKaS9BWmNYeDQyT0EwN1B5b2ha?=
 =?utf-8?B?YWs3aFBNN1pGdXhBVVhVcmF4aUIzUnNTbk5tc05KdVMxOWgxcVRUYjhwc1N2?=
 =?utf-8?B?bVJkRUgzdkFoRHZIbXpvKzlrQy8zS1RYZ0VIeTR2bWNFbDNkTnVuZURaNHFG?=
 =?utf-8?B?TTc3YWUzeTViMDlxU3BFNjkvaDRPZ3RQQ1B0OFJaWHJ4d0w0WWo5Q2N2SXJu?=
 =?utf-8?B?WlhBVXg0ZUdJRHExaDFabmlwTmVEWXVVdmh5NTU3TWl3L2xEek5aYTRBRlVq?=
 =?utf-8?B?MkF1Nlh1Z1VlUUJiSVdraGxwTzNhUjhEUjgvSG95MGRBNmFNTDUzbU9KUmpL?=
 =?utf-8?B?d3czdEVtV3hhajR6aG5PallpdXF1cHduNkJGbVZvaEVVUlFnUEFHcVdPa3Rh?=
 =?utf-8?B?RDJJblNMYytxRGZSMjhCMVpJM1VxeFpZcWYybUtPQ1pUZmNERUw4cXphSnFn?=
 =?utf-8?B?Qk9TS0M0dXF5SU5LdGN2OXB0ZXcxdXZ2Rnh4cU1zWjRVYnI2a2VMNWRVZ1pQ?=
 =?utf-8?B?VzVuTFVVbEdxVXFiSjF0UzNXd3Q2UUZBN1JkZnlYdGFtOTFuQkdkWWg1WGZX?=
 =?utf-8?B?Zi9TcjZQK0NxcUpVcW11bmw3cGhyaW44ZVUrTlhFZWZzS1k3NmllU0dUN0NE?=
 =?utf-8?B?dDVpOTdpQ01sdHNUWkdBTkdrVkF3dDQvL1pQQlZyUEphNDlIdTgxaDJNNng2?=
 =?utf-8?B?M1NWVTZJTk83TW1ubWRySlJFYThHNDI3eGRvd1haMmMxK2hVWS9Bek1PZ1BE?=
 =?utf-8?B?ay8waWVlMThDNnlTU21lMldvcXNCcnE2T1lZeTcveVAyL0hseDhOemRJbDd3?=
 =?utf-8?B?SEpPSndBSjlWQjI4em9qRzFQM25zY3Nqc0Q5di9ZYnUrMktKTGl3ZHpWQUYy?=
 =?utf-8?Q?s553/op/92q4FuiD+Ij32jVmkzsKinEMAS9hxD5Iis=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cf07278-30b6-46e0-9602-08da00468640
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2022 14:26:53.0017
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: blD92glH7+i5APK0SaFBd2VdkqIBgCAC3Cl3y94iEMEGr+8t792FVlQxEQm01zwk/lIgGC9/SQcl+AYpeI/cVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0030
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 07/03/2022 09:15, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.27 release.
> There are 262 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Mar 2022 09:16:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fwww.kernel.org%2Fpub%2Flinux%2Fkernel%2Fv5.x%2Fstable-review%2Fpatch-5.15.27-rc1.gz&amp;data=04%7C01%7Cjonathanh%40nvidia.com%7C52f7666efdc24e35cbc708da001e0bcc%7C43083d15727340c1b7db39efd9ccc17a%7C0%7C0%7C637822426962400608%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=7OrqXqRl71%2FAG4A1q5lIuWzCpA0r7uul3XpgJIfyVuA%3D&amp;reserved=0
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
> Pseudo-Shortlog of commits:

...
  
> Hou Tao <houtao1@huawei.com>
>      bpf, arm64: Use emit_addr_mov_i64() for BPF_PSEUDO_FUNC


The above commit is causing a build break for ARM64 ...

arch/arm64/net/bpf_jit_comp.c: In function ‘build_insn’:
arch/arm64/net/bpf_jit_comp.c:791:7: error: implicit declaration of function ‘bpf_pseudo_func’ [-Werror=implicit-function-declaration]
    if (bpf_pseudo_func(insn))
        ^~~~~~~~~~~~~~~

Jon

-- 
nvpublic
