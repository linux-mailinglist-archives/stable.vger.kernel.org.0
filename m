Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 178534BBCA3
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 16:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbiBRP53 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 10:57:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiBRP53 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 10:57:29 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2046.outbound.protection.outlook.com [40.107.236.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F0B5AEEA;
        Fri, 18 Feb 2022 07:57:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L3Nv5UaHpvrxRA9MWwjNusEm+wJEEH9G5XS4rj1QbMuLRRfdBVHAtmMvu3hFeqQ8a7GwdvoENDZ1ZyTMd3OXb2RT+pgeTm3QAGfMD1c8/SHhM7s8NGjugv8WT4YZx2ftF+qy9SSSMQf2L6j9ZRTwk3h5H3GgJBe3xttxgk2J7Jx3PMyMehAiSm6FyK8RpQFpaeUnEtfRvk8Hdn4zVQFMxeOk+0MbazuOfRnJ35Gd1iRMVPer1F7698DXfpje+f0qIrGjMW8b5lVIm/6oAzTsrppPaZUjcG5jHMPlTi7Ja0oAAzK0t6NL012Xy+khUmg7zjTNH8C/crZUkJBaqWNPfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qJCds6hKj7BXlsq0XJHRV3qOitiQ5VWMrcDXe+v+rts=;
 b=Cl3AYa1QNfleN8gjppXa/t8F/A6gzFi5PIqK0CcP5H1sOraeKJDOLEt58e+hq2Fs559ZYWmfIwsy5OI2elgvIRwcHx+X/uSUDxS0RFST1HhXXpTcXU35C18PWWzkLiLOa07elub4Ks4L1JtBfXCUjIdrAds+BCRaNNam1wQq7hd74Q7yKtTRNqfZaVRlDOOwfkAECP/teR+SbU0OnpmkDlAFoKJgavVj60jxzshyL47hgDgyVi/ro8Ps5O8lZ+hfkPz/lYkE2+cia5UWwkzxIvWLjBgqbGcGXw8H9UkuBzl53fKWHSgy+BAY4EVOuVYAj28pzh1jHTbWqgWlwUDtiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qJCds6hKj7BXlsq0XJHRV3qOitiQ5VWMrcDXe+v+rts=;
 b=PeaX1GbRXXKYdISwjnBHJATO9EXxZmQaXUjyI57e5ebwZqTfHhVwBzRAmqvIEg8Dxlt/puanQEWcJVeqAQAsdB0bQb54L5Ugy9gFuz80BFvwUdtWWzqKnBuVUnUgvHHqsez3OpLt/6n3d2jHm/mPGUP8dA7KOv/7r0lqgD0xy0MZWsVhawSu5SD5e03JS5PAerP3I4vZZtUtrDqckpMDiKXOBmOOGVgSfsCQc387NUXwqyU1nGoMSN/KmF8eLbMQxqxWViIwn3RvhDwldE21kKj+68jQF7l03VkNhIgK2hINIZh+JCD2pDsi7mjvnWW8PvnWGu8CWthNvZeUCUby4g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by SN6PR12MB2656.namprd12.prod.outlook.com (2603:10b6:805:67::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.17; Fri, 18 Feb
 2022 15:57:08 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%5]) with mapi id 15.20.4995.024; Fri, 18 Feb 2022
 15:57:08 +0000
Date:   Fri, 18 Feb 2022 11:57:07 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     mike.marciniszyn@cornelisnetworks.com
Cc:     linux-rdma@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH for-rc] IB/qib: Fix duplicate sysfs directory name
Message-ID: <20220218155707.GA1583594@nvidia.com>
References: <1645106372-23004-1-git-send-email-mike.marciniszyn@cornelisnetworks.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1645106372-23004-1-git-send-email-mike.marciniszyn@cornelisnetworks.com>
X-ClientProxiedBy: MN2PR18CA0026.namprd18.prod.outlook.com
 (2603:10b6:208:23c::31) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e7288447-7359-4f78-f981-08d9f2f75130
X-MS-TrafficTypeDiagnostic: SN6PR12MB2656:EE_
X-Microsoft-Antispam-PRVS: <SN6PR12MB265687F55567552D238DE28FC2379@SN6PR12MB2656.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 633elrlaWoWlLMn6teNo51LXO5RKI1Rk+6HTReXBsN9mEvUhwf6OOvXO5k8QWIO78BeHO/MJ+Kg4MiE/2IGFn4nF98Gb0hIgj8pq3euioBHGHOsbkmvhbuJMqiUfkKMjf2FJX+CF5R9ayo/eKLdSJffT+M7yMO248dpPOgTYeLk0VQBJs3l4K3ak8WmuBmdk9acyviTSDQIj8HEBbAmbxlJVCVKJjF8hrwfq95aV+6DEO++aMTCck6+vypb57614Kz+SuNx5Nxm0UCQe3grN+hlwezYVIUQxXYS6u0vudJD8FKJlbWUBEaw3h0Vb4uvkygehV6COtf4zli8qiZAAUoZbb+mQ25tmeh8SUbTnyWn7KsYiRm3YpOyFTXF8910VY4tIrV+rg/J6pxdpKVc8jfjjZ+LqLtyUyif7e7W9sIyvRI2z6ZiZkmQh7mL9CffMcXdICpp9wzuiQ/GnjJuJfXn7hjfuT/lRYXUgZ6VSNuieKychf+SNwbW3Af3Lqfm13yuZkQLuNB02sIVOs/6L0upGyfc2IVOrdYRWnoXeEU1jn86/Hy8CihO3zIMBfHd93JrDEFkx/wzQpVvk8KevV7es4X/4j5WRgArzjjVnkrIVUJ+lrwdK9cSDAZSAxJ+FubXkQLdwPNcSc/JcmWsU1w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(4744005)(66946007)(8936002)(5660300002)(6916009)(38100700002)(66476007)(6486002)(86362001)(316002)(66556008)(2616005)(8676002)(4326008)(1076003)(36756003)(26005)(186003)(6512007)(2906002)(33656002)(508600001)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+XIk0c38SYBeZr6cp7bgAI4aWBH2GTNu+nmL1SU3C9DsIqE6uGz0E366MZn4?=
 =?us-ascii?Q?NfdEbMsSzcRkK0yQ0f8wJkPB0NPsxUvUMlSP1A6A2AldvE6pMjfMgyvl4SlB?=
 =?us-ascii?Q?zVV7uOWvtBwPAXirhqpoa8V9gGV8IkQlktHc9uMwsOA1ywBaXTPCWwPQxjXW?=
 =?us-ascii?Q?mC/jxdH6dTDhbQZaILWsq9erAsLX13ld/t3rA1JrvzbwV2PXEJBhv1yzLGKZ?=
 =?us-ascii?Q?nql2hTpyXZFxjlDEeUMQHuCIJiHTainJfAR+qXDTSnk/K6buyAbtd42nRhzj?=
 =?us-ascii?Q?x2WS18lKsVOK+H+aZ5t3XlwUVgdqDAIaDHJtqRbsjTnAMsqpPhihivzTc6na?=
 =?us-ascii?Q?LCbijytv7dhmyPmsQCPpcqac5xQ33fAhYrinYjJyX89zPipqsdPHI4uIBCeL?=
 =?us-ascii?Q?veaWJlmtjVP5pIEaU8v25VUltwme9qzQcPJn8nUbJnEsoD7Tfsp3FgOVjnY+?=
 =?us-ascii?Q?224du47xcejP9jngkhoumi2OzAWgsyKLr/oC/MmUHcxhkn96cLoHO5OzaVPL?=
 =?us-ascii?Q?nQnB2ub58mmbtuPpYuvdl98ImYF5pTbTzucnB0/4IIEZjdZKDFIAIbvXvnpJ?=
 =?us-ascii?Q?a69O5hiLDny/o0DUkXzIY+gga6Cntm93dpK87nmJ8+Dje3GDtmKOJrNhr61D?=
 =?us-ascii?Q?e8HZq1b/gAD4+BQy5hM7kjFyYiGG30JXuhj0WDSBm8UVXNlKAczhViGfugyv?=
 =?us-ascii?Q?fQkFcSZ8XjuhIkZgTMSZLsJgIS9Fj84ZXffmdnfmkB+S5/y45/RP4AHVBEF8?=
 =?us-ascii?Q?C40Y75DbdXzoaP8XARzMG77gCvrFD4cnhaesE30+JAG1nCjKIL9wOMpPbEi9?=
 =?us-ascii?Q?hzWCbHgSoYMMKmikRQDtMi1exIPnA6Qfv5BgaS41Q8+ijsW1gR3NSxDpEkIi?=
 =?us-ascii?Q?n7ENIZC/pMPudo6QSYcaeSQ9bpwuemj5rwnsq3KAhruaj+vDutq+fOzymYhF?=
 =?us-ascii?Q?vheV/qurovDIR7hEoj3C8lQgRyX1SZ3rPfsawPmpcYvseK0S7YXCR6arsvME?=
 =?us-ascii?Q?dyM94a/OqTmnS1G0hAxG+bOER2b9v9YVVSOjcG14/1izCX+ex3EjX5+Gyv/L?=
 =?us-ascii?Q?DIwEjvk5R5/CM5ksOUP3lZcmC/rpiE+pxWBGCON/YAuipis3zpgfYH1CmTaI?=
 =?us-ascii?Q?JeEk7QPlF59FgP1A9+gFY9DrNqMr406h2NdNQ1KYPSDgBMknpmVeJfzL8JHe?=
 =?us-ascii?Q?Ce+g9suQxCO0slrt2oJO/I+8Z2hel00RExAvgKPbqjwZDytzZDONZf6VU3Y/?=
 =?us-ascii?Q?oxX4qO/RZDmWWycb3RxuuR9GswHeuNiRzkuNR1oLrw6P4NeuCzXqDeqdSfNs?=
 =?us-ascii?Q?QFcHeyq/fZCKpaZ/mFT/v8j7ns5hq3i1qlw3Xuaix4euukX+EKMfDhZ5hpCm?=
 =?us-ascii?Q?yiiiJxKwCgpJOiiF27Z+Wm8zpgPfp0UqReaR2A1If3j4BbNILfNV0sfA31hP?=
 =?us-ascii?Q?k+ZeTJesXaetjb6vlOe+yJTsGFC/Ns7GioNmZVIx2DL4QZQmE/WWid0p2trE?=
 =?us-ascii?Q?vMh0hnHHjRyzvE6Rzj0aj4cg2J08JV8aS7OTmVjUMXDzrRLmGp6M1IOzIh4M?=
 =?us-ascii?Q?mEksThoqityUTdyIVAA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7288447-7359-4f78-f981-08d9f2f75130
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2022 15:57:08.5612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NNRP+Z6HGozNGIf5CUC1IbgGzgo0/FPkdhkCvvkqw2JDjnTFD5Owj+REIw195cPT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2656
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 17, 2022 at 08:59:32AM -0500, mike.marciniszyn@cornelisnetworks.com wrote:
> From: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
> 
> The qib driver load has been failing with the
> following message:
> 
> [   21.186138] sysfs: cannot create duplicate filename '/devices/pci0000:80/0000:80:02.0/0000:81:00.0/infiniband/qib0/ports/1/linkcontrol'
> 
> The patch below has two "linkcontrol" names causing the duplication.
> 
> Fix by using the correct "diag_counters" name on the second instance.
> 
> Fixes: 4a7aaf88c89f ("RDMA/qib: Use attributes for the port sysfs")
> Cc: <stable@vger.kernel.org>
> Reviewed-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
> Signed-off-by: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
> ---
>  drivers/infiniband/hw/qib/qib_sysfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied to for-rc, thanks

Jason
