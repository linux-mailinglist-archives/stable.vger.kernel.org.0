Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 552F568963C
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233461AbjBCKZS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:25:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233476AbjBCKZG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:25:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51FDF2FCE3
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:24:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4478661E5D
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:24:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 137F7C4339B;
        Fri,  3 Feb 2023 10:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419885;
        bh=pdgtpVvH+QLYHxEW0gg+Kv2WAE6uFIXwrN7IYbfw83U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I6qKjRs+xcr3x0KUBzIQVe/Xz8CBGQflzSXoWaBNgVKjAAqrd24Tu4Mdi394+jsIL
         VdBSUaLqRmKx8zXJ+fgbi5JEVkfoGBndrCryrlxtQE2CtAepQD0ErClBxtcFS060Ef
         JCOIf2lj7BqBqBXzrvvCNkuQYhR7ldE3vuRMVFQY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 010/134] HID: intel_ish-hid: Add check for ishtp_dma_tx_map
Date:   Fri,  3 Feb 2023 11:11:55 +0100
Message-Id: <20230203101024.315121009@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit b3d40c3ec3dc4ad78017de6c3a38979f57aaaab8 ]

As the kcalloc may return NULL pointer,
it should be better to check the ishtp_dma_tx_map
before use in order to avoid NULL pointer dereference.

Fixes: 3703f53b99e4 ("HID: intel_ish-hid: ISH Transport layer")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/intel-ish-hid/ishtp/dma-if.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/hid/intel-ish-hid/ishtp/dma-if.c b/drivers/hid/intel-ish-hid/ishtp/dma-if.c
index 40554c8daca0..00046cbfd4ed 100644
--- a/drivers/hid/intel-ish-hid/ishtp/dma-if.c
+++ b/drivers/hid/intel-ish-hid/ishtp/dma-if.c
@@ -104,6 +104,11 @@ void *ishtp_cl_get_dma_send_buf(struct ishtp_device *dev,
 	int required_slots = (size / DMA_SLOT_SIZE)
 		+ 1 * (size % DMA_SLOT_SIZE != 0);
 
+	if (!dev->ishtp_dma_tx_map) {
+		dev_err(dev->devc, "Fail to allocate Tx map\n");
+		return NULL;
+	}
+
 	spin_lock_irqsave(&dev->ishtp_dma_tx_lock, flags);
 	for (i = 0; i <= (dev->ishtp_dma_num_slots - required_slots); i++) {
 		free = 1;
@@ -150,6 +155,11 @@ void ishtp_cl_release_dma_acked_mem(struct ishtp_device *dev,
 		return;
 	}
 
+	if (!dev->ishtp_dma_tx_map) {
+		dev_err(dev->devc, "Fail to allocate Tx map\n");
+		return;
+	}
+
 	i = (msg_addr - dev->ishtp_host_dma_tx_buf) / DMA_SLOT_SIZE;
 	spin_lock_irqsave(&dev->ishtp_dma_tx_lock, flags);
 	for (j = 0; j < acked_slots; j++) {
-- 
2.39.0



