Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00D836C3101
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 12:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbjCUL4D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 07:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbjCUL4C (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 07:56:02 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2068.outbound.protection.outlook.com [40.107.92.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED0025E11;
        Tue, 21 Mar 2023 04:55:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kSHNijqJKJN+mi3Rj0MAyQ1kJwaIb2qVgBZQeIPdRxjuf3FipH34CXtNOyG2kVJNjF8qb5uYoMHGTfxtQx1BepFr5RwTwciKO+qo1bzOq1CxCGMxSaEEfixe3cu+43lUPLVwJPimdnc4hxzMbnXM/c8opQXQXGQwyJ+XY/SeoN4ngrPc7EnlJMNzhhllhpe7JK8Y4gMHgFPydGi7fToC6SBxdoFJLb2YgYsDiN+nI5ddW9aLzCQz1sEteN6gz1XQbphgiwoFYMe0HpAa9/e+ziJXQGEZ1lkKWGBMXfyjhsaZqdviq+OVGvDWsfmOK2sGaEaVcVp0dzpaiudU+2cNTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TLgpHdc+j55L9bKlGEf/kBp613TOzIDl7Yt0KAuzt0Y=;
 b=HYoaxSRBc6Z5H97FY2oldPfXcJQ6mKzpmpkQCWQGkQnyD7ANb/WGdxCZGmNPRNnUuMArezUGTGPnOAHgXuKnn2aU2zL1Iks/dEUr+JPCZPmdKtqEVUx3VBAOKPdDqrLDIPqAXvlWVlYQwykCqA+BA/SVLUePk7Ua+OlcIKCOPq1jva/2fcQseCChPKWbYvGwWcFzGbfsTZe1yE9bSd9NR6LWUQSxP8rpg4y+7CNOTYH5kVkMdzQL0MDmAZsqdSmLbUPH/gPOdCKezV0n4j1IGnQF1TUlPJbD+dhLBhD7PhhyhvF0XK+bzOF7KJnbP05abZOB+8GGFSo7lLaBCdJuUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TLgpHdc+j55L9bKlGEf/kBp613TOzIDl7Yt0KAuzt0Y=;
 b=Cr0blvPoSwZCR2Mo/t5hOIk8Rd6JfDtid3inCZruLDn7pGpyNBytEeAGae7u4NTOg+Hw4eGUABFny24avXwmhpIupMmOvrAfiNgPtl8beqJ+y3ETYFMvf/pNPvuPIrLBJPX5rcsK9yu077ioXZbrcZfjaTm+ccNFICHGENeQw58pIvFitJfq/R65znYso8lLJy1ZPG9K/ZrMWixhPfMsJhRBEF3nD0bFCBP+KNHK0xu3PwKfWaVh+tw7UJC8AhuE5t+wylbeDXMJ4phXOXjiVI24ut6r4/fkPidExuDu3IzeIY/r619Pdr9coqEeJGnmKTsu9Axh68ThSHZfl3DvtA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 DS7PR12MB8273.namprd12.prod.outlook.com (2603:10b6:8:da::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.37; Tue, 21 Mar 2023 11:55:35 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::5464:997b:389:4b07]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::5464:997b:389:4b07%9]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 11:55:35 +0000
Message-ID: <668ef919-9a8f-a3b5-03a4-60295d7edce0@nvidia.com>
Date:   Tue, 21 Mar 2023 11:55:22 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 5.10 00/99] 5.10.176-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20230320145443.333824603@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <20230320145443.333824603@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0604.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:314::13) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR12MB5444:EE_|DS7PR12MB8273:EE_
X-MS-Office365-Filtering-Correlation-Id: eb742cae-39f5-43e4-6f62-08db2a032ded
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yZ7D37peqvysH6/SS2Urfse83Ca6IjdW6ImFwZx1j4+WJp0dMVaSS9NpESbAxqdmJvJR4Uj8I5Qci7PyU5FteYqJ8/FTbq3RFCdn8RsiHKamW1NalAJf8T67ZRnVfdplA2i1kqnvccB7e22jABWIhXC5Zxs16B0HTqOEqMSc05q7WJlKZtX5vVfw702Yx5KZjIDKphGkwm3DdEWxqxOt6PODG84uCd1WXk3tJBjA2OXbpW0PUTUwmZLTXLnJMAZ2swoOlKpjee+tZV4WPVxIGxqO9nTbK0pL3htmVIgRQATfOf3yweI2LF/xJ/8f54S9oga8SX7EYBkvcd0yQFloVbTZnJnxlbh85mq+JyDTIwZfCLuDw8bPbeN2AYeKPx2yN+qNIEuWnPaSaBUazg27ibvKzIN0RBTmXJ26Chty1Y790O0rfXnWCEczSjDh1FnXXkLI4PvKcvoEh7mqxl17HMBe9uO/UhBbS9bF2lv9fLJ2Gsb4gMMHJrjAhg3zrcP/nAy2f8CNx1HrXorvsHPycOcsgHEyGuiLzyJ9SNRFLIEdoXjNMUacsgd1raeHs+6O3IqfhrkFwgu782YMRpIFzxNv1EYwjp0+woB2qUuXku9/8WMkxIocVWexbMCzAKzbsCWw1RbxUROHYvBNr4D+1EVZyVvlSL2506UzFpksicgTxM73W/J2Hce0sqqkd3lnuixRZH/o3FcPgIq1V8ts+PerDQ/mxn3QsdnCTkiaDQf/u8/aSlXxkOr6nx2JzoGq4k+sU0ncED1mty9F1xPtTw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(366004)(346002)(39860400002)(396003)(451199018)(31686004)(2616005)(966005)(316002)(6512007)(6666004)(55236004)(53546011)(6486002)(478600001)(26005)(6506007)(186003)(7416002)(31696002)(38100700002)(86362001)(4744005)(66946007)(5660300002)(41300700001)(4326008)(2906002)(8936002)(36756003)(66476007)(66556008)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MHNSd2lJcHQ0QzZmTDdlTDRaZHBPdzE3ZTRtTTBhR01CUzV2NGx3UXMvWWlv?=
 =?utf-8?B?d1B0SGN4OGpRVU5HWHkzTE40MWY0UGgwd1dNbU9aY3BSSUtXRnN1c2tGRERW?=
 =?utf-8?B?QklnVk96RHI4anJxMDlBMmUvaFFza3dyRXZNMmdxM21xWmM4aGpKNFNRdzMz?=
 =?utf-8?B?Q0tYOERreTdzajVXU0NKaitzUkNkUG1nV0g3Ync2M25IT2QvYmJQTUxqbjhl?=
 =?utf-8?B?YU1NR3llRjU0YlpnTzJ5N0d3d1lXM1FhUi8vTzZya0huRThGOE5yMjlhY3Ru?=
 =?utf-8?B?elpLVTVjRW1IeHRKOHJpb1hZaUR3VjlyME9PU2xXSVRlQjlKS1Vlam1yY1h5?=
 =?utf-8?B?cFp3NTRXYkZQVFkxd0ZVdVk1akNtWEw1OGtFbFlYNUwvcmRLV0g5RWoxQUMv?=
 =?utf-8?B?UE5xZmRLd0IwcUxHSWF4YXRHUEhEQkI0RlVSNWFlZXcrSzlvTzBJTjB4LzJv?=
 =?utf-8?B?WDZrSFljeDdGSjB0Z3J3VzBBVUIyUFJma2p3czBSYUY4UEtJbkNDRkg3MXVE?=
 =?utf-8?B?M2NZc3ZoQ1VyQS9QcVdieXNJM1dBNENBMVNoeGhVMis5TnAwTzRJaGYrS2Z4?=
 =?utf-8?B?VndQQkRqa0RWR25zSzBpZnI0WFJTaVZDalJ1TEIwMFV4Q0dTOHJjclNId3VP?=
 =?utf-8?B?M0JkN2JhRmZ5MGlFazB6U2U3SjRLNXZEQ2hucGg2V0g3VjRWcU5xbUNwcnky?=
 =?utf-8?B?cmNncHJidHF5WCt6SjdPa0hXT1lZb2tOb3pGZm1ueTlTWjMyQzBPYUVWcHNW?=
 =?utf-8?B?Z0lJZVlFTkZiaW9IQVNqa3RSdEc0bGJqd1kxQU84MWFVZTJmQ0E1VTBPN21E?=
 =?utf-8?B?OVJVM3U0cUNQMXZ0VmRyaktBSFFDbDlRN1VtNHFJeWltSWI2eCtSYVZ3ZkVD?=
 =?utf-8?B?YUJjMldQYTE2UDl0cUl3Qlk3MWNDVjNsUzRVQW1OZzNnV2xZbjJLSm5wcjF4?=
 =?utf-8?B?UWxWaTltSFJYTzFUVTc5N0RmYjZIWlFtbkZlMFUvVjVoalNDaG1Jbzl3QzMz?=
 =?utf-8?B?NkplRkNwK1ZIOGlBa3BKRXBvck9vQTJUVU9YZWw2bUJFck5XWjVUdHZoZk11?=
 =?utf-8?B?VVcwUThzd1pWQjhQZFZmYzYyNENlZEdjVUdDRlNTVE1SNVVWcDh2RTB1Wisz?=
 =?utf-8?B?bkVscTByUEpLbEJvTUNCL3p2Z3FCOXNlTDJJYkxwbUR2MlR0SjBvVlg0VnNI?=
 =?utf-8?B?MXBvanVNU2piTDVvSGVJOURQTXJrRjUvNjc2UU0zU3FkeTZOdWhNaUI5OUpy?=
 =?utf-8?B?U3JuOWVMeldjNkxjV0lYYVYwS0tabmFaS25pT0JDcmlWNUxPQ2JBUlZPY2Ro?=
 =?utf-8?B?Ni9XVUwvT3U1Q1VESEIzdFJpWklWRlBaWUdnTWpXc3VjcWpzaFFLZWNFL1NG?=
 =?utf-8?B?STlUL1pITGhmSTVHd1doRCtGUU51UUdNVktDMEdIbVZFb3pSOXlMTHU1RjEr?=
 =?utf-8?B?OHFnejhVZ2lVUEsySC9PTFcvTmpCL0EzMnhVbGsrditJSVdyQm5aSHRwVkZZ?=
 =?utf-8?B?VFFwcGRpbktESTRGR3YzWUk1NDFDSjhTQzUwMlpTVFZWaGxUeVEyZlUrUEwv?=
 =?utf-8?B?ek45MFlwWWMrQjdJWThJaUFqcDR6U2xLdzVYZG9valRVWDlLT0xZNkV4bW1k?=
 =?utf-8?B?V2pLRXhGZkJrbnBjdVZCRTBtRUdMcHluOGFDckh2ZjJLNk4wRlZPbnRWNjJ3?=
 =?utf-8?B?SU5rcFk0diszSlhyQmJXOTk2Y2pEc1AxNWF3ZDhwZTRQbXRjbWczY3gyanBY?=
 =?utf-8?B?K2haZXIxU1hQeEZpZnBaalJ4T3J3SWp0YXNaOVBxOUlZM2dLdm1JbzdyWjBw?=
 =?utf-8?B?QnJ0SmNTcGRxekhZOWgxQ0hES2s0VnpwMEJFOVVuNHdORWRTZzFZOGVXaVFL?=
 =?utf-8?B?QTY3Q004OGhsdmZYZ096TFhrdVFjMjltd0lDUFpDTWMza005WGt3Nk9FNjYx?=
 =?utf-8?B?MW5tNmRyVlNHYXE3eFcybkpHUlExakp5dVRpMXZrSGxncmt4L0tNaVA4YjZr?=
 =?utf-8?B?cTY5STdlVm1nS1pKZTB1Q2JMTnZzTzB6cGxjVWduMXFBRlFXK05FSFRoeDcz?=
 =?utf-8?B?TENUbjExN0pvSUNEVW9qcVg2QXRKdWVzR0I4OElqQnEyaFlQTDF4NGIzVk9v?=
 =?utf-8?B?TmFhU1RQZFc2RkpyRWxkK0xlbThna0l6aTlvMkpOYjgyWThta0FKbG44eXZJ?=
 =?utf-8?B?dlE9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb742cae-39f5-43e4-6f62-08db2a032ded
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 11:55:34.9216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dD6P5r3iuus+l8seIKX7Rh2uV2ymy0doUQXtkpmSMoGKBJj0wfbzbFVmltcyIWJdc1XEz242npnMeaJYMFfHfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8273
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 20/03/2023 14:53, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.176 release.
> There are 99 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Mar 2023 14:54:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.176-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
