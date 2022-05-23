Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF5C9531A23
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240420AbiEWR20 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:28:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241701AbiEWR1F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:27:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 860CF72210;
        Mon, 23 May 2022 10:22:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13E0FB81215;
        Mon, 23 May 2022 17:22:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58226C385A9;
        Mon, 23 May 2022 17:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326529;
        bh=aXIclfWBIOx5lIp7wg9pctDo0qwzajhfixeFv43Rg3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pI52wukPqLmeQ/htaT07kQibqIcaVeaWskdm36wgXSfyOS8+KQKIfouL+uQ7LmnbN
         xRSVt7TgONfobnwCa7xNQMN0Vro8Y5ZdsDLtUBNQNucE//jW0O0U7rks9Vsrfx1X4m
         hC+fu4dRKf/jAyU3+aVFtwPmZdGzBrTbr9lhws0o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, TOTE Robot <oslab@tsinghua.edu.cn>,
        Zixuan Fu <r33s3n6@gmail.com>, Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 082/132] net: vmxnet3: fix possible NULL pointer dereference in vmxnet3_rq_cleanup()
Date:   Mon, 23 May 2022 19:04:51 +0200
Message-Id: <20220523165836.729718699@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165823.492309987@linuxfoundation.org>
References: <20220523165823.492309987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zixuan Fu <r33s3n6@gmail.com>

[ Upstream commit edf410cb74dc612fd47ef5be319c5a0bcd6e6ccd ]

In vmxnet3_rq_create(), when dma_alloc_coherent() fails,
vmxnet3_rq_destroy() is called. It sets rq->rx_ring[i].base to NULL. Then
vmxnet3_rq_create() returns an error to its callers mxnet3_rq_create_all()
-> vmxnet3_change_mtu(). Then vmxnet3_change_mtu() calls
vmxnet3_force_close() -> dev_close() in error handling code. And the driver
calls vmxnet3_close() -> vmxnet3_quiesce_dev() -> vmxnet3_rq_cleanup_all()
-> vmxnet3_rq_cleanup(). In vmxnet3_rq_cleanup(),
rq->rx_ring[ring_idx].base is accessed, but this variable is NULL, causing
a NULL pointer dereference.

To fix this possible bug, an if statement is added to check whether
rq->rx_ring[0].base is NULL in vmxnet3_rq_cleanup() and exit early if so.

The error log in our fault-injection testing is shown as follows:

[   65.220135] BUG: kernel NULL pointer dereference, address: 0000000000000008
...
[   65.222633] RIP: 0010:vmxnet3_rq_cleanup_all+0x396/0x4e0 [vmxnet3]
...
[   65.227977] Call Trace:
...
[   65.228262]  vmxnet3_quiesce_dev+0x80f/0x8a0 [vmxnet3]
[   65.228580]  vmxnet3_close+0x2c4/0x3f0 [vmxnet3]
[   65.228866]  __dev_close_many+0x288/0x350
[   65.229607]  dev_close_many+0xa4/0x480
[   65.231124]  dev_close+0x138/0x230
[   65.231933]  vmxnet3_force_close+0x1f0/0x240 [vmxnet3]
[   65.232248]  vmxnet3_change_mtu+0x75d/0x920 [vmxnet3]
...

Fixes: d1a890fa37f27 ("net: VMware virtual Ethernet NIC driver: vmxnet3")
Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Zixuan Fu <r33s3n6@gmail.com>
Link: https://lore.kernel.org/r/20220514050711.2636709-1-r33s3n6@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vmxnet3/vmxnet3_drv.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 8ab86bbdbf5e..bc3192cf48e3 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -1668,6 +1668,10 @@ vmxnet3_rq_cleanup(struct vmxnet3_rx_queue *rq,
 	u32 i, ring_idx;
 	struct Vmxnet3_RxDesc *rxd;
 
+	/* ring has already been cleaned up */
+	if (!rq->rx_ring[0].base)
+		return;
+
 	for (ring_idx = 0; ring_idx < 2; ring_idx++) {
 		for (i = 0; i < rq->rx_ring[ring_idx].size; i++) {
 #ifdef __BIG_ENDIAN_BITFIELD
-- 
2.35.1



