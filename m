Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4635B6383E6
	for <lists+stable@lfdr.de>; Fri, 25 Nov 2022 07:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiKYGNf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Nov 2022 01:13:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbiKYGNP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Nov 2022 01:13:15 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 443102F388;
        Thu, 24 Nov 2022 22:12:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669356733; x=1700892733;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6jYt7Cj8zjwcswBZNQ/vgJGpt/57KFSil74omp6mMf8=;
  b=Vjq45Bli3Xrx1bDbLlvF/2oh3fLUEI8h6mREwgHy1HzmaKFy/El+il1T
   j2P6QFPMZg0qB81+1oQtSjlO5EvtP4pPO96q+7QOL5+5Cmv7yvq+rqNzx
   fV6wapURr38QX8m6DNbwcJ6VWU69Lx9uuHTyJNLVWdQfsXaUvhdnWLUqW
   JaSsY522E82y++luRsfl6+R/CgBEoNw4oEqRjlFkXHwS5SfX17Lb6d9Ex
   vXJI3IvAvQvHRiHz8m/FzNN4A0mKy5QDEmoQPM+Bh+gQ11vP/EuBnvnt7
   PJW2xmrEjTpyB8Y0Usv27RAvA0st0WjfAZCXqfzjVk6CJkHwN3EmH9YVf
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="294801830"
X-IronPort-AV: E=Sophos;i="5.96,192,1665471600"; 
   d="scan'208";a="294801830"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 22:10:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="620236912"
X-IronPort-AV: E=Sophos;i="5.96,192,1665471600"; 
   d="scan'208";a="620236912"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga006.jf.intel.com with ESMTP; 24 Nov 2022 22:10:49 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id 1C0CA128; Fri, 25 Nov 2022 08:11:14 +0200 (EET)
Date:   Fri, 25 Nov 2022 08:11:14 +0200
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Shevchenko <andy@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        stable@vger.kernel.org, Dale Smith <dalepsmith@gmail.com>,
        John Harris <jmharris@gmail.com>
Subject: Re: [PATCH v1 1/1] pinctrl: intel: Save and restore pins in "direct
 IRQ" mode
Message-ID: <Y4BcguSaNlh7VbLQ@black.fi.intel.com>
References: <20221124222926.72326-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221124222926.72326-1-andriy.shevchenko@linux.intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 25, 2022 at 12:29:26AM +0200, Andy Shevchenko wrote:
> The firmware on some systems may configure GPIO pins to be
> an interrupt source in so called "direct IRQ" mode. In such
> cases the GPIO controller driver has no idea if those pins
> are being used or not. At the same time, there is a known bug
> in the firmwares that don't restore the pin settings correctly
> after suspend, i.e. by an unknown reason the Rx value becomes
> inverted.
> 
> Hence, let's save and restore the pins that are configured
> as GPIOs in the input mode with GPIROUTIOXAPIC bit set.
> 
> Cc: stable@vger.kernel.org
> Reported-and-tested-by: Dale Smith <dalepsmith@gmail.com>
> Reported-and-tested-by: John Harris <jmharris@gmail.com>
> BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=214749
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Thanks Andy!

Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
