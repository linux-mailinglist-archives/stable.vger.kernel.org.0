Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA04546CCEE
	for <lists+stable@lfdr.de>; Wed,  8 Dec 2021 06:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232215AbhLHF0f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Dec 2021 00:26:35 -0500
Received: from mail-dm6nam11on2057.outbound.protection.outlook.com ([40.107.223.57]:31201
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231827AbhLHF0e (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Dec 2021 00:26:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m0e+yDTH3FzpSH5rWMe/flblY2eyNAJbwcQuDIbShsfI9UEEq0vm3n9wG/CiibPH92FhiWpTfiKrnITQIHjxIluS5W18O3Q7j86abr9KiVXU/LiiYv0vSjl1w+teHY2DfGpE27YYtLpfvmpIx+OM85Bw6tjs9RCs9cbY2Quag4jd4qByI2njZ9yrKr+T9T8pSIqGrO91POs3kruKVQbuEbPYRTHQfzsS7rfwExy0Kf3qaIL5Xf3CLuaVH0AeRQNL791EGD91qv1fgIrK87IFvfCGJVbpnBma/P43fLHw0ZhRX4He+dz/4yZDey7E0uhrxgEm1A3N40Q1BLhStqFbyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vU0tsCfPJh72Ik8wpG2bUELICSudriBqXqnvef2sVYw=;
 b=Uv/h2iO5RNdTFWljo3xHgjSdJJ3qnmXyHJ4kWvRU+/mOtr1JVjUiGcJBXn12SNo+VHYHSb3rfQ5o9OWNt7QrDoKAr7Ynrlr9lfG8p9ZMCJ9XyZ37cU16QQm1Mj+hH2FXHK3gAYv/A0ujmW4fsXVZ89pHYuScfw86JcdDiD3ekJ9cup6C3MKf/iiahO6uVyybGWa8Gb5z/nspdiA2OWVENipElqJoeXg+MQ/Rr4zd7Tl+tZKMse4oTzQWX3ucaOLLp4+CCFwQkebcUH2ZQclE9hMmAZuhHn4ASCa9ynb6WhJSADOlbGi/c+SEjTCrN1T2AV4sv487ifnRwmonovQ1Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vU0tsCfPJh72Ik8wpG2bUELICSudriBqXqnvef2sVYw=;
 b=ep40GEsa+nwZmxkvbTWnFCCS5suXSJ/4MBlqPRo5+ErTsUK5V9g1i1bHLwBSkv+DPM5iUp6bwOdeGIA9wZT3ng1SjSHpI7c88aDmP0W96c/WOOXapfYPuzwRnn4wq8/Pc1FRmR3L33MSRVfr7AvzEbuYilxsk99ASWagcYjJ1HohVxo2c4tL73/98Ofec3NJaOw1B0HhaV+8cJw6hGGfP+YQaCbO6Q3i1fvBZ8wcFYQXyoGAIY2qpue7nBtomafJ8SGb3lsVtm38Nod4/Fu7wjLsaU7aY9NhHVYTnWmXeGo7ZKjwSzykkJp51uhO4Zdn0D6T8YZ/W3zfcC0YwpZNgQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY4PR12MB1576.namprd12.prod.outlook.com (2603:10b6:910:10::9)
 by CY4PR1201MB0200.namprd12.prod.outlook.com (2603:10b6:910:1d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.11; Wed, 8 Dec
 2021 05:23:01 +0000
Received: from CY4PR12MB1576.namprd12.prod.outlook.com
 ([fe80::24b0:46e7:d3c0:a77b]) by CY4PR12MB1576.namprd12.prod.outlook.com
 ([fe80::24b0:46e7:d3c0:a77b%7]) with mapi id 15.20.4755.022; Wed, 8 Dec 2021
 05:23:01 +0000
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
From:   Sameer Pujar <spujar@nvidia.com>
Message-ID: <73d04377-9898-930b-09db-bb6c4b3eb90a@nvidia.com>
Date:   Wed, 8 Dec 2021 10:52:48 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <3b0de739-7866-3886-be9c-a853c746f8b7@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-ClientProxiedBy: MA1PR01CA0178.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:d::7) To CY4PR12MB1576.namprd12.prod.outlook.com
 (2603:10b6:910:10::9)
MIME-Version: 1.0
Received: from [10.25.102.194] (202.164.25.5) by MA1PR01CA0178.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a01:d::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.16 via Frontend Transport; Wed, 8 Dec 2021 05:22:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7b3ff653-2935-4d53-3bed-08d9ba0acdbb
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0200:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1201MB020053B02767A10BDFD939BDA76F9@CY4PR1201MB0200.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NK2kT/kyEIOzadmsEkUw+0Srmv0EFSId2yNx9bavTQQLBMy6eCttp0cV81RHhqc1TgkFCSrxaOLgoMj7yvB0r8iR5iKaVeSm0Rc+ztBNSUAISuPVIXVDBNWJQpT6of0EAE3jCHizCt3rbNbuyeI+65nHob5WQET/I2BIro5lMROb79GPJfWAu7TZxPRrPfBFESw+G/XFjMI8WpXp21PNsEDo3p/i+qo/MtoPCDlyMJ7pXDo7zSH1f30acXuqq2XjBHdnDxkJ+zawc58Ndy62Ddc93kVkJIHFm3gxwFKQV3Gzc/lAr4UjNwUQgqbc7D2D89ftN4ir+BducfybXCBAcF+GL/1qdZjL3FtPlPLIAkkw8hrtoUVDUkVT7nXGmtnKobEaDSZTHRYMTnhkEe1YqHsVPaunwdKJsFOCLdiZbhbQjyeKiqpVbUhMZEulKA4BcpPtbI30MxdFjTmrYbjRm2e9nMEVaSb316aUwzcS+EsoSWcKbq06uyJU/U3UgN5BuJADlulqHyUMk6BWX5Bz9089eWVMGnPr+PbyrYANondrqJ2FLLQBwvA1QXEGSAxb1vJxqDZFSc5tn6C9p+/35dLRNUlAHelbWkIMzhO6vkwbrjOemxfUqsOwg07v+ya8jggOW/Qixz5ub5rwzo3ode4t5tl6jjBCa67Q2LoYPaCcngoghJRDsAfvcLICbr4dxtiXmOoyI3CrMjk7twKmsU6Z0Jqotx3ycpt0JQ7AXmk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1576.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(31696002)(36756003)(26005)(66556008)(66476007)(7416002)(508600001)(6486002)(4744005)(66946007)(956004)(2616005)(31686004)(86362001)(4326008)(6666004)(186003)(2906002)(8936002)(5660300002)(316002)(16576012)(38100700002)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QkFZZkRhc3E1VkpUQmZpZTFtNzFBaFZGbjd6ektHWW92MGh5bU5BdEdXS3Qx?=
 =?utf-8?B?b1VWcjlVSE5CMUEvNFcyQ29sVE9LdjR0aDRzem16SXpIOGI2SFFmKytWdmtR?=
 =?utf-8?B?NmttMG5vSlBlTkY3aWUxOVFlUmJJd1RtdkNZSHhhVGg0cFRJTlhYVzJUSGhn?=
 =?utf-8?B?RUcrZGNNd1N2cHhzTmUxaC8vS0xKeTN6dDU2ZzJkSWlQaXd5MlpTL1RTL3E4?=
 =?utf-8?B?cXUrNEplNXVFMWNrVU9sNVByOHNkZVl5ZWhxY1ZtTldia1lFQy93eTFqRGp3?=
 =?utf-8?B?OFAwQWlyc0dzRkVXNytvSWFXS2NBZUNZbXhhT29FOWc0ck9HQmEvZWQvc1I5?=
 =?utf-8?B?anMrd2poUDUvc1NXM25ueTFSTXBoNWpqRnNIb1VXc2V0MFRRckN3QUpPcjJr?=
 =?utf-8?B?dnRyK2w4M2RTbkdsU2l5b1kwS29iOUxPUStDY0RVR0dNNTNCWHZDU2VWQXF4?=
 =?utf-8?B?UTRwSEZrRkJ1Tmh5Y0NrM2JrdGluYzNEQjByQ0JVN21heVM3U0tMd3FlUEpz?=
 =?utf-8?B?UkpOM3JtL09aYUJMYUlqK2d3VlA1WXF1aE1ybXEzSUU5QnloZVFiOVVkWXUr?=
 =?utf-8?B?Q3lVSUVYSFhwMm9jb2NrRGZ2TTlWeWVhVm15RDZ4WW1NL0FuN1NsczdOYVJH?=
 =?utf-8?B?WXZFRFJpaE45akI5MHZEbHlEdlZ4Q3FNUStuOGtIblhjZ2xTT1huTnRzTldH?=
 =?utf-8?B?UmR3clRqbWhvelVMc0RZVWpjSENTaHRZN2oydFZER0JtdUQ1RlRHcHIyaUJw?=
 =?utf-8?B?VkhEdElobVBHZ3BpWHc1WjFqMGJmbnVla1ovVnpVYlFRcTJHTVE4VS9JRFQy?=
 =?utf-8?B?VDN1Sitod3VaaGdyR29NdjFIYTR4SGk2aWN0azFTMWRJbmFCbXFFYURpMTZL?=
 =?utf-8?B?K09yTkwvM3lJZkFtMTV5M0R4YkJPb0xrWkp3U3BES3lnRFpWU0QxVWFhNHgy?=
 =?utf-8?B?TkVFdmRGYnZNVkRsT0NwU0lCZTV0QXRhVnJPNitmVmZGKzJHZGFTMjRIMmxQ?=
 =?utf-8?B?VVBuMUVwWmI1WVBaaWtTZ3dHc1FDMmJ1QmQxWFJQdmJSYXJHNzlleDRxSUhi?=
 =?utf-8?B?dDZicHNqaW1PSTYrYXVjZVUxZW5na3VtSVI2WStRTUl2WkZyQXZDNGFBeHhV?=
 =?utf-8?B?MGViaFF2b1hieDJOOU1CQXFjdzFpcVM0SEpVdWFyUXE3d1lGcU9wTDhJalhW?=
 =?utf-8?B?NFJveXFrWmN4SE0yMFVVZ0VNeXQ0K2FzSnk5cTQxTFUrWXhlcE5rZFE4bnlL?=
 =?utf-8?B?Skxmdm55MkNnYWZaR3BtWTdJTnZNNWEvQmJRL091R250d0ZHVnV4RnIyUHcw?=
 =?utf-8?B?MnhVUVZlWHBuT0dIUXZnQWEwUkJUZEt3NEZGYnZwVGR5aXhTMFIxZUJDTUoy?=
 =?utf-8?B?S3hPNWV4M2pTSmVoNlFsNlFNNnpGU3MrVU1mUmdYdTY1Sm1EKzJVQzRZM1Vm?=
 =?utf-8?B?dk9iWU9iYnphM1ovY3RVUCtoN05sWWhlQXE1YXF3eVZTUjh3bmlPVjNMeHpn?=
 =?utf-8?B?emJBeGIxU29meCtpVkd4SHcyS3pQeldJTHJLRFljeVBvK2t1Zit3MVl3WVlt?=
 =?utf-8?B?MUU3UlBZNHFrbEFvanR2VXNkMlNyK1VOK0ViVnRjUW9tamRMM0RQVlNZUTN3?=
 =?utf-8?B?d2NWVnNZam9TWmpsZlZ6NTE0UzFRS1RhWkV5UVRNVFdkYTFiTmFTZktHYVJv?=
 =?utf-8?B?U3ArUXpYUVZDQ2FTZTlueUVHWUVnN3pZbDg4SGRZZVllMnlVa1VWVENQU1Zw?=
 =?utf-8?B?SytDcGtIeEF1N0VNckxZSjVwanNPZnJ3aGtTd0p6aDMvLzIwak9sOFZZYVVv?=
 =?utf-8?B?L3JhN0wyQjRud2dmd0YrLzJpcHkrQ21BRjJFdGJWZEtTbkNOb2E3eVM5R3VY?=
 =?utf-8?B?V0VhNklJMFMzelFvSGE0RzZBSWhmRnZ5K0x4b3pEZVRRa3dpVjFOUmZiUWxO?=
 =?utf-8?B?SGZCNGRndDR1cUJ6UXM4RDRKT0lmVm1acXlsSWRLaUwwZU5nODNtQ04zQ1VV?=
 =?utf-8?B?ZnovZlBoOTd4U2hCY1FXaGc3aGwxaXlFbWI2Z3VDU2xQQ0FDNmc0UjhtRmc2?=
 =?utf-8?B?WmVuTGJIT1VyZjUyYWVOMHpYTGhHeE1PNjRzN2JOMDI1bUx5Ulc5VVh3cng1?=
 =?utf-8?B?aVVOSVhydTFndk9lUWRURC8xMERic3dhR0NtT0JRWElOL21jR1I5UHZ3aExH?=
 =?utf-8?Q?RD9AdggoP6sK2jggcE1zggE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b3ff653-2935-4d53-3bed-08d9ba0acdbb
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1576.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 05:23:01.5294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JCZRrZ+fMAO/TQMtVr1dltWdb8C2G5erAsP3uk5yPzCEJnlnOsnkIQIrkqKh6WQkv4aj0sKWZPpDNkO0h794OQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0200
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/7/2021 11:32 PM, Dmitry Osipenko wrote
> If display is already active, then shared power domain is already
> ungated.

If display is already active, then shared power domain is already 
ungated. HDA reset is already applied during this ungate. In other 
words, HDA would be reset as well when display ungates power-domain.
