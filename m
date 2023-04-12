Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CEA56DEAB6
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 06:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbjDLEru (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 00:47:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjDLErt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 00:47:49 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 953332D57
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 21:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681274868; x=1712810868;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Rfrw9W+tpt2rbWR0d11c4o7GKJhmu98cnIro6PigazQ=;
  b=kAuZMmwJSP6JDRYCkOM0NII7JRJz93ZHT5LthrAx7rFu5omFsyT+fBg2
   ZUdG1yvh9BJLYDVrnfvZK8YFmESpdWv4pTYf+f9tTIprzvC0BgcZU2Waf
   t/BGCMDhf5/lbGleothhV32hUBALGtin5sCiSY3DAhkySfqJ161AEgnHZ
   qYJH6IUREMfESISqlDgYw9tqfunrsuLz2IBDKm3qkiQ1C1bB6GcLxhL07
   +kPPo5oluOtDgRoh5BkBzR1RtkVv+qRjdXix4dIpwDFvVsErNCSzx5a+y
   9YrPEMr8DRQFyHFgE8L8zo04IRX1ZgXHkq/ngfrkkDTQjGKd7xXRlLoBw
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="332493278"
X-IronPort-AV: E=Sophos;i="5.98,338,1673942400"; 
   d="scan'208";a="332493278"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2023 21:47:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="863159812"
X-IronPort-AV: E=Sophos;i="5.98,338,1673942400"; 
   d="scan'208";a="863159812"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP; 11 Apr 2023 21:47:28 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 11 Apr 2023 21:47:28 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 11 Apr 2023 21:47:28 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 11 Apr 2023 21:47:28 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 11 Apr 2023 21:47:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SBjAXQ+kfN2ngM7kDT2xwsyUhUfwFpKMr40DQdq69K2TdVxyb95WjnotaL/vXq8opZSn0/lvgjfUiqpuZpNJiaXheFc3fBDMxmMWM2OpT/dpwr4lCbaHmzpd6usDU40tmUz8uBSk+CJto6BgWsk61MOg1rv4BwIuzp7uVHi7EWh6UMUa1JXwbcKlGIcqtpFZ05xv4Uds+4CqSc778W2tWtadsOHbR+yvP13rm8ZeYAEn3w8VrOB1vq7jNR5uiWP16cvbBaNkCGgvuEq3v0ZprAp3CjJF5D/gUviYi3dEbwpa1bqFI9pNjrbxwzS1Bou/9I1GkptG7AwzVwZ4obmcyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WeBSS3CcGTXREdgvdEYXEGW4xLWGehlaPJwSUipWVDs=;
 b=Evil2jx/N8z6yl2URGV0IbjtGGUmqDsbLzasCIR4HpK4si46pFrkS5Z5jzr1rTo28FIbYotcVDm9T1XnjIxDFBS7cRWtaHPEmuiv7mHkA2bsZHQz8NytQvKyMFqpxF22jC0GTpy5P4FbhDXsLvt2d5LcnOrIKxuSJB91Sl/Ue/FEU10QWvPSg0lDmQz98lHx2/qwywyYDWhNdhyNkXQjYlxVSDsb9D+QF1lImMk8nRw1U1PY85uFE6MJka8M8/oHwKU0KTbiKzuRix8g3DlhhslpIW9UZmGxsXaaElkSf2TjyFfBKraNdGWofHH5bSSNOINe7uvXpPXu8HFAHPOI4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL0PR11MB2995.namprd11.prod.outlook.com (2603:10b6:208:7a::28)
 by SA2PR11MB5116.namprd11.prod.outlook.com (2603:10b6:806:fa::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.36; Wed, 12 Apr
 2023 04:47:26 +0000
Received: from BL0PR11MB2995.namprd11.prod.outlook.com
 ([fe80::b4ed:b620:b6f7:f1a7]) by BL0PR11MB2995.namprd11.prod.outlook.com
 ([fe80::b4ed:b620:b6f7:f1a7%6]) with mapi id 15.20.6277.038; Wed, 12 Apr 2023
 04:47:25 +0000
Date:   Wed, 12 Apr 2023 12:47:16 +0800
From:   Philip Li <philip.li@intel.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
CC:     kernel test robot <lkp@intel.com>, <stable@vger.kernel.org>,
        <oe-kbuild-all@lists.linux.dev>
Subject: Re: [PATCH 5.4 09/17] xfs: simplify a check in
 xfs_ioctl_setattr_check_cowextsize
Message-ID: <ZDY31JiLR2k0M2dP@rli9-mobl>
References: <20230412042624.600511-10-chandan.babu@oracle.com>
 <ZDYzp9l2Ku6cbtQC@ec83ac1404bb>
 <87cz49lnjz.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <87cz49lnjz.fsf@debian-BULLSEYE-live-builder-AMD64>
X-ClientProxiedBy: SG2PR04CA0154.apcprd04.prod.outlook.com (2603:1096:4::16)
 To BL0PR11MB2995.namprd11.prod.outlook.com (2603:10b6:208:7a::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR11MB2995:EE_|SA2PR11MB5116:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d693167-37ef-4305-6a74-08db3b11030e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RX3vIIbXSU/JTi2ocC8FYacxBsEkKUleSjOv+x/GBUDtsXjRZNMtOkTSzj4ALDqYbU5vqOheOkK92oo4jYreKMb47vozrG+RXIVnR6ekHOooGKJU0ju8siblBXDeqRmMqJr/p6km5h8xV6R5dIMk288RUAsts+SKjcy9vjaZIr7da41RrWlZ1o6xomxQYEMt9xnbllkqXlcOwrMDFgmVkvlT7OelfRMcAQyQXZNXjUPYRFL/cRI8RrKSPfIBibfU8IRO90+omKbyi/8ZTFNwOe3cGx5ZBnAGlhVZnl3RMfjgA7AAkylCd+T3ISexk4d+AcTUrmGMHqLWfs5/HyatBbp19sEd/Mc8TvPDfxlPh7bSPoPV/JwHIYkNMDgDRO4oLDvmNlkXPaFBalCEpqg5HbR8ya3IphdlyDorg65Sxh4ZrUsW+Tfk7VxV3+pSRV+IlVFHwo4nVmhdUvWgJWD42i+x9SGuRaqlWTz8ma8oS5LzWqA636gqbYkdTRRp7041xXmlqehSffUMMdFcXWLwzkaBfJPc10TH0/liX1J6s65RTJCMAo6305DX7YDhwfs89D98Lg4nU7UuOBXdGaS2PA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB2995.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(39860400002)(376002)(346002)(396003)(366004)(136003)(451199021)(478600001)(83380400001)(86362001)(82960400001)(38100700002)(966005)(4744005)(2906002)(33716001)(9686003)(6506007)(53546011)(44832011)(316002)(66476007)(6512007)(186003)(26005)(8676002)(66556008)(8936002)(6916009)(6666004)(6486002)(41300700001)(5660300002)(66946007)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?I2GZ7bmsDyXPzs0M5QW7ZULo2VVDZSxBnNThKUoScnJ2p5qRYgqeTUB2fGjq?=
 =?us-ascii?Q?MC2r0H7F5Q/HZ0Vxgca5N8IlsCLPefF4Bs+BsFdPFf1ag3dhjOvE0pGnVcgP?=
 =?us-ascii?Q?6aJLZ6KTd+e0uusUyiQz2EP30W/GkjLZcs1piaFup6B2LkmS00ml01C0zi0c?=
 =?us-ascii?Q?9xbxS+/9czMQlfshWwXYVgzfiwnaPvFkhdEKGVZ768DcIS4j0fWxyohlyR8C?=
 =?us-ascii?Q?xRVFGCrFoHZuKDNz0LXgKM1mXJwzUeuiBqY3gsit+ZLPz4BQwt72mEPOfrkr?=
 =?us-ascii?Q?sFGpB9+bowt+LnFy3Fiy+cgVtipTtIol8bQfi8haXO2aKkwesjeuwRWHWDOs?=
 =?us-ascii?Q?FkH+KvGQ4uyw8uIdVD+hxPCJqWYpz9qNZeIIOaQpZJ7es4IGKBqbAjvKUH3i?=
 =?us-ascii?Q?kXQqaC7ffynpJ8hcpwFU/kVcuDooURedKNHBrLGJBCtDfJDckhM5qZqQBMyN?=
 =?us-ascii?Q?DrRsJgbHD/tvh60haV8bbui2AGOtKo0Cgf61uQw57Ds2RwzkY1w4yrINmmhA?=
 =?us-ascii?Q?XGoRX9RMDk5AXBxrl8QYXpsynCpGbunIHwK45yPLC1iRS56hsfIAvjV5Gx0A?=
 =?us-ascii?Q?pKvI5wbH8dlEG9NuQbPII60n1A+zGgdyzNG1HXIddomy9Ws7bZnQ1Bq6Z61H?=
 =?us-ascii?Q?+fV/Ehkp1dB3Qh1RK4ucDZm/H+fAw4MIplRkbsU9SrXTUPdngl7a5Z4jWGWv?=
 =?us-ascii?Q?RTyhYT18VLJ4Mprk/oSe5JtINEJ72REO/rV7KFwASOhfsU2707+J38GuyaJd?=
 =?us-ascii?Q?UT/UxXOlhHSOhNY9VpBftYILKWT4M+/OPEwxruPdMyHsZsULDH5WrJFkVwuL?=
 =?us-ascii?Q?hqa/fCAOANvcPX/JNKThiGZFXwuwcRfJbPCb4KLWRVlLEQypUMlBLMkysQv9?=
 =?us-ascii?Q?g9H0ezgkjKLPD7Dn6cDl/D7OinTt60f+JK3fZQUtb/XrwPLzrub3k0Gvvznf?=
 =?us-ascii?Q?Jyiy/9lSNMQIvnB2avA1nPl424/kdC9bPcmeuNwheqBY4nsJVvzPGY2kMuKC?=
 =?us-ascii?Q?doW5h9tPMN0qYg1eF6O6eXTQwb42WAZA8X4GqfPNxd9Z7Jg+Gg9hdWE9dQXC?=
 =?us-ascii?Q?adK1KNzMZcgar3g49SSefrRYwwKnWpRVjdbZEFqlebXgq6vsyT+XLLZbomSN?=
 =?us-ascii?Q?/RpOE55hJZiftkBtj4kM/8fcmKjFrPNbzwmfoDVc5E/6cxoIt7ezjO0sZFQS?=
 =?us-ascii?Q?y9kHY1uV5c0ZEg+7wYAyldlAHm4b78dnP5ZTdCLDW1SZd6bXcDhNVnz99uaX?=
 =?us-ascii?Q?CiXTeVtGHegZd/mPCAGz14KmWluY41LWQBr0uBCcoxCViVGIvpOXUW5gJ50S?=
 =?us-ascii?Q?v7vsFsyRoQTTG60kQp8zFSHP7NhWEDNEbaTeIIpideEJY88qs5MIgX7ieqon?=
 =?us-ascii?Q?iG9+Z0SCdYWIPsEQ4nvrqCl6Qu2YvvXAZ7TfNeAYYtVwTBc+bULn3TsGcJJS?=
 =?us-ascii?Q?AO+So6I+Ndr6wpjGDA5teMsjdsO8M1i4abX9WgonrmeEcp1J6b6xHJn5js/s?=
 =?us-ascii?Q?5lSxcpGoGtBm3mBAirJpMtwG6eGUYZ+ml7HtnbIhSVYFjMamV/N0JmW6VAxv?=
 =?us-ascii?Q?d6dP7Jqau2BHomvvkW3WUcx5mxt9NU5XVwln8hDc?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d693167-37ef-4305-6a74-08db3b11030e
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB2995.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 04:47:25.8435
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y7nr+ohxrsyboR8SVIiIYYwZwVuh5BR1EtGWA8v2M6mXSmbarMk3WUdzvSspvZf7LJt9antGFwhcimRNd3dUGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5116
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 12, 2023 at 10:06:59AM +0530, Chandan Babu R wrote:
> On Wed, Apr 12, 2023 at 12:29:27 PM +0800, kernel test robot wrote:
> > Hi,
> >
> > Thanks for your patch.
> >
> > FYI: kernel test robot notices the stable kernel rule is not satisfied.
> >
> > Rule: 'Cc: stable@vger.kernel.org' or 'commit <sha1> upstream.'
> 
> I have CCed stable@vger.kernel.org and also mentioned the upstream commit ID
> in the commit message.

Hi Chandan, this looks to be a typo of "uptream" in your changelog

commit 5e28aafe708ba3e388f92a7148093319d3521c2f uptream.

Thanks

> 
> > Subject: [PATCH 5.4 09/17] xfs: simplify a check in xfs_ioctl_setattr_check_cowextsize
> > Link: https://lore.kernel.org/stable/20230412042624.600511-10-chandan.babu%40oracle.com
> >
> > The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> 
> -- 
> chandan
> 
