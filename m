Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFAA537CEF8
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344382AbhELRH6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:07:58 -0400
Received: from mail-dm6nam11on2048.outbound.protection.outlook.com ([40.107.223.48]:61665
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244922AbhELQvj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:51:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i8nQWcAz3p2C+mwaXv7RyMNa1y2XjnyGW2HuMbcj/lbPxSI13A954M8LxvurmeKrb3wdwp4eH5osFAgNg8EW6BohT1TdDaZChErpATrqDVq3eouts0gbQruqInVVeYhnkDDxV6CR0zF80Y/s77Bd9UMjqMuUIaAGL+nEX/bxOtgKpmbMhfpTNQEBb5JCPW0jKO92/AT+vdNQFAfA0Y0kMMPVpTv+pCM9X51t2+TVQw5VpWJN6yabSj9IhP0A6tCTqh81SjllQtylGadCYiKzv9JQ8/U/ylaXROlUYBM2Rhi1RqezD7R3t05y2Q6rrWlU6BcbISmSBKpg0VjzwOFNUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vjo7WrkxyR4VluWP/TI+J1L6gnPN9SBiF1Yrl61ljTs=;
 b=Rff3vN6UKAuxLtE2sB0wDBnOgsKkK2WWNicO+iSb5rlpZpsAo0hmUwEP/JRw0iADB7lJ6XEV78o/GcAWkvxj9VoAH1r8K/VG7Uhlvm4obnhafU/WNyOktu3LDRwpn5q+GCR55o2bvf6J20YtqPeR8qVHioSA4Us29dbyty/0VqULXDjX5P9PR0Re0hZvV97G7cqvyDidMmSIDQP6T6fpyUBuO74/zHw74QALHIFQlPw3AcAzTL7Vni1y8zRzG3CTdd4g/u5PUBfOnU9HOw+qhVa6u/8MCnb6rxPJHh2/AXowG5thiTQGKSjIkg0vQZPzzRwSzL8v2TVZ60feHeVe6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vjo7WrkxyR4VluWP/TI+J1L6gnPN9SBiF1Yrl61ljTs=;
 b=LhhmKHSeT7mqJsUrQOBlVuGFgxYautosBEA/+eIwd5MM4Fdjs1OE6dJ0XG0yWuGTsy9a30SVsIMLT2EzRrxdHuYYalyeNXzmVzx9AcAi1SVolqQksJcCG79brFXVcO5RvRWSBYoOVVJSFbwHMDUr31dcyWIRvVZ4g3ddD9waIsBrA3r+Ur0tNAJ/XA1LK2gCznWipGgV6GalDknWyF4CHAQ9hy1z/v3lNdKT+9xFTTiP/Fzf2pw7dA1ooi5uToWnGEM9ZY/mwQmXSCoQbVWF/WyqMmKVCA+RNhQnJqFmxlsvrD+lUJIhjljUrCWZmJGkP/q8uzEkV3cMe7BrFo42OQ==
Authentication-Results: de.ibm.com; dkim=none (message not signed)
 header.d=none;de.ibm.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB2487.namprd12.prod.outlook.com (2603:10b6:4:af::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Wed, 12 May
 2021 16:50:24 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::ddb4:2cbb:4589:f039]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::ddb4:2cbb:4589:f039%4]) with mapi id 15.20.4129.026; Wed, 12 May 2021
 16:50:24 +0000
Date:   Wed, 12 May 2021 13:50:22 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, cohuck@redhat.com,
        pasic@linux.vnet.ibm.com, jjherne@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        stable@vger.kernel.org, Tony Krowiak <akrowiak@stny.rr.com>
Subject: Re: [PATCH v2] s390/vfio-ap: fix memory leak in mdev remove callback
Message-ID: <20210512165022.GW1002214@nvidia.com>
References: <20210510214837.359717-1-akrowiak@linux.ibm.com>
 <20210512124120.GV1002214@nvidia.com>
 <41f48d58-687f-289c-3eb0-ef4001d16ff6@de.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41f48d58-687f-289c-3eb0-ef4001d16ff6@de.ibm.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL1PR13CA0108.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::23) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL1PR13CA0108.namprd13.prod.outlook.com (2603:10b6:208:2b9::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.11 via Frontend Transport; Wed, 12 May 2021 16:50:23 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lgs3y-005uVB-EH; Wed, 12 May 2021 13:50:22 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cb368267-6e16-41b2-30b5-08d915660968
X-MS-TrafficTypeDiagnostic: DM5PR12MB2487:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB2487FF60E5E75B6DA390CE53C2529@DM5PR12MB2487.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nHcxftJJST1URZGcjNWQ2efP9kcOnObJOQnRxy2TnLIjwckiJ0JBMeG3uN1mqAAM9K9vu8DgoI1xaZHKPlpJo9EKtl2PiYG54rdLAl8gO4UmjzoFpHfs2fpqvralQVD8qUFFkX7dB56I13gMDl3Gw0hImmoSR9lrzomge9jh3NGS8glOEWeNBDIzSFMUaoUH7Ly19DVoWMZiYKPzz+eGPQ2odmcbiERJz9NC8YhUIHgmDYt1h39aLIsINBSwY6SPeHiw24BtrNWswiL8NMG+RBrMwHOI/+HRiO3NQ9Q9tW3D9UjrGgvggooVY+i3EsrczYsBjgItXJ+AYzy46/RCvBSNOX1GAyCLQV/Q/H2Sj3bIGsTsFSemX4WLmaEuWLBmAfhVTRfekZIqlVXg4cTHFGkTOMzysGOd/LxW89ASCW4t/LXee7egzGOHeTbEClFATK+Fo3HCpFNv8/6HRpafs5HrEdaq2gX0l4muKwJyeXNtcmgtLdnwsczUudg6081iWh8qghlQPKK1zBC+9mK0X78brr5qHUHBAV2wNFfOH6neBNDyJObKR8eOU5ecBBxg4/q5UwM6o6Bu3Ek74PjOMtijrLKIafIwubzDp57C1T8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(136003)(376002)(396003)(366004)(8676002)(86362001)(66556008)(9786002)(7416002)(6916009)(66476007)(426003)(33656002)(38100700002)(9746002)(186003)(478600001)(8936002)(316002)(54906003)(83380400001)(36756003)(2906002)(26005)(53546011)(4326008)(5660300002)(1076003)(2616005)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?pvFZWqX/mGQoXtI+BsceT7Xih6Cmwv3cUTXbGMNdHDxqP0lnjV810yVB8HYj?=
 =?us-ascii?Q?GFkDbfzOlF8zaPMsqkpqqzyNi29etrqclM1J4yrWuX4s5Z2Gj1p8gwOrHWCz?=
 =?us-ascii?Q?JY+R69RMRYNQeuy37WcVBjVSyZ5PYWwY7POX1XkiujxrDqLuMzOO1BFOiOwH?=
 =?us-ascii?Q?iuITwo63cK3eWfnXXCVf9aGtT85C/U2+pzWcaBPArh8MNOdleIFRJk0Lx0FI?=
 =?us-ascii?Q?Ut7WCzxtEslBMpc4FGHZITdMbhDQlWxX5oH6ut/MxPJP7R3b6hGrT7/TZg+B?=
 =?us-ascii?Q?ErbX6WNEc206KHxMLG9L48kQAEfLFw8Mcu2Re0/8K80LjjVisD45iFRTZwDX?=
 =?us-ascii?Q?zUn89miKaYrYxXEbnGAy6hlGxEGZ5AQcM7GXtV+rH5onDfdPKtCIpUfBmGIw?=
 =?us-ascii?Q?3LKWCFYtK82q/qKwKyQ+2teMfRBFSYgt3ySd0GbqHNtMyN1hDgE35RDmbFKG?=
 =?us-ascii?Q?t6IT7U09vf7IbLE08gLS0laTQafkqgB4CzV0eEsQaRfYXNMvQMHNmwgrehno?=
 =?us-ascii?Q?04rXY6D896Vq7IaZcaVKAU66wjQFlNoSXUncROvn6VeA8NnxqN+mhtD1oCXX?=
 =?us-ascii?Q?6DwMTW0Mk+ES8eQYG0ABFKOPErvOM3BKBubzIG52tIcG7AoOBZ9XcsWGVilU?=
 =?us-ascii?Q?BQXquurArAV51UJ0Cde0U+zHAy8S3fX0qOoKJam3AbYZzKDCsQcw5lx/Wpi7?=
 =?us-ascii?Q?brYyayRRymL7lSBOB0nMS0rzlGHXLAKXAtgrdcUVEfuVmVm4i4RXEsJBufKZ?=
 =?us-ascii?Q?ty/3tkoJegKgG1lPfIQ+yY6YZsSPmHAdBazyK50SzeESpsHPUzVY5RjrG1kc?=
 =?us-ascii?Q?1Lqyc9gDUhJ1j4ZYMh9uNhQW2s4lsgkLctMfCTgIxztVmRQyP4sZyLQdMESb?=
 =?us-ascii?Q?yviCyQfPrJObLOHeNdhSQV86+8Z2dhGTxkOUi61Mv9DWlnsZeodD5i8V+xcz?=
 =?us-ascii?Q?3l+eSZgkHxoifIMlZBLFSqxlJyWUXKw3n0oBsEKEWBUe+0v1nO00DcfoVtvk?=
 =?us-ascii?Q?RfF3g0oqBe+qEzuOXbi9n5A2U2s37jXGFNfC5w2BVodtkz3BvdRyPu+cpGft?=
 =?us-ascii?Q?sZTY/q+q4khyz8Mmz9rrvyrEByUlubPd44h9ijjlJsqFqtEh/bngW9A6lfPx?=
 =?us-ascii?Q?q9p3kNDETJ+WxH+1ffsQX68ufhUKzm4NI1Ew74QwpIRebk9QQ2nk9fSAn1HL?=
 =?us-ascii?Q?IkrZRecq7AugthefMEM9dR/Lcj/w7wa0+ZBu+NxQr00EbVEoHdnMnz2DF42f?=
 =?us-ascii?Q?oV1zCftmnk01fnsbJKE+pLI4DwP/XFqT2ijrLK7exbGslU1JsUYi5hU1FSEv?=
 =?us-ascii?Q?aZanq2PhyVtTTFbjQnW6gEuF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb368267-6e16-41b2-30b5-08d915660968
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2021 16:50:23.9635
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V9NwWEhNKCCfpYyBcGZ8iVXet0GXfw2ZE7iFa0AdnGKq5ZW19ox/kFfmW3MI5Hfm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2487
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 12, 2021 at 05:32:52PM +0200, Christian Borntraeger wrote:
> 
> 
> On 12.05.21 14:41, Jason Gunthorpe wrote:
> > On Mon, May 10, 2021 at 05:48:37PM -0400, Tony Krowiak wrote:
> > > The mdev remove callback for the vfio_ap device driver bails out with
> > > -EBUSY if the mdev is in use by a KVM guest. The intended purpose was
> > > to prevent the mdev from being removed while in use; however, returning a
> > > non-zero rc does not prevent removal. This could result in a memory leak
> > > of the resources allocated when the mdev was created. In addition, the
> > > KVM guest will still have access to the AP devices assigned to the mdev
> > > even though the mdev no longer exists.
> > > 
> > > To prevent this scenario, cleanup will be done - including unplugging the
> > > AP adapters, domains and control domains - regardless of whether the mdev
> > > is in use by a KVM guest or not.
> > > 
> > > Fixes: 258287c994de ("s390: vfio-ap: implement mediated device open callback")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Tony Krowiak <akrowiak@stny.rr.com>
> > >   drivers/s390/crypto/vfio_ap_ops.c | 13 ++-----------
> > >   1 file changed, 2 insertions(+), 11 deletions(-)
> > 
> > Can you please ensure this goes to a -rc branch or through Alex's
> > tree?
> 
> So you want this is 5.13-rc?
> I can apply this to the s390 tree if that is ok.

Yes please

Jason
