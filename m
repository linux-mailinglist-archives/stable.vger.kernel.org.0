Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A68913DE3A9
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 02:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232686AbhHCAxn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 20:53:43 -0400
Received: from mail-bn8nam11on2115.outbound.protection.outlook.com ([40.107.236.115]:36320
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232311AbhHCAxm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 20:53:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JLbKqYGsbTLs1j16iUQPciIR6AjaDXtvME/Ak5untUJ4egmPogBTBip2BfRQ5PBCt4hL1NDIX8J6u7iI//YHuZyHsEqYyQ888to5KEk/2zWEpd0Zi0LP1CYJhEE2jNGMvkhARfzmBpqKd0iF/BZ1YwDZl8xJlNOfnPKTs1EqlRSxi7sSeRtK92MdNkN14BY8IsupEO1GmQsGHNIjzdTwSVJ9DRufggpZClIKYn8F1dY/nKz48HbV2B0KaJq4swP3KQWL3mThlINds4qtFdx5HALvf+fTMZ37WvIwmdlYDuC1jCT9LUb79/CxwlZnzC5h4NCMMuAPl4AsmKY9xryVaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jByOASg+aE4eik3859cfIhBilRfHMjNMD6DWGOmJbGI=;
 b=J7uCbdz5QgnAavv0QipxuZ9dRXAttiNAYqVKY0sHmtBCmg+gNEf5CSiPgi+hBI+w7BEGgRZT7DYla7ktPPQT0YjTLEkoQyUL59BkwUfFnAEliSOC8wG+ArwiqkMqiENrzBFZVvq2zjilInCptewZv93P9VIM/ongoxbrf2tE3tMtJYLUXFquC0idma2vn5vERdIt+UEAC0uL1N+m0Y4Fi/kY5zEE59uL23rcLubp7vyXBZF0yTS+DZkjXgMmPkB+ZW9rddlXQnn9Pw73VqvfY9Kvh30T0yAia/jvuQ4tnEKnNpc+UBW1NJbchYOpq3I8DpTzc2SNHSOEsGQo95aszA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=concurrent-rt.com; dmarc=pass action=none
 header.from=concurrent-rt.com; dkim=pass header.d=concurrent-rt.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=concurrentrt.onmicrosoft.com; s=selector2-concurrentrt-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jByOASg+aE4eik3859cfIhBilRfHMjNMD6DWGOmJbGI=;
 b=pV7kZV8izxepSASQuSrZlqkpY3V1Qpz8iZHJ4VWY/W4nTTniQrRrIY07btRZ2sZFvol/Dnwqv6J3HX+8Uz5MsP4Qpn/S45/1zZKjA7xo1fsZIIyxF8b2MjaTl+ZnzD8lKSvNAerApX777KzlR2JPgzbBK6XJVA3+R4TtbwEx9f0=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none
 header.from=concurrent-rt.com;
Received: from CY4PR11MB2007.namprd11.prod.outlook.com (2603:10b6:903:30::7)
 by CY4PR1101MB2135.namprd11.prod.outlook.com (2603:10b6:910:1d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.25; Tue, 3 Aug
 2021 00:53:30 +0000
Received: from CY4PR11MB2007.namprd11.prod.outlook.com
 ([fe80::542c:7439:3edd:1a9b]) by CY4PR11MB2007.namprd11.prod.outlook.com
 ([fe80::542c:7439:3edd:1a9b%3]) with mapi id 15.20.4373.026; Tue, 3 Aug 2021
 00:53:29 +0000
Date:   Mon, 2 Aug 2021 20:53:25 -0400
From:   Joe Korty <joe.korty@concurrent-rt.com>
To:     Zhen Lei <thunder.leizhen@huawei.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>,
        Anna-Maria Gleixner <anna-maria@linutronix.de>,
        Mike Galbraith <efault@gmx.de>,
        Sasha Levin <sasha.levin@oracle.com>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4.4 00/11] Fix a potential infinite loop in RT futex-pi
 scenarios
Message-ID: <20210803005325.GA32484@zipoli.concurrent-rt.com>
Reply-To: Joe Korty <joe.korty@concurrent-rt.com>
References: <20210802134624.1934-1-thunder.leizhen@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210802134624.1934-1-thunder.leizhen@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: BN9PR03CA0438.namprd03.prod.outlook.com
 (2603:10b6:408:113::23) To CY4PR11MB2007.namprd11.prod.outlook.com
 (2603:10b6:903:30::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from zipoli.concurrent-rt.com (12.220.59.2) by BN9PR03CA0438.namprd03.prod.outlook.com (2603:10b6:408:113::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.20 via Frontend Transport; Tue, 3 Aug 2021 00:53:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d97ed6d-a665-499b-cbf9-08d956191c0d
X-MS-TrafficTypeDiagnostic: CY4PR1101MB2135:
X-Microsoft-Antispam-PRVS: <CY4PR1101MB2135C15F4BBB86FEF5D4F557A0F09@CY4PR1101MB2135.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I5bbbrv1S6ZTHDvo8hBCW9heva1o9zAwmricMuWzIUnVQyDbfFijFQ5xZBbpUszUCmqvTpEmufkAPXYmD9gvL+UnpvCDQzneC51dipK2DN18ckaYc+Pm2+mzf2GksXRAfvIFOCV0/aPveh4jtkpK8vo2uzH3S13C3CYGCP24CAd7y1iHRiiDjnynkF3rT5R77GKUQUom0b9nmNut2tteSy2Ee/Liwu0VdKUSfIazMf1IqefUcF/ZlCcbES/zG039S4Kl/Jd+bD9nhi67M8Y0bo5kPBA/6m55xFGtT0P+tKnMY4c/zuYwXsneRUuuWlT1SRhFbZiht8Ps0SDZGISSLWSYU09VBj+F+eDCLbY4XEViZ3JWtiEiMB41NSadWB60p8LmM3XzgZxQi+ZjDOjJJBX78GF9jQQenpp2icEu+K9a3YWYVJsZmqU81o7dFz8Y8sn7eHxZp3nOFy2UR14sAa2WHmXIhWbz76T9r8SiTh3A5ri8FP24/w3B4XbKy3TIy9D9YEIScAS4GJtD9s9pqgOakktR4xRzsIDYO00TNelY7Cn+sX4xkiD3QqQRAo/i3ZDrDCz2sHMfW0pJq7eD/3sHXDt48tQf2qrXpM4yLkogB4tU7qjy+MW6oNR/WUJcCyMuopr2Ukj+MQVg4AX92IEfzhSHnxfX5EUy9DsYlw820vvsOck3r2psL/U1HBgQ2KAHPo1Puj+67GQEKtUbow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB2007.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(376002)(346002)(39840400004)(396003)(186003)(26005)(66946007)(54906003)(6666004)(55016002)(8676002)(52116002)(316002)(2906002)(7696005)(478600001)(6916009)(38100700002)(38350700002)(7416002)(86362001)(83380400001)(66556008)(66476007)(956004)(5660300002)(8936002)(44832011)(1076003)(3450700001)(33656002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SNIIadGompjOt5HxXJr4RZYTcB7+Qgs+0nDe55wW6QffgIBoREsuzaZXaRue?=
 =?us-ascii?Q?lc/hSF8YyZ25ntF9IcSWGEpj3Je9BCPAz5incTddjOihAb5w8+PcIQD8iBwl?=
 =?us-ascii?Q?Js9y+hP+d4fdMZCksilRv7xVUVXnVQqBDjTvDRU/OlTBROgnReOgHjXX4JdS?=
 =?us-ascii?Q?QbUCt9nU3JkhbZGRbnN1uSxMcQlACRcYHXipD/fQfyt4cJM0H2Xa8uI9Hww9?=
 =?us-ascii?Q?EDWVqHrokCrL7yOHSuVIhHbTH/xEc0q/LkopSF6ikVnUOD2YyRw4H9I91pBf?=
 =?us-ascii?Q?F5ysYYn3FaiEBnlvZxY76VgM51oT7ufa8KMGrwbetVmc24vEWMmTE3Ndcngs?=
 =?us-ascii?Q?NbYH/dxo49VHrmkLxd8FUezfIbfrmhrlt/HVAxK16VqC85n4ImxOt+KzssWZ?=
 =?us-ascii?Q?vqXkkKHjzqT2ogCyItIw2VGWsMmuoNbrscwaawoUFCIJ17oTkvpPUSeVtIs9?=
 =?us-ascii?Q?Ke5XE0w1H7PsH5CBdn684Eo2fa7f6sTXyAtx+I8qcNo70T6MO3X8xrvcuNZd?=
 =?us-ascii?Q?Tx9pqrep8D6JAxo4JK+A5SQ96dcCbNl5MyJx8jAJaDzge4NVa/i97hpuOWXc?=
 =?us-ascii?Q?/AZB9kcAOrMD963wGZduU9RxEESOEfadZY4rfC2LyoRgwhIBVjefV2Pe5RrC?=
 =?us-ascii?Q?EnHY8+Va39I9ns6TSQmA70jR4cRJm1jdZjnGx9SxiiOz0TpqYbXgqRUTPtll?=
 =?us-ascii?Q?aAE3VmedkIcgCkdz0AmuS3HUdn0BGxW6y3DRZYwF1QjiX+b0cJsCJnXKl1Lk?=
 =?us-ascii?Q?nyJrrshqXvbrzFHBWarSpKN1HctKz7fPSpM4nNwoDHBbYX64fD+lnEIiSdbi?=
 =?us-ascii?Q?DlCU953t8Ox1EigBoJni/6NP+Vy9MxSEtkQYHdQ6blWwqCgORg5dgqdn4Dok?=
 =?us-ascii?Q?TiTgc56p6S3AWXiwlVQt00FuQk+RnMDEsJaAkLSwus/t2SSdTUwbw+GvVLF9?=
 =?us-ascii?Q?xE+m/7+UjnuqbaKlL+q+gkvnd+IEoRCrDERv4k0Nj2FvqztJOFlo5kMnnvEL?=
 =?us-ascii?Q?r4Y11xIBUuMXgVpMR6GANgyFls6vAvI5PfBJKsijEU5h4yU38ElRGwcsl6Lr?=
 =?us-ascii?Q?g6mXkXKmIdMK2Y1fW/mB8dir33+AeVuac9Trd8DogIUx9E7dK4liTLK6FbyC?=
 =?us-ascii?Q?atgAzhdKh01wc9o7R7ZvTcHJFWRhyeRtXpP/NYyDPZZS6CPQ7BkB4u10DK7T?=
 =?us-ascii?Q?evhn+d4dUGSRqiqxsKyyk553tpxHdFuA0uNUI2Uoa2eRfXJ6btB237NaNGgP?=
 =?us-ascii?Q?0vfBPHWUireReze2Ayal3DNuSogMrbwFUmBMAd19DKBPxxP9/VraWS7jmwkI?=
 =?us-ascii?Q?4r0vW4ahNnMUqH3Z37eM0KLD?=
X-OriginatorOrg: concurrent-rt.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d97ed6d-a665-499b-cbf9-08d956191c0d
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB2007.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2021 00:53:29.6492
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 38747689-e6b0-4933-86c0-1116ee3ef93e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: anE41yWK7/gP5iDdnlPGVLnRseJDus27+K29IahGaXGkqTEnrAxuW0ncEmdxqe/Cv7nGfg+07AVoGBvqCdxUOgbh5uT6jj4lnFdvKnLnqTI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2135
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 02, 2021 at 09:46:13PM +0800, Zhen Lei wrote:
> Commit 73d786bd043e "futex: Rework inconsistent rt_mutex/futex_q state"
> mentions that it could cause an infinite loop, and will fix it in the later
> patches:
> bebe5b514345f09 futex: Futex_unlock_pi() determinism
> cfafcd117da0216 futex: Rework futex_lock_pi() to use rt_mutex_*_proxy_lock()
> 
> But at the moment they're not backported. In a single-core environment, the
> probability of triggering is high.
> 
> I also backported commit b4abf91047cf ("rtmutex: Make wait_lock irq safe"),
> it fixes a potential deadlock problem. Although it hasn't actually been
> triggered in our environment at the moment.
> 
> Other patches are used to resolve conflicts or fix problems caused by new
> patches.
> 
> 
> Anna-Maria Gleixner (1):
>   rcu: Update documentation of rcu_read_unlock()
> 
> Mike Galbraith (1):
>   futex: Handle transient "ownerless" rtmutex state correctly
> 
> Peter Zijlstra (6):
>   futex: Cleanup refcounting
>   futex,rt_mutex: Introduce rt_mutex_init_waiter()
>   futex: Pull rt_mutex_futex_unlock() out from under hb->lock
>   futex: Rework futex_lock_pi() to use rt_mutex_*_proxy_lock()
>   futex: Futex_unlock_pi() determinism
>   futex,rt_mutex: Fix rt_mutex_cleanup_proxy_lock()
> 
> Thomas Gleixner (3):
>   futex: Rename free_pi_state() to put_pi_state()
>   rtmutex: Make wait_lock irq safe
>   futex: Avoid freeing an active timer
> 
>  include/linux/rcupdate.h        |   4 +-
>  kernel/futex.c                  | 245 +++++++++++++++++++++-----------
>  kernel/locking/rtmutex.c        | 185 +++++++++++++-----------
>  kernel/locking/rtmutex_common.h |   2 +-
>  4 files changed, 262 insertions(+), 174 deletions(-)


To all concerned,

I have verified that this series of patches, when applied
to 4.4.277, passes the futex-unlock-pi replicator I posted
to lkml on July 19.

  Subject: [BUG] 4.4.262: infinite loop in futex_unlock_pi (EAGAIN loop)

Acked-by: Joe Korty <joe.korty@concurrent-rt.com>

