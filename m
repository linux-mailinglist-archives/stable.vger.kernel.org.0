Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93F0060A5FB
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233864AbiJXMbM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234086AbiJXM3S (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:29:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E76B88A0B;
        Mon, 24 Oct 2022 05:03:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 988BA612CD;
        Mon, 24 Oct 2022 11:54:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A70A5C433D6;
        Mon, 24 Oct 2022 11:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612460;
        bh=rIg2dTzgThn+dS3MU0ennADYE3Yj0Vem1J2NhhjSi+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QBCSsuzvuNUn4dzI5mrCKWTlcYvruLi863D5KuC+riKBCH11Z5uiinbu9+cUI8Sxg
         Usj1u74iWy36eNVOedOlo3NKc68kUsY4fs1yFmL0D4vD7uDzB9sDfImiT+i/D1K0XY
         ppCzLFLZCWa8HfBuRcObX5MhV5tL/gWwSWQQqkTg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianglei Nie <niejianglei2021@163.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 199/210] usb: host: xhci: Fix potential memory leak in xhci_alloc_stream_info()
Date:   Mon, 24 Oct 2022 13:31:56 +0200
Message-Id: <20221024113003.434828631@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
References: <20221024112956.797777597@linuxfoundation.org>
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
index e930e2777c87..ae724460c8f2 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -657,7 +657,7 @@ struct xhci_stream_info *xhci_alloc_stream_info(struct xhci_hcd *xhci,
 			num_stream_ctxs, &stream_info->ctx_array_dma,
 			mem_flags);
 	if (!stream_info->stream_ctx_array)
-		goto cleanup_ctx;
+		goto cleanup_ring_array;
 	memset(stream_info->stream_ctx_array, 0,
 			sizeof(struct xhci_stream_ctx)*num_stream_ctxs);
 
@@ -718,6 +718,11 @@ struct xhci_stream_info *xhci_alloc_stream_info(struct xhci_hcd *xhci,
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



