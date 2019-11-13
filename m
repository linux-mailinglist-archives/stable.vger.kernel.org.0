Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73749FA333
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:08:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730368AbfKMB74 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:59:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:54802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730365AbfKMB7z (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:59:55 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98CB122469;
        Wed, 13 Nov 2019 01:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610395;
        bh=DFdAjxDKTWhb2noNLW6GfraKQGL6VTYbRx3/xkS64kQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J2PtGuXyHcJb6s/8rzEfqwt48loLHHZm0HtfES1bgFS16/T3Zo4pSx+3Q0CFsaygC
         5XB2LnEjUKCPJypkV6oTtNsSqmF8MTjn/Vbyw5rakMyiMnbctrCn5ohHW8aR0BP+sB
         Lf1AvXAjlE7Uu2sdkgkKBVr+73M/jcIq5EX4YNas=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 4.9 14/68] dmaengine: ep93xx: Return proper enum in ep93xx_dma_chan_direction
Date:   Tue, 12 Nov 2019 20:58:38 -0500
Message-Id: <20191113015932.12655-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015932.12655-1-sashal@kernel.org>
References: <20191113015932.12655-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit 9524d6b265f9b2b9a61fceb2ee2ce1c2a83e39ca ]

Clang warns when implicitly converting from one enumerated type to
another. Avoid this by using the equivalent value from the expected
type.

In file included from drivers/dma/ep93xx_dma.c:30:
./include/linux/platform_data/dma-ep93xx.h:88:10: warning: implicit
conversion from enumeration type 'enum dma_data_direction' to different
enumeration type 'enum dma_transfer_direction' [-Wenum-conversion]
                return DMA_NONE;
                ~~~~~~ ^~~~~~~~
1 warning generated.

Reported-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/platform_data/dma-ep93xx.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/platform_data/dma-ep93xx.h b/include/linux/platform_data/dma-ep93xx.h
index e82c642fa53cd..5913be0793a26 100644
--- a/include/linux/platform_data/dma-ep93xx.h
+++ b/include/linux/platform_data/dma-ep93xx.h
@@ -84,7 +84,7 @@ static inline enum dma_transfer_direction
 ep93xx_dma_chan_direction(struct dma_chan *chan)
 {
 	if (!ep93xx_dma_chan_is_m2p(chan))
-		return DMA_NONE;
+		return DMA_TRANS_NONE;
 
 	/* even channels are for TX, odd for RX */
 	return (chan->chan_id % 2 == 0) ? DMA_MEM_TO_DEV : DMA_DEV_TO_MEM;
-- 
2.20.1

