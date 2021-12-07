Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A972D46C1F0
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 18:38:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239870AbhLGRlm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 12:41:42 -0500
Received: from mail-bn8nam11on2058.outbound.protection.outlook.com ([40.107.236.58]:40800
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232939AbhLGRlm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Dec 2021 12:41:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XB2QwAGFFbcZM16t3hfMBBDH7oMqOJw9s/B5U+phnHnc6p2/FQdKTMx8epV37vUnkh43MOty39V+5cG1oQJDgV3hWaK7ubgvV1QHvcyiZpanYPPPYW/wwC84DAEL0XgiyzAUvoNCTSMTR8HvgQ8667GNG/hPAxCTTsmDbDNj12ViY6AmkVvzWKCZoibG22V7k1ASzvQljDNyYuemLlL+eUfSzPgE8USLRped7Y959FzsilRZo1N5nk8Kbk8n0ueLZNfF3VknwwK7nCb6zPjWxLuLhKmD7V+TBOdeHAyHZIh07fES6ecAQBWrx05khSAjXD78FnKImwJejkkUxKaVLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EtIhKTuKWdYcH/nUGdVVBUU2ch1PweIlk6gios2vq5s=;
 b=bzFOqiqpZaRQtKHyPvH1nveDE1vys2aNE8hiULJu6yWhJVvqZt+aASztTUMmm2vjgC/d1d5KtqmGYEkBS+fMX7Vfl8qSAYMsekXciJjiKVsSxiTdWt2qO403NL0kRs1RVaXPYykJLeLsoG6vHxPdQ/RvQh06FBAUJwrYUfuxNPjr01qIC/8J8DlZ83EmTamZQEDFebRM5Sv13T8jLCbyM/ZLWlAunZ4tu7MBYDnCAlqrRVq09PInaccVctM0kOLwJNZiJOTyYujXQtiuFoLCk1IGKmq+doCfPYQN9Rtm8S+WKVpK5bGJXnxWnsuj4G/vU20UM0kGqlqEK6Ga6E3l1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EtIhKTuKWdYcH/nUGdVVBUU2ch1PweIlk6gios2vq5s=;
 b=kHB5LZ2j/Ft+Fk6RBTm0W9HuB+eNLbuxftGz4F4jbc/FN5RTZXsR0KcrBFnOHndfMIC68mIYs/1JC4chrkKye24IRZOQ/iMDPIOZILijbNpT172MPDmBkhqKbye6O32QJwkcykJRnt17SOC23KSPGWYDqX4TMqTVcnrCYjHxUNSUKhT7qFao3dCzZIQp+qCQgG6fJM3RsScpeoXzd9GhlCpiataq8XKvgFsbDSd0dQIjbVNk+VQc64KSNLly27JyPH6WZmVPsJq+Zq7LDWywzE9yyatKfz6Bs6RJb7Z3EtYjUNAOe8/3UQNFAq40rFNr7k/JjzDLBZVJlEaSIlerjA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY4PR12MB1576.namprd12.prod.outlook.com (2603:10b6:910:10::9)
 by CY4PR1201MB0007.namprd12.prod.outlook.com (2603:10b6:903:d4::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.16; Tue, 7 Dec
 2021 17:38:05 +0000
Received: from CY4PR12MB1576.namprd12.prod.outlook.com
 ([fe80::24b0:46e7:d3c0:a77b]) by CY4PR12MB1576.namprd12.prod.outlook.com
 ([fe80::24b0:46e7:d3c0:a77b%7]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 17:38:05 +0000
Subject: Re: [PATCH 1/3] ALSA: hda/tegra: Skip reset on BPMP devices
To:     Dmitry Osipenko <digetx@gmail.com>, tiwai@suse.com,
        broonie@kernel.org, lgirdwood@gmail.com, thierry.reding@gmail.com,
        perex@perex.cz
Cc:     jonathanh@nvidia.com, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mohan Kumar <mkumard@nvidia.com>, robh+dt@kernel.org
References: <1638858770-22594-1-git-send-email-spujar@nvidia.com>
 <1638858770-22594-2-git-send-email-spujar@nvidia.com>
 <7742adae-cdbe-a9ea-2cef-f63363298d73@gmail.com>
 <8fd704d9-43ce-e34a-a3c0-b48381ef0cd8@nvidia.com>
 <56bb43b6-8d72-b1de-4402-a2cb31707bd9@gmail.com>
 <4855e9c4-e4c2-528b-c9ad-2be7209dc62a@nvidia.com>
 <5d441571-c1c2-5433-729f-86d6396c2853@gmail.com>
 <f32cde65-63dc-67f8-ded8-b58ea5e89f4e@nvidia.com>
 <95cc7efa-251c-690b-9afa-53ee9e052c34@gmail.com>
From:   Sameer Pujar <spujar@nvidia.com>
Message-ID: <148fba18-5d14-d342-0eb9-4ff224cc58ad@nvidia.com>
Date:   Tue, 7 Dec 2021 23:07:51 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <95cc7efa-251c-690b-9afa-53ee9e052c34@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-ClientProxiedBy: MA1PR0101CA0072.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::34) To CY4PR12MB1576.namprd12.prod.outlook.com
 (2603:10b6:910:10::9)
MIME-Version: 1.0
Received: from [10.25.102.117] (202.164.25.5) by MA1PR0101CA0072.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:20::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.16 via Frontend Transport; Tue, 7 Dec 2021 17:38:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0b3bd43a-b12f-4b18-ad31-08d9b9a85361
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0007:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1201MB0007722212ACD47BF5D00DB0A76E9@CY4PR1201MB0007.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DgyuEOyoVMPwdyLoNxrMAbj0xiMflKRq0dC19MTHdXTWWEDYXEMDeVoES7KvuN2s/xxd7K9OfVYW8QEm1xGW9i2OXOLBhAIck50Y0W9Jrc1WXaoTXsNP98hFDM6XcJk/ZY60dI5rymTJLOi3IxRoeO1JFOzYQ1+TXUJSE4oV0CQqexWFZ7fO16bojkZneRhZ6R7GOXg8oZigetpv0QA6DtJ9lprDZkzSZQ+HWlsHQdP6ElIso+5O0cAFXh4wYAKB7c+quzaiGsnX7DA/tLpxR4N9MF1XsKXD0V5yGb8BGR/8gK5EnaLDNOSszPJUt/9OnRnWFGzCaN7Z5rkllKOOX+SOdFMfrc4L2LNWocIPerM5uBq8yamzAqbjEX9nS0c+U3MEs3EG0NK9uzBRhdBbu/BqURRH9mnd1+4nSiqjq0UdlpTV7kPesPgjIBQRk2Z7YOiiIdzTrVU/YbzCBfvzelb36W/xm1JnvoBiB+Tb9LqLTvIXyrseSf/u6buveMP+8zw7B8dixCFj4SUUCNRnNP2DEG0X3g7LBFQeccfaRz/gvzVrmb16oiIv97DJ+JKwsn3N7xsyWHbeYgnkKGVKqPAAT69QjvF51XWDtRl1Wbgg6exv6NYIFsKRPEfrVEK3Z5T3D+Zyvgv2evC/5ZQquh0agqs7AQlh6tfCRKr2L3JsehoA46r4ee5lnmVLnaMb/edP+46V+xn5s0Hqoqgmb40GuvZTm7h7dErJrn5+lbM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1576.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(316002)(508600001)(86362001)(53546011)(38100700002)(31696002)(8936002)(26005)(4326008)(7416002)(6486002)(83380400001)(16576012)(6666004)(5660300002)(36756003)(186003)(66946007)(2906002)(8676002)(66476007)(956004)(66556008)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZnJzVWZ1QU9OWTVzUnZ4WHFvbGoxbVZWVzQ1RkthTXFsTUduelVKNjBvV3hF?=
 =?utf-8?B?bHhibjQ4eXZ1ckVUUFdVdHBHeVEvWVA1QXkzWGtXdWRiaUowc01Oa1hGdGZO?=
 =?utf-8?B?TnJlU25Dbkl5Q0NvMDgrZ2Jmdk16UU1Rajk1TkVtTUtjek5tdUJUVkhRKy9J?=
 =?utf-8?B?cFM4OTNVTTdONjRXem5iSEZ2a1d4NGpaZW4xdW5oQlcyRHpjSHc2eDZBNGtN?=
 =?utf-8?B?a3o0UXRKUTBZMTlBalRFNU9PUW54ajhjWkdZZ2NZZllUY3JRZm5PQTZYQ05C?=
 =?utf-8?B?RDN3MUxJWmhFNUhUWkp0eFZWb0ZvdzVzTk1hS3dpMElYc0U0T3VnVi9kRFRB?=
 =?utf-8?B?UE0raGdOUzJOSUJ0SDJHME90bHMwdWw4cnV5L3ZQaHNKUGZ4a21rcm5yaFFw?=
 =?utf-8?B?VyttV2lnREFwdnBXVFFZK2hWb2RremN2ZGVMTWtMQTE4Mmgzd2FHVmpLcXlZ?=
 =?utf-8?B?TWF6VnhNbjMvMTF1cW1DMGdqTnRza2ZuMWJxTzdBMTVDQ1UrV3NNV3Z6Qmlm?=
 =?utf-8?B?NjVzdWhDTVgySC9DKytVd3ZyUk9LVnNJL0dpMFRJTWpQSXJzOERGaHRkMTJT?=
 =?utf-8?B?d2pPK01HcUMrT2FVN2NPSDNVMnV0WEJ0TDgxYUtsbW5XaEdyZ2o4bVhITHg4?=
 =?utf-8?B?UnB5TzdOVm4vSXl4R2h2ZEZXVkE4M1J4Nnk2UEd1ZHdjV24wcDRIUnJiaEx0?=
 =?utf-8?B?cEF1SDJTdFdvMmQ0YzJyQzFmNVZ6elJwQmZ0dDZXaERhVDMvK0RkY09GWGth?=
 =?utf-8?B?UHZTMmxpTWxwV0UwMnNJeDB5RE5oTjBNY1lUYXVtR2EwLzhQZ2RCTFBBSndT?=
 =?utf-8?B?WnRNVlk3YUZUM0M1em9yaFNSS09jUUZ1RXB5U1k3WkVOdWh1dVM2Qk8vQUdX?=
 =?utf-8?B?Njd0OFdCMEJEQXhtU05sOFp5akV4dWF3UG9OSkVCZU5oZ2x3ZXQ1elZPTk5K?=
 =?utf-8?B?LzdFUzlJN09kazdPalAwK09VN3o0MXZCbEg2WURiM041UVVVK2ZQM01BWmdu?=
 =?utf-8?B?VFgwS1F4N2JuSUIxVFYzeEZNbjBJTTZDbVhVYWVLWDlDZmYyeHBZTndPeWl0?=
 =?utf-8?B?QytPenlyYzhVLytVWHMvZ2hoUXJEQm9SUlNjQTJXRWZFbEN0R0RtSU12NVVs?=
 =?utf-8?B?c3NuU1g0ZTFrVDNIRmd1NFlML3MybDRRQXRSUHE4R3NCV01ydlVqcU9zbGVw?=
 =?utf-8?B?RHErM3JUNmt5U1hsYk9zQnh3MWFEb0phcWZWL2UvRVo0L2ZQSDl3T2RJMTg3?=
 =?utf-8?B?V3N4aXZDUkp4bXBCazhTNFdUS1BUcUdwVTBaKzZlRGNuU2NWNW9mWmltVUoy?=
 =?utf-8?B?dWpweEFmY1d1VjQwcW42REl3Q3E1dU1yZGhrVkFHQktPaVlVcjdndmU3TGNl?=
 =?utf-8?B?MU52NkFiT2g5RXNSQ3I4SHRtWDc5eUp6VFliUTJuVmZMMFZSZUxmc0ROUmpW?=
 =?utf-8?B?S0JsRk84OGc4QkkweTE5blp3NVZwTWx2YVNCUkRUSFFMRzY3dWpjSVk1L1N2?=
 =?utf-8?B?dDBXbU16S3F0UHBFREJ0eVBydTVnUGIyV1dXdG4xU1doZGhXWkZFdTc5SHpJ?=
 =?utf-8?B?Q1RaN0E3MDdaeURIWnpjdmRZZU12cUhpTXo5aGJ3aitIZTBGRHdRUnFJWW10?=
 =?utf-8?B?Rk40TU8rajR5Q0JSeDRRdXNxamJXUXZMMVVWSEp4ck9GZVZOOFJUdkl5MkU1?=
 =?utf-8?B?UERId2VMM1RJUEYvL29USW5ja3ZOMklUK1BmM3NDamVwWE80c2xmRHRKL3Vr?=
 =?utf-8?B?cGRDczlIU1RCRWVLZG5nR0cyUHJMRXBUWmd2KzBvdmlDcVF5T2ROTWJ5bmNt?=
 =?utf-8?B?WmxUQlJqVjFSdXhVNzl2dS9Za0ZPMjBkY2tobDFxUUExNG4vbzYxK3dseXNS?=
 =?utf-8?B?dVdhK0hCcWlFbFlMbEFJU3FEZTZFd1AvL1pENkFTdDZkUUZYOHdERkNxOVV6?=
 =?utf-8?B?amRRYUdKbFhseXBnZ2phdzRxbnpmY283N0cybTZMTklrQ3YwK1pUTE14WHA4?=
 =?utf-8?B?TkZBeG9DajF6WGc1UUljcit2S2xHR1ltM1RSQTJpeDVWdmh6YTlWL1EweEdp?=
 =?utf-8?B?WmN6bEo4M0RaSFBaQkphdTVGTGRkRk53N3NFVUlDdWRDdnVPanJONnhUelI4?=
 =?utf-8?B?WG9PLy9PMFNqMmF3aVZmTVZvc3lqNXRBeWZmTDdldmFhNC95Qy9sallWZytX?=
 =?utf-8?Q?ynKRGSE4gDd/42xxTf3r8iw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b3bd43a-b12f-4b18-ad31-08d9b9a85361
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1576.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 17:38:05.5809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ax1ysECkNaA3q2LvRyhepN8CzjdNJmrunY0AOLEA6OToGF2c2EGY3m4H4NcsC25NVsRwPlVwqtC3I1Dwx8CkKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0007
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/7/2021 9:05 PM, Dmitry Osipenko wrote:
> External email: Use caution opening links or attachments
>
>
> 07.12.2021 17:49, Sameer Pujar пишет:
> ...
>>>> How the reload case would be different? Can you please specify more
>>>> details if you are referring to a particular scenario?
>>> You have a shared power domain. Since power domain can be turned off
>>> only when nobody keeps domain turned on, you now making reset of HDA
>>> controller dependent on the state of display driver.
>> I don't think that the state of display driver would affect. The HDA
>> driver itself can issue unpowergate calls which in turn ensures h/w
>> reset. If display driver is already runtime active, HDA driver runtime
>> resume after this would be still fine since h/w reset is already applied
>> during display runtime resume. Note that both HDA and display resets are
>> connected to this power-domain and BPMP applies these resets during
>> unpowergate.
> HDA won't be reset while display is active on T186+.

No. HDA reset is applied whenever power-domain is ungated. It can happen 
when either HDA or display device becomes active. So I don't think that 
it is inconsistent.
