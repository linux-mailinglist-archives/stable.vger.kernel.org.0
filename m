Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B668E591D66
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 03:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbiHNBKf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Aug 2022 21:10:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbiHNBKe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Aug 2022 21:10:34 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2067.outbound.protection.outlook.com [40.107.237.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE54EF5B;
        Sat, 13 Aug 2022 18:10:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HfP3oQVy5QyHiCxiccG7nM4npnfhl1tDry5zweF0IQPwZKjqY7a386cm0Q1+81WgSUFVQuRLS5DcsX3asGemhyIEQsYno+y+EpFlDuUFl7Wk4VkW/HPjOofWnTUYyZ8+6eq9HkgD9xdJu90MyXo/3ct2pBAjl+oMfELWNqz/abLnNQPviiOh/yoYTbjHHQGBNqO2oARINKqzOtGRLNvkGqw5B2TX1bTX6VUjaDJHglefhuE7F3L8sJzxc8x8hu4ThyGJVepQUYE418UB5UnwVN20bnQfdGnWAJ1sprMLR7pEN4ag11yzaq5tOLHFSdt+rNkYpUqDlUhr6ZLpl/HAfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xjDfi2Ipvr9Jh/Ka66JD9VPW4d4zOI2czUvkxsQAheE=;
 b=hEWSJhhwgIjyv7NpQzXRTjL3cZzlMfOr6K0iQxLgg/2PvkJt8+dG4nPjyuJQvzw/LlVahc0jvT4povwFvwXzwG6UA9zcTrpmuYizOy8VIGpiZ1ExU+ZwbdihLTMlMXX1/Zp3dzLPeSs1oTrARsWi0C76t4c70doZXHfzuptATo4XtWcDp6A5+uZ2fZDi5urNpINpT/W2aR0UAQS0Ups63wzVsVd0Hn5bXjoonkRa5ejMUERnFiD4QtrvrU8qWGQqSnmFvFLA7F+uN34N1/tMhNpdCYpZtHD/NoVvpdoxCWJyKpbwJT7xsvIHwVInI1p5wDlXiIUJP3yE0HZhOym5vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xjDfi2Ipvr9Jh/Ka66JD9VPW4d4zOI2czUvkxsQAheE=;
 b=Kn8Aydrr7yNl7B4pN69/tvLyKL1XoB5JziO46dxUMBZOKL4pcA+tVqqzQEUH/E791fhApq97TG51q+t8H4MSM1pbHKzNgY0uAQIMBOG1UDdgPhYGo6JUHcnpAhVDtebcMEG6zvxTWQkIRhSHe/jhS47WBRp7FamouuyyYZN0zLbIhEAi0sb7Bdx47hqGL/eJDnyk3qFsyoH9C95QAb/Q1NVv4pMj8m1KrW+AntZIRUfu369C6JnIdBZZsqc928HW5Wm3kqw00PeHdRwx9QG4ySD1+O6tBjynzdt+N8XDTwDye8OKlxXKWpg5iwcoKpUTlXufAMGk+DKJf5vJNmGe5w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4130.namprd12.prod.outlook.com (2603:10b6:a03:20b::16)
 by MN0PR12MB6149.namprd12.prod.outlook.com (2603:10b6:208:3c7::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.25; Sun, 14 Aug
 2022 01:10:30 +0000
Received: from BY5PR12MB4130.namprd12.prod.outlook.com
 ([fe80::508d:221c:9c9e:e1a5]) by BY5PR12MB4130.namprd12.prod.outlook.com
 ([fe80::508d:221c:9c9e:e1a5%9]) with mapi id 15.20.5525.011; Sun, 14 Aug 2022
 01:10:23 +0000
Message-ID: <df6f3200-5989-c4b8-65ce-85ba82f4196f@nvidia.com>
Date:   Sat, 13 Aug 2022 18:10:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH] sched/all: Change BUG_ON() instances to WARN_ON()
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        David Hildenbrand <david@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Peter Xu <peterx@redhat.com>, Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mel Gorman <mgorman@suse.de>
References: <20220808073232.8808-1-david@redhat.com>
 <CAHk-=wiEAH+ojSpAgx_Ep=NKPWHU8AdO3V56BXcCsU97oYJ1EA@mail.gmail.com>
 <1a48d71d-41ee-bf39-80d2-0102f4fe9ccb@redhat.com>
 <CAHk-=wg40EAZofO16Eviaj7mfqDhZ2gVEbvfsMf6gYzspRjYvw@mail.gmail.com>
 <YvSsKcAXISmshtHo@gmail.com>
 <CAHk-=wgqW6zQcAW4i-ARJ8KNZZjw6tP3nn0QimyTWO=j+ZKsLA@mail.gmail.com>
 <YvV0e7UY5yRbHNJQ@casper.infradead.org> <YvWPThSv65hwuSMl@nvidia.com>
From:   John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <YvWPThSv65hwuSMl@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0055.namprd17.prod.outlook.com
 (2603:10b6:a03:167::32) To BY5PR12MB4130.namprd12.prod.outlook.com
 (2603:10b6:a03:20b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d43c768-604b-47a3-a98a-08da7d91c3d1
X-MS-TrafficTypeDiagnostic: MN0PR12MB6149:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Kei10gnJdsP8g8/5mudFnNnLny11yC5+JO1wV6/UDviUhLmE0aBj6jtCjX0uJ9fp4Hb0rLrJUoCXtXA9QeY+DQAHi5iSLSPR7pk99FPWbV3aru9RsnOKI2pAVdZIJDawam8BG3wP/f8zkEGg5xtlhr+OVjfHP2yGx8hY7B3s94eAlPXqytBBMgIdkB5h4W/RF6kAa6oRnRxPXm/3hA5wWDNyYlkw9bQ1xbO/iMeIvjUmuHsZrjZ/OtXl05pMsyWkNhfoidRbOxiFza9AAVikmWmhpuN/mHqP5rNEqWwlVW/BGmVJxyvvY2r6GFl7WcpGT95bqa++mXusfnH5gpofKl7Pk4cvDPbY5N6QgBflxWRMXsHUIWx1Ef0Qv0VUxpTxKYEA3Ft2JBtioxn79puwU+cyB4GjKK0nZHqOd3AvH1megrRNJI0ReDBj61KS/fcG8SJj9cV9i90JBV8PIKk5FJcoY9/0BGGzPhh+XyKSbG0T/wfyU2WExzsDiQZKEQzPsr3ZKQLGsNMViufMYv2EE3YJYk4koRRM0chz9NoUoObfHTIZ44KX0g4HuLfta5lUrhW5nlk8efFCIYDMn5Y/+tzVmZp4KkBSFVm6fRD1AqI0JrmjstXza63CmFbvPI1uRgQ1YBRJPxz2V2oHXvkCGuM0cz+GoLhCNkvyXlqayFPQeN2G8cyYnAfX2I5pwjWfAaOMxIQaM0BgKC/BbPQAzKXZTQ1o4hXqpl65g2qq5/YyggzARM3MNulRfdLhaf2+4ln1lMorU6O1lThydtDvbRxKlvoSrfPFciD+1nam1xziQ2SdZybG/WpmId0lzuTev2/LNa38qlaD9KdvuVpm+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4130.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(39860400002)(136003)(376002)(346002)(8936002)(36756003)(2616005)(6486002)(66556008)(66476007)(2906002)(31686004)(4326008)(110136005)(8676002)(31696002)(186003)(86362001)(54906003)(5660300002)(83380400001)(7416002)(478600001)(316002)(41300700001)(38100700002)(66946007)(53546011)(6506007)(6512007)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YUxBb2tVT1lNUlpiWTdscU9yQllqRzlkRG1sOEYxSEluQWo0VjZ3TkUyaVZr?=
 =?utf-8?B?UEFGYXh0WjFXOVUraFVnTDFvMHlJWEd3KzRxSHZwdUJad0hLT1ZoUmQwTnQ3?=
 =?utf-8?B?eVc4YWswT0xTYzNaVVMvWnI2N0NoR2xvZHliYjREbHVnMTh6WTZDOGVGWkpD?=
 =?utf-8?B?YWFqbUg0VFV6T2QzMWhSTkZvVGh3L0IwVVE2RHcvb0ZrQThNaUVhamRXbUly?=
 =?utf-8?B?MUw0dXlqdGhkcndoeW9Nem9SNkJ6NzgzdjdWZ2NJMFB2cGNXY1d5TUtCK1px?=
 =?utf-8?B?WjFWb3owSGxDa1lpTy9oanNTTmtVL2dRSGVmVVdSNWtscHVLVmoyOWM3TDZr?=
 =?utf-8?B?aUl0NWQvTFpPcUFsZHQ3cjZpYVNzZVEyRThyeEk5TG12RS8weStHQzJ2dE80?=
 =?utf-8?B?YzlaZXpHNjN5cFlNQ3pEZ1diSkhLTDR2UDBOcFB3NHBHOUtKQ2xteS9zanF1?=
 =?utf-8?B?RUtUU2tsN1dlY0liVVdUNFRCd1pJR1lXd1dRa2xmYUJLM3dXcE1HRzkzeVBD?=
 =?utf-8?B?ZzEyQUNoeU9BRC9TQ3FiNFoxdzM4MDYwa1NWVjlLR1d0b1cybno0SXZwVXVQ?=
 =?utf-8?B?QndLbVNiTHVPMzZSRERhd01TNVdIRUxqTmRwakV3K3F6bU5QNHl3aFpnTmJH?=
 =?utf-8?B?cDRFaU1ENVBaT1pDOXBySW5ORUxIY1B1djJ1Y1EwelJtUjRjZVV5RktNTldo?=
 =?utf-8?B?amNFWGE3NmNxUFZIOEl5cVZqYUpTUThCRGZMa1gzWTd3NkZ0WkllNHI5aTN4?=
 =?utf-8?B?SjlZN1MzQzROQkR3MzhLWmpwRmNrZitiL05MbG5RNW50MWZDNzVwUXA2ZVo4?=
 =?utf-8?B?R2FiUXhhQmYvZFk0U1ZydlBiYlAwTGtTeXJMUzU4TXQyZkFrcG5DRTF0KzdC?=
 =?utf-8?B?dXBwUjJtdGZTeU53NExnYlZVcjI5c0xwR09yaEl3WDlOQnh4QVZVLzZpY1pT?=
 =?utf-8?B?OEhKN0hmNnRaLzk2VE8rQVJ5ZjBvSi9ZT21aall6R0JxNDNya3AwZ3MrNG54?=
 =?utf-8?B?djlXZUJYaDRHeVJacVd4VHFWZkZyTTVhVWxJSC9TQ2U5TXVIN3U2aEVhRkND?=
 =?utf-8?B?TDkrUDZwbUt0MTVoem5QVHZPdlhmbmIvV1BpSGNtcktOZGMrWWpQTVlvWlZF?=
 =?utf-8?B?QlpzcERIQ1A1djFDU2dWTTdwMkFzeU9sbW1lTzVkYkxocTljcFBBNmdiS1Jz?=
 =?utf-8?B?Z0JHS2p3T0hEaFpZRVZnbzhwT3ZrRDFMcTBOREZvREtUQ2VERm9HcFdpZytn?=
 =?utf-8?B?cXdHNm1aTDAvWEtQMEZ6TFR3VjV2NnYyYmhtaTY1ZDBlZFVVM05GNllHbjND?=
 =?utf-8?B?Vk91eWVTQjlmUnc2WWI0emhRR2h2OW9JSGFwZk52bm9pZlIxanhDZ1lsOURD?=
 =?utf-8?B?a1VTWG1obTN6NW5kb2YzaFB2d29WdHpSSE1QbDhhQXlWdHlMcmpadEpXZXpB?=
 =?utf-8?B?dkJZNXhrT2hLMnJUYlZ1eCtpbzVpSjU3dVZKeloxZnRaTHUxMVV3L1hFenJU?=
 =?utf-8?B?T2RaTk43VUxGT1N5REd5QWx0SmpLaDcvK2pVeE0rSG5nY0gyR0J0VVkweHky?=
 =?utf-8?B?TTdUU1doR1FqK3JTVHJuZE5WMWVJRmE3Um1IcnlTdU1jcmNJOENiU09GQTJw?=
 =?utf-8?B?SWlDeVp4djZ4bXlNYXNnSEY3dWRwditPR0hHLzN3Njd0OEhOdHc3eHhoYlY0?=
 =?utf-8?B?NW9mb0w1MkEwNmR4WTc3cjYzZ1NJUXdwUGRMdlpvR3hQeXdkR3FHaFBYRTRT?=
 =?utf-8?B?OVM4d2ZYd3pxU3JkbHFJWE9LVXVYMkw2ZjBNOHFhYmlBR2F2emgraWppU1Q0?=
 =?utf-8?B?VFkxKzVUL2pTUkQ2UlFEaUY0QWFXTlQ0aVJNYTJuTERlWi9XQUdOa3U0Y0tS?=
 =?utf-8?B?VnJOT1crM2FLN1lNb05IR25SaFh3N25NbDgrZnBJb0FkNVdSUVEvZGdlaW93?=
 =?utf-8?B?SEJsbDN0d3Z3Z0N6TnV1bHRCSmF0UVVoTlRZZGlZZ1ROL3N6dzc4TnVzMFAx?=
 =?utf-8?B?LzJ6WWRzUDBaUUxBTWtNQjJ3U2k4N25RaGVSaTM0SkdZcEI1Qm5ta0xXSjRn?=
 =?utf-8?B?RVZWazZiTXVCOVQxeHJXOFRLNVBXSFRXZ1phTzZZUlg3L2gvQlVuWXhMV1pM?=
 =?utf-8?Q?HCbWolh9SA6LmdvtMiw9mrz/l?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d43c768-604b-47a3-a98a-08da7d91c3d1
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4130.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2022 01:10:23.6311
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i/P5bOECa+QRWtoLXYzOwFbM6F46FtPQmD2mYv0z8v0Gdl0xe3mR5eajgL1sFp3MFU1OHl1W03t2FRbzsDV58Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6149
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/11/22 16:22, Jason Gunthorpe wrote:
> On Thu, Aug 11, 2022 at 10:28:27PM +0100, Matthew Wilcox wrote:
>> On Thu, Aug 11, 2022 at 01:43:09PM -0700, Linus Torvalds wrote:
>>> May I suggest going one step further, and making these WARN_ON_ONCE() instead.
>>>
>>> >From personal experience, once some scheduler bug (or task struct
>>> corruption) happens, ti often *keeps* happening, and the logs just
>>> fill up with more and more data, to the point where you lose sight of
>>> the original report (and the machine can even get unusable just from
>>> the logging).
>>
>> I've been thinking about magically turning all the WARN_ON_ONCE() into
>> (effectively) WARN_ON_RATELIMIT().  I had some patches in that direction
>> a while ago but never got round to tidying them up for submission.

If you do that, I'd like to suggest that you avoid using magic here, but
instead just rename at the call sites.

Because:

First and foremost, something named WARN_ON_ONCE() clearly has a solemn
responsibility to warn exactly "once times"! :)

Second, it's not yet clear (or is it?) that WARN_ON_ONCE() is always
worse than rate limiting. It's a trade-off, rather than a clear win for
either case, in my experience. The _ONCE variant can get overwritten
if the kernel log wraps, but the _RATELIMIT on the other hand, may be
excessive.

And finally, if it *is* agreed on here that WARN_ON_RATELIMIT() is
always better than WARN_ON_ONCE(), then there is still no harm in
spending a patch or two (coccinelle...) to rename WARN_ON_ONCE() -->
WARN_ON_RATELIMIT(), so that we end up with accurate names.

> 
> I often wonder if we have a justification for WARN_ON to even exist, I
> see a lot of pressure to make things into WARN_ON_ONCE based on the
> logic that spamming makes it useless..

Agreed. WARN_ON_ONCE() or WARN_ON_RATELIMIT(), take your pick. But not
WARN_ON_EVERY_TIME()--that usually causes a serious problems in the
logs.


thanks,
-- 
John Hubbard
NVIDIA
