Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D387B47A7C8
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 11:32:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbhLTKcl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 05:32:41 -0500
Received: from mail-mw2nam10on2089.outbound.protection.outlook.com ([40.107.94.89]:42081
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229502AbhLTKck (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Dec 2021 05:32:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PsYNmToLIC9+cE0Q8VchSJXxKVcieJoWjGlcouV7PvPCVoO/1xqbsd4ze9hy/mGQiDRKNESpG1wKbe3UzgtrgiADi2YWqmiWdtb6MZmUINL1vdTRcOe2V1nXMDWYnWqZcuWVDNQPKwpnj5gCpNzVoeQEfvMHebfUdxg5juWsv3w6cmeuOdSNe1rYBn/W0qEWJHdfxvbepaJw8NJcIiPNu+1Sm55S59qaWy82tEIOktGhBaqk6oeR3mO6bAbLb/Cl3egK0JJQ2Fd5kt2D3qoEvFN2hHTlJrOINv40AhVv9i5BH5osSCVU9nUBUT1nwT3jLFdqDvujOHJQI5cPwlZ6VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QOLTTRzr1eMKc8YLBRkXGFgi6IKPNo1pfIGpfUWRAXk=;
 b=ayFcFZIvaw1xj6IbAyrqb6lEb5i4+ZVGYANtcnsTjswa2PLHeBmRvT/1nd2a8AEl7tgqVqq1h/z5q8I+myxHgQCf/4j6hhyOijW+BV6Gf40GAJqXSB5OvOEI1Yd5hgCj9LVJi+YEW1BG5YT+1UopbXqeUI1nfZ3sAryocBej1KnrgAKurXJVsCRK3avPB/b39zwaIQ6Qp2YSn8QKCj7b71UPalVqlkJRLWSCZk//K3iof8fil1qyg54VygPAKZ0XYgVk4f4qH8EOpowcDmh9I/D7zUb8Zg4sNpuFkjDG1Lwe/9J2fmCKY3ytHR9jbmbhRvRm78HyRwsV4smGHZLaDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QOLTTRzr1eMKc8YLBRkXGFgi6IKPNo1pfIGpfUWRAXk=;
 b=CZaZ4GGbsPeHvPD+J9GcJhwKw1NF4VlkNzJlsUYJIva7l/cnVecHssLMP9FL/lTiY8lVP0+wvWYcoOp67wefvEDOxBWtoRGhcsSfdoOGRLq4j63VoxBkuPprL+43X81iCvMJzL2S/6+SZxSoQc52sKdPnWWoQQifbIEeJY4JB76TJvTsuo7lM87/mXnSTALQKeI7AdsC/iK/WhUKG33kMwChBCxgaG5JiBVnJeZLV7jxPuclO4NgDxbV3SsVWEdzXAqfqp3c2Zll28MiD0d8jMGIl3nL6ku2ExB29lWBHp1fOn5UVPUIQMTwlji0VBt5fTHQ7+FqCrxPaoJXNywcvw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY4PR12MB1576.namprd12.prod.outlook.com (2603:10b6:910:10::9)
 by CY4PR1201MB0246.namprd12.prod.outlook.com (2603:10b6:910:23::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17; Mon, 20 Dec
 2021 10:32:38 +0000
Received: from CY4PR12MB1576.namprd12.prod.outlook.com
 ([fe80::24b0:46e7:d3c0:a77b]) by CY4PR12MB1576.namprd12.prod.outlook.com
 ([fe80::24b0:46e7:d3c0:a77b%7]) with mapi id 15.20.4801.020; Mon, 20 Dec 2021
 10:32:38 +0000
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
 <148fba18-5d14-d342-0eb9-4ff224cc58ad@nvidia.com>
 <3b0de739-7866-3886-be9c-a853c746f8b7@gmail.com>
 <73d04377-9898-930b-09db-bb6c4b3eb90a@nvidia.com>
 <ad388f5e-6f60-cf78-8510-87aec8524e33@gmail.com>
 <50bf5a83-051e-8c12-6502-aabd8edd0a72@nvidia.com>
 <7230ad0b-2b04-4f1b-b616-b7d98789ded0@gmail.com>
 <48f891bc-d8f6-2634-6dd1-6ea4f14ae6a3@nvidia.com>
 <0761f6f2-27f8-4e1a-fabc-9d319f465a9e@gmail.com>
From:   Sameer Pujar <spujar@nvidia.com>
Message-ID: <b57bc2c0-7aed-635c-a488-bb50af470a36@nvidia.com>
Date:   Mon, 20 Dec 2021 16:02:26 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <0761f6f2-27f8-4e1a-fabc-9d319f465a9e@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-ClientProxiedBy: MA1PR01CA0182.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:d::8) To CY4PR12MB1576.namprd12.prod.outlook.com
 (2603:10b6:910:10::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 744f14f4-2b7d-4919-d760-08d9c3a40b6f
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0246:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1201MB0246EA4A03C51EE613E19707A77B9@CY4PR1201MB0246.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZmsYNZSI9lXCr665nM3nl2eO027SeBW+pWSwHrVhbhNjgtEvJWFDfMwAKZuF8risaPm/1FPbj9NV50z65AOHzuZnn4x3YWjbtld/Y/ffr1FILe7EykIg5S13tniAmbJzzBb7hrEw9W+a4plTz7tovSTNTuzD0DjdukyIEjJRvB53EUCNIQxhpY/53wM1Kzh+6qmoBX/5/2N5a6dmBjcrO/3jw/BAnfcJ3Gn9t4NEmRdZX95mBou8v267Xy5KaeSodoV6RXWFw1DUbri4YDy0psxatblTwkJRrlxLIDOil0xUiVFV9Jne7oXA7qo/dNqkNv//0oIIUYkXAzrMqscyuxIfFMAJVbIkA/xE/9BJNpOTCv2rzcBI+BwV2kmfi9if58IL7z6dHDvBET2UzDzHTTbpEZwDma/pKK0EYUyRh+Zbooehft6W8cg/e8Zv3deVQlT2HJq0QAzb4Kz0R0dQYZzdmWjcGfgokzIqE+gJ6cHK2Psy43RmCL1Bj4ZG0fgcghGEq25kdmUqv1hkXyYYQSWFsSh4Rg/lHkz5XT6cFBTBPBSMBfeVkxmTDpVzgtqdZxO8QMO3P6p6sWMO+PTnBRG2oaJy4sHC9YvlEuoVA32SMwog+sebyD/66JU+BqsWIbF58A3Au4EgAgZ9GbGpf8hwAxWAHRv3VVYnpM7iFNiDNYoollCsiyDifyEKlWFq+CH5v6sioTMeR0G0veYngvs8zNRxAuTZmg38B9yEdpI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1576.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(36756003)(31696002)(38100700002)(2616005)(86362001)(31686004)(83380400001)(5660300002)(508600001)(6486002)(186003)(4326008)(8676002)(26005)(316002)(8936002)(7416002)(66556008)(53546011)(66476007)(6506007)(66946007)(6512007)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZXhZMDM3RmVKTVExUFBTZkNOekE0K0JiTWljS254T3VsR0VwbXR6VWdHOEZG?=
 =?utf-8?B?cjREbGpEOFJtelVjM202WWhMREZQZ0svNnJHRmo5RmxzcnF1dDJaZEpzK3pO?=
 =?utf-8?B?YTNjR0RoTjJNRmROcnBIcFdXK0ZoRVd3OXZSNEZrSy9nUDQzK1BHVDNpUXQv?=
 =?utf-8?B?bEVTK2dqTUZFM05TMWdJZmgyYjJjUHM2ZHI3WEtYODRYWmxpZm5Zc2N2b0cw?=
 =?utf-8?B?aTZsL1MxMDhFbitqVjhHMTVXbFlhcUpCSnI1anZUK3ppMlRPOFdFZWdMbzhk?=
 =?utf-8?B?Zy8xcVdoYWhoQnRxMTV0OXpQeStIV3A1dkYzbGdLRWExY3ZYaGhOU1N2ZW80?=
 =?utf-8?B?dFVXSTl4MlNZUHhIbXcwOExMcXBtR2VJZUxhRjQyV1FGbzN0RE84QjcxMmRJ?=
 =?utf-8?B?OGd2SGFFN00ybG1KTjhaTmdvTzNVaXVNc2twc3BURCtib084cmR2bXJNUkdQ?=
 =?utf-8?B?MG9VS2ZLRkhLY2c2T21maWRHRTZaVk13b0ZYdW5MZkFMTitkOWQ0ZXQ5QjhW?=
 =?utf-8?B?RG56VUlEdFJPZC9DQWpSUDVKdlptWDcvWXVQZDRwVVV2R003NDlJek5SQVB3?=
 =?utf-8?B?K1EyWEN2dHFBRDBIczVzdXlrTVFlWm1ONk5aOERZVGcxWEJ5ZEc2ZFpwekpD?=
 =?utf-8?B?NWtSVWgrN0V5d3ZzbFJJbzZvNERZU052SHluRHdPQ3c2TUhnQy93b0Y0cks5?=
 =?utf-8?B?MkFOZHBJSUxNZ3ViakNyMmc1MzRlRHUrR2xONUpNL1kyc1FDZWprM1RWdVYz?=
 =?utf-8?B?ZGprdFVjYUNsYXV4bE4xK1c4T0g4YzltQktCdXlXNm9ERVB3VDFTT2pFeUU4?=
 =?utf-8?B?Tmc3eHdaUVNlcWdMblR5WE9JYnM5R21YMjFEVlk0Y3hCdnBDcUVBNEE2bkla?=
 =?utf-8?B?bHBsaElhMm1HMitsTVlDWVFSYUc2YWlXNXlKcVF6dlV1bDFLSHlsQjZ6UCtm?=
 =?utf-8?B?WVgxSUE0aHBKSUl1dWFrZFJJUWJ3TVVMUURjYmloaW9uaG04SnpBMitLNlcw?=
 =?utf-8?B?Z1hNcE1ONjBBVVdjQXAzc0lWQ0ZuSVBBem8ybStycVBQV1cyWXJSNGVBYVFJ?=
 =?utf-8?B?QWloaDAvR0FVVXFmR28rclpiZFRCTWVGU0NEL0QvZjBGM0RhcWt1ZHROSjFv?=
 =?utf-8?B?dlZhOXpwWEtObEFXZGlPNHNkeDdVSFdkM2M4YjgzNzBUblNDdUlBb3U3aHVn?=
 =?utf-8?B?REhsYXVzR1E2bXZTZ1Q1d3paeVFvcFRMamZKV2FqL2gwZzYvWjdqaUhhbmx5?=
 =?utf-8?B?bStNMGpUOFlqNzhZZ0grMVNIV0d4bGpPUUZUQ1lKL1RhMWlBQWUvNVpGZkZq?=
 =?utf-8?B?M3NseDVXYWpybkxHNjhrMGhXaWQ1VURVN2VlYUlnNUVGN3ZncGxtbllhbnd0?=
 =?utf-8?B?K2M5R1J1c3dnUmMxNlJUSGVubUgySXpuTVNYOUEvVjh6Ni8yODZIcHJaYnNX?=
 =?utf-8?B?aVl4ZlpJRlhiWXNKMUhVUUVkUDFnMnU0cDNxb0twbDdhYng4Y2d0YzYvYWkz?=
 =?utf-8?B?cm1COGRJQjhLTVVsNUZ3ZDdCNlFOSkZyK1pIc2RyckJsMkdOVllTcTlwcm1F?=
 =?utf-8?B?ZHBad1Nrczg1N3haSjk2OHZwZWtrM2tJNFhuQURXQmx0N2x1TzFyN1FwQnEy?=
 =?utf-8?B?bk5VWjhncVI3RFVKUWZuSkJHUjlUNlNUYWs1N05lcE9vYVpXM2MxVlhTV0Nk?=
 =?utf-8?B?VFVFcWx5VWMvcWoyZUJISnI4MVBZMURqUEo2UVhkL1EzMTBxMmdFUXhabXQ0?=
 =?utf-8?B?Skl6RUtxSHljWW4rMXd0MCtPQzFpdXhLbmFPRFhaTEtBRWE3UHJ5MkVCLzJR?=
 =?utf-8?B?QVN4aWpKbmFkV2lxVTI5T0dON3BmMWZ6ZXdvUWkvOXFlQ3dMdUJPSHBKb3pi?=
 =?utf-8?B?M2toQjM4WFM3ZTJ5MlplODBTVXMxbkhhdWl5bDhydXlKczlGMTdBMzEzOHdQ?=
 =?utf-8?B?dWRkM1ZWWEdVelZ6TWhPMm1uZEsrSmpwSVZvWHBuSlhQcGRVcG5KZkNVQ3E3?=
 =?utf-8?B?RVM4SnhLMkw2b1hLU1Axa25lajZMekFvMUpWd2hlQnFRdDVJcHFMNXJmZlY4?=
 =?utf-8?B?cCtpM2wzQ1FpY2hRZytIakNVYit5Q1dnOE9NdlpLb0F2RjgvbjNJM2hFMmI2?=
 =?utf-8?B?WjJ3aE5jdm8xaDgzcktGRithSnNWUUYwU3ZmUXBvZEt0NllQTVQ1YXhmZmd6?=
 =?utf-8?Q?qZv9KIrM/9n6ZMBbJc5nDow=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 744f14f4-2b7d-4919-d760-08d9c3a40b6f
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1576.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2021 10:32:38.5566
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S+ZBJkd8hHLJZ7RUAkwtXN07tWCCwcEJ8NEFhiqTYwOjHCa5ylo016FjXlk31dONG8OJVMyQgvB0Fmy3dqlslg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0246
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/14/2021 7:26 PM, Dmitry Osipenko wrote:
> 14.12.2021 10:22, Sameer Pujar пишет:
> ...
>>>> How the reset behavior is different? At this point when HDA driver is
>>>> loaded the HW is already reset during display ungate. What matters,
>>>> during HDA driver load, is whether the HW is in predictable state or not
>>>> and the answer is yes. So I am not sure what problem you are referring
>>>> to. Question is, if BPMP already ensures this, then why driver needs to
>>>> take care of it.
>>> 1. Enable display
>>> 2. Play audio over HDMI
>>> 3. HDA hardware now is in dirty state
>> Why this would be a dirty state? It is rather a functional state. Isn't
>> it? Power-domain is ON while all this happens.
> In general state should be a functional, but we shouldn't assume that.
> There is always a possibility for a subtle bug in a driver that may put
> h/w into a bad state. Full hardware reset is encouraged by users.

OK. I will prepare a v2 by just skipping the invalid reset for Tegra194.


>
>> Another point is, with present logic the reset is not applied for every
>> runtime PM resume of HDA device, which is confusing. It depends on the
>> state of 'chip->running' flag and I don't see this getting cleared
>> anywhere. Would you say subsequent HDA playback happen under a dirty state?
> This is a good point. There should be another potential problem in the
> HDA driver for newer SoCs because apparently we don't re-initialize HDA
> controller properly after runtime PM resume.
>
> See hda_tegra_first_init() that is invoked only during driver probe, it
> configures FPCI_DBG_CFG_2 register on T194, which isn't done by
> hda_tegra_init(), and thus, this register may be  in reset state after
> resume from RPM suspend. It should be a bug in the HDA driver that needs
> to be fixed.
>
> On older SoCs: HDA resides in the APB power domain which could be
> disabled only across system suspend/resume. HDA is only clock-gated
> during runtime PM suspend.
>
> On newer SoCs: HDA power state could be lost after RPM suspend/resume,
> depending on the state of display. I'm wondering whether HDMI playback
> works after DPMS on T194+, I assume this case was never tested properly.
>
> It looks like it should be safe to reset HDA on runtime PM resume
> regardless of the chip->running, and thus, we could remove that check
> and reset HDA unconditionally. Will great if you could check/test and
> improve this in the driver.

There seems to be multiple issues. I will work on this separately and 
send a separate series. Presently basic function is broken on Tegra194 
and will first send v2 to fix the regression. Thanks for review.
