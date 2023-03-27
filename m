Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CAF36CA076
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 11:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233265AbjC0Jt5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 05:49:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233010AbjC0Jtg (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 27 Mar 2023 05:49:36 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74C6D5276;
        Mon, 27 Mar 2023 02:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679910574; x=1711446574;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xBeLqlQQ2ZjA9fI2W7QipMFz4tnsQ/MApd2Q6uLzh6w=;
  b=NWfeLEs/db/OnAuPLB6R/j58XUSxPLR2V39uZso4boMr86cwYpsg6LQL
   euCskZK0E1b8ZaHmp04WM6GVoKfa8K+D4++6V3YnJp9xuFBvWI/LhpJrF
   UHh6XMwkG8p8HJY/gpBy4yVLeQcBoGqu8srjHiLhrrALa2JoFh4io7bqe
   hHc0FwJmYVajyru4aEfOp1jB/A2gyqZuzRgWxJRJwi5RlJzaDJFM2oF4V
   dUCbHzipOmW8DNqFvNOzLJ9CauowbtcB7wa9oj6sU2bfDxzx4F8fzVzvw
   yVy29Lu4VhL4vm6umYWrU9lOGzoObFxnJKHI/BJVdGlVaC4rBncO2P6XB
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10661"; a="367968164"
X-IronPort-AV: E=Sophos;i="5.98,294,1673942400"; 
   d="scan'208";a="367968164"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2023 02:49:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10661"; a="716017172"
X-IronPort-AV: E=Sophos;i="5.98,294,1673942400"; 
   d="scan'208";a="716017172"
Received: from mattu-haswell.fi.intel.com ([10.237.72.199])
  by orsmga001.jf.intel.com with ESMTP; 27 Mar 2023 02:49:28 -0700
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     mirsad.todorovac@alu.unizg.hr, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, ubuntu-devel-discuss@lists.ubuntu.com,
        stern@rowland.harvard.edu, arnd@arndb.de,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Stable@vger.kernel.org
Subject: [PATCH] xhci: Free the command allocated for setting LPM if we return early
Date:   Mon, 27 Mar 2023 12:50:19 +0300
Message-Id: <20230327095019.1017159-1-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <b86fcdbd-f1c6-846f-838f-b7679ec4e2b4@linux.intel.com>
References: <b86fcdbd-f1c6-846f-838f-b7679ec4e2b4@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The command allocated to set exit latency LPM values need to be freed in
case the command is never queued. This would be the case if there is no
change in exit latency values, or device is missing.

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

