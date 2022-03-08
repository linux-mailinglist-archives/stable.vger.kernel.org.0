Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D595F4D1410
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 10:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345567AbiCHKAn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 05:00:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345571AbiCHKAl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 05:00:41 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59E1A39687;
        Tue,  8 Mar 2022 01:59:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646733585; x=1678269585;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=CmU/s/E0INqhtkxEdG6nX1vb75Ifunj3U62eYAzaRTM=;
  b=L3+t5uD+F6cx8Htuf9pEuOOmlEOsJeQYAKWkF5oDMwHHidcDYk038kCT
   Ihp0zSZZ2kLSp+KnOiocbsh/Y7zJlAzkFzQ2Yi0yLax3CKylM+3GpVnVg
   oYS65LyJHKIwCdUfqOy2Q5wMj4EL0UOLU7LLhXXl4YLP/EQJbq1D0mJfm
   bUWUIJaxZF42xMsqfRBeG4DpF/IHPZL9x1JqBxJEFFKfqelWni0WndzkY
   sXn6Ry7CfxkKBB5RZjxJ9h1XcsBPNQ2iQVYGN2I5Ep4dweNQaTKh/Yf/I
   aIQ6G4n/BoYfeFCNwIx7Fng2mg1HQix5JQa4ns8JpL2BaoXZk56ExQyQj
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10279"; a="254373012"
X-IronPort-AV: E=Sophos;i="5.90,164,1643702400"; 
   d="scan'208";a="254373012"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2022 01:59:45 -0800
X-IronPort-AV: E=Sophos;i="5.90,164,1643702400"; 
   d="scan'208";a="553555980"
Received: from twinkler-lnx.jer.intel.com ([10.12.91.43])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2022 01:59:43 -0800
From:   Tomas Winkler <tomas.winkler@intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alexander Usyskin <alexander.usyskin@intel.com>,
        Vitaly Lubart <vitaly.lubart@intel.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next] mei: avoid iterator usage outside of list_for_each_entry
Date:   Tue,  8 Mar 2022 11:59:26 +0200
Message-Id: <20220308095926.300412-1-tomas.winkler@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

Usage of the iterator outside of the list_for_each_entry
is considered harmful. https://lkml.org/lkml/2022/2/17/1032

Do not reference the loop variable outside of the loop,
by rearranging the orders of execution.
Instead of performing search loop and checking outside the loop
if the end of the list was hit and no matching element was found,
the execution is performed inside the loop upon a successful match
followed by a goto statement to the next step,
therefore no condition has to be performed after the loop has ended.

Cc: <stable@vger.kernel.org>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/interrupt.c | 35 +++++++++++++++--------------------
 1 file changed, 15 insertions(+), 20 deletions(-)

diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index a67f4f2d33a9..0706322154cb 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -424,31 +424,26 @@ int mei_irq_read_handler(struct mei_device *dev,
 	list_for_each_entry(cl, &dev->file_list, link) {
 		if (mei_cl_hbm_equal(cl, mei_hdr)) {
 			cl_dbg(dev, cl, "got a message\n");
-			break;
+			ret = mei_cl_irq_read_msg(cl, mei_hdr, meta_hdr, cmpl_list);
+			goto reset_slots;
 		}
 	}
 
 	/* if no recipient cl was found we assume corrupted header */
-	if (&cl->link == &dev->file_list) {
-		/* A message for not connected fixed address clients
-		 * should be silently discarded
-		 * On power down client may be force cleaned,
-		 * silently discard such messages
-		 */
-		if (hdr_is_fixed(mei_hdr) ||
-		    dev->dev_state == MEI_DEV_POWER_DOWN) {
-			mei_irq_discard_msg(dev, mei_hdr, mei_hdr->length);
-			ret = 0;
-			goto reset_slots;
-		}
-		dev_err(dev->dev, "no destination client found 0x%08X\n",
-				dev->rd_msg_hdr[0]);
-		ret = -EBADMSG;
-		goto end;
+	/* A message for not connected fixed address clients
+	 * should be silently discarded
+	 * On power down client may be force cleaned,
+	 * silently discard such messages
+	 */
+	if (hdr_is_fixed(mei_hdr) ||
+	    dev->dev_state == MEI_DEV_POWER_DOWN) {
+		mei_irq_discard_msg(dev, mei_hdr, mei_hdr->length);
+		ret = 0;
+		goto reset_slots;
 	}
-
-	ret = mei_cl_irq_read_msg(cl, mei_hdr, meta_hdr, cmpl_list);
-
+	dev_err(dev->dev, "no destination client found 0x%08X\n", dev->rd_msg_hdr[0]);
+	ret = -EBADMSG;
+	goto end;
 
 reset_slots:
 	/* reset the number of slots and header */
-- 
2.35.1

