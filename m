Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9CBA68932E
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 10:11:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232528AbjBCJLJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 04:11:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232524AbjBCJLI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 04:11:08 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6218C646B3;
        Fri,  3 Feb 2023 01:11:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675415467; x=1706951467;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=7VmvSkouB9bRwflOPwJCHjcG+BCFgQEbTqSrs2uSnzk=;
  b=hAdcg71tx2pVlxX3hyQv9de6ROKOu+TXTPp0vYRvjhtnL3RLYOa9uN0D
   TrsyEy40Y0mmoZ7Ue2ReA9341XiMYIQAs+Ak0qtrHP4c+L4BjoWUTaxPV
   7HGDtamgW/XCYj6dYKvcRIbk8xcqLDKMp70j0FjPuEAvkZfXXQHoJRBQQ
   any6fzxfSOWhR9lXl6jFZRRR1AIbRegJ9VwMrAqiHQ0Pm/OgVrB3cDfzQ
   rHwv18GiF2pEQ2uq4dSf6Yzuz+YNtZ4vdTAQEka689/fEkPrXN9fZPSgN
   u6Sjimvb6iiuSWhH3CtnlcQbghGuQ0kg6nVt0CQPP7WYirmEEZC9A6wTt
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="312356214"
X-IronPort-AV: E=Sophos;i="5.97,269,1669104000"; 
   d="scan'208";a="312356214"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2023 01:11:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="808310261"
X-IronPort-AV: E=Sophos;i="5.97,269,1669104000"; 
   d="scan'208";a="808310261"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga001.fm.intel.com with ESMTP; 03 Feb 2023 01:11:03 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 3 Feb 2023 01:11:03 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 3 Feb 2023 01:11:03 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 3 Feb 2023 01:11:03 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.45) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 3 Feb 2023 01:11:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DB62VPcUDN1QxFa+ov0b94HzUBwpubz+K4cjNCTDazvTi+V0VNgN5oxB+z5nwjHFbxoYJqGc2xhmXEFnJmY6GI/RFkUg7UxppC92IJ1eSoQi0dIYxAWvGOqZrzBZeCquIuSC5zpIK2K2Lbo6EoOnUVRycntiuKGMIkynadLtshrYyRyU84QCHdDoEGQZqyMxIe4m/TFMZvTrwDrVsxeEKifB0SvQnglQYAzHDmj0LwehmhcazafA6jXBJb+rL/BnZ0Cxfhwcdx2OvzwRNCYfjoSfYlCS4dc9oXSK+s/zaaJ0BOiH2IDsrw62hWqmjtkdiaMj26G/zqu2RAENKTMNRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A9UKcf59IxiTOWfbcrY0g/RYGJs/RyMT7FqmHWgrO8s=;
 b=jxpIe5UUisuw96EGrz0EayultjMvEWvsUQVoc1ZTuTThIzsHCg0XMksg9vLAaApHZUYxLzxbKrFHxAODbV/I6jkGm9S380ecNJvqBh8xwD7IIAUYZiSgMOSxYYW81bIrpLD+HyV2MxHapTHBZswjgCOJZMOYVRqufOdLomh612Wo2fWx1jQhXwpCsYVq6U5yyyP5DKOwPnJqS1gReIZGPCONZjdKgWkV+VHq7hzX4P6TaPyVIGth2ypmN76FVqnmG1HM3+OM94cnxXpfFfVadBg57MGhT/AMAar3ha7xepea0H6hDHVElXxoJaEtZ70Joy4671ZpcZpnb8eFuV4CQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by MW5PR11MB5905.namprd11.prod.outlook.com (2603:10b6:303:19f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.24; Fri, 3 Feb
 2023 09:11:01 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::4b3:1ff:221:2525]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::4b3:1ff:221:2525%6]) with mapi id 15.20.6064.024; Fri, 3 Feb 2023
 09:11:01 +0000
Date:   Fri, 3 Feb 2023 09:10:55 +0000
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <qat-linux@intel.com>,
        <stable@vger.kernel.org>, Vladis Dronov <vdronov@redhat.com>,
        Fiona Trahe <fiona.trahe@intel.com>
Subject: Re: [PATCH] crypto: qat - fix out-of-bounds read
Message-ID: <Y9zPn9hgTjG1k9Qc@gcabiddu-mobl1.ger.corp.intel.com>
References: <20230201155944.23379-1-giovanni.cabiddu@intel.com>
 <Y9xduyjbaxFdaCUT@gondor.apana.org.au>
 <Y9yrZk9KnICxqkZp@gcabiddu-mobl1.ger.corp.intel.com>
 <Y9zKTHFvYHrmfqdW@gondor.apana.org.au>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y9zKTHFvYHrmfqdW@gondor.apana.org.au>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: LO4P123CA0264.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:194::17) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|MW5PR11MB5905:EE_
X-MS-Office365-Filtering-Correlation-Id: 4921c4f1-6972-414a-325c-08db05c691b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V9vCAplexxLcpWkO50MiYyvmLzz73oBwcr3xhpEEOG5zGetTkVQGQJe0wO0NzwOWySBLxV6lI0Wb9kSp87vpAD0bdsoYPP9s43jRMmsEug0MPUuicHyPjwlC6SNMvpJq26PAsW48lWl5OCogk/LN687K+IB/H9axrFKt+rp3KzWLiI1HWV/vs4YZ7sHUQtsIJfsxJTLTD2vkdbBLPZ5MlhwdB/IoDuv7zXIqTc81A/F5r6ccOKKddgxxlzHUSEpVDIEeQEbFtyUfAG0Z77XoRpOoX7wnGf404zomEprVUS7TO6+kAG80DHXRPrV23plqwGrFmHXh/10RgA+YBMm0/4BQgY24ITNNky7R+oBrQlMbAj4Y1jZ/VfHwgZ9shMDj5XkS5f9SvQHxL3EdaXef/n1/UGGGemEouwCelfpiU3hxS4GH6cH5W3ikQCClVvHnBIQbU82tdFea5ImV2t+Pjnou4XdiYrsnLuEZo3wrsYouUa8KPRlg5EM/jdc7yvo8DojTo7gG0kdViDxEgi725whW4ZzbYv1evZ5TP8DMBHEM0BimNoi0U+UMfRYal8C1SXwLDGSocx0Ib3oT45f/15RGfn+WpLsMH9KLpJLP2TvhWCaO8DEnfRsSSDhH0Sc1Xiy8a6iiGbUQt3DwEE6kcA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(396003)(366004)(39860400002)(376002)(346002)(451199018)(6916009)(8676002)(8936002)(41300700001)(66946007)(478600001)(66556008)(6486002)(86362001)(66476007)(4326008)(316002)(36916002)(54906003)(5660300002)(44832011)(6506007)(107886003)(6666004)(2906002)(26005)(186003)(82960400001)(38100700002)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4NLskgqyn9ACnmr7c2vhWyP4ISc/IvVKRref7UluYdUHHhi7H2QgKMp5ewo6?=
 =?us-ascii?Q?WmVSLoBh8eRZbSyTpQmbWyIKca4S1lZIY8y8OCN1RQbz5KGd6asdBOAFmhrm?=
 =?us-ascii?Q?1Bg0/2GpC1BClx0ErUs7JLLIAIjcIQqCqUQbByH8z3p10petNkYb2vnx4FO4?=
 =?us-ascii?Q?/mNJyvb9yIJumYFL4oOlFtAivt/q4gPU+OhTTNqrcx/HfnLMBepKWcZqOv9y?=
 =?us-ascii?Q?Ln+W7adro41jQ2M2WmQMSyQgvSxI8Cl6lV8AsINaRHNHChqwS2Ya+Kk5vUyC?=
 =?us-ascii?Q?NFvLaNzQELWM5fd8jzmJKXDQwPDQecY33gM9dCxutBMnTLl+xlg6/f/ScGRs?=
 =?us-ascii?Q?rTinBRqqDPio2urroWyUToDEP/LMA18DiCGIc0/KixlYAUVxpDpCVHIxq3Ly?=
 =?us-ascii?Q?+/UjETYo6iGF/COQeNI3zMbM3iGgptGGJxfSqNrNumYE9MsEH1JxEVonthx5?=
 =?us-ascii?Q?ZPv0DQFoCxurwcJz+p72nEE07Ph65zWUKI8ZOt7wvjHo8TZVIWduLolQqpDB?=
 =?us-ascii?Q?eRDqMyum6hrSxGz4kw6yPpZgHFXvRx8y1Z3k7u7aCT10z6hLsXJjlCsdpG7Y?=
 =?us-ascii?Q?IrichMhw0hFFeydOjwP+NoaB6Cl+ISSsOQlMCf18/KfcefAG5f7kEhWXv8FW?=
 =?us-ascii?Q?dfeasohNImx7TOlz/B++SGzWLkRmTlaj9+d81IFVRizwONWq3+wLrmyN6f47?=
 =?us-ascii?Q?LSl4+yJ2bIV/rAuCrewqZE2LyGsVvJbKpTDp6W39bFJY9MHGchQ+b81IkV/Z?=
 =?us-ascii?Q?//I2U+UhKjCu8bDIyfRHD1UC2XNGnuV+TSbdFO0adby2JSyO1sVM3OqoPZc8?=
 =?us-ascii?Q?Ub1P0D/+KwjZYvvvhwOqRrusdQBEWp0kpX9f7z1tyMST5JkZHQ8qIJnZ1jcX?=
 =?us-ascii?Q?I1iknHG944ctEvreGfgiTPJ/CleIHE6z7KEiS6BXsrwwqNUOruop812D0eBx?=
 =?us-ascii?Q?cCSgTtOkb9moKjM0apBs2vScA6R8256qvmypSABbJeql0MPK5UdwP6AQ0LD/?=
 =?us-ascii?Q?Nef+Ei3m2CL6Lj3Z9KQibi2hEtB3ro7exIPEZTwDpkZv7Q4tLSW4rHY5/7zS?=
 =?us-ascii?Q?yRxc9q1FU5TmGFVvGwuJtgNJcTDXkKVWa0t7kv6xa8r8eIycLRLDVt5NHwZ2?=
 =?us-ascii?Q?79/jYumwyIabPYclK4LhSnji7dkf2Q6SYsBURf8GdK0AXmf8uiC+Dj8g0JPn?=
 =?us-ascii?Q?0SRvm97b3MUOUsThyrMf6o2okm7t+UZ7tYji11lcvjj3NDKZa5WMsuN1VdX+?=
 =?us-ascii?Q?rWOF/v/4P4vB81UKXjZlaBpsNfGZvokVv3NJyhVtjPv5gEwLJV4ZXWXJVjpE?=
 =?us-ascii?Q?o2bRZChkFkssY9Iuq2DjWJIX/6YOmx5PXYtHOSH6BmLQaRE5rDapJSCzW9XU?=
 =?us-ascii?Q?jQQH5jt3SBESjpOHaJd+ayNhvr6hhMShcLE4QRlfwGDMX7c21d6WEgzWkE7t?=
 =?us-ascii?Q?WTON5LYBDLDIMMxY8Xwf/O3CUTqmUmQ+xz0JZSHtByexBtumfUL5UiFGKcQv?=
 =?us-ascii?Q?GZnC30ljt4OFVVdjv80tkXtiGkhIjKTTkDAFBDV0Hta1yHAIjUb8AOkBR/sk?=
 =?us-ascii?Q?bHMiBgVjZRb9XejDadCK4puxXZ948w4Nl2uaIjAsnCYEOVSvoSaqul3PDGWR?=
 =?us-ascii?Q?dQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4921c4f1-6972-414a-325c-08db05c691b2
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 09:11:01.0513
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xXP1QKbC9eoTiLSKgOOHejsAXGiI5FLUN59glfpTJjkXyxxiAaoh9TSaSpx9k0zkOC9TIEmYuMPOL+MpruflSWPA4Jef+4JRdFe+JsZKwkA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5905
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 03, 2023 at 04:48:12PM +0800, Herbert Xu wrote:
> On Fri, Feb 03, 2023 at 06:36:22AM +0000, Giovanni Cabiddu wrote:
> >
> > The content descriptor structure (cd) is already initialized to zero
> > before the function qat_alg_skcipher_init_com() is called.
> > This is done in
> >   (1) qat_alg_skcipher_newkey() implicitly by dma_alloc_coherent(),
> >       the first time setkey() is called for a tfm or
> 
> Sorry but what zeroes the memory in this case? The only zeroing
> I can find in newkey is when you free the memory.
dma_alloc_coherent() returns zero'd memory.
When implemented originally that code used dma_zalloc_coherent(). This
was phased out in Kernel 5.0 by 750afb08ca71.

	commit 750afb08ca71310fcf0c4e2cb1565c63b8235b60
	Author: Luis Chamberlain <mcgrof@kernel.org>
	Date:   Fri Jan 4 09:23:09 2019 +0100

	cross-tree: phase out dma_zalloc_coherent()

	We already need to zero out memory for dma_alloc_coherent(), as such
	using dma_zalloc_coherent() is superflous. Phase it out.
	...

Regards,

-- 
Giovanni
