Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD014FC99D
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 02:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242759AbiDLAsE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 20:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242900AbiDLArc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 20:47:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC53015FFE;
        Mon, 11 Apr 2022 17:45:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 40ACF612A8;
        Tue, 12 Apr 2022 00:45:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51593C385AB;
        Tue, 12 Apr 2022 00:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724315;
        bh=4rQkhM+RJN5qC5mkIJ7o7Iyrqs+aVLeQY8i7Xhtec2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f5QQCdmppk+wPWBOzK8O8MckjlkiNXiQHB+JEmPjWlehqXqVGvYE6kk/tb73b9wnq
         4LFvB42NqzKeqPAhOlqc1xPuM3EllsK1akt25UrKbYTW3gRqtm+hgNMhAnIBOpOvmb
         QXZZt/J2q1W6m8AAAQM92hK6t/lS09aOn5J2ie5kiWCETZ93mxAZ4qHyMaLmX8bo0l
         huMkgcty7slcjjWr7THir9OQAh2iBH4ODdPdaqbTyjEkYswF1RAGct8igQ1bA2dMb3
         0PdIixHx2U8tpEeLEW9X6H7QEQWGuJV6pERnl5zcrxKRTXCqG3jXcu4mO4Rlfp1AzP
         HjPd+uFp/ngjQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Kelley <mikelley@microsoft.com>,
        Andrea Parri <parri.andrea@gmail.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>,
        kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        decui@microsoft.com, linux-hyperv@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 16/49] Drivers: hv: vmbus: Prevent load re-ordering when reading ring buffer
Date:   Mon, 11 Apr 2022 20:43:34 -0400
Message-Id: <20220412004411.349427-16-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412004411.349427-1-sashal@kernel.org>
References: <20220412004411.349427-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Michael Kelley <mikelley@microsoft.com>

[ Upstream commit b6cae15b5710c8097aad26a2e5e752c323ee5348 ]

When reading a packet from a host-to-guest ring buffer, there is no
memory barrier between reading the write index (to see if there is
a packet to read) and reading the contents of the packet. The Hyper-V
host uses store-release when updating the write index to ensure that
writes of the packet data are completed first. On the guest side,
the processor can reorder and read the packet data before the write
index, and sometimes get stale packet data. Getting such stale packet
data has been observed in a reproducible case in a VM on ARM64.

Fix this by using virt_load_acquire() to read the write index,
ensuring that reads of the packet data cannot be reordered
before it. Preventing such reordering is logically correct, and
with this change, getting stale data can no longer be reproduced.

Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Reviewed-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
Link: https://lore.kernel.org/r/1648394710-33480-1-git-send-email-mikelley@microsoft.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/ring_buffer.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/hv/ring_buffer.c b/drivers/hv/ring_buffer.c
index 71efacb90965..3d215d9dec43 100644
--- a/drivers/hv/ring_buffer.c
+++ b/drivers/hv/ring_buffer.c
@@ -439,7 +439,16 @@ int hv_ringbuffer_read(struct vmbus_channel *channel,
 static u32 hv_pkt_iter_avail(const struct hv_ring_buffer_info *rbi)
 {
 	u32 priv_read_loc = rbi->priv_read_index;
-	u32 write_loc = READ_ONCE(rbi->ring_buffer->write_index);
+	u32 write_loc;
+
+	/*
+	 * The Hyper-V host writes the packet data, then uses
+	 * store_release() to update the write_index.  Use load_acquire()
+	 * here to prevent loads of the packet data from being re-ordered
+	 * before the read of the write_index and potentially getting
+	 * stale data.
+	 */
+	write_loc = virt_load_acquire(&rbi->ring_buffer->write_index);
 
 	if (write_loc >= priv_read_loc)
 		return write_loc - priv_read_loc;
-- 
2.35.1

