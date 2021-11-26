Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BFFD45EB0B
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 11:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238002AbhKZKK5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 05:10:57 -0500
Received: from mail-bn8nam12on2067.outbound.protection.outlook.com ([40.107.237.67]:19872
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233187AbhKZKI5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Nov 2021 05:08:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=er8DCSH3FPkQVvGDR+rsJO4bbPDxQoxkyY/+zE98U9AshRl1sk//u7Uc1vAVE7i3Hx+feBoOTRu0Ogqh/P94LTG4CnySAzBmjCOiuT//Mtla69HgsKCkFYqdDNiWsNpgzLfchkrKyOaYJhn8hzanvg9SxSDVLKxkR7qrxETXmevfidYlASbm4nXcNXvH2B5/dmQEu6fVU4OCOtNkEGTuRGbpPdAqfIprssVPve1+/OrMYVFo6eQb0TLLm0WjOWDsEzf/CwmQucOlAAPsS+19hX66AUScq0aTFd7uD0SIH2QOFibirK3w09V3BgcJSz0FlUueEl1EU7+fNmb5xpYpBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sFV4iiFp31IusWtDmbqLmFOpQ033Gc2gJy4qfBMbZec=;
 b=nf5nDXtpUybU70Or+Xn32EokRuf8bQlO3HTVE/4uEo+m49991AhMUOiOvIOKNySF7xtH4htCe5f7nJceWAbq8/LZ9dHWmoLqL6cQd8WOHEFJ598qweha0AMSp+OvDQMOL9/bSkdgkURtzd3E+J+Ur23oiXd2NkMwjmiax/KSddktgMXVJHDvLwFvrEu5DMfcfDaTwXS7pNU7puQ0ezqlcWNXlHArDiBhJpRn4jKC5wrWC9Fsu7xSE2hFNaiwRr+LWazUsi0+Y+nIdQR/juhyTQkAGAcUybEE6PrkEBnn3PuZHKLWZJ52ZRApeCRPeFXFh+vWzcAhybPTNPdJaow32A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sFV4iiFp31IusWtDmbqLmFOpQ033Gc2gJy4qfBMbZec=;
 b=ZnkePyQqG90S+S4Qg1HKRrDoHL7uRTf3mloQA7da8MP52xdrB4ASajttbkldfhEk81wqKm+a13WblqhgbClP2g3/r+LFPZ8lbCRKixNGKpfmFUt7zVBL58IpUDy/W2990vILzFNItMeu6XTBBznwfZSQMiE+e2yw1I0zBNCq6g0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MWHPR1201MB0192.namprd12.prod.outlook.com
 (2603:10b6:301:5a::14) by MWHPR12MB1487.namprd12.prod.outlook.com
 (2603:10b6:301:3::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Fri, 26 Nov
 2021 10:05:42 +0000
Received: from MWHPR1201MB0192.namprd12.prod.outlook.com
 ([fe80::2d02:26e7:a2d0:3769]) by MWHPR1201MB0192.namprd12.prod.outlook.com
 ([fe80::2d02:26e7:a2d0:3769%5]) with mapi id 15.20.4713.027; Fri, 26 Nov 2021
 10:05:41 +0000
Subject: Re: [PATCH v4] dma-buf: system_heap: Use 'for_each_sgtable_sg' in
 pages free flow
To:     guangming.cao@mediatek.com, greg@kroah.com
Cc:     Brian.Starkey@arm.com, benjamin.gaignard@linaro.org,
        dri-devel@lists.freedesktop.org, john.stultz@linaro.org,
        labbott@redhat.com, linaro-mm-sig@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mediatek@lists.infradead.org,
        lmark@codeaurora.org, matthias.bgg@gmail.com, robin.murphy@arm.com,
        stable@vger.kernel.org, sumit.semwal@linaro.org,
        wsd_upstream@mediatek.com, kuan-ying.lee@mediatek.com
References: <YaB/JHP/pMbgRJ1O@kroah.com>
 <20211126074904.88388-1-guangming.cao@mediatek.com>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <260c250e-e867-a797-d899-f0b285315c56@amd.com>
Date:   Fri, 26 Nov 2021 11:05:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <20211126074904.88388-1-guangming.cao@mediatek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: AM6PR01CA0066.eurprd01.prod.exchangelabs.com
 (2603:10a6:20b:e0::43) To MWHPR1201MB0192.namprd12.prod.outlook.com
 (2603:10b6:301:5a::14)
MIME-Version: 1.0
Received: from [IPv6:2a02:908:1252:fb60:9698:4ba1:7e0f:eebe] (2a02:908:1252:fb60:9698:4ba1:7e0f:eebe) by AM6PR01CA0066.eurprd01.prod.exchangelabs.com (2603:10a6:20b:e0::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20 via Frontend Transport; Fri, 26 Nov 2021 10:05:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2dae7444-ad3f-4794-b66f-08d9b0c44da2
X-MS-TrafficTypeDiagnostic: MWHPR12MB1487:
X-Microsoft-Antispam-PRVS: <MWHPR12MB148751E349B40D188E8C3A7783639@MWHPR12MB1487.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1186;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EFPMR28fpZK301D/vIdxNdR4IVYzZzWXOQF0a8y2OiDnhnkBmWo6uPmLGNnPFJEBKowT1Eoa9tpLZV0oo5WHWRUEN/aEjNEnslcCzx4NkBzfuaeQknC9MGkneEBzxyEEP2GyGKeZvHatl02dNEONd1lNIO6O1eNLC0lWea2L0eTp+EC1+g1xoQLQYdk3ENLkOffnliVRpiwkVEF9rKFmGi1oPF5s0gyY1XTxcrH1n7tpN3YQo1l1zbmxIe9bRJh9cE5IM1X9x974UuSOVKqzYls8XMjYdnMH04icj0TLx9V0X8T95p0MyCaWnEJoavJ1LOOO79gXqqleLHzst4G1JH3mu30SpefhiQTh06Lz0SvswqtKU37Xq9RqRWRp68jIZ26WVv/TvbMwlKN1VQfsq3Lf3O8ezV0msmiFnNRbTmqXk0HA5h2+fhTazjrS9Lu8mBKuOZ4mAbEpy526uQPQYrkov5Baa7SVecag/7HGpsdMbLUxa29Z6YjMVD/TDedKfDi3DJtfMSrjMEQqOpR7KFpyGNWtHVfYIun8JeLwMzEAIG6gPzAYS3hFqobSDupqdGunTLvUA/UkueY5sF5KLivqnYWUz3+AM7zUku7Q/5ccZ7cND0ig+AOCcTfdl92mW3TR/UNbEP1MwHYXNje9BaEx5rnByqyuxhuFmsGblmTud9ZeGDybCLZIDIRUeuI5G/3GChjMXuYG6gvNTm87JQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1201MB0192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(66574015)(66476007)(66556008)(31686004)(8936002)(36756003)(66946007)(4326008)(2906002)(2616005)(31696002)(86362001)(83380400001)(6486002)(7416002)(316002)(186003)(508600001)(6666004)(8676002)(38100700002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZkRTMkdwSXJHNUlmL2F3emh1OVJ3Qjcrb3hsMmxhWXdMRzBsL3A2eFdIajlM?=
 =?utf-8?B?OVMxcjZhZFZOd3lOQmYwZU82RUhMYzhUdm5YUk40R2w4N25SeThEaTJuUmQy?=
 =?utf-8?B?VW9wR0ZZSHBiMDEvcmpVWVg3UXgzbjRvSlM3ZzJsTVkybk9XbjEyWnF0N0Ju?=
 =?utf-8?B?Q1NiLzdkSllJYmE5a0ZkRkgyRWsvc2RTaitGYmJBTFJ6WCtrdVJmSkVoM2s5?=
 =?utf-8?B?T3kxeS9wbnI5ZlVDVG8wVEpXWnlGa2w3cnZiQUJIZGlCM1NSU3c2T0Vzck1G?=
 =?utf-8?B?anBMUm9tTlR5ZGg1RklMRDZLNERCOUFvOVdhUm9FNHIwRjdmdFBlL2hhd2tS?=
 =?utf-8?B?cU9LcUlveGNKbTgyNUpBMWFDaHU5ZFhmL2ZtR3FMaDI3NmlpVVZWbUtCdUxP?=
 =?utf-8?B?dlVjNEFsd2lKdStPL2JpbjlRcEdEaGJZcFA2Z1RRVldrTkNCZktsNGhXN0F6?=
 =?utf-8?B?SDJXbndqWldGTCtIRzk2dTJpN1pMZUNyRkJvRmFDNjRVN2ZnbUVpbm10MkNi?=
 =?utf-8?B?cjlaQ1R3NFdTMUpnV1RMRW1MSkhKQ3NhUkpid0hFM0Z4ZVpPdCtHdjRkaGdL?=
 =?utf-8?B?UnJqWCsxZGhPM3BuMTdRSExZc1F0em15d1Z2azdMUkY3RnVEcU1RVGZPY3dm?=
 =?utf-8?B?cURxYk5MTTZvQ3Q0UU8yTm5SWEpvVE1IdytYUU9zV3JuY0ppRFd5MnNTNnBX?=
 =?utf-8?B?d2F6ZWRPejNQcldFMjh4emNrS2hjZnpwS0YvbkpNeVA3MGY1SStYbGhCekNJ?=
 =?utf-8?B?U1orUjlXeEFSZ3ZtbHkxRHZNcHFLM0hMeGZmK0F2dlZ1citwMDl6U0dPeDBi?=
 =?utf-8?B?ZUY3eUFLMXdqMmpSVUZxWmZHT21CMFo5UXZ3ZWZLcDhYakpjbEpWa2YxL2lx?=
 =?utf-8?B?T25IWFdINjNpWnZZb1F4N3o4WjBBWGVodVFjWEdsdXM1NGJLN3N6Y3IxK0J4?=
 =?utf-8?B?ckxVUmZLdnoveXNTZ3c3WWxOVUZ4d3F0Sm5tU3M0aVJuSWVYZGl4TVJpQ1dX?=
 =?utf-8?B?bTNaaWVXRUFGSTU3ZDAwMTRRWFEwZnU0ek9VdE00S0JmejVXMW5JeXF4cVZp?=
 =?utf-8?B?c3U1OGRieXpCZk43UDhtOEE1K2JQYjhZbWdhQ0hUOGFFKzEwazJPbkVtLzFH?=
 =?utf-8?B?b05ycjlWN0ZPNCs0MWRxSzRVTXVNV0hLdFBCbkxvcFplbTFnWkpCY0cxSG9W?=
 =?utf-8?B?SHN0MmxBM3VNVnNTbTNlOFhsNTIxTFZpQWlDRk1lTDduR3c0QWZWcE80aU9t?=
 =?utf-8?B?aUdhU1FHdDBUemhuNFp3YkYwOFE0TXM2cldHTGVKZmJjRE5sTTJhWXNuSUpQ?=
 =?utf-8?B?Ukt1MXN6d0Jjck8xemRxTXR4b1J1ZlpxTlZmZTdOVUhMaEk3b29NTDNhOXE2?=
 =?utf-8?B?Wk1Db25lQVNBV0pESTI0NkFRWitiWG5qTmM1K0ZaZi82S0ZaVER1R2hrcTlR?=
 =?utf-8?B?UHZJN2k4YWhhWjRleGE5S2xDZnlIckI5NlYzakVsUFk5RDM5RHJub0NDY2NP?=
 =?utf-8?B?emkzUExVMThHUnJLRko1M094UDhXQ3FRQUROTW8yUVdRSlVPRnUxUXNKbzJq?=
 =?utf-8?B?Q2l0ODNlSjFraFB3RUt3N05pMEJ5bHhwTmRYNmZZMHFrT1JPaFd6Z0pQUTln?=
 =?utf-8?B?bkc5NGF1UTY3cjczQjh0TFdNT05idXJkQUM4YWF2ZnpmVXRQSmdDS2txMWxD?=
 =?utf-8?B?MmlYc2VhRURKVXpYbFFqQ3FFbDR5c01rb3lhYkduY0FlOWxvYTBxN3Q3M05F?=
 =?utf-8?B?eGJmVlcvQ3IrR2IrbDhlVlZ3WE9yQ2VNV05Rbm9zc0ZrY2FPYmp2dUxNZTIw?=
 =?utf-8?B?MmgxL1FFemZWSElEcklFd0hPYWEra1FPdjMzRGZheVhBYktOc3QzZzRzKzdr?=
 =?utf-8?B?QlhPYTFRbGRLVE84WjJwT3ZWcnd5eFY2NnVnREFXNkJUR2ZiZ0FwR1VtVFJZ?=
 =?utf-8?B?eWNMaWdScHJ6S2xlNDYvaTVMMko5eHM3TGRrWURFRURmYmpqbTlTVUM3MlNC?=
 =?utf-8?B?MCsyQkZMb3d4cjFnVzlvelR1UjNoQzhwVmZoMDgyQnNpaGdVcll4U0gwNnVW?=
 =?utf-8?B?NWUxTXFtUTNRRnAvWGdaZGtLNTBGdHJ6QzBPWWRSRWJoKzc4S0FobktGSUZG?=
 =?utf-8?B?VHZCNkNrVGFqcmRIc2xDWVc0OURHbHdVN2thdmhMa1V0VTZLK0w3ckJYcXdQ?=
 =?utf-8?Q?e/2zoPdPB2elJOSL6dTArC4=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2dae7444-ad3f-4794-b66f-08d9b0c44da2
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1201MB0192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2021 10:05:41.7681
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ocvy1BRVmc40ju7yAV1YYMrUaEG0hQTFZM1E7hxBcvG6g4JH84GA9BOZ79TLRIXX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1487
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 26.11.21 um 08:49 schrieb guangming.cao@mediatek.com:
> From: Guangming <Guangming.Cao@mediatek.com>
>
> For previous version, it uses 'sg_table.nent's to traverse sg_table in pages
> free flow.
> However, 'sg_table.nents' is reassigned in 'dma_map_sg', it means the number of
> created entries in the DMA adderess space.
> So, use 'sg_table.nents' in pages free flow will case some pages can't be freed.
>
> Here we should use sg_table.orig_nents to free pages memory, but use the
> sgtable helper 'for each_sgtable_sg'(, instead of the previous rather common
> helper 'for_each_sg' which maybe cause memory leak) is much better.
>
> Fixes: d963ab0f15fb0 ("dma-buf: system_heap: Allocate higher order pages if available")
> Signed-off-by: Guangming <Guangming.Cao@mediatek.com>
> Reviewed-by: Robin Murphy <robin.murphy@arm.com>

Reviewed-by: Christian König <christian.koenig@amd.com>

> Cc: <stable@vger.kernel.org> # 5.11.*
> ---
> v4: Correct commit message
>      1. Cc stable@vger.kernel.org in commit message and add required kernel version.
>      2. Add reviewed-by since patch V2 and V4 are same and V2 is reviewed by Robin.
>      3. There is no new code change in V4.
> V3: Cc stable@vger.kernel.org
>      1. This patch needs to be merged stable branch, add stable@vger.kernel.org
>         in mail list.
>      2. Correct some spelling mistake.
>      3. There is No new code change in V3.
> V2: use 'for_each_sgtable_sg' to 'replece for_each_sg' as suggested by Robin.
>
> ---
>   drivers/dma-buf/heaps/system_heap.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/dma-buf/heaps/system_heap.c b/drivers/dma-buf/heaps/system_heap.c
> index 23a7e74ef966..8660508f3684 100644
> --- a/drivers/dma-buf/heaps/system_heap.c
> +++ b/drivers/dma-buf/heaps/system_heap.c
> @@ -289,7 +289,7 @@ static void system_heap_dma_buf_release(struct dma_buf *dmabuf)
>   	int i;
>   
>   	table = &buffer->sg_table;
> -	for_each_sg(table->sgl, sg, table->nents, i) {
> +	for_each_sgtable_sg(table, sg, i) {
>   		struct page *page = sg_page(sg);
>   
>   		__free_pages(page, compound_order(page));

