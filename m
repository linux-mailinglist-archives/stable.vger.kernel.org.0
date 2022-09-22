Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6C105E5ECC
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 11:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbiIVJnS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 05:43:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiIVJnQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 05:43:16 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5AA5D4A9C
        for <stable@vger.kernel.org>; Thu, 22 Sep 2022 02:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663839795; x=1695375795;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=EPTpK8gutKArEkFZ81VB/+sNpHO438XhXV6sIgeevvg=;
  b=k0x6L3dJdN04YubMAPieNomIIJgNzQE2SkWOIkO4F+AxUbtx2MN0PPNU
   ashQHRlqeO0jvuW4KauWMMpUegJWMmYFf+4uUYcpYbhjxbIZjLyoUs1+F
   5ZA23pp+bAIbhAnuZYZXYFDaA/wxa/8kWgu7TRzmNMsF/0MSSLVt2PvDm
   CGM5WnVCs7QpC9x+Tsv5cGQTmdc+30oqtD0HNEvvv29UcUEcapBTzs0ih
   ANf8qbsW5+9bth253qCU9VAuOVFjI9tSGtaBytcWt285jICeD5VVKCWXn
   ry3+ghc1x9je7rPO5YHjXNVhl3nmIeNCmtT4+jGV+Xd7C23Blc7CuuQZ3
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10477"; a="301661640"
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="301661640"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 02:43:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="688230342"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 22 Sep 2022 02:43:15 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 22 Sep 2022 02:43:14 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 22 Sep 2022 02:43:13 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 22 Sep 2022 02:43:13 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.108)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 22 Sep 2022 02:43:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UKUn6CNyLLykIpHtw1AsmRpT3UyPrntHhz8AxRVCULQDuzux6g9gPmtRAWcG4wENVVeL8I7RJ8Pm/+8Pw8PJjEVKIgHO/RuX66/TQ5UVB3mdrAQpJV4mzwTJbQua9tGWBZcmupvM7ZWzgVhBFdHdr0scQa1xw494tPs9E8owx9L9Glw9UKEI1R04AHlnLWBByIcFAmkxhapsP20IYhFJnlfrZ5SHEK56HLofqeRNpnzvjKdIioZ6pnXEjwxUQgey1kJOLjq7e0cAhhI+SLlh2wfXWxP6FxucKl5EocUVxAszokshJwqPl4uRREW9gz/9rVyNm8Oo1sOvFwFk4iaQgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5Vd9ss7X2QZ0pELINrEl1Ort0FscnVE7D8aE1P8a+bo=;
 b=d0Ewtkx0BpoyVcxi/IJuKXdClj2bl+7Mddefy+H4uF/cPLB9oZYhGLcb0raJpMiK0cCJaWgDq4qGdGt8L1nFqW+V7zmvqhF6Qszkjvb0CkX2n6qVKGaRlj7jk8kmQHQnpXtdbGgAFXsajZppRoj+NNPaQSxTUhdPPEPgsUyw77iyzBSe703L4DT0A86cNd25Yv0iLDrWrx/MjUGN6G7f4naUorWnRm53JGHDGXLSrbM5TCrEr4S3UVMU3KRjQk8fwDsgz7P1l3V8Sow/rC55QmwuJ0m/WohaKaP9AP3TEUgMj/NaoOG8E41qPzYdP3xZn0r4K2Ucdrn5DJtanQjTEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB6059.namprd11.prod.outlook.com (2603:10b6:208:377::9)
 by BL1PR11MB5445.namprd11.prod.outlook.com (2603:10b6:208:30b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Thu, 22 Sep
 2022 09:43:11 +0000
Received: from MN0PR11MB6059.namprd11.prod.outlook.com
 ([fe80::7ea6:6f6c:f2dc:cec7]) by MN0PR11MB6059.namprd11.prod.outlook.com
 ([fe80::7ea6:6f6c:f2dc:cec7%3]) with mapi id 15.20.5632.017; Thu, 22 Sep 2022
 09:43:11 +0000
Date:   Thu, 22 Sep 2022 05:43:06 -0400
From:   Rodrigo Vivi <rodrigo.vivi@intel.com>
To:     Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
CC:     <intel-gfx@lists.freedesktop.org>,
        Daniel J Blueman <daniel@quora.org>,
        <stable@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Allow D3 when we are not actively
 managing a known PCI device.
Message-ID: <YywuKoAg35X1Pclh@intel.com>
References: <20220921173914.1606359-1-rodrigo.vivi@intel.com>
 <2f318650-b01a-a526-8b74-bff99d5b2010@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2f318650-b01a-a526-8b74-bff99d5b2010@linux.intel.com>
X-ClientProxiedBy: BYAPR08CA0072.namprd08.prod.outlook.com
 (2603:10b6:a03:117::49) To MN0PR11MB6059.namprd11.prod.outlook.com
 (2603:10b6:208:377::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR11MB6059:EE_|BL1PR11MB5445:EE_
X-MS-Office365-Filtering-Correlation-Id: 87046a8f-3e6f-429d-585b-08da9c7edcec
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gcCMIN2+XBWTsYrNwBn0VyLp9XRfrl3rt+guE9d+OuPiQC4Jec/eCUzjv0AxvL+w28HaHLQvnIDGRi1eesdjBOMjEzuuMm3YP4dXo7UbFt52znrbmNDvIsuybvWeeSBZgKpK7qAodgv/b1RMWWKoplC8zKhzhhVJZV1Txfs6Q8pHDwjAFHqaSqioGCsvksBGh+p4BT6bc0PZbsff+YhPRV+P8kZceYOjRL6q1wQ9u+F82pokL1O7jBjuBWlOEcw7bt6oC+8VLNw6KxtFWdYY/YnK2OeN5pmY+Ws4GxXIYCsPca3cZvjgZ4bdJjACn1Lh/RBHuKNaS/awnMkz9DsPQrZPBccPIFsMmsGcF9OrT2n9ZKN6EpG01lcXDUREyxBuqxKnBXYQFgAffTLB/J/xQedqvSEQ1jfVrkTUTv3uoG4p4/2wyC4wJ2teSla/EVIjoAW5ry4idLPFFHqhksXoWDDPgFmwSTAYVvMg+vwC535a5phG7fyAQz2la/DLiMFQAFh3pl3Mn6A0FhSnKn7Aa7zKsu9R4BLWSjvzuZ1ZlJF+lwByHkimflZhKTT4/FK0BZu4/A0lKcDyc3WCiG9w6xcyVmmS3TNoxqQwdsBCJ6ZBNXCAiRAfpPAMtYPIWqdIkLr1FvTqdIrgu6rObnlqI5PyqLcZmi9QrNFyermyv5ufbRuTh/7cFpOh1PQ66YIb1/1IndcXSRx0BR39ZCn/TA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB6059.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(346002)(366004)(39860400002)(396003)(451199015)(6666004)(8676002)(86362001)(2906002)(66476007)(478600001)(6916009)(6512007)(26005)(82960400001)(316002)(36756003)(54906003)(44832011)(38100700002)(2616005)(6486002)(53546011)(8936002)(66556008)(186003)(4326008)(6506007)(41300700001)(83380400001)(66946007)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Wzgplb1B6myRp43mnHBPawIXwsDqU8FhbB2b/JEHHssP+AXx+jG+MF8tHmsq?=
 =?us-ascii?Q?iDFSXxkhFJcxSNCKtT1JBbjxqVn11cCl1MkJoK/cuyZqp1QKjsg8CU0uJ0ju?=
 =?us-ascii?Q?8muFVhrp5VB5LilFrnneY28ZPOG4c8BXRjTh+8ATfXHVx8qiY4z0h9V4+yhg?=
 =?us-ascii?Q?GWGYZmBSIl6tio139RZDUP0xzZbNkW8TlX2T3NVYEfByOfjl7YHqD3fE0LtM?=
 =?us-ascii?Q?c2gHuHiFmJopz11nQ08j23umzHshEkUlXgptxA9XOcRc6LN16FPSmaCcVjp2?=
 =?us-ascii?Q?Ij8j0IZZrXyymR6MakLjBacaZ8L5D8fjSCyLy0k9dZOx3t1H2ddzBoKcGAbb?=
 =?us-ascii?Q?UuDTXgTw13N1ni+vgDEvJCg+ywSSAyg6gb6q5EsZ7/sq6ZCzcU8zCpd1p4Cf?=
 =?us-ascii?Q?XkHOzl2lfa46JKVSxU1hnl4GkOvG7pLTa3Tfr7pRXDv0T/dPLRVgVMlj7k/K?=
 =?us-ascii?Q?826OMmvuyOqACL+hMXnR6wd/SnEV0Cv5ZSH5PnHcv5yjTGyrMA+ST1YiQkam?=
 =?us-ascii?Q?XeM1NwWcGpnW8uoGYF0gpN723szzlPPxqRxtCDlwlD21tynLExLPwZQBZtf2?=
 =?us-ascii?Q?5TnwO2r9EBHbDKOG2be2lT43lgxF35nssIgfPMwOnbhrl+NXBf7QcwJpLa2H?=
 =?us-ascii?Q?K24GYJwcihrps13K1ekAXsskbwLHRPvq4LGC/jFDY2nDwlBJQNUqmfjaPkeI?=
 =?us-ascii?Q?3UnUjvXvlNOJLQF380tsbXxNAPHux+efPsfB+JeGQeWBhLN9gmAz1S4obSdG?=
 =?us-ascii?Q?5cjCqMS7gSxZ+7pFRObrCW82mmp+M+8IloyXezoTiAWpcY1NqPGwJEfKz88y?=
 =?us-ascii?Q?RSoGlEhqzLrP2kBXQ+pF4H3Iwz+7AuZRJRgoFmHir0WvoEzJ4E9PmTQsXDw4?=
 =?us-ascii?Q?xx/cstPnIhEiM5GfwmaeFbT1HSeI3GyqJkGW4OS4zcD5iTUMT5SNmJTxl7mr?=
 =?us-ascii?Q?+QBHToZ9a0VfG7lhoCtSJ2/Z24+bbgeOcPXa1rUeyLnZIfVUUoqrliZv853i?=
 =?us-ascii?Q?bdr9cNsoW80U/j0RkGDqkn5xuS3IUOKQXZB6+O+phN+HnukjmPTi2ovEcAGo?=
 =?us-ascii?Q?V63hi96jrflrSEo/qAvJZ5xgrGEkvI7Ea9rhzKltYxxtCG5r/q6/T4WW5o3s?=
 =?us-ascii?Q?BFyHl0Iz1rvypGT9Ai7hXDLm8qpuTDdUJX7cmIeTeU/CVXtq6PWi+vNqUkJs?=
 =?us-ascii?Q?b5/36cWTdonfQac07lGT6ow61/8j4BaLq+ewHVDXrJHLkqcchUfTeSxaxyFI?=
 =?us-ascii?Q?GJpUWo2KUU8ZfBSze4Q3GJ5FsC9c6Y7YLuiQu9bIXCXT4TRC+nDygLHIUQjf?=
 =?us-ascii?Q?uMPDqY4Zs1E4/3zsBM9QZvaz9ybftv3951enqdgQkM5/1hKF5XnWhw9SstAq?=
 =?us-ascii?Q?ruSP2YZ0dgEYeH+bvGY8+UnSWjkkuojClxhxp+Zy6sL0ukT/udAuP+8fF2c7?=
 =?us-ascii?Q?SpN0YhfjLqL6Om04LQ60FjOLEQHONKqaLE493p6fQ7PxneDsi23hoSzN1c10?=
 =?us-ascii?Q?T8X+wc33hGCnQUmyuSbTXP09UBMivRNyCH0SDbVKpO+O1hsru6F9ynoct0Kq?=
 =?us-ascii?Q?lgg0Ffe/xw6UEAnN+cZDSGS22PcTYKAI8VCC5CRt7nf96xCSgaAgAd2/IjEF?=
 =?us-ascii?Q?iQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 87046a8f-3e6f-429d-585b-08da9c7edcec
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB6059.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 09:43:11.5603
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h6jPWBBw/7DkOKW4rRnffBtFSAoJcZYxB2wZDDKyZh9+4wVs4PJYQPlMZidNISSWeDxePIvQE0yVht7BUwxQyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5445
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 22, 2022 at 08:56:00AM +0100, Tvrtko Ursulin wrote:
> 
> On 21/09/2022 18:39, Rodrigo Vivi wrote:
> > The force_probe protection actively avoids the probe of i915 to
> > manage a device that is currently under development. It is a nice
> > protection for future users when getting a new platform but using
> > some older kernel.
> > 
> > However, when we avoid the probe we don't take back the registration
> > of the device. We cannot give up the registration anyway since we can
> > have multiple devices present. For instance an integrated and a discrete
> > one.
> > 
> > When this scenario occurs, the user will not be able to change any
> > of the runtime pm configuration of the unmanaged device. So, it will
> > be blocked in D0 state wasting power. This is specially bad in the
> > case where we have a discrete platform attached, but the user is
> > able to fully use the integrated one for everything else.
> > 
> > So, let's put the protected and unmanaged device in D3. So we can
> > save some power.
> > 
> > Reported-by: Daniel J Blueman <daniel@quora.org>
> > Cc: stable@vger.kernel.org
> > Cc: Daniel J Blueman <daniel@quora.org>
> > Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> > Cc: Anshuman Gupta <anshuman.gupta@intel.com>
> > Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
> > ---
> >   drivers/gpu/drm/i915/i915_pci.c | 8 ++++++++
> >   1 file changed, 8 insertions(+)
> > 
> > diff --git a/drivers/gpu/drm/i915/i915_pci.c b/drivers/gpu/drm/i915/i915_pci.c
> > index 77e7df21f539..fc3e7c69af2a 100644
> > --- a/drivers/gpu/drm/i915/i915_pci.c
> > +++ b/drivers/gpu/drm/i915/i915_pci.c
> > @@ -25,6 +25,7 @@
> >   #include <drm/drm_color_mgmt.h>
> >   #include <drm/drm_drv.h>
> >   #include <drm/i915_pciids.h>
> > +#include <linux/pm_runtime.h>
> >   #include "gt/intel_gt_regs.h"
> >   #include "gt/intel_sa_media.h"
> > @@ -1304,6 +1305,7 @@ static int i915_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
> >   {
> >   	struct intel_device_info *intel_info =
> >   		(struct intel_device_info *) ent->driver_data;
> > +	struct device *kdev = &pdev->dev;
> >   	int err;
> >   	if (intel_info->require_force_probe &&
> > @@ -1314,6 +1316,12 @@ static int i915_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
> >   			 "module parameter or CONFIG_DRM_I915_FORCE_PROBE=%04x configuration option,\n"
> >   			 "or (recommended) check for kernel updates.\n",
> >   			 pdev->device, pdev->device, pdev->device);
> > +
> > +		/* Let's not waste power if we are not managing the device */
> > +		pm_runtime_use_autosuspend(kdev);
> > +		pm_runtime_allow(kdev);
> > +		pm_runtime_put_autosuspend(kdev);
> 
> This sequence is black magic to me so can't really comment on the specifics. But in general, what I think I've figured out is, that the PCI core calls our runtime resume callback before probe:
> 
> local_pci_probe:
> ...
>         /*
>          * Unbound PCI devices are always put in D0, regardless of
>          * runtime PM status.  During probe, the device is set to
>          * active and the usage count is incremented.  If the driver
>          * supports runtime PM, it should call pm_runtime_put_noidle(),
>          * or any other runtime PM helper function decrementing the usage
>          * count, in its probe routine and pm_runtime_get_noresume() in
>          * its remove routine.
>          */
>         pm_runtime_get_sync(dev);
>         pci_dev->driver = pci_drv;
>         rc = pci_drv->probe(pci_dev, ddi->id);
>         if (!rc)
>                 return rc;
>         if (rc < 0) {
>                 pci_dev->driver = NULL;
>                 pm_runtime_put_sync(dev);
>                 return rc;
>         }
> 

Yes, in Linux the default is D0 for any unmanaged device. But then the
user can go there in the sysfs and change the power/control to 'auto'
and get the device to D3.

> And if probe fails it calls pm_runtime_put_sync which presumably does not provide the symmetry we need?

The main problem I see is that when the probe fail in our case we don't
unregister and i915 is still listed as controlling that device as we could
see with lspci --nnv.

And any attempt to change the control to 'auto' fails. So we are forever
stuck in D0.

So, I really believe it is better to bring the device to D3 then leaving
it there blocked in D0 forever.

Or forcing users to use another parameter to entirely avoid i915 to get
this device at first place.

> 
> Anyway since I can't provide meaningful review I'll copy Imre since I think he worked in the area in the past. Just so more eyes is better.
> 
> Regards,
> 
> Tvrtko
> 
> 
> > +
> >   		return -ENODEV;
> >   	}
