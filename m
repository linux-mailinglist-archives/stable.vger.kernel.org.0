Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01336516D21
	for <lists+stable@lfdr.de>; Mon,  2 May 2022 11:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384015AbiEBJSB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 May 2022 05:18:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234028AbiEBJSB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 May 2022 05:18:01 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB0B369F3;
        Mon,  2 May 2022 02:14:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651482873; x=1683018873;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mrdpF69sgCUgjY0iIsOoVsoDaXbqkIBauMYAKitutdM=;
  b=JNJYTZG8707V5b7Jy7pWVWbh+VGMqUgPve7/Su6NUyU00zEZxvlRxjH8
   jbd12ck9w0WDdGtLkePR1M1Ly/Kkrwdhvq/IQgXzFcpTXnqmjHKvVjc5/
   WNelm2BWICOXw1jsbUk2Z+xWfiha1bOruXmjv8oAbC4JBzNRY2Jw10whV
   LJnLSX2DukS0ADPEmg8R1n4vx1qQOxNEmd69ewvPzlKHNhdEnZAyw6c3k
   Yfm9oZz6OlX+EzJ2QGiXiAKIYkGh6l9m5qGkWvmU27c7TY6PH/HTyUYU+
   KkpUHgJOOJlJWTJ9cQcQrZLX+/cFqvfu2On+I0eTupldqJ2J3r9kIKcNl
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10334"; a="247714633"
X-IronPort-AV: E=Sophos;i="5.91,190,1647327600"; 
   d="scan'208";a="247714633"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2022 02:14:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,190,1647327600"; 
   d="scan'208";a="886465610"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 02 May 2022 02:14:29 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nlS8T-0009RP-5Y;
        Mon, 02 May 2022 09:14:29 +0000
Date:   Mon, 2 May 2022 17:13:53 +0800
From:   kernel test robot <lkp@intel.com>
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>, agross@kernel.org,
        bjorn.andersson@linaro.org, joro@8bytes.org, will@kernel.org,
        sricharan@codeaurora.org
Cc:     kbuild-all@lists.01.org, linux-arm-msm@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] iommu: fix an incorrect NULL check on list iterator
Message-ID: <202205021754.GETHfNnS-lkp@intel.com>
References: <20220501131259.11529-1-xiam0nd.tong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220501131259.11529-1-xiam0nd.tong@gmail.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Xiaomeng,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on joro-iommu/next]
[also build test ERROR on v5.18-rc5 next-20220429]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Xiaomeng-Tong/iommu-fix-an-incorrect-NULL-check-on-list-iterator/20220501-211400
base:   https://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git next
config: arm-allmodconfig (https://download.01.org/0day-ci/archive/20220502/202205021754.GETHfNnS-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/99e334beef5d5be25ed19d3142d16000f0a1986d
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Xiaomeng-Tong/iommu-fix-an-incorrect-NULL-check-on-list-iterator/20220501-211400
        git checkout 99e334beef5d5be25ed19d3142d16000f0a1986d
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=arm SHELL=/bin/bash drivers/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   drivers/iommu/msm_iommu.c: In function 'qcom_iommu_of_xlate':
>> drivers/iommu/msm_iommu.c:629:17: error: 'ret' undeclared (first use in this function); did you mean 'net'?
     629 |                 ret = -ENODEV;
         |                 ^~~
         |                 net
   drivers/iommu/msm_iommu.c:629:17: note: each undeclared identifier is reported only once for each function it appears in
   drivers/iommu/msm_iommu.c:638:1: error: control reaches end of non-void function [-Werror=return-type]
     638 | }
         | ^
   cc1: some warnings being treated as errors


vim +629 drivers/iommu/msm_iommu.c

f78ebca8ff3d61 Sricharan R   2016-06-13  614  
f78ebca8ff3d61 Sricharan R   2016-06-13  615  static int qcom_iommu_of_xlate(struct device *dev,
f78ebca8ff3d61 Sricharan R   2016-06-13  616  			       struct of_phandle_args *spec)
f78ebca8ff3d61 Sricharan R   2016-06-13  617  {
99e334beef5d5b Xiaomeng Tong 2022-05-01  618  	struct msm_iommu_dev *iommu = NULL, *iter;
f78ebca8ff3d61 Sricharan R   2016-06-13  619  	unsigned long flags;
f78ebca8ff3d61 Sricharan R   2016-06-13  620  
f78ebca8ff3d61 Sricharan R   2016-06-13  621  	spin_lock_irqsave(&msm_iommu_lock, flags);
99e334beef5d5b Xiaomeng Tong 2022-05-01  622  	list_for_each_entry(iter, &qcom_iommu_devices, dev_node)
99e334beef5d5b Xiaomeng Tong 2022-05-01  623  		if (iter->dev->of_node == spec->np) {
99e334beef5d5b Xiaomeng Tong 2022-05-01  624  			iommu = iter;
f78ebca8ff3d61 Sricharan R   2016-06-13  625  			break;
99e334beef5d5b Xiaomeng Tong 2022-05-01  626  		}
f78ebca8ff3d61 Sricharan R   2016-06-13  627  
99e334beef5d5b Xiaomeng Tong 2022-05-01  628  	if (!iommu) {
f78ebca8ff3d61 Sricharan R   2016-06-13 @629  		ret = -ENODEV;
f78ebca8ff3d61 Sricharan R   2016-06-13  630  		goto fail;
f78ebca8ff3d61 Sricharan R   2016-06-13  631  	}
f78ebca8ff3d61 Sricharan R   2016-06-13  632  
bb5bdc5ab7f133 Xiaoke Wang   2022-04-28  633  	ret = insert_iommu_master(dev, &iommu, spec);
f78ebca8ff3d61 Sricharan R   2016-06-13  634  fail:
f78ebca8ff3d61 Sricharan R   2016-06-13  635  	spin_unlock_irqrestore(&msm_iommu_lock, flags);
f78ebca8ff3d61 Sricharan R   2016-06-13  636  
f78ebca8ff3d61 Sricharan R   2016-06-13  637  	return ret;
f78ebca8ff3d61 Sricharan R   2016-06-13  638  }
f78ebca8ff3d61 Sricharan R   2016-06-13  639  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
