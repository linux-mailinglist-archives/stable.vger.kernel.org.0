Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12CE3419CC9
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238001AbhI0RcU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:32:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:43764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238740AbhI0RaL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:30:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3C95611BD;
        Mon, 27 Sep 2021 17:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632763094;
        bh=3Ik20HBUFhgSIeY8t5/CVBX/Rxlx/X7q+RZ4ZYkcYtY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vbWhyRS146hP/YusrLgA0O/LKQcA9dT0sRn2f4jqQ5tb+TWJGEAlCFy7Sczvl7BhL
         ts+nv2fc4rotJ/ht/twuCVzpWnPt7/4Peu5BvxkdVUn7Ane/9IZeZYaqyRUvbGyvEc
         epG93gxPQBTyvsr1RwO5dfDm2JGqHWloe5JD4Xmc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeremy Linton <jeremy.linton@arm.com>,
        Hamza Mahfooz <someguy@effective-light.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 123/162] dma-debug: prevent an error message from causing runtime problems
Date:   Mon, 27 Sep 2021 19:02:49 +0200
Message-Id: <20210927170237.697804704@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hamza Mahfooz <someguy@effective-light.com>

[ Upstream commit 510e1a724ab1bf38150be2c1acabb303f98d0047 ]

For some drivers, that use the DMA API. This error message can be reached
several millions of times per second, causing spam to the kernel's printk
buffer and bringing the CPU usage up to 100% (so, it should be rate
limited). However, since there is at least one driver that is in the
mainline and suffers from the error condition, it is more useful to
err_printk() here instead of just rate limiting the error message (in hopes
that it will make it easier for other drivers that suffer from this issue
to be spotted).

Link: https://lkml.kernel.org/r/fd67fbac-64bf-f0ea-01e1-5938ccfab9d0@arm.com
Reported-by: Jeremy Linton <jeremy.linton@arm.com>
Signed-off-by: Hamza Mahfooz <someguy@effective-light.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/debug.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/dma/debug.c b/kernel/dma/debug.c
index f2faa13534e5..70519f67556f 100644
--- a/kernel/dma/debug.c
+++ b/kernel/dma/debug.c
@@ -567,7 +567,8 @@ static void add_dma_entry(struct dma_debug_entry *entry)
 		pr_err("cacheline tracking ENOMEM, dma-debug disabled\n");
 		global_disable = true;
 	} else if (rc == -EEXIST) {
-		pr_err("cacheline tracking EEXIST, overlapping mappings aren't supported\n");
+		err_printk(entry->dev, entry,
+			"cacheline tracking EEXIST, overlapping mappings aren't supported\n");
 	}
 }
 
-- 
2.33.0



