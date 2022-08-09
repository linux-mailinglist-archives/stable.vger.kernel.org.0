Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5314658DFFA
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 21:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345833AbiHITPQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 15:15:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343776AbiHITO4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 15:14:56 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2041.outbound.protection.outlook.com [40.107.95.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C35A6DF38;
        Tue,  9 Aug 2022 12:07:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z/S5aenRtlOyrf2w8dRZfXrF3zqwQ4SpCRfHHozWvbRidDWeRSzaEPWL3M/MMqi20wUPDdAhU+UiVQ0HCU9347JLGaxdnZO09IrukhPinxPlWQi4rSrB7wJAIQLOV4etEWRZh8utHorr6nZMJvXE/6OjBXZLpoEol9Mk9NwYo5sm3mvNqp8zzUSdVHVsRBABK1gd2I5x1K+rYimrTsEqpvVn8CTj7cToYc9Uzfyxqoa8/jEQ58gvaKCOc92vDZIve4J9eYFkVyY7hnDXY3dUmA4XBlZTMAkSCU7OFBM3i8Z249eL7ptgXmJoAUuafCQ3tKUqyilaSt0n88DF5rK7Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=37wsUngQZ4n8yhdqTmNQbosz50HZR2sr+27obxYQzIo=;
 b=Ka46d31iKzokqrysykR+qBukNFK1bmVyleaI1R56WEx1dNcHsTFMP3C+lb/4tL49xiMc/Vm8/T5IFeiZfe/IXkgle999nUZCuq+nYDbaF3FKRW5ZqW4xlV452/qdNksfR5+FpjHGkshbWRvEuLGUMl2jEvm16p+Iyj8MfXvbyz4IFNciwzKpKgIoZWc0+BbFcefmaNx9TiSjZsl8DQBIXT2AbvEUesInUPsf3kggAE6Azjy/hkY8IiLGAHPsSBKqM0duRpZjKXGgKcAHzrKRiF1/cWUn+TlpNgh+xQTO6TG66gIhVBzqWcYEN0vj/vpu1SZohY1/EDff8JWEmclyng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=37wsUngQZ4n8yhdqTmNQbosz50HZR2sr+27obxYQzIo=;
 b=tMcMGqeA4JSx+qN/GFIfYTEMy4IwbIzGEYIZXhbkuXIK3Fu4fkFkgkH/12SB1LhqwarvDUchAcABjJ83tFxtlg7FeQevEEw+4NxBcldq8wP2QaR4sdn5dmgzR+z2YcAk3YDa8YRVAvhe1/7PrYMR8Eq/XHhIpNIBtHpxyV/M6CpyzPC2FPbXRqt9BYgQeO9C8Uwj7V7nbYNyMTQAtnLxrpNxErEZmIfDzp1Mw4MM1gk3oi2i80uxnXO3vmyvj6TFEMy8EKrRpwyc73FdkOD75CxA7ouu1DdpHNWCFiUCU9L6MofVK+ifCFp1zkn+nl9AyZR1B2RUzImvx368E5lfgw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN8PR12MB2849.namprd12.prod.outlook.com (2603:10b6:408:6e::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.17; Tue, 9 Aug
 2022 19:07:51 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::1a7:7daa:9230:1372]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::1a7:7daa:9230:1372%7]) with mapi id 15.20.5504.020; Tue, 9 Aug 2022
 19:07:51 +0000
Date:   Tue, 9 Aug 2022 16:07:50 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Peter Xu <peterx@redhat.com>, Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        John Hubbard <jhubbard@nvidia.com>
Subject: Re: [PATCH v1] mm/gup: fix FOLL_FORCE COW security issue and remove
 FOLL_COW
Message-ID: <YvKwhrjnFQJ7trT1@nvidia.com>
References: <20220808073232.8808-1-david@redhat.com>
 <CAHk-=wiEAH+ojSpAgx_Ep=NKPWHU8AdO3V56BXcCsU97oYJ1EA@mail.gmail.com>
 <1a48d71d-41ee-bf39-80d2-0102f4fe9ccb@redhat.com>
 <CAHk-=wg40EAZofO16Eviaj7mfqDhZ2gVEbvfsMf6gYzspRjYvw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wg40EAZofO16Eviaj7mfqDhZ2gVEbvfsMf6gYzspRjYvw@mail.gmail.com>
X-ClientProxiedBy: MN2PR05CA0059.namprd05.prod.outlook.com
 (2603:10b6:208:236::28) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d1374db9-575b-4ef2-16d7-08da7a3a74f1
X-MS-TrafficTypeDiagnostic: BN8PR12MB2849:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2phV05//P8AXC8u621/H9WafFTcdkFVK77lWTcn4pVE7VncdO2Rzy7q4bHewpHKL6s/8eqJ+L1dFqdMaEpY4VuwtKHWZLkMycZChRzPFVLrQ+2WWPMp9mzJ8Wu7KHXR0QZX4uvt3k9Gb3z7iI4nIQAywfx+iUshseCPwjCmK6aPIIIOP5YBuja5UrOVXbviPzckCItaWh1otRLGfkIeARMmiiucM+Zjq4HkdqDZuqOuCqW5g7YqxDfEyiG27fQoKzMJQVMvl07Lhc4jQz/ozifLLRilo8mMeNyID9ARtJ+otRspNILtRX9bBXPfDuhFnBZ/Fpfj4j0HD2iaBUB/HTyjbR+wqcelGEB8nJb3wV2EdqM9rpjksaAeENerLbmqYGaqYuARASENrtWHv5faVYZ1QbgHcssqt5MCAbV9gootba4XT9crOjMbT/w1h0txVwY2apF3Fe2pTAamkIQNODiZdHzp5Itsn1plkgd0mAH24NgEvJQJrdgZ3xVZrMNjMsCDhIc3C2vipdAQjgeawTaRmYRSw+LflTM4mn+RQ5hEJkiNZ8e3Yoz8D81qzTUQ3YhRDzZhsqxPTuBgBOKMJlCHP4HfvHCREfSnb547CS4EQAiSaBCnhmn7epjxWcP/e/qKXuGR21l9nD1XK3Hve6acYybGgXT1pAPqum9cDPMG5avcWpEAKfch87QGnMclBg4vA8MXWkVioZPq7DDF6RSfPovrlHDHxbty/Vygxvh0soDGkxtBQKpTaVprbrWEH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(136003)(346002)(396003)(376002)(39860400002)(4744005)(66946007)(66556008)(66476007)(8676002)(4326008)(7416002)(2906002)(6916009)(478600001)(6486002)(36756003)(316002)(8936002)(5660300002)(41300700001)(6512007)(26005)(186003)(54906003)(2616005)(86362001)(107886003)(6506007)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Yvhh6Jff/mbq5KuuLTUE2KYIAuZJJsgLO3EepkfCHdMdZiD3S/wJQzS90smO?=
 =?us-ascii?Q?LgXNyQ3ip5uRFDO/upqGcevrsHLaTZRPO/ui9gZ5pX5sbXaysDU18awA7yyK?=
 =?us-ascii?Q?DjNu0J08yWzG8DTMnzRO95fucJ4uzoZSHlJ8/Dnrr7zgSy9tMk41EMVg6qze?=
 =?us-ascii?Q?sybe4U0smYcgHKdA17nHdlh7doXqIq+TAs06NPoMfWi8p0H60MSjGFG0E85c?=
 =?us-ascii?Q?VWEdmJZjcdvOhWu615SrMbk7xK3vMae2F5YIkwIy+pqcFOsNlpSoRa2cE0S8?=
 =?us-ascii?Q?hzmBeCW9IQcRG/q9X05YyIBt7cN3+YE1oIoFqhe9KveScyps0uTFcA3mm652?=
 =?us-ascii?Q?dD1PMefTOxlUAYQKvSEPL4Iayai8eJXjNt/qp0oqa/IRbXe1RhlYnFx7Gf1n?=
 =?us-ascii?Q?l9MDNTFeRM6xBTRIKXzO7I9sblVIqGKJOObketfuVZ2mdoh+o8nQyE3FXUm/?=
 =?us-ascii?Q?8bGJJGl/fXTK5T8qscvvaFJdMxJjAS2fu9PKEgdO/tLFAztcrjdFHqpNpBKY?=
 =?us-ascii?Q?f+ZpB66jbE+0AZQLiWFVU4sGHDCKq3/AbkJo3MftvjbFJUl6mJN7JLP21AIn?=
 =?us-ascii?Q?p15AEtxy8nNY99hZ2gOGmIdlOcbJq7GfbtWVMGWK7yJTTLX1w0xUtaGsKd8t?=
 =?us-ascii?Q?7nXdC75LO/eBJ20HI7bkDFlA6jUVd/k2nkZ938XZQ1wG3kbgimNC14UmW+tk?=
 =?us-ascii?Q?+ItmgRV8ne5nLmPyVGHWkWNCzL49mBmvbGUU2ZhRMetVbFzm4filE2/oJyvk?=
 =?us-ascii?Q?c9NvN7xU74pxzS65jkJ4pYYEHSVEaO4gJn3y875qkhbKfAHm9G20eolwTDCT?=
 =?us-ascii?Q?mz+Hdenv6VPhnpUg8Xt1kTzNPshuvVLRLvWrjU/PfZSINVga76nAMfTyfiFc?=
 =?us-ascii?Q?Bh6vAVWfUKfkL/IXH5BSyXrE3xNbX9br2K8yOFOsYDZA5r+bOzp6m0w5poV7?=
 =?us-ascii?Q?AFGbaXepFMrg7ugcIut3vDwJCWlsKWycDioT8/9Ew66DPbHeD+4itLyvxBTh?=
 =?us-ascii?Q?0oRNpz3otJInjKGLnW7YCqmcyNcOnrV4SgohcBKV03AcUuE8hOcvqLqq7Lw8?=
 =?us-ascii?Q?AJ3xhfIRgtMvQPjq7132liMO6VSIXupdB4gWPN179AqexdyL2V6tk7YJLi02?=
 =?us-ascii?Q?xybbISHQjbSQMNNEcjR7eGWWRl1xW4oJaQ7CKadQfqbeMWMNf8V7bNe/8pPN?=
 =?us-ascii?Q?bhZBifA8tCXUgStejPSMdOBZi2R1zZgrHlu+3KOMC4f5UtkymLIEBSW0qKtb?=
 =?us-ascii?Q?wcb80jIwmnaLZLYPfnwca1r85peIUmt4cnoYUIyD8xaf7EpFQNG/ccAxBXek?=
 =?us-ascii?Q?q8mUHcxWOguEezcdil7M2hYldozMoNEVvFRB/yV6ogHUBV0bfLnK7EHc5qcl?=
 =?us-ascii?Q?Cs7o5q0abRpJle2cztAUYLLnrwSLzI/AegO8j7CjIXRS8lgzOOdNdWny9v3q?=
 =?us-ascii?Q?16q3JiMAKEiacBUCDWR5hQ0fH82Pu+sBgQ8Wl6KFRe8wQ2c4H5whUHOzmxRl?=
 =?us-ascii?Q?51tBljBY4krj9WTLRZKzTqKJsyTadbVVTZrl6c4wW9+RA5goGvss6SEFF/ei?=
 =?us-ascii?Q?douzMOP/Cwnr//T23ABpVWQGcwY4Ca/iokDLZPZW?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1374db9-575b-4ef2-16d7-08da7a3a74f1
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 19:07:51.7494
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UthIFdQfH+DnmKIy5kcj9EjvgJmNgVPZb4BAT5kA/5bLe6bVeetfHmBgXDaY8UIZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB2849
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 09, 2022 at 11:59:45AM -0700, Linus Torvalds wrote:

> But as a very good approximation, the rule is "absolutely no new
> BUG_ON() calls _ever_". Because I really cannot see a single case
> where "proper error handling and WARN_ON_ONCE()" isn't the right
> thing.

Parallel to this discussion I've had ones where people more or less
say

 Since BUG_ON crashes the machine and Linus says that crashing the
 machine is bad, WARN_ON will also crash the machine if you set the
 panic_on_warn parameter, so it is also bad, thus we shouldn't use
 anything.

I've generally maintained that people who set the panic_on_warn *want*
these crashes, because that is the entire point of it. So we should
use WARN_ON with an error recovery for "can't happen" assertions like
these. I think it is what you are saying here.

Jason
