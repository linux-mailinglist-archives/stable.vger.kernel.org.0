Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D94996D0859
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 16:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232113AbjC3OaD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 10:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232345AbjC3OaB (ORCPT
        <rfc822;Stable@vger.kernel.org>); Thu, 30 Mar 2023 10:30:01 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8037B3;
        Thu, 30 Mar 2023 07:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680186600; x=1711722600;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hTiUmnEecxYNtA9xQHIkvXv5NkPp0vGZ3pfAXPcUgus=;
  b=HFYilgzsqPUMFc4LkPAdAGNqlH/afgyPIL4baBDpFcNE1v93eFeh95g4
   T294+63ha4hUIxUzUvP9LoZ3SfazabDpu1FWnrh3IH1UEYcodyvFurBHN
   XS+fwIDC1+BCqpLqppsqRyuTqVBEU3G7YImIVs59flWme1DQKOp8nV/eG
   P03g9PQK6+sV2OeVWyT/PpanSPCjWymYNBOhXtWE11shUsPVxUbeTGz9t
   06VSXt1MQeVVpyTYVqI9nKcej/HFyFFwvklOs8KTM+ktSyuNzTIrJxXKG
   RDsl+gntx6EYOZutWoc1jvvagKTnum8VuNa6fGKMtwXzqSznee0NBrejS
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="406172544"
X-IronPort-AV: E=Sophos;i="5.98,303,1673942400"; 
   d="scan'208";a="406172544"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2023 07:29:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="774021097"
X-IronPort-AV: E=Sophos;i="5.98,303,1673942400"; 
   d="scan'208";a="774021097"
Received: from mattu-haswell.fi.intel.com ([10.237.72.199])
  by FMSMGA003.fm.intel.com with ESMTP; 30 Mar 2023 07:29:50 -0700
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>,
        Stable@vger.kernel.org
Subject: [PATCH 3/3] xhci: Free the command allocated for setting LPM if we return early
Date:   Thu, 30 Mar 2023 17:30:56 +0300
Message-Id: <20230330143056.1390020-4-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230330143056.1390020-1-mathias.nyman@linux.intel.com>
References: <20230330143056.1390020-1-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The command allocated to set exit latency LPM values need to be freed in
case the command is never queued. This would be the case if there is no
change in exit latency values, or device is missing.

Reported-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Link: https://lore.kernel.org/linux-usb/24263902-c9b3-ce29-237b-1c3d6918f4fe@alu.unizg.hr
Tested-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Fixes: 5c2a380a5aa8 ("xhci: Allocate separate command structures for each LPM command")
Cc: <Stable@vger.kernel.org>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index bdb6dd819a3b..6307bae9cddf 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -4442,6 +4442,7 @@ static int __maybe_unused xhci_change_max_exit_latency(struct xhci_hcd *xhci,
 
 	if (!virt_dev || max_exit_latency == virt_dev->current_mel) {
 		spin_unlock_irqrestore(&xhci->lock, flags);
+		xhci_free_command(xhci, command);
 		return 0;
 	}
 
-- 
2.25.1

