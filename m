Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 040654CBC23
	for <lists+stable@lfdr.de>; Thu,  3 Mar 2022 12:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232627AbiCCLIU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Mar 2022 06:08:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232399AbiCCLIT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Mar 2022 06:08:19 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A778817AAA;
        Thu,  3 Mar 2022 03:07:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646305653; x=1677841653;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=74os4aT3i+C2SOidVvHvZZBWyvDlquCbqF5/mimla4Q=;
  b=QY3rr1Sip08jAL0EYdj0bl7LTwbomToklSw3GT6ap++YxjI6vwYL3P8/
   ytOXkWUMv3hQOlPaaAm+L65T0+y91w3rA8l4JqrtLf+UAIC+gPoM0gWbH
   b78H6VzdjVsxfkxORprnYDco7vJFjCbOnGlhg0aD851KiQh0iT6r7HGzm
   45VSAROBYdL9yS2h+ZIJ+EjaRmqKhdiitw8PHkkI0GiB4gT/Wu8aliWQw
   EadqVqW3Jr+smEi+RusPIJEQ4+i/K2xWsqZlrQx0k8GzUzDoGp2CJ1XG8
   VFtPdL90efyWvAJcc50BkVl6kToUNoaTABXM+G705YCNH+Xs6M8z6kdAp
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10274"; a="251219879"
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="251219879"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2022 03:07:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="576452357"
Received: from mattu-haswell.fi.intel.com ([10.237.72.199])
  by orsmga001.jf.intel.com with ESMTP; 03 Mar 2022 03:07:31 -0800
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>,
        Anssi Hannula <anssi.hannula@bitwise.fi>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH v2 2/9] xhci: fix garbage USBSTS being logged in some cases
Date:   Thu,  3 Mar 2022 13:08:56 +0200
Message-Id: <20220303110903.1662404-3-mathias.nyman@linux.intel.com>
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

xhci_decode_usbsts() is expected to return a zero-terminated string by
its only caller, xhci_stop_endpoint_command_watchdog(), which directly
logs the return value:

  xhci_warn(xhci, "USBSTS:%s\n", xhci_decode_usbsts(str, usbsts));

However, if no recognized bits are set in usbsts, the function will
return without having called any sprintf() and therefore return an
untouched non-zero-terminated caller-provided buffer, causing garbage
to be output to log.

Fix that by always including the raw value in the output.

Note that before commit 4843b4b5ec64 ("xhci: fix even more unsafe memory
usage in xhci tracing") the result effect in the failure case was different
as a static buffer was used here, but the code still worked incorrectly.

Fixes: 9c1aa36efdae ("xhci: Show host status when watchdog triggers and host is assumed dead.")
Cc: stable@vger.kernel.org
Signed-off-by: Anssi Hannula <anssi.hannula@bitwise.fi>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index fce32f8ea9d0..1d83ddace482 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -2625,8 +2625,11 @@ static inline const char *xhci_decode_usbsts(char *str, u32 usbsts)
 {
 	int ret = 0;
 
+	ret = sprintf(str, " 0x%08x", usbsts);
+
 	if (usbsts == ~(u32)0)
-		return " 0xffffffff";
+		return str;
+
 	if (usbsts & STS_HALT)
 		ret += sprintf(str + ret, " HCHalted");
 	if (usbsts & STS_FATAL)
-- 
2.25.1

