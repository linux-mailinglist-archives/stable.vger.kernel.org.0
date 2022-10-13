Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A26B15FD163
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231901AbiJMAgM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232215AbiJMAe2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:34:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 227FD11E440;
        Wed, 12 Oct 2022 17:29:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66713616C2;
        Thu, 13 Oct 2022 00:26:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE524C433D6;
        Thu, 13 Oct 2022 00:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620805;
        bh=BN27ZtVKkJ3LHKlBDcv2Kvb9Ok07kbOCpdjRtHGbjVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d3LZEEav5WV0MdOiOi4+f+GoDVyQk3uA6vhJHzAgey2KTkWEAChuB7za6WfvaztH7
         oEhA7rNM16vFtFXE0YTpTk/UGTBQGhxx5/ZKGBerVbDzPdrjY+RTDmQm6r1J+nlscj
         btFBhkHncTOaQ4NTFQbAayDn6g3/Wi6sgjfTxn7OmVY4thEnMf+qDopvn8JHChSfry
         kU4Q5ph6DonJD0VldVNCjQ3uCP6jqcJws97laNey+HQWuRHILLllzxiLPVwbdh+/5U
         cmsPmiyNJac8KSjmMiKGKPHbPoYjKbLjTcLoK65ZKY+zEC5+OZRF9rAYqBSRNKUhYO
         bsMWo4SlZG+GA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jianglei Nie <niejianglei2021@163.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, mathias.nyman@intel.com,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 11/19] usb: host: xhci: Fix potential memory leak in xhci_alloc_stream_info()
Date:   Wed, 12 Oct 2022 20:26:10 -0400
Message-Id: <20221013002623.1895576-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013002623.1895576-1-sashal@kernel.org>
References: <20221013002623.1895576-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 798823ce2b34..7de21722d455 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -650,7 +650,7 @@ struct xhci_stream_info *xhci_alloc_stream_info(struct xhci_hcd *xhci,
 			num_stream_ctxs, &stream_info->ctx_array_dma,
 			mem_flags);
 	if (!stream_info->stream_ctx_array)
-		goto cleanup_ctx;
+		goto cleanup_ring_array;
 	memset(stream_info->stream_ctx_array, 0,
 			sizeof(struct xhci_stream_ctx)*num_stream_ctxs);
 
@@ -711,6 +711,11 @@ struct xhci_stream_info *xhci_alloc_stream_info(struct xhci_hcd *xhci,
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

