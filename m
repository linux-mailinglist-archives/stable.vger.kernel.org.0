Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2E04A439B
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:22:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376869AbiAaLWH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:22:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378549AbiAaLUV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:20:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37B75C0604D6;
        Mon, 31 Jan 2022 03:12:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CAECD60ED0;
        Mon, 31 Jan 2022 11:12:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95FA8C340E8;
        Mon, 31 Jan 2022 11:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627559;
        bh=KdRHcHHtBNtTHvxsQm/KjAEIXD/uEpMZHgfXut/QXvw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MgPOXam37npqd9bwZDeA8hPsNGhW7f7DVLW8bkodpxpTZDG/rrcvGzU/Fhc6ahelQ
         voetgO0fTyoJ0R8rvY6YMq2wvkFCmKdOANc5XdKRj85tARBLx2+9SE+xDf1DO8cC41
         yme04r8LmvavKH7Q7Am2LG5nctptBakgfnS8GeSE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 123/171] octeontx2-pf: cn10k: Ensure valid pointers are freed to aura
Date:   Mon, 31 Jan 2022 11:56:28 +0100
Message-Id: <20220131105234.195446079@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geetha sowjanya <gakula@marvell.com>

[ Upstream commit c5d731c54a17677939bd59ee8be4ed74d7485ba4 ]

While freeing SQB pointers to aura, driver first memcpy to
target address and then triggers lmtst operation to free pointer
to the aura. We need to ensure(by adding dmb barrier)that memcpy
is finished before pointers are freed to the aura. This patch also
adds the missing sq context structure entry in debugfs.

Fixes: ef6c8da71eaf ("octeontx2-pf: cn10K: Reserve LMTST lines per core")
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c  | 2 ++
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index 49d822a98adab..f001579569a2b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -1131,6 +1131,8 @@ static void print_nix_cn10k_sq_ctx(struct seq_file *m,
 	seq_printf(m, "W3: head_offset\t\t\t%d\nW3: smenq_next_sqb_vld\t\t%d\n\n",
 		   sq_ctx->head_offset, sq_ctx->smenq_next_sqb_vld);
 
+	seq_printf(m, "W3: smq_next_sq_vld\t\t%d\nW3: smq_pend\t\t\t%d\n",
+		   sq_ctx->smq_next_sq_vld, sq_ctx->smq_pend);
 	seq_printf(m, "W4: next_sqb \t\t\t%llx\n\n", sq_ctx->next_sqb);
 	seq_printf(m, "W5: tail_sqb \t\t\t%llx\n\n", sq_ctx->tail_sqb);
 	seq_printf(m, "W6: smenq_sqb \t\t\t%llx\n\n", sq_ctx->smenq_sqb);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index a51ecd771d075..637450de189c8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -591,6 +591,7 @@ static inline void __cn10k_aura_freeptr(struct otx2_nic *pfvf, u64 aura,
 			size++;
 		tar_addr |=  ((size - 1) & 0x7) << 4;
 	}
+	dma_wmb();
 	memcpy((u64 *)lmt_info->lmt_addr, ptrs, sizeof(u64) * num_ptrs);
 	/* Perform LMTST flush */
 	cn10k_lmt_flush(val, tar_addr);
-- 
2.34.1



