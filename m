Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3A7146B9B9
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 12:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235528AbhLGLG0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 06:06:26 -0500
Received: from mail-bn8nam12on2060.outbound.protection.outlook.com ([40.107.237.60]:29973
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230293AbhLGLGZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Dec 2021 06:06:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SgAOqIu/yxcjReiOiaou2f0xFgJMH4C5LxH0RqHZDYn5VeiaeBD1SBvwOM/AJwIDGEpFlS5SqWfCkJYE+FwAZ5dfpmtqzOl2z6g6CD+X8PlnCLe9NyYwkk9Sg0jxO+gJ9i+M6eVlYm0ECyIEa5tLrPJSCN9Ms2lAxCDhd/wlAjzsdSH/XNppBTgSSVWYHCKy066xvLM/0bAciVg0sDK2gFHcZNoKax99O4kX/kSrtgt7bpYGi6ScqfDmRFSSiY//D5L84fQ1LjMNTrSkBuIq5irhvHOzVAG7SrQKGmNDe3FVJ69dw3NEezWrSUoWYfVUfM4xVPleOJlTI9jN2Bf70w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QkLoXzt0kzdt1p6sc1w92nYNzDu9gYQCPc3QRut7XSA=;
 b=WgNPoeGLcX/LO+K/ZL03WExHMNbHmsucRg+juIuMbXC1cLsZLSjHl+kz62vYbnPVva9ZM5B4htEd3VUo0MpP+t7ealiQr88X0NC6jAhfB1Vuc7GMWssQysO6A6skEfBfsq722fqfQutkPJrTuJekWKDnI+MDuKp/2sk78MeztII+LqQn5Uv2LJgCEeoHC02CEXim0Ri6xkyqIkT2fYJGL9Goy2g4zufLqfWjUDRyNHfxdQaQk76M5WnGX9YvAEaEZnBgVb7GwA3kj3B1v8zaGyYUL9tpetnREZ8RDkim6Y6/Y0V3LXmc7c9m4M23zvU7/YmN8tizH0TuGFOwuvSqLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QkLoXzt0kzdt1p6sc1w92nYNzDu9gYQCPc3QRut7XSA=;
 b=LYGNN4PPQflJ2TQKX6mrA7vgUiysc5Cg+JKoPqIao8L3E2J9i1mdw/r1NYDK6el10jPNMGBr3g4TX589EYG1Un3X5Z4gBwqUcgMuT8H94r2rfeQGZJaGznkU+RFgDYJsEmQ27ZVqb7jwiiznx4lifivtvivOJDiaHqUCwZWr+YT2MNxspGB3f8ig0ceS51vtkE724I8wlRB5g6jJch8V0+eHjoGf3hXdAOW/XiDlxMYCJcSy9GR9EEvwWJRN7gxphqQyfuHDD/JrzCWPQthlr1euuHqBVKcCNc18yWxR3FYIalk06UaL4xN61kF0dR1yPLT2+bSALeARXiMevnfloA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 CO6PR12MB5428.namprd12.prod.outlook.com (2603:10b6:5:35c::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4755.22; Tue, 7 Dec 2021 11:02:54 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::ecac:528f:e36c:39d0]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::ecac:528f:e36c:39d0%5]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 11:02:54 +0000
Subject: Re: [PATCH 1/3] ALSA: hda/tegra: Skip reset on BPMP devices
To:     Dmitry Osipenko <digetx@gmail.com>,
        Sameer Pujar <spujar@nvidia.com>, tiwai@suse.com,
        broonie@kernel.org, lgirdwood@gmail.com, robh+dt@kernel.org,
        thierry.reding@gmail.com, perex@perex.cz
Cc:     alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <1638858770-22594-1-git-send-email-spujar@nvidia.com>
 <1638858770-22594-2-git-send-email-spujar@nvidia.com>
 <7742adae-cdbe-a9ea-2cef-f63363298d73@gmail.com>
 <2f29f787-7c77-a56e-3b90-0fc452fd1c88@gmail.com>
 <9c21aa0d-b7e6-17b8-cd1a-f12a2b2a1a57@gmail.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <5e50e8a1-5436-b543-f15d-50c5089304e3@nvidia.com>
Date:   Tue, 7 Dec 2021 11:02:45 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <9c21aa0d-b7e6-17b8-cd1a-f12a2b2a1a57@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0374.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18e::19) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
Received: from [10.26.49.14] (195.110.77.193) by LO4P123CA0374.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:18e::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Tue, 7 Dec 2021 11:02:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 883f536b-5145-4116-3d1c-08d9b9711deb
X-MS-TrafficTypeDiagnostic: CO6PR12MB5428:EE_
X-Microsoft-Antispam-PRVS: <CO6PR12MB54288B260FD452BD90D81DFCD96E9@CO6PR12MB5428.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fHn8yMSvgTzoSrqgW7fAkwb0Oz4EUTRhmA9edtA32aNUdvhx+/uAU8GnR/x+IeKBJyTFELCUaZtjglQYhqAx+6pEKDOivQoLllOY9UPZ1wHSPVey/o0Am10MZvYeqkmD8OW4SPo/6gLPGnj0AXwmaGPmzOxAFlqeaxKMi0h8ioZczbkrBOWfhZq52RXA31yHsWAkp+jAAcEaw5FOoqHD+vecvY3L/WqIBCJ6vS/aE0r/jE5VUVW2r2io0i9TRGq+P5vikXZj74+BTaRyoIBmJEk8NFPM059fXXIneHni/kpYkTWewiP0fmsuIkHntMQAzxcG25yZqa5e8M/P7IYKnEamXrOP2ww77WytVYWjx3IUjblN2mo6dbwgUtLPkvFWzSdPY3J5LKWbrc/pmKiF/J0n28bSWdk+/vTj+qPuCp+vaJsMB9X6eeyrfawMeXkCrTi7Uj1Ek425I/g1s81sgNkC8/BGpshzgaYKYv6b/k9GAA74RdaGpXq0Ifa0AudZDjuBulMfEefYzasXxi9CwNtYXgbEkwnfg9qukaovQyV62MFFd6bfgLSCXmfLgLlfVI1Rlmg56oTz6dnawgAdSeEpZ9Z7JYZ8xXzKCfFqsqQQBupezpnxXtvIXGjsZ6LhxVjOUlp09/V5kECGwOSfk3e+3BAjOoOMh1pdd9BHYAHCley0RlJxRwBPCYCWO10DOvHg6z2GgOyVVaq4jMNRY8zyHWkOTqY/8ROtyCXnonsR0mrws2VFc10ojoqaNIJ2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4744005)(2616005)(8936002)(956004)(83380400001)(508600001)(38100700002)(36756003)(7416002)(316002)(8676002)(5660300002)(6486002)(6666004)(53546011)(31686004)(66946007)(31696002)(55236004)(16576012)(186003)(4326008)(66476007)(66556008)(2906002)(110136005)(26005)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VkpIMnd2MmJDUkc0NTJMMkZOVm9XQkc4THZWdTRSSTc3MWxtbEFGZFBoTE5q?=
 =?utf-8?B?emUwMkRkNHBsQkFRL3kvOHhTdnFMZzd6QUVFbGlGRFZMa0NDaDVVN3AyNzdn?=
 =?utf-8?B?RnQ5K2NTY0lLd0h1RGFoUXlSNGZ1bENNVEt2cnFpaDQvelpRbEJJRS9OQ1g4?=
 =?utf-8?B?YnhJU2ZHMHpLUUI0ZXFzVStVczRjektSV3p6S1hXdjZTZVNtaVViUnI0Mm9I?=
 =?utf-8?B?MTJrc3dpNTlQSGZIVU04M0RRZDZpNndQbk04Z2U2b0dqTUk2Q0VpK2RYTmgz?=
 =?utf-8?B?aUQ1U3l2WXR2RnRxMzdqRENYQVhqZVg5R0x2SUQrTEZ4Ry81ckQrRFBLRVQx?=
 =?utf-8?B?SzJYM3RLNnhPSGtSUkZvcEUxUE5HdXVJQTljTnRzdkMvNlg0aG9rMncvajhQ?=
 =?utf-8?B?T1pMbCtINVRLUkJXa2JTZkRvNW90ZWdMZUppQjlFODZsUHdrYXZvOGdEdnRr?=
 =?utf-8?B?YkRWM3FreWl3Y0RpSWtSKzZaVHhzdi9vajBMdnk2MkZHWDFJZklVREZGSGFt?=
 =?utf-8?B?N1M1bEVKbGhVK3ZYMlhQQWhKb3cxVFcrNzZwU0J6SWRmKzhvMGdQS2U3WkFK?=
 =?utf-8?B?OVE3VHl2bVFvTk1TMGVnN3NaMzRRWDJYYis5eTZCaWVzMWxmYnhILzJ5TTF0?=
 =?utf-8?B?MjdFR0xxUm9vQXZnbDhKWUVaU1hEMVNXTjlrSUV4MHpPd3ZEaVRQdXZRWU9q?=
 =?utf-8?B?dkVVeXltQnUwZHJUdHhxNmZzbnA0QXZOL1pXWmI5TGVvYnc0SVRJakh0dkFu?=
 =?utf-8?B?YkxXZWp3bHFORENkM0o3VWxvU1FGYnhIdDU0aW9YNVIybXNDbU5PYkJvRXg4?=
 =?utf-8?B?WS9ZL0hFYXRjdzVPQi8yc3dJTWJ5c2VKbGlNUmhyNzBUcG5NUDV0amxkb1Rm?=
 =?utf-8?B?OC9kUFZJOW5vWHl3VU5YeUlzRlVnNGVTUWNaeTVMYzdoL3dMNTBwYjd1OElG?=
 =?utf-8?B?SEFSUFBJMkZwNXMraVpYRG5pRmNNaUIyN3BpWnlZbUxkZDZMMXZkU2ozeDA5?=
 =?utf-8?B?R09Hb3g5eTREQjYyb1M5aUdPZUpZR3RSaWlBRWtjUk1TWUhldTJoSUlsZFdT?=
 =?utf-8?B?Nk9oVE1Ed2pyYXNZZHdVbnBrQ0RCVk9Sblk0MEhJdk40V2svdG9sczVpV3FL?=
 =?utf-8?B?cEZHamdnclE4bTA3VE0vaFpsY3dUQjZ4K1hvNzZ4d2I1c01GdVJNb0ZXQ1ZX?=
 =?utf-8?B?bmJ2K1JtS1RXT1lIalFLNU5JY0Rkd2JPZmdHbFB4dTNjNWVqQXdEYUhCU0ZL?=
 =?utf-8?B?T0s3d2daTUNRZ2JEL25FZndqV2pjL2JjQ2MyNktKZTN2MFQ1cTBsaWloamhV?=
 =?utf-8?B?OUllektFOTVVVWppV1RWNktZVWRqOFFqWXFZRzFiNEN5QkpNNlVPK0d3d253?=
 =?utf-8?B?N3JVK0ErVlNIRDZwYXNZSUNJeFVkWEZsZXJ5clBub0hQWVkxNTlhRHd2V2x3?=
 =?utf-8?B?SWcwMFZKNFlKcTkrL2RYdjNoNEE0dlE3N1ZOZmc1WjgzY2hBVkVIUHEzTCtV?=
 =?utf-8?B?d3l1NUNZdkFpZlBhMXlENkduRlhsakRDQ0FvbjhFbGIraTJnSkJueUJqbnhG?=
 =?utf-8?B?SUx0RGIyS1JNODk5YUZYZldNMHc0VUU3Q21EVm9FVFB2VHFpcUtKbjZEdXFT?=
 =?utf-8?B?NldycjU1UWEvbGRBNCtMYllDdlBlYTUwT3I1MFlSTmV4TEZIOERWdi90bHpC?=
 =?utf-8?B?Q0xpREdUTHdYcWNHOG9HdmpCVGhheVozc3VtcTVKcW1hU2JDUlczZEZOcGJC?=
 =?utf-8?B?OGVvay9CSlc2UnpiNklRZW85WkZVNHU3aVZUNnFlcU9DN3RydWNWZVYybUY1?=
 =?utf-8?B?alI0SVZ6M1lrb21rb1dwdEswRGRRdmY0bTQxaWxMRzNSejFjdHJTN1RqOWZ5?=
 =?utf-8?B?SjlURXgzdlU1QWl3Ukdmd3JqV0ZMMHhuOXpzMmpLZys5aUlwOGVaNUo5RUFE?=
 =?utf-8?B?aHlSWFJNQWt6VUdaVFozUVdlTld3RzMrUWlBOW1QM0RhaVcvK2lianV2QS9Y?=
 =?utf-8?B?YThVZ3JxQUNMdTFaMXdIV2NCODBzVHVmVGoyS2dLMEJqeVNUT05mbUlQd2xM?=
 =?utf-8?B?bzA0RjJTRUFnQWFNR3N5aUFaMXNSalNPS0RUTXUzdVZFQk5jb1NHaHJMSDJ5?=
 =?utf-8?B?RVpCeEhxa2liajNMUjV4dHIrWEFicDZ6VlFmb2wwR3cvSSswTkhZSUJnblZk?=
 =?utf-8?Q?jvaiui0e+aFRfdvAMpr1Tbg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 883f536b-5145-4116-3d1c-08d9b9711deb
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 11:02:53.9958
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q1ve3wMQ9Mhg3ZiySKTCFX/Cq7tXEUpN6onE9KBgyRbOGizKzDXaFl0UPs1DH6uGmgHsuiQ4/REA0ZZBMw34Sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5428
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 07/12/2021 10:58, Dmitry Osipenko wrote:
> 07.12.2021 13:44, Dmitry Osipenko пишет:
>> 07.12.2021 13:22, Dmitry Osipenko пишет:
>>> 07.12.2021 09:32, Sameer Pujar пишет:
>>>> HDA regression is recently reported on Tegra194 based platforms.
>>>> This happens because "hda2codec_2x" reset does not really exist
>>>> in Tegra194 and it causes probe failure. All the HDA based audio
>>>> tests fail at the moment. This underlying issue is exposed by
>>>> commit c045ceb5a145 ("reset: tegra-bpmp: Handle errors in BPMP
>>>> response") which now checks return code of BPMP command response.
> 
> I see that this BPMP commit already has been reverted. There is no
> problem in this hda_tegra driver at all.

That is temporary until this fix is merged and then we will revert the 
revert.

Jon

-- 
nvpublic
