Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4830C6DEB8C
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 08:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbjDLGJQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 02:09:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDLGJP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 02:09:15 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2048.outbound.protection.outlook.com [40.107.237.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A20953A82;
        Tue, 11 Apr 2023 23:09:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kV3GIp1Zy2t+1sRWVu4XXxwagXGX2vZvxzd0PrcyoLKMe8485VF8x0+r56hKAEVI079ZgfWMT3RwKCYaDfJxEAo9d2070qFbRWz7b0tCjTy1nIloLtiCUFERuszBc8+R9G3E16UPZ7uu7xKbXPTCEGem+CGfkdOa7v1aRsuV67xs+ZBchnw8CpUuM7XfKVDWviHV1U8xHDg4YGIm938UCjAi4J0HmOijt9tI61pakAraGu22lbr0hjwu0pEbLeFp0n9yRaAfXet+m5T/K2ZzFXo1stz2Wt278ikFdOLFU7SXh3Ru6GFq+36NrGkiKWDB5KmbOqP5PwSm9y2mMKJPKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zc6jiPmXwX5xNdCX1tgrCXHJSGYZ0qNWo+39BPRLkIE=;
 b=hmB27agSaOqWgPyEy/ZouE04o3NCJoASxNH4aHYzj9xfVAEVY3A/b+7FTo4xRZC71yuxAoSFTRAAkk2oNMe1aGUhIjEC78OI9eypoU6dOTObcfl9Zaxwf/O6PwXtLgAS4ntncBE478vkOLXEzmidHKbxE/RO84hJSUnKGZ/YjiPCpSh0u2xFqgJa3LtdSoA0rli8xNgB9mIpVXazzn7eiEacIkQTAZPmsYW+zEg8mKmpE52G2hIBaByWTxWkMb8tgf47VMOry8xlAM4fs1jgVj3gkRTImH/nUJ2pZP/WCdczYTK82rZsySdx2pDS+UvP4NAaPa1zJhUoW1X198/gpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zc6jiPmXwX5xNdCX1tgrCXHJSGYZ0qNWo+39BPRLkIE=;
 b=IANeCaNcZkiRS9RNlNtheyCmBhmzCWVwsEqXIKmpd4tFKjIp6/ldvNkFszLi7euOOlBymSP65uwY5mvjovULo/LTl4iIzkn+809azmrzgywcqBC1LyGfLHnrGUGFiY1XjYXS1gxF9ZxbI7anenlWmqOE6NdEJw+MB0nVM7OTyjM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BY5PR12MB3876.namprd12.prod.outlook.com (2603:10b6:a03:1a7::26)
 by SA0PR12MB7461.namprd12.prod.outlook.com (2603:10b6:806:24b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Wed, 12 Apr
 2023 06:09:11 +0000
Received: from BY5PR12MB3876.namprd12.prod.outlook.com
 ([fe80::d1cf:3d4a:4882:7fd3]) by BY5PR12MB3876.namprd12.prod.outlook.com
 ([fe80::d1cf:3d4a:4882:7fd3%4]) with mapi id 15.20.6277.038; Wed, 12 Apr 2023
 06:09:11 +0000
Date:   Wed, 12 Apr 2023 11:38:52 +0530
From:   Wyes Karny <wyes.karny@amd.com>
To:     "Rafael J. Wysocki" <rafael@kernel.org>, g@blr-5cg13462pl.amd.com
Cc:     ray.huang@amd.com, viresh.kumar@linaro.org, mingo@redhat.com,
        peterz@infradead.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
        bristot@redhat.com, vschneid@redhat.com, joel@joelfernandes.org,
        gautham.shenoy@amd.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] cpufreq/schedutil: Add fast_switch callback check
Message-ID: <ZDZK9Jpjj6ysOJmg@BLR-5CG13462PL.amd.com>
References: <20230410095045.14872-1-wyes.karny@amd.com>
 <20230410095250.14908-1-wyes.karny@amd.com>
 <CAJZ5v0jH4uatAR7HiGY_MYASOcdwxvwkUZaMCHcznd-0idLCUA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJZ5v0jH4uatAR7HiGY_MYASOcdwxvwkUZaMCHcznd-0idLCUA@mail.gmail.com>
X-ClientProxiedBy: PN3PR01CA0162.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:c8::6) To BY5PR12MB3876.namprd12.prod.outlook.com
 (2603:10b6:a03:1a7::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR12MB3876:EE_|SA0PR12MB7461:EE_
X-MS-Office365-Filtering-Correlation-Id: 3699b388-cb2f-4207-398c-08db3b1c6eaf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ji4BTlP3bbrVh/G4CXUo/NVTNtsSnFucyqWnN46ZyDQS/XO2+1jrrOx/t+3TSZzieGwJ59mLFpGzWckcXWfhMCpmTiES44Jl2euYOO43MtKatMyHue0+AymN4gTVAEcUMHDxuLkRiQAQ0J7seygInmpbonFVr/55+hJJdbcfrRKyy9O1BpTdMMAo7vr6AU3/k5//ccwRtqcRNyOv3OjVGbVfJhUimafNCD9/niXvJTTadJJ5eWnjXFsALo8RLmOskm2dFPAj5LzqTRFXGO7n1uBIl5AstP6jDYFWMMnJlmI9bM+ExqneC9rk9UI6qNe1tdnHk7fXA/Zfm1ts3bSpE88jNzKA6OZZ237mxz32ntV24qa94WPbXZtdhfZT0xhsnnhPV0hPCgjL9J+EeU8i39j8hiY1RgbsMUaCeibiLrts7BZJSgvR5hxAxNcqOTqrj5ITMz++dTOcD7RNViKFVPf54k90O/31BP/i9/NS20M9tkAFWHGqiUhPvdCbKdAvkuNTIih87U3dn1WjNDYdo5Ca6GMjG5NmZXo1vRukN0kb/y0TYDHSAcE4ByEyBtj8u4BUCKaFpvcaEXpe4gOr9f6PLHJctn54evOLxluu7Bw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB3876.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(396003)(346002)(366004)(39860400002)(451199021)(6666004)(8936002)(66899021)(44832011)(7416002)(6486002)(5660300002)(86362001)(66476007)(66946007)(8676002)(4326008)(66556008)(478600001)(38100700002)(53546011)(2906002)(83380400001)(6506007)(6512007)(186003)(41300700001)(316002)(26005)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eVJIdGdDTVh5ejBOamt3SERibWNCa0QxWktCRWlCYjV4NFIrYjkzcGJiZEdV?=
 =?utf-8?B?WjFpSGF2N0VWODRoa2JnTXJSR1B4eTNZMW5JQmFpOEtzYkUzZXVUVGhRcXZB?=
 =?utf-8?B?MFlqM2lnSUJxQWl6K2hMd2dVTWI5ZzEyaEVYNkZXQUpseE1YSTlGeEVzeThQ?=
 =?utf-8?B?TFZKREpCSTVWNUU0V3pKMWVldVJLMGlJMFpYOVJ4QXRDa01vZkpFZEZ5LzBP?=
 =?utf-8?B?anVUa3lyNUZCMkE2cE43L1loSHJ5STEwdzU2TytINkJINnpzOHRUYnp2eGtY?=
 =?utf-8?B?cjViVk5nbW1HVUt4MkVKUk9adzNrUVJwMWJjQnp5dVRueC9ucWdQRUV4Qk9J?=
 =?utf-8?B?WFQxQnNMWElwVXRNb0N3L1JmWHdjVmsyVlpmd2cvUmhrV1NQemloRVhmNFNM?=
 =?utf-8?B?VnRCVWFDN0tpWlduSkVheU9wMHB6YnBldFJDaHRZamZOOVFFOE9nOHowenRT?=
 =?utf-8?B?bnZxYU1iaTN0SEFZZGZIMXc4YXRFTCtDdXJTT0NBUjZuaFN3QWdHTHJTRmVS?=
 =?utf-8?B?ZmtFODVGTlFxNzFWWm1YZDI4aVlSSEl0dDA3bmdDNkFjSEg2UWxCQ2IzREpP?=
 =?utf-8?B?WWhkaGdVdmhtb2U1SmZ2cGMzTmY5akx4bG5ZbzFUZyt2TUhRT0tyZC9sdWRw?=
 =?utf-8?B?S3lVNC9PcER1N002bWFMTlQ1K3pKSGpBNFhEdUlLZVdLcUtxNzRBdStjckFU?=
 =?utf-8?B?SDZ4R0hBQ3NVajBhVTJ1a3Jkdk0rUGNGWmhFYm5uNUhIWmdPajdUdXhtRThn?=
 =?utf-8?B?VDJ5bU9FR3R6cWxNcUl5T3VQanA3ZXlDSWJucGJkZVlEOFVzQkVGTXpTaTd6?=
 =?utf-8?B?Z0V2emloS0U2T0g0NWl1NFdRbk1DNHZCSTB3aFlmMHdDVHU4NU9XYjRFVXdS?=
 =?utf-8?B?RDgzWnN1U1kyb0JRdTVPdEQycUdVVVYxWWZPakQ0K3V4cE5jLzZlNno1NDR1?=
 =?utf-8?B?UDZKcUtqeFEwY1BVd2h1d0lpTWxadUJhZVFQakpNWnVsYU9XazZIN2FCcC9E?=
 =?utf-8?B?VW5sbERVQnFLMjlCMmRSWkltdGE1Z0ZtMlUwdThwSkVYTHROQzBVb09rZXpW?=
 =?utf-8?B?ZlYvL0x4eHlpYW94Ny9xYmRyQm8yeGdhZGZ1eFBiWWFpM0hCZDgxc2xFcXQr?=
 =?utf-8?B?ZXR2aS84d3UrSUNleHA1eEwxekhIaVA3NDNIVUt5YXdhclozdFlLWFJLOUJC?=
 =?utf-8?B?eWl4bkNrVTc3TFV0SjFianduQys3MDl3bzkxZ2VKdzQyaGU2Vmd0NkltYjZY?=
 =?utf-8?B?a3o3QlpxR3V1NUlsUkZDK2kwUXJyQjYwWW1YelZGRHg0ZE9XV09oVnVkb2RC?=
 =?utf-8?B?cmtiRENZZnQ4akdSdGxZb3loWGh5ZFhHMk8wanY0ejc1L3hINGZWSDhyY1Zl?=
 =?utf-8?B?N01xQXJtbURWajBhekdBQ3g4dTc4M1BtZk1XRWplRHRvOWxxdE5hWFR2Vkdy?=
 =?utf-8?B?amtId1ptN2krTlBpRWw3N2tWa1I5bHNxNHBNbGt4YWhhYXk5a0VqZVhleTJr?=
 =?utf-8?B?aUdBYTRHelk4MUNPQlg5akRJUmNZNE9LdXRLVkZwT0U5Z1Q5MEV1Vmdsc0M2?=
 =?utf-8?B?VG5pSkh4c2kzMmpHOU9IMUZaMHgyVkU3aG5EYkwyYWlGVmtIc3JHNFBGeWVu?=
 =?utf-8?B?SkMzaHlhOTBmb2ZLMTA5MFd0c0svZ0YyZXB5dzJaOWQyaCtWZStTWUhDL0Z2?=
 =?utf-8?B?WVhhOXNqNjVlRndCdHBIcGJtTkhNa05HajBraDJBaWwxNnhKNVF1MWpERnBi?=
 =?utf-8?B?cXFPbEZpNVlSN0xkUHpaa1lmUnk2VFVGRmdUeEovWUhib0gyd3Nid3cvejli?=
 =?utf-8?B?RzAwc0YrVXBtSG1lZkZCQlpDRG1lV1l6Yk1BbFZlS0Z4UUxlTVBzWHhMWDd6?=
 =?utf-8?B?SlM4b3pSa2VCZ0tiTytqMHhrZDU5SzBNeGRURVB0NStvZEpJelozMmxVdHZK?=
 =?utf-8?B?aEhPTWFib3NBbU5GdzU1c1V6QlRLbnNjQkFBUHJBdjYza0IyVzNNcjUzRzls?=
 =?utf-8?B?ZU5EcThHQnNPbUNROUp0bUNwMHV4YnNNcFhoa3EvMHYxalhNT04xK280WDdM?=
 =?utf-8?B?SVBuTUpxaTZyUkJGaVFOclFSeWJQYU1iZWs0NklxeDk3ZW1PVWVHZC85RjRZ?=
 =?utf-8?Q?qhUyDCEZJjahJzz75EHSs1Rxp?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3699b388-cb2f-4207-398c-08db3b1c6eaf
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB3876.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 06:09:10.8333
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U1bFOYOnt54TYgkR20ALgmQUe7HqsPY9iz+W2XHyrqUTyUzZ1yjZ5TjtIZzBWdLsQkKQfsj9twZ1+SD/PVT15Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB7461
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
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

Then should the below logic be changed in sugov_start function?

'''
        else if (policy->fast_switch_enabled && cpufreq_driver_has_adjust_perf())
                 uu = sugov_update_single_perf;
'''

This logic restricts the selection of adjust_perf function based on
fast_switch_enabled flag. If this fast_switch_enabled check is removed
then amd_pstate driver can disable this flag and shedutil can select
adjust_perf without this dependency.

Thanks,
Wyes
> 
> Please fix the driver.
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
