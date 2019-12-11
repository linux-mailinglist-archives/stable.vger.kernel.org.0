Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FBFB11B11C
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733129AbfLKP2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:28:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:35062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387709AbfLKP2p (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:28:45 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E43352467D;
        Wed, 11 Dec 2019 15:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576078124;
        bh=IveGYPqIBGxxO9HI6PWVQ5k5rY4SGIjnoNOe06r8UVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T0JpO51Q/RcS5akT7kdo3pbya0q1kMqNDus9XMwLPzaOOHwDJcVe7GeNFPctjw4a9
         jvDpHhcW8g64RmbLXSz7ibWjOryF2kO/5FPYWqFdsoZjN+sSLZcC75OXCUERKUXERD
         BklBP5XygVn+0sP6vm17ururQoZrVlv0PrMkBnX0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Corentin Labbe <clabbe@baylibre.com>,
        Christoph Hellwig <hch@lst.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 12/58] dma-debug: add a schedule point in debug_dma_dump_mappings()
Date:   Wed, 11 Dec 2019 10:27:45 -0500
Message-Id: <20191211152831.23507-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211152831.23507-1-sashal@kernel.org>
References: <20191211152831.23507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 9ff6aa027dbb98755f0265695354f2dd07c0d1ce ]

debug_dma_dump_mappings() can take a lot of cpu cycles :

lpk43:/# time wc -l /sys/kernel/debug/dma-api/dump
163435 /sys/kernel/debug/dma-api/dump

real	0m0.463s
user	0m0.003s
sys	0m0.459s

Let's add a cond_resched() to avoid holding cpu for too long.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Corentin Labbe <clabbe@baylibre.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/dma-debug.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index ea4cc3dde4f1b..61e7240947f54 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -437,6 +437,7 @@ void debug_dma_dump_mappings(struct device *dev)
 		}
 
 		spin_unlock_irqrestore(&bucket->lock, flags);
+		cond_resched();
 	}
 }
 EXPORT_SYMBOL(debug_dma_dump_mappings);
-- 
2.20.1

