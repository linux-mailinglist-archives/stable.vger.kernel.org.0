Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8AB59F2A6
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 06:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232091AbiHXE0o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 00:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbiHXE0o (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 00:26:44 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2041.outbound.protection.outlook.com [40.107.94.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3993880039
        for <stable@vger.kernel.org>; Tue, 23 Aug 2022 21:26:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N0BjAecnyhSqdQJ25Lr3+jxLUNHC0wID40TGN5ruirUuh4L4fh6cauTk5YvPJw5Md0vcfJvyNoOpcT09wnDdkJwDbWysVvPAtj8izdWwkZ9hMMDUlSvjbNvpWf/8P1+fpbkI5Jtx/OO9QPvzMSXqMRpvE5T3TKXtzWfkTXaSeezLPS0+KqoZK9i7xylzSJQghpeonqS96EnoKjt3BwLhAx85FQm6dyk1zxBq03fgLUDP7jdX2m3Z+J/ksef4wQ6qMoe6JvgE8Oj3DKebvSD00zAQdgEjfr1jYT/Ec+18sWh3toyYe/UwQiaHkuqC3+4GgbSNLbztS40wZN/47+FGMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HiJi8HaVgYRcFokQiAb9m29BdFPtepnvQrV7zHdlKe8=;
 b=mcU02RupUfUHdswJqp3gieFK5quW8Nea8c5dEkOGWeKhzyaWLXmZEmVWXzoGWNzr3bj0OEBlqKlP1ZH3V9pJUKwOYl+knbC1xGhqqy1DpTcBRkH+LYQJWFvgW6YUFU4It6DOR5w5DwsV1yNWuwQPC6gAfjKOsMXSA6NI3mHYBzbIg85gZ2suGDVww/bymwHJCUg3F0z404/5K8fPaBb9iqgQcpxBWo/MusW1DV4WPBHWovqaYrcmesGUCt9ehpb1mQO5eOtC2+RVO1jXydfNp8dwddv2gJavI6ceNMEEnMsWdxG4La14ms12VSnB2Wy236HIN3Y4A+3LDtc7I8WYNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HiJi8HaVgYRcFokQiAb9m29BdFPtepnvQrV7zHdlKe8=;
 b=dm79TgIOP5gH/thzRAQt7vsXyX4yb3HLrOgH8f3/cnV/wjpHXyMAdStTWfDnv+3DWUG2nRY8Y2wVWUdq5OddrKnOjfywMssWfv7WXmLcdBd//VsnCIuJkfsXRfsF9FK3e6VorRos0HFghZijccwH/XRzcw3WEI7yeUw1OdAbsDowCOxcZGlqLfzCGIWJOjy3MbQxeGCc4+kR9/3uaSpSOuQxo2S5F0R3CviO1kE7+GuX9lI+zD8UvV7mo57Vf72gFRY8A2T54bjQtP99+HClS5XrA8dSnN5iXhiAHwjgEH9CPPeUFnSpw1V9m+nbx5WjPIPPKzdnUrfqZKUNFYNH7A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by BY5PR12MB3892.namprd12.prod.outlook.com (2603:10b6:a03:1a2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.18; Wed, 24 Aug
 2022 04:26:41 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::7432:2749:aa27:722c]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::7432:2749:aa27:722c%7]) with mapi id 15.20.5546.022; Wed, 24 Aug 2022
 04:26:41 +0000
References: <8e425a8ec191682fa2036260c575f065eeb56a53.1661309831.git-series.apopple@nvidia.com>
 <YwWVp83+9Wd5GbCV@b1a0c294b6c5>
User-agent: mu4e 1.6.9; emacs 27.1
From:   Alistair Popple <apopple@nvidia.com>
To:     kernel test robot <lkp@intel.com>
Cc:     stable@vger.kernel.org, kbuild-all@lists.01.org
Subject: Re: [PATCH v3 3/3] selftests/hmm-tests: Add test for dirty bits
Date:   Wed, 24 Aug 2022 14:24:51 +1000
In-reply-to: <YwWVp83+9Wd5GbCV@b1a0c294b6c5>
Message-ID: <871qt6gtc1.fsf@nvdebian.thelocal>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0154.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::9) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 654ccc66-b27a-46d2-559c-08da8588d7e4
X-MS-TrafficTypeDiagnostic: BY5PR12MB3892:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F6PgbS1YntynhmPuSEsyz6FeOqzVRDuVCJmftadJcN0DolJsif+5to5hJfhEZF9+MK4F1wot0PGiYntypN2pn/8mf8L+DhExwQjtAiaA/Z5B6uGx76SHjeXeN6z2dBwIAivs7gjFfjNWcs5d0f3NGObyyXEG7gmnXAGFDZv2xpaMoY0DkKZt8qfEKQHeYXJ7sRJk7v5yxqMYkUrrebM+wykMcJPq16lrv+Eus9Lp7Re8GhfAEnVTIpjikITocA+87wXTWGVbqLtZLN1ZRUT+qwuHBmGh9CpGIK2uh78sqNGRI5vXjg3z2y3qYlyaTb4rsqdsiM9f/QulmRLwO3OJQpe/2wHqa/C7/Z8XBo6ChrR8p/XdMlFJi46Fg++3u3JTTAhIBXumvnALfmGUVIi/XQtH17ULs4AhTvfds2euf51OOb40IxlQ/lgDqIqB2mmChEq0cRFzYA74JOUJbU+UPSEBfz+1OPS7eX3wAYKO0nPor+XhfvD4Gj1g1sYyzNIjO7iPsUIcuCo/lmIBq6Sh5FZLadq2gaZr0bQHF9wRH00/9Buy//gnfEA4uA709zn2UT97QmlYyKA5MYlyWmnM6d4dluw3DM0BaceX7yqZBLcgmTkfTxpRjPCnp+5szp6seyV8QxlIsBJE9AGfr9hWGRtyeny2HTSh+lCr6cysVtH6H90vGep3INk7NmzgxvEraEf235pCM+s4/+GTRY+o/TiZ1mhkt1oTapRTBUNbSWmp5CLYv47xVkcddXr+cKMDZq8GIi/eYTb+2nU34oLXIUFGKLlDxugh6O0wou4r8Gcif+tTmH4ICcuWJFLDEKpJqN8z4sehDr4RflkHur566drXPL7+W9Yy7QkwtTFiVsxQByh6fskgK8IDEGWN6Ev7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(39860400002)(376002)(396003)(346002)(136003)(66946007)(316002)(66476007)(8676002)(66556008)(5660300002)(4326008)(6916009)(2906002)(8936002)(38100700002)(4744005)(6506007)(86362001)(9686003)(41300700001)(6512007)(83380400001)(478600001)(6486002)(966005)(26005)(186003)(6666004)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WOYYTHVvB1KYc0JM8UibrfvB+I4UN6Bn9J0H/Qs93COuDPSoQhHnqq9Lh15F?=
 =?us-ascii?Q?uEYgnX2nz2NV3U4CD0UWg0cn21xmvWi6uXiaAt2FoHNohWI2tRpZ4Rxx91zB?=
 =?us-ascii?Q?xGa7LgFg/m+ImK6ktmFv7w10647geW1fumnK78XWyVHcEEnFUioLTjeLC2aH?=
 =?us-ascii?Q?i/5hFab9xOYPAfjdBa2Z1melKtMaQ2SP/sweBklldOaWXrTUXbHFQcg5ATW4?=
 =?us-ascii?Q?T069HAseMBj8Z8sqYurat88iXEHqEZ6L/7EDXAWA5GAKmh4fAMMzfsl+J/Sa?=
 =?us-ascii?Q?kxudO3FF1jVO7XoMF4/QdqkUwLpvkP3ghWnz57Nuti/VYNRHAGwYf1kr9ZKd?=
 =?us-ascii?Q?Xo2e34xYTfXHXmdkk8JNSzd6MwnMESZFh1/rXuRx4kX9884TocU4B2Wg642B?=
 =?us-ascii?Q?qOK0tbSmkHmYbwpwoI4vSSZjSGT7mi/uBPqLM+coYQCsu2roKM6RohirfarH?=
 =?us-ascii?Q?Zl9tJUzk6/WEV5AEV/Xw+lvYrGKVe8oVRwl7Kjs0yTK1P/S5QbJzy2gdFofF?=
 =?us-ascii?Q?AP+2P+sNdzDD01egOT8mJVNvzIyjtwnpOKF1q/En3gXEUacQk+ZB4icV9WxH?=
 =?us-ascii?Q?k/JI5dj2U8r+Wi8L6L4MfsVbsWWbM4B6iiSXcUSPDQu9onm+aI2n3/7FqlvI?=
 =?us-ascii?Q?Pelel+SB9LQE5x0u6MhwG+pWur3USyKCpRemA6Ryj9yTRDtt2CodsfJkdzFy?=
 =?us-ascii?Q?6kDP8A2tTHZQEImJhyA1bzeePnR659xNOn/Ewv8rtdBWNcZWeZYDHyXUiFqy?=
 =?us-ascii?Q?8q8m3NrcpNGhGIedpOIjYDJvrrfFoSwkfsb6GQGcQwez28i2i7gb+lsG7qA2?=
 =?us-ascii?Q?N39sgIJK8k2UzJ8/x6PF9oEg/ZMDrYfH3LFWK5Gt62dcCGhNLCaJpJDnDX+8?=
 =?us-ascii?Q?LTdMkyJtDkhg09qIq4E3I16G5TmjNoV2cEPWFh5e5g+rdSpWtS54/V7zy67X?=
 =?us-ascii?Q?hDb7rIa6hH/QAamsLBuLnWWfiBZ5Q/GfFb5YZJ2QHqxJzd2dqkNykbj/ezS/?=
 =?us-ascii?Q?JvFesBgUBY7/DN12YuTU8Y/h5AtBuppjkBhHNs7pl0UsHZIdHAMwPz+3jL5f?=
 =?us-ascii?Q?p73IwgpEVOD4sTf6gGV85aQ+KbHxyOiyNoDzpwTXAvz5TZ/c10aAz8VdvXAo?=
 =?us-ascii?Q?/668MEF6XMKGtME7Dm/TsAxANgPjaM83KrXzeFHq3fiYg3pR+AJh3qYPxEw7?=
 =?us-ascii?Q?YqyW+A5y49zP7DeJyYtiov1AP8JY8SaTdGi8sDRYbT5YE6ZdoXxQZ4LUfETZ?=
 =?us-ascii?Q?qBkDIPbrnNQwTBZWB0FNi6cOuZwsg0vYAr2H6brCa1J+mIKnqCVoQS/VOfRO?=
 =?us-ascii?Q?CswNnTL1iR0nWQ/qiZj/705dRqUETypLKZ8KAwog95n8cVudnLOSfy4oIZBL?=
 =?us-ascii?Q?ZpSZ55tycrQRXu9kGZ+USJhkLyPdCErebWWsl+cC7CTw3hvbNix6t0ppsB4b?=
 =?us-ascii?Q?luu2THdFoYQJBvB9un5VPaU+RvKjiJpsu1JSMoNBp3wKFgEmFvK+aNwJnbkJ?=
 =?us-ascii?Q?Hr8V3hGxDdsGlqQCCnNayriR4U/omE4Za42FxveCZ/j/IMg+/O8vIXFbKumC?=
 =?us-ascii?Q?z1Ov5Wh9u+nFO6hDyOEZeUfnAekPwyapx4LsD7tn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 654ccc66-b27a-46d2-559c-08da8588d7e4
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2022 04:26:41.2177
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9brgZyI69H3wW35+Dti/1wJdbfd7Xptl7Q6MYi9ARFeKJmEi5NoIm+sm8afuZqxKkaCJvlJYegsG/D5XQ9kPow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3892
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


kernel test robot <lkp@intel.com> writes:

> Hi,
>
> Thanks for your patch.
>
> FYI: kernel test robot notices the stable kernel rule is not satisfied.
>
> Rule: 'Cc: stable@vger.kernel.org' or 'commit <sha1> upstream.'
> Subject: [PATCH v3 3/3] selftests/hmm-tests: Add test for dirty bits
> Link: https://lore.kernel.org/stable/8e425a8ec191682fa2036260c575f065eeb56a53.1661309831.git-series.apopple%40nvidia.com
>
> The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

Ugh. I didn't mean to Cc stable on this patch, just the first two.

 - Alistair
