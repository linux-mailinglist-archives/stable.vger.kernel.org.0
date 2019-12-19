Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C318126CBA
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:06:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728556AbfLSSox (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:44:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:37030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728740AbfLSSow (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:44:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D62A8206D7;
        Thu, 19 Dec 2019 18:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781092;
        bh=2G4P0JOS8f9qYCJslKvxhQlXUFeVrp1j1/nRykz2bEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F5+vw2w06EoaanUoFhb+bXzkbL0AQ/f8btjyNSyojZdg/9Q2Ff/QjfM662P4r8eVj
         7zKjBGRrul7uYq/4aLP6U7634pqOX6mDKcBgn94AsSRngvQJnTUXLIO1YUUJMXPJQB
         yMUk8943iUdwVd+B+SYIt02122Ha/HpbaazVBHxw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 042/199] dma-mapping: fix return type of dma_set_max_seg_size()
Date:   Thu, 19 Dec 2019 19:32:04 +0100
Message-Id: <20191219183217.267546126@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183214.629503389@linuxfoundation.org>
References: <20191219183214.629503389@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

[ Upstream commit c9d76d0655c06b8c1f944e46c4fd9e9cf4b331c0 ]

The function dma_set_max_seg_size() can return either 0 on success or
-EIO on error. Change its return type from unsigned int to int to
capture this.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/dma-mapping.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 704caae69c427..97f817f4eb784 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -618,8 +618,7 @@ static inline unsigned int dma_get_max_seg_size(struct device *dev)
 	return SZ_64K;
 }
 
-static inline unsigned int dma_set_max_seg_size(struct device *dev,
-						unsigned int size)
+static inline int dma_set_max_seg_size(struct device *dev, unsigned int size)
 {
 	if (dev->dma_parms) {
 		dev->dma_parms->max_segment_size = size;
-- 
2.20.1



