Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C61F4F47CE
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 01:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240956AbiDEVVL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 17:21:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1453960AbiDEP5n (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 11:57:43 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2139.outbound.protection.outlook.com [40.107.220.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4B661621A6;
        Tue,  5 Apr 2022 08:02:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G5fWUluv+7zz5an4MN7ariBSAJ7SLxXwtWFUn6LsujQBnn1GHWxjuQ1zB7K9xNdQrUK8heMRH8YiRQp/zUk3nE9qWiDcqkQxXtGW8vuT3JaMhVfE9ODtvhecBKu3ez7y26Ej3YeN3OXs/rxsThT90psVwSMGC0J4YRyd9b5s+5wnwiVgYT1HFvByk4ZiLP9BYyiroYutXWdEia4SV55S6YktoTejkeWXPQe4tpC3mJ17Um6HVPDAU91jxfEEEcvdsDV0eMeAIKCXqy749CO1bJEiBsTFeCXEb84bbXmgzX9Hv+rtquSmD8TfGR8XJ/j0RyfY8nHHvleUhmh1cHFM/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dAphyUdWOsFrvRgB9FRQILKqonpDoBKxzX+N+rmFHgA=;
 b=WGro+YqKjAFYqBC5kJCeREUbv6KeAJ5+5Y8fQNk6Yb43rA8MdNk+7yaSO8THcfYbh2ZjavmS0c+7C17GXplCFleTBQ3orz7YrqLDSWwrb2SC329zR4q9TrAOZTRKyB1MpNhkGwSrCxYtPNNXIbmdZefv1UiDXokjjyEkSRzmVx4E8rJMJ85WpqEcb3YrUzrl2TGZZhWH5atcmlv6F94/zVo17U4GEQqb4saXAhPlDW6PvAmmZbymr0dItxJXjk7MP1tqxwITMUr+RzSLhyrA5PTo0bbN9izK6FCFdDU5s0rZmdYfbuu8b5pohgvbvfCrxoo7wLRxkmViIkvW1/9+bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dAphyUdWOsFrvRgB9FRQILKqonpDoBKxzX+N+rmFHgA=;
 b=fkxSYuca+oWEN8SaCX1EP0g2B2vCc4m2svkWfcSt4MZqfJGJtIvoruJixYOusp4RbCua9nb/q6CVJOrpQlJw5y2MB89LwnGLujyb/lP1aM3N5tqsB/J3WvyQDtjsuuXtZRHqtcSA6gVs4P0zBdKGTCxxSyPdBqQLLho8SFd56/k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SA0PR01MB6329.prod.exchangelabs.com (2603:10b6:806:ee::12) by
 BL0PR01MB4978.prod.exchangelabs.com (2603:10b6:208:68::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5123.19; Tue, 5 Apr 2022 15:02:39 +0000
Received: from SA0PR01MB6329.prod.exchangelabs.com
 ([fe80::f56a:e18f:b6c4:ddb5]) by SA0PR01MB6329.prod.exchangelabs.com
 ([fe80::f56a:e18f:b6c4:ddb5%9]) with mapi id 15.20.5123.031; Tue, 5 Apr 2022
 15:02:39 +0000
Date:   Tue, 5 Apr 2022 08:02:37 -0700
From:   Darren Hart <darren@os.amperecomputing.com>
To:     LKML <linux-kernel@vger.kernel.org>,
        Linux Arm <linux-arm-kernel@lists.infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sudeep Holla <sudeep.holla@arm.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Barry Song <song.bao.hua@hisilicon.com>,
        "D . Scott Phillips" <scott@os.amperecomputing.com>,
        Ilkka Koskinen <ilkka@os.amperecomputing.com>,
        Carl Worth <carl@os.amperecomputing.com>,
        stable@vger.kernel.org, Dietmar Eggemann <dietmar.eggemann@arm.com>
Subject: Re: [PATCH v4] topology: make core_mask include at least
 cluster_siblings
Message-ID: <YkxaDT6jT73ZBgb3@fedora>
References: <3d58dc946a4fa1cc696d05baad1cf05ae686a86d.1649115057.git.darren@os.amperecomputing.com>
 <YkupgBs1ybDmofrY@fedora>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YkupgBs1ybDmofrY@fedora>
X-ClientProxiedBy: MW4PR04CA0053.namprd04.prod.outlook.com
 (2603:10b6:303:6a::28) To SA0PR01MB6329.prod.exchangelabs.com
 (2603:10b6:806:ee::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b9c9e2c-7557-4ea5-e550-08da171553a5
X-MS-TrafficTypeDiagnostic: BL0PR01MB4978:EE_
X-Microsoft-Antispam-PRVS: <BL0PR01MB497882788B880411663C8F6FF7E49@BL0PR01MB4978.prod.exchangelabs.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 22MKve/N6YmUwBuTGe2a3DaDxjIWtCghZXIwn2u1YJ12cCmSI0AaAqqYxg8KhponX9khCyx3n/aIN3ashS8x1/bBY4SSut2L6keS7ttIAe38uHmyjOC9JPG2AwLv5wC2BGRF8/NrZK2v8EN7d3jPEdRmCIBHlNnQjqhOrEgeSTOSgzNJkTyO/7b/a/lqpPRxtg6Y1GPsq6ZYzuGeK/VJlGWS0JIOeo2m/HrrVzoktXOj+l8S0aFa5zzv0dxsCTqEfDCe88ePv6fmpSi4LuxRB+EdZ0mf7nEAuOs97IkqkJu5Vr1Pt8rNdHHG5VgpPjAvFYct3UHEbn7qu7DCpB/3sIrERL5lDaAsjYylRqfGuhbt2cWHla42kaGvT2C4CRoYmI0ahCntVHd2GISqVobpqEBsaom2kcVvFjfjv7AiFcNi4gVUu+E1rUnl16vgafHwWzgtMKI204buddVvi9WsFz0mfjWx/EX+xe3x0Gc8wSApm/Q4s7tNVdgzQQUr6asx7vxPT6l9t//b4PHm/JLSA4GBHTkFHIH6y5DY0wAoW6fqjw1RpsGwT+zIQLAYKZO2nW2YBn5yCRtTvWujhQtwEAjUHVG1yzGX6rpZTYd1/lSiz6ilD0EOlsYAQwWtD6xqoNC/ugMcDFXSO6XN2Vn1IFP5b0NBfFV0kefQ4zok7L/T7+AAWgJIgmXIJNXBlWjFuL0CzNyDvkkKDgsXT10VCg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR01MB6329.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(110136005)(8676002)(38100700002)(38350700002)(4326008)(66476007)(66556008)(66946007)(54906003)(316002)(33716001)(6506007)(6512007)(9686003)(86362001)(8936002)(2906002)(4744005)(7416002)(52116002)(508600001)(5660300002)(26005)(186003)(6486002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?b0C0fDolLP8EcVKFg66boGghZKlT+LZFyq3FY5rXJT1Y8o/iAB2eaaGzU4pM?=
 =?us-ascii?Q?JeI/mKfOgM6N1AWKMIt38zUlawznWdY/GYVYnJ0gSJO/pvWCI++YhU68nCDj?=
 =?us-ascii?Q?yuV/w2bDXsfz4lMvW6QqWI9LpURknvwtcItPjx7eYAVya7GiZ3k8dFUjeTDj?=
 =?us-ascii?Q?3dEzEyVssdTagfaxya5ZUXvj9zuevZNJ9ANm4ejHQxqNZyBnzZYFcKTemy6e?=
 =?us-ascii?Q?LtkOt2EtJeETuTqxWQU+4GXno/jLZxBzeAHWEOxfQSEuURjuTARJZ8E143QV?=
 =?us-ascii?Q?x/JaTKqRraQ7OjusVggaSDrDz03SAjPlcVVVsiD8frvueybVeR1xMPFDqrL9?=
 =?us-ascii?Q?dNVS8qCT0Mkj2ixpIR8DxSiBWoOvGytWNF2B4lzT2eCwgqQ2xP4QstDHnr8V?=
 =?us-ascii?Q?3I4IWxgmE0tCiTS/cen0rqLQwv3S76zLYMdmVYy6bGuMC4cHxC1h1KtcUVA4?=
 =?us-ascii?Q?u6c8cgt7/fWTOErOaEdhNOKY5Nm9if1x5BVkzhKO72hz4ciCNtjjCFLO+p8S?=
 =?us-ascii?Q?/DCVJLB1ibsSWdKnNMCBbAZKxZMM+jJMChkAw9sIanObIoU9IAjS0PrTLcko?=
 =?us-ascii?Q?kLf9OEiKRllD4XvAeyzLstSRiaO2CuiQGQ66sR2CKQfJ3UN7TITBQ+Munmmf?=
 =?us-ascii?Q?a6r3plFUX/e9RhsJJlnBEi4lm5qWe8DZvC72RwcePmwrvHIpCelbhjUjSJPU?=
 =?us-ascii?Q?SY0FLy0bPsR9JMKKJCsXtyaiJ7ki0JpJOE/eFS93ZsHNK0r0C8IPHuNP3zlm?=
 =?us-ascii?Q?9NmH16lPghc+slfQ4HmPTezwUIGqxSVpcK4z42mufgl8I2WKJxdZ8lyiatEl?=
 =?us-ascii?Q?eevDf+Ah5mCRIZpvdMoOz5STcSSbJY4MrgQoBTt9coFHPqPhiLM4OqEfQ2BG?=
 =?us-ascii?Q?1mogwEEe5JeKavY9mm/OIqXIZYAIIRHTxa2IasqtgrK6PxZnV3j9Jrm8B8Oa?=
 =?us-ascii?Q?5z9X4X37Yw9w8KAZGJ0cM4GNacfVXE6BBqfKGTD05b+5ikb/8GtpE/FIJsog?=
 =?us-ascii?Q?0EkF5K0Qk3jrEJoxiuMUJltXZzoBOxXQHAlrX5QTilp9ju61VBNdALeNRARC?=
 =?us-ascii?Q?kvH6467W6sQjdn9jW6UN2EFewm0FJyMt6fs9nvgglhj7x3k/EzccYI06ZZ0s?=
 =?us-ascii?Q?56HUyA/wO2165fnW77EYWdKPW1ZVTwJ3o2r27GbLzXVevSru+8OfM201zPjv?=
 =?us-ascii?Q?Qno52n0WQXKkj8CW4EWqQapC4mwAeiJhvLFfzD3CBBwNeIp2TU1Rt4LOlo/e?=
 =?us-ascii?Q?v0Y90O000mJGxbB2IzAfm+p0hG6wHWat4X4zV5Rhxj14Mt/8aCq4GqY7kwow?=
 =?us-ascii?Q?3D6CQB9bG5D42ZxB1SwR0L1WZfm805F9YNzERNXbYnTC0WMe0enL1YDObDDh?=
 =?us-ascii?Q?VlFVLBtSGjwuEQr8MPwTg6DG/CmPgPYCl9n5Eu72ruZ5w1WK/Ac7Q4srx5iN?=
 =?us-ascii?Q?nsIw/pq8PoclJMqcrYt/YTdEMlKHnsYh36BOvpPZbFR6v7/aRP0C/IQYAzsu?=
 =?us-ascii?Q?lZR0gRjTcblz+zzo4ojpwNNDGrQ+tgiOrX7BGrFYZWwH0INDn0QiA0ZGuyU9?=
 =?us-ascii?Q?Bk2JNGsAJqw3jT9JwakHvhWwQ0zT95xGDbNuLE/ECOAHbOZ0FQBoynmgFcSE?=
 =?us-ascii?Q?n0F9SbWBm29rAWz3hv2HUc+6ikLtypv4iFctktXwpc7H2FssqP70AVEj5TrQ?=
 =?us-ascii?Q?TZN2XuRRVvuIGQv8OOPYfbC1Ka9hdudMHa8qGu6n/32eF+EWMOPIInt7brXM?=
 =?us-ascii?Q?9yMq59MWabTvhMf5v1u3Aqy8g+PHQli+jErmGhmSaQfF69cb2Qtj?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b9c9e2c-7557-4ea5-e550-08da171553a5
X-MS-Exchange-CrossTenant-AuthSource: SA0PR01MB6329.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2022 15:02:39.2885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2V+xOLG4KWDPO1GjS3o5O/FuZbnHrONxp7N9AN3CkhAuSvzD5G/s/qltQl/zRKFikbpnAydu865s0mhSPW6P5ixw3yIrHc/QLUr2CvBTp4FkzRYYXmfOZWcBdpZqLFiI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR01MB4978
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 04, 2022 at 07:29:20PM -0700, Darren Hart wrote:
...
> A bit more context on the state of review:
> 
> Several folks reviewed, but I didn't add their Reviewed-by since I added the
> IS_ENABLED(CONFIG_SCHED_CLUSTER) test since they reviewed it last. This change
> preserves the stated intent of the change when CONFIG_SCHED_CLUSTER is disabled.
> 
> Barry Song - Suggested this approach
> Vincent Guittot - informal review with reservations
> Sudeep Holla - Acked-by
> Dietmar Eggemann - informal review (added to Cc, apologies for the omission Dietmar)

Dietmar responded with his:

Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>

-- 
Darren Hart
Ampere Computing / OS and Kernel
