Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBC36414DB
	for <lists+stable@lfdr.de>; Sat,  3 Dec 2022 09:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbiLCIDf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Dec 2022 03:03:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbiLCIDd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Dec 2022 03:03:33 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4BA427908;
        Sat,  3 Dec 2022 00:03:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670054612; x=1701590612;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=S4l6YnbHMvyfAxod+tYI+IVB8ngT5PUsUIMUb0Ivn9w=;
  b=PInLwOiwbnZMgcK5BSb5d1j0eFy3ustB0wu4qXg/wy5q6g/TADZ1iM8v
   c3/kPK+QLQ+DWgZ2i2bMa/XzHY1mSRI0isqyCAYiOccefhR9Cx0AgJxTr
   kA8tleMpQNBMawB09j7MjIdZJdxeFn//MnsZCungAiwvvhIAdjc/dR4pr
   NWSXTRoP8Qk/A6F22M3ALxsFJ7iuJEj/cvMhTLepzKbqZI1iLajZrCDl1
   qr5HS7Hv3HlPSf3PKfqdTUcigPm9KKd98eGinF5OE7Tccu+6IQ2RYEPom
   jcgO6eBJKMtoLX8Unz87g4NX79OGdkJDCy1leHA8ER54OIFiIljASxVBL
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10549"; a="317250454"
X-IronPort-AV: E=Sophos;i="5.96,214,1665471600"; 
   d="scan'208";a="317250454"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2022 00:03:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10549"; a="713876610"
X-IronPort-AV: E=Sophos;i="5.96,214,1665471600"; 
   d="scan'208";a="713876610"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga004.fm.intel.com with ESMTP; 03 Dec 2022 00:03:32 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sat, 3 Dec 2022 00:03:31 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sat, 3 Dec 2022 00:03:31 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sat, 3 Dec 2022 00:03:31 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sat, 3 Dec 2022 00:03:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ADQ33Tt1vCYQqwjzjKVs92mQy/poBvEbTIPt2dYhp7uKj3Q2in5sY2nmuO5RRRjqUc7qSmzwWwv/4k60UHIbIK29QKsKXh34Jb2RWVr21tMrUkJoY5MBXtMfrDvcQvfOEuMxp5mOyKBNjexIrciFnbin3ZqhxE0FfquAZ2cKMaFsu88Q3z0KzYp0+Lgwko/4v3uD1NQi82wxdjfhQr7OZENgnNZsxrePG7CXDRKCavs4bxzWF9d8gOQf7o3zL9uZ7vKcqwSz0ebcPJ7Ld9/hL6Eb+udtYH/yRnONBA0BitZlhzvOl61jW9Qac2n5mU3AsbE4T9vegU5RWmh3BHVWbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WAQweG1C8J7V2DiyO8cx8VCN0Q4zxqHsrO2pUiFi00c=;
 b=lk2aYUyfz3b0dcPYs3nMuppkMYXMT7RkyZ/lDRmZLIy5Fn6jfQFBuZtgy4++NUDfBvXjlWn1L/OdyWQmLeStHB1kLB4pCDmn/NNAXl3kLRcBp7jhawJMdrFkY3sW89c2jAZkIwxOIApobq0zrQyuGBvZhyLrCb9ZDu7kfdjJS4vtiRqJMp1/R1hL0W4Nwb/t3Yu0ISBNt2ItEF47LWUuoFwnCqINQqa/E9D42614rQRM+ZtH9P7c1uFz920bcES+OHSTi8WGzWv7V60zl3sYl5adqIZV7VYs9wqWFFxABZbhLepgkWskTsUdX4kgM7FpaBml359CE9tNmX4oBpFKEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by DM6PR11MB4657.namprd11.prod.outlook.com
 (2603:10b6:5:2a6::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.11; Sat, 3 Dec
 2022 08:03:29 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b%9]) with mapi id 15.20.5880.011; Sat, 3 Dec 2022
 08:03:29 +0000
Date:   Sat, 3 Dec 2022 00:03:27 -0800
From:   Dan Williams <dan.j.williams@intel.com>
To:     Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Dan Williams <dan.j.williams@intel.com>
CC:     <linux-cxl@vger.kernel.org>, <stable@vger.kernel.org>,
        <dave.jiang@intel.com>, <nvdimm@lists.linux.dev>,
        <dave@stgolabs.net>
Subject: Re: [PATCH 2/5] cxl/region: Fix missing probe failure
Message-ID: <638b02cf5be7f_3cbe029457@dwillia2-xfh.jf.intel.com.notmuch>
References: <166993219354.1995348.12912519920112533797.stgit@dwillia2-xfh.jf.intel.com>
 <166993220462.1995348.1698008475198427361.stgit@dwillia2-xfh.jf.intel.com>
 <20221202142328.00004254@Huawei.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221202142328.00004254@Huawei.com>
X-ClientProxiedBy: BY5PR03CA0016.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::26) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|DM6PR11MB4657:EE_
X-MS-Office365-Filtering-Correlation-Id: b4798963-78c5-43d9-30d4-08dad504dd30
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5fMJtwZq6fYO+iEvazRxGxuHC1oYYVu49Y0r5kpq1MNuYW0AaRIMQdR/oi0U0W6GNvWZdyzBshDzfCG0ufFXtTVd8gJ9gsM2fgwGWWaZJYBFAUyB4q5QvQUh+k73L2oXciMX9lFHY1CldTzA37Uf4CRNAst2K2s/QV5pSlrEiMoJnB4shNzFk5VRn47MeuMsQhvcbKKLCIy+vlS+PNZXhdk0z/t1jFmtv141yAQHbdj4bcskJ5bHT8kmOqvE1uvamOJPiALPAD3yLySw3OD9vp+IIeTsUQ56GMuHqS/cLjs3k1DL75f4WuA0DTt356Xm9YpVr3BsMELs82gz2WrDdbo5oldnwYkzvAlwu5ufRArJ766bRiaYo6+Fk1iOjSnJwCoxRAfIDwc//rhMk1wnCxMx7Rpc7cpk7EVj+tRlL0nkxFp3IxaoqUm75axFoAwZax5g0XJDnpQktKGMQAnh4H7DWK3o8z+q92EX6kAn/Au6oDito8w80xMxCw+6KqMpoWYJneAzm6X0uGgEn+BF9NHIBdFMUZlBGwXFxO7gB2mgFa1jNJ/pJankQJPLxwMLW6PbtrJOrwL6sGlSP9nvGlXIfBsDzX1Ns2wAt8jhpfC/K94c0NXZIpECXfOUNCzlbHxR73fbu6irJ+aUEk5xmQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(396003)(39860400002)(376002)(346002)(451199015)(38100700002)(82960400001)(2906002)(41300700001)(8936002)(4326008)(83380400001)(86362001)(66946007)(66556008)(66476007)(478600001)(6486002)(316002)(110136005)(5660300002)(8676002)(26005)(6506007)(186003)(9686003)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?efGKDoUfAu1ZZeKJmo+BJ8iQsmZuzVVfUZUFJrX7q48Ao2rifkY0JDHnrZRi?=
 =?us-ascii?Q?0uEyyppsGjrMo+R1tViuWhPQ70vkQXagakMq949wb3ybCyT3tCcpt4uexH5o?=
 =?us-ascii?Q?orRvsYL0Q9+oXdncv5SKWA1xkexY7syRYFYUOD79rkDMqXmhaA/wSH0YOsxf?=
 =?us-ascii?Q?s+aun3uyUICNGcLAOzC6NL9TRuBXilvE0ytTGrbXUuP1onuaLA4m+6EnxnJI?=
 =?us-ascii?Q?8fasRAr5ZlA0N8OH0HA6WVA8swcm6PLPFlmySdTvoK+1bmb65sfjb8piE1gB?=
 =?us-ascii?Q?pqSa9g0QXVF5X9SFxtYJLmd6RyaaRCKGkTm8P+1zKqWW8VoBylr/I1ypzKG6?=
 =?us-ascii?Q?r1v5w7SIf2U/rrxFJlB7+6hy+HmYQq9aQwiI9ZqN8rafCk8cjSilwvPHkLMS?=
 =?us-ascii?Q?Bt+2IDZ899qAErg/9e5L2HDCXFgR0CP9uBkF9uwgoxk+ZUGX7ZchWABVgRbG?=
 =?us-ascii?Q?n3W45kh8UuHxDFySPJulGoLDmHLnyv/62TiZD+aUsYy3CEey2RNBQoDCDUyH?=
 =?us-ascii?Q?ClHBRedYebgYYKBYSm7PgSdydPBtbbCPusae42ggQuYt9K1DwN8ymNSwSKKN?=
 =?us-ascii?Q?fLUAGmWfdCvy1wCpuXB1OqopxDtL6Kr+HYCwV7xD4AAq+8V/tfIWbIRBAUgd?=
 =?us-ascii?Q?8l6FyYZQnXw/dWcKsxL3gJ86uNmxnsGz6SzmRfPRH20xXO2BahEhnFJTGsGc?=
 =?us-ascii?Q?OGOUnko+8d5ThTczcd7yRYFOqnywkKeGF1VqbaMfDnfDiNtCm6idgX4p26zn?=
 =?us-ascii?Q?/5Vv3rLiVG9tTUmtfCkjfwLDk4OniSMgjpUnrXEFRIA+bzVWpHr2N0GhBJ2U?=
 =?us-ascii?Q?U7+sa3CwVxY1ESjoeEpaZIWGVqP/kWmEsklynP2rNdmgAuDQamvfOUhGl26Q?=
 =?us-ascii?Q?m2CJRFHh4iE+9MM2LOnwLQK2fmSUVlXHFHtUfuPggxFHgVvV9ZmyXd/x/NFc?=
 =?us-ascii?Q?fJ6v5XInalJHnUOdS7wWU0SJML2YmKecKzyxb9TcwHbvu5wc0lkoPaISYxcK?=
 =?us-ascii?Q?vm5u4zVsX8GW+rZFxYgH63fa+7hFYLegUQaN4zwcvPWGc4nRbeqKjO/65gMY?=
 =?us-ascii?Q?RCEFCAFMiZ9BjAAsQnLbDyBrXE4K//UgYVU+IAqN9mYXJcmyKKOBAGg/BT6J?=
 =?us-ascii?Q?9QFgT8JpM42WNAgkNRC9qAjN+t8sxYIytLVnSTBqtx11JYUL5DJhEd+Q+MNF?=
 =?us-ascii?Q?p28b4Y+Ot0lzUfTNirq5DrElzL8bNfKag+9O39x2j2MefX3tVFOa+j2hZ8Jd?=
 =?us-ascii?Q?w+nqOLzsKuIH8IHJXsgZfW2ofvVHmEzit+GPG9FnLd/eGVh0bkokldH/6PZs?=
 =?us-ascii?Q?fEjN0Hcu4PhQ1ZkzN5HwHLFyd8/ATFed+duj3RyIBpiOoXlZ0d4Zd1pUO0sK?=
 =?us-ascii?Q?Imc88jFfa4fLdLuV/U+/Dp+xxTDP4uEncvU1wrdu00ZduLhPqAYpiikzZNeF?=
 =?us-ascii?Q?PxmIpRTB4oNq413jEOAED+JIHutEqaWgwPXV2G5y4zdJXWQsfZ7P0aiIZJhs?=
 =?us-ascii?Q?KDKoT+AyvlnbEKmu8dCe6GXVCoruPfk71USBFKLt+H2ycOmAhwnXkOJjzr3P?=
 =?us-ascii?Q?NMjy0MoFTjcJD3rbTa89lFohuDe4ENI40I4aIfDTNIadC62JkZQCox3NOSud?=
 =?us-ascii?Q?zg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b4798963-78c5-43d9-30d4-08dad504dd30
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2022 08:03:29.5729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tUhOVUdV6QFa5IHkJaeUN9mv0KDKEdoAm1EC01I8X5QjvIwul492QyoNndQy1urqEb61/XrerSV+7YRJ0ybUeAQ56wIXoP94LZTis1KPkP4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4657
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Jonathan Cameron wrote:
> On Thu, 01 Dec 2022 14:03:24 -0800
> Dan Williams <dan.j.williams@intel.com> wrote:
> 
> > cxl_region_probe() allows for regions not in the 'commit' state to be
> > enabled. Fail probe when the region is not committed otherwise the
> > kernel may indicate that an address range is active when none of the
> > decoders are active.
> > 
> > Fixes: 8d48817df6ac ("cxl/region: Add region driver boiler plate")
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> Huh. I wonder why this wasn't triggering a build warning given
> rc is assigned but unused.

Yes, I thought that was curious too.

> 
> Ah well, this is clearly the original intent and makes sense.
> 
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> 
> > ---
> >  drivers/cxl/core/region.c |    3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> > index f9ae5ad284ff..1bc2ebefa2a5 100644
> > --- a/drivers/cxl/core/region.c
> > +++ b/drivers/cxl/core/region.c
> > @@ -1923,6 +1923,9 @@ static int cxl_region_probe(struct device *dev)
> >  	 */
> >  	up_read(&cxl_region_rwsem);
> >  
> > +	if (rc)
> > +		return rc;
> > +
> >  	switch (cxlr->mode) {
> >  	case CXL_DECODER_PMEM:
> >  		return devm_cxl_add_pmem_region(cxlr);
> > 
> 


