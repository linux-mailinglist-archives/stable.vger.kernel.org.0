Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C69FA40EF62
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 04:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242980AbhIQCfc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 22:35:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:32802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242912AbhIQCf2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 22:35:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CEDB461164;
        Fri, 17 Sep 2021 02:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631846046;
        bh=DSwoeb78C09D60/JqXFNRUZ1AyEgpA5tJAO6kXTO5MA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qdv8zj3YhjLtA5LZZ7D3BGqPBRDtXVS7tpEI6sVZ54+YfeRBU2EfXdPYJJuvZC5wg
         yP14YgfmOhPTCXnQ2AlZE2OHcdoHNg5G4+RzCpMxJargkAOzuPLqoLdC3csprPyJZ/
         z3Nt0m94HdMx8VXy6OJp7ZtdJYXyuSxy+uiWhA3vyavV70BqD3AEkIgbfslMc+pzXg
         GDumfi6lXBCjnqfBvEI5DNsZCaG66nRwKIGpZ+D7NE4m1hhr0SzIy5fJbT84NnQyWk
         h6NJ+YA7hs0qMnHq+SQtdii7FMa1NZLiovRLKPvkNd1qCh2LdWRC6g4QDKV0GTiPhN
         xFwCdyOuzJ13Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yuri Nudelman <ynudelman@habana.ai>,
        Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>, Arnd@vger.kernel.org,
        gregkh@linuxfoundation.org, ttayar@habana.ai, mhaimovski@habana.ai,
        obitton@habana.ai
Subject: [PATCH AUTOSEL 5.14 08/21] habanalabs: fix mmu node address resolution in debugfs
Date:   Thu, 16 Sep 2021 22:33:02 -0400
Message-Id: <20210917023315.816225-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210917023315.816225-1-sashal@kernel.org>
References: <20210917023315.816225-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuri Nudelman <ynudelman@habana.ai>

[ Upstream commit 09ae43043c748423a5dcdc7bb1e63e4dcabe9bd6 ]

The address resolution via debugfs was not taking into consideration the
page offset, resulting in a wrong address.

Signed-off-by: Yuri Nudelman <ynudelman@habana.ai>
Reviewed-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/common/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/habanalabs/common/debugfs.c b/drivers/misc/habanalabs/common/debugfs.c
index 703d79fb6f3f..379529bffc70 100644
--- a/drivers/misc/habanalabs/common/debugfs.c
+++ b/drivers/misc/habanalabs/common/debugfs.c
@@ -349,7 +349,7 @@ static int mmu_show(struct seq_file *s, void *data)
 		return 0;
 	}
 
-	phys_addr = hops_info.hop_info[hops_info.used_hops - 1].hop_pte_val;
+	hl_mmu_va_to_pa(ctx, virt_addr, &phys_addr);
 
 	if (hops_info.scrambled_vaddr &&
 		(dev_entry->mmu_addr != hops_info.scrambled_vaddr))
-- 
2.30.2

