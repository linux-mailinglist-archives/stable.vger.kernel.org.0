Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0169C595214
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 07:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232569AbiHPFdw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 01:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiHPFdh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 01:33:37 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2048.outbound.protection.outlook.com [40.107.220.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3A17118DE7;
        Mon, 15 Aug 2022 15:12:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NbNNwUtJs3Eu2qK0+LV4RI1IPvE3AMiH9UkCRVBWrt8JcwQb9bZ73glOFpfggq4dn4maryfkbzBWu3WTpt2LJmK9HEXSYRVovpiFbI2vh7UBuZkJLgQTrIINBKDaACtHl9/sd6XTQF12tSCLQRKttbWpNo/Ph9++81EVrLSzUMNA4lMNwapWL/UiytaNdGqD5I9wppN7Zwf1Lt2JYPGMMszooT8TsmpAXPUO0rpMLxk6NxnjlgDXRHOo0xJRFm8NK/0IQp0RrlCmCAoIfQtLO/hEEuk2iTaxdSIWNanHiIa9woBAQo5zJUKDhmc/jM5XMLcQ/CCNJVphFun353RwIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ck+VCzPdVu3/y3LimiewTjanc97eXGBhENYeTvKUq50=;
 b=Qkpyrfi6qBqgsyrCVtayfrgRReKeirPjX/W9zagbEMJphITe3Yr5cCVKU1J5S+A3adP8PE4k+uickVBxLByHCMUtIlznYrJKkKD48fRbxkGjJXwx1ItTCb4M/OLaPgPsm44Omk+VqjSnwzeKVYFa5YcOxy4eRrI1VcATaajYHUkunojsaGgzoJkmYFRA2SwYtbSDz4tf3kEteu6B04f7ywOTNznv73Y/VbMWUaIPTCMjYbDqwcvdS/nYXY8Lr4vpzPhkO3HW3fpY3c6Gkx/O5tv6YXvf4hNXsIjCHqKtIvfLsWH76ekbE/D/xdvr5lH4SGe7c1Oeggk1dt4kMs3v1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ck+VCzPdVu3/y3LimiewTjanc97eXGBhENYeTvKUq50=;
 b=rAiuBuJsa4mDJovTyTYi3dAILOZ3yM0p+xRYMY5u8mqd0gT28Zq+hxF90n0b7JOY928Gqz9HzXQIyyPqDiIosMJjIFFsXnKnvdm4jhdERBXNlzLNLgNvi9IYqfaQxO7doutSL2ynHTTJhRKMLintyvdAm2Ntw3J5r2KyR/nVRNr4WXeNp0olmPB5cakdA7IXWt1gepoMQ+y8ocW7FS32RAc1yEHp4kvesqxw14r4woOx8ptzDITOt99E1WjWx1K4NuwQEduX9r59fh+KNGVW1gDC2eAIcBVnFkQHZx5hHRy7QDjhyXYzSekPImASUVq0MPkMSiV7zLHUlirIaofDWg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4130.namprd12.prod.outlook.com (2603:10b6:a03:20b::16)
 by BL1PR12MB5946.namprd12.prod.outlook.com (2603:10b6:208:399::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Mon, 15 Aug
 2022 22:12:22 +0000
Received: from BY5PR12MB4130.namprd12.prod.outlook.com
 ([fe80::508d:221c:9c9e:e1a5]) by BY5PR12MB4130.namprd12.prod.outlook.com
 ([fe80::508d:221c:9c9e:e1a5%9]) with mapi id 15.20.5525.011; Mon, 15 Aug 2022
 22:12:22 +0000
Message-ID: <cbb3697c-f310-ae91-1322-fea5794ebf30@nvidia.com>
Date:   Mon, 15 Aug 2022 15:12:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v2] sched/all: Change all BUG_ON() instances in the
 scheduler to WARN_ON_ONCE()
Content-Language: en-US
To:     Mel Gorman <mgorman@suse.de>, Ingo Molnar <mingo@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Peter Xu <peterx@redhat.com>, Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>
References: <20220808073232.8808-1-david@redhat.com>
 <CAHk-=wiEAH+ojSpAgx_Ep=NKPWHU8AdO3V56BXcCsU97oYJ1EA@mail.gmail.com>
 <1a48d71d-41ee-bf39-80d2-0102f4fe9ccb@redhat.com>
 <CAHk-=wg40EAZofO16Eviaj7mfqDhZ2gVEbvfsMf6gYzspRjYvw@mail.gmail.com>
 <YvSsKcAXISmshtHo@gmail.com>
 <CAHk-=wgqW6zQcAW4i-ARJ8KNZZjw6tP3nn0QimyTWO=j+ZKsLA@mail.gmail.com>
 <YvYdbn2GtTlCaand@gmail.com> <20220815144143.zjsiamw5y22bvgki@suse.de>
From:   John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <20220815144143.zjsiamw5y22bvgki@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0018.prod.exchangelabs.com (2603:10b6:a02:80::31)
 To BY5PR12MB4130.namprd12.prod.outlook.com (2603:10b6:a03:20b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dea507ef-8667-40b9-ddaf-08da7f0b39bc
X-MS-TrafficTypeDiagnostic: BL1PR12MB5946:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dAKEoPD0jXJo1dPFrUYIhYx3/wwMFDY42zIhAwaWA/YXc3TFZ10b9u6ghc1vyx9odwEfq9ZdXrdlJQsiTmda5igD490BDPEYkv6a5iikd4/ZuHMHJGo4dNJhPf7KP5KPO2iKGbaLOh/Qdb+arBlIwjJEyO0w/oz+gLhRPXY4TA03onpK9JcDb7vDgCiGlzfIzqkWqZ3TqLNqJQODiNbHu/hBxpmr1Ue+/M4pRdNLfHxSjdW9QH49OkHq12EJz8hRlx6amGcCE2kNQbBQP8KuYnft2mh0K3wdNcQGXD+essSSCLy6ziz0w82KQCghDACX7fFC2ljKtyCQbdihLE3YR5Yud7BA1WSpV48Ei41ti6VYHhQuN/EPzRSPBSGG8T5TXLU4EpfFnT7IHqFBWZdMRuyvn+Do/brQTWAOK9iQ1OphytOFYzhP+aj5mjXS0wXDBDXYZ9sOTxPtNde74a+UkkiEDLrvL9TnkGO601j3EAXRKIgUNpELbLqBPpGDHEbp8e7uJytXdIY8kpplWjOSmCQoqlKcsw9BVEXvZX1IdE5+cq4hJkGP0AUDoJp2OL2i4VGYk3aMCgACq1MIAvc2uMwFzGM7Tq/HCmlXZUqtcpHJy6I66TqmgUNq7SeHBPIeTTRIk3nCdnu1t5aoImWL5VAGMQ3mq+4u10m82ps65Cm9nynfDieaf7je8iew7DCXX37EwSvNNfjVO3SMQ9h10JyCaBxOdCz0y19CMYi9u1fBtvcTHvRfeEjOnuQL3J4VRmkJI8UirpJPVDZ3XyENLQrxHQvM1C7shryn633xNIyUpIBuNMdPoNfSffn0NKoMDBuY86G8rYyIkcGSTa0AaQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4130.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(136003)(396003)(376002)(346002)(39860400002)(38100700002)(31696002)(316002)(86362001)(66556008)(36756003)(8676002)(66476007)(66946007)(4326008)(83380400001)(6666004)(8936002)(6506007)(6486002)(53546011)(478600001)(5660300002)(7416002)(2616005)(6512007)(186003)(26005)(54906003)(110136005)(4744005)(41300700001)(2906002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZVM5cmgza29qSS9GYzFNZ2dpMmVOSkYxWlZvTE45ZjVvNnlYYUZyMFBhSG0x?=
 =?utf-8?B?ZXA2RWx2YzJIdEk1S3lwQ3JwR1B1Q1liOVVlUUhNMDUrb0J0OE04K3A0Umxm?=
 =?utf-8?B?bDNJU2J2VloxaEo1YzB1dEJhTUF6enlkOWU4bjFpMW1MUzRUbjVWRk0yNDVJ?=
 =?utf-8?B?WlhXY3M0OGxYSHVxN1dBZmxxQWVXVlFWdVZXQzNzaFFzUkh1YTFyVkNXN0Fv?=
 =?utf-8?B?VzB2ZTdmU2JaUFlXREhSNHUxNlA1QytadXJ3ZUlJaUdZWkNHSG9sNnNIUFh6?=
 =?utf-8?B?T05WeUJiZzhROWF3RUV6RzZsOE1tUXpsRjRXVHI0MXpRNUUwbUxiVnM3eHJT?=
 =?utf-8?B?ZG1LUldlRExFdnJzNWNIMVlWWVNOTUlOWGduSkFVVUZjc3NKdnVMOXVZZG9n?=
 =?utf-8?B?RmsydmNSZ0l2amQvUkFES2dGaTJmY3pQY01KSWYxb0hyeVJHS1Z1UUZONDdZ?=
 =?utf-8?B?MnFZTzhlSFBFZHBmQnljK1VWRGdKZDhReVBGeklCU1VuTWdxdWpLeURrZkZw?=
 =?utf-8?B?dkN0aVVwYmxrSWgxZ0pkeE1TWk5YVTh4U1QxZTcxRCtXUW9NMkRUMHBNaFlr?=
 =?utf-8?B?eGVaSVdNWDRLMXpsNFhDT28vOGIxaFRGZFFyZy9KU2tvcTY0NlVjczc0aHVT?=
 =?utf-8?B?bmNKMGFVTVlSbWJPRlJTSm94QjFFTWN3TlA5NitGU3RCbVRyQWtIVHlpMGJw?=
 =?utf-8?B?ak00NWZDRlBxdXZ5V0RpUUYzM0RLbFNIN2VRdkptVDJxNC9INU85YmpjRzZG?=
 =?utf-8?B?ZjdyUG8vQWUvdU8xSGk5YTVjcGtSd2x2cUNmSVZxeEVhOXJtL2w2OTJyWjdk?=
 =?utf-8?B?TTNEYmdqZ0tXTjVEbG1Hb1E3LytkR1JqVzcydUw5Njl1WHFkQW1RUDRkcmVQ?=
 =?utf-8?B?bi8yVXZMdEFic2NpSUI0NXdacHNqdk5xT2lxZzNzTTUwcDBVcFh1QkM1OUt6?=
 =?utf-8?B?VEVwTklYc2Y0N0RhaS9CZHRUdXpaYXJsSWpJdEcyeWhkeUhRaFc3SjIzSHEv?=
 =?utf-8?B?WjR3ZU5TNWs2TTdLbHBKTTRnV2FMQkcwMXo0ZjRwWHR5b1NDVWE4TncwOUVz?=
 =?utf-8?B?cGJFUGZUdXNZWE1uVENIZmoyTVB2NzZmVGNhNFNtQnllWjA5NW1uNmkwdkRT?=
 =?utf-8?B?Z2RNTVdpQWdPdU4ySTNGTnJBZVUyb1lkb2dzTGhoY0JoT3B5OTIrQmVEK1Vm?=
 =?utf-8?B?RDZYNGlPeEEvTUowUG9RMzVJaTFOeUxhUlJqb05mTWNnc2NIYm1GU2N4c2dO?=
 =?utf-8?B?VGFXdkJ4Vk1PUTlFN2xZTm5CUUpJa1ZBYlVGOUkrQnRWckg3UHBEcFJkdC9r?=
 =?utf-8?B?KzEyMlR0ZmtCNTRueWl5Q3hPQmNXSnp6ZHgvemJQZmdLYm1DdjRBWXNpOHRp?=
 =?utf-8?B?eHcxL3l3TUVJK3V0NFgxVjBDWGhRb0F5VDA4dldLcWJHZlJUcmNTeGVvMDJZ?=
 =?utf-8?B?VWxiUExNZnhWTWlrcTZXN2ZjY0hpQWtLNzlFZGx2NDlkbVhXdHdXeWdLVVE0?=
 =?utf-8?B?WUxVVVNuQVNrODNWZ1VnZzlselFPZTkwczhqbW4vSkZTeXd5ejR6RFJ0Lyto?=
 =?utf-8?B?djNOb0h2WU1hTWVoN2JDSnZERmdTTkZ4VE5Pc3FFdjAyZDBQYU5oenZGeEVF?=
 =?utf-8?B?UDBrMXBUaklnRSsyeWFFNmZ2K1YzemdCNFlWdlJBV3hNRlhaZ2dUVSs4QzV2?=
 =?utf-8?B?eGxuRm92YWxrbzlBclZiTm9weURybThOb2p5eVdtam5EWU1pV1RWOUNHa0V2?=
 =?utf-8?B?SW0zNnUyREhoVXVwbGZaTnpub2VXZE1wYUdhNGdhN1NveG1YdGdreHFXOUk3?=
 =?utf-8?B?K0M4a0FLaUxPK1BFbnJBYTVGUTNpRDRwQWNDWUtkM3MrU2hnRFc0ODI3Mndq?=
 =?utf-8?B?dmxCVmhlUGEzcFgvZlV1anhXMThoZExIdXFIaHZEanRsSkljb01nWHJTME5r?=
 =?utf-8?B?MlAreE1BWlVBeCtkSjJsL0RESkVpSGt2aTZUQStkT20yeDhISVJKY1huR3Rj?=
 =?utf-8?B?Tk80ZzNJenBPbEJxa3NSamNCNyt0ejhoeXFPQWt2WVBhblB1NEZBbEFaS0k4?=
 =?utf-8?B?ZFkvaHFsRWJ3SU9xanJNNTNZSU9vOHBBaWNxbFZITVpwaTZxcXhDdm8xM291?=
 =?utf-8?Q?37FX3r+wS/yBqfqFvMjA+s8Jh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dea507ef-8667-40b9-ddaf-08da7f0b39bc
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4130.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2022 22:12:21.8423
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QCvRClMINjg+cLuaIzEBseX+6WWkOJZti7gqbbY1GM2F9n2q1Rq9xedO/nyjI8oamL2h5/SpUovV/jNwW1fu7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5946
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/15/22 07:41, Mel Gorman wrote:
> For the rest, I didn't see obvious recovery paths that would allow the
> system to run predictably. Any of them firing will have unpredictable
> consequences (e.g. move_queued_task firing would be fun if it was a per-cpu
> kthread). Depending on which warning triggers, the remaining life of the
> system may be very short but maybe long enough to be logged even if system
> locks up shortly afterwards.

Hi Mel,

Are you basically saying, "WARN_ON*() seems acceptable in mm/, because
we can at least get the problem logged before it locks up, probably"?

Or are you implying that we should instead introduce and use some new
PANIC_ON() or VM_PANIC_ON() set of macros that would allow proper "log
then reboot" behavior?


thanks,
-- 
John Hubbard
NVIDIA
