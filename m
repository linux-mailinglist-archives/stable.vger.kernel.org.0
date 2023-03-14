Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E53EA6B8AF1
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 07:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbjCNGKd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 02:10:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjCNGKc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 02:10:32 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 293C55DCAE;
        Mon, 13 Mar 2023 23:10:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678774231; x=1710310231;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=4mLCEy2H7JEU8KoAKmGcuzQP9O9EsavChPpUcqcifCc=;
  b=gGGWXK3KKqZsPWxOfP2VNov/ddWuJ73aDmwLkU7OVjsnu2/aAb3Xd3+U
   OvNpx8PtoVCq90lSNgTtRNEItC83pg/SSOniXH6aaG3VGSJwOmQxcU9Hg
   43OD/sXX1h344wpsy35AKgCY1fbTrtf7ZD3vju8caq5NYm1FIpGb1Uvhd
   OCHYIXo3I7TWUQ2XNzUko1D5yya0g0XvFgBuzR0ul+cRQlOqKFO3JAbnQ
   fOO6IeqZj8TRf5Hf53nb2CN5er+4vl5C5+P5zJ0h+svy8R3XHftcyr3Kt
   cTC8liWoiesgjRtg+3DT95EPzdA31F+8ezxS4I7M5d4R1koQW9IxXyJcO
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="316986725"
X-IronPort-AV: E=Sophos;i="5.98,259,1673942400"; 
   d="scan'208";a="316986725"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 23:10:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="802719705"
X-IronPort-AV: E=Sophos;i="5.98,259,1673942400"; 
   d="scan'208";a="802719705"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 13 Mar 2023 23:10:20 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pbxrX-0006aw-1A;
        Tue, 14 Mar 2023 06:10:19 +0000
Date:   Tue, 14 Mar 2023 14:09:23 +0800
From:   kernel test robot <lkp@intel.com>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <alvin@pqrs.dk>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marek Vasut <marex@denx.de>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        linux-usb@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] extcon: usbc-tusb320: unregister typec port on driver
 removal
Message-ID: <202303141316.EltVGG8V-lkp@intel.com>
References: <20230313130105.4183296-1-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230313130105.4183296-1-alvin@pqrs.dk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Alvin,

I love your patch! Perhaps something to improve:

[auto build test WARNING on chanwoo-extcon/extcon-next]
[also build test WARNING on linus/master v6.3-rc2 next-20230310]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Alvin-ipraga/extcon-usbc-tusb320-unregister-typec-port-on-driver-removal/20230313-210245
base:   https://git.kernel.org/pub/scm/linux/kernel/git/chanwoo/extcon.git extcon-next
patch link:    https://lore.kernel.org/r/20230313130105.4183296-1-alvin%40pqrs.dk
patch subject: [PATCH] extcon: usbc-tusb320: unregister typec port on driver removal
config: i386-randconfig-a013-20230313 (https://download.01.org/0day-ci/archive/20230314/202303141316.EltVGG8V-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/fe414069d19f6d59c7c34f820459f4114e2de136
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Alvin-ipraga/extcon-usbc-tusb320-unregister-typec-port-on-driver-removal/20230313-210245
        git checkout fe414069d19f6d59c7c34f820459f4114e2de136
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash drivers/extcon/ drivers/media/common/videobuf2/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303141316.EltVGG8V-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/extcon/extcon-usbc-tusb320.c:429:8: warning: expression result unused [-Wunused-value]
           priv->connector_fwnode;
           ~~~~  ^~~~~~~~~~~~~~~~
   1 warning generated.


vim +429 drivers/extcon/extcon-usbc-tusb320.c

   379	
   380	static int tusb320_typec_probe(struct i2c_client *client,
   381				       struct tusb320_priv *priv)
   382	{
   383		struct fwnode_handle *connector;
   384		const char *cap_str;
   385		int ret;
   386	
   387		/* The Type-C connector is optional, for backward compatibility. */
   388		connector = device_get_named_child_node(&client->dev, "connector");
   389		if (!connector)
   390			return 0;
   391	
   392		/* Type-C connector found. */
   393		ret = typec_get_fw_cap(&priv->cap, connector);
   394		if (ret)
   395			goto err_put;
   396	
   397		priv->port_type = priv->cap.type;
   398	
   399		/* This goes into register 0x8 field CURRENT_MODE_ADVERTISE */
   400		ret = fwnode_property_read_string(connector, "typec-power-opmode", &cap_str);
   401		if (ret)
   402			goto err_put;
   403	
   404		ret = typec_find_pwr_opmode(cap_str);
   405		if (ret < 0)
   406			goto err_put;
   407	
   408		priv->pwr_opmode = ret;
   409	
   410		/* Initialize the hardware with the devicetree settings. */
   411		ret = tusb320_set_adv_pwr_mode(priv);
   412		if (ret)
   413			goto err_put;
   414	
   415		priv->cap.revision		= USB_TYPEC_REV_1_1;
   416		priv->cap.accessory[0]		= TYPEC_ACCESSORY_AUDIO;
   417		priv->cap.accessory[1]		= TYPEC_ACCESSORY_DEBUG;
   418		priv->cap.orientation_aware	= true;
   419		priv->cap.driver_data		= priv;
   420		priv->cap.ops			= &tusb320_typec_ops;
   421		priv->cap.fwnode		= connector;
   422	
   423		priv->port = typec_register_port(&client->dev, &priv->cap);
   424		if (IS_ERR(priv->port)) {
   425			ret = PTR_ERR(priv->port);
   426			goto err_put;
   427		}
   428	
 > 429		priv->connector_fwnode;
   430	
   431		return 0;
   432	
   433	err_put:
   434		fwnode_handle_put(connector);
   435	
   436		return ret;
   437	}
   438	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
