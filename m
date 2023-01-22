Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92D0F676FD5
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbjAVPZn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:25:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231400AbjAVPZn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:25:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D008022A01
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:25:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 671B260C44
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:25:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78FE5C433D2;
        Sun, 22 Jan 2023 15:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674401140;
        bh=nTbne1nt77NyCgxYrpQHQ7oRR4YAisxOQsnupA2Fqeo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ovP/pS8CtUkqeJA0BCbquzTBRGKTyfKkYEnzlaVLp3Wp637MJjNSUbC2mzylBQMq6
         2BW6wn+2vFQrIVyr3Ggp1UgjZwkn32VKVLutvBpARl7m7aauiGSM99oCyVMLrk/XpN
         9dtPUQ8M3Lp9jjdf5TL7XJWK4gJFXamH6+y1DTEs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Reinette Chatre <reinette.chatre@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.1 124/193] dmaengine: idxd: Do not call DMX TX callbacks during workqueue disable
Date:   Sun, 22 Jan 2023 16:04:13 +0100
Message-Id: <20230122150251.987459454@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Reinette Chatre <reinette.chatre@intel.com>

commit 6744a030d81e456883bfbb627ac1f30465c1a989 upstream.

On driver unload any pending descriptors are flushed and pending
DMA descriptors are explicitly completed:
idxd_dmaengine_drv_remove() ->
	drv_disable_wq() ->
		idxd_wq_free_irq() ->
			idxd_flush_pending_descs() ->
				idxd_dma_complete_txd()

With this done during driver unload any remaining descriptor is
likely stuck and can be dropped. Even so, the descriptor may still
have a callback set that could no longer be accessible. An
example of such a problem is when the dmatest fails and the dmatest
module is unloaded. The failure of dmatest leaves descriptors with
dma_async_tx_descriptor::callback pointing to code that no longer
exist. This causes a page fault as below at the time the IDXD driver
is unloaded when it attempts to run the callback:
 BUG: unable to handle page fault for address: ffffffffc0665190
 #PF: supervisor instruction fetch in kernel mode
 #PF: error_code(0x0010) - not-present page

Fix this by clearing the callback pointers on the transmit
descriptors only when workqueue is disabled.

Fixes: 403a2e236538 ("dmaengine: idxd: change MSIX allocation based on per wq activation")
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Fenghua Yu <fenghua.yu@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/37d06b772aa7f8863ca50f90930ea2fd80b38fc3.1670452419.git.reinette.chatre@intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/idxd/device.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -1173,8 +1173,19 @@ static void idxd_flush_pending_descs(str
 	spin_unlock(&ie->list_lock);
 
 	list_for_each_entry_safe(desc, itr, &flist, list) {
+		struct dma_async_tx_descriptor *tx;
+
 		list_del(&desc->list);
 		ctype = desc->completion->status ? IDXD_COMPLETE_NORMAL : IDXD_COMPLETE_ABORT;
+		/*
+		 * wq is being disabled. Any remaining descriptors are
+		 * likely to be stuck and can be dropped. callback could
+		 * point to code that is no longer accessible, for example
+		 * if dmatest module has been unloaded.
+		 */
+		tx = &desc->txd;
+		tx->callback = NULL;
+		tx->callback_result = NULL;
 		idxd_dma_complete_txd(desc, ctype, true);
 	}
 }


