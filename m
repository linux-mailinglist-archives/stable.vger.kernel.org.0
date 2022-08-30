Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05D9E5A60CC
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 12:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbiH3Kce (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 06:32:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiH3Kcd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 06:32:33 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2049.outbound.protection.outlook.com [40.107.223.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D49CA3D5D;
        Tue, 30 Aug 2022 03:32:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fnWcfEDvTV6uaagEritkUJr9oicqZl9+YZ3HqX/DAMaUPk4BbZXJ5nET9GLfaTcE1XkVdBVovGTpS7gAOTiQKTl6ofcF94F5C4GiOBcIlupg8OlA9nFBba6DIOtndXCXOA94HgPK8NbPZi/cO+f07uGeCYfavOpC3lGFeq5SHDCa/G8Li3FSqoH3LQw2zAs45h9vPDCckGCyxYEo3WQpe+d36HfqsngohvFOaSpAv8Jvc6eBq1mKm+JpNfeu0/trXhwqxm6Mgtljs0we/S46W8PpI7K75hIvQ4uM4WAiwiEhPx0P9Y+Y0pd/WOVQZmA8hyoQXX60v8yTwKABAtUfqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sYHDe+hmVzqlyU4Zb77qjKGNfX8ybR44fTlXjGhGnb0=;
 b=MX01vfHbHtQGKrfHHS10bSJRm9gr/2PvhLQ8w0UmbYpUMXVVed6MtZ98G/kYWHNyWWb+gxJhHJxxb1era5Hztw3GZ9MJKqCXnaXN7fG7Ec9xOVusQPfkRs89EwNPV6XPLDXjHLmXfbMUg86dWBwBmHooU611X36HPKxfHkTSu6dF/JileRlpt8SRab7X6rTXCdPBOG40QlCHmPfFfgZtjAQFBCZeye6oqRTBvw0GrL3x40Ytc8/2rFXWKYQznZSdGMuLiy3tlBtFGhdHolQvThOL4T+Xwm0MFRZoLaRLjSfCjAJrxAJvAbZvYKvsfVgMewitrZ5ctOSheUWztAWREA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sYHDe+hmVzqlyU4Zb77qjKGNfX8ybR44fTlXjGhGnb0=;
 b=ExGls3sbgT8N/Q8YFUeWxojNd5aBbQvqH3DxIb1Li86KYlYXGCJMEO295129dGG6sya8FZkAFdrhT5Ut3ImxyyEsDxt+EcOFyXmKeh2jcgAmBR9H6CVrCXColKbifs+oIHAexOcU+1HsIrWrBfDGKuTnUwq4AXyB/LDSz5aIbO75wmKChXVHDUviVxG4nO6BM7xchJa4Zqbt3/A+yfx4cm8vtq2zEMj6kn/+RMt0fL/c3w3AI2FVA9baz+1rXL7wt+YRigR3nzMuWYwAb7LA1s7GGytQYUV39b0OiMykvMGlEoctTRDK0u8wkeD7NRxuftFDaBWB4CKrUVXNFDI6MA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 DM4PR12MB5150.namprd12.prod.outlook.com (2603:10b6:5:391::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5566.15; Tue, 30 Aug 2022 10:32:31 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::2cdd:defc:a6d3:7599]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::2cdd:defc:a6d3:7599%3]) with mapi id 15.20.5566.021; Tue, 30 Aug 2022
 10:32:30 +0000
Message-ID: <e9834880-c16e-e269-30ba-3fa8a94ba1af@nvidia.com>
Date:   Tue, 30 Aug 2022 11:32:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.15 000/136] 5.15.64-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20220829105804.609007228@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <20220829105804.609007228@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM5PR1001CA0010.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:206:2::23) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e03a2e42-f2d6-48ee-3d6b-08da8a72f164
X-MS-TrafficTypeDiagnostic: DM4PR12MB5150:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ku9BtdLM40q1jUt2GomO4PMbJs5tCEK1Hy0veJNoi1289ExLCXiNJT1rX/8SogQHpLDXyflF8IwjSPr8puCB0Jg0uaXnMmqKBdZThKn6TxsTKRKcyBdRbTRXG93XA1Re29kVINTd2OEcHg1r6/+WcOogedzX/kiM3khPd7XaVvcJ4XfErtWc1SDVTR8LKLy8vZ3XTaQwQjHJ2edyWKofy2RxyWmQsByAFZ81lA87smH1sf4IRfgnW02cZcTB2ZTyucUg0d9GKdcUB8XRn5IZR07NSf23OeNmmRTpdQ7/uKPdmYiYuk8/ZLuQPNWnewLVmjQxzrN9Jp/u5k0Ihlob3bwID+dIDo4pZdcVw/zVwPu8/rdVpsa+Ds7tflMMqFEShyiybbUkhJibxZ8SuwKYxKFQxw5L/jivscA7DcIYiwmXTNAJw61m/jsWhM0Yr0mkAmbAZ8ebhALPmg2US0AiGkudsuiE5ndTrDrUFqdlL77P78gyVeegxKyQ5OK6ETKVo/2Evtt3t8Lpn1H8eFSut1CreTbylRVISCsgf62oLUQOKPCYzSB37UaVasvm+vQVWFM0VqJrrueOTi45Hny5dmM1K/xzhtmWWhFoGv8bNfDeN/BxN3/eYrHS047BtJm8+Zuu1cYfPQBpk3KT3cFYGxWEXksQxKBHtcLrIBt14KUZtu1FV4XLJR594g60fNaeBwzAb7ZphgKkMF2toL0mqEYAca5YAOK8oshBTykC82l/MnLSCS6CkEHxqkF9lZ0/C/kRFCQuis9SuaPPRphA36oRkej8la0Jniul8MPuXsZNdDzoiqKx3HrJ11DpIbiAmO9Cfga28rBBdJUZSNKRDVLsZcM2hBk6CXvadsH9gYNXwCVND1cCsf96h3goEXLT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(39860400002)(346002)(366004)(136003)(6512007)(53546011)(86362001)(55236004)(478600001)(966005)(31696002)(6666004)(6486002)(6506007)(41300700001)(26005)(186003)(38100700002)(83380400001)(66476007)(2616005)(66946007)(66556008)(5660300002)(7416002)(8676002)(8936002)(4326008)(31686004)(2906002)(316002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SHArVzRVNGNmUE5tS2FKRVhmdmZDMXVJb1diSHJJTzdOWFpPQ2x1NnZDbDRE?=
 =?utf-8?B?YjNyMU0vWktUVFB1bmpiZk1ZNTRCTzlldWRlQllUWXZRRmE1SmozNXFxSGdp?=
 =?utf-8?B?UG0rdjdsbExvNFAvdlVnR1BBRU9LeThWNWhZaCsrK2hlakw4MVpBWWRsVTZH?=
 =?utf-8?B?SjUxWTBZNCtScFNZd3NObXMzS0xlV3h6dlRqMjArVFA0R0REZ2FHQis3cW5R?=
 =?utf-8?B?SGVIYlMvMEVHSldNbmZ4c01IMklFakwvNUg1ZUFCYWZHS0JRdzZBS1luVjdQ?=
 =?utf-8?B?ejVoRDhWZmxmbTdkZ0VDakRpbDhuL1p5UzhsS3QvREN1UTYwSFZXM0tLOERi?=
 =?utf-8?B?Qks3eTBYL2NtclBEczRHdU5SeWYzZTMyZnZBRzhZdnhZTDhXQ255WmNjeTV3?=
 =?utf-8?B?OExuNG1FVUdIbG9wWHJZU1h2OHAyN25NcjcwVkdtRSt5ME5uSzlCaDYyU1I5?=
 =?utf-8?B?a2tKVWVveUFyT1B2OFBhTktuK0Vvb2NRVjY2ZnhjdW04KzRBZHB3NXdxSHUy?=
 =?utf-8?B?cmc5ODl5blIzRnZ0amkxbVhjQVJqK0pPQWhsRVVlZXl3amROdkVuNWpubC9R?=
 =?utf-8?B?N1dSTTB1KzVzaVN3Mi9tdVEycXZoMmdFTFRjcEtUd2pBaHQ2QTMxWnl6Tk4y?=
 =?utf-8?B?bGo2NUJ5Nng4dk5lQVo3RjhLSHFyUjdZU3k1OEEwZHNvYll0MFNLenNaU0d4?=
 =?utf-8?B?Vk4rTXNKUERZUjNKb0xWRDdYVTkxSTM3QXNHZTBUL3RpSnZEeGtnNFp1SC9K?=
 =?utf-8?B?S3hLTlQ5a0VvVzBBbUp5dXRDTkU2SitYZTJqRmxVM3Y2N1lZNnpkOXhjQlQr?=
 =?utf-8?B?ZnJFOXpZeGNGSlN1dHp3b1U1RUl0WHMwVjFOKzFRc213Ym1SV1FCeWlqSm9v?=
 =?utf-8?B?cW1xclpLZklVaWxZQzlFMEZxYms4ZDdYK09MVUY5cW5iSzVaclFVcytFRXRR?=
 =?utf-8?B?bGphS0Y0QW5wT3B6bHRjOXI4ekdIaC92WDhmZjZTV3kxR1N5YWhYd1lsS083?=
 =?utf-8?B?MWZ0aVhuZWc2Q0JHQmVMYWNLczRJSVBSUDhpb2tBWnZMU3pVNm5VUk9sMEdv?=
 =?utf-8?B?WFd4TmtkVDRmRU9jam5nQjVVa3k0ZDB4dU1pZ0RCMjQ0aTdsWS9za2pyY1BK?=
 =?utf-8?B?bGtJQjVWZit0UXF3VUdMY2REQ3hJTSt3MkxremJNYjZnbDlpWm5VMXUxSisy?=
 =?utf-8?B?VXVLZDlvWmxqZDQ3enRPL0FsY1FaY0FHWU54NVErYk9EN2l1dU1melRFSEQ4?=
 =?utf-8?B?WGw2MXVSc3FrOTRibnh3cFNrYnlZY1RvQVRoa2ErYlRYZk8wQmljTDFzek1I?=
 =?utf-8?B?bUhQWXI5eVlFZGxtZjJsNU5udmFWV3VuaFUvNU5iTGNnVnM3Q1Ywa3VaQ0dK?=
 =?utf-8?B?cDl5b0hpeU9XdjQzQXRDSlRMdFd3QTVUcWdEekRSNGt6TThzNVdUU2ZPOHdl?=
 =?utf-8?B?YXZ2L0VxWVFUMGJJa0t4K2FmWWtGa1M4MTJEZmw2M3piUnJ3VFNCQndFOGl2?=
 =?utf-8?B?eitveHBXRmxYRU9SWVp6ZnN4Y2hrOW1zRlRpKyttUndnK1lNNTVHK2d3WXR0?=
 =?utf-8?B?dnZrcmV0WWxlaEtMdTNoNzJEdWhpWDlFb2NGS1U5V3hIQVNYSDdGb3Q2ZWhD?=
 =?utf-8?B?THk5UlFzM3ZwaCtIbXhCOXBDckxTaWlCWEdzZ1pIenkrYm96dHk1TTI4b1J6?=
 =?utf-8?B?VzJuakc3Q0hQYVlpSjZveW9IMHh4cS9FY2pIc1JjT0FIQzdPTFJHUEw3ZitG?=
 =?utf-8?B?NkRsYVpCOFZ6OFZSeGdheEVjRHpKaW9iOFpqcjZKZEdHS1p3NUpyZDh2QzM3?=
 =?utf-8?B?eldENHoyalJoM3lHZi9RdTdydWR2ekJNZ1Z2ZU0yZVB5eHFRYmdTd0NqMjJj?=
 =?utf-8?B?SVVyUEkrSFpQQlQ2eWkwTUovdVViK2EzWUYrTjFxN2hCbnhuWEYyRHQ1eG56?=
 =?utf-8?B?R0VjcTFLWHhhZ2Y0ZU5xS0haWWIrSUI5QUJaRHRWVnI2THhtUjlrZXFERE4z?=
 =?utf-8?B?V2tBVFhpSktMOHZxckxwRjA0anUxTUE3cUlySUd3WFJWTE9oS1QrZzNmS2VS?=
 =?utf-8?B?TmwyY3AwZlFWWVJKb21xWXlTVm5VOWl6WSs1U2FyWGlVMTZvSld6OGYydUFh?=
 =?utf-8?B?R01GSmR6SERTc3lCYlVSd2k4SGxNT2lKcy9XNWhKVXoxS21qdlp5R3JscG9U?=
 =?utf-8?B?K0E9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e03a2e42-f2d6-48ee-3d6b-08da8a72f164
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2022 10:32:30.9159
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6gtISOzT2qn1ChiG7pI213M+QGfoQEdJfQhQBPgMOFNfnA7Qt2mmZqACSdM2xL5U2FgesxKVcNNDc60ehzRQpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5150
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On 29/08/2022 11:57, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.64 release.
> There are 136 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 31 Aug 2022 10:57:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.64-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


I have been out on vacation and unfortunately some boot issues were 
introduced for Tegra back in 5.15.61 ...

Test results for stable-v5.15:
     10 builds:	10 pass, 0 fail
     32 boots:	28 pass, 4 fail
     68 tests:	68 pass, 0 fail

Linux version:	5.15.64-rc1-g881ab4a7404d
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                 tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                 tegra20-ventana, tegra210-p2371-2180,
                 tegra210-p3450-0000, tegra30-cardhu-a04

Boot failures:	tegra186-p2771-0000, tegra194-p2972-0000,
                 tegra194-p3509-0000+p3668-0000


Fortunately, these boot issues are specific to Tegra and were caused by 
commit a7f751d4e830c5a2ac9e9908df43e8d29b7d3b22 ("arm64: tegra: Mark 
BPMP channels as no-memory-wc"). This commit had the fixes tag populated 
but it has a dependency on mainline commit a4740b148a04 ("firmware: 
tegra: bpmp: Do only aligned access to IPC memory area") which did not 
have any fixes tag populated.

Can you pull mainline commit a4740b148a04 ("firmware: tegra: bpmp: Do 
only aligned access to IPC memory area") into 5.15.y, 5.18.y and 5.19.y? 
Fine if you want to do it for the next stable update.

Sorry about this. In future I will definitely make sure that someone is 
monitoring this while I am away.

Thanks
Jon

-- 
nvpublic
