Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7142238303E
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237679AbhEQOZW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:25:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:37626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239321AbhEQOXS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:23:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CA4661456;
        Mon, 17 May 2021 14:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260743;
        bh=vtm7F/6tXDBNDtMofCJDG2fGHndGHXEprEjcQpcyU6E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Py4qOgP2y6VUHtHy/LJQzLWBl05GpV3qFuda1+M5sMJjvZJWM+aDFEStoq6f7dNFq
         RIZFhlJfAvpJoFRgtvbkU/uO3qoCiaNvvpB+xnf9V6jfP/Iu82x2sPT+LaicJIem2Q
         O/vFaWACjWs9ZWWhOAdw106EysNIdWiZ285l0cQc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Claire Chang <tientzu@chromium.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 185/363] swiotlb: Fix the type of index
Date:   Mon, 17 May 2021 16:00:51 +0200
Message-Id: <20210517140308.842374980@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claire Chang <tientzu@chromium.org>

[ Upstream commit 95b079d8215b83b37fa59341fda92fcb9392f14a ]

Fix the type of index from unsigned int to int since find_slots() might
return -1.

Fixes: 26a7e094783d ("swiotlb: refactor swiotlb_tbl_map_single")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Claire Chang <tientzu@chromium.org>
Signed-off-by: Konrad Rzeszutek Wilk <konrad@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/swiotlb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index c10e855a03bc..fe4c01c14ab2 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -608,7 +608,8 @@ phys_addr_t swiotlb_tbl_map_single(struct device *dev, phys_addr_t orig_addr,
 		enum dma_data_direction dir, unsigned long attrs)
 {
 	unsigned int offset = swiotlb_align_offset(dev, orig_addr);
-	unsigned int index, i;
+	unsigned int i;
+	int index;
 	phys_addr_t tlb_addr;
 
 	if (no_iotlb_memory)
-- 
2.30.2



