Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2456D4FAA
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 19:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231416AbjDCRze (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 13:55:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232054AbjDCRzc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 13:55:32 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2066.outbound.protection.outlook.com [40.107.237.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6E28359B;
        Mon,  3 Apr 2023 10:55:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KipK6r/Ih3EvZ+sroZEDB7qBG4/aAS7tK3uOXDF9ZsAkmVdWQiSD5IXfs6V+f19ADm4/jgdVaVCzWDsS6+lT4qvwai7uEgVXt8wJZ8XTBCBlbbih8bUKPGyfawrMwSSrRHDtJ5OkHzemWVZ7/VOmHhT0L2smo+arb74eT09HppkbOQ+ha7wpNiRz4+pRZ5goUM1fHok9P7hIVi/j7dkE862jEjJCRaQuXjEed8jnJWGPws84mlTEBsPxefETwsxhS2UCwrY5TY6CRrvFE8xyrEBnDu8H2IYSa7jdNyTx8DUgnesOPe3hI8OpXuoqjkFO/oPSDWnbOlhs/GVFfET8FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+eCHlp8dPM6PHyNcxzHwcv4vpL5Z/ruO6VK+819CwUk=;
 b=WEx7fLgdNtGzry4HcHwKoqmhupoydWDTcgZ/eL8t+m91AhkVq7P4okEtK5R926U8nLX4O+MJajIq/ZRk2RiRvMtw4ONveXxSsmIkYk3kxBj2q2LJ7aBedz8DH/TRIK0Er6q4zyTKdUayCE/7wE30rblZw6joQochCdijeXEbelJe/T7KWQsIxEE8BoXIlq2cHMYahk7LQJ5XbsNt+O9A8hz27NHpWwh9iOWLbQn8zLY3nmC8Tn+LtMhwDk0RJ1ALSHp5vvDY6lhNSpSSTLmrXDTBidn+g1qa7/3z/XcR2NFWzmp2DWpLKEd5AuuowZzgheErvqeNTXv//fDFMQQhUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+eCHlp8dPM6PHyNcxzHwcv4vpL5Z/ruO6VK+819CwUk=;
 b=ecUlu0cogstmrrnVn8AWibWz1gjzbkqilaQpNr3k6ZLUHW4KG11iaIvfXvzHFtpXARYlrcjVedtOi161qq8YjRWwVdCu8YHv4ieQdFvT/cwyBApyMhwAzRfa+DBWPKCGOslypDhB4KH3KSRbndFhGzLf0KhdEhVpnV1TusV3xUc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by CH3PR12MB8209.namprd12.prod.outlook.com (2603:10b6:610:123::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Mon, 3 Apr
 2023 17:55:17 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::5b56:bf13:70be:ea60]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::5b56:bf13:70be:ea60%5]) with mapi id 15.20.6254.033; Mon, 3 Apr 2023
 17:55:17 +0000
Message-ID: <56d92baa-d05a-9b02-0195-7627187fdde1@amd.com>
Date:   Mon, 3 Apr 2023 12:55:14 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH] crypto: ccp: Don't initialize CCP for PSP 0x1649
Content-Language: en-US
To:     Mario Limonciello <mario.limonciello@amd.com>,
        John Allen <john.allen@amd.com>
Cc:     stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230403173801.2593-1-mario.limonciello@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20230403173801.2593-1-mario.limonciello@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0272.namprd03.prod.outlook.com
 (2603:10b6:610:e6::7) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|CH3PR12MB8209:EE_
X-MS-Office365-Filtering-Correlation-Id: dc717119-cb24-47fd-6d2c-08db346c956e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X/4Y3mZmFwCk/Can13b/sjjmfdVvzg+kT7h5cmpCEDPAEAZQR4C0ZShAujJp2rHjxHxSnc6uYMDs0ADJYdqbwpsUNeOwyyYP2BEkareGnNEIVCjJwxNRKSchFCtvx6vdYHHUvlVTVYc4hql7nMHI+Xe+vz6+m2+2k7KT43K8A+PNMaCybbSNhSxc6WXHLZMCf3AFBfRFTB3Xtaqpwj7DEddfESBCIWvPrfcYYjkOhYLq0Qg2y3G6Q1xLjIR17JeNU8nnMpH8huHB/zjMusqGAS4aoW71aITXtR7AAe+9yg281uOsXrc6vMRu9NlbkYDrbOcFsET2HJLcX8W98shiI1i8Xsql2CUjITb11hgkvjhfrJ8xktebI4FzcqB3i8Nboy0YvlrR/eIJHospAuVK+7uriWZCXqAJu+RXitouf3MjQzn9MqljR1msoTCWPlpPtIDaBTazdSgOda4jXXbNYQMwpOCvsc5z6njUNoCk4A8HNQLTizT5X3q7dQ++ufqBpx0aBtV7ispEt0quFnxdMZhSwvav9Y5R56/klz0f4Qg44DG6+f/lNOtK1PCx/geIUZzwyJVKfulUoxEDS9iisYZdhq2zlSjniRNcANo7KuPaHo84nGVcl0w1Rzi2OJvJh5JP7GZ4BSlAVax1rSOf9w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(396003)(136003)(376002)(39860400002)(451199021)(38100700002)(86362001)(31696002)(36756003)(6666004)(6486002)(2906002)(6512007)(186003)(26005)(4326008)(6506007)(8936002)(66946007)(5660300002)(41300700001)(66476007)(8676002)(66556008)(478600001)(110136005)(6636002)(316002)(54906003)(31686004)(53546011)(83380400001)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R0Y3dHAyRkJJckc5Ni9UdERhQWlSWDZNazRUZHZXNktMYnVQcjczRXVZQnFx?=
 =?utf-8?B?S0NrWHJGc1ZNTFpqaXFiUGtkTE53NFlVZG5mNFptZ0toWExlTXg3V0JHTTNG?=
 =?utf-8?B?cy8zT0gwT2hONnAxY3hNaFNBQTRyVDVqRGxTbnh5Mnd0VkJsQnBRT3FwZUx0?=
 =?utf-8?B?Ym1Ecnd4Ri9WaGtmTjIzZXlUcGNHa1c2dDhZYUlJbmFYS1pSdDU5N0VDQVpT?=
 =?utf-8?B?cHdoUG1wazljUE4zOHAwMW84YkdKM2k1aGxVcGNYSTFWZkY5RGEza3RlS0RL?=
 =?utf-8?B?eGh1dzZqTlU4MUx6SzI2Tjc4b0VhZUNUTUd1SWxwQkxvbzFEQ0NSc2thb1lJ?=
 =?utf-8?B?Q1cvRnRxclo3K1l2b29vdC9HTHU4eXhqeE5CZnB5Z2dWTDkzT0VaQmYzdHEv?=
 =?utf-8?B?amFFY2phVzdHQ1dZS0dzbmVKSzBjTzRMS3YveXVqWDZUZUl5S1lCUWkrSk1J?=
 =?utf-8?B?OEFpMjM3Y1NKWTlVeXVwbFdaMm40ZEFqcFZ1aW5vUmhsTC9tL2FtcjZHY1VZ?=
 =?utf-8?B?eUxOamZKTDNMSEdFZnViZ2M2VGQ4bFk1NHM2N1c0YjVlTmJINDJaUmhIUmV6?=
 =?utf-8?B?WWFCS0psbDN1Nkp3OWtEL0VWTkJ6VnNTWFRWSjdodENGQlh1dU10SklzTHBW?=
 =?utf-8?B?QkNtcDhLMFJaNXBpczlrOHRLbjNGb0lPejhvdVQyTmRRUFRFZW9kY2w3b1FW?=
 =?utf-8?B?NXcvQkhuck0xU0ZmeXp6SlRrbkRqUXVNZytyU0VEUU9NS2lBYnhNN2dyYzU2?=
 =?utf-8?B?QUpVMzFrQWNUWlBEV2xCSm1UR1lVaWFQUmIxMUJyTmFGMDZVMnN2OW5OZGdr?=
 =?utf-8?B?V2hSVFREc2lVSTV3M2JESkU3amFPOHRMbFNkTkRTV25MazMvQm9DT2JhRXF1?=
 =?utf-8?B?bW9DMTdNMFJmUC90K2Vtd2FwTjZtbDFxMzBXT2NtUWVrc2RIQ2tPcDNvTE1S?=
 =?utf-8?B?a1AxN1pNOUMvZHFuYlo4N213Q1gvbE1LMURYVHl5VmlwakswSE9qUmU5V1VP?=
 =?utf-8?B?WmxNb3A3b2VTTjJZUklZTlpBczIxMjNVMDFpZ2dyUE1OaTh6ZFg3b2oyS1dB?=
 =?utf-8?B?bUVjNkZMSCtKZEs3V05nZzZSNEJpTjNhRVVYYVluSnRJWVg0NmszT21GN214?=
 =?utf-8?B?VUYzZUozK1VRY2poZitodDNqaGMvZ01wc3ZCcmZzNCswWE1CSzc4OGxzTVVr?=
 =?utf-8?B?ZFRWYURHdGlxbzYvSElvbkIzQitwNTEra01HRFI5dHNaQml2Nkliam4yTzI4?=
 =?utf-8?B?QzZ0Y25aZSttOGFIbCtIOHhCQVZTSE1OZ3ZWdW9iVzFYcmVPdkFlQlJTUEl4?=
 =?utf-8?B?QUQyUUNuaElybHdBcm1OMGhYS3lBRENXS0NqL3F3cFd3WFV4bDRBQXNab042?=
 =?utf-8?B?SUE1T0pIT3dydGJiZ3haZG1MVGppQnRQQ3Z5UzRBajRDRlJrellWWXZNMjdC?=
 =?utf-8?B?bjEwcVBHQ0luNXFrOFRVRERjeVQ5TzN2UlhBTXNlK0pLMHRIM2c3bnFNZ0V3?=
 =?utf-8?B?YlN5NVY0Zm1RUXlvUEsrRHNNQzVYNVdCSkZFbmNiMWQxdzhxSjc3K29sQXhL?=
 =?utf-8?B?MHcvMlM2NjZ3bGxyNC9ZWTYxMDVyR20ycEQ0Q05ZQzdGMkJPRFdINWc2aHFm?=
 =?utf-8?B?dW5abkhxOXhUeFA2bmp6SzBiL0Y0T1kvMVB4aEdSbm5PVlZMcW5nZUgyRHBz?=
 =?utf-8?B?QmgxZ1kyRXMrSDNFZWdzSFA2SE1NMEp3cXNXL2VMZmtZcDJGQzMybU1nY2Jl?=
 =?utf-8?B?bjZUektSaFRqWVNTTDVXeVZOTlBoWUl5eVV2TllDK2p3TkduQlE0NlpOcmww?=
 =?utf-8?B?Mi9LSTlGNEwzUHlrSFNLMTNMWC9XVHJSMEdDRU15SVdUUkNhMGRsRnhnYXhT?=
 =?utf-8?B?V25rOUtDdWRnRDcxR1BoL1huNUNyYk9uTlZ3VTB5QkJnN0VOU0hUS0hxUVBG?=
 =?utf-8?B?L2tsYzZ3ejRJQXdwTGZZOE9Bd1JQaTF5V0VnYkt3RVdDZEdJN3h1WHpmNEtX?=
 =?utf-8?B?V3BEY3FWUWlFTENPQllxVzFPSjg5L2lUZU9YUzE3T1dOY2FKRUt4KzIvUGJ1?=
 =?utf-8?B?c0NiM3JGeFJIc1ZTeU94bW9lcWxUU0NvTC80K2diY1pWRHJNWldRTFdWZGpl?=
 =?utf-8?Q?fzonyMZrSYmWR2rxqYPIo7B7t?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc717119-cb24-47fd-6d2c-08db346c956e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 17:55:17.2366
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: suwppOAe5X8ELZk5RFpWTed2fzDG84XFaqMYMmtk+fPN8pC9tdkNYeFjv/V5YImHggTmeF/lenHAol3+3xQKlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8209
X-Spam-Status: No, score=-0.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/3/23 12:38, Mario Limonciello wrote:
> A number of platforms are emitting the error:
> ```ccp: unable to access the device: you might be running a broken BIOS.```
> 
> This is expected behavior as CCP is no longer accessible from the PSP's
> PCIe BAR so stop trying to probe CCP for 0x1649.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>   drivers/crypto/ccp/sp-pci.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
> index 084d052fddcc..55411b494d69 100644
> --- a/drivers/crypto/ccp/sp-pci.c
> +++ b/drivers/crypto/ccp/sp-pci.c
> @@ -451,9 +451,9 @@ static const struct pci_device_id sp_pci_table[] = {
>   	{ PCI_VDEVICE(AMD, 0x1468), (kernel_ulong_t)&dev_vdata[2] },
>   	{ PCI_VDEVICE(AMD, 0x1486), (kernel_ulong_t)&dev_vdata[3] },
>   	{ PCI_VDEVICE(AMD, 0x15DF), (kernel_ulong_t)&dev_vdata[4] },
> -	{ PCI_VDEVICE(AMD, 0x1649), (kernel_ulong_t)&dev_vdata[4] },
>   	{ PCI_VDEVICE(AMD, 0x14CA), (kernel_ulong_t)&dev_vdata[5] },
>   	{ PCI_VDEVICE(AMD, 0x15C7), (kernel_ulong_t)&dev_vdata[6] },
> +	{ PCI_VDEVICE(AMD, 0x1649), (kernel_ulong_t)&dev_vdata[6] },
>   	/* Last entry must be zero */
>   	{ 0, }
>   };
