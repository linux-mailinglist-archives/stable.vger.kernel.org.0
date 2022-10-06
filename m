Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5C8E5F6540
	for <lists+stable@lfdr.de>; Thu,  6 Oct 2022 13:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiJFLfL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Oct 2022 07:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbiJFLfJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Oct 2022 07:35:09 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2047.outbound.protection.outlook.com [40.107.223.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 093964C600
        for <stable@vger.kernel.org>; Thu,  6 Oct 2022 04:35:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AOy62DkGwjD5YSvTc7xEarTXfcIbsLaQYhU9D6x0R2g+JriHu3mvbqpcDhNsTCSi8Q0Y1ZTMBg7iI60MNLlvM7zTNsNvCu0EiPV3gfjKAk7Y9i4mbX3JJ27nhZ5RyNHH1THRbyhd6v+YYb2Yu1IJw7WOb8In20eXgTBebIYEO/WIoHDphQ73k85Ajv84dxgsMkpoRXicrGXQ0v7dxjKx6u1G3vGQVco9+RbUsYcSpx1m23ekRGY18exQfBh6urNCXx5+Lo5LKbbe8xV51oBklGl9iQD5Jv5gbLH7E0sHhxVWq70UWCqZvWLc/6VFHBLzR3ruxPS4u5bzZEoHNwTadg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fcfIM00QPfTRhYTaM9uLJRgY6P/dRoibROfUI2DuIeA=;
 b=VLVVNIf0lXXItOE8GJOZDEBxZpH/2xvEY83dJmlubUGBieQhV77h9sSmddavNh4YWxMGOUkBSijZrlbekTjqPbbpqFlGuwGS8Nzky3GLr6eYcgCTbeKQVC91KJNv1cuiOnccWL6qmtEY6CSijsFWL7byxlG+kHUVbJXRLrxwUS/k7rG4548uRrI2+MRPBFOReZGZucQ+bfPjIguKLymn/3bfG1EWo6+vTbKZMyeJmbZeEbOLVitkb5vtn1wPR8iJonfkSXDdO99+RjtWH7UkunOrY8S2sdAg6GOvi0X65DHi5XPuehZZjFvcQ0Iqj0P71TdAak1CGS5y4aeWxwwKog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fcfIM00QPfTRhYTaM9uLJRgY6P/dRoibROfUI2DuIeA=;
 b=q4PjWk3NpdWUHy4wr0W9TA4rpRo5SY+RtDw4rkAaWBgxqCLWxGX5SB0BIxM1V/Xri2yuMZwexXKwyDMOUucwEQ+YVUDLq+oJampCcis2Pg5qkMiP7VDcpoIcqjhn7GMwROU/w5H+c7wxJ6JbrH1ICWHh322Htt/MKzq6pRim6ad6Tgg8B5yM4aZHWeqQURm7QO3TeMjGOU4dY9RYlBMhGGZbx87V//T4ng098LmD86PA+axeDUZDKoi/dUnJg+MMWDm8MoAZ6SQAn4CpKHkgSIZ9Zh7YITvtMXgzKJ7mTyzOMaJMJJvb19RJiekjMG37m1siu6g0XDV+WD/iV6+gWw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY5PR12MB6082.namprd12.prod.outlook.com (2603:10b6:930:2a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.28; Thu, 6 Oct
 2022 11:35:07 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de%5]) with mapi id 15.20.5676.032; Thu, 6 Oct 2022
 11:35:07 +0000
Date:   Thu, 6 Oct 2022 08:35:06 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org,
        Zhi Wang <zhi.a.wang@intel.com>
Subject: Re: [PATCH] drm/i915/gvt: Add missing vfio_unregister_group_dev()
 call
Message-ID: <Yz69amRXgm5ZTKrg@nvidia.com>
References: <0-v1-013609965fe8+9d-vfio_gvt_unregister_jgg@nvidia.com>
 <20221005141717.234c215e.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221005141717.234c215e.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR15CA0065.namprd15.prod.outlook.com
 (2603:10b6:208:237::34) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY5PR12MB6082:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c2b02d2-8a38-4293-47a4-08daa78ed1b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +CDfdrc1TsouWCl4WGOuaEWS1GJF61X0Ktw5CRUfqqQ6ZgRHlAt1/swHFAZ/c7y22liKqZl27USv7Yw8IG4l6GLcgH3X0QH5zZBazUOoqe/geMvlp5X/RHLoZ9/vanyj5JoEhBcXU3ZcztSkC/MWEMkziakipz4I58SAcYXS4bMmo6+QiOgErFnkWSbAtICaSi7TN3iGBY6lU1xCdgYIWqcAputuS1clP1rEqftj8GqTcuBzMIExWSegElNEfo3pRYcGTlUk+9hapAGrqni6fa5awikUYtpGOjUCeBArREcgEcyP7cqz4Ie/VinxO1sg+bOP+qGcTQEYHO1ao30nwvaFiJ9g+my4xP0n3yf9qa4v1PQ9PKXcQgS9GdspaAHfQBVwyEQ+fXfh2B4aUuwhJ4k1NvQeL5vQCqKNY+9405MK+6wjNHwlAANNYtFVS38f5xEMdCYHsQ56Vg5doYW9zNInXKzNYEA8vISPfmly1q6QRLUc5P4pV0uc8zfmeqEFoPp0/hHe/Jl918UWl2iC8oOJDev7u4ysjAPBdq/qM7ylhTsmZAD6AO4xRwF+dMJFctjTci+Mo95H2XAuHH1FXia2Jr+OJUGUHP9GoS/OoS4/MZiINdR0fE4Zo6RfKzNgkso/G8xtA/t+y55sKjWLssxlOPkiPluCZyq358x1L3j8rVrmIQy5zZDe7gvtOBfPAPknyyen0mZzadKlOhgvSA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(376002)(396003)(39860400002)(346002)(451199015)(54906003)(66556008)(6916009)(6486002)(86362001)(4744005)(41300700001)(7416002)(36756003)(316002)(478600001)(5660300002)(4326008)(66476007)(8936002)(8676002)(66946007)(186003)(38100700002)(2616005)(6506007)(6512007)(26005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KwgGvUpw9wnJ+5aDaBDFa7NLLZcrno3nMKW8mGtmhoQef6R6PriVtiohFcDz?=
 =?us-ascii?Q?9WloxLW6sidT1hDPU46oINHiCsEAn6Y94dhI5h4Ku6JBWV8l33U+Rv9OqJpr?=
 =?us-ascii?Q?kEi2NCzRJGXnqb6DjWDS/spjgAJkMnX6C15DOwCymvBR4+UooRJ9jx3i69l3?=
 =?us-ascii?Q?3OjyPL9XeQBkHLfw4LO21kkvWSoWqe2lSeGvg9EHHY7TyIWDbTxuOe6SE2uh?=
 =?us-ascii?Q?/chQmzaJqpqFvjr6/hzgQTQC2yh29vjlnXEckF38ciAB8vCtLWN5dUH1gEy0?=
 =?us-ascii?Q?+/5Md3BBpz4bH1yKFV0wMpcdagaB8jW12z7BlF1Jf2DWvRjESCOg9QlS5uKi?=
 =?us-ascii?Q?qvCTrLWiBLTCZbwGIaLDJ+gm0WwIv8RRNrM+q6DDgndwhe1PK3OZ1It47V72?=
 =?us-ascii?Q?ogI+Mq1BHPztetlcXOkQ1QcFmtJTsl06rMaTHY9JBdtqc/R+MkeKiQtRNrzP?=
 =?us-ascii?Q?KHAvU8C/IgfE9kVPPxBsuOWIt5R6J7vHkCTvWDlUUtQRmzQW/NChbQ+QZDC2?=
 =?us-ascii?Q?5/Q4fTbUoWUKVtdD6/FSGh2GVV/k4YOw1QhFsZcOzwjAA1VyUKBzqetuQQOW?=
 =?us-ascii?Q?TopeHClMtEx/Oxcn6t4ZWvkd0JQJLPxnWKt5vD7DIpbCfUtzes/1VS8Qn0Mh?=
 =?us-ascii?Q?fGksv30YPsPfzI1LFNMJOuPmV1dKoBaP6+V/FdHt7nMPp2W+8dWFihfg9j6J?=
 =?us-ascii?Q?1HyYxmabtBqNEsBjS6pIeu2j6pUgm4v6sQyf3yLoGoZNqqRSvBY/8HxLe4zv?=
 =?us-ascii?Q?vrXVe4ViYGoEDVd8DIptGehFKaF2gc3c3gKux28TPvEQAO1dowKtufo8m4Dp?=
 =?us-ascii?Q?uPRpcR2KSxzKOLAsKp4q4kJ3RiKgXt1xPFAJ9IFjkDAS3nAeqAHO+TO/10UC?=
 =?us-ascii?Q?nRvI/L/RC58bzYyMi+eAqj4Xf27ESMotRfASSh6BrVun6xM7mKyl2HX1HQDT?=
 =?us-ascii?Q?3x/eivfsQvSZeXIaBfvwgp4h/OfNW4kbwWNF/443SN3z8kYXgQ9xG1qkw0ek?=
 =?us-ascii?Q?pPT1sdtGX4DzOPrQOUfbBQ7JyksYoA79ckxa0+15N2O6ogtfwh/9vGFbYdJD?=
 =?us-ascii?Q?m40VQPYGYpiYmcrPcWD80llXrhcElHnFPjnjqHRrTFvVxaS1yn+Mp8yCJs0H?=
 =?us-ascii?Q?wIwBOabWIQktczqp4CMC6jKXhC9WRjcEpZW9F+sHHxvVtoriMxkTHBUCHYN2?=
 =?us-ascii?Q?8gstfXoZNAfqh/OSoQzcFk8PSIWf56LGoK3taoGltMHTIMbLiM7lRxbuYR6a?=
 =?us-ascii?Q?rm9U3buL+u9/AhJ/9MIw5KCEMaBj15T/NONS9ECShay5BwxGS/RZbtBAv8jV?=
 =?us-ascii?Q?NkOoPmM0tDZVXHtTgoNw4N5aEWZbXDQEeZ1dAWIxgTPJEUtfmdE3NaeIJ4CO?=
 =?us-ascii?Q?BSoUwvOctPWXCYlFuUeXl4/0ADV5jRT30tbd50H7rtTemDLmZjtsyUd+EmHC?=
 =?us-ascii?Q?T+ENczTM0mldjdTkOW6ebWB6BHKmeiAzgpIH+7VGNgTAw9zpude2jEYFMCek?=
 =?us-ascii?Q?ZtknPl56FJe7mm5DEqblhx/ESgDO/2QbBuOreRUjapD+O1RG7DI9NRNBYpnX?=
 =?us-ascii?Q?X9CiYX53dvl5hsarcjI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c2b02d2-8a38-4293-47a4-08daa78ed1b5
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2022 11:35:07.2953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QVDHQGKykT1VdO1j7Rd0rlCvUwQNikWxJNJFaTiv9vgAOvFqqBYuj7/vqOpnjr9j
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6082
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 05, 2022 at 02:17:17PM -0600, Alex Williamson wrote:

> > diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
> > index 41bba40feef8f4..9003145adb5a93 100644
> > --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> > +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> > @@ -1615,6 +1615,7 @@ static void intel_vgpu_remove(struct mdev_device *mdev)
> >  	if (WARN_ON_ONCE(vgpu->attached))
> >  		return;
> >  
> > +	vfio_unregister_group_dev(&vgpu->vfio_device);
> >  	vfio_put_device(&vgpu->vfio_device);
> >  }
> >  
> > 
> > base-commit: c72e0034e6d4c36322d958b997d11d2627c6056c
> 
> This is marked for stable, but I think the stable backport for
> existing kernels is actually:

Yes probably, this patch won't apply so if anyone wants to see it in
the stable series they need to follow the process to send the reworked
version.

Jason
