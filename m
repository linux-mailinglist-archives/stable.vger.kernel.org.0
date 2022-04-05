Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 227C54F3A5C
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244788AbiDELoo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:44:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354633AbiDEKO5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:14:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B774949915;
        Tue,  5 Apr 2022 03:01:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77D84B81C8B;
        Tue,  5 Apr 2022 10:01:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8CF0C385A2;
        Tue,  5 Apr 2022 10:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152908;
        bh=E/V8qGzLRoFzJuYpZWUx/E60yGc/iIh6mMdRxNsZPbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GgceHJx7grJ3SiQdT7TDRqFwWz7edKuM8bTH3rj224P/jE4mv1G8f9EevkXGt3XNA
         0MiycCOJT3yUPDPrtu9rO77ipgtKBGL+01+DCJtfs7eLdqYhjUNZkTmgSWt1FJDigp
         HMfuEaJ1MhYBo0fqIrOiBIPQ6g5+4ihvy9x7Rx4Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 5.10 031/599] mei: avoid iterator usage outside of list_for_each_entry
Date:   Tue,  5 Apr 2022 09:25:25 +0200
Message-Id: <20220405070259.747908078@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit c10187b1c5ebb8681ca467ab7b0ded5ea415d258 upstream.

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
Link: https://lore.kernel.org/r/20220308095926.300412-1-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/interrupt.c |   35 +++++++++++++++--------------------
 1 file changed, 15 insertions(+), 20 deletions(-)

--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -427,31 +427,26 @@ int mei_irq_read_handler(struct mei_devi
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


