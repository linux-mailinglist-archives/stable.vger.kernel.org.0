Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83EAC6D4AA4
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234174AbjDCOtM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:49:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233987AbjDCOs5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:48:57 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD5429BE0
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:47:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D5D65CE130B
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:47:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E02DBC433D2;
        Mon,  3 Apr 2023 14:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680533258;
        bh=DZZZor3KGACAE+vuWBdaPZmKFCVu59LfVL0jJ+4tQbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KfNOway2G3ePA/NZawwLnOlzpm3vXmos/3d0Y6WLrJPGdwJ10oTikT92CQeSb2NPQ
         sz/tmjDDB09QHHuqcAbHvGaO8WZIFcobTVTmJl3gRh3XSw2qJiDFwDMB9gP6XX7ilh
         WVIOYrw9DXvzMBduS8yKRQdaJ0Fo+XHPjZxdPNSE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Bjorn Andersson <quic_bjorande@quicinc.com>,
        Mark Bloch <mbloch@nvidia.com>, Alex Elder <elder@linaro.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 113/187] net: ipa: compute DMA pool size properly
Date:   Mon,  3 Apr 2023 16:09:18 +0200
Message-Id: <20230403140419.688734351@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Elder <elder@linaro.org>

[ Upstream commit 6c75dc94f2b27fff57b305af9236eea181a00b6c ]

In gsi_trans_pool_init_dma(), the total size of a pool of memory
used for DMA transactions is calculated.  However the calculation is
done incorrectly.

For 4KB pages, this total size is currently always more than one
page, and as a result, the calculation produces a positive (though
incorrect) total size.  The code still works in this case; we just
end up with fewer DMA pool entries than we intended.

Bjorn Andersson tested booting a kernel with 16KB pages, and hit a
null pointer derereference in sg_alloc_append_table_from_pages(),
descending from gsi_trans_pool_init_dma().  The cause of this was
that a 16KB total size was going to be allocated, and with 16KB
pages the order of that allocation is 0.  The total_size calculation
yielded 0, which eventually led to the crash.

Correcting the total_size calculation fixes the problem.

Reported-by: Bjorn Andersson <quic_bjorande@quicinc.com>
Tested-by: Bjorn Andersson <quic_bjorande@quicinc.com>
Fixes: 9dd441e4ed57 ("soc: qcom: ipa: GSI transactions")
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Alex Elder <elder@linaro.org>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Link: https://lore.kernel.org/r/20230328162751.2861791-1-elder@linaro.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/gsi_trans.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ipa/gsi_trans.c b/drivers/net/ipa/gsi_trans.c
index 0f52c068c46d6..ee6fb00b71eb6 100644
--- a/drivers/net/ipa/gsi_trans.c
+++ b/drivers/net/ipa/gsi_trans.c
@@ -156,7 +156,7 @@ int gsi_trans_pool_init_dma(struct device *dev, struct gsi_trans_pool *pool,
 	 * gsi_trans_pool_exit_dma() can assume the total allocated
 	 * size is exactly (count * size).
 	 */
-	total_size = get_order(total_size) << PAGE_SHIFT;
+	total_size = PAGE_SIZE << get_order(total_size);
 
 	virt = dma_alloc_coherent(dev, total_size, &addr, GFP_KERNEL);
 	if (!virt)
-- 
2.39.2



