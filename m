Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6ABE4507BB
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729828AbfFXKJb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:09:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:42616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730501AbfFXKIo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:08:44 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2187205C9;
        Mon, 24 Jun 2019 10:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370924;
        bh=JsOn5zvNdjseQUSp5vTdE8wd2jG/9/FXfBMmaHfHcIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zakNhxFgMQjxw4GoIBEXMhwEt3CR+i/hjHERZSohtLpAgOgYPgeo1PZEYNjJUHMmO
         BVJ+JvuA+bWB9bkyrwnIo9JyDOxIfmKOFy8WjzU8clHhKDCT1v7oJ2m7WaJEPObImo
         fjZOUhB1D2EBztHk5AeDN3wA3/sngVvnTHj/7e28=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 034/121] dmaengine: dw-axi-dmac: fix null dereference when pointer first is null
Date:   Mon, 24 Jun 2019 17:56:06 +0800
Message-Id: <20190624092322.564239225@linuxfoundation.org>
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

[ Upstream commit 0788611c9a0925c607de536b2449de5ed98ef8df ]

In the unlikely event that axi_desc_get returns a null desc in the
very first iteration of the while-loop the error exit path ends
up calling axi_desc_put on a null pointer 'first' and this causes
a null pointer dereference.  Fix this by adding a null check on
pointer 'first' before calling axi_desc_put.

Addresses-Coverity: ("Explicit null dereference")
Fixes: 1fe20f1b8454 ("dmaengine: Introduce DW AXI DMAC driver")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
index b2ac1d2c5b86..a1ce307c502f 100644
--- a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
+++ b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
@@ -512,7 +512,8 @@ dma_chan_prep_dma_memcpy(struct dma_chan *dchan, dma_addr_t dst_adr,
 	return vchan_tx_prep(&chan->vc, &first->vd, flags);
 
 err_desc_get:
-	axi_desc_put(first);
+	if (first)
+		axi_desc_put(first);
 	return NULL;
 }
 
-- 
2.20.1



