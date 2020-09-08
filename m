Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8046D261D36
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731866AbgIHTdb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:33:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:48730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731005AbgIHP6F (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 11:58:05 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0D9B22460;
        Tue,  8 Sep 2020 15:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579372;
        bh=NSBuye3y5qXgCTXV6CZRQCd0s3rA8j6SnAcyR7nKAY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lKMz0qvjbsaOKmCjxovccsX9kOQG/67l9Z/Aoh6grgYEZVrygHdzQZDEQiSNSP1ij
         MTWbl50rJUz9NaRlVOsshbTB4q/kbEQTZyzTlqbTtck0FtqZgWhZ1LF5PWu2nR8bkQ
         D7bskpo235w2uASLBhd7lm6Ke8o0Q+eVJxjiq6V8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 043/186] dmaengine: at_hdmac: check return value of of_find_device_by_node() in at_dma_xlate()
Date:   Tue,  8 Sep 2020 17:23:05 +0200
Message-Id: <20200908152243.754111179@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 0cef8e2c5a07d482ec907249dbd6687e8697677f ]

The reurn value of of_find_device_by_node() is not checked, thus null
pointer dereference will be triggered if of_find_device_by_node()
failed.

Fixes: bbe89c8e3d59 ("at_hdmac: move to generic DMA binding")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20200817115728.1706719-2-yukuai3@huawei.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/at_hdmac.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 73a20780744bf..22c1c507055a3 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -1650,6 +1650,8 @@ static struct dma_chan *at_dma_xlate(struct of_phandle_args *dma_spec,
 		return NULL;
 
 	dmac_pdev = of_find_device_by_node(dma_spec->np);
+	if (!dmac_pdev)
+		return NULL;
 
 	dma_cap_zero(mask);
 	dma_cap_set(DMA_SLAVE, mask);
-- 
2.25.1



