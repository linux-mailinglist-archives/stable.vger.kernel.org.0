Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96B3859BA84
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 09:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230442AbiHVHrO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 03:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiHVHrK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 03:47:10 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-eastusazon11010000.outbound.protection.outlook.com [52.101.51.0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E6A6547;
        Mon, 22 Aug 2022 00:47:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lrtgepj5nf8hwp6DSpXYCiF6rL8lJkWeVKTfjnLiJzxPzQ7sH1ZoR7Qx69QdQAkcR2Mx4TfWui3ug98YkjforDkZvYNMGZa7eyccYnH2xlTfp6Pxy03zgVq4csXRiyf0hvuLqU2hlSinzTTAn6uFfU1IyG6Gg2B1UBmKcoluJRztoVwvgEq6f8uN7lkXDCZlyKNzaZ90Nnlj77XE4j8oFMj15m+iEv3TNS/mBdTnUmbW3Ju67VfkH6pK8Olx0PadT7miJbmwWolFF+1qQX1VgiwWFaaqUzIzuS0PAx3nRol91kkYYKo/ROQ/XlgJw4rPYNV8wj06YbPsELhBRDr5XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x7zyXXBqRo/ErW+hcdXqjdJ9CklJzgiRH2UNItkTzyw=;
 b=cKrCbmPdvwZWejf6IA/mV//ILPREwD8RZAkeKQb6Qc1ftU2nwidOJCs1VYeEy2x1koARRyeaf7xYfyLqVfh7FXL0hm1gGwW64ufTjrwDPI0OAUmMSwJV5Men/OarE5mxAblBcS8NdCE/ueCo7b161V8n1pA0hZLuSIibv9dBYe2Z87Tb4/piJN7O3E3m+0yrxFZXkX0SddL4GjE0CFd0kyAqyxfpdxDw0u/JTzR/ZQY2xZd3k7vYJC3HoaQ3I2sKaCGex9Kk1S0+j03wixOtG6e8ZphQC0seCb3oDe3HXzdFTnDPCxD/OppLeyxlJSD52NLTR19A8oY+vglMpjj8Zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x7zyXXBqRo/ErW+hcdXqjdJ9CklJzgiRH2UNItkTzyw=;
 b=TW2Or7gztUHr54cwXNiTR0yQKZHxgXQ5SAlTPXD4++IcKPq2FoxrS6O8UWGW/rYTml+aLhZAw+yW9qFWd7bLSJJ9jmwBQqxuOaSU6sgpnQGADkuk28XB+ozXrukIWiyLd/lwy4QOBpLoPwzgAwd/s71nfMZe2pKHHHHCuHp+w0s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
Received: from SA1PR05MB8311.namprd05.prod.outlook.com (2603:10b6:806:1e2::19)
 by DM4PR05MB9253.namprd05.prod.outlook.com (2603:10b6:8:8c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.8; Mon, 22 Aug
 2022 07:47:07 +0000
Received: from SA1PR05MB8311.namprd05.prod.outlook.com
 ([fe80::c0a2:3165:1ca9:254d]) by SA1PR05MB8311.namprd05.prod.outlook.com
 ([fe80::c0a2:3165:1ca9:254d%7]) with mapi id 15.20.5566.014; Mon, 22 Aug 2022
 07:47:07 +0000
From:   Ankit Jain <ankitja@vmware.com>
To:     juri.lelli@redhat.com, bristot@redhat.com, l.stach@pengutronix.de,
        suhui_kernel@163.com, msimmons@redhat.com, peterz@infradead.org,
        glenn@aurora.tech, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     srivatsab@vmware.com, srivatsa@csail.mit.edu, akaher@vmware.com,
        amakhalov@vmware.com, vsirnapalli@vmware.com,
        sturlapati@vmware.com, bordoloih@vmware.com, keerthanak@vmware.com,
        Ankit Jain <ankitja@vmware.com>
Subject: [PATCH v4.19.y 0/4] sched/deadline: Fix panic due to nested priority inheritance
Date:   Mon, 22 Aug 2022 13:13:44 +0530
Message-Id: <20220822074348.218135-1-ankitja@vmware.com>
X-Mailer: git-send-email 2.34.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0027.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::32) To SA1PR05MB8311.namprd05.prod.outlook.com
 (2603:10b6:806:1e2::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6d827589-8366-4920-2c3a-08da8412836f
X-MS-TrafficTypeDiagnostic: DM4PR05MB9253:EE_
X-LD-Processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rJXIO/v3oWrNvXd3kndAwiwL99k6Ak+tM1Il4NkI9rTErhHuu5LpMRbXgS3MjoTVEN/1pQFMqqfexmdolvIxwjSTbBJi9fVdUGQZk1C7i1aP6BU0VQc1t/95yjNx9JoeZhP07wPHrrDdLhotMaMqxU+7Ehyf1il6QcK5ydx/bVtW4/wFAvFe1HnV5+Q3+OnmtBiFsShhvTxm8ggtjC83vqEn1mVFJr4ZtLSF2bk1d9eK6W4ZaGVeB/c+BmUVLvRW3cBKCJMLsXox5M/SwB950+AupFOIuiKK1MSbT2yHh1lQmeAkqqTRK7xLrWfyjX4Pz4S9DhC6XKDHIaeacIcIkIiAFHFYSOl3+wmsbjFj2bhlxY5N/tPtqUSIAQ8hD+LGTRNO433nOOErQFOwZbIdYhy0jGGwX1QwHyjRvPCnxFtG/6B54fqxGCzM7VIIORtg6Zd7AJiyVYm2N+OUNPZHHlKgwMfELl/VfG4Zt3lMnPrH44zUIvt24I7w4hjqmECxydMIl+nw6px6SxY4q1qSjis6LMjeVFdMhZQo12v3HhsON9Um0n9ZD7ypyjuqwxERZCp0UUDECCAQwWK/mr+c/M9FD/eZca4v9iqQqLghjCPNgLwXT9adDANwufsxRpxu8a5H/rUZP9gakgen/WwccJlOSQuCKsNOrdNs1hXwuj/hqIraGU73ZxUmrS+5nSTnCi+KG5JR6LoXdSLM09PmlfpCRVADH0CXo8EXXbWvWH4L0zDI/Y0rHw17hSvhy/P+bwzUs08Q/QnGEjmX1SyCt+HCedfcF9q6msgwvloWnvym19EK/ijM5sVWAbjoxceolxYLxziLuqSgioE0udreAg63W968RWy4BPA/ouCYGq0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR05MB8311.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(39860400002)(346002)(396003)(376002)(86362001)(6666004)(83380400001)(36756003)(38350700002)(38100700002)(2616005)(52116002)(6506007)(26005)(921005)(186003)(1076003)(6512007)(478600001)(6486002)(107886003)(2906002)(4326008)(41300700001)(66946007)(5660300002)(4744005)(7416002)(66556008)(8676002)(8936002)(66476007)(316002)(218113003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SDZPUDNZU1BUNWczQlFZSHFKVWU2V3Y0cmNxVzhoNFlPdFhIN2tYbjBwSTBj?=
 =?utf-8?B?KzZQaW5qOUJNQUF6MlpLZGt4Q1kzZDA1NkNxZTU4eCtaZmR4NVFhYTR2amVI?=
 =?utf-8?B?a25haEZCOFREMktXMFE0SEJJWXRCdGpIRjZycnVhWWU5YXA4R3J6blhLL21m?=
 =?utf-8?B?NjdPQzJVOStSUzZiNXNQZjZwTGlTVEV3b0x3UlJBQVkyUjM0Uy94MEhQeHZv?=
 =?utf-8?B?d3NXT3cvUkdVUUVZNnJYVHc4UFp0S2tocTY3Q2lzc3kzNS9USjlUTjdqMGFO?=
 =?utf-8?B?bVZ5WDJGNWpsYmNnNkFNVkVJMDBjMDVOUk9OSGlZYzlUR3lGR2lyZVkxUzRQ?=
 =?utf-8?B?UHpSMiswV0RCR2FjUy9XK0xJSGxUcWVUSnVKbzNOcFp2c3dzZlFzbi9md2JW?=
 =?utf-8?B?NWxEOFp4MjVLTEYyaHRjTlJRRDZIa1NyNDBGakd3TjU5dGZmaCtvck1oRXRn?=
 =?utf-8?B?ZEFiQjNJNjEycXJibGlOSkFMYkw4ZTlyUlpEUFFNQktYNWlIYVZwTkN4N0ZF?=
 =?utf-8?B?QWZ1Rk1JaStQdW4wcmNJeUxrVHhRQmh5ZEpzRVRwQ0l2YWNocWNRYU1rTzgy?=
 =?utf-8?B?S0l3dDQxZkZWRXFvQTEwdGM0aW1tUyt6SUxHNHRPK2pIY1pYaWZBY0xxcFBU?=
 =?utf-8?B?cG9OZjlrNFk0WmM4eWdIMUVJbDdJVFhiclA5YU03R0U3dU9YM1FIckxRckVC?=
 =?utf-8?B?QkdUNUVGWmoxOFk2aHE4TGMrWWFURzd5TXN3QTE2OGRrTWg5S0U1Nk9kaTZq?=
 =?utf-8?B?aXNLR1RybDRyUy9tNXVKR3lpaHYyZk10T2ZqVWc1VzR2MmVtOFNqS2F2TkZK?=
 =?utf-8?B?MEZOc0Z6RVZOZXdSMEVrQVI5eElJN0dSZXNqbDA1OEp2NjRUTUtvdlVQMG9o?=
 =?utf-8?B?Q0FTNFlPQTJYQm9hUEFWU2tjS0NaZmNVYnZLMkFJZU9ZaVB1Vk12YkJaODZ2?=
 =?utf-8?B?MzlCcm1qMDgybHBUYld1RTF2emxSTndkaUp4Tnp4VGhZUEpXaGxlcFZ1QzVv?=
 =?utf-8?B?bEo2Nm5PcUdrWEJJSGVxWE82a3ZnKzYraVJzNGdkcDMwUHMrMElmcGVLdWty?=
 =?utf-8?B?U1dBVDRYZTFHMFpJNjBrZ3ZXcTVXTm1weWw0OW4zUkN4RDg0cDN0QlBlNU1l?=
 =?utf-8?B?d3kzb0kwTTZobzREelQ0NXVndTlQclpTZGFRTzQwcmFxRVc5OXNRZHA4aXRI?=
 =?utf-8?B?RDZSdWUzQXNYdFNnSmpDNitzM0hkVno4djhmTUdha2ZRblY0S1FWb1dLTk92?=
 =?utf-8?B?cXZ4NXdVS1QvZWxMUk45V3hMRUIvTlFpckFyem8vc0N2QTJTQnpzamdhT3Jz?=
 =?utf-8?B?Uk8wVFlUSU9iZTZLZEpSeEsyZlRyM0RjL29Mb0NoRktsRXd1Z0NFYlhXQjI5?=
 =?utf-8?B?enB5UXdqR0JQUHp2ZUFtWEx0YzM5eDFNRVlOSVdYK2hCS1NpWnFza2NqQlJM?=
 =?utf-8?B?T2FoOE9YTkh1aDlGSUJyYnZCazRneUZNR3d5SW1WdjJqZ21nd1dySEwxc0Zo?=
 =?utf-8?B?VmVvb0dyQm1NalU1RDUvZXJtbGZmWWVjZWY5UFFsUTNxaW40Sktma2VQUCsz?=
 =?utf-8?B?blVlZEVGRmRPcEdaeVN1UTN3OGNwRE8xY29NZUdmdzhVMXdMcUFwazJvMEoy?=
 =?utf-8?B?aUNyellFOTU1T2dFQm5IZzYvR2ZVeG9QSSttN0p0VVQyQ3NhamJnb2RSUGpQ?=
 =?utf-8?B?ZkZuYUdKck9xSDdlZjlESjNJcWd5bXRxYkh5L0o5NUhqTTBBcC8wdTZMTGhH?=
 =?utf-8?B?M0pPQy9leElpaGJpWWIvSlljME5ndzRRdzRmTnZCdkQ5VmY3UXFMWWxyb0FN?=
 =?utf-8?B?S3UwM0NacHZNZ1MycS9UTlR1ak9Fblc2bHgwK1pXNTUxYWFwMkJRd083MDhY?=
 =?utf-8?B?UUhyU1BOWjZ6SmZvV1JoYmdocEV3NlVmWnpobHIvRWpZSkRwUVJwMlhRSkFm?=
 =?utf-8?B?R0VnUk1zY0NENGp5a1ZWcmJEZmIrcCs5UnJRaWhveVFrcGVpaGpraFI3am1E?=
 =?utf-8?B?Y050Sy81RG0xdW5hNzhGQXhYWksrdTcrSkd6UFdWS01tT2IxdThycFk3bnVy?=
 =?utf-8?B?MHBwSUhkTUY5ZnhZanRaNGNTb2xBYzhoTHFCWFUwdEZpbDJCVEFRb0R3dytL?=
 =?utf-8?Q?IDO4IwIuqh345aMvIWPzAfgkR?=
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d827589-8366-4920-2c3a-08da8412836f
X-MS-Exchange-CrossTenant-AuthSource: SA1PR05MB8311.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2022 07:47:07.7755
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: txdqbrJukj/ydJPWrwmR+BGSLDN3XB85q/uGC7xOIfpZ119wd7vUx5TTVvP4gP8eoXxvCaoZoUT+HrLD0mFzhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR05MB9253
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When a CFS task that was boosted by a SCHED_DEADLINE
task boosts another CFS task (nested priority inheritance),
Kernel panic is observed.
Fixing priority inheritance changes the way how sched_deadline
attributes are being inherited from original donor task.

Additional supporting patches are added to fix throttling of
boosted tasks.

Daniel Bristot de Oliveira (1):
  sched/deadline: Unthrottle PI boosted threads while enqueuing

Lucas Stach (1):
  sched/deadline: Fix stale throttling on de-/boosted tasks

Juri Lelli (1):
  sched/deadline: Fix priority inheritance with multiple scheduling
    classes

Hui Su (1):
  kernel/sched: Remove dl_boosted flag comment

 include/linux/sched.h   |  13 ++--
 kernel/sched/core.c     |  11 ++--
 kernel/sched/deadline.c | 131 +++++++++++++++++++++++++---------------
 3 files changed, 96 insertions(+), 59 deletions(-)

-- 
2.34.1

