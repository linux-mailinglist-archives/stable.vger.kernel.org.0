Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B542571FD2
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 17:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233280AbiGLPpn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 11:45:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231423AbiGLPpm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 11:45:42 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CB08C548D;
        Tue, 12 Jul 2022 08:45:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657640742; x=1689176742;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=g8HjPXg0vMWijjAzqReQodiFn+1+MvBU8lI9SQD+sr0=;
  b=WNov3cmqADhXP3f6ouBCwlYD7Rr+N1xsQjNHJLALicQP++qNgIEw/l0i
   ePNlPa9PMaE3fQ0EwOANlGUkFBGKaZeWuXrMolDmj98s2iLUrTSIzL6vK
   BG/rHYiD10BBsOl3KUmo/QQQlMWaa1j0y5JZwsepNG+7DSRlCRppUkUav
   nsjdsXzVQV1xBi4nSDOTmn+GJydjIemimMuMqLMCU4n+C6eBOwE4pHN4E
   JyOXk2lgDUP34NRK+ahZCfNn76xGBDMm1GrQ8ixAZk7H+M+2EfjJlxMD0
   V+p0wUPKIfJji6H/S1iN8ryj1kPyOnvSrb1Oxzix0kkKFeGl9l8He2Uq9
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10406"; a="371281382"
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="371281382"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2022 08:45:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="592674036"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga007.jf.intel.com with ESMTP; 12 Jul 2022 08:45:38 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 26CFjb8E024821;
        Tue, 12 Jul 2022 16:45:37 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Yury Norov <yury.norov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        kernel test robot <oliver.sang@intel.com>,
        iommu@lists.linux.dev, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iommu/vt-d: avoid invalid memory access via node_online(NUMA_NO_NODE)
Date:   Tue, 12 Jul 2022 17:44:07 +0200
Message-Id: <20220712154407.42196-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220712153836.41599-1-alexandr.lobakin@intel.com>
References: <20220712153836.41599-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Lobakin <alexandr.lobakin@intel.com>
Date: Tue, 12 Jul 2022 17:38:36 +0200

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

Bah, forgot to insert the link here. Hope not worth resending ._.

[0] https://github.com/norov/linux/commit/0e862838f290147ea9c16db852d8d494b552d38d

> 
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

Thanks,
Olek
