Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F04385B653C
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 03:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbiIMBvp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Sep 2022 21:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbiIMBvp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Sep 2022 21:51:45 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 060FE4F6B8;
        Mon, 12 Sep 2022 18:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663033904; x=1694569904;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2NGc7hvIE92RCbTENDH1MmBHPouANN1/L78mTjXfFAs=;
  b=Ipln9n8efswqVqwMMrHaQesMo1oQGb4OS82Xl17QJWW6U4fHmdH3TN18
   cb5KWaI3MQdy6kWwvnRyS43+R3IWBu/n2Z3JuIvQKsM/vxwF4TOI39eko
   LIJGTRValOAr0zsGnFGzQHOKx4y0pK2GFsGtPm60gpqRuzeIrNYbRTf8v
   OEGIydVJmaKXj3+MzuNHLhuf7ISqVKHLmnwjm200PDrE6GKIp9h9wOkjB
   P1OX07xzKGOyLX3UvchDcHVueJsgOb+thFI3TwxitjXBBaY8twE9/1CFc
   5iCdFjwpzLuHU3AW8O9fvzDfkVEzYPpE74Qmnuh0sA/YVyhdkC9AyEnyd
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10468"; a="298811072"
X-IronPort-AV: E=Sophos;i="5.93,311,1654585200"; 
   d="scan'208";a="298811072"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2022 18:51:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,311,1654585200"; 
   d="scan'208";a="741990614"
Received: from lkp-server02.sh.intel.com (HELO 4011df4f4fd3) ([10.239.97.151])
  by orsmga004.jf.intel.com with ESMTP; 12 Sep 2022 18:51:39 -0700
Received: from kbuild by 4011df4f4fd3 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oXv5O-00034d-1T;
        Tue, 13 Sep 2022 01:51:38 +0000
Date:   Tue, 13 Sep 2022 09:51:37 +0800
From:   kernel test robot <lkp@intel.com>
To:     Johan Hovold <johan+linaro@kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Rob Clark <robdclark@gmail.com>
Cc:     kbuild-all@lists.01.org, dri-devel@lists.freedesktop.org,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Jonas Karlman <jonas@kwiboo.se>,
        David Airlie <airlied@linux.ie>, linux-arm-msm@vger.kernel.org,
        Bjorn Andersson <andersson@kernel.org>,
        linux-kernel@vger.kernel.org,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Robert Foss <robert.foss@linaro.org>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        stable@vger.kernel.org, freedreno@lists.freedesktop.org,
        Sean Paul <sean@poorly.run>,
        Johan Hovold <johan+linaro@kernel.org>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 4/7] drm/msm/dp: fix aux-bus EP lifetime
Message-ID: <202209130930.yrI8pQGL-lkp@intel.com>
References: <20220912154046.12900-5-johan+linaro@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220912154046.12900-5-johan+linaro@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Johan,

I love your patch! Yet something to improve:

[auto build test ERROR on next-20220912]
[also build test ERROR on v6.0-rc5]
[cannot apply to drm-misc/drm-misc-next drm/drm-next drm-intel/for-linux-next drm-tip/drm-tip linus/master v6.0-rc5 v6.0-rc4 v6.0-rc3]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Johan-Hovold/drm-msm-probe-deferral-fixes/20220912-234351
base:    044b771be9c5de9d817dfafb829d2f049c71c3b4
config: arc-allyesconfig (https://download.01.org/0day-ci/archive/20220913/202209130930.yrI8pQGL-lkp@intel.com/config)
compiler: arceb-elf-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/458c96e19570036b3dd6e48d91f0bf6f67b996fa
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Johan-Hovold/drm-msm-probe-deferral-fixes/20220912-234351
        git checkout 458c96e19570036b3dd6e48d91f0bf6f67b996fa
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=arc SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   drivers/gpu/drm/bridge/ti-sn65dsi86.c: In function 'ti_sn_aux_probe':
>> drivers/gpu/drm/bridge/ti-sn65dsi86.c:632:50: error: passing argument 1 of 'devm_of_dp_aux_populate_ep_devices' from incompatible pointer type [-Werror=incompatible-pointer-types]
     632 |         ret = devm_of_dp_aux_populate_ep_devices(&pdata->aux);
         |                                                  ^~~~~~~~~~~
         |                                                  |
         |                                                  struct drm_dp_aux *
   In file included from drivers/gpu/drm/bridge/ti-sn65dsi86.c:26:
   include/drm/display/drm_dp_aux_bus.h:64:69: note: expected 'struct device *' but argument is of type 'struct drm_dp_aux *'
      64 | static inline int devm_of_dp_aux_populate_ep_devices(struct device *dev, struct drm_dp_aux *aux)
         |                                                      ~~~~~~~~~~~~~~~^~~
>> drivers/gpu/drm/bridge/ti-sn65dsi86.c:632:15: error: too few arguments to function 'devm_of_dp_aux_populate_ep_devices'
     632 |         ret = devm_of_dp_aux_populate_ep_devices(&pdata->aux);
         |               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/drm/display/drm_dp_aux_bus.h:64:19: note: declared here
      64 | static inline int devm_of_dp_aux_populate_ep_devices(struct device *dev, struct drm_dp_aux *aux)
         |                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors
--
   drivers/gpu/drm/bridge/analogix/anx7625.c: In function 'anx7625_i2c_probe':
>> drivers/gpu/drm/bridge/analogix/anx7625.c:2654:44: error: passing argument 1 of 'devm_of_dp_aux_populate_ep_devices' from incompatible pointer type [-Werror=incompatible-pointer-types]
    2654 |         devm_of_dp_aux_populate_ep_devices(&platform->aux);
         |                                            ^~~~~~~~~~~~~~
         |                                            |
         |                                            struct drm_dp_aux *
   In file included from drivers/gpu/drm/bridge/analogix/anx7625.c:24:
   include/drm/display/drm_dp_aux_bus.h:64:69: note: expected 'struct device *' but argument is of type 'struct drm_dp_aux *'
      64 | static inline int devm_of_dp_aux_populate_ep_devices(struct device *dev, struct drm_dp_aux *aux)
         |                                                      ~~~~~~~~~~~~~~~^~~
>> drivers/gpu/drm/bridge/analogix/anx7625.c:2654:9: error: too few arguments to function 'devm_of_dp_aux_populate_ep_devices'
    2654 |         devm_of_dp_aux_populate_ep_devices(&platform->aux);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/drm/display/drm_dp_aux_bus.h:64:19: note: declared here
      64 | static inline int devm_of_dp_aux_populate_ep_devices(struct device *dev, struct drm_dp_aux *aux)
         |                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors


vim +/devm_of_dp_aux_populate_ep_devices +632 drivers/gpu/drm/bridge/ti-sn65dsi86.c

77674e722f4b27 Laurent Pinchart 2021-06-24  620  
77674e722f4b27 Laurent Pinchart 2021-06-24  621  static int ti_sn_aux_probe(struct auxiliary_device *adev,
77674e722f4b27 Laurent Pinchart 2021-06-24  622  			   const struct auxiliary_device_id *id)
77674e722f4b27 Laurent Pinchart 2021-06-24  623  {
77674e722f4b27 Laurent Pinchart 2021-06-24  624  	struct ti_sn65dsi86 *pdata = dev_get_drvdata(adev->dev.parent);
77674e722f4b27 Laurent Pinchart 2021-06-24  625  	int ret;
77674e722f4b27 Laurent Pinchart 2021-06-24  626  
77674e722f4b27 Laurent Pinchart 2021-06-24  627  	pdata->aux.name = "ti-sn65dsi86-aux";
77674e722f4b27 Laurent Pinchart 2021-06-24  628  	pdata->aux.dev = &adev->dev;
77674e722f4b27 Laurent Pinchart 2021-06-24  629  	pdata->aux.transfer = ti_sn_aux_transfer;
77674e722f4b27 Laurent Pinchart 2021-06-24  630  	drm_dp_aux_init(&pdata->aux);
77674e722f4b27 Laurent Pinchart 2021-06-24  631  
77674e722f4b27 Laurent Pinchart 2021-06-24 @632  	ret = devm_of_dp_aux_populate_ep_devices(&pdata->aux);
77674e722f4b27 Laurent Pinchart 2021-06-24  633  	if (ret)
77674e722f4b27 Laurent Pinchart 2021-06-24  634  		return ret;
77674e722f4b27 Laurent Pinchart 2021-06-24  635  
77674e722f4b27 Laurent Pinchart 2021-06-24  636  	/*
77674e722f4b27 Laurent Pinchart 2021-06-24  637  	 * The eDP to MIPI bridge parts don't work until the AUX channel is
77674e722f4b27 Laurent Pinchart 2021-06-24  638  	 * setup so we don't add it in the main driver probe, we add it now.
77674e722f4b27 Laurent Pinchart 2021-06-24  639  	 */
77674e722f4b27 Laurent Pinchart 2021-06-24  640  	return ti_sn65dsi86_add_aux_device(pdata, &pdata->bridge_aux, "bridge");
77674e722f4b27 Laurent Pinchart 2021-06-24  641  }
77674e722f4b27 Laurent Pinchart 2021-06-24  642  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
