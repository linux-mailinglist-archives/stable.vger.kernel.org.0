Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0CE4FD568
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354117AbiDLHi0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353595AbiDLHZs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:25:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22B6326126;
        Tue, 12 Apr 2022 00:02:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CCCFDB81B4E;
        Tue, 12 Apr 2022 07:02:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A54EC385A6;
        Tue, 12 Apr 2022 07:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746921;
        bh=6uhKsBVK/85T0zV+8oTAuD9p40iNznVFuvXgxUB+jLs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BE6xPM2uV9rC3yDbFBhQd8Jf4DZ1lrrCLi8sQGbYF5rZrb+Qcdfc73g5pykRNjvm6
         sm0m3NPPnwS9UgiLt6fsN4jBL/WxMwhl7XUp9l/u7vnkWSmaFTuf8v0PsvYaKyskrE
         RdfFnOAdgJI2GGNPYLatE2/2M9Gl8wzipC9EQMXQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 178/285] sfc: Do not free an empty page_ring
Date:   Tue, 12 Apr 2022 08:30:35 +0200
Message-Id: <20220412062948.804765167@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
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

From: Martin Habets <habetsm.xilinx@gmail.com>

[ Upstream commit 458f5d92df4807e2a7c803ed928369129996bf96 ]

When the page_ring is not used page_ptr_mask is 0.
Do not dereference page_ring[0] in this case.

Fixes: 2768935a4660 ("sfc: reuse pages to avoid DMA mapping/unmapping costs")
Reported-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/rx_common.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/sfc/rx_common.c b/drivers/net/ethernet/sfc/rx_common.c
index 633ca77a26fd..b925de9b4302 100644
--- a/drivers/net/ethernet/sfc/rx_common.c
+++ b/drivers/net/ethernet/sfc/rx_common.c
@@ -166,6 +166,9 @@ static void efx_fini_rx_recycle_ring(struct efx_rx_queue *rx_queue)
 	struct efx_nic *efx = rx_queue->efx;
 	int i;
 
+	if (unlikely(!rx_queue->page_ring))
+		return;
+
 	/* Unmap and release the pages in the recycle ring. Remove the ring. */
 	for (i = 0; i <= rx_queue->page_ptr_mask; i++) {
 		struct page *page = rx_queue->page_ring[i];
-- 
2.35.1



