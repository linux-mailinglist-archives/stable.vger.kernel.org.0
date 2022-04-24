Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2322B50D509
	for <lists+stable@lfdr.de>; Sun, 24 Apr 2022 22:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbiDXUS0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Apr 2022 16:18:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239539AbiDXUSX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Apr 2022 16:18:23 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9417D6327;
        Sun, 24 Apr 2022 13:15:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650831320; x=1682367320;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=tr1uVkg19DmCx5czIAnRVO4Mi4x8AE/hXA4O7abWsDc=;
  b=GFkJ4GVZjE8fND6BWituOIScVqh41XDlhvl9YXWEACVN6+ejH3ao0cHC
   1ud3eYLmVR5kgp12Rd2kcmXRM5LIyR5J0cIG4xkG/BbMN/Qc6Kf5vTKG1
   rZzA5pyiYu1F8pDdOoxSdDOlJVVXhaAJ0rPJU1+BBU5bZgJUAVyNQJ+1e
   A8VP3sovPpeH06QSnzFb0dCQzuoiW36VnW4etK3IKV+yRXd/zTha1TdPF
   TLGg9Ap7d7YUBoBFdW/uv7ECNdbbHQIXUSKcylUxMlA6CpgO0DrEmb6AX
   fGIXGanSgaSobdzg6Qtlc26YE7jRoA24jrs/IsRMg952zGZEyv0seN8kO
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10327"; a="328013291"
X-IronPort-AV: E=Sophos;i="5.90,287,1643702400"; 
   d="scan'208";a="328013291"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2022 13:15:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,287,1643702400"; 
   d="scan'208";a="649401862"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 24 Apr 2022 13:15:16 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1niidX-0001kb-PS;
        Sun, 24 Apr 2022 20:15:15 +0000
Date:   Mon, 25 Apr 2022 04:14:46 +0800
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
Message-ID: <202204250429.nq0alVBK-lkp@intel.com>
References: <20220424172044.22220-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220424172044.22220-1-rppt@kernel.org>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
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
config: arm-randconfig-r015-20220424 (https://download.01.org/0day-ci/archive/20220425/202204250429.nq0alVBK-lkp@intel.com/config)
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

   arm-linux-gnueabi-ld: kernel/iomem.o: in function `memremap':
>> iomem.c:(.text+0x36): undefined reference to `arch_memremap_can_ram_remap'
   arm-linux-gnueabi-ld: drivers/gpu/drm/drm_gem_shmem_helper.o: in function `drm_gem_shmem_fault':
   drm_gem_shmem_helper.c:(.text+0x54): undefined reference to `vmf_insert_pfn'

Kconfig warnings: (for reference only)
   WARNING: unmet direct dependencies detected for DRM_GEM_SHMEM_HELPER
   Depends on HAS_IOMEM && DRM && MMU
   Selected by
   - DRM_SSD130X && HAS_IOMEM && DRM

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
