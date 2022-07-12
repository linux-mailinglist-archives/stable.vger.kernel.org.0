Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86DAD572027
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 18:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232850AbiGLQAn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 12:00:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbiGLQAn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 12:00:43 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E579C54AD;
        Tue, 12 Jul 2022 09:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657641642; x=1689177642;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=AnwCkEUuxJLCRx7GhtMQk+FLBhJzxZJHbxYHUOLgTl8=;
  b=P27IVRQNKzmaG2d+TwGBLUdc3yLbidOE8HrVpX4Tex8v3nKDhDDZaLEC
   y9Y37xDBmVIklq0VyedAFDvj3AIH2NAMezk5ZkREzjE7y2ItwRrO6zaWV
   eBzbnsIG6tqAP//h2UplzKn8iKxNGVDO2K6B2okAClg+uM2JYBOLxrm2P
   jsk1az1TxX0LgMpQ9rSPQRjZy79yWTGjxgSFTPpdVkNk1c1THX8qeaodj
   RhZ7Q5uoNj9Zz1YIj/duwRKBKHYxCe/5IkNUzMj+1ALvEHyX+YtbBzulc
   kgiM2Vavg1k8zJNqbxMnckeyXA8PcShfOPSyvyIG8m13RG7cNkQRWeGm/
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10406"; a="265386478"
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="265386478"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2022 09:00:41 -0700
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="841430869"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2022 09:00:38 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1oBIJP-001Bb2-1l;
        Tue, 12 Jul 2022 19:00:35 +0300
Date:   Tue, 12 Jul 2022 19:00:35 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     Yury Norov <yury.norov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        kernel test robot <oliver.sang@intel.com>,
        iommu@lists.linux.dev, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iommu/vt-d: avoid invalid memory access via
 node_online(NUMA_NO_NODE)
Message-ID: <Ys2aoyVn7lc9VIUO@smile.fi.intel.com>
References: <20220712153836.41599-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220712153836.41599-1-alexandr.lobakin@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 12, 2022 at 05:38:36PM +0200, Alexander Lobakin wrote:
> KASAN reports:
> 
> [ 4.668325][ T0] BUG: KASAN: wild-memory-access in dmar_parse_one_rhsa (arch/x86/include/asm/bitops.h:214 arch/x86/include/asm/bitops.h:226 include/asm-generic/bitops/instrumented-non-atomic.h:142 include/linux/nodemask.h:415 drivers/iommu/intel/dmar.c:497)
> [    4.676149][    T0] Read of size 8 at addr 1fffffff85115558 by task swapper/0/0
> [    4.683454][    T0]
> [    4.685638][    T0] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.19.0-rc3-00004-g0e862838f290 #1
> [    4.694331][    T0] Hardware name: Supermicro SYS-5018D-FN4T/X10SDV-8C-TLN4F, BIOS 1.1 03/02/2016
> [    4.703196][    T0] Call Trace:
> [    4.706334][    T0]  <TASK>
> [ 4.709133][ T0] ? dmar_parse_one_rhsa (arch/x86/include/asm/bitops.h:214 arch/x86/include/asm/bitops.h:226 include/asm-generic/bitops/instrumented-non-atomic.h:142 include/linux/nodemask.h:415 drivers/iommu/intel/dmar.c:497)
> 
> after converting the type of the first argument (@nr, bit number)
> of arch_test_bit() from `long` to `unsigned long`[0].
> 
> Under certain conditions (for example, when ACPI NUMA is disabled
> via command line), pxm_to_node() can return %NUMA_NO_NODE (-1).
> It is valid 'magic' number of NUMA node, but not valid bit number
> to use in bitops.
> node_online() eventually descends to test_bit() without checking
> for the input, assuming it's on caller side (which might be good
> for perf-critical tasks). There, -1 becomes %ULONG_MAX which leads
> to an insane array index when calculating bit position in memory.
> 
> For now, add an explicit check for @node being not %NUMA_NO_NODE
> before calling test_bit(). The actual logics didn't change here
> at all.

Yes, and bitops performance is critical, so it's caller's responsibility to
supply correct bit number.
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

> Fixes: ee34b32d8c29 ("dmar: support for parsing Remapping Hardware Static Affinity structure")
> Cc: stable@vger.kernel.org # 2.6.33+
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> ---
>  drivers/iommu/intel/dmar.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/intel/dmar.c b/drivers/iommu/intel/dmar.c
> index 9699ca101c62..64b14ac4c7b0 100644
> --- a/drivers/iommu/intel/dmar.c
> +++ b/drivers/iommu/intel/dmar.c
> @@ -494,7 +494,7 @@ static int dmar_parse_one_rhsa(struct acpi_dmar_header *header, void *arg)
>  		if (drhd->reg_base_addr == rhsa->base_address) {
>  			int node = pxm_to_node(rhsa->proximity_domain);
>  
> -			if (!node_online(node))
> +			if (node != NUMA_NO_NODE && !node_online(node))
>  				node = NUMA_NO_NODE;
>  			drhd->iommu->node = node;
>  			return 0;
> -- 
> 2.36.1
> 

-- 
With Best Regards,
Andy Shevchenko


