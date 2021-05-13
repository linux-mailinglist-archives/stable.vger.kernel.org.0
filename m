Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D886F37FC7A
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 19:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbhEMR0X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 13:26:23 -0400
Received: from mail-bn8nam12on2056.outbound.protection.outlook.com ([40.107.237.56]:2816
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229877AbhEMR0W (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 May 2021 13:26:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QPOY/9JmkieURiQUDF3Fmy79M3KVntmvLcnQZEhaM0LyNotO5KfdqE4nLsE7g4wCnDbwq0wMYlebeSu+yg5PiDWwCzizZ5pckVmcv9H0loNrwzo/FsQytAvAsZ8/g8k6Le2q+lNxO1nKwUbjDwPHgv32rWH8F0G+0UhSmO1rTgCM1G8LBOrbJC/6aKo4oMJBUSsy2p+rZLR4AxeD9+0LUGz0YoZNAMtpRksxvgwF1qCzZCFdcoYC5gywl8vGyzcJpz1QNvmsPWdlRb/GnBKiaq9DkiV0tRNxUz5Y6BsqX4hqau2eUKa7Sb1tpdbnoeYOjGxgnNzPvCEcZ+tU2RD+bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9dsDbQR4wDIlwT7Hxrkn30Y88BIvCX+SUzfIJ5k/wpc=;
 b=IOV5nao6dYLsyjnPrzzV35Abt2eIgGWRurWuRdShH+gBFIvaAXd7G8l0fe8XfFjZ6SSjpF5KNK+nj13WscZSTvAQocLi2sbRDWQ1DuJOOTBx/ZhWHaMC0cafvRzshfK1gbUVm0aMV7ls7jWhSZ4fqINNTOe6tm/xIPoFcBfdTT8gIXCrJiwz3VZSRxv/NtZn2woMrTKJRex7HCv+0NZMtX+raYdnmdJOTWID06j4pgzRghtBTmWC7/EUJzmJ8YEVstfZyhhzpFdJbivjkboMvG9fXRJYRGUqxQN9Wud1wfeWjjcjalTNGFJLOEVvfA/Dge/SjZDjQAKSjOIx+u/2NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9dsDbQR4wDIlwT7Hxrkn30Y88BIvCX+SUzfIJ5k/wpc=;
 b=HX8zlrY9xQ4SdfS9u967rCKypgqbfE9xloI6aNqDLln1TIv3czzxazkxZxkYpeYE/GC5RA2ufNxp/3DkCTjm5JKXQITEWlIwsj0frXKE9PZRzYjIh+j8xvtn5NiW0zcNzz+I45JMXAJ4Jz6EHO1vr0IxXHC6Hr1w9vycZu29ebhhC8pHwGcMdCrNzM8O/hx6jP/7wNbGuEWIx2JJxZWHOhZp6z9CgR51v7YeI9R7uH9f8Gr4BTchMrNMTeNZKZMtHHP+ygx01xhcD+tZwQVcvm4i3x4Y/IQ8C6CmpbXeB87YGmVKp7RqpFIjrsx5dnoGkxwoeLWNknnQCHY4LNa7RA==
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1882.namprd12.prod.outlook.com (2603:10b6:3:112::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Thu, 13 May
 2021 17:25:11 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::ddb4:2cbb:4589:f039]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::ddb4:2cbb:4589:f039%4]) with mapi id 15.20.4129.026; Thu, 13 May 2021
 17:25:11 +0000
Date:   Thu, 13 May 2021 14:25:09 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        pasic@linux.vnet.ibm.com, jjherne@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        stable@vger.kernel.org, Tony Krowiak <akrowiak@stny.rr.com>
Subject: Re: [PATCH v2] s390/vfio-ap: fix memory leak in mdev remove callback
Message-ID: <20210513172509.GJ1002214@nvidia.com>
References: <20210510214837.359717-1-akrowiak@linux.ibm.com>
 <20210512124120.GV1002214@nvidia.com>
 <759f8840-671a-446c-875b-798dceb10d0f@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <759f8840-671a-446c-875b-798dceb10d0f@linux.ibm.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL0PR02CA0094.namprd02.prod.outlook.com
 (2603:10b6:208:51::35) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL0PR02CA0094.namprd02.prod.outlook.com (2603:10b6:208:51::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Thu, 13 May 2021 17:25:10 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lhF5B-0077jY-4m; Thu, 13 May 2021 14:25:09 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c39a81f5-0550-4d0f-cca3-08d916340f87
X-MS-TrafficTypeDiagnostic: DM5PR12MB1882:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1882DC03414AD56AC0A85622C2519@DM5PR12MB1882.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YYI09951kwkJuxM1khmm97hGz+ZqiibcJwlXIzn/2tg1t5jYMBpARFeWdQvWSvoRc1NJw00cj9wbPi98HTCBJ1hut6bhNuGMjEpuOGihbIdsJzbCnnH1XKVScOSE8aDBOTe7QsqtAE1zuL+uBJRAJG5EkyIRWQ9IQXEsHQxPDzCoYfEokvgCsQxMXg1Vq1qd8HV3brTeIrgtdtQf9gDpjP39qQpm1D9knDYRUt2zN6XVItjH3Dw4/7C9I+AfQLSMdbsrKWCuzI+5dEphMYWhsMFz1+1JUL6B+/VBCW9hh0TTxAAjVzVyvqEUTOf4wxrikUAr4RAWjIFBK3ViR0s/Vs4nI+e2qw1PgcMq6lYoT5T+ZSwfOjfrWOPlX4HneMldE8PE71UlCpsIHhyH0Vrpb3sNLvR/wUUrkUmKBAcPCFwJH1J79LvswP8Jh/Vws8DMuf3t87q5NOgH33FlPfoRP6vY1bRhQdSuCteSGmJdK3fddojRSgJxa/t709QQPz8wbbH7LeDm93RHOdZyoS0VjKizkVxsw2e9hawblIg1qpLguh1/rENA5LReoZQbv7h1dSI2rHPb4atSCDk9zKbdQdufwDOuwyODYxQgI6VBPis=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(396003)(346002)(39850400004)(376002)(53546011)(66946007)(1076003)(26005)(5660300002)(316002)(9786002)(36756003)(2906002)(9746002)(186003)(6916009)(478600001)(86362001)(83380400001)(8936002)(2616005)(38100700002)(66476007)(66556008)(4326008)(426003)(7416002)(33656002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?pWokFDLxIzqQCbfci1cjF0LKmbJGBpJZSlqPTueYO4JeCke9OuChj9jhKTpZ?=
 =?us-ascii?Q?QvUv8TqTbDSY3HXGjRlGuIruE1OAQDwqfB5lqZcnbOVmP+miOotDyInWTuu6?=
 =?us-ascii?Q?LLfsdoOph9YkK2xFYEjVf92YkPN1B9iaO0e6eMFTrYdkN1AM+OAQ1x62t2qZ?=
 =?us-ascii?Q?WC50guQA4yO6xoXqoBfx6RIIQywV19ZfD6iL6500ESBFc57TlmpKakizQh6L?=
 =?us-ascii?Q?sN5Z5baikkZA97s/q/rnrxc3ncZEXOvPcZc3i6VnWrkaIRKFvKagYbZmySBI?=
 =?us-ascii?Q?O5HH3OakDW0Xlqkj1cE2/HXYmPweF5PC2/WsFcGWgLIGn7pW8BexLtHq53jE?=
 =?us-ascii?Q?i8rKEKCBAowlH147qaY+vRcVB7SqjrEqabNodH15STh89UItkbDJW2Ei6lc6?=
 =?us-ascii?Q?mxtLFNAr5+TXWHqcXeHzWW8l8SGvF0lGnQUFxP/kArbjqwFc/4WjeWrgGg9g?=
 =?us-ascii?Q?5nSMuMQLMZQXchfBNkDcABNb8t+aMsAh74VqnoTVZ6cqobMuyRtg60XLCniC?=
 =?us-ascii?Q?IjplPdvrT5xnYRSdMsbwiINfKVPpGpcS9TL4EA6ETZYpaM9o14eXNi+mJ2B3?=
 =?us-ascii?Q?JM+cU1g+ugSqV7poVqwrB/hH4b4DkTHaHkm8N+DnCpjOHwPJt4QXb4OOZ6PW?=
 =?us-ascii?Q?SVVF423+AWN0X4OuI/m5QYqL5+Q7jwxWIpyVfBLzQzawVjs4Ui+caFT/nPXD?=
 =?us-ascii?Q?HcCzqlrrK2MSZsj3DOeQqatbQEpAjYMiJGDgGT6WBTfYgXJCXgocQoTkreWG?=
 =?us-ascii?Q?6QZMXYKkUYXE06KWVA/Fy/D7PjaCxOqTORd3HLcR+K2oWVgkeGTJYftF8yg+?=
 =?us-ascii?Q?JMfKxw2cDJpt6Xlu/0PdylcQQH3tcmLO5notLuEZxP7t/F54UnsZIIAKHZPu?=
 =?us-ascii?Q?Dpo4e8jHol0n/zeQ/5/zBA/bbyZvQfUdsubRBgsXDSdiFRwvJK0C7F3WOOk9?=
 =?us-ascii?Q?IbnwrDayuqRdBXrfhvnEqQ+5Rp8xRD1lf2LxjhfI7C9tQtNmqYcyyfxO/2yl?=
 =?us-ascii?Q?SqF4pQ3NTfR1hLt5GzQ6h3K5PXCVAj9nrYYm5/WvMme16PoAVeKkndADTMqu?=
 =?us-ascii?Q?6cT8kQlm86iTOboYR5WP8f3xfBAfFvtoEIrSxC5NWJG5J+Niy/Mci3P2qNn9?=
 =?us-ascii?Q?dMBov2jsz0bKdeSbi0ogKHHNAivqzRe5855kr1YXBd4xNKgTKLG1a9CNu2ke?=
 =?us-ascii?Q?2Z6jPbdqcDSRlJQ3+JtTKWt3j8njYKiJUITtE/9kf52Q9mijN40GhwQjs64v?=
 =?us-ascii?Q?rme0Hwhan6+J5ktgkhgcGRKVx4negoyfOxD5SM2APpevFaFrSEQ4wrd7b23B?=
 =?us-ascii?Q?3KfkwvLQwsKj43xyVvSJFk70?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c39a81f5-0550-4d0f-cca3-08d916340f87
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2021 17:25:10.8601
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pl+yeHjJ4u42+s5xPyWwvK+nqMTcS4UCZxn+55dc5mjLxwRS6YMBTbIFGuyUHt0x
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1882
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 13, 2021 at 10:18:44AM -0400, Tony Krowiak wrote:
> 
> 
> On 5/12/21 8:41 AM, Jason Gunthorpe wrote:
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
> > Can you please ensure this goes to a -rc branch or through Alex's
> > tree?
> 
> I'm sorry, I don't know what a -rc branch is nor how to push this
> to Alex's tree, but I'd be happy to do so if you tell me now:)

If Christian takes it for 5.13-rc then that is OK

Otherwise please ask AlexW to take it

Thanks,
Jason
