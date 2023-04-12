Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22C8C6DF6B4
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 15:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbjDLNN5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 09:13:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231466AbjDLNNk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 09:13:40 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AF859EDF
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 06:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681305183; x=1712841183;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=AUF/quekUUxpvCLmCm9hA9iDAkEAkug1moBhE9M4uvA=;
  b=SwwQxGvBL6a9MNahzj3HgBh5AmgCZTmo+Fx/6JHRpwqomeXvSEyS4Vmx
   KVHzfdg6q4d8gk7vTiK7IHf9Q6s3qnRoqMygN40vHEDzX127J0nASt8bO
   agnmdylGYowVICqysPMsfj63k9jcnlo0qJsUvH/Nt6SuaFnaXFDtbXztb
   8NVw54k8OYv7wqXVogEmO8kutOJTHh/CLSZSzRGGx3J+QR9JfvcesyEXB
   7wBNSCiqvnQG9JD0tq3r3fGLSdPvZIGdkbCFdVt+3UBcKSZk6T+Wy97DI
   nJXmCPlWgPP6/8VLPKbPyyNvfCsU0HaGJ6EFKF5qIeTn46rUb5PW0VFs5
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="371742909"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="371742909"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 06:10:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="666352383"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="666352383"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 12 Apr 2023 06:10:24 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 06:10:24 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 06:10:24 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 12 Apr 2023 06:10:23 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 12 Apr 2023 06:10:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BAJvZKj4ILFSB3kWe5/zyiYpsAI5TxTQ1um3NIqKlsHZFiMe6qulLtiQyCoduiEAVEpMgbc7H66+gsgKSVzUHSQaP4ohMxxPn2wUKF2H0fBe5ggOItjZy3nuScDkROLJuD5KdFZflqy5SWMSucSBG0FGTcJxF0S62Y5eyHrbPFsjyQ+Wel4e/4yf8TLBVBOQ+2LYzD4U8lO/kbNrIx2xja/XA3YJRUetZ8YzYN2jcneLcOmtMK5tgLl29TQks+DxsqdMWwDX6+OrGdCqzEQrCgHWUQQoEyeane+resK5lDzOH9dpMaGRoagxJrCUt/XWZMH7drbeAuCOqQ/oHJi9wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XtfNe7Mtht1pYhZUHzhSOdf4oYi/IAM4Y4qqxOx3DZ4=;
 b=FCeJuRmUgBsnckcUOAbOArHYVsxx62XKPFUUmYOY+oBdSKbB5Sil6os68Hts8ORbaaL1rhSlOV+Oqy1edvULYIcjk/XEQsHEvVZTFkhOWrf0mfUnOOw8D0x0LoXPE3Ya3bj5dGN0BBP47ru1hevN+3TlZ1N/uTr1ErVrEkhJsYOArtuxVV/pTg/jfhBrGbrA/RUJo6nRFPl6FZE+PeitRNyWeEgtMa/0fjj2aEO2dGfmDZt6Quur9Yd5MWqWDIH8iJDeQDNe936hc6JCjD2xZJk0NhXvjYR3KxBXGb5j4/HYcJgLnYwOVy9u9R8rpuJhAa9JEDL7s1aMm5SmTwsZYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB6059.namprd11.prod.outlook.com (2603:10b6:208:377::9)
 by DM4PR11MB5503.namprd11.prod.outlook.com (2603:10b6:5:39f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Wed, 12 Apr
 2023 13:10:21 +0000
Received: from MN0PR11MB6059.namprd11.prod.outlook.com
 ([fe80::2b57:646c:1b01:cd18]) by MN0PR11MB6059.namprd11.prod.outlook.com
 ([fe80::2b57:646c:1b01:cd18%6]) with mapi id 15.20.6277.036; Wed, 12 Apr 2023
 13:10:21 +0000
Date:   Wed, 12 Apr 2023 09:10:15 -0400
From:   Rodrigo Vivi <rodrigo.vivi@intel.com>
To:     Andi Shyti <andi.shyti@linux.intel.com>
CC:     Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Andi Shyti <andi.shyti@kernel.org>,
        <intel-gfx@lists.freedesktop.org>,
        Matthew Auld <matthew.auld@intel.com>,
        <dri-devel@lists.freedesktop.org>,
        Maciej Patelczyk <maciej.patelczyk@intel.com>,
        <stable@vger.kernel.org>,
        Chris Wilson <chris.p.wilson@linux.intel.com>,
        "Das, Nirmoy" <nirmoy.das@intel.com>
Subject: Re: [Intel-gfx] [PATCH v4 5/5] drm/i915/gt: Make sure that errors
 are propagated through request chains
Message-ID: <ZDatt0vKsRECOYTD@intel.com>
References: <20230308094106.203686-1-andi.shyti@linux.intel.com>
 <20230308094106.203686-6-andi.shyti@linux.intel.com>
 <1bee29d0-a5cc-9ff3-d164-f162259558e2@intel.com>
 <ZDVwMawvlOLZ2VZt@intel.com>
 <ZDaOWhKiG5jD7ftp@ashyti-mobl2.lan>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZDaOWhKiG5jD7ftp@ashyti-mobl2.lan>
X-ClientProxiedBy: SJ0PR13CA0124.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::9) To MN0PR11MB6059.namprd11.prod.outlook.com
 (2603:10b6:208:377::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR11MB6059:EE_|DM4PR11MB5503:EE_
X-MS-Office365-Filtering-Correlation-Id: e24d3d1d-fe5d-4406-5531-08db3b574538
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CizmaML7oVEfSARjkgF7/c9icoEU+wBLcKzfu20eY0dT97UeJpj3XfGA0njxm/1EQqMhZmCsRB5UkT6pWuep0z7zEdZld1qUUkukjlJplpcSzTkko601pgoBFx7DqiZitxtWCMzTb1uFuCtdms/Iul/GF0HrWo5d9/1Ccu9yOr0+wfeZdJ3vOYGN/z1diDLSg8Aw4ak60EdeDRQ5yWQIaJmI0V4VarnjfImsb86ik2TDO1SoSv7FQ2Td1p84lIt3VSuoCP27u/IdTGJ6uUDbWgTJCZ5c5pOe+Bosy3kLajugpOrTVUOVKbHrSNY/CYHZXKZj8hvFz7A1AnMP/MZQFUaJig3ehOkmVN9qCJBSQSFTdagqArG8QDGZKN0bBjJft2bflRoGVd1ykzSQQqCh+IvD47JcZgVtqkmJDHu7z4ylQ3I5bmwomINoMONQE3bnuhhS2DRzOGCx7NYYHnsWeNMFfOkFZ8ePZe40HvAoJavtLD2VLePySDIib5T5UqrV8pTmOlNSNpcPrgQr3rMhFPJIqIiAtaNn9gUtrDFehHM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB6059.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(136003)(39860400002)(346002)(376002)(451199021)(54906003)(44832011)(86362001)(66899021)(478600001)(316002)(41300700001)(82960400001)(38100700002)(8676002)(8936002)(5660300002)(4326008)(6916009)(66946007)(66476007)(66556008)(6506007)(6512007)(36756003)(26005)(186003)(6666004)(2906002)(966005)(83380400001)(6486002)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bUdmbnIybDgzVlBaS3g3WmxFbGRLUk4wOTY5MW1kRmt4UWVsKzVjcTVXbU0z?=
 =?utf-8?B?ZnRWN3YvOHA3N0JCanMxdkszQkNEYUsrU0VPamdiTGVaNU84d1g2bTd3RFlW?=
 =?utf-8?B?cFhqbEc2K2NFN0tFVDdZWFNVSnd3dU0vOGJqRis2U0ZzWXUzZjcrbTlraEZy?=
 =?utf-8?B?MWI4WGpXMWNKVEFMUWJMQnZzNFEwWWdOVDNUcXhrWExmb1lMdEZHdkw1Tk91?=
 =?utf-8?B?TXhBY1BlUEVWaVlmU3lZOWdzZTNsOGppQTVpUlp1dlorUktzU0lxU0NBU0VI?=
 =?utf-8?B?MGs2RDgxb0RqUGZNRy90b0NJbi9RZkF0cC93T2FaZkJzcFk2NU1hVVBuRjRr?=
 =?utf-8?B?d3dLVEVNeVlrcHJ3ejhHY05rWGxCUDczVS9OZEc3OEdOZ3IrT3NrR2NIL2Rp?=
 =?utf-8?B?VkFxUDdEelcrMkFEZVdvMnFVQlQvTXc5dkhicTN5YWxLSFJsWkY2eEhZS3Vq?=
 =?utf-8?B?STNPRzUreWxGOTBLSWhqS3V6aGgzbm5jbEp3YzQ1ZDdsMklBOXI1SXU4cG1p?=
 =?utf-8?B?TXVDc1IvaEMvUTJEQWUvS0wzZVdYMk1ORW1lbno1UzFtWVJaQ0xjcTJMdXoy?=
 =?utf-8?B?MTlqNjJ5cW0razJ4TjJHUlExRE1ucXF4V0Z4Mk84cVZIaC9oM2ZDS1BWcE9I?=
 =?utf-8?B?N3hmZXdlRzNwSHJneXBDYnRhbmZLQmxEWTk0cDBjamNNTFkvN3JXUzYxMk8x?=
 =?utf-8?B?eGRkdHlVR0drSEE3b2Nwb1VyUHN5SHVDdXZFNnc1U0krVy9BSy9LZHpZeC9Z?=
 =?utf-8?B?RFE0RlQxaC9RMTlkUTAwNGNRdXY5RldPZ0V6MUNZOXRpK0xxM01ld1FrSm1u?=
 =?utf-8?B?SzIyTFJQUVFZdUlrbjVZNTFuZ20yOWx0b2NQR2kzSFZCc2dIY1FvMVYvNi9D?=
 =?utf-8?B?Z2NNUjJVb21zUi9OU3A5clI2cXVyREFFMXhkZUFVdHBLc0VLTjdtbzhtVzBw?=
 =?utf-8?B?TngwUlJrRk8rWHA0ZDltbmFzbHBEYm1XWEFDbUs0NHMyVUtRYUhwVmUra2Ny?=
 =?utf-8?B?Zk02L0xhQVJ5eStUVklTQ2Z3UVgrVmRXVy9SMllSV0xiMkthMTNWU2dJLy9Q?=
 =?utf-8?B?Y0FhNi9sNHNIdnpxZnNPZXdNNGpOb1lIYitURnplSzAwdmI3eU1KQXJFU3Yr?=
 =?utf-8?B?bnVIc0piTjU3ZEdES3BCWGpXU2x5LzUvSjMwZmZaQk5sRzFJZDZwS2lzUnFY?=
 =?utf-8?B?eVNTd1pHVjFWSUlmV0QxQUpzSlhtOUVtL2Z3UkxkblE2ZUxMQ2ZYZzF2clBF?=
 =?utf-8?B?M3lJcVNhaXBPTEVIZTBhaW1FU0Nwb2RuOGJld0RFMnhPVTNwTjE5dVlUeUdT?=
 =?utf-8?B?L0tmTlZ4Q2pWeWlQOUtFeWQ4QkxmUFBtYTIwTi9BUmlhRWhDRlRwMHdLL1BI?=
 =?utf-8?B?U0lFK0FNZWcrUFEyS1Z4N0V4WkVCMmhXV1M1aGJCa0R6d1g2QXJrRnlTVWIy?=
 =?utf-8?B?RllTWXVwNGhIZ000Z05vSXgvejhKeDRvZlJzUzgrWE93VC9SNXpkbkZSeTNY?=
 =?utf-8?B?WWtlb25RYnJyc21jdENNcG1pUVpvTFBmQm9iNDQ2cUdqM3ZKVE5MQkFyQW9n?=
 =?utf-8?B?VW1aNEFzUzRxSlhIWlQ5cGZQTHJqZ1pHYkQ0aklhTXQxbGJSOTcwZGVtNC96?=
 =?utf-8?B?bXdZS1Erelp5YWM4MGhtZlhPeXIyNUw4L0JlUy82eU9kSE1rNnhRaGdENDFu?=
 =?utf-8?B?bm10K1VMZEZIUFBTMlpTQ2FnbVg3cWJrUGZVT3oxOXFGVmtBV1NCci9FdzQw?=
 =?utf-8?B?M3lGYW5wOWdzd3BkamZEY2ZyVmkyOUxuSjQzVnY1TC9TV3VWTjRiTzBmOHRO?=
 =?utf-8?B?bmRnVGJpVFpQcVBDZFFmdmhtaHJiT0lTNC80STNhMjFCTVNiNkgzYUFxaVc5?=
 =?utf-8?B?dXRtcDdMcUcyR1FPOXFBd0FXOWN1SHVsUFo3UXNZVWNBZVZiUldLRy9SdFl1?=
 =?utf-8?B?Y1c5Wnp4SFV4aUxTKzZkR0dJQzdRcnNUNkNSRFpTWnJMOWRuNnBRK1VtV0R5?=
 =?utf-8?B?VVpEcmVja1JTQ0syMVJESU1va1hyOUZDZE5pQnZkTWlPd01KKzU2M1UvMmQ3?=
 =?utf-8?B?Y25ZYlBWNlptV2hvdEdKL2M4alpxTGhxM1ozVTZTVm5sOXBMMllRVjQ0MnEr?=
 =?utf-8?B?eHR5RU1lQVJYbWdidks1cHJxMThIbkJOaXR4RE5VQ1hZRU80Z2dXaTN4MGdQ?=
 =?utf-8?B?NEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e24d3d1d-fe5d-4406-5531-08db3b574538
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB6059.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 13:10:21.4818
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kEltoNWIssEXoavfOsXjJ8HlGsoh/a3cU6FOVukYOgTffs29lSuW2zO1/mCde5HAEGppuhm/gIbZoGuBSTWITA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5503
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

On Wed, Apr 12, 2023 at 12:56:26PM +0200, Andi Shyti wrote:
> Hi Rodrigo,
> 
> > > > Currently, when we perform operations such as clearing or copying
> > > > large blocks of memory, we generate multiple requests that are
> > > > executed in a chain.
> > > > 
> > > > However, if one of these requests fails, we may not realize it
> > > > unless it happens to be the last request in the chain. This is
> > > > because errors are not properly propagated.
> > > > 
> > > > For this we need to keep propagating the chain of fence
> > > > notification in order to always reach the final fence associated
> > > > to the final request.
> > > > 
> > > > To address this issue, we need to ensure that the chain of fence
> > > > notifications is always propagated so that we can reach the final
> > > > fence associated with the last request. By doing so, we will be
> > > > able to detect any memory operation  failures and determine
> > > > whether the memory is still invalid.
> > > > 
> > > > On copy and clear migration signal fences upon completion.
> > > > 
> > > > On copy and clear migration, signal fences upon request
> > > > completion to ensure that we have a reliable perpetuation of the
> > > > operation outcome.
> > > > 
> > > > Fixes: cf586021642d80 ("drm/i915/gt: Pipelined page migration")
> > > > Reported-by: Matthew Auld <matthew.auld@intel.com>
> > > > Suggested-by: Chris Wilson <chris@chris-wilson.co.uk>
> > > > Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
> > > > Cc: stable@vger.kernel.org
> > > > Reviewed-by: Matthew Auld <matthew.auld@intel.com>
> > > With  Matt's comment regarding missing lock in intel_context_migrate_clear
> > > addressed, this is:
> > > 
> > > Acked-by: Nirmoy Das <nirmoy.das@intel.com>
> > 
> > Nack!
> > 
> > Please get some ack from Joonas or Tvrtko before merging this series.
> 
> There is no architectural change... of course, Joonas and Tvrtko
> are more than welcome (and actually invited) to look into this
> patch.
> 
> And, btw, there are still some discussions ongoing on this whole
> series, so that I'm not going to merge it any time soon. I'm just
> happy to revive the discussion.
> 
> > It is a big series targeting stable o.O where the revisions in the cover
> > letter are not helping me to be confident that this is the right approach
> > instead of simply reverting the original offending commit:
> > 
> > cf586021642d ("drm/i915/gt: Pipelined page migration")
> 
> Why should we remove all the migration completely? What about the
> copy?

Is there any other alternative that doesn't hurt the Linux stable rules?

I honestly fail to see this one here is "obviously corrected and tested"
and it looks to me that it has more "than 100 lines, with context".

Does this series really "fix only one thing" with 5 patches?

> 
> > It looks to me that we are adding magic on top of magic to workaround
> > the deadlocks, but then adding more waits inside locks... And this with
> > the hang checks vs heartbeats, is this really an issue on current upstream
> > code? or was only on DII?
> 
> There is no real magic happening here. It's just that the error
> message was not reaching the end of the operation while this
> patch is passing it over.
> 
> > Where was the bug report to start with?
> 
> Matt has reported this, I will give to you the necessary links to
> it offline.

It would be really good to have a report to see if this is
"real bug that bothers people (not a, “This could be a problem…” type thing)."

All quotes above are from:
https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

> 
> Thanks for looking into this,
> Andi
