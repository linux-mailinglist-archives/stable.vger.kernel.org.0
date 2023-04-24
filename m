Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3606F6EC604
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 08:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbjDXGGb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 02:06:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbjDXGGE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 02:06:04 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2055.outbound.protection.outlook.com [40.107.92.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 114885594;
        Sun, 23 Apr 2023 23:04:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oUxSvIuRjRc0U558VdYANgJoQIlK0dYxyc5d5lpjBJBeXKnxtji4I3zb1ynObgzUgPvRDz9QoscUW1MegOB2AaGui6Sko0SjbR9/xW9NyyfdC+SbZX9RGZ5GNSwmX69MXTgTye4lGiujP8lLqDpMkQNeRDFmGmSCiO4S9x99JqrFQF80Hxqq+wWgXwjLujzgfMes0/2qNrLUTRRjaTaUGKEh5eTEhSscSikguKkS6QzpLPTW7tA7IxmmdN2zbEXOhR2zT5VHQxL6ccPmRRQm1ChZV0ZLRVqo+K40LxvxIWGSaZGKkZ7SVGPSsHq9eRoJ3fN0ZCkEYVoJNcDmUkIvZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+RX7jcVdaJ1AqU0nRbwKfXGiCo9g45VqRfNsd/h7K5U=;
 b=bTUuqYG0JyVBaSRFUFRVfxIwfVoj+J3uf4PS0rLfq36fOKtDUwGTtzvAGgD5HXn7YiYqwDSgm0eAiIpO2kkFmhMk7k+xJiTwX79PzlsffG+ytc5PPOqoYHpCJ70HnvcCC6TofDYQ2N0Cqan1HUR8/F+jPlmYf9Mm3Hf5m9B9IDqtbg1nzTx2M/iC0C6yQ4we9X3r3IvYZAELRCthcfOfj4wcjowipCe7DtLthMTju+BTH9GyJnLRNU/4DhdLBJhBRoJTV6o+cDHsyxNEohTuhByBFNLg5xjgN6yRiak4r/HADIGkZ0D2lzdqucCCjSJo6o2pXVC2EYeAN5iC85MP/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+RX7jcVdaJ1AqU0nRbwKfXGiCo9g45VqRfNsd/h7K5U=;
 b=MvgIyewF0Pqi7LUYRbFbZCaohyliifjMfKBsM0lztY63q2qk62m9NksxEeqOkUiZ3WDRSgJdKK5idt8HmloeTm/KhWmP5e9cEYOet8piJniYlew1d/YHpvOLrkLj+u4s4odkohi0h5kWBu19h8jrMKeCerml9lalhuOFgIO11Sc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BY5PR12MB3876.namprd12.prod.outlook.com (2603:10b6:a03:1a7::26)
 by IA1PR12MB8238.namprd12.prod.outlook.com (2603:10b6:208:3f9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.32; Mon, 24 Apr
 2023 06:03:34 +0000
Received: from BY5PR12MB3876.namprd12.prod.outlook.com
 ([fe80::1651:c184:fc1:d4c9]) by BY5PR12MB3876.namprd12.prod.outlook.com
 ([fe80::1651:c184:fc1:d4c9%5]) with mapi id 15.20.6319.033; Mon, 24 Apr 2023
 06:03:34 +0000
Date:   Mon, 24 Apr 2023 11:33:17 +0530
From:   Wyes Karny <wyes.karny@amd.com>
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     ray.huang@amd.com, viresh.kumar@linaro.org, mingo@redhat.com,
        peterz@infradead.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
        bristot@redhat.com, vschneid@redhat.com, joel@joelfernandes.org,
        gautham.shenoy@amd.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] cpufreq/schedutil: Add fast_switch callback check
Message-ID: <ZEYbpSnQYJGUyKEI@BLR-5CG13462PL.amd.com>
References: <20230410095045.14872-1-wyes.karny@amd.com>
 <20230410095250.14908-1-wyes.karny@amd.com>
 <CAJZ5v0jH4uatAR7HiGY_MYASOcdwxvwkUZaMCHcznd-0idLCUA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJZ5v0jH4uatAR7HiGY_MYASOcdwxvwkUZaMCHcznd-0idLCUA@mail.gmail.com>
X-ClientProxiedBy: PN2PR01CA0226.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:eb::9) To BY5PR12MB3876.namprd12.prod.outlook.com
 (2603:10b6:a03:1a7::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR12MB3876:EE_|IA1PR12MB8238:EE_
X-MS-Office365-Filtering-Correlation-Id: fb48c9ef-b963-4b65-7db4-08db4489a2c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IfPnOM07NJyBjoSuTWHPC46tmRlL5qySTSznlGa2Pb3g4ZlZt1FGlJRJmbIVUKclRRhsMf3figDGv26P3D+I2L9pdjtpGPyX8IlHxwPX4acv3b1ahP13+nUqnJCiAI4b6fYul9xP3jwY3typ+ZZtx3Rzv0kI0lo92pTQYq+9BFKnYCpisL3jUiu46U1C8tjaX3t1c/YNCMGPEh1XYQGcz/8Do0qNAG6vBd08jr4i1Qn2xjRIP2KdNn/b+TvYiDShT9s/ew1OPnIpYL7tCccKSSSQSjhkLfPQnawY5mAu32s9HJEpOuyUWjwH8tKF4HeChoZODTqG/7rtRq0pe9N8c4wGWKf0xgCymadt/ttGxyB2hjkbsIdAM1X2m6kXLAUxHEqT2Pkxa9y+KfcRYLiRRK75sdDKY2EsM59J7csGGQ+1Tk2HQLXEzp3XHjd9tykStXb7dm5xWqDlFHpxI68m6vC370zWtzeFZdeunuJfbrdZaplFSM5xGcbn5fb+OPAlj0aenhmQqoLAAxoeeQrLZDFM1wvT3RmNNhAS0YMqax2pn2Ea2whJFU80A2sGXM6P2I7Qg1xE+t1YS6Nba9Yc2XgYP3oKJMJd8aE195SmZKA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB3876.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(39860400002)(376002)(366004)(346002)(451199021)(53546011)(6506007)(26005)(6512007)(83380400001)(186003)(38100700002)(66946007)(478600001)(86362001)(6916009)(66556008)(66476007)(8936002)(8676002)(7416002)(44832011)(5660300002)(6486002)(66899021)(41300700001)(2906002)(4326008)(6666004)(316002)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZE4zeEJrRXdld2lGMXFiUkpiVDBXNDEzeW5xRHo5Y1ZlYVhvcno5RWdoYjR1?=
 =?utf-8?B?Myt6bWV6bWMrcmZTNUZsalBrS1JwVzRrd0RlQUFheUlIWWxwS2RLOVdMTTV4?=
 =?utf-8?B?cE9YZFlnME0rL041MW9ZdDZ2cjNTdGhjNzBoOFFDamw5cG9QR2xiYW9Pc2li?=
 =?utf-8?B?T2VOSCtRWEZuWlMzRUE4S0hFcUFwR255Zm5Pakh4ZDJCS0gySHFtdy9kcndS?=
 =?utf-8?B?MHRlaDJrbXZQQWx2clE4Y3V6eDFXTlN0dzFiYTlIeXFpTCtmUnZIOCszYmtu?=
 =?utf-8?B?VHk2ODhoWGlLd2g0YStObU1yNHZucXd5L0NuMWVKT3JkQ3JrNGlxcStrd1Nv?=
 =?utf-8?B?dlZrbXRRa1Q1S0w3a203M3NOK0FSWEZObWh6SHo2Rzh6eWNpQStOVzVFTnZh?=
 =?utf-8?B?T1pTVCs5MGluOW55M2NBT3hpU2RHNnQvdHo1Ym9lSWVSMExRRTZrZXJCSVZa?=
 =?utf-8?B?S3N6ek1RNHhMMEJjaEU1Rmd4OS84OWF5SnJLU2FyTVZJTk01cC83SmZ1eFRa?=
 =?utf-8?B?SUhkVTBsVjZtOEk5UVVsQmZpc1dlOXdVZ2VVZ00wWGwyL0xsZnh0SGpSWnA0?=
 =?utf-8?B?azNZK0Z5MEF2VG9PT1JKY243cjV1UXZTTTlSdkNLYzZIYVpaVVh0anczelVt?=
 =?utf-8?B?RytoYXNtQWM3RGhQcVVCd25Tc28vczAvV2tNVG85Q0wrQ0xpZnY4UExMYmpu?=
 =?utf-8?B?bE13QklpcnhsNlhoV1pPZlkzU3FMaWI4cG55d0o0bDF2WWd0TmtpQ2dkQlp5?=
 =?utf-8?B?RFF5dWMrWHE0M2hETEVZS3AvbkkzRlhQU2tEUStQRXZ6Q2FodHZFREExak1s?=
 =?utf-8?B?VlZvVlorU1dGYjNXRmNPUTdIeCt5OVQrK2c5b01ZaW5velBmZS96Z1ZieGdt?=
 =?utf-8?B?emxlUVBDRFdNMU1sZWdlQVpidmhGZkNERENVcFJxN2pIQi9Kc2pFUlRvdlFt?=
 =?utf-8?B?Q3RNbWRNdXo2djIxLzJieDdZUGNFQU80b2FHTmg0Y2t3YStrblo0WDJYZEgw?=
 =?utf-8?B?dTFqMHFNY3VxRjhMRThQb0hybHdNSjZaMGZ1Q1V3S1JHYVJ1YWswZmFVKy8z?=
 =?utf-8?B?QUE2eTZFdkVLc2FDOEh4YTJ0VkhaT3hQMitKcW9UY0RqYjk4d0syYjZKOTA4?=
 =?utf-8?B?K2VTRUtSakVxTm8yaXI0MU5BcU5RTFhCUjdkaC9kRHloZVhCOUN5QmcyUFRM?=
 =?utf-8?B?NG5IRmE0YnM0bWVVZExaU1BXaGx6SGF3Q2tuRnIyZzhmbFk5YWhxazd2Z2tM?=
 =?utf-8?B?WjA4Tm53cklSem1Sdm1UMnpsRHFHQXZ2Q1VLRWI0QVJuY214YXY5ZmY4TWZO?=
 =?utf-8?B?bjIvd2ZrTEEyTUZqQ0Q3My9ORk8zR0xSNXFMU2FPK2VSSWY4YnhKOVZ3Z0lo?=
 =?utf-8?B?Q3FmeUt6Nlo0M0FmMHdxRFlCbGdsSVN6akUweWVqVU9UMEw2dkwvenovRzYr?=
 =?utf-8?B?WjJhU3R6Z1RuNGNtY2tCVXpINXlMYXJ0N1EwMEUyQXNzU1Uvb0hLbFlPUVlG?=
 =?utf-8?B?bFFReG1PckhicjBrSVB2b0xMTUY5K3lYYm5WOGtnVnMrZjU5WXJ4VjhzV1BN?=
 =?utf-8?B?YU9hNGVmQ2psbDlFdHNqYlRaWHVMaUZaSUsrSy81Q2JMS2hyc2t0RUppcERF?=
 =?utf-8?B?bnFHZ0NRVFpWZ2FWa3FHSHpIdzBCZzNQYUhzMThHaTEyUk5sL3hzOEo0QXVP?=
 =?utf-8?B?SGI4Z2NrVy9INWs1TWtsV091WXlwZVdCQmJIbzV4dkx0akJaYzJ0SVpKOGhT?=
 =?utf-8?B?b1dkV05Ob0R5NktNZ1IzeTN1UnBrMGtzd2RnUE55M0o0dzAxQzJ6RzNFSklJ?=
 =?utf-8?B?eW1TaWRqSTBDTnVtZTBrUU4zdzU4SndDUmxOWHBuaGZ0WEtJSnF0cDF1dzlR?=
 =?utf-8?B?SDhIMDN2TTh6Zm04SGRVdDdMZ1o5aFRrQjJVWm1DY1ZubXpFbXp2Z081eS9p?=
 =?utf-8?B?RlRPcFhZT1F1Unl4Z0VvcjVmYTc3cEM1YkR0QkFLY3YvdFJlQ0hjRXlhYjNk?=
 =?utf-8?B?d1dXMHBmNnprbkhjOVBzdmFsYWRiamZ3TTNJT2Z2UFdueS9MVXVBTDhvSzdC?=
 =?utf-8?B?UnpSUmtYdXZvZ0RlTDRFSjZQWllTSlVyeVpPM3lJRlZMT3ZDbEUzdDh1dE4y?=
 =?utf-8?Q?VbmuhrEpBEpANgjUDQ1yrBCaI?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb48c9ef-b963-4b65-7db4-08db4489a2c9
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB3876.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2023 06:03:34.0981
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w9/HIRXlZkGzPKakwAQBdd+ml9rKtYK30fKT/US9zrmD3DdKkgCBkl6V1kLhMSM5myfzB6S6OwFvnCHtOrjIoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8238
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Rafael,

On 11 Apr 17:55, Rafael J. Wysocki wrote:
> On Mon, Apr 10, 2023 at 11:53 AM Wyes Karny <wyes.karny@amd.com> wrote:
> >
> > The set value of `fast_switch_enabled` flag doesn't guarantee that
> > fast_switch callback is set. For some drivers such as amd_pstate, the
> > adjust_perf callback is used but it still sets `fast_switch_possible`
> > flag. This is not wrong because this flag doesn't imply fast_switch
> > callback is set, it implies whether the driver can guarantee that
> > frequency can be changed on any CPU sharing the policy and that the
> > change will affect all of the policy CPUs without the need to send any
> > IPIs or issue callbacks from the notifier chain.  Therefore add an extra
> > NULL check before calling fast_switch in sugov_update_single_freq
> > function.
> >
> > Ideally `sugov_update_single_freq` function should not be called with
> > amd_pstate. But in a corner case scenario, when aperf/mperf overflow
> > occurs, kernel disables frequency invariance calculation which causes
> > schedutil to fallback to sugov_update_single_freq which currently relies
> > on the fast_switch callback.
> 
> Yes, it does.  Which is why that callback must be provided if the
> driver sets fast_switch_enabled.
> 
> Overall, adjust_perf is optional, but fast_switch_enabled can only be
> set if fast_switch is actually present.
>
> Please fix the driver.

FYI this issue is not exclusive to amd_pstate driver. Even intel_pstate
driver sets fast_switch_possible = ture without setting fast_switch
callback. If the driver only has adjust_perf even then
fast_switch_possible = ture is necessary because without this flag sugov
won't choose `sugov_update_single_perf`.

Thanks,
Wyes

> 
> >
> > Normal flow:
> >   sugov_update_single_perf
> >     cpufreq_driver_adjust_perf
> >       cpufreq_driver->adjust_perf
> >
> > Error case flow:
> >   sugov_update_single_perf
> >     sugov_update_single_freq  <-- This is chosen because the freq invariant is disabled due to aperf/mperf overflow
> >       cpufreq_driver_fast_switch
> >          cpufreq_driver->fast_switch <-- Here NULL pointer dereference is happening, because fast_switch is not set
> >
> > Fix this NULL pointer dereference issue by doing a NULL check.
> >
> > Fixes: a61dec744745 ("cpufreq: schedutil: Avoid missing updates for one-CPU policies")
> > Signed-off-by: Wyes Karny <wyes.karny@amd.com>
> >
> > Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> > Cc: stable@vger.kernel.org
> > ---
> >  drivers/cpufreq/cpufreq.c        | 11 +++++++++++
> >  include/linux/cpufreq.h          |  1 +
> >  kernel/sched/cpufreq_schedutil.c |  2 +-
> >  3 files changed, 13 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> > index 6d8fd3b8dcb5..364d31b55380 100644
> > --- a/drivers/cpufreq/cpufreq.c
> > +++ b/drivers/cpufreq/cpufreq.c
> > @@ -2138,6 +2138,17 @@ unsigned int cpufreq_driver_fast_switch(struct cpufreq_policy *policy,
> >  }
> >  EXPORT_SYMBOL_GPL(cpufreq_driver_fast_switch);
> >
> > +/**
> > + * cpufreq_driver_has_fast_switch - Check "fast switch" callback.
> > + *
> > + * Return 'true' if the ->fast_switch callback is present for the
> > + * current driver or 'false' otherwise.
> > + */
> > +bool cpufreq_driver_has_fast_switch(void)
> > +{
> > +       return !!cpufreq_driver->fast_switch;
> > +}
> > +
> >  /**
> >   * cpufreq_driver_adjust_perf - Adjust CPU performance level in one go.
> >   * @cpu: Target CPU.
> > diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
> > index 65623233ab2f..8a9286fc718b 100644
> > --- a/include/linux/cpufreq.h
> > +++ b/include/linux/cpufreq.h
> > @@ -604,6 +604,7 @@ struct cpufreq_governor {
> >  /* Pass a target to the cpufreq driver */
> >  unsigned int cpufreq_driver_fast_switch(struct cpufreq_policy *policy,
> >                                         unsigned int target_freq);
> > +bool cpufreq_driver_has_fast_switch(void);
> >  void cpufreq_driver_adjust_perf(unsigned int cpu,
> >                                 unsigned long min_perf,
> >                                 unsigned long target_perf,
> > diff --git a/kernel/sched/cpufreq_schedutil.c b/kernel/sched/cpufreq_schedutil.c
> > index e3211455b203..a1c449525ac2 100644
> > --- a/kernel/sched/cpufreq_schedutil.c
> > +++ b/kernel/sched/cpufreq_schedutil.c
> > @@ -364,7 +364,7 @@ static void sugov_update_single_freq(struct update_util_data *hook, u64 time,
> >          * concurrently on two different CPUs for the same target and it is not
> >          * necessary to acquire the lock in the fast switch case.
> >          */
> > -       if (sg_policy->policy->fast_switch_enabled) {
> > +       if (sg_policy->policy->fast_switch_enabled && cpufreq_driver_has_fast_switch()) {
> >                 cpufreq_driver_fast_switch(sg_policy->policy, next_f);
> >         } else {
> >                 raw_spin_lock(&sg_policy->update_lock);
> > --
> > 2.34.1
> >
