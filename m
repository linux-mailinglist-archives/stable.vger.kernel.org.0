Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3A446BA92
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 13:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231542AbhLGMEg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 07:04:36 -0500
Received: from mail-dm6nam11on2049.outbound.protection.outlook.com ([40.107.223.49]:6081
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230444AbhLGMEg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Dec 2021 07:04:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B30/wqYSO0ngN5Zf0UihQ8w0JApgfQnE3NvO9ph0Rt7VuBfeFaevUK7qP1fnGUjw5+COCohBc0PAo2CBVQZ83Hcps0OJNdDCzCJwfQYZhC+FJ1oInuXMwJ/MQOsfmrut/ZrY44BKCh6VAj4WXlQ5bjRjlOkNE+hMk+blQVSflWYTLCRfn+IZq4FLliji3M+BDFhLBVKNEQJ6sUUjD6UUq/0YZJXqP6sYO1mseE7R5DFlXV5xrjSonr41CFQ4taYcDkzJUhuW72Rpw/3D/TQlNiBLlsk6F3FnsF8E0f7XDupihIW06D6i9I0C38xOq0g+fax1Asd9ZkBuZcVMvAfrHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ea67hSn9yMCJ+ZC8mjjbe9py4nMOoYOTdVXxLk+Qy1Y=;
 b=Lt8vseJyjHcTqDSdyEE2KJV1n8z+3SvfzybWcCxkOeF8cpeD/aavVNnKDPpLuZzPSLjO4t9mxkF5yFdLg5lirZ1AemDT9wbO1HRKnwgIxef/ezF8T63MnR1YiDswh2O/l30VkZlZYN8dacSH0yGTUrp7YbVaz1KrAY761iMt0Sw5YZJMMAU5RWVf2LH76LhWA1eCepCClHq+gbmhrJ+dLJnyevnrjKeJ52Tm4a3M45upPXOB/p7NiFwhdAOmcEh56lTwDJ/JmT9vWQv0BUHxsAtzF4l4SdVv8ZJrXXVSESzBpcmeVXJO+8wPLv8xoaOkWDEV9bMANwP5StfgaFsHSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ea67hSn9yMCJ+ZC8mjjbe9py4nMOoYOTdVXxLk+Qy1Y=;
 b=KpURhvNRRgzN1i0LlKpQh/Cm1ZILAtgE5wSEQoCkXVT4iS4TlUm/2emtEOIfzlAOF7Q5BcrnzKsC3JLDAJGqN/jJsy0gFn4uQvCHSrxFCZAKEn7WmlrsFY5AdJJmOYGkN5c+IMT+Tzalz58NQXJ6m6ASuCL+za7HSBlCvTsGqacpDxF4WXw0vqTu7xWtTmCJ1FuWQLWz0XMW4hmWK7/UDW5M2DuDdjdaUIVHBbXmovvSZFdXgBsP1UQsd87bIno9iklOOP072zYrW6F1dSArkUci5mJdoHgK0hojMluGrizREutowJZWA1sB1buA7cQT+F9f5O7KDwMJxmW7Pls2Vw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY4PR12MB1576.namprd12.prod.outlook.com (2603:10b6:910:10::9)
 by CY4PR1201MB0085.namprd12.prod.outlook.com (2603:10b6:910:1c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.11; Tue, 7 Dec
 2021 12:01:03 +0000
Received: from CY4PR12MB1576.namprd12.prod.outlook.com
 ([fe80::24b0:46e7:d3c0:a77b]) by CY4PR12MB1576.namprd12.prod.outlook.com
 ([fe80::24b0:46e7:d3c0:a77b%7]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 12:00:58 +0000
Subject: Re: [PATCH 1/3] ALSA: hda/tegra: Skip reset on BPMP devices
To:     Dmitry Osipenko <digetx@gmail.com>, tiwai@suse.com,
        broonie@kernel.org, lgirdwood@gmail.com, robh+dt@kernel.org,
        thierry.reding@gmail.com, perex@perex.cz
Cc:     jonathanh@nvidia.com, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mohan Kumar <mkumard@nvidia.com>
References: <1638858770-22594-1-git-send-email-spujar@nvidia.com>
 <1638858770-22594-2-git-send-email-spujar@nvidia.com>
 <7742adae-cdbe-a9ea-2cef-f63363298d73@gmail.com>
From:   Sameer Pujar <spujar@nvidia.com>
Message-ID: <8fd704d9-43ce-e34a-a3c0-b48381ef0cd8@nvidia.com>
Date:   Tue, 7 Dec 2021 17:30:44 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <7742adae-cdbe-a9ea-2cef-f63363298d73@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-ClientProxiedBy: MAXPR0101CA0039.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:d::25) To CY4PR12MB1576.namprd12.prod.outlook.com
 (2603:10b6:910:10::9)
MIME-Version: 1.0
Received: from [10.25.102.117] (202.164.25.5) by MAXPR0101CA0039.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:d::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.14 via Frontend Transport; Tue, 7 Dec 2021 12:00:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e3847956-79b7-4d3a-8523-08d9b9793b02
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0085:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1201MB00859CA52D3282BEC192235DA76E9@CY4PR1201MB0085.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pIHmo2/46aOAqD2WlgZLoTCSrmUs4kqukMHJ9kHNf+KiVyPhgV7LbjrExQ9T2qAb+M2Sw7d4A76odexkq/tgTbYEgY0ZM5HNPPJAba5aP0SYZ22DCUbVSoaUKnvSESdk3yAKkRX1s3JL1RruKO2twtclH86bwu1dZMSPRFHTtEtpy07AD0uj7e/ZV0jorf8ezaSFGT/duJiY6d0UFc5PgpMjuYTYDnPsgBqvVt3uGVLN7ADGrKimSFi5Ys1FPmK2rp3hZ73qR2NUboNqe2Ik6lSxWIgAcH/rupfrwfPn7W8kTpeVcXXM7P6tD8nOPYNTJQW20cJ7SNlBTvvcF8kIjJCpgsDyzBtUPownciQosDpEVuiMiPXMgIyWTRfJ9UvqbgxYM/UHdtashW5OFvTt20ICTo1RhqnGJs3meBgpjfUQEqwZqhoNGIfz2Yaz/rCTDXWtinw/WOZCs2EDKJvHP+QJIQqWXKzf56K2SBUYPUSgSFJce583DjfxVzQva5Gk7Pz8JcspVAQEyxTt93sz998fhX/HyM+eiHliyG4ivIG+7WdC44PTIALJlQedOnbuuDnb2HnJcym+exmczgRNzDNdMO3CBr+XmpfZUU+mwgcsXejA1yCaV5M77n9bQuBZoCYxJ+LwkbrhURxR/7M3sY8bb//z5huGouzpEuJGFyWYHOhCBhJ8R/XH5sBtrL5IRtzvWrrEE1eBIbeInbF8WGAmQjZdUMvbQY6Wx3du71I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1576.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(36756003)(31686004)(66556008)(66476007)(107886003)(66946007)(6666004)(2906002)(38100700002)(508600001)(2616005)(31696002)(186003)(5660300002)(53546011)(86362001)(8676002)(8936002)(16576012)(316002)(6486002)(7416002)(956004)(4326008)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QnBPaWpoamRCQkRNMmNOdGFtdFF5ajMrT1NLZDNDWVhDSnVyMkVObzM1QWZi?=
 =?utf-8?B?MFhoVVlJdGpFcG1JdGVNYWNnQjhtNDk4YXQ5WVlJODRWYUN5NW10enphVXZ0?=
 =?utf-8?B?NDkzTWpSZDlveDBTZ2V3R3ovZm02V1h3a0VFdHJUSUJHeWxxeDRMd2k2RnI4?=
 =?utf-8?B?bVljRENvTWRMMGhHU2tTQTZ0STdmdW1xdWY1dlNhTjByTzNmeXE2elRWdklX?=
 =?utf-8?B?QjJPZzFDM3VTb2RLSklxbThlbzFVb3JnOTlSU2hvTnpTc1F4b0c4bWpWZ3FQ?=
 =?utf-8?B?ODVuYW5tL3p6QVRZY2tsSDF2VHczdHZyeDNmd0NuQkJ1VXdqS0Rnak5pVWdv?=
 =?utf-8?B?USs1Sm5DYkYyenJrdEtuWUs0S3dLemJ3REdGRUZpSms4amJDRGhjTjNKYnlx?=
 =?utf-8?B?WmVNVzlnS0Z0TkFuZmIwOC94N2FMa1hmbVNndDZmQkZxb2VxZmZreGxqdW9x?=
 =?utf-8?B?TnVJNlNPRlVFVXZ3VWJPSDBqb0FIRXJUT290QVlkTmxXNVlBMWZpKy9GQUMy?=
 =?utf-8?B?elZVVDZpZkR5b3JXNC81bUdJdk1yWkdpbmJUaVd6b2lnRmh2bkk2TTFQbkNN?=
 =?utf-8?B?ME9TOFQrL09OT28yZ1kwUTViM3BiZFRpK3YvVjJqb0l2THZQeEtYMnNON25Z?=
 =?utf-8?B?Wm54VUZrcDVCZXo1T2s4SzdzaUR1VVZRcTlDa053NnBFaFZTSnN0R2hLdUdu?=
 =?utf-8?B?MWRMK2Jka00xeFBzMGdsbHBsNll1ekxEV3BNNzR6MVdKZ0FMWHp0b0FtQ2s3?=
 =?utf-8?B?NzVubzZMQ0VCaUo0endLQU9nL2FQVEh4WnM4MU9VY1BOZG51TU9hMjRCMXhu?=
 =?utf-8?B?eFYwMTc1eHROd1hmU3N6TkdOcWRyd25hbFNMbVRCZHRDNXRCUlNJY0lrK2NE?=
 =?utf-8?B?emNsM3NDVWVkVkxRbjdrcGhlYVM3WGQ1eDZRdERPd3hnVTFFbUplSGxRR2FY?=
 =?utf-8?B?NkI5VCtVbXV2d2ZSWWhWcDFvNkhpNzNmUEl3cUZkL3ZjSGo5b1hkblFqTTVR?=
 =?utf-8?B?YlNGT1daKzBYTTNJS1JTMzFrNUU5WVpoZGhVUURzc3I0SjNPaENQRFlCZG5M?=
 =?utf-8?B?MXoyb0hqZ0lkeFBrc01RZ1ZFQ3U5ZTZ6M2lCTGx2TTFYWllpOERhL2h4eTh3?=
 =?utf-8?B?UHo0RzgwVGRIeVRVRVF4ZCtlNm9QVjR3cUtTVlFIZ3NOd044ZWtGU3JiSXc2?=
 =?utf-8?B?ZHphODhYMHl6QjlZQzNTeDdMZnY5MmtLWnF5V1haSElKQVV3RW1QUHhQRmda?=
 =?utf-8?B?d1hPRVprTXNaSkZ0K2hTTCtzRThyYkhQM0MvSlA5cDlrMU5sd3g3MGh0RDNP?=
 =?utf-8?B?S3pTdTB0aStBdFN4Y2dBeTlmTnFyNnRmN0NiUjcxRGZ1TjZsQXhRMzJ2UDV5?=
 =?utf-8?B?dTVmQ1BmRFhsYko0YU5ZYTVSTktzK0xONDFmWGpURnY1ZmpVL1hUUFFUbERP?=
 =?utf-8?B?ZHBQc2Z4dU1Kc2hmT2thQks0ME1SNEhnYUNaS2NoWHpReWpQb3AvR1BidjM3?=
 =?utf-8?B?a0duSFRjRnF2dGpmTmVueitDL2JGZTFQSndJUHNwS1ZFOW04TW9zeG9zUFND?=
 =?utf-8?B?WlQyZzk2YXpPU3ZqaWNQdGtqNWREeHpyT1JmUHJ4dVJhSHpqZXFaQmtqSXd1?=
 =?utf-8?B?bmlubDFkTFR1NmJNclNEc3FxMGQwU0xVNzUzQjBMc0R3Wmp3TC9sdkFERmVR?=
 =?utf-8?B?WG0vb0ExdnVRd0NYaEhFeUNKVEU5ZmNtU2RQTVlKVTJsQVN3dWNuNG5RczVU?=
 =?utf-8?B?RjN1b1V6cm9qMHJVM0xDVEpOd0NRSHBnbm9jRyttMkQzNFNUbm1mdjNqY1FR?=
 =?utf-8?B?b1VTUHFvN1RMNlVHMTBpUkpDeWk5NEhsajAxSDR6dTFsZkN0S044RHVyYmsv?=
 =?utf-8?B?Qy9FeURLVGJjaGt3LzF0bU9iNVpMbFRoaUVabnZGZCs0bGZseWxPYnN0SDVC?=
 =?utf-8?B?bHJQRldYYWRPdXFpSWZ2WldObXFZS1RDR2gvU1RPRS9QeG94SXNyWHRIaHU1?=
 =?utf-8?B?VmNLS20zalJ5aDdVanBYTDNkRmJoOENlSEljOVJjb3phaHlJVTdZZ2VRQWxa?=
 =?utf-8?B?eGtNUjNBTlVTMUZyOHFORHE5dXFaekVUNkM5VzJjMWhsOTNLanNiNURCaFBZ?=
 =?utf-8?B?akpHakNmajlORzJFS1NVenNNYWQ0ZHZXUGI5SVUzUkRMNjQ4amVRUzRqQzhJ?=
 =?utf-8?Q?W9dR8930iJ/P8IrSEjW+baQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3847956-79b7-4d3a-8523-08d9b9793b02
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1576.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 12:00:58.3327
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jbbi0EsXdNIlUQaIdM0GTnWOB5pmfc53Nx4kzrenRfwxkN9GN8kXvWfJR3Rk5Q1cl/6bFpJEEVKhxlzYKhG4zQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0085
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/7/2021 3:52 PM, Dmitry Osipenko wrote:
> 07.12.2021 09:32, Sameer Pujar пишет:
>> HDA regression is recently reported on Tegra194 based platforms.
>> This happens because "hda2codec_2x" reset does not really exist
>> in Tegra194 and it causes probe failure. All the HDA based audio
>> tests fail at the moment. This underlying issue is exposed by
>> commit c045ceb5a145 ("reset: tegra-bpmp: Handle errors in BPMP
>> response") which now checks return code of BPMP command response.
>>
>> The failure can be fixed by avoiding above reset in the driver,
>> but the explicit reset is not necessary for Tegra devices which
>> depend on BPMP. On such devices, BPMP ensures reset application
>> during unpowergate calls. Hence skip reset on these devices
>> which is applicable for Tegra186 and later.
> The power domain is shared with the display, AFAICS. The point of reset
> is to bring h/w into predictable state. It doesn't make sense to me to
> skip the reset.

Yes the power-domain is shared with display. As mentioned above, 
explicit reset in driver is not really necessary since BPMP is already 
doing it during unpowergate stage. So the h/w is already ensured to be 
in a good state.
