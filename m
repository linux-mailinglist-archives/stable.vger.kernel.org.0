Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB721824E6
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 23:31:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729881AbgCKWbQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 18:31:16 -0400
Received: from mga03.intel.com ([134.134.136.65]:34041 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729799AbgCKWbP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Mar 2020 18:31:15 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Mar 2020 15:31:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,542,1574150400"; 
   d="gz'50?scan'50,208,50";a="231846698"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 11 Mar 2020 15:31:09 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1jC9sb-000AOV-4M; Thu, 12 Mar 2020 06:31:09 +0800
Date:   Thu, 12 Mar 2020 06:30:40 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     kbuild-all@lists.01.org,
        "linux-mmc@vger.kernel.org, Ulf Hansson" <ulf.hansson@linaro.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Ludovic Barre <ludovic.barre@st.com>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Chaotian Jing <chaotian.jing@mediatek.com>,
        Shawn Lin <shawn.lin@rock-chips.com>, mirq-linux@rere.qmqm.pl,
        Bitan Biswas <bbiswas@nvidia.com>,
        Peter Geis <pgwipeout@gmail.com>,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        Faiz Abbas <faiz_abbas@ti.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Jon Hunter <jonathanh@nvidia.com>, stable@vger.kernel.org
Subject: Re: [PATCH] mmc: core: Respect MMC_CAP_NEED_RSP_BUSY for eMMC sleep
 command
Message-ID: <202003120651.UpVhdtW8%lkp@intel.com>
References: <20200311092036.16084-1-ulf.hansson@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="WIyZ46R2i8wDzkSu"
Content-Disposition: inline
In-Reply-To: <20200311092036.16084-1-ulf.hansson@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Ulf,

I love your patch! Yet something to improve:

[auto build test ERROR on linus/master]
[also build test ERROR on v5.6-rc5 next-20200311]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Ulf-Hansson/mmc-core-Respect-MMC_CAP_NEED_RSP_BUSY-for-eMMC-sleep-command/20200312-034807
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git e3a36eb6dfaeea8175c05d5915dcf0b939be6dab
config: mips-vocore2_defconfig (attached as .config)
compiler: mipsel-linux-gcc (GCC) 5.5.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        GCC_VERSION=5.5.0 make.cross ARCH=mips 

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   drivers/mmc/core/mmc.c: In function 'mmc_sleep':
>> drivers/mmc/core/mmc.c:1917:21: error: 'MMC_CAP_NEED_RSP_BUSY' undeclared (first use in this function)
     if (!(host->caps & MMC_CAP_NEED_RSP_BUSY) && host->max_busy_timeout &&
                        ^
   drivers/mmc/core/mmc.c:1917:21: note: each undeclared identifier is reported only once for each function it appears in

vim +/MMC_CAP_NEED_RSP_BUSY +1917 drivers/mmc/core/mmc.c

  1890	
  1891	static int mmc_sleep(struct mmc_host *host)
  1892	{
  1893		struct mmc_command cmd = {};
  1894		struct mmc_card *card = host->card;
  1895		unsigned int timeout_ms = DIV_ROUND_UP(card->ext_csd.sa_timeout, 10000);
  1896		int err;
  1897	
  1898		/* Re-tuning can't be done once the card is deselected */
  1899		mmc_retune_hold(host);
  1900	
  1901		err = mmc_deselect_cards(host);
  1902		if (err)
  1903			goto out_release;
  1904	
  1905		cmd.opcode = MMC_SLEEP_AWAKE;
  1906		cmd.arg = card->rca << 16;
  1907		cmd.arg |= 1 << 15;
  1908	
  1909		/*
  1910		 * If the max_busy_timeout of the host is specified, validate it against
  1911		 * the sleep cmd timeout. A failure means we need to prevent the host
  1912		 * from doing hw busy detection, which is done by converting to a R1
  1913		 * response instead of a R1B. Note, some hosts requires R1B, which also
  1914		 * means they are on their own when it comes to deal with the busy
  1915		 * timeout.
  1916		 */
> 1917		if (!(host->caps & MMC_CAP_NEED_RSP_BUSY) && host->max_busy_timeout &&
  1918		    (timeout_ms > host->max_busy_timeout)) {
  1919			cmd.flags = MMC_RSP_R1 | MMC_CMD_AC;
  1920		} else {
  1921			cmd.flags = MMC_RSP_R1B | MMC_CMD_AC;
  1922			cmd.busy_timeout = timeout_ms;
  1923		}
  1924	
  1925		err = mmc_wait_for_cmd(host, &cmd, 0);
  1926		if (err)
  1927			goto out_release;
  1928	
  1929		/*
  1930		 * If the host does not wait while the card signals busy, then we will
  1931		 * will have to wait the sleep/awake timeout.  Note, we cannot use the
  1932		 * SEND_STATUS command to poll the status because that command (and most
  1933		 * others) is invalid while the card sleeps.
  1934		 */
  1935		if (!cmd.busy_timeout || !(host->caps & MMC_CAP_WAIT_WHILE_BUSY))
  1936			mmc_delay(timeout_ms);
  1937	
  1938	out_release:
  1939		mmc_retune_release(host);
  1940		return err;
  1941	}
  1942	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--WIyZ46R2i8wDzkSu
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--WIyZ46R2i8wDzkSu--
