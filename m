Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDFB32EF7B
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 16:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbhCEP6Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 10:58:16 -0500
Received: from mail-mw2nam12on2068.outbound.protection.outlook.com ([40.107.244.68]:58967
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230050AbhCEP5o (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 10:57:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GhrGP1diyd2HZDxwwhmeSUhNfmViEKYfEOwKoKMV6hkWLIHSlAHNjGqDbHF6GzmImzR8ABB7U2H81T7ErjvZze9jkDNgscGOgkTEOVFPAXJngrSJa0a2OpITP3Mh+xzMRuyFPZ+NunkFqv1tUojKqCQrOGT3aW4nfomyyJbbBsZzWLpJ4eTX81gSnzVz3cDG4UtmPBKmDl6yJLbzrAOUSNs7BQLjEah1+n1D81ijQrwvkoU26la5ikJ/dCs3wSPF90sDi0LkQ7x+HQKM1h0Q+Z1xiITdXiRIWROnHqyJhukGlnRO+yIPkU9dgpm3r2LLO/ANTNzKGk+zZ327W51+jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=josyCDPm3DqIowbZNlg0byBVTEvYT12ZCIe1G+3g3Xo=;
 b=fZ2Lav/j/19ZkzVSTnCeptdVuPOBwPWIE8gRq6XzQtxg4yGJZ2T+0xb8qPvWIAOJwyW467s52YjFPlnemlOtNWuDBNeLwumBR+izUkntAxLKeQyop7KbwjZBPnI9JD+6BeVOKJtKgtvNtRWeGlYh75ndJyGLSez43BarkKfcZ7qJNrM5X10ZoOuW96jUO6j7xA5s3ooaDnaUunFtFSo7jzesi5lGv/JyxyVL+r/Szm6s0p5JHNqEOOp6wtqeNriC/eV/HPB/KRmS5aWQ8UxauFPetyNK5vsKa1dpQKMNyGDSrdfbqvw49PMKqt18gSPZbXFuXLNif/GLWt1BLhd3yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=josyCDPm3DqIowbZNlg0byBVTEvYT12ZCIe1G+3g3Xo=;
 b=aU1KsSpBlIMGAxHdgpW66mj6S0umSbj684bZJZXNBo8YUkp96f90M56+4Z/mTRj3KmpR3VhwGQ2ErOf+iH+G9eMTaszt834WoF9ehP0bt84JXuQhXi/j+vCt2swkIl7OUisdOpYqDOmgZVTGURJ3xdzIjNTQVryBapuoZUEi580=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1463.namprd12.prod.outlook.com (2603:10b6:910:e::19)
 by CY4PR1201MB0056.namprd12.prod.outlook.com (2603:10b6:910:1c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.28; Fri, 5 Mar
 2021 15:57:42 +0000
Received: from CY4PR12MB1463.namprd12.prod.outlook.com
 ([fe80::6504:7fc4:d02f:77f2]) by CY4PR12MB1463.namprd12.prod.outlook.com
 ([fe80::6504:7fc4:d02f:77f2%3]) with mapi id 15.20.3890.030; Fri, 5 Mar 2021
 15:57:41 +0000
Subject: Re: [PATCH 5.11 079/104] drm/amdgpu: enable only one high prio
 compute queue
To:     "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "Koenig, Christian" <Christian.Koenig@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        "Das, Nirmoy" <Nirmoy.Das@amd.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20210305120903.166929741@linuxfoundation.org>
 <20210305120907.039431314@linuxfoundation.org>
 <23197f54-020a-691c-5733-45ce7e624fec@amd.com>
 <MW3PR12MB44918AD858505706809367F3F7969@MW3PR12MB4491.namprd12.prod.outlook.com>
 <9f12d4c6-35c8-7466-f1bc-bee31957e11b@amd.com>
 <MW3PR12MB4491E72712027DCBB8486E59F7969@MW3PR12MB4491.namprd12.prod.outlook.com>
 <YEJOt6KXCzNb5y+x@sashalap> <1b5bfcb0-3860-bb81-f0ad-91a522beef0a@amd.com>
 <MW3PR12MB4491C79B8F847B982066A3ABF7969@MW3PR12MB4491.namprd12.prod.outlook.com>
From:   Nirmoy <nirmodas@amd.com>
Message-ID: <489d8a9e-1e24-82b8-7738-5e93aa1aabf4@amd.com>
Date:   Fri, 5 Mar 2021 16:57:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <MW3PR12MB4491C79B8F847B982066A3ABF7969@MW3PR12MB4491.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [217.86.122.77]
X-ClientProxiedBy: AM9P193CA0005.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:20b:21e::10) To CY4PR12MB1463.namprd12.prod.outlook.com
 (2603:10b6:910:e::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.178.87] (217.86.122.77) by AM9P193CA0005.EURP193.PROD.OUTLOOK.COM (2603:10a6:20b:21e::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Fri, 5 Mar 2021 15:57:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 986ae6c4-9daf-488e-e3dd-08d8dfef685c
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0056:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR1201MB0056775929B59349DDA736678B969@CY4PR1201MB0056.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gU2hpSmB8e6mPvVqCBRfwf9MgIN8M0wRO/9U+Skcj1dGDJDukf5BZfuFH/jxbcD7Hsy7QL8iLy0DHsVYdWxMGi5oK6AGyqK1wAq3x5bPZEB+LBCwDh/9Yl3JbPtxVyCXeFeuFJECxZCbv+D7jb+K1IFrPLeRSLBtuafbGD0XcwsyVMv1Tgq6Ok4lVJG34JNoCVcDt8c3c984JL+KXYwFSTL+vrKddKPPDVvHkcDBfCMLoqixHmLRmPxM4wlxxh1pHzWF2uhUw8vTGcq6KLNUrIAxqGw/982/oysmmx4MFCglzi3DJPilXo5wNN9nhL6a1nxiczuKTKAOlYYHiwAWUaB118OMFGQhThsutfRcOPsjDzg5z6aNrqsurUQkJeM17+bKIKK3xN+r5hsvu9OelHQGyrJ7aMbdxMTGrsDFwgjF0jJXcJT012eHQqcvR4os+2E4nZ46WaTfW8ArZxsyDItS0zeIWLMaiUQjAA8NA3jJOv1wR/WDRevJi+J7pGduFxAW/8dtMa7mLKOx2Q5RtKJYOI0JfzPy+3SiLxMiliiYHB1l8iMlxJ61Nb+Yw9MSTrxZyfE/623yIBHPT0Yn145oVAbMrWspcw4miJla6gA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1463.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(396003)(376002)(39860400002)(346002)(6636002)(4326008)(26005)(66556008)(6666004)(110136005)(478600001)(66476007)(16526019)(31686004)(54906003)(31696002)(16576012)(8676002)(66946007)(83380400001)(186003)(6486002)(2906002)(52116002)(316002)(5660300002)(956004)(2616005)(53546011)(36756003)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cHlXQys5Y1I5MlBOd3ZOdlZYL1VlMWtCRzFUTkh5OFBjeG42NmcrQW1Yek53?=
 =?utf-8?B?RTkwZVp3RlpESk1LcndxSUl0UkFhc3phZ3luS21PYS9CeEZDdnk1MXA1QUNw?=
 =?utf-8?B?UTNhSkJxZjVEcU5keXBlRmF6YnA5Zzg1VHhsOFJSamFlUTc3aVppeGNtV1c5?=
 =?utf-8?B?ZnRLWDNTNUtyU2JpUzVGKzVWeXVUUXdydlhpbjRzUzkzc2FIVWZ0QW5CZ1Qx?=
 =?utf-8?B?RkxBMlNPV0dReXQyMDRhbW5oalZQb0hOcGtISS9ybEhZaC8rY3FYSGE4NDV1?=
 =?utf-8?B?bHEwekpkL3lVa1M2b0dxRkE1cWc2MEFFRit1RWEzeWZ6WmQ1QlpyRHV6ZHRB?=
 =?utf-8?B?TGZzbGY3UHExS0dTZzYrOWxvTjlrNXJXbU8zVmgvamozU1BJVEVmTVVmazlK?=
 =?utf-8?B?Y1pjQ3R4QTV5TlVkb3Y5K0pXRFdwTXBVMENYcExlRm53OW1Zd2lKQ0RGMzY2?=
 =?utf-8?B?d24rS3NwMU1jQTh2eHlHNUZlTXhhWmtRdldTY3c4ZlVvYmtKYy9vS212dFcz?=
 =?utf-8?B?clNrYTROTHZndGJySi82TU1nSk5iYjYyeGxzNE43OVRRRGdiaytuNWhPZFVm?=
 =?utf-8?B?Sys4ZjVBYzFRbDloTldnMVpwbmZNZ2JTRzkzKy81VXhzeS9WQWUxbkwrSFZh?=
 =?utf-8?B?M0NSR0EwSm5vN2RuVWxKTlRWdnlDVi9PcVUyM2laU3QrMVBHL0JnM3VaY2RZ?=
 =?utf-8?B?N1BtbUpUQ2xCSWR1eUJXMjFKUzRUR1UxWDRGZTRGM24wR2JQYkJEdVg3VkRL?=
 =?utf-8?B?L1lCZ1JKTUEycTdhMFVzSkkxVTdwMlZDSEZxSlBMTjI0TDk3K0o0Nnp2Uk5R?=
 =?utf-8?B?OVMwZFJuOFNWMm1DT3U4QXBRemhBYVBOMnRBY0V3eDRlbVBzOXd3dEZxeDBX?=
 =?utf-8?B?cVpoSUx4TnBWWERWZ1o1TGtkemh0RHV2SXU5YjlRODBja0l2MGttQ1d2SEM4?=
 =?utf-8?B?ekpJVGk3SWpJUEY0Rm9IcnZIMkVKc0Q2dXVrTWJBYWdMOFJmdUU5ZkViV2or?=
 =?utf-8?B?cGtFV0t5NzRsc2pJUEV3RnZxVXJlYXZJWGhZQUdjUjNvZEF6dWY5ZFdKUGpO?=
 =?utf-8?B?MnZvV1lxZzBSd3puS0l0WDdtQUlJYWlHaXZhYnlCVklpVC9idkxOYi9WYWtp?=
 =?utf-8?B?cHR6SUpGS0g5MGFRZkw0Rnc3YXpFUzlVOUtyQ1YvYUl6UlhoWm0yNnNwRUNl?=
 =?utf-8?B?eTFpQy80OVM0RHBxUWtBREtTKy9HUnpqWUNGMmF5MFlvV3hKVGVMdXZmUmNj?=
 =?utf-8?B?STlUVWhpeWJLb3lxOHlkOGVQeGNpNjlCall0ZFhKZ3MwNjRSd0VGeFF1ME53?=
 =?utf-8?B?L0xzaWJNd3AydkVReXk2TkFNS1IrUFJUcDdyc0l6OFpzeWEvdHRlb0NtbG5L?=
 =?utf-8?B?eXJUbFp4MHA5cjN3K2pVNnZmSXZTT0Z0ekw5bXlEWjJEOC9PRHd0R29sekFw?=
 =?utf-8?B?eGR2ZTV5SGJJdlc2LzRaOWFVblMvdVA3WXNzdXdIWHF4Qy9vdVNnSlJIempr?=
 =?utf-8?B?MlJrVldpNlIzZmdiZ3RCSnQ0UmE0Uk5naHZiVklCWVFBQXd1clVubEdsaHNC?=
 =?utf-8?B?bTRNdTQxcUdia3NsYjNvU0RNTERoZU9SYlFLN0pnQzV3YWVrem9ialY3VWYv?=
 =?utf-8?B?RmVoZTNoS2tkWFhROTZLQzg2cTl3dDJxTWxnVTh2aCtlcEc1UHBoOHpBQ0xC?=
 =?utf-8?B?MnpSREkzb0xGemRMVXYwZEJQUTdDeXlTK1RoNlEzMWZxMXhGVHl2eHpPeEMv?=
 =?utf-8?Q?m1u4lCMsopMT4xmcmoc5co4oow7YDNHBTUwQSNf?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 986ae6c4-9daf-488e-e3dd-08d8dfef685c
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1463.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2021 15:57:41.6550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +m1YSGKr/yubFWDtfSE9hrlngBT0RDdd2JntPQSJOVZPWHzqa7c4QmlNMYgcS6zeJ/BR8zwtmEE2xhgpaoTd0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0056
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 3/5/21 4:40 PM, Deucher, Alexander wrote:
> [AMD Public Use]
>
>> -----Original Message-----
>> From: Koenig, Christian <Christian.Koenig@amd.com>
>> Sent: Friday, March 5, 2021 10:35 AM
>> To: Sasha Levin <sashal@kernel.org>; Deucher, Alexander
>> <Alexander.Deucher@amd.com>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>; linux-
>> kernel@vger.kernel.org; stable@vger.kernel.org; Das, Nirmoy
>> <Nirmoy.Das@amd.com>
>> Subject: Re: [PATCH 5.11 079/104] drm/amdgpu: enable only one high prio
>> compute queue
>>
>> Am 05.03.21 um 16:31 schrieb Sasha Levin:
>>> On Fri, Mar 05, 2021 at 03:27:00PM +0000, Deucher, Alexander wrote:
>>>> Not sure if Sasha picked that up or not. Would need to check that. If
>>>> it's not, this patch should be dropped.
>>> Yes, it went in via autosel. I can drop it if it's not needed.
>>>
>> IIRC this patch was created *before* the feature which needs it was merged.
>> So it isn't a bug fix, but rather just a prerequisite for a new feature.
>>
>> Because of this it should only be merged into an older kernel if the new
>> features is back ported as well.
>>
>> Alex do you agree that we can drop it?
> I think so, but I don't remember the exact sequence.  @Das, Nirmoy?


Yes, I agree with Christian. We should not backport it alone.


Nirmoy


>
> Alex
