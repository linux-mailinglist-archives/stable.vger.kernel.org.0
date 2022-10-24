Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C49CF60B290
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbiJXQuQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234842AbiJXQrP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:47:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04AAB1C2F04;
        Mon, 24 Oct 2022 08:31:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85143B81A24;
        Mon, 24 Oct 2022 12:56:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB0AFC433D7;
        Mon, 24 Oct 2022 12:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666616159;
        bh=u6bQ6shkJdvnR5gPrBU77s9UZD5wLmWhUJw1JoEnmAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cDw50TlSwvlHXOXqepkPhAMXd5TML0Scx0eUlbFjIijK0GO/zn51ONZ/PX99Cy937
         8oIldKP9a47rW9lSyhdDDUxkQmve1DLFV7e/R9BBnXE+5YmpFFTNz7M25mkqkfJyAG
         +AizjrbhX/imCX0DquDrOyuof/c4PQ8dogcCa01s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianglei Nie <niejianglei2021@163.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 496/530] usb: host: xhci: Fix potential memory leak in xhci_alloc_stream_info()
Date:   Mon, 24 Oct 2022 13:34:00 +0200
Message-Id: <20221024113107.500189062@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jianglei Nie <niejianglei2021@163.com>

[ Upstream commit 7e271f42a5cc3768cd2622b929ba66859ae21f97 ]

xhci_alloc_stream_info() allocates stream context array for stream_info
->stream_ctx_array with xhci_alloc_stream_ctx(). When some error occurs,
stream_info->stream_ctx_array is not released, which will lead to a
memory leak.

We can fix it by releasing the stream_info->stream_ctx_array with
xhci_free_stream_ctx() on the error path to avoid the potential memory
leak.

Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20220921123450.671459-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-mem.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index b398d3fdabf6..02cd4d7c3e7e 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -642,7 +642,7 @@ struct xhci_stream_info *xhci_alloc_stream_info(struct xhci_hcd *xhci,
 			num_stream_ctxs, &stream_info->ctx_array_dma,
 			mem_flags);
 	if (!stream_info->stream_ctx_array)
-		goto cleanup_ctx;
+		goto cleanup_ring_array;
 	memset(stream_info->stream_ctx_array, 0,
 			sizeof(struct xhci_stream_ctx)*num_stream_ctxs);
 
@@ -703,6 +703,11 @@ struct xhci_stream_info *xhci_alloc_stream_info(struct xhci_hcd *xhci,
 	}
 	xhci_free_command(xhci, stream_info->free_streams_command);
 cleanup_ctx:
+	xhci_free_stream_ctx(xhci,
+		stream_info->num_stream_ctxs,
+		stream_info->stream_ctx_array,
+		stream_info->ctx_array_dma);
+cleanup_ring_array:
 	kfree(stream_info->stream_rings);
 cleanup_info:
 	kfree(stream_info);
-- 
2.35.1



