Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6343812EEC2
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:41:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731104AbgABWlJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:41:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:50274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730932AbgABWhf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:37:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB1CE20863;
        Thu,  2 Jan 2020 22:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578004655;
        bh=K7SE10bigZvxGl43MedsdOZk/x9XA9Zvd33+Z36It54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2J4sjLkAvZAoivMjO+UB/3aSuwitkPwP5iQk1uGq/Pe2jkov0VnNGReOYldKPnAvL
         v5o1Uy3MeMkQP9l/J0W8boSk0lhoOI5EuSVUeQG1dTRoeA8u5mfiClrmTFg5jxIZLz
         zSk9wL8YwhqvhpXu/4ywaPG/hQ3nYrXG7vHE7Yvs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Corentin Labbe <clabbe@baylibre.com>,
        Christoph Hellwig <hch@lst.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 098/137] dma-debug: add a schedule point in debug_dma_dump_mappings()
Date:   Thu,  2 Jan 2020 23:07:51 +0100
Message-Id: <20200102220600.245410965@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220546.618583146@linuxfoundation.org>
References: <20200102220546.618583146@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 51a76af25c66..173013f5e41b 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -427,6 +427,7 @@ void debug_dma_dump_mappings(struct device *dev)
 		}
 
 		spin_unlock_irqrestore(&bucket->lock, flags);
+		cond_resched();
 	}
 }
 EXPORT_SYMBOL(debug_dma_dump_mappings);
-- 
2.20.1



