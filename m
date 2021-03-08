Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0CEF33142E
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 18:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbhCHRJY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 12:09:24 -0500
Received: from mga07.intel.com ([134.134.136.100]:26559 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229646AbhCHRJG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 12:09:06 -0500
IronPort-SDR: RnA5kG6rr08ZXHFJWRy/dljkq7hrqhzRyjGktwqnCQUb1Z26rMoSmANq7hvyCG/dahyQkRRA62
 Cbp60FX3iAxw==
X-IronPort-AV: E=McAfee;i="6000,8403,9917"; a="252095713"
X-IronPort-AV: E=Sophos;i="5.81,232,1610438400"; 
   d="scan'208";a="252095713"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2021 09:08:50 -0800
IronPort-SDR: ZOFpuvo8wwoBwmhfusA6vab8NUDVYUz7znmPbV+a/enelrBrvSyn/dIMbg4aIiQB7ps1iX6XLT
 GXSoZ51lLs8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,232,1610438400"; 
   d="scan'208";a="408295193"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga007.jf.intel.com with ESMTP; 08 Mar 2021 09:08:48 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 2665A147; Mon,  8 Mar 2021 19:08:45 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andy Shevchenko <andy@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        stable@vger.kernel.org, Maximilian Luz <luzmaximilian@gmail.com>
Subject: [PATCH v2 1/1] pinctrl: intel: Show the GPIO base calculation explicitly
Date:   Mon,  8 Mar 2021 19:08:42 +0200
Message-Id: <20210308170842.88555-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

During the split of intel_pinctrl_add_padgroups(), the _by_size() variant
missed the GPIO base calculations and hence made unable to retrieve proper
GPIO number.

Assign the gpio_base explicitly in _by_size() variant.

While at it, differentiate NOMAP case with the rest in _by_gpps() variant.

Fixes: 036e126c72eb ("pinctrl: intel: Split intel_pinctrl_add_padgroups() for better maintenance")
Reported-and-tested-by: Maximilian Luz <luzmaximilian@gmail.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
v2: added tag and Cc'ed to stable@ (Mika)
 drivers/pinctrl/intel/pinctrl-intel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pinctrl/intel/pinctrl-intel.c b/drivers/pinctrl/intel/pinctrl-intel.c
index 8085782cd8f9..7283203861ae 100644
--- a/drivers/pinctrl/intel/pinctrl-intel.c
+++ b/drivers/pinctrl/intel/pinctrl-intel.c
@@ -1357,6 +1357,7 @@ static int intel_pinctrl_add_padgroups_by_gpps(struct intel_pinctrl *pctrl,
 				gpps[i].gpio_base = 0;
 				break;
 			case INTEL_GPIO_BASE_NOMAP:
+				break;
 			default:
 				break;
 		}
@@ -1393,6 +1394,7 @@ static int intel_pinctrl_add_padgroups_by_size(struct intel_pinctrl *pctrl,
 		gpps[i].size = min(gpp_size, npins);
 		npins -= gpps[i].size;
 
+		gpps[i].gpio_base = gpps[i].base;
 		gpps[i].padown_num = padown_num;
 
 		/*
-- 
2.30.1

