Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD44450892
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730091AbfFXKPx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:15:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:53298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730025AbfFXKPw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:15:52 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1172B20645;
        Mon, 24 Jun 2019 10:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561371352;
        bh=iX2Cvxv91ZoHMIbqMcsmuPSIR3ZlwV71LpYzXjuL+B0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jCA7SiNPp/vsvvBstvbj3qe4Fkfk89um9DEKxedDdTfTAMf31SGNnOZg/wB69s7FS
         pfP+CrHW5/lpH25bsduFNU99HasiKU0he7Um2YRRGqZ66J80PF9iKqtdjbvHhT3AUo
         ailpaR7q4x6bkO2zqFhxxJ2JsplSb2sa1J0+Zkos=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Baolin Wang <baolin.wang@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 036/121] dmaengine: sprd: Fix the possible crash when getting descriptor status
Date:   Mon, 24 Jun 2019 17:56:08 +0800
Message-Id: <20190624092322.661887903@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092320.652599624@linuxfoundation.org>
References: <20190624092320.652599624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 16d0f85e45b99411ac10cb12cdd9279204a72381 ]

We will get a NULL virtual descriptor by vchan_find_desc() when the descriptor
has been submitted, that will crash the kernel when getting the descriptor
status.

In this case, since the descriptor has been submitted to process, but it
is not completed now, which means the descriptor is listed into the
'vc->desc_submitted' list now. So we can not get current processing descriptor
by vchan_find_desc(), but the pointer 'schan->cur_desc' will point to the
current processing descriptor, then we can use 'schan->cur_desc' to get
current processing descriptor's status to avoid this issue.

Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/sprd-dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/sprd-dma.c b/drivers/dma/sprd-dma.c
index 48431e2da987..e29342ab85f6 100644
--- a/drivers/dma/sprd-dma.c
+++ b/drivers/dma/sprd-dma.c
@@ -625,7 +625,7 @@ static enum dma_status sprd_dma_tx_status(struct dma_chan *chan,
 		else
 			pos = 0;
 	} else if (schan->cur_desc && schan->cur_desc->vd.tx.cookie == cookie) {
-		struct sprd_dma_desc *sdesc = to_sprd_dma_desc(vd);
+		struct sprd_dma_desc *sdesc = schan->cur_desc;
 
 		if (sdesc->dir == DMA_DEV_TO_MEM)
 			pos = sprd_dma_get_dst_addr(schan);
-- 
2.20.1



