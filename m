Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F14661A3C1
	for <lists+stable@lfdr.de>; Fri,  4 Nov 2022 22:58:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbiKDV6T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Nov 2022 17:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiKDV6S (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Nov 2022 17:58:18 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EF8B5985A;
        Fri,  4 Nov 2022 14:58:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667599096; x=1699135096;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=iwT/QbJ3nmVvdP56PZB0c+wNQB/OB7JEn8T3Ax2+aCQ=;
  b=iyG7D+rXRHf08ITEOfDctOd1tZGodz6/zh3mH837i+TvSh06jXV+fvmk
   BkV8eWP/i6nOfyqHX0nvRnSOXuy5D4I6KE0iJprGmbivpB2GYKQR10c5/
   1ZWdmoHvWT22095fXbSaP1HKuMQrFdKe8BmtCwpRzj0aHs9oZNTCAJxrB
   jTmweHZU/z6RgzazDLwDYhiHRiDdTZsc7+428rkD7fjAMSSzjl7VwnU2R
   +2b9gQncHHZKk4oVROWZWMA/Zs3/SCpRJF9WX8CvyemK4XevOdVKs9aeX
   D0yHQfEAUjVMdZ9TjtgyPXWXPLO/O8BltKFidlgw0NcYMUlnHJ1iKUW/7
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10521"; a="311203879"
X-IronPort-AV: E=Sophos;i="5.96,138,1665471600"; 
   d="scan'208";a="311203879"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2022 14:58:15 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10521"; a="698804053"
X-IronPort-AV: E=Sophos;i="5.96,138,1665471600"; 
   d="scan'208";a="698804053"
Received: from djiang5-mobl2.amr.corp.intel.com (HELO [10.212.112.74]) ([10.212.112.74])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2022 14:58:15 -0700
Message-ID: <31b4e74e-3a6e-d2cf-48f8-7df2cafbebb4@intel.com>
Date:   Fri, 4 Nov 2022 14:58:14 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.4.1
Subject: Re: [PATCH 6/7] cxl/region: Fix 'distance' calculation with
 passthrough ports
Content-Language: en-US
To:     Dan Williams <dan.j.williams@intel.com>,
        "Verma, Vishal L" <vishal.l.verma@intel.com>,
        "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
Cc:     "Schofield, Alison" <alison.schofield@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "lmw.bobo@gmail.com" <lmw.bobo@gmail.com>,
        "Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>,
        "Weiny, Ira" <ira.weiny@intel.com>
References: <166752181697.947915.744835334283138352.stgit@dwillia2-xfh.jf.intel.com>
 <166752185440.947915.6617495912508299445.stgit@dwillia2-xfh.jf.intel.com>
 <fa869572ab3190e0dacba8f5f133f750e9b30676.camel@intel.com>
 <63656110eb4eb_f52ac2941e@dwillia2-xfh.jf.intel.com.notmuch>
From:   Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <63656110eb4eb_f52ac2941e@dwillia2-xfh.jf.intel.com.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 11/4/2022 11:59 AM, Dan Williams wrote:
> Verma, Vishal L wrote:
>> On Thu, 2022-11-03 at 17:30 -0700, Dan Williams wrote:
>>> When programming port decode targets, the algorithm wants to ensure that
>>> two devices are compatible to be programmed as peers beneath a given
>>> port. A compatible peer is a target that shares the same dport, and
>>> where that target's interleave position also routes it to the same
>>> dport. Compatibility is determined by the device's interleave position
>>> being >= to distance. For example, if a given dport can only map every
>>> Nth position then positions less than N away from the last target
>>> programmed are incompatible.
>>>
>>> The @distance for the host-bridge-cxl_port a simple dual-ported
>>                                     ^
>> Is this meant to be "the distance for the host-bridge to a cxl_port"?
> 
> No, but I will preface this explanation by admitting "distance" may not
> be the best term for what this value is describing. CXL decode routes to
> targets in a round robin fashion per-port. Take the diagram below:
> 
>   ┌───────────────────────────────────┬──┐
>   │WINDOW0                            │x2│
>   └─────────┬─────────────────┬───────┴──┘
>             │                 │
>   ┌─────────▼────┬──┐  ┌──────▼───────┬──┐
>   │HB0           │x2│  │HB1           │x2│
>   └──┬────────┬──┴──┘  └─┬─────────┬──┴──┘
>      │        │          │         │
>   ┌──▼─┬──┐ ┌─▼──┬──┐  ┌─▼──┬──┐ ┌─▼──┬──┐
>   │DEV0│x4│ │DEV1│x4│  │DEV2│x4│ │DEV3│x4│
>   └────┴──┘ └────┴──┘  └────┴──┘ └────┴──┘
>      0         2          1         3
> 
> ...where an x4 region is being established, and all the xN values are
> the interleave-ways settings for those ports/devices. The @distance
> value for that "HB0" port is 2. I.e. in order for 2 devices in that
> region to be mapped under HB0 they must be at position X and X+2 in the
> region.  The algorithm needs to be flexible to also allow this
> configuration:
> 
>   ┌───────────────────────────────────┬──┐
>   │WINDOW0                            │x2│
>   └─────────┬─────────────────┬───────┴──┘
>             │                 │
>   ┌─────────▼────┬──┐  ┌──────▼───────┬──┐
>   │HB0           │x2│  │HB1           │x2│
>   └──┬────────┬──┴──┘  └─┬─────────┬──┴──┘
>      │        │          │         │
>   ┌──▼─┬──┐ ┌─▼──┬──┐  ┌─▼──┬──┐ ┌─▼──┬──┐
>   │DEV3│x4│ │DEV2│x4│  │DEV1│x4│ │DEV0│x4│
>   └────┴──┘ └────┴──┘  └────┴──┘ └────┴──┘
>      3         1          2         0
> 
> ...and the algorithm can not know that a device is in the wrong position
> until trying to map the peer (like DEV0 and DEV1 are peers) into the
> decode. So "The @distance for the host-bridge-cxl_port" is referring to
> the value "2" for host-bridge-cxl_port:HB0 and host-bridge-cxl_port:HB1
> in the diagram.
> 
>> Also missing '/in/ a simple dual-ported..'?
> 
> Yes to this fixup though.
> 
>>
>>> host-bridge configuration with 2 direct-attached devices is 1. An x2
>>> region divded by 2 dports to reach 2 region targets.
>>
>> The second sentence seems slightly incomprehensible too.
> 
> Oh, I think I meant that to be s/. An/, i.e. an/:
> 
> "...host-bridge configuration with 2 direct-attached devices is 1, i.e.
> an x2 region divded by 2 dports to reach 2 region positions"

s/divded/divided/ ?

> 
> 
>>>
>>> An x4 region under an x2 host-bridge would need 2 intervening switches
>>> where the @distance at the host bridge level is 2 (x4 region divided by
>>> 2 switches to reach 4 devices).
>>>
>>> However, the distance between peers underneath a single ported
>>> host-bridge is always zero because there is no limit to the number of
>>> devices that can be mapped. In other words, there are no decoders to
>>> program in a passthrough, all descendants are mapped and distance only
>>> starts matters for the intervening descendant ports of the passthrough
>>
>> starts to matter?
> 
> s/starts matters/matters/
> 
>>
>>> port.
>>>
>>> Add tracking for the number of dports mapped to a port, and use that to
>>> detect the passthrough case for calculating @distance.
>>>
>>> Cc: <stable@vger.kernel.org>
>>> Reported-by: Bobo WL <lmw.bobo@gmail.com>
>>> Reported-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
>>> Link: http://lore.kernel.org/r/20221010172057.00001559@huawei.com
>>> Fixes: 27b3f8d13830 ("cxl/region: Program target lists")
>>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>>> ---
>>>   drivers/cxl/core/port.c   |   11 +++++++++--
>>>   drivers/cxl/core/region.c |    9 ++++++++-
>>>   drivers/cxl/cxl.h         |    2 ++
>>>   3 files changed, 19 insertions(+), 3 deletions(-)
>>
>> Other than the above, looks good,
>>
>> Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
>>
>>>
>>> diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
>>> index bffde862de0b..e7556864ea80 100644
>>> --- a/drivers/cxl/core/port.c
>>> +++ b/drivers/cxl/core/port.c
>>> @@ -811,6 +811,7 @@ static struct cxl_dport *find_dport(struct cxl_port *port, int id)
>>>   static int add_dport(struct cxl_port *port, struct cxl_dport *new)
>>>   {
>>>          struct cxl_dport *dup;
>>> +       int rc;
>>>   
>>>          device_lock_assert(&port->dev);
>>>          dup = find_dport(port, new->port_id);
>>> @@ -821,8 +822,14 @@ static int add_dport(struct cxl_port *port, struct cxl_dport *new)
>>>                          dev_name(dup->dport));
>>>                  return -EBUSY;
>>>          }
>>> -       return xa_insert(&port->dports, (unsigned long)new->dport, new,
>>> -                        GFP_KERNEL);
>>> +
>>> +       rc = xa_insert(&port->dports, (unsigned long)new->dport, new,
>>> +                      GFP_KERNEL);
>>> +       if (rc)
>>> +               return rc;
>>> +
>>> +       port->nr_dports++;
>>> +       return 0;
>>>   }
>>>   
>>>   /*
>>> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
>>> index c52465e09f26..c0253de74945 100644
>>> --- a/drivers/cxl/core/region.c
>>> +++ b/drivers/cxl/core/region.c
>>> @@ -990,7 +990,14 @@ static int cxl_port_setup_targets(struct cxl_port *port,
>>>          if (cxl_rr->nr_targets_set) {
>>>                  int i, distance;
>>>   
>>> -               distance = p->nr_targets / cxl_rr->nr_targets;
>>> +               /*
>>> +                * Passthrough ports impose no distance requirements between
>>> +                * peers
>>> +                */
>>> +               if (port->nr_dports == 1)
>>> +                       distance = 0;
>>> +               else
>>> +                       distance = p->nr_targets / cxl_rr->nr_targets;
>>>                  for (i = 0; i < cxl_rr->nr_targets_set; i++)
>>>                          if (ep->dport == cxlsd->target[i]) {
>>>                                  rc = check_last_peer(cxled, ep, cxl_rr,
>>> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
>>> index 1164ad49f3d3..ac75554b5d76 100644
>>> --- a/drivers/cxl/cxl.h
>>> +++ b/drivers/cxl/cxl.h
>>> @@ -457,6 +457,7 @@ struct cxl_pmem_region {
>>>    * @regions: cxl_region_ref instances, regions mapped by this port
>>>    * @parent_dport: dport that points to this port in the parent
>>>    * @decoder_ida: allocator for decoder ids
>>> + * @nr_dports: number of entries in @dports
>>>    * @hdm_end: track last allocated HDM decoder instance for allocation ordering
>>>    * @commit_end: cursor to track highest committed decoder for commit ordering
>>>    * @component_reg_phys: component register capability base address (optional)
>>> @@ -475,6 +476,7 @@ struct cxl_port {
>>>          struct xarray regions;
>>>          struct cxl_dport *parent_dport;
>>>          struct ida decoder_ida;
>>> +       int nr_dports;
>>>          int hdm_end;
>>>          int commit_end;
>>>          resource_size_t component_reg_phys;
>>>
>>
> 
> 
> 
