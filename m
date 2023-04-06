Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 043B16D92AB
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 11:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236091AbjDFJ14 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 05:27:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236180AbjDFJ14 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 05:27:56 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1FF76E9D;
        Thu,  6 Apr 2023 02:27:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680773270; x=1712309270;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=InPNIBceKrNnxNxhCo8TDxqyXGZESVT0F+BzGH5I//k=;
  b=TNpzp+bOMyh8T1FXO5QFZvfJd0Ndcn8MMb+f44sIuetfuVnHglVqhxjc
   o4TGFiJmvRA0pTTRXWJK3Qz3Vr460JWfFP3+gGdbXDaoffCFlAifoo86a
   xWPQxfoxB2LFOkjiomh7uPjiGG+sWhdHWvqOV2uH0C438m+zyIpyAQOLZ
   0ANm+e1btBUMzKfM4aB3vO5KJV4kTzUsxxyWfgmyGV+IDJPv62Ly534uT
   VgDAMtDfTzVVjMecNwJR6D1sceTfkffP3RSsZ48oT18wHOWEKqNs7aAS1
   SOr3uYsDtNqaDPx3g2yOyLu6rY6T/uw3vRVbxGuc5Sjj7SjBI7SQuRbDW
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="345288857"
X-IronPort-AV: E=Sophos;i="5.98,323,1673942400"; 
   d="scan'208";a="345288857"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2023 02:27:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="1016809916"
X-IronPort-AV: E=Sophos;i="5.98,323,1673942400"; 
   d="scan'208";a="1016809916"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 06 Apr 2023 02:27:46 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pkLuE-000RGg-0I;
        Thu, 06 Apr 2023 09:27:46 +0000
Date:   Thu, 6 Apr 2023 17:26:48 +0800
From:   kernel test robot <lkp@intel.com>
To:     Badhri Jagan Sridharan <badhri@google.com>,
        gregkh@linuxfoundation.org, stern@rowland.harvard.edu,
        colin.i.king@gmail.com, xuetao09@huawei.com,
        quic_eserrao@quicinc.com, water.zhangjiantao@huawei.com,
        peter.chen@freescale.com, balbi@ti.com
Cc:     oe-kbuild-all@lists.linux.dev, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Badhri Jagan Sridharan <badhri@google.com>
Subject: Re: [PATCH v2 1/2] usb: gadget: udc: core: Invoke usb_gadget_connect
 only when started
Message-ID: <202304061758.Tz5RJDZU-lkp@intel.com>
References: <20230406062549.2461917-1-badhri@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230406062549.2461917-1-badhri@google.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Badhri,

kernel test robot noticed the following build warnings:

[auto build test WARNING on d629c0e221cd99198b843d8351a0a9bfec6c0423]

url:    https://github.com/intel-lab-lkp/linux/commits/Badhri-Jagan-Sridharan/usb-gadget-udc-core-Prevent-redundant-calls-to-pullup/20230406-142708
base:   d629c0e221cd99198b843d8351a0a9bfec6c0423
patch link:    https://lore.kernel.org/r/20230406062549.2461917-1-badhri%40google.com
patch subject: [PATCH v2 1/2] usb: gadget: udc: core: Invoke usb_gadget_connect only when started
config: s390-allyesconfig (https://download.01.org/0day-ci/archive/20230406/202304061758.Tz5RJDZU-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/2f12e8b0c9bf3d25df88c73b614c3e8d84bd7338
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Badhri-Jagan-Sridharan/usb-gadget-udc-core-Prevent-redundant-calls-to-pullup/20230406-142708
        git checkout 2f12e8b0c9bf3d25df88c73b614c3e8d84bd7338
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=s390 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=s390 SHELL=/bin/bash drivers/usb/gadget/udc/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304061758.Tz5RJDZU-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/usb/gadget/udc/core.c:696:5: warning: no previous prototype for 'usb_gadget_connect_locked' [-Wmissing-prototypes]
     696 | int usb_gadget_connect_locked(struct usb_gadget *gadget)
         |     ^~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/usb/gadget/udc/core.c:749:5: warning: no previous prototype for 'usb_gadget_disconnect_locked' [-Wmissing-prototypes]
     749 | int usb_gadget_disconnect_locked(struct usb_gadget *gadget)
         |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~


vim +/usb_gadget_connect_locked +696 drivers/usb/gadget/udc/core.c

   694	
   695	/* Internal version of usb_gadget_connect needs to be called with udc_connect_control_lock held. */
 > 696	int usb_gadget_connect_locked(struct usb_gadget *gadget)
   697	{
   698		int ret = 0;
   699	
   700		if (!gadget->ops->pullup) {
   701			ret = -EOPNOTSUPP;
   702			goto out;
   703		}
   704	
   705		if (gadget->deactivated || !gadget->udc->started) {
   706			/*
   707			 * If gadget is deactivated we only save new state.
   708			 * Gadget will be connected automatically after activation.
   709			 *
   710			 * udc first needs to be started before gadget can be pulled up.
   711			 */
   712			gadget->connected = true;
   713			goto out;
   714		}
   715	
   716		ret = gadget->ops->pullup(gadget, 1);
   717		if (!ret)
   718			gadget->connected = 1;
   719	
   720	out:
   721		trace_usb_gadget_connect(gadget, ret);
   722	
   723		return ret;
   724	}
   725	
   726	/**
   727	 * usb_gadget_connect - software-controlled connect to USB host
   728	 * @gadget:the peripheral being connected
   729	 *
   730	 * Enables the D+ (or potentially D-) pullup.  The host will start
   731	 * enumerating this gadget when the pullup is active and a VBUS session
   732	 * is active (the link is powered).
   733	 *
   734	 * Returns zero on success, else negative errno.
   735	 */
   736	int usb_gadget_connect(struct usb_gadget *gadget)
   737	{
   738		int ret;
   739	
   740		mutex_lock(&gadget->udc->connect_lock);
   741		ret = usb_gadget_connect_locked(gadget);
   742		mutex_unlock(&gadget->udc->connect_lock);
   743	
   744		return ret;
   745	}
   746	EXPORT_SYMBOL_GPL(usb_gadget_connect);
   747	
   748	/* Internal version of usb_gadget_disconnect needs to be called with udc->connect_lock held. */
 > 749	int usb_gadget_disconnect_locked(struct usb_gadget *gadget)
   750	{
   751		int ret = 0;
   752	
   753		if (!gadget->ops->pullup) {
   754			ret = -EOPNOTSUPP;
   755			goto out;
   756		}
   757	
   758		if (!gadget->connected)
   759			goto out;
   760	
   761		if (gadget->deactivated || !gadget->udc->started) {
   762			/*
   763			 * If gadget is deactivated we only save new state.
   764			 * Gadget will stay disconnected after activation.
   765			 *
   766			 * udc should have been started before gadget being pulled down.
   767			 */
   768			gadget->connected = false;
   769			goto out;
   770		}
   771	
   772		ret = gadget->ops->pullup(gadget, 0);
   773		if (!ret)
   774			gadget->connected = 0;
   775	
   776		mutex_lock(&udc_lock);
   777		if (gadget->udc->driver)
   778			gadget->udc->driver->disconnect(gadget);
   779		mutex_unlock(&udc_lock);
   780	
   781	out:
   782		trace_usb_gadget_disconnect(gadget, ret);
   783	
   784		return ret;
   785	}
   786	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
