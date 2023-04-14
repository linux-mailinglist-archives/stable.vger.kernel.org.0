Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60B426E2B42
	for <lists+stable@lfdr.de>; Fri, 14 Apr 2023 22:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbjDNUok (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Apr 2023 16:44:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbjDNUoh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Apr 2023 16:44:37 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0FEE72AA;
        Fri, 14 Apr 2023 13:44:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681505066; x=1713041066;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=pJAiHeVfIgbEGi/DaZqiXX5lD/S9H6cFfX4ChxBf3+w=;
  b=meqEuJ2tAbQPXs+jmwjrZBVt5nmye4QdTwOlkAFcfSBbzGTcgsytiuCb
   33QwEZzuBd0NQFxIepr9m4LJxTu7iVv9FGxsO7DKSltzr+c3HRSOLsxtf
   gZS+a9Kpbs5/MjxCoac0AimUP1xCipZ20O25xlUa87X4DGfN/VBvnE0lF
   9kUWa425lIJkmkr8PHlT1lodZGpBac03FTcKrZx0SnW+4Bw5owzBQn05J
   ML0ebWuTGROZe8bu6mp0prjseyxUdATRu4YHCfzk7gaYF/4TFhNQfYjHG
   rZ5KdTEHAnPXMXsSwdQi+mcTpigTBDzxRCu3q/I6Gl1BiXrKDzvOyFiGC
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="328723191"
X-IronPort-AV: E=Sophos;i="5.99,198,1677571200"; 
   d="scan'208";a="328723191"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2023 13:44:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="689954311"
X-IronPort-AV: E=Sophos;i="5.99,198,1677571200"; 
   d="scan'208";a="689954311"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 14 Apr 2023 13:44:17 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 14 Apr 2023 13:44:17 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 14 Apr 2023 13:44:16 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 14 Apr 2023 13:44:16 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.102)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 14 Apr 2023 13:44:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LuTtiRyBPtHj1EKsHzErooV3bjjr78rP/e7//QnQZoOzPYkX4T518k83If6NfJyd96FF7H4lOtmk9d98C5uh0f1Ur05eUl4ajhczbP0L+0WV6MNjOkOX9LCBfCG+2RDY5Nf6CwnhQ0GOfuSmiEljjJhMaQTrFHzCOYfo7dM5iB2mCukGRLXJaszn7Of6iAEmJOPVcre99QXPP6zvp9UPelXUSWrLaDhxRh3VvjsT28m5LTKsbUrwFMy3qJlA4NHuSNhSSQXp09hozTLBKyy2PaD6pSe0qThhqYaCMcSz7HOEmskzWrF0vXWJxG5jezl5cv7G3v+qyNGmldUVOiryNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZgHnh3VvjpJjtQXJxMwJtuwuxsKqt89nLtMjsA5LnEY=;
 b=GbdjMF4a73l/5wdwbyJ8bodQiDYhW3GGO6xXyy85/Wl01Ew4nn31ZuKp7XwzwBIPxswE3uXykxiQ8AMKRvuDg5INoKaG7AgjKpBLd9IQk1hYFCZa4D2ny+kqRl1x+8yVk3OJqbsLEAddnpw6DXD9oY3KAlH90IhAxqCNYjNFg0uvtVTIYk7Vrw5pPyCt9P3QN+iAmWUFYPZpCViigfSvn/n/M2Lh8NIgq6zysPrS/13YYItSQC/hPHKt4wW3UAkrqEN5Tiz6KsVzyalw/C1jX8YuhShMd8OLgd+rv40R8Uy7ZcSMM/zJe5kMfy8RMkZDWp8ARaN//wlEb75R/CwrxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DS7PR11MB5967.namprd11.prod.outlook.com (2603:10b6:8:72::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Fri, 14 Apr
 2023 20:44:14 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::ffa1:410b:20b3:6233]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::ffa1:410b:20b3:6233%6]) with mapi id 15.20.6298.030; Fri, 14 Apr 2023
 20:44:14 +0000
Date:   Fri, 14 Apr 2023 13:44:11 -0700
From:   Dan Williams <dan.j.williams@intel.com>
To:     Alison Schofield <alison.schofield@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
CC:     <linux-cxl@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 2/5] cxl/hdm: Use 4-byte reads to retrieve HDM decoder
 base+limit
Message-ID: <6439bb1b57819_417e2949b@dwillia2-xfh.jf.intel.com.notmuch>
References: <168149842935.792294.13212627946146993066.stgit@dwillia2-xfh.jf.intel.com>
 <168149844056.792294.8224490474529733736.stgit@dwillia2-xfh.jf.intel.com>
 <ZDm4TqspwS3AAQSr@aschofie-mobl2>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZDm4TqspwS3AAQSr@aschofie-mobl2>
X-ClientProxiedBy: SJ0PR05CA0015.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::20) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DS7PR11MB5967:EE_
X-MS-Office365-Filtering-Correlation-Id: 2603b45f-8d62-411a-c5b3-08db3d290182
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WrfniyT3Zd9hmZrq+E4ePJif/Mcrn5NM0En6I4udqHdXSj0CVFDpa9mT5O1amPL8HTNfPeYgs1ikVuv6gSa2eRgQhydEt/trLVb5GfZWQv3efqts9w34WNMXa6zvwsVq6gApTNSYUjtzEQLYD6bFJgSwOmf9PzqDZtcp25I7xBCPjl8ftb2lQPGe3kLEYy7rrARfZr4G0oXGdGwRkdcoLI2ooeIhn2HHBNU99mD/aCBvBIHXkMZoFWLPcxb7Do480uHV1VhvcCMCYTCi+Mg4/9JgVfFb1s9DG5lIeaoDNXMmnkBpiSJl9Zk3tFOw1ewUQHxesh1LL+PUbYeJB4p9nHuEegyA4A2vNiGu5NI5oDh1FaDn8iLC/UA3pncsIvpigxWJ269C4I84Kcz1zjI3PVG3NYkDIB1y1AjfJyb01t2EnaYMvx2CK0MqM4ItEAvibFcFitAZEFLK2ZFbTEeQ8sjJV3buLC8kUtu0OGHgU4UBYYcmcV63eDdtP9sz76M4QBDHzD18Y5uQ6qBbgJM0skmbg/gK3i3+eBhkD78nqVvkCVzmMpzjbONVIKGe+u8C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(396003)(39860400002)(346002)(376002)(451199021)(86362001)(110136005)(82960400001)(316002)(478600001)(41300700001)(8936002)(8676002)(38100700002)(5660300002)(66476007)(66556008)(450100002)(6512007)(6506007)(9686003)(26005)(186003)(4326008)(66946007)(6666004)(83380400001)(2906002)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ynBJzfUA3s6AU7YzaaI1rL+j1vaJDLwX+QobuhfEzdNS7Zt6GkPtkiDPEvPR?=
 =?us-ascii?Q?+sA4ffdmjQ6JTo0dk/pgFJwrHOeOOq1hN0pbxtijPf047Ow/+v4qcv4BEz1a?=
 =?us-ascii?Q?Y1/9mytbhxd9aP/MsPO508qi6gH72HQqtuPP94FXO1JOM+4ZF9dt6bS+aOT9?=
 =?us-ascii?Q?ukIvp9DOdp5JrFFJvp71q6dQObKkKrZR7+rWg/Oc4aMjB7E23HsZEd7SPmpH?=
 =?us-ascii?Q?TOOtQo+g1v4zZt+09wHMIfu86F9reBmRM/fUPbyNw7rrQEUhGN35TVKx1+5M?=
 =?us-ascii?Q?Rgjhd272qlGXVuHguHsmiNmN1JXQ+T42Qw/DHKrQxXD3f/jGpk6RvVlD/l/B?=
 =?us-ascii?Q?kW4ajNyv8IdLgZtxLDYQdm5BV+MV8WBjIb0/vhe++Slv3SZ8RtfLgOfE96oF?=
 =?us-ascii?Q?+aa46z6VcmxHKk0QNlexI9UIq7wFw05hqD73lnFAFTlY08JIOkcZ7FioMevk?=
 =?us-ascii?Q?6rBVZtBuyqSbuCy4MkqNmV6tUkUAAJKZcNS58qGum9jqJw3kBfSAXkWrXYd6?=
 =?us-ascii?Q?WUSq6fELjAFmP2KZJN4Yp54MkgpuusxUREb9I8XRhJ4xvza/SOMW6fcO8MAc?=
 =?us-ascii?Q?jt8yQ9xGFf/++hTDF+9GZAF1vqBQcnNLyKpCjNyrPatUIH85ESRpTTwd1kVa?=
 =?us-ascii?Q?hxkxqmycB2kANL5B4JyCEGr86snZ76w6YpVGiZHEnoC+E9ssiPwsMKj0yLR7?=
 =?us-ascii?Q?LYE5ZLc80E0OzVeGLDmHykZgra2fthICcdJzJWDYE6le8EvphOcxVN+uLw+0?=
 =?us-ascii?Q?Au+Cw7VACrmtys5pwrBAbiXjjQJWIP+i1kOPTaowpYZYsrjDSt4E2oagCI0H?=
 =?us-ascii?Q?4rncjs4Z+0EaajVCXI/mkrBcweYNpFsm1pz8nuk0uAm+q41nUpANZapDz0PU?=
 =?us-ascii?Q?liY8/TwsNaSehs6MoWsQK949sgHKSm1KLMGhO4AV3ttDTnPUzVIXaigXtIem?=
 =?us-ascii?Q?5iD+4BfVXDfFmb/SykqNEdmwGguZY9zOhlukx212b1Ct8JVFbwb9OnYjTdBp?=
 =?us-ascii?Q?cEd/8PQbKNBEEdrqAq1Np4Adb5tEWMUKHouWfTvK7dedo8XjCTUivb22un4+?=
 =?us-ascii?Q?ZmK92e5Jw0qW+XSbcrtx9cz2l3nuzrrPzIaMpGBDz0N+prVqI8KbAlq9JtXr?=
 =?us-ascii?Q?jmJ6M7LpUQYFkdajbUBPGR3eq/8Vekd2RZShM6g+ZHl5rN0JvwdbzRSfmEBH?=
 =?us-ascii?Q?8er6qkAh0Aq2mKG4UUppjo//mpEb597ZWhBMPvVobsOdv1UzfW2ORo+UY+BW?=
 =?us-ascii?Q?QO4srONptdVFBqzvwbh2VbzlidxnU+zR88jM9yLpPXUpZkuoqyc6CDJeL4b8?=
 =?us-ascii?Q?LiL9YUEhf2MA/xVkTN3GJDPy9AIDi/zPosj5+D2XWJXWIe/wI7zsnFiLXUJI?=
 =?us-ascii?Q?6PUxw6I2r9peMNmRbOEogKbOX/EHkiDXuGWWQw2tRl04nJJKg0OkSXbWlYJc?=
 =?us-ascii?Q?bZyB9Q4CwOApGd7QpAmE7ngsaeKps6TJnNRHTY/RLedqhSYGTLPs83serkrq?=
 =?us-ascii?Q?/Sc9b7FNurF93SERRJWHn47lKm5h9QbgJyDtp8TWdQf9ibrRezBgc4yZ1PuW?=
 =?us-ascii?Q?VMFQv+cwRPqO/YbaAWVNxQDJ6KkuSSVrF47hbDIKu2WIZ/LVD5i5sKFMvjUN?=
 =?us-ascii?Q?hw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2603b45f-8d62-411a-c5b3-08db3d290182
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2023 20:44:13.6592
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oBfAn4YAspQ1ErDEYQ69HKXFew+/pkniyfFlO7FUcxDWkHBJvbGjo1kihBaJFmTKTIu2cEvMXV2l5B3kh5K/666NKu4ih/Qt2BghTjNw7lI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB5967
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Alison Schofield wrote:
> On Fri, Apr 14, 2023 at 11:54:00AM -0700, Dan Williams wrote:
> > The CXL specification mandates that 4-byte registers must be accessed
> > with 4-byte access cycles. CXL 3.0 8.2.3 "Component Register Layout and
> > Definition" states that the behavior is undefined if (2) 32-bit
> > registers are accessed as an 8-byte quantity. It turns out that at least
> > one hardware implementation is sensitive to this in practice. The @size
> > variable results in zero with:
> > 
> >     size = readq(hdm + CXL_HDM_DECODER0_SIZE_LOW_OFFSET(which));
> > 
> > ...and the correct size with:
> > 
> >     lo = readl(hdm + CXL_HDM_DECODER0_SIZE_LOW_OFFSET(which));
> >     hi = readl(hdm + CXL_HDM_DECODER0_SIZE_HIGH_OFFSET(which));
> >     size = (hi << 32) + lo;
> > 
> > Fixes: d17d0540a0db ("cxl/core/hdm: Add CXL standard decoder enumeration to the core")
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> 
> I see you got rid of ioread64_hi_lo(), so this can't be
> happening anywhere else. Are all the other readl, writel
> usages known to be OK, or do you need review help against
> the spec?

Good question. That's what I looked to answer in patch3. As far as I can
see all the other readq() usage in the driver is for registers defined
as 64-bit, so that patch ended up only being a deletion of unneeded
includes.
