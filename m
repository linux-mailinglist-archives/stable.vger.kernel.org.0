Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CACF44173F8
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345420AbhIXNBV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:01:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:57332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345304AbhIXM7U (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:59:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 092A6613CD;
        Fri, 24 Sep 2021 12:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488000;
        bh=rpNRGVigFN3f4Bpb1M9tyiVKZ4yIse1JFWgkBeeFs7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Q6i5rGD0VhthYcWKZzSZOqHoGS/WlSYkD4AY8u4fVZxBIPw36vPdc4T+pykwjrc4
         Xrox6gWWjqCAtFcoZ9rZzmlvWHO/GWdS6HENjg9jb4I5O9pIuY7/fU2b5Tn30BuSrQ
         ePemFBcnERwNeEu1GMjZTR7OB3YQ+N+Z6ONgNwyI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 045/100] dma-buf: DMABUF_DEBUG should depend on DMA_SHARED_BUFFER
Date:   Fri, 24 Sep 2021 14:43:54 +0200
Message-Id: <20210924124342.959729678@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit cca62758ebdd71fcfb6d589d6487a7f26398d50d ]

DMA-BUF debug checks are an option of DMA-BUF.  Enabling DMABUF_DEBUG
without DMA_SHARED_BUFFER does not have any impact, as drivers/dma-buf/
is not entered during the build when DMA_SHARED_BUFFER is disabled.

Fixes: 84335675f2223cbd ("dma-buf: Add debug option")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20210902124913.2698760-3-geert@linux-m68k.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma-buf/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma-buf/Kconfig b/drivers/dma-buf/Kconfig
index 6e13cc941cd2..6eb4d13f426e 100644
--- a/drivers/dma-buf/Kconfig
+++ b/drivers/dma-buf/Kconfig
@@ -53,6 +53,7 @@ config DMABUF_MOVE_NOTIFY
 
 config DMABUF_DEBUG
 	bool "DMA-BUF debug checks"
+	depends on DMA_SHARED_BUFFER
 	default y if DMA_API_DEBUG
 	help
 	  This option enables additional checks for DMA-BUF importers and
-- 
2.33.0



