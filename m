Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84A9A6B4248
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231530AbjCJOBh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:01:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231483AbjCJOB2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:01:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6482D114ED9
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:01:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F365B61552
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:01:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1CE7C4339B;
        Fri, 10 Mar 2023 14:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456886;
        bh=uuFptdgdXONQlpP314S7OqYZlmrK8PnW/w/gUmsCNCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ICYlk6hTcwzWrIeuFLjz18xA3HjNwn57Mo/ytOeTSihlDJ4u3OaHA5M/pwAFX2Qja
         BM3z1VpPyXGui5mUBSWP98ESQ4Y+4JLoVJFF4tVtbXFDbKML1uDWUxjHdSJEDujdzg
         EJWKjh3kWD39wZUzDd7lZd/5IFALdpdHdZNxSqN4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alan Stern <stern@rowland.harvard.edu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 159/211] USB: uhci: fix memory leak with using debugfs_lookup()
Date:   Fri, 10 Mar 2023 14:38:59 +0100
Message-Id: <20230310133723.594731638@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 0a3f82c79c86278e7f144564b1cb6cc5c3657144 ]

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  To make things simpler, just
call debugfs_lookup_and_remove() instead which handles all of the logic
at once.

Cc: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20230202153235.2412790-3-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/uhci-hcd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/uhci-hcd.c b/drivers/usb/host/uhci-hcd.c
index c22b51af83fcb..7cdc2fa7c28fb 100644
--- a/drivers/usb/host/uhci-hcd.c
+++ b/drivers/usb/host/uhci-hcd.c
@@ -536,8 +536,8 @@ static void release_uhci(struct uhci_hcd *uhci)
 	uhci->is_initialized = 0;
 	spin_unlock_irq(&uhci->lock);
 
-	debugfs_remove(debugfs_lookup(uhci_to_hcd(uhci)->self.bus_name,
-				      uhci_debugfs_root));
+	debugfs_lookup_and_remove(uhci_to_hcd(uhci)->self.bus_name,
+				  uhci_debugfs_root);
 
 	for (i = 0; i < UHCI_NUM_SKELQH; i++)
 		uhci_free_qh(uhci, uhci->skelqh[i]);
@@ -700,7 +700,7 @@ static int uhci_start(struct usb_hcd *hcd)
 			uhci->frame, uhci->frame_dma_handle);
 
 err_alloc_frame:
-	debugfs_remove(debugfs_lookup(hcd->self.bus_name, uhci_debugfs_root));
+	debugfs_lookup_and_remove(hcd->self.bus_name, uhci_debugfs_root);
 
 	return retval;
 }
-- 
2.39.2



