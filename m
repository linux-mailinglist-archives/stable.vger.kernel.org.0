Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 762B3567606
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 19:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232935AbiGERyy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 13:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232649AbiGERyy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 13:54:54 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1690913E9B;
        Tue,  5 Jul 2022 10:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657043693; x=1688579693;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Km880PB9XZc0BJUMeh8tRcEuJbGickfi/0b4M5YX+Ik=;
  b=Dbk6BVmeVH+oQSjaCEaG23oR6hE3X+YRYvntD1+zKwwFMKnYK7KJ0Ip6
   x6to0msA+GuH5Ad48/PVEUPZKf4FUDGVmnPrETCWrADcHAOkV+RlDsE+O
   qxHgxhm4KETVTG7kg2wKkpVlv+ANhdY1+GJ2bO9tob8mhglAzCtcJ4cW1
   a53l6T58RsRpla3iLrM3Z0EDT2dUcJHRVRh7ij2Ru4PIW7Gn7bNwa7cpg
   cqaHsgw3J8GQJd+7qcYjOJr6/qJPWkiZVsGEG6GGHrZu9lJY5E5upHcE1
   3P7KxBs0glCU6H0AHAw5zPwSHfk5yruBpCimIypSDWzCPteuCBbNEQ5hK
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10399"; a="272208264"
X-IronPort-AV: E=Sophos;i="5.92,247,1650956400"; 
   d="scan'208";a="272208264"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2022 10:47:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,247,1650956400"; 
   d="scan'208";a="919813843"
Received: from lkp-server01.sh.intel.com (HELO 68b931ab7ac1) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 05 Jul 2022 10:47:49 -0700
Received: from kbuild by 68b931ab7ac1 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o8meK-000JRZ-Uh;
        Tue, 05 Jul 2022 17:47:48 +0000
Date:   Wed, 6 Jul 2022 01:47:27 +0800
From:   kernel test robot <lkp@intel.com>
To:     Nishanth Menon <nm@ti.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Nuno =?iso-8859-1?Q?S=E1?= <nuno.sa@analog.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Alexandru Ardelean <ardeleanalex@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <jic23@kernel.org>
Cc:     kbuild-all@lists.01.org, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] iio: adc: ti-adc128s052: Fix number of channels when
 device tree is used
Message-ID: <202207060155.zkacpxjc-lkp@intel.com>
References: <20220630230107.13438-1-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630230107.13438-1-nm@ti.com>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Nishanth,

I love your patch! Perhaps something to improve:

[auto build test WARNING on jic23-iio/togreg]
[also build test WARNING on linus/master v5.19-rc5 next-20220705]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Nishanth-Menon/iio-adc-ti-adc128s052-Fix-number-of-channels-when-device-tree-is-used/20220701-070342
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio.git togreg
config: nios2-randconfig-r036-20220703 (https://download.01.org/0day-ci/archive/20220706/202207060155.zkacpxjc-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/d5184722ec9ae186da9bed1497e4804297f2040b
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Nishanth-Menon/iio-adc-ti-adc128s052-Fix-number-of-channels-when-device-tree-is-used/20220701-070342
        git checkout d5184722ec9ae186da9bed1497e4804297f2040b
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=nios2 SHELL=/bin/bash drivers/iio/adc/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/iio/adc/ti-adc128s052.c:185:50: warning: initialization of 'const void *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
     185 |         { .compatible = "ti,adc122s021", .data = 1},
         |                                                  ^
   drivers/iio/adc/ti-adc128s052.c:185:50: note: (near initialization for 'adc128_of_match[1].data')
   drivers/iio/adc/ti-adc128s052.c:186:50: warning: initialization of 'const void *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
     186 |         { .compatible = "ti,adc122s051", .data = 1},
         |                                                  ^
   drivers/iio/adc/ti-adc128s052.c:186:50: note: (near initialization for 'adc128_of_match[2].data')
   drivers/iio/adc/ti-adc128s052.c:187:50: warning: initialization of 'const void *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
     187 |         { .compatible = "ti,adc122s101", .data = 1},
         |                                                  ^
   drivers/iio/adc/ti-adc128s052.c:187:50: note: (near initialization for 'adc128_of_match[3].data')
   drivers/iio/adc/ti-adc128s052.c:188:50: warning: initialization of 'const void *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
     188 |         { .compatible = "ti,adc124s021", .data = 2},
         |                                                  ^
   drivers/iio/adc/ti-adc128s052.c:188:50: note: (near initialization for 'adc128_of_match[4].data')
   drivers/iio/adc/ti-adc128s052.c:189:50: warning: initialization of 'const void *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
     189 |         { .compatible = "ti,adc124s051", .data = 2},
         |                                                  ^
   drivers/iio/adc/ti-adc128s052.c:189:50: note: (near initialization for 'adc128_of_match[5].data')
   drivers/iio/adc/ti-adc128s052.c:190:50: warning: initialization of 'const void *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
     190 |         { .compatible = "ti,adc124s101", .data = 2},
         |                                                  ^
   drivers/iio/adc/ti-adc128s052.c:190:50: note: (near initialization for 'adc128_of_match[6].data')


vim +185 drivers/iio/adc/ti-adc128s052.c

   182	
   183	static const struct of_device_id adc128_of_match[] = {
   184		{ .compatible = "ti,adc128s052", .data = 0},
 > 185		{ .compatible = "ti,adc122s021", .data = 1},
   186		{ .compatible = "ti,adc122s051", .data = 1},
   187		{ .compatible = "ti,adc122s101", .data = 1},
   188		{ .compatible = "ti,adc124s021", .data = 2},
   189		{ .compatible = "ti,adc124s051", .data = 2},
   190		{ .compatible = "ti,adc124s101", .data = 2},
   191		{ /* sentinel */ },
   192	};
   193	MODULE_DEVICE_TABLE(of, adc128_of_match);
   194	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
