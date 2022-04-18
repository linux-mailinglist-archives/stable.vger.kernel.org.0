Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6891505279
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbiDRMpi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237490AbiDRMoT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:44:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FB4926AEA;
        Mon, 18 Apr 2022 05:32:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F03EEB80EC0;
        Mon, 18 Apr 2022 12:32:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CC64C385A1;
        Mon, 18 Apr 2022 12:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285152;
        bh=Y+mN8yxB8UYnXBTzQwry6M5BRV4I9UhvtQahWGKhiB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v1ZZvtB9020U/ZWt/gDMgqTDYWrTGR3/cgve3HKrhwhYncjPb0Upeaf1g73DrApaA
         LR/t4XTkPG7FfEyoIp8E5YvoCcOKhUZth52Z/8wjK1fcpAEJbISIS2/DYk+s5AKCqn
         wkftYfbe29oX/5Dj+cDl+jx6brh+BieUp/vpuieE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Kelley <mikelley@microsoft.com>,
        "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 118/189] Drivers: hv: vmbus: Prevent load re-ordering when reading ring buffer
Date:   Mon, 18 Apr 2022 14:12:18 +0200
Message-Id: <20220418121203.846698225@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121200.312988959@linuxfoundation.org>
References: <20220418121200.312988959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 314015d9e912..f4091143213b 100644
--- a/drivers/hv/ring_buffer.c
+++ b/drivers/hv/ring_buffer.c
@@ -408,7 +408,16 @@ int hv_ringbuffer_read(struct vmbus_channel *channel,
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



