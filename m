Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0270D41745C
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345991AbhIXNFG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:05:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:57332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346229AbhIXNDN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:03:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5185D613E8;
        Fri, 24 Sep 2021 12:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488100;
        bh=ztyZNbZOV7a4EjyoOiFCn8eUzuDvK9xolYB4ExY21P4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rtzlwCs/lQRK5wdtfKeo8U3Zk1n5OoqzPMBy3c6KCFxNwrVmaWb+piJ/xeSI4AEMs
         Xt6k8UkZFORJUYpJJGvM11aZPboc6aUjIu2/pjbB2UI7QCI2wxWXDHK8P92PNsQQD7
         6i8cKtgwG8p3k4BSqE2rQy7h0umtweJqP/E4w7Mg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yuri Nudelman <ynudelman@habana.ai>,
        Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 085/100] habanalabs: fix mmu node address resolution in debugfs
Date:   Fri, 24 Sep 2021 14:44:34 +0200
Message-Id: <20210924124344.318323110@linuxfoundation.org>
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
2.33.0



