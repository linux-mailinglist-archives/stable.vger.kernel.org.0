Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 659B64CBC26
	for <lists+stable@lfdr.de>; Thu,  3 Mar 2022 12:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232636AbiCCLIW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Mar 2022 06:08:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232626AbiCCLIW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Mar 2022 06:08:22 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3545B59;
        Thu,  3 Mar 2022 03:07:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646305655; x=1677841655;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IVlmjCWFleFaQIZOFMVVi1fmFAsE8fignO+22Fs7Fvk=;
  b=H0+PQM1rT5PemajYuYMPAeRQC7cV/6tO2S30EryPvR5meamCYeET0rBf
   KQlQrp4HZc2oNsmtR/whNuoe6L7XVH6uvqLaJMRfF/raCTsO7l6WSt/Ij
   xWb+/wXc5LTNmlpjd/+j1zQ4BrR0pjMeDjtfhYcYFztrgpDqQqJ7S8rZa
   AkeRBeOBX/hgnfArWmgR0ZZILYt8IvqbbEW1pAG8lZ/DBhSNRTNdy2Jd6
   vI4Jgpq/LUFxsHEeRySSqpVaV4vBHHiDD6ic5M8kE0X5MqZe5nB+x7Qyk
   uWcgmodjp4j+rcWG3/NyehS7yZdNxXTxlcRDuav8Slh+oMKLEwhQGPk6T
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10274"; a="251219885"
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="251219885"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2022 03:07:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="576452371"
Received: from mattu-haswell.fi.intel.com ([10.237.72.199])
  by orsmga001.jf.intel.com with ESMTP; 03 Mar 2022 03:07:33 -0800
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>,
        Anssi Hannula <anssi.hannula@bitwise.fi>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH v2 3/9] xhci: fix uninitialized string returned by xhci_decode_ctrl_ctx()
Date:   Thu,  3 Mar 2022 13:08:57 +0200
Message-Id: <20220303110903.1662404-4-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220303110903.1662404-1-mathias.nyman@linux.intel.com>
References: <20220303110903.1662404-1-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anssi Hannula <anssi.hannula@bitwise.fi>

xhci_decode_ctrl_ctx() returns the untouched buffer as-is if both "drop"
and "add" parameters are zero.

Fix the function to return an empty string in that case.

It was not immediately clear from the possible call chains whether this
issue is currently actually triggerable or not.

Note that before commit 4843b4b5ec64 ("xhci: fix even more unsafe memory
usage in xhci tracing") the result effect in the failure case was different
as a static buffer was used here, but the code still worked incorrectly.

Fixes: 90d6d5731da7 ("xhci: Add tracing for input control context")
Cc: stable@vger.kernel.org
Signed-off-by: Anssi Hannula <anssi.hannula@bitwise.fi>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>

commit 4843b4b5ec64 ("xhci: fix even more unsafe memory usage in xhci tracing")
---
 drivers/usb/host/xhci.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 1d83ddace482..473a33ce299e 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -2468,6 +2468,8 @@ static inline const char *xhci_decode_ctrl_ctx(char *str,
 	unsigned int	bit;
 	int		ret = 0;
 
+	str[0] = '\0';
+
 	if (drop) {
 		ret = sprintf(str, "Drop:");
 		for_each_set_bit(bit, &drop, 32)
-- 
2.25.1

