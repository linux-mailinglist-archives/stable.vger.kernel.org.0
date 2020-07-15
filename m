Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 583492207ED
	for <lists+stable@lfdr.de>; Wed, 15 Jul 2020 10:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729765AbgGOI5r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 04:57:47 -0400
Received: from mail-co1nam11on2076.outbound.protection.outlook.com ([40.107.220.76]:10593
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727930AbgGOI5r (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Jul 2020 04:57:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WAaPX1gwKxLPYN2vPkBhUO6L1MuUBsST7AsjnaIhmjvnPjOv66eOaA0zt45vV5XoW/fvOXaPLOYJnlddMNgTVHcsnDK2XiHYw0lHtrQ+Gb6wZQ6PjXdMfz36xNcW3ekEhFyy84J0Hmf01SXlNIMZrYfWckt5leKjF15fTV+q6hfSTRuzIciKdk8ruEH6nasdDuNj+SA7Q2eC1z0h8D0ZlTukzMsGRX5lxb0kuYqbJOX6QrkU47NiqSuj13o9Z4h/XE1YFxsKHc6qIPp6LQqSLLSkRECYb+IPjpdsX0EHXUusS8oex08zXf5slNjIirD+HW9MWMhb/yyplXPnogE6/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P3AX29zBuUkR5HGzKOk4k5e0hbL5m7eQtx4REtZbhrc=;
 b=M/xeSdOLs0qhZRevp7oxL2xR7ul5LDuuoAfeW/OFwbj/TI53GAyQ3GP9xIM5MD1DY12cVS8TAih3+VG5FGhalA6jLoPltczzHtZNYjamUokJt9YyzKAHktejKPeFp3lMFB52N5pkQHcCF9Z4I2jrfZvBKn8Cf8je88+Z8oPRZogW/ruiKld8c//7zyJL2hO6BZ1tfZhrPOaNFS1E/f3rS/1mP1CB33l+yj2qrw1oRcwSECWbrPj7nSdAVla1uVTIC1D8SZijxO+Lx/ijh+AyDCBbbkvTXqp+MTL6vWHLH4auOVPB8Pze/prZkyp4Byu/Hym+nCYUKRmZzIPcSWS6Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P3AX29zBuUkR5HGzKOk4k5e0hbL5m7eQtx4REtZbhrc=;
 b=m9/DgbMmqr2GysmtKBrVnTFkF4gG8+Z+CUoC2iza8xqDnYtT2YY1T35gaU0lHT9eSucExQ2V7mJGmoQMvDa5srMS1yrR4INYfylpyoaARBrW4lL00Tr9v5ARaH50KvEGujUbW7my1LapnKQe8xFeHcsHnXgasO/8HHY1c6owr+A=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from MN2PR12MB3775.namprd12.prod.outlook.com (2603:10b6:208:159::19)
 by MN2PR12MB4125.namprd12.prod.outlook.com (2603:10b6:208:1d9::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21; Wed, 15 Jul
 2020 08:57:43 +0000
Received: from MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::a16e:8812:b4c0:918d]) by MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::a16e:8812:b4c0:918d%6]) with mapi id 15.20.3195.018; Wed, 15 Jul 2020
 08:57:43 +0000
Subject: Re: [PATCH 1/3] dma-buf/sw_sync: Avoid recursive lock during fence
 signal.
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        dri-devel@lists.freedesktop.org
Cc:     intel-gfx@lists.freedesktop.org,
        Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Gustavo Padovan <gustavo@padovan.org>, stable@vger.kernel.org
References: <20200714200646.14041-1-chris@chris-wilson.co.uk>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <a523ff11-beba-6fa5-743c-ff2336d06cfb@amd.com>
Date:   Wed, 15 Jul 2020 10:57:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
In-Reply-To: <20200714200646.14041-1-chris@chris-wilson.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: AM0PR06CA0073.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::14) To MN2PR12MB3775.namprd12.prod.outlook.com
 (2603:10b6:208:159::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2a02:908:1252:fb60:be8a:bd56:1f94:86e7] (2a02:908:1252:fb60:be8a:bd56:1f94:86e7) by AM0PR06CA0073.eurprd06.prod.outlook.com (2603:10a6:208:fa::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17 via Frontend Transport; Wed, 15 Jul 2020 08:57:42 +0000
X-Originating-IP: [2a02:908:1252:fb60:be8a:bd56:1f94:86e7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c7589e92-3757-4aee-6055-08d8289d2304
X-MS-TrafficTypeDiagnostic: MN2PR12MB4125:
X-Microsoft-Antispam-PRVS: <MN2PR12MB4125ED8B1E0DC67208F3FD63837E0@MN2PR12MB4125.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8BcWbY4/hDxziPax/FdGiEnn7y8YkI5+sx3ia5bW2Q+kYQObieH9vAB7X8RYhFVobs+WwwQXA0m7lqw6S2J5VDYGcsftNwgMCyX+1G1mGAq8Fk4pQLgqSjSqBP0zXq9qJsaFLiwHYkMgDJdI7xxVNqiLjri0z4juh4yiVqOvXOtqg0zeEfaACgWK9RjG2YtyfjXwgrVxEUhbj7l1W7Z/zQ3uf+57PhOJ0bgzWAFrLfzECRl0PVg5fQ3ez1CuH54wRxb8Vjl71uJrVT4eks/8ponvcwMaeEuk730MxxFOG8wK+68vYMNp+AWi5Gux+ydogkfbEdhiqvsKn4XB8gTl0Ru6ZX0uoNQW2neXcMxVb66o8xytog2GwUHrkxLrETa2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3775.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(136003)(39850400004)(346002)(376002)(396003)(16526019)(2616005)(6666004)(36756003)(186003)(66556008)(6486002)(31686004)(4326008)(52116002)(54906003)(316002)(66946007)(5660300002)(66476007)(86362001)(66574015)(8676002)(83380400001)(31696002)(478600001)(8936002)(2906002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 3QLPEfRsn/ZDgEGdbvXa/W4lSih+2clqRLPA49ToLbi4itW26EuutMDGwTqpXvDhJ6ITzp4ttbXmS55J4o2tA8ItIdKzqNwYQJbneKa7YYs9bldNEymHlUHjziUU8dzYpQt8xql0AyPKGVkB45p6/s5f1byQZdXsxvuctWn3ViWdKKK2had7ZO9ZtuEeoQKobNZ7joCjfKK0hKBBIiDqkjf9dYEX8xQfamPZvlqTZ7qwRRM8Cu4wlBgwMTqsezK1BHloOUMUM84Nf8ofvpYjKQ+rFlB3C3iScUbJuiJehdPLINGx4zdK0y619F/Iw8/bbXrM95317mnVN2Wq9ujBgyOOIfiMLleduzbCR0YTwyyRGBLbYtmOfK6hsQkR2lO1p1fQUIVVTryB0EGWaml/QOnlqigobMOxf3j8MHrbkrXYQwIzqxUQuWHvNuseiGPny4Cx6oCC1F2j9fwZJUv8QaKSRfNODhgQubFpLS4dw0166MZVVMDN1mS9kvFoe5KBShAg0i4IWyFP9UO5FkMlkf44CTM1x8/lf9LhU4Qjc7XwV9YY9N53WloxcwF7CHdk
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7589e92-3757-4aee-6055-08d8289d2304
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3775.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2020 08:57:43.8899
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wEdk5LYA/9N6lD7LSZuhGoek0Bp5PWsuF2V4DT1yjdpAjZoUDzTBM1fF75/D6Tvd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4125
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 14.07.20 um 22:06 schrieb Chris Wilson:
> From: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
>
> Calltree:
>    timeline_fence_release
>    drm_sched_entity_wakeup
>    dma_fence_signal_locked
>    sync_timeline_signal
>    sw_sync_ioctl
>
> Releasing the reference to the fence in the fence signal callback
> seems reasonable to me, so this patch avoids the locking issue in
> sw_sync.
>
> d3862e44daa7 ("dma-buf/sw-sync: Fix locking around sync_timeline lists")
> fixed the recursive locking issue but caused an use-after-free. Later
> d3c6dd1fb30d ("dma-buf/sw_sync: Synchronize signal vs syncpt free")
> fixed the use-after-free but reintroduced the recursive locking issue.
>
> In this attempt we avoid the use-after-free still because the release
> function still always locks, and outside of the locking region in the
> signal function we have properly refcounted references.
>
> We furthermore also avoid the recurive lock by making sure that either:
>
> 1) We have a properly refcounted reference, preventing the signal from
>     triggering the release function inside the locked region.
> 2) The refcount was already zero, and hence nobody will be able to trigger
>     the release function from the signal function.
>
> v2: Move dma_fence_signal() into second loop in preparation to moving
> the callback out of the timeline obj->lock.
>
> Fixes: d3c6dd1fb30d ("dma-buf/sw_sync: Synchronize signal vs syncpt free")
> Cc: Sumit Semwal <sumit.semwal@linaro.org>
> Cc: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Gustavo Padovan <gustavo@padovan.org>
> Cc: Christian König <christian.koenig@amd.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>

Looks reasonable to me, but I'm not an expert on this container.

So patch is Acked-by: Christian König <christian.koenig@amd.com>

Regards,
Christian.

> ---
>   drivers/dma-buf/sw_sync.c | 32 ++++++++++++++++++++++----------
>   1 file changed, 22 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/dma-buf/sw_sync.c b/drivers/dma-buf/sw_sync.c
> index 348b3a9170fa..807c82148062 100644
> --- a/drivers/dma-buf/sw_sync.c
> +++ b/drivers/dma-buf/sw_sync.c
> @@ -192,6 +192,7 @@ static const struct dma_fence_ops timeline_fence_ops = {
>   static void sync_timeline_signal(struct sync_timeline *obj, unsigned int inc)
>   {
>   	struct sync_pt *pt, *next;
> +	LIST_HEAD(signal);
>   
>   	trace_sync_timeline(obj);
>   
> @@ -203,21 +204,32 @@ static void sync_timeline_signal(struct sync_timeline *obj, unsigned int inc)
>   		if (!timeline_fence_signaled(&pt->base))
>   			break;
>   
> -		list_del_init(&pt->link);
> -		rb_erase(&pt->node, &obj->pt_tree);
> -
>   		/*
> -		 * A signal callback may release the last reference to this
> -		 * fence, causing it to be freed. That operation has to be
> -		 * last to avoid a use after free inside this loop, and must
> -		 * be after we remove the fence from the timeline in order to
> -		 * prevent deadlocking on timeline->lock inside
> -		 * timeline_fence_release().
> +		 * We need to take a reference to avoid a release during
> +		 * signalling (which can cause a recursive lock of obj->lock).
> +		 * If refcount was already zero, another thread is already
> +		 * taking care of destroying the fence.
>   		 */
> -		dma_fence_signal_locked(&pt->base);
> +		if (!dma_fence_get_rcu(&pt->base))
> +			continue;
> +
> +		list_move_tail(&pt->link, &signal);
> +		rb_erase(&pt->node, &obj->pt_tree);
>   	}
>   
>   	spin_unlock_irq(&obj->lock);
> +
> +	list_for_each_entry_safe(pt, next, &signal, link) {
> +		/*
> +		 * This needs to be cleared before release, otherwise the
> +		 * timeline_fence_release function gets confused about also
> +		 * removing the fence from the pt_tree.
> +		 */
> +		list_del_init(&pt->link);
> +
> +		dma_fence_signal(&pt->base);
> +		dma_fence_put(&pt->base);
> +	}
>   }
>   
>   /**

