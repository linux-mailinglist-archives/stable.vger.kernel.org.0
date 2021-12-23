Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 767EF47DE40
	for <lists+stable@lfdr.de>; Thu, 23 Dec 2021 05:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346330AbhLWEeh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 23:34:37 -0500
Received: from mail-bn8nam11on2081.outbound.protection.outlook.com ([40.107.236.81]:33696
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1346323AbhLWEeg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Dec 2021 23:34:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K8MmnFyOIubhhNY/qEGxvMhzAgDTqd0HCtZauYKqmNZMpe1JLeOE0wmwUqM71dg0A44XIGu7lovhBQMSnfkEzXTFb/x3M1sfC/Yo957ZM85cZ1KL/cAIJbKbFCuR+ZDl6aupyYIB1l/pVCsBgfpTXsJFK4InIDl+5GiqNcIx8yNddyvR/e86DwAGJQFhuBGDHo7YnrdRqMc1O1dScMBFg2Mw0AYGQo5MuzIFJ5wK9pBxYdbidJJFvNxNSsOJVBX7G1ZwZEvWtF71HrBA0RHypsDKugHcGueAzZd/UByNfkkYil6JtM0SIhMIq8n3wiyk6xZdyhqpFjiiQAT6POnXNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A0s2xTxbR6XP++AQf/8dfI3KKhJTeo+yL15QgD3YLOE=;
 b=oHEebC+rDg3zSQZd92fLfZmnSV08czR9iWqR+9Wsen3wgwlkJahCtgkwno7Q1rSIZYB2szx8YwNHqV438G3MC0wnfSfIlkX28vQfGfvIJISEYo5lWbsCp7/1iIXoJ4hbb7MUOiwhBfhPtvzbO+6q42zcRnw/PexhDrQguQ0Ap3LXW9+RjEMfDA4fo7U8OiRQL6x/yuP/i5hlQvJxfRwxMjwT0d6TZfwvWtbOUdDRQVWHb88sNNP2B+A/cIzY5hn/MycVd2VWqkkbUsmZglk9ZLwwMSOXPj3URSfyQqgpaHo8/a/W5xr4/RU1L/R4Mr9A6/UQwq7+YNm9BBsm7OVcxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A0s2xTxbR6XP++AQf/8dfI3KKhJTeo+yL15QgD3YLOE=;
 b=BFKQC5wUixo0zPSAQwjhdx3J2TpHSNGCHqvLGz95R0XwbvS3eGWnXuAm6uNmwpG/0Ja5dhSS150YIwR5ztWh94h93g7Fhd15BBtjKKo9Tj0xHk19VWhGDtXbrtVLtaze3m2UV3VulmvtRWmAbvAWE1OppkEwHJ0fJNNYB1t0nkeG9B9S0sQgMfY37sl0+cMK7x8BL0FON/4PUcZYoy2AGwhoM53o3ePQ+fyR1Utq+b/BSvNPRIpfAg/+ZxXf+XAX5uOM21upSg3UzmCNzy2Cr31iNU3jpCgmqx0B2Jxy1gpQ+to8UJjdDRWMyLL6kAUkZLECzC5RsCPAfF36gXMRJw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY4PR12MB1576.namprd12.prod.outlook.com (2603:10b6:910:10::9)
 by CY4PR12MB1669.namprd12.prod.outlook.com (2603:10b6:910:3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17; Thu, 23 Dec
 2021 04:34:33 +0000
Received: from CY4PR12MB1576.namprd12.prod.outlook.com
 ([fe80::24b0:46e7:d3c0:a77b]) by CY4PR12MB1576.namprd12.prod.outlook.com
 ([fe80::24b0:46e7:d3c0:a77b%7]) with mapi id 15.20.4801.024; Thu, 23 Dec 2021
 04:34:33 +0000
Subject: Re: [PATCH v3 1/3] ALSA: hda/tegra: Fix Tegra194 HDA reset failure
To:     Dmitry Osipenko <digetx@gmail.com>, tiwai@suse.com,
        broonie@kernel.org, lgirdwood@gmail.com, robh+dt@kernel.org,
        thierry.reding@gmail.com, perex@perex.cz
Cc:     jonathanh@nvidia.com, mkumard@nvidia.com,
        alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <1640147751-4777-1-git-send-email-spujar@nvidia.com>
 <1640147751-4777-2-git-send-email-spujar@nvidia.com>
 <fb8cf33f-41fb-79c0-3134-524c290e4fc1@gmail.com>
From:   Sameer Pujar <spujar@nvidia.com>
Message-ID: <f734e48f-dd60-ddb8-510a-3c4f37d8fb52@nvidia.com>
Date:   Thu, 23 Dec 2021 10:04:19 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <fb8cf33f-41fb-79c0-3134-524c290e4fc1@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-ClientProxiedBy: MA1PR01CA0101.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:1::17) To CY4PR12MB1576.namprd12.prod.outlook.com
 (2603:10b6:910:10::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 82efb77e-d601-4e87-bd32-08d9c5cd84ae
X-MS-TrafficTypeDiagnostic: CY4PR12MB1669:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB1669C0A4D1B0481FBD868B70A77E9@CY4PR12MB1669.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IA0hg3tBbO3icQQlRbf8/Lppyc+tu3HYnyPVOOhhNJQccivpLoc2fOxW1FvPym2ahNbbWMF+8dtre6XJMnPvmT+jMQaV9IixT8jynTmfeeEVO5V3zjaIux+CXvitLwW/aPAIWh1BQZ5jNk8spKvmGgQqztTDafCZMnEHm9qQN3yp4TuROyby8aenDUYMlWU1B7iYFbWnrgIfKBZkEgo3PUK/Gdml9A/MI9IeUnERD2x0oeT1pSldNGXbVEDxP2lCkZSlnbbzIf0uyCNEw6jcWjmzs7TX7PeDfR0Sw19pOK/dC5wVhxEKInnXJ83apm9Jvk3exHHS/UNs9fZjwnIBHx/o1NSlT38ClfAVBLMUP0fSd6VBunpsuBHpEU/sfGkK7pHauTFc86pNdzdw+4sYs4kWuSRxlbjM7V6Upn6d135gSLvr+I0aWtrSPzzUARkPl5gBfgew8a0132Uy0hPq1piKv/RWO/ihRaKKpzJcE70VrbJLrfChMnF7E6VYo945rgUuLCrsPpj2/H/JyO7Z6lZSN/2198tQvNX8HWciiF+ulQRLJ4XLHUCoHxlnww4zBX9SIqE2I2Fe9hHBSheEMkMPhk4Qiqn4YC8SPB9rVYceeJWnFjYTKi0GKMBB/2fkXElFM1HRKxrY3EGWNuMfFIRwJZ9ZPAYLqBMzt/v1KqoJPfO177oKI8UsFnImJgq7MkBnhdQ3T+wjXLxPFymKELlg6vJHh0EAHs4inQgCcK0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1576.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(26005)(6512007)(66556008)(186003)(2906002)(8936002)(5660300002)(31686004)(66946007)(66476007)(8676002)(7416002)(86362001)(6666004)(53546011)(31696002)(508600001)(6506007)(316002)(36756003)(4326008)(6486002)(38100700002)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZkZQcU5tK1pFRjJtZHpzYjZBWDc0bFRWWDVhUnRZcU5NNVNDeVZXUHdUUU5C?=
 =?utf-8?B?QkNUUHFKZjJSN2NuY2kwbGxvbFVXaGFmQzBtbDJlZUFqa290OHdTZVJ6Zjl6?=
 =?utf-8?B?SlBOODFhY0FEbGtWanlPOGx2WXF1QXZnSlI4SHhiWjBIRDVkaWh2VS9OWGhm?=
 =?utf-8?B?TzkrTDE1QitWT2IxejlweTBFbHp2cDVXTnlGWUlLN21XZjJjUjdwaDZVbTI0?=
 =?utf-8?B?WHpHeXU5UEx1azE3WHgvVnZSTlJnanNRR05idi9wNXNuTmxOK3NNcWhsUlo3?=
 =?utf-8?B?b3puYjdWeDZXU1A3eUI0OHpuRlJ2eWNiaU1zbkZCWjBHcGFyTlZZOENuQ0M2?=
 =?utf-8?B?eVA4K2VlU01MWTJDb1pTZ1V0dnNGMkFPZVVBUnorTytxTTBNQ0NoZ3dROUU1?=
 =?utf-8?B?YjlvNW04bGZaVVNpeVplcTBXY29Ld3c4SkxMb0NhNy9sNStmR1NQRFN3UnBx?=
 =?utf-8?B?dWdZb2UwbmtPcmQrandRTGpzTW1XVTlVN2owYzByaHVKV3VQUlJWNHBTRkJs?=
 =?utf-8?B?N1JiOEFjc01VakdWTzVkSEdGMW5vQXlqRUpaTDdkWXBLdFdIYkZuZXZsVTNL?=
 =?utf-8?B?eUVZWWRZSmM3cU1vNUpJUS9pRFRKUUxLMVV1QW9kY1QyYlhvRFpENjdhNzJE?=
 =?utf-8?B?dE9iSUpEbW9KbitiWlMwRGVnRlNRcDFWcVBkZlFIZDlaQVZBaXoza3QyaEt0?=
 =?utf-8?B?TS9Dc2tkbEo1ekRjZFRvLy8vU2RkRjQyeEo1N1hyNStNMTVRVC9jcTcxWThF?=
 =?utf-8?B?RVNnOU13K1phRzFVUW5ZTHVTUkd1Y21pN3Y1Ry8wdndETHdTNFpuYnpTNTRB?=
 =?utf-8?B?OTBUNGFuWGJ5cTZKOUg1SktLUnpROW5Yd3hZRUV6T3RhS05YYWU0QTdPZDJQ?=
 =?utf-8?B?YzhaWWh0OWtNT240TFkrLzVyUFJpSC92U2Q5MHQwUW9aaERDMFhwMHpIYjlz?=
 =?utf-8?B?NGxOc1ZpdVg0WC80Vm9NUHUyRWFBU2dyQ29UZkU2cWxYcUxiaU5aVkRwTmJR?=
 =?utf-8?B?RmIzcDZyTGRiWE5LZkJ5SWRpY2lhTE5XSElCdWhSUXZmcWg5VTJYelhOVEJn?=
 =?utf-8?B?SnN0aWo0TUl4eWhnY3hsWmtnTnN0a0NtcGNXazVkbG4xOGduc0VvOWFqaks3?=
 =?utf-8?B?NEc3QkduUnd0dnN0MVFvYjdORDh5UjhJY1hmUGxJN0k2WEZ0VUx0SVU2U1Ns?=
 =?utf-8?B?YlBTc1pWekJHbXBjU3UvTzVHQWVWd2wwNzZyeW94QjRwVHRab3czUkprWHQ3?=
 =?utf-8?B?eTYxOUx5SFI4UzhsREdVNVYyVUZ3MjBOTnhQMFBHVkY5dDdaSzJETzk5L0xX?=
 =?utf-8?B?R0hUMTJGRVdMWlRQeGdNaHBTb1A3RDZDTlFCL0k5TktzS2h6SUdpQ2xQbjZK?=
 =?utf-8?B?SC9hbVA2UFNSRjBmSUI1cmRVUVIzalh2TFRMZkt2OFJMMW5yMitBWEtwVFB1?=
 =?utf-8?B?dTRFYW1weHhsK1hmVU9IK05rUjB5a3BDMFM5ekJ0Ukc4SitCNFY4VnMvQW5r?=
 =?utf-8?B?Y1lCUEhZSTIrdDBVdXhqaWtWakpQcmxvKy85T2RoOTE3N0tTaW1Ka25VUndz?=
 =?utf-8?B?R0lmYytMUHZJMDU1QmlFK1FFazdodE5GRy9ydFlCRUF5ajJNZjU5T3BtZkFM?=
 =?utf-8?B?aHVmTWFYUFFqY3FXRW9aRWsweGpqR2hJTXdqOGdST2lYcEdIa1VWSy9BVlpx?=
 =?utf-8?B?RmZBZS9taHdLNVJlckRuNEVsYm5YUHRRRDl4RTFCeHZySUF5TjJwaTl6YnFh?=
 =?utf-8?B?S0FvNjJ0VlFVMXB4b1RhUkZCSnFQSk51KzRxS3NrSXZOL1J5Q3M3VGxBZ0xN?=
 =?utf-8?B?YktqbVR0OGtRbEF1Tk1ZQWlzVGVJRG5aWkJ0Y0I1b1RJQ3RtRzRhNWpzVjJE?=
 =?utf-8?B?N1pZTTZha244TVBmNzdwLytDUFhwaHdPNHNCbDUzSWFuQm1aTWFRTDdVU0o4?=
 =?utf-8?B?NllGYnAyTFpRNEd3d3Z5TWNCaUIreGM4SVBwQTg2QTFsQmM2cW1TazRLeVZw?=
 =?utf-8?B?ODFnM2tSR2Zoc0hnd0U2NUROL0dCMVk4bDVGZ1NLb2NaQmxvQmV1cERrbFl4?=
 =?utf-8?B?UWs1REhHRzFtOUhHTkFjUGZ0NzB1R0FvNE5RR3Mwc1pGY0pjSEZlT25FZVdz?=
 =?utf-8?B?Z3B6RHJEMTN0dGtPOVI4UFZYSnc4V29qbGZLNkk3RHNETWxDeEJPY3p6UGRv?=
 =?utf-8?Q?yIEz0kXNqBO7qLeVMKVQh9w=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82efb77e-d601-4e87-bd32-08d9c5cd84ae
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1576.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2021 04:34:33.6246
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SYMid/o90TZtHGjpUIp8ORgHdsMBVz3QPi6ZZ+0XjNFc2qrf4K1alCZIizM+Fvu8kXUY2wJgx78X2UaQQDM1EA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1669
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/23/2021 12:10 AM, Dmitry Osipenko wrote:
> 22.12.2021 07:35, Sameer Pujar пишет:
>> HDA regression is recently reported on Tegra194 based platforms.
>> This happens because "hda2codec_2x" reset does not really exist
>> in Tegra194 and it causes probe failure. All the HDA based audio
>> tests fail at the moment. This underlying issue is exposed by
>> commit c045ceb5a145 ("reset: tegra-bpmp: Handle errors in BPMP
>> response") which now checks return code of BPMP command response.
>> Fix this issue by skipping unavailable reset on Tegra194.
>>
>> Signed-off-by: Sameer Pujar <spujar@nvidia.com>
>> Cc: stable@vger.kernel.org
>> Depends-on: 87f0e46e7559 ("ALSA: hda/tegra: Reset hardware")
> Is "Depends-on" a valid tag? I can't find it in Documentation/.

I do find the usage of the tag in many commits though there is no 
reference of this in doc. I always thought it would act as a reference 
when commits get pulled to other branches. If this is not true and it 
does not mean anything, I will drop this.

>
>> ---
>>   sound/pci/hda/hda_tegra.c | 45 ++++++++++++++++++++++++++++++++++++---------
>>   1 file changed, 36 insertions(+), 9 deletions(-)
>>
>> diff --git a/sound/pci/hda/hda_tegra.c b/sound/pci/hda/hda_tegra.c
>> index ea700395..7c3df54 100644
>> --- a/sound/pci/hda/hda_tegra.c
>> +++ b/sound/pci/hda/hda_tegra.c
>> @@ -68,14 +68,20 @@
>>    */
>>   #define TEGRA194_NUM_SDO_LINES         4
>>
>> +struct hda_tegra_soc {
>> +     bool has_hda2codec_2x_reset;
>> +};
>> +
>>   struct hda_tegra {
>>        struct azx chip;
>>        struct device *dev;
>> -     struct reset_control *reset;
>> +     struct reset_control_bulk_data resets[3];
>>        struct clk_bulk_data clocks[3];
>> +     unsigned int nresets;
>>        unsigned int nclocks;
>>        void __iomem *regs;
>>        struct work_struct probe_work;
>> +     const struct hda_tegra_soc *data;
>>   };
>>
>>   #ifdef CONFIG_PM
>> @@ -170,7 +176,7 @@ static int __maybe_unused hda_tegra_runtime_resume(struct device *dev)
>>        int rc;
>>
>>        if (!chip->running) {
>> -             rc = reset_control_assert(hda->reset);
>> +             rc = reset_control_bulk_assert(hda->nresets, hda->resets);
>>                if (rc)
>>                        return rc;
>>        }
>> @@ -187,7 +193,7 @@ static int __maybe_unused hda_tegra_runtime_resume(struct device *dev)
>>        } else {
>>                usleep_range(10, 100);
>>
>> -             rc = reset_control_deassert(hda->reset);
>> +             rc = reset_control_bulk_deassert(hda->nresets, hda->resets);
>>                if (rc)
>>                        return rc;
>>        }
>> @@ -427,9 +433,17 @@ static int hda_tegra_create(struct snd_card *card,
>>        return 0;
>>   }
>>
>> +static const struct hda_tegra_soc tegra30_data = {
>> +     .has_hda2codec_2x_reset = true,
>> +};
>> +
>> +static const struct hda_tegra_soc tegra194_data = {
>> +     .has_hda2codec_2x_reset = false,
>> +};
>> +
>>   static const struct of_device_id hda_tegra_match[] = {
>> -     { .compatible = "nvidia,tegra30-hda" },
>> -     { .compatible = "nvidia,tegra194-hda" },
>> +     { .compatible = "nvidia,tegra30-hda", .data = &tegra30_data },
>> +     { .compatible = "nvidia,tegra194-hda", .data = &tegra194_data },
>>        {},
>>   };
>>   MODULE_DEVICE_TABLE(of, hda_tegra_match);
>> @@ -449,6 +463,10 @@ static int hda_tegra_probe(struct platform_device *pdev)
>>        hda->dev = &pdev->dev;
>>        chip = &hda->chip;
>>
>> +     hda->data = of_device_get_match_data(&pdev->dev);
>> +     if (!hda->data)
>> +             return -EINVAL;
> hda->data can't ever be NULL because all hda_tegra_match[] compatibles
> above have .data assigned. Technically this check is redundant.

Will remove.

>
> Thierry suggested previously to name it "hda->soc", like we usually do
> it in other drivers.

Previously I renamed strcture, but didn't update the member name. Will 
update.

>>        err = snd_card_new(&pdev->dev, SNDRV_DEFAULT_IDX1, SNDRV_DEFAULT_STR1,
>>                           THIS_MODULE, 0, &card);
>>        if (err < 0) {
>> @@ -456,11 +474,20 @@ static int hda_tegra_probe(struct platform_device *pdev)
>>                return err;
>>        }
>>
>> -     hda->reset = devm_reset_control_array_get_exclusive(&pdev->dev);
>> -     if (IS_ERR(hda->reset)) {
>> -             err = PTR_ERR(hda->reset);
>> +     hda->resets[hda->nresets++].id = "hda";
>> +     hda->resets[hda->nresets++].id = "hda2hdmi";
>> +     /*
>> +      * "hda2codec_2x" reset is not present on Tegra194. Though DT would
>> +      * be updated to reflect this, but to have backward compatibility
>> +      * below is necessary.
>> +      */
>> +     if (hda->data->has_hda2codec_2x_reset)
>> +             hda->resets[hda->nresets++].id = "hda2codec_2x";
>> +
>> +     err = devm_reset_control_bulk_get_exclusive(&pdev->dev, hda->nresets,
>> +                                                 hda->resets);
>> +     if (err)
>>                goto out_free;
>> -     }
>>
>>        hda->clocks[hda->nclocks++].id = "hda";
>>        hda->clocks[hda->nclocks++].id = "hda2hdmi";
>>
> Not sure whether the above nits worth making v4. I'll leave it up to you
> and other reviewers to decide.
>
> Overall this patch looks good to me, thank you.
>
> Reviewed-by: Dmitry Osipenko <digetx@gmail.com>

