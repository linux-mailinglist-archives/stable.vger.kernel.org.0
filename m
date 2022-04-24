Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 297E350D505
	for <lists+stable@lfdr.de>; Sun, 24 Apr 2022 22:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237427AbiDXUSX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Apr 2022 16:18:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbiDXUSW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Apr 2022 16:18:22 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DA671B7BB;
        Sun, 24 Apr 2022 13:15:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650831320; x=1682367320;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8t6fpLenBHAH+wdi7yNt1q9I4nBEIopCZfP0qWGHTqQ=;
  b=HysqCqagGTCyHWVf13a1GDUrx4Ty9FP5IcV1WB4mN4ZkRBwDidUz/GQu
   z4okSL5sBomZH053lBkCNJ5x48lOqBsshg9uUjusalLwF9ytwPF0krdn3
   MfM2nDg8BSIP4id+gkqsDGbmBY+QZdjiZ1krY4dmRAA8xEX46UwEUPpbh
   n9bd9wUKMS1PWUMsPnNvJf8tzbfHTKQZnasXwR/QF74q64HzRF9Qayero
   WVzJ81M+8fvOCWPH0JiWm3LZznbwTLKr2ocTDK+sH1mD7/kInRzjnHejp
   wpg2vOkIcdDemhfGEuRjg9oPMmuhtc1kv3fSrbma+XPCZ3/lmjFP6/8BQ
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10327"; a="245009582"
X-IronPort-AV: E=Sophos;i="5.90,287,1643702400"; 
   d="scan'208";a="245009582"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2022 13:15:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,287,1643702400"; 
   d="scan'208";a="659856336"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 24 Apr 2022 13:15:16 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1niidX-0001kZ-Nr;
        Sun, 24 Apr 2022 20:15:15 +0000
Date:   Mon, 25 Apr 2022 04:14:47 +0800
From:   kernel test robot <lkp@intel.com>
To:     Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guillaume Tucker <gtucker@collabora.com>,
        Mark Brown <broonie@kernel.org>,
        Mark-PK Tsai <mark-pk.tsai@mediatek.com>,
        Mike Rapoport <rppt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Will Deacon <will@kernel.org>, bot@kernelci.org,
        kernelci-results@groups.io, linux-arm-kernel@lists.infradead.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] arm[64]/memremap: don't abuse pfn_valid() to ensure
 presence of linear map
Message-ID: <202204250425.OjOiS0ZK-lkp@intel.com>
References: <20220424172044.22220-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220424172044.22220-1-rppt@kernel.org>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Mike,

I love your patch! Yet something to improve:

[auto build test ERROR on b2d229d4ddb17db541098b83524d901257e93845]

url:    https://github.com/intel-lab-lkp/linux/commits/Mike-Rapoport/arm-64-memremap-don-t-abuse-pfn_valid-to-ensure-presence-of-linear-map/20220425-012242
base:   b2d229d4ddb17db541098b83524d901257e93845
config: arm-randconfig-c002-20220424 (https://download.01.org/0day-ci/archive/20220425/202204250425.OjOiS0ZK-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/635763878be30ab45f350cdcffba3d8e71089942
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Mike-Rapoport/arm-64-memremap-don-t-abuse-pfn_valid-to-ensure-presence-of-linear-map/20220425-012242
        git checkout 635763878be30ab45f350cdcffba3d8e71089942
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross W=1 O=build_dir ARCH=arm SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   arm-linux-gnueabi-ld: kernel/iomem.o: in function `try_ram_remap':
>> kernel/iomem.c:37: undefined reference to `arch_memremap_can_ram_remap'
   arm-linux-gnueabi-ld: drivers/gpu/drm/bridge/ite-it6505.o: in function `it6505_i2c_remove':
   drivers/gpu/drm/bridge/ite-it6505.c:3317: undefined reference to `drm_dp_aux_unregister'
   arm-linux-gnueabi-ld: drivers/gpu/drm/bridge/ite-it6505.o: in function `it6505_get_dpcd':
   drivers/gpu/drm/bridge/ite-it6505.c:602: undefined reference to `drm_dp_dpcd_read'
   arm-linux-gnueabi-ld: drivers/gpu/drm/bridge/ite-it6505.o: in function `it6505_bridge_attach':
   drivers/gpu/drm/bridge/ite-it6505.c:2858: undefined reference to `drm_dp_aux_register'
   arm-linux-gnueabi-ld: drivers/gpu/drm/bridge/ite-it6505.o: in function `drm_dp_dpcd_writeb':
   include/drm/dp/drm_dp_helper.h:2088: undefined reference to `drm_dp_dpcd_write'
   arm-linux-gnueabi-ld: drivers/gpu/drm/bridge/ite-it6505.o: in function `drm_dp_dpcd_readb':
   include/drm/dp/drm_dp_helper.h:2073: undefined reference to `drm_dp_dpcd_read'
   arm-linux-gnueabi-ld: drivers/gpu/drm/bridge/ite-it6505.o: in function `it6505_hdcp_work':
   drivers/gpu/drm/bridge/ite-it6505.c:2084: undefined reference to `drm_dp_dpcd_read_link_status'
   arm-linux-gnueabi-ld: drivers/gpu/drm/bridge/ite-it6505.c:2088: undefined reference to `drm_dp_channel_eq_ok'
   arm-linux-gnueabi-ld: drivers/gpu/drm/bridge/ite-it6505.o: in function `it6505_step_cr_train':
   drivers/gpu/drm/bridge/ite-it6505.c:1688: undefined reference to `drm_dp_link_train_clock_recovery_delay'
   arm-linux-gnueabi-ld: drivers/gpu/drm/bridge/ite-it6505.c:1689: undefined reference to `drm_dp_dpcd_read_link_status'
   arm-linux-gnueabi-ld: drivers/gpu/drm/bridge/ite-it6505.c:1691: undefined reference to `drm_dp_clock_recovery_ok'
   arm-linux-gnueabi-ld: drivers/gpu/drm/bridge/ite-it6505.c:1704: undefined reference to `drm_dp_get_adjust_request_voltage'
   arm-linux-gnueabi-ld: drivers/gpu/drm/bridge/ite-it6505.c:1708: undefined reference to `drm_dp_get_adjust_request_pre_emphasis'
   arm-linux-gnueabi-ld: drivers/gpu/drm/bridge/ite-it6505.o: in function `it6505_step_eq_train':
   drivers/gpu/drm/bridge/ite-it6505.c:1760: undefined reference to `drm_dp_link_train_channel_eq_delay'
   arm-linux-gnueabi-ld: drivers/gpu/drm/bridge/ite-it6505.c:1761: undefined reference to `drm_dp_dpcd_read_link_status'
   arm-linux-gnueabi-ld: drivers/gpu/drm/bridge/ite-it6505.c:1763: undefined reference to `drm_dp_clock_recovery_ok'
   arm-linux-gnueabi-ld: drivers/gpu/drm/bridge/ite-it6505.c:1766: undefined reference to `drm_dp_channel_eq_ok'
   arm-linux-gnueabi-ld: drivers/gpu/drm/bridge/ite-it6505.c:1777: undefined reference to `drm_dp_get_adjust_request_voltage'
   arm-linux-gnueabi-ld: drivers/gpu/drm/bridge/ite-it6505.c:1781: undefined reference to `drm_dp_get_adjust_request_pre_emphasis'
   arm-linux-gnueabi-ld: drivers/gpu/drm/bridge/ite-it6505.o: in function `it6505_drm_dp_link_configure':
   drivers/gpu/drm/bridge/ite-it6505.c:1603: undefined reference to `drm_dp_dpcd_write'
   arm-linux-gnueabi-ld: drivers/gpu/drm/bridge/ite-it6505.o: in function `it6505_parse_link_capabilities':
   drivers/gpu/drm/bridge/ite-it6505.c:1457: undefined reference to `drm_dp_link_rate_to_bw_code'
   arm-linux-gnueabi-ld: drivers/gpu/drm/bridge/ite-it6505.o: in function `it6505_drm_dp_link_probe':
   drivers/gpu/drm/bridge/ite-it6505.c:726: undefined reference to `drm_dp_dpcd_read'
   arm-linux-gnueabi-ld: drivers/gpu/drm/bridge/ite-it6505.c:731: undefined reference to `drm_dp_bw_code_to_link_rate'
   arm-linux-gnueabi-ld: drivers/gpu/drm/bridge/ite-it6505.o: in function `drm_dp_dpcd_readb':
   include/drm/dp/drm_dp_helper.h:2073: undefined reference to `drm_dp_dpcd_read'
   arm-linux-gnueabi-ld: drivers/gpu/drm/bridge/ite-it6505.o: in function `drm_dp_dpcd_writeb':
   include/drm/dp/drm_dp_helper.h:2088: undefined reference to `drm_dp_dpcd_write'
   arm-linux-gnueabi-ld: drivers/gpu/drm/bridge/ite-it6505.o: in function `it6505_process_hpd_irq':
   drivers/gpu/drm/bridge/ite-it6505.c:2293: undefined reference to `drm_dp_dpcd_read_link_status'
   arm-linux-gnueabi-ld: drivers/gpu/drm/bridge/ite-it6505.c:2302: undefined reference to `drm_dp_channel_eq_ok'


vim +37 kernel/iomem.c

5981690ddb8f72 Dan Williams  2018-03-29  29  
5981690ddb8f72 Dan Williams  2018-03-29  30  static void *try_ram_remap(resource_size_t offset, size_t size,
5981690ddb8f72 Dan Williams  2018-03-29  31  			   unsigned long flags)
5981690ddb8f72 Dan Williams  2018-03-29  32  {
5981690ddb8f72 Dan Williams  2018-03-29  33  	unsigned long pfn = PHYS_PFN(offset);
5981690ddb8f72 Dan Williams  2018-03-29  34  
5981690ddb8f72 Dan Williams  2018-03-29  35  	/* In the simple case just return the existing linear address */
635763878be30a Mike Rapoport 2022-04-24  36  	if (!PageHighMem(pfn_to_page(pfn)) &&
5981690ddb8f72 Dan Williams  2018-03-29 @37  	    arch_memremap_can_ram_remap(offset, size, flags))
5981690ddb8f72 Dan Williams  2018-03-29  38  		return __va(offset);
5981690ddb8f72 Dan Williams  2018-03-29  39  
5981690ddb8f72 Dan Williams  2018-03-29  40  	return NULL; /* fallback to arch_memremap_wb */
5981690ddb8f72 Dan Williams  2018-03-29  41  }
5981690ddb8f72 Dan Williams  2018-03-29  42  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
