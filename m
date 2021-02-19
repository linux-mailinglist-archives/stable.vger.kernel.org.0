Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EACD31FC75
	for <lists+stable@lfdr.de>; Fri, 19 Feb 2021 16:57:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbhBSP5W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Feb 2021 10:57:22 -0500
Received: from mail-mw2nam12on2053.outbound.protection.outlook.com ([40.107.244.53]:41568
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229535AbhBSP5V (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Feb 2021 10:57:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RqV+FoPd4WuRylYpQrwpkjWG2WtOvv4G73VdckpdhaWOrm8LW/rE0MhNWtJ3O34z+lC0rmR5aQB09dEXJrfAPiBu4c+SxRAS5z9nfp7HtqiHl1MWgh8rVjOp3dpZ5n8n4qALCPNnvB238YUREIvCiu248z49sjMQKt6bL5WhQJaqNzDilkAj+NSxmMaInpbaJDLMIl/OHnYBgHd+5+zkSgHRNNcUPiFTwUyOAcI5FTBE1g379ofFZfahfon4yfg2EQdoTK1Wy5AxgZLqt2nvuavjrgqBdb+8e166uN5Ez6SUoXkJ4Z+aUr6nbUQhO/wE/4gHB8jdQLWZtj8qjnEG8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dH4Oyt+YNLBNZ2P4NVAu7snhSWhDuyHvEwvccg6frNI=;
 b=ivQ6vJy4ufUnY+U3C8yqr1f89k+OHOsdSczmkwH2Zi4S+K+4Mr7ONAzeROxeinue3NWeqfCG8MX2An6WXqTnbsnOYxA51CbhfTJhx2gZqQNNuCwSHIHdaKk239qKTYlfztmiHJbg3f35LtsePUV0O6DVLZaYGhPNAr3i0QKRpA7bGKqEx5AmTvlKhWDb0RJOnHc5Fiii0WZHCwcPKPDOZl+mB6WB6izz1WjOmxHEt+AsRBqxGMyxI/pY1+470ayodeDzLzSCOVt62D2a8fUWhNOjij/9YPX5UeD+plOaXs0Guh+lHFeViEmvjb3FT50blWY0nv1q0EjOwsr1OfrqvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dH4Oyt+YNLBNZ2P4NVAu7snhSWhDuyHvEwvccg6frNI=;
 b=qutSZSb97WjJ8hVEVc1aJ6Cb6DhIGFK9yq26+94crAvua4tk9F3xpcGayOI/Yk8Y3LZJX0Z8DhFMK5n0yOQjz6oU6Svxh4JXiTwK1iX4rrtBnUxHgITmwfKMrP2M3soBs4Dl3ebTUiY2j2vlwI9LINfBGUskMl+ZWnh6EiizLDA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from MN2PR12MB3775.namprd12.prod.outlook.com (2603:10b6:208:159::19)
 by BL0PR12MB4930.namprd12.prod.outlook.com (2603:10b6:208:1c8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Fri, 19 Feb
 2021 15:56:25 +0000
Received: from MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::c1ff:dcf1:9536:a1f2]) by MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::c1ff:dcf1:9536:a1f2%2]) with mapi id 15.20.3846.038; Fri, 19 Feb 2021
 15:56:25 +0000
Subject: Re: [PATCH] drm/prime: Only call dma_map_sgtable() for devices with
 DMA support
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     Thomas Zimmermann <tzimmermann@suse.de>, daniel@ffwll.ch,
        airlied@linux.ie, maarten.lankhorst@linux.intel.com,
        mripard@kernel.org, sumit.semwal@linaro.org,
        gregkh@linuxfoundation.org, dri-devel@lists.freedesktop.org,
        noralf@tronnes.org, Christoph Hellwig <hch@lst.de>,
        Johan Hovold <johan@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Oliver Neukum <oneukum@suse.com>,
        Felipe Balbi <balbi@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
References: <20210219134014.7775-1-tzimmermann@suse.de>
 <02a45c11-fc73-1e5a-3839-30b080950af8@amd.com>
 <20210219155328.GA1111829@rowland.harvard.edu>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <d2d581fb-ccba-00c9-0a22-b485870256ae@amd.com>
Date:   Fri, 19 Feb 2021 16:56:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210219155328.GA1111829@rowland.harvard.edu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [2a02:908:1252:fb60:eb81:6e66:649f:1820]
X-ClientProxiedBy: AM3PR04CA0139.eurprd04.prod.outlook.com (2603:10a6:207::23)
 To MN2PR12MB3775.namprd12.prod.outlook.com (2603:10b6:208:159::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2a02:908:1252:fb60:eb81:6e66:649f:1820] (2a02:908:1252:fb60:eb81:6e66:649f:1820) by AM3PR04CA0139.eurprd04.prod.outlook.com (2603:10a6:207::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Fri, 19 Feb 2021 15:56:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e7764d59-69aa-4235-6d81-08d8d4eee8d7
X-MS-TrafficTypeDiagnostic: BL0PR12MB4930:
X-Microsoft-Antispam-PRVS: <BL0PR12MB4930AF20E365D4CC2D1B4D7B83849@BL0PR12MB4930.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bl4DVpjF6oqVyQBQKdGc9m5eRu57rfXKlO0eLjpHQzqHOlpsSUC98Ge8DQ3+pJMF95zaKgBM70mrg9r4twL4lamihow7YWABjvD/rZbCU1JAok/a4alpI31uGBfwoReNPRKMDOV1kFsCya5mwJXE7VXq+s0Fb3YAEgj6eDA7i9jAU2NIeDQUjJ+rhGnemKvlQw7iipee5PcR1zB9v+IK9dKVTPtLqwk3LcklwOos2En1GqPKxiftMAeDRN6ACvsCNEQOSBTHrT+j51kZQuG207E2qY5i92DauIT0Dst8XmQMDAJmi1IikXW3pVM2huQW+CPYZXDAuHC+w+11WuW9Y3kjI6RQwThaxbI8BBo32urMFjDJfnQRFDB0gHquhE+XmZny6vG/fldpQ7SRfioJaTwQXSyGOgRp8E0GexlMWtuRveNgPwPvROC0KKUP8gS5IHl+CMhmXaIVhd5WKNNf1926FvRZibFE5OnI3NUbg9x+OdmijK2QIcfZuZyhYWZwjoEt7uJ3jLOQK4nA8qEntitQqlvlsKFTpY3UrvqLMo4Wg9y2eAM8GShQM6m4N/lR+rZHGJXJ1ZicbZLlLokk42TWJ+J929qI2QvkwBZOtG4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3775.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(366004)(136003)(346002)(396003)(36756003)(16526019)(52116002)(66476007)(8676002)(86362001)(4326008)(31696002)(316002)(5660300002)(2906002)(66556008)(7416002)(186003)(83380400001)(6916009)(6486002)(54906003)(66946007)(31686004)(478600001)(2616005)(66574015)(8936002)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Ujd2bjhmNnJRakMzUW1oOGoxemxzdklZSTRFWlJYazNQQVZUc2RZRzk5ZUZq?=
 =?utf-8?B?OWs1SUQ0UHY2dXNXNndmR3JXRmpmMTBYUmRHK3NwN2RmSzljNEFMa0YvUHFq?=
 =?utf-8?B?L1JpeS8rbTg4YUFyUTJwNHB1SjRHWnRyM2tPT1VzZlY2U2p4ZmR2VHdGMGsr?=
 =?utf-8?B?UFpTd3Q0bUpjWUdYN2FyZ2RxN2htbWZCZ2VXaFVZWmhxTGZjVEtxcW9rYUJM?=
 =?utf-8?B?UFdMakdNZmpGT0lha0FuK1preDhaVGdhQ1dMYndIUk9YcEhTQVROci9zMkdN?=
 =?utf-8?B?Slg3LzA1VlRrMVg2bi9keEZFU0FPVjhEMkNNWitkMFhaUGxLc0NjREFLWE5U?=
 =?utf-8?B?d1dyeGlLY25xb2czN1ZTeTNLdEVaQjk4alk4RlcwNndHNEo5b1RqaGx5Y0Ir?=
 =?utf-8?B?VzB0VnNGSzM1aThpTmk5am0yeSsweGR0blhJK1NpM3FwVmhwOHpuVE5RVmJD?=
 =?utf-8?B?T1gxUjNCazY1NE4vVmwyOVVRcmdTTGlLb2FDeFhOSlRPVWxBUGZVdmxvR1pz?=
 =?utf-8?B?cXRDTWJDbjdKSWlkMzRycmdSNzI2WnZMT3VtRU14RnczanRZUkh4dS9Kd2FB?=
 =?utf-8?B?OFJzWVZkUlkvakREUm1XNnAwSm1wdnNYc3BONUEvNzl6NUcrTmJtWG5ETjc1?=
 =?utf-8?B?OTNtNHcrMVZwd1JkKzBDNFlrdUxjdFg2RWhjMUVkOWV3K09Fc1BMSUZlNkhr?=
 =?utf-8?B?aFhaeDBpMmpJWFhjeXFSNTI2UXljOHhJZ0NseWJhUm5pdk1ReUZQeXVNTVQ1?=
 =?utf-8?B?QzZscmZOM2FaR01naXpKRjNUUnlUZHRibkVsTXRQWHJpU2xpallLNnRqWURa?=
 =?utf-8?B?d0NhWlFnQ0dRSU55QTQ0QmF3QWtCVHBZSDFhY25nUGtRT3RxQklHb2xKSWQ1?=
 =?utf-8?B?UTB2ckYwb2w0Skx4a2xhd2ZMcjZtd2JpT3NpOFNZenBRTjA2L243cmhub29I?=
 =?utf-8?B?dnF6K0ZmNWwxbGVwdWdveUJuUVlxaFdaY0YvSW9HaEdXMGRkNGJLbnZlQVE3?=
 =?utf-8?B?c0pCa2x1WGFjWXdKRk01QjVwSEFTdDk3ejllZVdGN05leFB1OGhkaHcwN2lr?=
 =?utf-8?B?YkZTNUxudzRtUnJyVlNCS0pVcXJQb2o2MkZiN0l5OHJaeFUyT3pNOEVUZkxq?=
 =?utf-8?B?ajArTGovcXVoN3ZaeXJsbXVFVktoSjNuTnhXTGhQU3htS3M0M2Nva1Y5d2Ft?=
 =?utf-8?B?czVmRnFLWjVwQWRYZDc2STlseFdIZHM2MWFabzJwYXpjR082MmtBTjd5MDhS?=
 =?utf-8?B?TjUxeFNGeU1uKy9OemFDcGpPQ0FNWnA2aDhnaUl6a2JzR1FPeXcvZ3VoZmM2?=
 =?utf-8?B?OUc1dk9CYTBLYmZDMzZxblAxRHpQSWJRY2tiS08yQ0JmazRxelVKRTRqd3l6?=
 =?utf-8?B?RmJncndvV2hweUU0d05GcGwxS3JkeS9mcmpPbGNkWklSK044KzNOZ0syVjdS?=
 =?utf-8?B?MHhNUzFTR2JXQjVEMU1GbDhaWUVoZXFtR3BSaEdVNFJzZExSRFNSaVViNFZ4?=
 =?utf-8?B?dVpVWGI2Zmg1aFJGY0FXNU9FMFIyWHY0ak1ZSEFlUDhRTE5hYzNZN0N5Z0Vo?=
 =?utf-8?B?QkdkZWZ6dVowVDYyWkd3SmxTdTVRVkJNUmh6cUg0KzBJNkN4cStHTUd1ejJy?=
 =?utf-8?B?SExKOXIyY3JzZUFJMzVMRTEvZFpsSlRGeFdvNXlONTdwSyt1SkJ6eVBMbVUx?=
 =?utf-8?B?cCtGVWRUNjE5THpHMW13MkNLd283OTl1dkw2VVJ2Ym9DdVB0ZG5uZy9pZERT?=
 =?utf-8?B?QXlVSVJwcDRjc1g1WllwZUN0R2I4Lzdyc0xKZkU3U2JNU0tsMWltYXYyQjQr?=
 =?utf-8?B?ZHpyZzRJQzYxZ0h6YlJMQ09Cd2VQdVV5M1BBVjJJbGR4VGZuSnJTSVc1Vm5l?=
 =?utf-8?Q?/bHnWEW/JcQ9p?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7764d59-69aa-4235-6d81-08d8d4eee8d7
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3775.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2021 15:56:25.1449
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hcmr735q5+bVGxHYUTOREFZXHAckMw/sPmrMAHJEN5IX7M4W3ynZheVvd4w1RWpp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4930
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Am 19.02.21 um 16:53 schrieb Alan Stern:
> On Fri, Feb 19, 2021 at 02:45:54PM +0100, Christian König wrote:
>> Well as far as I can see this is a relative clear NAK.
>>
>> When a device can't do DMA and has no DMA mask then why it is requesting an
>> sg-table in the first place?
> This may not be important for your discussion, but I'd like to give an
> answer to the question -- at least, for the case of USB.
>
> A USB device cannot do DMA and has no DMA mask.  Nevertheless, if you
> want to send large amounts of bulk data to/from a USB device then using
> an SG table is often a good way to do it.  The reason is simple: All
> communication with a USB device has to go through a USB host controller,
> and many (though not all) host controllers _can_ do DMA and _do_ have a
> DMA mask.
>
> The USB mass-storage and uas drivers in particular make heavy use of
> this mechanism.

Yeah, I was assuming something like that would work.

But in this case the USB device should give the host controllers device 
structure to the dma_buf_attach function so that the sg_table can be 
filled in with DMA addresses properly.

Regards,
Christian.

>
> Alan Stern

