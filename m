Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74D1047E232
	for <lists+stable@lfdr.de>; Thu, 23 Dec 2021 12:24:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347817AbhLWLYZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Dec 2021 06:24:25 -0500
Received: from mail-co1nam11on2044.outbound.protection.outlook.com ([40.107.220.44]:4215
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239783AbhLWLYY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Dec 2021 06:24:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eGPOyAlRnge9mQGGswywC2LNiaxWuP8pJmoBz2qCcNv0HuXPrD7yrJ0UTjuFgHY71WalBf5zgW8R+sZNzvbS+eXyKuURPFR7syTxKt3jxJJyNDEXzqtlOulz1Ry5TovDzLbe+cYJB+NKBzcsEgOvCp8TFGDzs5NAZN0Utl6Zv+5BMaQ6cRWZSPe1Ub+wu+F8GIQ1aIJWgMHp1JOmSp8/KMwsfcSvN1+PNkjziCVja1avuOPc68AMZ/z6w+hn1ibSn/qO1jtqRJ14+yGXINnusb+f8QPTRuiMpU9pXf7fTg7JzBrttHHqaQVjsivTGadToDdLf9NXJ0Fr/SP6/CMgIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZuPP2lQzmkMtFMprzOY3iNaSCPBBKwxr6ge8jHJl3SQ=;
 b=cguOcLDyyXwOIlBZguhqzrSUaeM1gL8xeI3OEaakwaUosYkB/hyVwr5+B6gYC4Q8M6K77BgBASFL7YmZO5CZrjIifnrzpXbjrJkZkbIVci/kPMB/tZNMCsNixwuGciML8KY75ZJD9kOCMzEfqQhTAYanaCQ2QIlFb28HD391b3prdLLaaeSh5NQ0ocvbViRRNXjOWK5WPaR2307+B1m7GYuanYWgOo0T9twduFiGhWyNshgi9P1qwY9b7SlGmamWtDY1MTfW8RiKHl/6Ea3tzCIJ6k16WEfiubXLhwy+RiDH990lUAwbDzvjMKBk0gJjxqaijsU1u2py7uSc7pMlyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZuPP2lQzmkMtFMprzOY3iNaSCPBBKwxr6ge8jHJl3SQ=;
 b=qdTjC0a4odhsVzvQOwZzDK9ELa/ACjdBM4O/Vgz/mLG8O/ukiHCTQ7+itkpcSmcYcpRrF9qc1/ZBYjaHrP/3A6xKqoj+XqX4SjKSOeicPlLfjn8BtRxvpwWFZj48ilMffBubNbF5zXt5KYoo1uWDB8J2+pUtxVANR7CfyW/VpqKE/l62hzmrWOGrwwheV97vp75JoEz8Dd0/wg1Axju50WenjOIFlPAVgLe0cQUpFRoBCiZpxiDQhibgrGdTqCu+J7t3NgTG5cuzm73AIzfQt2qSBqixPAFdqzE/38sZVf6q76Xg3udJjcIOOVu3NdXoh/52XYxUaphpJIXXTbzKGw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY4PR12MB1576.namprd12.prod.outlook.com (2603:10b6:910:10::9)
 by CY4PR12MB1751.namprd12.prod.outlook.com (2603:10b6:903:121::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Thu, 23 Dec
 2021 11:24:23 +0000
Received: from CY4PR12MB1576.namprd12.prod.outlook.com
 ([fe80::24b0:46e7:d3c0:a77b]) by CY4PR12MB1576.namprd12.prod.outlook.com
 ([fe80::24b0:46e7:d3c0:a77b%7]) with mapi id 15.20.4801.024; Thu, 23 Dec 2021
 11:24:23 +0000
Subject: Re: [PATCH v3 1/3] ALSA: hda/tegra: Fix Tegra194 HDA reset failure
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Dmitry Osipenko <digetx@gmail.com>, tiwai@suse.com,
        broonie@kernel.org, lgirdwood@gmail.com, robh+dt@kernel.org,
        thierry.reding@gmail.com, perex@perex.cz, jonathanh@nvidia.com,
        mkumard@nvidia.com, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <1640147751-4777-1-git-send-email-spujar@nvidia.com>
 <1640147751-4777-2-git-send-email-spujar@nvidia.com>
 <fb8cf33f-41fb-79c0-3134-524c290e4fc1@gmail.com>
 <f734e48f-dd60-ddb8-510a-3c4f37d8fb52@nvidia.com>
 <YcQiP+MxrlLi+R94@kroah.com>
From:   Sameer Pujar <spujar@nvidia.com>
Message-ID: <84e3ab9d-b351-b4b6-aa34-174725166913@nvidia.com>
Date:   Thu, 23 Dec 2021 16:54:09 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <YcQiP+MxrlLi+R94@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-ClientProxiedBy: MAXPR0101CA0016.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:c::26) To CY4PR12MB1576.namprd12.prod.outlook.com
 (2603:10b6:910:10::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2576212c-9b60-4a2a-5d34-08d9c606c517
X-MS-TrafficTypeDiagnostic: CY4PR12MB1751:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB1751D5E5FA9652666599FBF6A77E9@CY4PR12MB1751.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YPeaQXeHCBvFNvVct0yq/jorJy7WJ5xoTnluW/WBkCr0b15BZqDB7cqaWAlfC/KU1kpe81aIddmob+Gf7+ibm+BZGbAU8/T9fiEUYrlMSkLgZgQUtkN9CmtoffbcKeqh+Bs5qpTg3oEgOiftaHBsFwV8Zkha3Owtyee83AxLYKaFE6S6v11T/8k0QfGJSALeIjZGxO3sPfbqH5Z2B/6T6fMchgwWAKIA1+XXYCBkL9ZQerizLdmsueLUVldc8FtQ2uDYd6kqCA4U0ruF6ZPIGn2e1eBtHmq1Bt98VRd5HJjELm7W3p+8mVEIIbMAdCOYFBVLNdbVfvLD3zABX3OcOfki+li72ifcl27QgIw8Gb/gVrtV5XfqJ87T7BNShFczEA6rEHWOKGpGMc+vneipIiEyf788A5Kx+hCS2HlC/dWnDXHVxVS8LRb65oxLqsrUDOe3uHAZKpxxUVsBDCBP8en3BmBlXtsoJB36/8TY5cFI2dxOfquci+/MqS1FZEWURYNmzdvcNQQZ4TqrBquSV8bRrFiiN+PhuO5/05LGgQPHjOr7YNR87rGU7LcXmX6bpNlMY/M6vhC12N87eCGuC7U+ChD/67W+zlimhd+ux+J+YA+IIEEOUKoNa7swug++8PDqpwQ79dk9BhfCZS8bHAWS7XzMozhmedameHlApKCH7u/+Kk/kBhbjLY/Vu0hXQ4ow0U4aDzOhyjM39aVQk2HQcETGhBFrQHa4ZajRQMNTTiYTBIWA0wPHG0C4u3YPxjEdcjGI0MLUMPQmadAM0qV4BV2DbuVPI8OmwddxCrxKkjh/ZOsKQ1yzVSqc5bOF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1576.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(36756003)(2906002)(6506007)(66556008)(31696002)(31686004)(8936002)(66476007)(8676002)(4326008)(6486002)(26005)(66946007)(316002)(6916009)(83380400001)(186003)(5660300002)(38100700002)(86362001)(7416002)(6512007)(966005)(53546011)(508600001)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SldwM0UyZExwOVo2WVgxdW5JQnRrV1JQK3ZtRzhTOGl6QVNobk9xZFhkZm9E?=
 =?utf-8?B?RlBkcTVVd2gwbW5lSkhocGlBVzdEQ2FxRjU4dTYzRTlOOGJ2UDlUekdGMzd2?=
 =?utf-8?B?NDRMSzRuUStveTd6a00vcEhLbkNOLzdBcnpWdnVEQzdJQnZUNkkzclVJQkMx?=
 =?utf-8?B?MERSMkhiNmIwZk9od3N4bGZjWEw5cUJlUnBTQWUveHZtUCtNcGwxem5oelUx?=
 =?utf-8?B?YnVDZUYzby9tbzhTbXI1OFBmK1ZBSm1CMVQ3UXMvMTVMRlQ2ZTZvRTVqcHVH?=
 =?utf-8?B?aVgxM29LM3EzSnQ4Y3FGd1VBQUppTE9SbzYyUElpRHU0LzZrQWtkSVJPOTZO?=
 =?utf-8?B?cjl0QVFnc3JhQTNIQlV0V3FicGZEZGQ4TWZuajREelRQaEFUSWZiWnZMM0sy?=
 =?utf-8?B?eGdqaGUyM0t2QVpmOWJRRm1HZko0enZQWTFSQS9MRk1ETnc4dVh0cnROUklX?=
 =?utf-8?B?czlXVlZydHE4SmZhZ0w0ZkhuYXJXNHJwSU5RcFZ1VC8xUDNaZUJscnMxanJo?=
 =?utf-8?B?Q05FeGM1OUdRMjRUazZ0cHk0QlFBa3lxZlhYbnF4VDZVbHpEV2Z1akd2VzZk?=
 =?utf-8?B?MEdxM01TaExoMFoyRWNFbk1lSnd4SlB4N2ZFQ0lqa25EYjBoelhyZVJrV2Zj?=
 =?utf-8?B?NnU5R2hOdGVFZi9qeW42UmR3MzFCcFJwaVFCZGFhTjJlM1JWdVpSRVorejE2?=
 =?utf-8?B?SGtSNTFkdWRJYnVXNTBaRmJoWjRYQ01zNEJUdXlwNjJuanZyMlpKQ2hZd1pH?=
 =?utf-8?B?aGJ5aWxNN0J5TW0vVjRXVzBwVm8vUG83ckhjRTVFMld1SHM2bXQ5THdXUHdn?=
 =?utf-8?B?ZGJJK2trSWl6U3NVWTFydjFhdGNva1I3L1pIdkJPU2V1bWRSSlA4d0gvdmt5?=
 =?utf-8?B?dndyQndKTTZsY085dDdpaEVKVkZIVlNTeWhXMlVqYVpMMlJreWxISGJ3R1hy?=
 =?utf-8?B?VVNpanJPVjBLTTF3a2RScWJWWG9qdkFJSEJYTTRSSVBJUEZWaFNmeTMvOXlv?=
 =?utf-8?B?dEc5dXg3TTJUcDRuK1hSeUhONTRNVkxzNG1YNVBvZDJUMUdXVTdjRWE1WllL?=
 =?utf-8?B?TkR2eTQwdDZhTGlYa3Izb1dYNElvYW5KQmh4K2JxcVNNN2FzdmE3TGpWSGNG?=
 =?utf-8?B?Y25UamY2YWdRaUlTMGpGampEUVUrczVndnNuNzBKenZ2NlhKZ0NoWVJxbU5o?=
 =?utf-8?B?QlMzTHoxMHNiQVM5S2s2ODliMVhZalNjNHJlaDFadm5aQll6cXdya1l6dkFU?=
 =?utf-8?B?dU5pZ2dBS2ZyOGJsYUFIdzlIRWhEN1Ewa2trT3JsL2Zwblo5TjRkSVVYWEtB?=
 =?utf-8?B?RXVSU21YaFRqQ25rOTJFZk13ZnF6bHVVRE42ZUovNk5tSGZtb0tOYm9JT3NX?=
 =?utf-8?B?dmtZemlGMTgwanc1ZVJESHRvdDhURGtkQkZ3NnVtS29pRjZqaFlUcFJzWXJ6?=
 =?utf-8?B?K2c0Ky9EL1YxTitCNFl4TlZWTUhaNkc3L0N2ZUNnVlpzZWVJWENTejgzQThh?=
 =?utf-8?B?OG0zd3h4QU1RbDlTUHo4d1k3bGk1ZkhVTk1DRjE3VFR4TmdWeVFSU3dlRUtp?=
 =?utf-8?B?OXFMVTAydzhWZXJjUUtBTm1DYzAvdnM2VUg2eEo5b2xVMnFLUmY2VDRWMU93?=
 =?utf-8?B?dFJXY2x0SkYrSFE0VlA3VklXZmVzcTZzWlVGNVZDVTcvOFRObWJneXB4dGFQ?=
 =?utf-8?B?SlNGV0svaGc3byt4cUt0dll4dzQ3M01vQ0JtK0QrOTJ3Z2d6NUI2NFE1ZGFD?=
 =?utf-8?B?NUpjMEVwYm1Eelh5SkVaLy9uTDU5QTd0cUVoRm1NTVlnRkVwU0Nlbm5nbTdW?=
 =?utf-8?B?RUxJN3MxbW9QaGRaRnFXZDRlZkNEMU5zeEJjVDRjVEtLNFc5K1M0QmtXSU9i?=
 =?utf-8?B?bXkwUGJEVVBCclJGeWJGcjI0NUJGdGgzaWVHYUpSYVFZdytHL1NXSGdmUTM3?=
 =?utf-8?B?eEV1dGppeGdja1A4WTNnMExFbVZTb3dqRzBscmVvUmEzS2ZqbzZ0R0ZKaFFr?=
 =?utf-8?B?TVJUclVCQ0FnZnFyUWZObHFQVkZLZURRMGNzMnJybVVlcHRxSkVtR1BieUlJ?=
 =?utf-8?B?UlhEaFZ6c0ZoMFNsMksyeDZ2QXMyNHpoTjNqYlBxY01Ma1F5VEs5YVlZUkt6?=
 =?utf-8?B?bVFqQjNzaDAyOVhDOW8xUEJsUFUrbjFESzBZQmpFbUVaQmdBTzVyQUZ4cU5I?=
 =?utf-8?Q?RyiLDmVIes0TaD3t2AcyJ4s=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2576212c-9b60-4a2a-5d34-08d9c606c517
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1576.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2021 11:24:23.0351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wIHHtsJAozExGr4qvJFX+h5JYQGhl8YCFtBcFAmldBIPcHNIHw24vCYyoEY0aarvgo8GnWSw1+KbD6xXLm8EZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1751
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/23/2021 12:46 PM, Greg KH wrote:
> On Thu, Dec 23, 2021 at 10:04:19AM +0530, Sameer Pujar wrote:
>>
>> On 12/23/2021 12:10 AM, Dmitry Osipenko wrote:
>>> 22.12.2021 07:35, Sameer Pujar пишет:
>>>> HDA regression is recently reported on Tegra194 based platforms.
>>>> This happens because "hda2codec_2x" reset does not really exist
>>>> in Tegra194 and it causes probe failure. All the HDA based audio
>>>> tests fail at the moment. This underlying issue is exposed by
>>>> commit c045ceb5a145 ("reset: tegra-bpmp: Handle errors in BPMP
>>>> response") which now checks return code of BPMP command response.
>>>> Fix this issue by skipping unavailable reset on Tegra194.
>>>>
>>>> Signed-off-by: Sameer Pujar <spujar@nvidia.com>
>>>> Cc: stable@vger.kernel.org
>>>> Depends-on: 87f0e46e7559 ("ALSA: hda/tegra: Reset hardware")
>>> Is "Depends-on" a valid tag? I can't find it in Documentation/.
>> I do find the usage of the tag in many commits though there is no reference
>> of this in doc. I always thought it would act as a reference when commits
>> get pulled to other branches. If this is not true and it does not mean
>> anything, I will drop this.
> It is not true at all, please read:
>      https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> for how to do this properly.

Thanks Greg for the pointer. I will drop above tag in v4.
