Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C46E4DE3DB
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 23:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241225AbiCRWDN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 18:03:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239124AbiCRWDM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 18:03:12 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E60B10DA58;
        Fri, 18 Mar 2022 15:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647640913; x=1679176913;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SYb/OD8wg6Ueo4+cA8AVOPQns3NV0dsnYyIUMFY3Asg=;
  b=AzT9HbWtkNCGdfR/bwfC5DlF4XgNjYG9WTkPJNG6360OalJ1UDsQpJ9q
   CPiOiT6DBV8BfNArYA+ebYAo6b84+0cMNtzD/EOrt4Y8uGhnFn+LlOwGd
   oJswjWhG3cib9y1ovjPCbVK27tKCrjQPxRNHnmJNTqoEcE5g/NWmTk9a9
   LihlXS1Dvfc5cWeOYaTwSriGsN8HEzARX0Q7e10N0hjM9od+Nw6mYZprK
   P3/qH8mj816AirQsxTLv3Mm/BJy0AIRShAZbbW+ASE6OyD1jqPKVoIJLv
   cdKVA6rpVYNMPl4Uq3NZuaxQbQgxd12T6G3XldstH+MLMahhfRZtswnnN
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10290"; a="256059345"
X-IronPort-AV: E=Sophos;i="5.90,192,1643702400"; 
   d="scan'208";a="256059345"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2022 15:01:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,192,1643702400"; 
   d="scan'208";a="635911530"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by FMSMGA003.fm.intel.com with ESMTP; 18 Mar 2022 15:01:50 -0700
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nVKfN-000FBn-Hi; Fri, 18 Mar 2022 22:01:49 +0000
Date:   Sat, 19 Mar 2022 06:01:08 +0800
From:   kernel test robot <lkp@intel.com>
To:     Takashi Iwai <tiwai@suse.de>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Takashi Iwai <tiwai@suse.de>,
        =?iso-8859-1?Q?Jos=E9_Exp=F3sito?= <jose.exposito89@gmail.com>,
        linux-input@vger.kernel.org,
        Peter Hutterer <peter.hutterer@who-t.net>,
        Jiri Kosina <jkosina@suse.cz>, stable@vger.kernel.org,
        regressions@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: multitouch: fix Dell Precision 7550 and 7750 button
 type
Message-ID: <202203190553.mMQsoOV3-lkp@intel.com>
References: <s5hh77v2uov.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hh77v2uov.wl-tiwai@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Takashi,

I love your patch! Yet something to improve:

[auto build test ERROR on hid/for-next]
[also build test ERROR on v5.17-rc8 next-20220318]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Takashi-Iwai/HID-multitouch-fix-Dell-Precision-7550-and-7750-button-type/20220318-223749
base:   https://git.kernel.org/pub/scm/linux/kernel/git/hid/hid.git for-next
config: i386-randconfig-a002 (https://download.01.org/0day-ci/archive/20220319/202203190553.mMQsoOV3-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project a6e70e4056dff962ec634c5bd4f2f4105a0bef71)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/34d08d524d0942a3242bf820e364dc3f496dbd6c
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Takashi-Iwai/HID-multitouch-fix-Dell-Precision-7550-and-7750-button-type/20220318-223749
        git checkout 34d08d524d0942a3242bf820e364dc3f496dbd6c
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash drivers/hid/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> drivers/hid/hid-multitouch.c:313:31: error: expected expression
                           MT_QUIRK_WIN8_PTP_BUTTONS |,
                                                      ^
   1 error generated.


vim +313 drivers/hid/hid-multitouch.c

   242	
   243	static const struct mt_class mt_classes[] = {
   244		{ .name = MT_CLS_DEFAULT,
   245			.quirks = MT_QUIRK_ALWAYS_VALID |
   246				MT_QUIRK_CONTACT_CNT_ACCURATE },
   247		{ .name = MT_CLS_NSMU,
   248			.quirks = MT_QUIRK_NOT_SEEN_MEANS_UP },
   249		{ .name = MT_CLS_SERIAL,
   250			.quirks = MT_QUIRK_ALWAYS_VALID},
   251		{ .name = MT_CLS_CONFIDENCE,
   252			.quirks = MT_QUIRK_VALID_IS_CONFIDENCE },
   253		{ .name = MT_CLS_CONFIDENCE_CONTACT_ID,
   254			.quirks = MT_QUIRK_VALID_IS_CONFIDENCE |
   255				MT_QUIRK_SLOT_IS_CONTACTID },
   256		{ .name = MT_CLS_CONFIDENCE_MINUS_ONE,
   257			.quirks = MT_QUIRK_VALID_IS_CONFIDENCE |
   258				MT_QUIRK_SLOT_IS_CONTACTID_MINUS_ONE },
   259		{ .name = MT_CLS_DUAL_INRANGE_CONTACTID,
   260			.quirks = MT_QUIRK_VALID_IS_INRANGE |
   261				MT_QUIRK_SLOT_IS_CONTACTID,
   262			.maxcontacts = 2 },
   263		{ .name = MT_CLS_DUAL_INRANGE_CONTACTNUMBER,
   264			.quirks = MT_QUIRK_VALID_IS_INRANGE |
   265				MT_QUIRK_SLOT_IS_CONTACTNUMBER,
   266			.maxcontacts = 2 },
   267		{ .name = MT_CLS_INRANGE_CONTACTNUMBER,
   268			.quirks = MT_QUIRK_VALID_IS_INRANGE |
   269				MT_QUIRK_SLOT_IS_CONTACTNUMBER },
   270		{ .name = MT_CLS_WIN_8,
   271			.quirks = MT_QUIRK_ALWAYS_VALID |
   272				MT_QUIRK_IGNORE_DUPLICATES |
   273				MT_QUIRK_HOVERING |
   274				MT_QUIRK_CONTACT_CNT_ACCURATE |
   275				MT_QUIRK_STICKY_FINGERS |
   276				MT_QUIRK_WIN8_PTP_BUTTONS,
   277			.export_all_inputs = true },
   278		{ .name = MT_CLS_EXPORT_ALL_INPUTS,
   279			.quirks = MT_QUIRK_ALWAYS_VALID |
   280				MT_QUIRK_CONTACT_CNT_ACCURATE,
   281			.export_all_inputs = true },
   282		{ .name = MT_CLS_WIN_8_FORCE_MULTI_INPUT,
   283			.quirks = MT_QUIRK_ALWAYS_VALID |
   284				MT_QUIRK_IGNORE_DUPLICATES |
   285				MT_QUIRK_HOVERING |
   286				MT_QUIRK_CONTACT_CNT_ACCURATE |
   287				MT_QUIRK_STICKY_FINGERS |
   288				MT_QUIRK_WIN8_PTP_BUTTONS |
   289				MT_QUIRK_FORCE_MULTI_INPUT,
   290			.export_all_inputs = true },
   291		{ .name = MT_CLS_WIN_8_DISABLE_WAKEUP,
   292			.quirks = MT_QUIRK_ALWAYS_VALID |
   293				MT_QUIRK_IGNORE_DUPLICATES |
   294				MT_QUIRK_HOVERING |
   295				MT_QUIRK_CONTACT_CNT_ACCURATE |
   296				MT_QUIRK_STICKY_FINGERS |
   297				MT_QUIRK_WIN8_PTP_BUTTONS |
   298				MT_QUIRK_DISABLE_WAKEUP,
   299			.export_all_inputs = true },
   300		{ .name = MT_CLS_WIN_8_NO_STICKY_FINGERS,
   301			.quirks = MT_QUIRK_ALWAYS_VALID |
   302				MT_QUIRK_IGNORE_DUPLICATES |
   303				MT_QUIRK_HOVERING |
   304				MT_QUIRK_CONTACT_CNT_ACCURATE |
   305				MT_QUIRK_WIN8_PTP_BUTTONS,
   306			.export_all_inputs = true },
   307		{ .name = MT_CLS_BUTTONTYPE_TOUCHPAD,
   308			.quirks = MT_QUIRK_ALWAYS_VALID |
   309				MT_QUIRK_IGNORE_DUPLICATES |
   310				MT_QUIRK_HOVERING |
   311				MT_QUIRK_CONTACT_CNT_ACCURATE |
   312				MT_QUIRK_STICKY_FINGERS |
 > 313				MT_QUIRK_WIN8_PTP_BUTTONS |,
   314				MT_QUIRK_BUTTONTYPE_TOUCHPAD,
   315			.export_all_inputs = true },
   316	
   317		/*
   318		 * vendor specific classes
   319		 */
   320		{ .name = MT_CLS_3M,
   321			.quirks = MT_QUIRK_VALID_IS_CONFIDENCE |
   322				MT_QUIRK_SLOT_IS_CONTACTID |
   323				MT_QUIRK_TOUCH_SIZE_SCALING,
   324			.sn_move = 2048,
   325			.sn_width = 128,
   326			.sn_height = 128,
   327			.maxcontacts = 60,
   328		},
   329		{ .name = MT_CLS_EGALAX,
   330			.quirks =  MT_QUIRK_SLOT_IS_CONTACTID |
   331				MT_QUIRK_VALID_IS_INRANGE,
   332			.sn_move = 4096,
   333			.sn_pressure = 32,
   334		},
   335		{ .name = MT_CLS_EGALAX_SERIAL,
   336			.quirks =  MT_QUIRK_SLOT_IS_CONTACTID |
   337				MT_QUIRK_ALWAYS_VALID,
   338			.sn_move = 4096,
   339			.sn_pressure = 32,
   340		},
   341		{ .name = MT_CLS_TOPSEED,
   342			.quirks = MT_QUIRK_ALWAYS_VALID,
   343			.is_indirect = true,
   344			.maxcontacts = 2,
   345		},
   346		{ .name = MT_CLS_PANASONIC,
   347			.quirks = MT_QUIRK_NOT_SEEN_MEANS_UP,
   348			.maxcontacts = 4 },
   349		{ .name	= MT_CLS_GENERALTOUCH_TWOFINGERS,
   350			.quirks	= MT_QUIRK_NOT_SEEN_MEANS_UP |
   351				MT_QUIRK_VALID_IS_INRANGE |
   352				MT_QUIRK_SLOT_IS_CONTACTID,
   353			.maxcontacts = 2
   354		},
   355		{ .name	= MT_CLS_GENERALTOUCH_PWT_TENFINGERS,
   356			.quirks	= MT_QUIRK_NOT_SEEN_MEANS_UP |
   357				MT_QUIRK_SLOT_IS_CONTACTID
   358		},
   359	
   360		{ .name = MT_CLS_FLATFROG,
   361			.quirks = MT_QUIRK_NOT_SEEN_MEANS_UP |
   362				MT_QUIRK_NO_AREA,
   363			.sn_move = 2048,
   364			.maxcontacts = 40,
   365		},
   366		{ .name = MT_CLS_LG,
   367			.quirks = MT_QUIRK_ALWAYS_VALID |
   368				MT_QUIRK_FIX_CONST_CONTACT_ID |
   369				MT_QUIRK_IGNORE_DUPLICATES |
   370				MT_QUIRK_HOVERING |
   371				MT_QUIRK_CONTACT_CNT_ACCURATE },
   372		{ .name = MT_CLS_ASUS,
   373			.quirks = MT_QUIRK_ALWAYS_VALID |
   374				MT_QUIRK_CONTACT_CNT_ACCURATE |
   375				MT_QUIRK_ASUS_CUSTOM_UP },
   376		{ .name = MT_CLS_VTL,
   377			.quirks = MT_QUIRK_ALWAYS_VALID |
   378				MT_QUIRK_CONTACT_CNT_ACCURATE |
   379				MT_QUIRK_FORCE_GET_FEATURE,
   380		},
   381		{ .name = MT_CLS_GOOGLE,
   382			.quirks = MT_QUIRK_ALWAYS_VALID |
   383				MT_QUIRK_CONTACT_CNT_ACCURATE |
   384				MT_QUIRK_SLOT_IS_CONTACTID |
   385				MT_QUIRK_HOVERING
   386		},
   387		{ .name = MT_CLS_RAZER_BLADE_STEALTH,
   388			.quirks = MT_QUIRK_ALWAYS_VALID |
   389				MT_QUIRK_IGNORE_DUPLICATES |
   390				MT_QUIRK_HOVERING |
   391				MT_QUIRK_CONTACT_CNT_ACCURATE |
   392				MT_QUIRK_WIN8_PTP_BUTTONS,
   393		},
   394		{ .name = MT_CLS_SMART_TECH,
   395			.quirks = MT_QUIRK_ALWAYS_VALID |
   396				MT_QUIRK_IGNORE_DUPLICATES |
   397				MT_QUIRK_CONTACT_CNT_ACCURATE |
   398				MT_QUIRK_SEPARATE_APP_REPORT,
   399		},
   400		{ }
   401	};
   402	

---
0-DAY CI Kernel Test Service
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
