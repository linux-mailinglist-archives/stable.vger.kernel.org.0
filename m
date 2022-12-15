Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0355364E21B
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 21:07:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbiLOUHl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 15:07:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbiLOUHj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 15:07:39 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 129691EEDA
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 12:07:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671134857; x=1702670857;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=MwyMrEMMHmy0IuSbx57QIO44n6RYHrH8RO3AhuHlrlY=;
  b=hE7/FP32SJjFq8JXuk9BeAqIpugxL3zUAsom1jBG5nA71mxa+UBeaTCi
   ba1ePKBjuIy1ntIRV5KMrPN1muqvk3YhpekKMQ6ghtWmVRJNGtkzROlxE
   Z9b3GkDjiWx6L87SuNDEBDu2t6Z2Qs0srZ2QDv2l7U1RJy7pcZgpTJ+y6
   DUwmADCC8N8lUA8qqSexsiBJY9hZNwVAFvxHmW7LWUZFVZjxTu7kNF7H7
   G2pnAWI0/Mg5uLePw16Sr5AYNTrvkSgyx3KEvyde4DVXjBZOZumGb6f7h
   eO9f5GIbTez7/emqz2v1m8xol0KBFKvZAFjvGAB65FY5H3RWvkEVEwO0z
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="383119083"
X-IronPort-AV: E=Sophos;i="5.96,248,1665471600"; 
   d="scan'208";a="383119083"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2022 12:07:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="791794898"
X-IronPort-AV: E=Sophos;i="5.96,248,1665471600"; 
   d="scan'208";a="791794898"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga001.fm.intel.com with ESMTP; 15 Dec 2022 12:07:36 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 15 Dec 2022 12:07:36 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 15 Dec 2022 12:07:35 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 15 Dec 2022 12:07:35 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 15 Dec 2022 12:07:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UbUXtEpQXpURqUmUjOBQaDJ7q4CLYI9iy/EHr4U43YbYI/Ti8ON6ki7QsYhzaWW63OoZ2kGg7c07JbNUkVY7ANKg4ePbmjG1tDXrPiEU8X3W0AL/EONjv1yVBYIROAjvscNH3cOgJs/SyPFgezH1q67xycQmkT/BGhYbaFXdkya7eRsEKIA2k8ilFNY6m4vpmRGph0GO/fdW01OEJ6p2luKLQeA8RZB/uctYid+orutaXuze+L4QnwAT8K4hsH6R0V+Ms62uIAR159i9IOt1FEXbYQKMDYT7DxzwLPLkFivqqqZWZ+SG1AzX+RDzQA1AeT5iDL4qRD1KOfs9WC5jfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AsZvYVN4LCi3TpUKRHezFHalAmKp+S02+lg3vn4UVcA=;
 b=N1CRmAmHwsixdzY5H4XLB5kMDcYtTHWCszKpjGr7vldln4kvV5v7xbzjd3FWccNe/ocMcZCVL1AgiSyd3RKO+dhB66tiXECjZRwnFk3rrFG4kLgDCUl2+AsQNv6hwA52f/YawWUbJaEjykKHyLcd8EBH4y8+y1oSmBTsni85ba6rIi65yXqCoA0jmvNuxz5BVxRrH03zrYY9lm+A0AbMZfbgb+A/UMgk1CQhrRglCkxZQrldHnfMk078rHoWSpZZ2sO3cyHkHVpYFzy8I8j74Y8oui+FDKP6vAG+cGELeXhD+82Ubymrg6SA5/FBNzIiQfFpUWQE02hOtCaDOpkCRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB6059.namprd11.prod.outlook.com (2603:10b6:208:377::9)
 by PH8PR11MB6927.namprd11.prod.outlook.com (2603:10b6:510:225::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Thu, 15 Dec
 2022 20:07:33 +0000
Received: from MN0PR11MB6059.namprd11.prod.outlook.com
 ([fe80::499c:efe3:4397:808]) by MN0PR11MB6059.namprd11.prod.outlook.com
 ([fe80::499c:efe3:4397:808%9]) with mapi id 15.20.5924.012; Thu, 15 Dec 2022
 20:07:33 +0000
Date:   Thu, 15 Dec 2022 15:07:28 -0500
From:   Rodrigo Vivi <rodrigo.vivi@intel.com>
To:     Andi Shyti <andi.shyti@linux.intel.com>
CC:     "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "chris@chris-wilson.co.uk" <chris@chris-wilson.co.uk>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: Re: [Intel-gfx] [PATCH] drm/i915/gt: Reset twice
Message-ID: <Y5t+gEMl/XFpAh4N@intel.com>
References: <20221212161338.1007659-1-andi.shyti@linux.intel.com>
 <Y5dc7vhfh6yixFRo@intel.com>
 <Y5e0gh2u8uTlwQL6@ashyti-mobl2.lan>
 <51402d0d8cfdc319d0786ec03c5ada4d82757cf0.camel@intel.com>
 <Y5pQH+KGujkSJTvT@ashyti-mobl2.lan>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y5pQH+KGujkSJTvT@ashyti-mobl2.lan>
X-ClientProxiedBy: SJ0PR13CA0152.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::7) To MN0PR11MB6059.namprd11.prod.outlook.com
 (2603:10b6:208:377::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR11MB6059:EE_|PH8PR11MB6927:EE_
X-MS-Office365-Filtering-Correlation-Id: 64ea91d8-0983-420d-5cde-08daded800a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v5cDQsWQWQ5Z+nEfa6Fjl0zRtFaDsSldAMhbxYaYKV1njgR1wtlop6yGUt9xaJczm5gaYXuav04LDx8jq5CBOOvC7UKRYWh82kETZdjv7HKStw8EhIWDpdIZN/PY1BCLK/BNx1EpYgPx1DDm2Nbo0hvq9aw2hyrhfqiTDXxcm4C7PcPh6Y7zn7eGiIWlWGK4ENTmletpBHh3iu3p9R6tAo6XQ+pLpAKxkrHE+7hdgG5kcVobveHN0VdRf6b5Ie9wjuzlKIZ2OmFIVJ2Tac5JOpc6UZ2gT6TxQRUcGobU0W7e5poRaDyx/B7p5zjhog+opuvCruskIq5mTSS0Aii4ajuBkPEKBbXyWr3erj/YF/ql10P3LMzrczwHLf9gTpQrAQKNJG0wZOWbO+nloYE3dMkjW+WWKvM/9y5MXsFxvgGMZFRBtEgBvdiLISNXJJdlX545N0KcgN/VBp4IHOWH8Lo0Iy11RthfCWOVKwN0Kpfogph2VoLbue4cvepSRIbuEObcMNsUEHz+N5J/nz6La917XBwtTWexFDf4MHFYlRI5ZyXwe1kKGZkw845YNPgLOeobh9mxk4TstKzM9UUNrw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB6059.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(39860400002)(366004)(136003)(396003)(451199015)(36756003)(6666004)(8936002)(478600001)(6486002)(38100700002)(966005)(82960400001)(41300700001)(86362001)(316002)(5660300002)(44832011)(4001150100001)(2616005)(186003)(6916009)(54906003)(66946007)(4326008)(66476007)(66556008)(8676002)(2906002)(26005)(6512007)(6506007)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?Tfmxk3YNJlNsch4gyu6g5of0rxepHtt1aDOKYnIRCcCAcYk7s/j9Uk2ykk?=
 =?iso-8859-1?Q?ONU2KIjUrz/A0gMwKM7FkjsnhcLnrPaOZ4LHxWCN4jWtkNA5Gb82o8ipDf?=
 =?iso-8859-1?Q?ccfWdlPiy0bYwYACOv+jvn/x0+1AJ0Mm08q/hAE/jYwYB1yPpPuACWZgQr?=
 =?iso-8859-1?Q?N8lVrIrkIFgxqbglkKnr+CG5WJ32Cxjg6j1donPlvPS7ak5wQb7UQ5fxYv?=
 =?iso-8859-1?Q?jd0TyKeeqEEv8koieuVdQsFipCDXt70I5LMNYsIcHdd4rNG61r3uVJnbPu?=
 =?iso-8859-1?Q?NEx0DqIbhmdD59veS+I6gApzISjp13K+Xn84Qgw2tjVjxGeZvmpT+LCfrw?=
 =?iso-8859-1?Q?iU1JblbyMFxjL2OxibKHMhsmKjxmSY9gNGYOTebHgcowYuFjx3DK0fGFEd?=
 =?iso-8859-1?Q?6N2OLAmgcrWqBtkNOK1wavfoTjpjyvMhfQByHCCked9p63Aqufqmldphr6?=
 =?iso-8859-1?Q?M/3G7SIVZ1X9KPEPBI0U+8mWYNzsObYBorzvij2L6l7owe89OFsnN1TMKy?=
 =?iso-8859-1?Q?B9UwYT7cX9XTcZl2SDuXfEqIEwjYrl9ymw3pCcjemtARh36WIAdHfwId18?=
 =?iso-8859-1?Q?Rz60RMo5H0m2pDQz/Ihf72zjs3FFXBNubSAptc1I18WFLI1EzDb8Mfavx1?=
 =?iso-8859-1?Q?peFy1CL8lET3q/ao8b7+WhxdZtJBV3V8qFh4kojACRIUaR87H0NZU5SNHG?=
 =?iso-8859-1?Q?rECr6f2JmNHIe6NYEJd0GwzvlnqmR0ZBMQrFU4daA7CVR+T0SQNPMoYect?=
 =?iso-8859-1?Q?mkoNUiuxk4hEdDhxTjYFIlGYqa7C2wwzoTuir9gLp2qsUSf11XW6BOS5j0?=
 =?iso-8859-1?Q?W5Fxu6zJIrfbBYBq9ymQopa2SVvPf/98nHVaiGBfEyLJ9v9p/wqHkRxjaF?=
 =?iso-8859-1?Q?KnVCw0qP0Wczv65Ax+a/tuFv/vuo+SlQeCe3Elf367na0IYQkvVTjpySS1?=
 =?iso-8859-1?Q?uuHi8Yk2Po1f4DbLFwfElvk41D35S79UdcFb/YXWuXhHNLk3fV+xZVHr9E?=
 =?iso-8859-1?Q?1K/+ZSHT0TBUabVChDy8+TsiUx60DBBJ6Xkvl1brZG4f/HlZQ9GlQeIwWo?=
 =?iso-8859-1?Q?AZ8xx2//5cO4pk4GNymy9T8GOjZd+L9HGJfV9UInaAFgYK3o89tSfwII0f?=
 =?iso-8859-1?Q?8wQSrMYQi39sdE6i517PycZkgyKr6VM/tn96VhWuetQGLSqu3576nt/3j+?=
 =?iso-8859-1?Q?JSiu0hQzNa5peZSBNtj2SifSRv+u9jo0kUBpIufq5gffkfNpCK91WuEs3O?=
 =?iso-8859-1?Q?SpDI0G5OGDZVLB1Grwuxl3Bgu/ZJDydr0BhqXy7IuBnz7DAYWD4sjFxhxg?=
 =?iso-8859-1?Q?p2KII0y9MkucbLjehYBTUIRfVmc+fC4cn/3jE/STWaZrcuJlQ7Zqp/3mat?=
 =?iso-8859-1?Q?vHU9/10P+WVBzjRx87nrd6KPCWGRwVSaBWFV86K6EUurM4znVGljLzQ6IF?=
 =?iso-8859-1?Q?j7ybQ+L+WPGq8uC5SNT2OjvqHrwlCzehnsc+O1iyc2gmNzkZJeCQLu/Jpj?=
 =?iso-8859-1?Q?kTpNP/UkeIwuAXiy6bHAfzvYj6RbVaEKRjpxz/eVl5sTtNrpBgzJ0ixwyJ?=
 =?iso-8859-1?Q?ZR8QQjihBuA3DEZcFO1gOxvfyx6OemttPwDBJa+Vcq9+nEDNa+aaJlv42H?=
 =?iso-8859-1?Q?Ocir+cRyZ6JT84h3rRhAPjnj2VXbi0qcGa?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 64ea91d8-0983-420d-5cde-08daded800a5
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB6059.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2022 20:07:33.4310
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oS2KO4OcHDI65UR6ADNcOHFs6EMOvfE1izFRvuAFOy7oKcntSZag4ezSuhQHzfovrhdObhi8/4+/vIrGaBgpmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6927
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 14, 2022 at 11:37:19PM +0100, Andi Shyti wrote:
> Hi Rodrigo,
> 
> On Tue, Dec 13, 2022 at 01:18:48PM +0000, Vivi, Rodrigo wrote:
> > On Tue, 2022-12-13 at 00:08 +0100, Andi Shyti wrote:
> > > Hi Rodrigo,
> > > 
> > > On Mon, Dec 12, 2022 at 11:55:10AM -0500, Rodrigo Vivi wrote:
> > > > On Mon, Dec 12, 2022 at 05:13:38PM +0100, Andi Shyti wrote:
> > > > > From: Chris Wilson <chris@chris-wilson.co.uk>
> > > > > 
> > > > > After applying an engine reset, on some platforms like
> > > > > Jasperlake, we
> > > > > occasionally detect that the engine state is not cleared until
> > > > > shortly
> > > > > after the resume. As we try to resume the engine with volatile
> > > > > internal
> > > > > state, the first request fails with a spurious CS event (it looks
> > > > > like
> > > > > it reports a lite-restore to the hung context, instead of the
> > > > > expected
> > > > > idle->active context switch).
> > > > > 
> > > > > Signed-off-by: Chris Wilson <hris@chris-wilson.co.uk>
> > > > 
> > > > There's a typo in the signature email I'm afraid...
> > > 
> > > oh yes, I forgot the 'C' :)
> > 
> > you forgot?
> > who signed it off?
> 
> Chris, but as I was copy/pasting SoB's I might have
> unintentionally removed the 'c'.
> 
> > > > Other than that, have we checked the possibility of using the
> > > > driver-initiated-flr bit
> > > > instead of this second loop? That should be the right way to
> > > > guarantee everything is
> > > > cleared on gen11+...
> > > 
> > > maybe I am misinterpreting it, but is FLR the same as resetting
> > > hardware domains individually?
> > 
> > No, it is bigger than that... almost the PCI FLR with some exceptions:
> > 
> > https://lists.freedesktop.org/archives/intel-gfx/2022-December/313956.html
> 
> yes, exactly... I would use FLR feedback if I was performing an
> FLR reset. But here I'm not doing that, here I'm simply gating
> off some power domains. It happens that those power domains turn
> on and off engines making them reset.

is this issue only seeing when this reset is called from the
sanitize functions at probe and resumes?
Or from any kind of gt reset?

I don't remember seeing any reference link to the bug in the patch,
hence I'm assuming this is happening in any kind of gt reset that
ends up in this function.

> 
> FLR doesn't have anything to do here, also because if you want to
> reset a single engine you go through this function, instead of
> resetting the whole GPU with whatever is annexed.

yeap. That might be to extreme depending on the case. But all that
I asked was if we were considering this option since this is the
recommended way of reseting our engines nowadays.

> 
> This patch is not fixing the "reset" concept of i915, but it's
> fixing a missing feedback that happens in one single platform
> when trying to gate on/off a domain.

But it is changing the reset concept and timeouts for all the reset
cases in all the platforms.

> 
> Maybe I am completely off track, but I don't see connection with
> FLR here.

The point is that if a reset is needed, for any reason,
the recommended way for Jasperlake, and any other newer platforms,
is to use the FLR rather than the engine reset. But we are using
the engine reset, and now twice, rather then attempt the recommended
way.

> 
> (besides FLR might not be present in all the platforms)

This issue is also not present in all the platforms and you are still
increasing the loops and delay for all the platforms.

> 
> Thanks a lot for your inputs,

have we looked to the Jasperlake workarounds to see if we are missing
anything there that could help us in this case instead of this extreme
approach of randomly increasing timeouts and attempts for all the
platforms?

> Andi
> 
> > > How am I supposed to use driver_initiated_flr() in this context?
> > 
> > Some drivers are not even using this gt reset anymore and going
> > directly with the driver-initiated FLR in case that guc reset failed.
> > 
> > I believe we can still keep the gt reset in our case as we currently
> > have, but instead of keep retrying it until it succeeds we probably
> > should go to the next level and do the driver initiated FLR when the GT
> > reset failed.
> > 
> > > 
> > > Thanks,
> > > Andi
> > > 
> > > > > Cc: stable@vger.kernel.org
> > > > > Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
> > > > > Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
> > > > > ---
> > > > >  drivers/gpu/drm/i915/gt/intel_reset.c | 34
> > > > > ++++++++++++++++++++++-----
> > > > >  1 file changed, 28 insertions(+), 6 deletions(-)
> > > > > 
> > > > > diff --git a/drivers/gpu/drm/i915/gt/intel_reset.c
> > > > > b/drivers/gpu/drm/i915/gt/intel_reset.c
> > > > > index ffde89c5835a4..88dfc0c5316ff 100644
> > > > > --- a/drivers/gpu/drm/i915/gt/intel_reset.c
> > > > > +++ b/drivers/gpu/drm/i915/gt/intel_reset.c
> > > > > @@ -268,6 +268,7 @@ static int ilk_do_reset(struct intel_gt *gt,
> > > > > intel_engine_mask_t engine_mask,
> > > > >  static int gen6_hw_domain_reset(struct intel_gt *gt, u32
> > > > > hw_domain_mask)
> > > > >  {
> > > > >         struct intel_uncore *uncore = gt->uncore;
> > > > > +       int loops = 2;
> > > > >         int err;
> > > > >  
> > > > >         /*
> > > > > @@ -275,18 +276,39 @@ static int gen6_hw_domain_reset(struct
> > > > > intel_gt *gt, u32 hw_domain_mask)
> > > > >          * for fifo space for the write or forcewake the chip for
> > > > >          * the read
> > > > >          */
> > > > > -       intel_uncore_write_fw(uncore, GEN6_GDRST,
> > > > > hw_domain_mask);
> > > > > +       do {
> > > > > +               intel_uncore_write_fw(uncore, GEN6_GDRST,
> > > > > hw_domain_mask);
> > > > >  
> > > > > -       /* Wait for the device to ack the reset requests */
> > > > > -       err = __intel_wait_for_register_fw(uncore,
> > > > > -                                          GEN6_GDRST,
> > > > > hw_domain_mask, 0,
> > > > > -                                          500, 0,
> > > > > -                                          NULL);
> > > > > +               /*
> > > > > +                * Wait for the device to ack the reset requests.
> > > > > +                *
> > > > > +                * On some platforms, e.g. Jasperlake, we see see
> > > > > that the
> > > > > +                * engine register state is not cleared until
> > > > > shortly after
> > > > > +                * GDRST reports completion, causing a failure as
> > > > > we try
> > > > > +                * to immediately resume while the internal state
> > > > > is still
> > > > > +                * in flux. If we immediately repeat the reset,
> > > > > the second
> > > > > +                * reset appears to serialise with the first, and
> > > > > since
> > > > > +                * it is a no-op, the registers should retain
> > > > > their reset
> > > > > +                * value. However, there is still a concern that
> > > > > upon
> > > > > +                * leaving the second reset, the internal engine
> > > > > state
> > > > > +                * is still in flux and not ready for resuming.
> > > > > +                */
> > > > > +               err = __intel_wait_for_register_fw(uncore,
> > > > > GEN6_GDRST,
> > > > > +                                                 
> > > > > hw_domain_mask, 0,
> > > > > +                                                  2000, 0,
> > > > > +                                                  NULL);
> > > > > +       } while (err == 0 && --loops);
> > > > >         if (err)
> > > > >                 GT_TRACE(gt,
> > > > >                          "Wait for 0x%08x engines reset
> > > > > failed\n",
> > > > >                          hw_domain_mask);
> > > > >  
> > > > > +       /*
> > > > > +        * As we have observed that the engine state is still
> > > > > volatile
> > > > > +        * after GDRST is acked, impose a small delay to let
> > > > > everything settle.
> > > > > +        */
> > > > > +       udelay(50);
> > > > > +
> > > > >         return err;
> > > > >  }
> > > > >  
> > > > > -- 
> > > > > 2.38.1
> > > > > 
> > 
