Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD4D61F9B0
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 17:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232474AbiKGQ3L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 11:29:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232632AbiKGQ2e (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 11:28:34 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2060.outbound.protection.outlook.com [40.107.102.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D41F2610B;
        Mon,  7 Nov 2022 08:26:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NtxdFd1oC7kBu8PN2N1IT6+YcqUvsnFsyqE8dKs1jexBzyJCmf5LY5YsUKKYWhT4ACsX++xUe8Y4SWKYZyFGwm9NfBj2p+UZ1m7Pg2e3zmrrWTtfl+lEDF0fWDffLL4P9zIM2aJSNjCQSNuwbxQdOr1YdW70k32gD8Iz5EtTIZR1rVR5+UcpTMqY2ftYlWI78eOKsbYX/gOEeMZHdw9FhKizbQgokE0glJ1gChrUGsTaam19UyTeBBUakpftJSMDmNfTj5Ba+htcNohewNUSJ3ZWFkZfqF5k6BMlu77hxy7QxnsXU5K4gaeX6O/11JzsgNo+wWXFXv0c+WPvM5xqGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5F5C6m3BXbPOlQHH5dbTuOAZnyfEJHPpk99LMR7OYDo=;
 b=HfLmdqhPWl0Qo0Xp0iS2Mh5VZR6SIRwphTgN8MqG3no02WOQLjlicBvvZ+9hhtMg6Ul5z5rjBQuEB+r0QxaFzZcbvuoiPfL7KIMlESG1S2rrYHnglb/3+twQMNWE5vG1zDSJko++i+rVJQv5SQL1aSFfIn5qvS8/S9prc/n2zDkhVBLmN5P16kwsdCLQRGGPUTx72RRRHKBvPe+jRXg0GJZnNXWfyugkzxXlDSVTM/cfF6qv51DujapCFDquYHG42+p5E+lqgnxLUKHssOZnv6QugPycBlSGxCBdL1bw6juDsgNMWxEVj70ew5sviEUlCrP0dXBvCuf6Ul0YD86QuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5F5C6m3BXbPOlQHH5dbTuOAZnyfEJHPpk99LMR7OYDo=;
 b=n4trIcouhjESDkjyzYKtq/1w0zKq3R/7aS+BN0bwh/b4Y1uE4UaNXrnE9EIe9NIbuKrQ8wnpiYniH0mlQ6ybDSlA0exdkzCsFlP6S0COIsvuWsv3KCxLjl2xzfrjb8e3mkkjmY5D9L7d3Mk8gqrRMKas241pbrZckKUdD4U+sAs+RuKTLzTscrQToHotqoO2jTXByI0xvSd7hkZAV+hNELdfSmf101SRZO9otQbxk2F4s8n5VK2lbx0sCcagOBqE8B4cN72hJKIvd6THdqOd94vAs6GMHdF4EqwNirSFoyZeNhIXa4CJBgUl5kr7RAsnIJwOY09cxwoNZlF05WfdGA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MW4PR12MB5626.namprd12.prod.outlook.com (2603:10b6:303:169::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Mon, 7 Nov
 2022 16:26:22 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de%6]) with mapi id 15.20.5791.026; Mon, 7 Nov 2022
 16:26:22 +0000
Date:   Mon, 7 Nov 2022 12:26:21 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Qi Zheng <zhengqi.arch@bytedance.com>
Cc:     dvyukov@google.com, willy@infradead.org, akinobu.mita@gmail.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] mm: fix unexpected changes to
 {failslab|fail_page_alloc}.attr
Message-ID: <Y2kxrerISWIxQsFO@nvidia.com>
References: <CACT4Y+Zc21Aj+5KjeTEsvOysJGHRYDSKgu_+_xN1LUYfG_H0sg@mail.gmail.com>
 <20221107033109.59709-1-zhengqi.arch@bytedance.com>
 <Y2j9Q/yMmqgPPUoO@nvidia.com>
 <4736d199-7e70-6bc3-30e6-0f644c81a10c@bytedance.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4736d199-7e70-6bc3-30e6-0f644c81a10c@bytedance.com>
X-ClientProxiedBy: BL1PR13CA0446.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::31) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MW4PR12MB5626:EE_
X-MS-Office365-Filtering-Correlation-Id: 7aa3efc5-5a27-4357-9579-08dac0dccec0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eC9BhDkF2RMqN/Y8cadS1RMqxMtCIGk7oDi7aPxHteYisO2OhYTrZZDiCAMjIUmHcYPDWM6QRdPQei8bmreK2SPL31eO6F5fiAWwJ8rSlzB1VfZ87BK9pQqf8XFIHiqp0Yi42epnO6hYDvdCdI8Q4cjBvCZkUnQkbP203KtA06YBmEY4UgwoVOqJnSXsfabgGOehMeM3V4ot0XqC+Z2HSyEKleNQtZJ6qDA4Evac5OoJl2sCUFxmXmoN+cfrKGV6q1ZzRedv/I5nmwLm0zzYG83g5A4JsjAPqEQynM+tOvDqUEzqnaSg+DMusYktAIN/jKW19vLkpkoU8eHEAOVE615Q48+cM7IWFA8NfWG10hEri+PrHz0DvQ20+fjz0cQ7i/0dv7HJTnOYFQdk4WbnplXpm2bsW1kgNrqpI4EdIaUqvW4ln/wfPv2Y5bwdsAha7pJQzRLDc+tQio8ZKw2+NlD3ctzlPMePUu252GeiUqQ1RM8SDkQSQzmsGdJK9YgVgodu2xKfDPbEoKWmiKEceIeFTWtclwPD2+2FS5O5Exc0iz5xDLA828wsfZgGE0w7aEpJeeHEXpBWsTQFrJXYuSNDr8g9/qAZssZJ4EBM+cTzyHGKmaxjsRr2jt12yfCsEYgHnCNbRZD4QbDDYc+3MqmBtPYwbzDcx3MjQRJ2+NmqjnBId6djdDUuAcs7DWdPiZOCmjC8LedjgsDdehlCzQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(39860400002)(136003)(346002)(366004)(451199015)(2906002)(41300700001)(316002)(66946007)(66476007)(66556008)(8676002)(4326008)(38100700002)(53546011)(6512007)(26005)(6506007)(36756003)(6486002)(478600001)(4744005)(83380400001)(6916009)(5660300002)(8936002)(2616005)(186003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8WVuukeEm6Vr3LX4BbHDFKGkdy6N884S9hbC8q2ZgawxNNa+6ZmbgAvDSi4i?=
 =?us-ascii?Q?lj9CpwaLmNpgbCgXAibQMzQXwO8s9fflc37l2/qnDXyaaqjj3SlMNfV1sSiF?=
 =?us-ascii?Q?/HwZ/MeR9VcS0Uc9M/isG0BcYq3OfEA9Ga3M6qgp4SRBCV4uez1BHaoa6EEM?=
 =?us-ascii?Q?Y7q7hk8l0b9atIh8rZ6ZpWUIHNiudYAu+w5LC74ERGaMm+B9uR5KgLWLtP0W?=
 =?us-ascii?Q?T6eJ6om8uZjXVsL0ZO/kbs8S/lnekwgOOjBMfjCTcT5UVb3pLswNOx4aUmMq?=
 =?us-ascii?Q?78yWUKRK1aGAsHOVIozL5Rr5JHGdYIOWBd8h09DEOFXvbEdxYUuzVHZKvJas?=
 =?us-ascii?Q?oVLCU81/broOY4YqVHW461eVZnKDvOE0sao/t4yyRUQ5GHpD+nviJQw/wYmx?=
 =?us-ascii?Q?9zusVIKGL8lCwZUmwpIiwss0fRg2F98rCoK77cI+tWPiSzHgMvthLjmJJC+x?=
 =?us-ascii?Q?qudfh55BKZuZHplsMnxPpwEduHCtikU0tgcWX+UB32GBpg2ROhRkwTB7gDxP?=
 =?us-ascii?Q?ig2oUj37hXrczcdTpQtPG3S73CaOYIzM5KnfGp0fxiUhmpShFS+H/QyUGhsE?=
 =?us-ascii?Q?eFo+SXYYm4DCKniwbSnZMlyKPTJKCSburH7NrIJyEKLeC5PLyHpyuLOew47z?=
 =?us-ascii?Q?wrWsXCc5nOg9CpEksbc2uoPQW7pZwfy5RBqUl4DYvzI7RI32+otCmTaI0oPt?=
 =?us-ascii?Q?rPYjMAFSAIt18yXGtJsDZKD9wGlgfYtcD5+wQDBvYUnbgcmVMOVe4sOuBj5F?=
 =?us-ascii?Q?K9dn7a1M5KOJTWAAyyctcfwbgdqAWfsT+ro6xwA/A6ZAQxZG59SmFJbk28Cn?=
 =?us-ascii?Q?xP983MTtkHiDPXZ/NhOzFAlScWykp6QvY230LgIi2wt6UE19pWzI6AYz99TM?=
 =?us-ascii?Q?iGOD+4i6vH1DFkXP06ePxSE9zjsFHT/kFH27DykQvZuMConv2xFfJJtnE6sW?=
 =?us-ascii?Q?Sx+4LM5mlVMRm+pY5jfxcb6sHMky9njkAV7WQysdHbqnqtspL1eV9eK1cySJ?=
 =?us-ascii?Q?/f/Rt6LRbN0lR3gxTf8Nj/NKqjefbSggRTrMTn9Vi8/ma3ezdPFDbm8Dk6td?=
 =?us-ascii?Q?uSLHibIAlIOxMJfvM0WtEl5V59YCAI+tpY5Vz5NH1gsuDiG04jArbGrSabEU?=
 =?us-ascii?Q?Glt+Lu0OR4C9GBVj6fuXdryDjhGzjVVNPoPbg2Tgy8pRoV88HHBMgV8Dixk5?=
 =?us-ascii?Q?B1gnZRLiTXvLZC9DLf/+YdmXZzTJbSi+7t3WiRMCs+VvVE7+MAEoDbWj72z4?=
 =?us-ascii?Q?SPku336HRd/bNKpGNV3ElzFYCn8PNeFOO1+KCxeJGCWNFwkrv8fhDzgNvIkL?=
 =?us-ascii?Q?/Fj3wpg+vDKEbeoD3jjhaCz7y/8fSsvaoRnxeacOK4Uy4RmHihFGIzmiQgjV?=
 =?us-ascii?Q?yNoQzEqvB3WfBgK0nCKdGPLQDYnizYDjdVn2WpfeKeY/adzirKtYwDpGURzF?=
 =?us-ascii?Q?HGWkDSzyPL/6XjRt/9txlSC7fdRUHeCBTvcbxNIH/Kzrn/pZnZhWvC0escNo?=
 =?us-ascii?Q?q0eS0ZS84Lm9fDbbVymtidWInw0zJQHkgy2YLMGyDCwEZqoMzC/C4NtjTOGB?=
 =?us-ascii?Q?VC5EhptfJykNmvuQkcw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7aa3efc5-5a27-4357-9579-08dac0dccec0
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2022 16:26:22.1348
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CFmf2C+O4Of7ui2rzqR1QLMsoR+VH3A6MWEMBOrBL99pkeamSoabEfYLtJRZ8IXg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5626
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 07, 2022 at 11:05:42PM +0800, Qi Zheng wrote:
> 
> 
> On 2022/11/7 20:42, Jason Gunthorpe wrote:
> > On Mon, Nov 07, 2022 at 11:31:09AM +0800, Qi Zheng wrote:
> > 
> > > @@ -31,9 +33,9 @@ bool __should_failslab(struct kmem_cache *s, gfp_t gfpflags)
> > >   		return false;
> > >   	if (gfpflags & __GFP_NOWARN)
> > > -		failslab.attr.no_warn = true;
> > > +		flags |= FAULT_NOWARN;
> > 
> > You should add a comment here about why this is required, to avoid
> > deadlocking printk
> 
> I think this comment should be placed where __GFP_NOWARN is specified
> instead of here. What do you think? :)

NOWARN is clear what it does, it is this specifically that is very
subtle about avoiding deadlock aginst allocations triggered by
printk/etc code.

Jason
