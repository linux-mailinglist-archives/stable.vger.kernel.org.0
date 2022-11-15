Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1407E629B6E
	for <lists+stable@lfdr.de>; Tue, 15 Nov 2022 15:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238495AbiKOOEX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Nov 2022 09:04:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbiKOOEW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Nov 2022 09:04:22 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83E722A272;
        Tue, 15 Nov 2022 06:04:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668521061; x=1700057061;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=JYGN4YJCKpoBV1HK1xLD1KHTUJxt32dHk1bzAhudxGo=;
  b=hRHuYgEqyjvzCjtcxSzsmO4RvIN7pIR6x43963SPoseRe4AvD/8/XSkC
   9mNblLeUQX2enO9dN0zPpL35NfLGHeE7uMFRBqov+7B2EBrjyk/qJ93gK
   LJMqyCNXyIGO7fY3aUsMmQ7WBV0vSRSJUlm3BE682bWGjR423Ga90IDAJ
   wbnU+XVQzXVzPQX2k2FyAv1pvqtbFjx9IMyA0Rf/nyryuwmo2M5Trmp60
   1NbHt9xw5lo4lTwSwrBPUyMBclBRAIcKEA5lgl6AKRbKfMO/yNqHowSAN
   1xuj8nontZuU5Jmyj0mDyZE+4HIBTKfKv8VqyyB0612a6NOOgGRyPT6R9
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="292653173"
X-IronPort-AV: E=Sophos;i="5.96,166,1665471600"; 
   d="scan'208";a="292653173"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2022 06:04:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="781352842"
X-IronPort-AV: E=Sophos;i="5.96,166,1665471600"; 
   d="scan'208";a="781352842"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmsmga001.fm.intel.com with ESMTP; 15 Nov 2022 06:04:18 -0800
Date:   Tue, 15 Nov 2022 21:54:54 +0800
From:   Xu Yilun <yilun.xu@intel.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Russ Weight <russell.h.weight@intel.com>, mdf@kernel.org,
        hao.wu@intel.com, trix@redhat.com, linux-fpga@vger.kernel.org,
        linux-kernel@vger.kernel.org, lgoncalv@redhat.com,
        marpagan@redhat.com, matthew.gerlach@linux.intel.com,
        basheer.ahmed.muddebihal@intel.com, tianfei.zhang@intel.com,
        kernel test robot <lkp@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH v1 1/1] fpga: m10bmc-sec: Fix kconfig dependencies
Message-ID: <Y3OaLlcTJECIeZoB@yilunxu-OptiPlex-7050>
References: <20221115001127.289890-1-russell.h.weight@intel.com>
 <48206188-97e3-1477-87f1-8946320be737@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48206188-97e3-1477-87f1-8946320be737@infradead.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-11-14 at 17:03:03 -0800, Randy Dunlap wrote:
> 
> 
> On 11/14/22 16:11, Russ Weight wrote:
> > The secure update driver depends on the firmware-upload functionality of
> > the firmware-loader. The firmware-loader is carried in the firmware-class
> > driver which is enabled with the tristate CONFIG_FW_LOADER option. The
> > firmware-upload functionality is included in the firmware-class driver if
> > the bool FW_UPLOAD config is set.
> > 
> > The current dependency statement, "depends on FW_UPLOAD", is not adequate
> > because it does not implicitly turn on FW_LOADER. Instead of adding a
> > dependency, follow the convention used by drivers that require the
> > FW_LOADER_USER_HELPER functionality of the firmware-loader by using
> > select for both FW_LOADER and FW_UPLOAD.
> > 
> > Fixes: bdf86d0e6ca3 ("fpga: m10bmc-sec: create max10 bmc secure update")
> > Reported-by: kernel test robot <lkp@intel.com>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Russ Weight <russell.h.weight@intel.com>
> 
> Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested

Acked-by: Xu Yilun <yilun.xu@intel.com>

Applied to for-6.1

> 
> Thanks.
> 
> > ---
> >  drivers/fpga/Kconfig | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/fpga/Kconfig b/drivers/fpga/Kconfig
> > index d1a8107fdcb3..6ce143dafd04 100644
> > --- a/drivers/fpga/Kconfig
> > +++ b/drivers/fpga/Kconfig
> > @@ -246,7 +246,9 @@ config FPGA_MGR_VERSAL_FPGA
> >  
> >  config FPGA_M10_BMC_SEC_UPDATE
> >  	tristate "Intel MAX10 BMC Secure Update driver"
> > -	depends on MFD_INTEL_M10_BMC && FW_UPLOAD
> > +	depends on MFD_INTEL_M10_BMC
> > +	select FW_LOADER
> > +	select FW_UPLOAD
> >  	help
> >  	  Secure update support for the Intel MAX10 board management
> >  	  controller.
> 
> -- 
> ~Randy
