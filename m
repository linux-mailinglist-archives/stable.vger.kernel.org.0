Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96596590ACA
	for <lists+stable@lfdr.de>; Fri, 12 Aug 2022 05:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237060AbiHLDfu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 23:35:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237005AbiHLDfo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 23:35:44 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E639866A75;
        Thu, 11 Aug 2022 20:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660275343; x=1691811343;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Gru/FUZqTnEoJxGSm5QiBlsSsNziw8YaNMIgwiFWbVg=;
  b=kX2lYV7fHs6+YlG++aJj0IKmMAPNusWv+GxnTrpZ2WY4XTxIpI+QdEd1
   SsK+rz0FjboHrQKQvuzocQOluzeZAGxXnuXXlElMlghr467xQ0nm+po+X
   cPKk8AWF5/vYAIOH+SNcV+LYaDko/aOxVdrUEc6wYVVws9rY/AiRz3Jki
   p32hkMeKznpKkbpsKkkR4gGyIe07WtlEAJAlkZNMZvjiqduBegqEFmmHr
   UWazh0HBbM23wF/V8sW+yDeK0wVdcolThiRaTjAzxu++Ufvfkn+5t21DT
   hX913CL+Bih33OPRgT0sHhBoPeF4DY34s20ZmH+mwWiEkFYMualmeFJZn
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10436"; a="353256156"
X-IronPort-AV: E=Sophos;i="5.93,231,1654585200"; 
   d="scan'208";a="353256156"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2022 20:35:43 -0700
X-IronPort-AV: E=Sophos;i="5.93,231,1654585200"; 
   d="scan'208";a="665660913"
Received: from jzhou16-mobl2.ccr.corp.intel.com (HELO [10.254.214.221]) ([10.254.214.221])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2022 20:35:38 -0700
Message-ID: <3748b73a-d02c-0f85-b245-6a8295ccecf6@linux.intel.com>
Date:   Fri, 12 Aug 2022 11:35:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Cc:     baolu.lu@linux.intel.com, llvm@lists.linux.dev,
        kbuild-all@lists.01.org, Joerg Roedel <joro@8bytes.org>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        Wen Jin <wen.jin@intel.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/1] iommu/vt-d: Fix kdump kernels boot failure with
 scalable mode
Content-Language: en-US
To:     kernel test robot <lkp@intel.com>, iommu@lists.linux.dev
References: <20220808034612.1691470-1-baolu.lu@linux.intel.com>
 <202208081636.6sNc86bT-lkp@intel.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <202208081636.6sNc86bT-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022/8/8 17:04, kernel test robot wrote:
> Hi Lu,
> 
> I love your patch! Yet something to improve:
> 
> [auto build test ERROR on linus/master]
> [also build test ERROR on next-20220808]
> [cannot apply to joro-iommu/next v5.19]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:https://github.com/intel-lab-lkp/linux/commits/Lu-Baolu/iommu-vt-d-Fix-kdump-kernels-boot-failure-with-scalable-mode/20220808-115156
> base:https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git  4e23eeebb2e57f5a28b36221aa776b5a1122dde5
> config: x86_64-randconfig-a011-20220808 (https://download.01.org/0day-ci/archive/20220808/202208081636.6sNc86bT-lkp@intel.com/config)
> compiler: clang version 16.0.0 (https://github.com/llvm/llvm-project  5f1c7e2cc5a3c07cbc2412e851a7283c1841f520)
> reproduce (this is a W=1 build):
>          wgethttps://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross  -O ~/bin/make.cross
>          chmod +x ~/bin/make.cross
>          #https://github.com/intel-lab-lkp/linux/commit/335018299049ac5dc13ff12d320b5952bed7e8f8
>          git remote add linux-reviewhttps://github.com/intel-lab-lkp/linux
>          git fetch --no-tags linux-review Lu-Baolu/iommu-vt-d-Fix-kdump-kernels-boot-failure-with-scalable-mode/20220808-115156
>          git checkout 335018299049ac5dc13ff12d320b5952bed7e8f8
>          # save the config file
>          mkdir build_dir && cp config build_dir/.config
>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash
> 
> If you fix the issue, kindly add following tag where applicable
> Reported-by: kernel test robot<lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>     In file included from drivers/iommu/intel/dmar.c:33:
>>> drivers/iommu/intel/iommu.h:705:14: error: no member named 'copied_tables' in 'struct intel_iommu'

Thanks for reporting. This happens when INTEL_IOMMU=n && DMAR=y. I will
fix it in the next version.

Best regards,
baolu
