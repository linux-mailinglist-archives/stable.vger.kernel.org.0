Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CBD710C5BC
	for <lists+stable@lfdr.de>; Thu, 28 Nov 2019 10:14:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbfK1JOl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Nov 2019 04:14:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:55366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbfK1JOl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 Nov 2019 04:14:41 -0500
Received: from ziggy.de (unknown [95.169.224.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4EA121741;
        Thu, 28 Nov 2019 09:14:39 +0000 (UTC)
From:   Matthias Brugger <matthias.bgg@gmail.com>
To:     mbrugger@suse.com
Cc:     Bibby Hsieh <bibby.hsieh@mediatek.com>, stable@vger.kernel.org,
        CK Hu <ck.hu@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: [PATCH] soc: mediatek: cmdq: fixup wrong input order of write api
Date:   Thu, 28 Nov 2019 10:14:36 +0100
Message-Id: <20191128091436.5805-1-matthias.bgg@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bibby Hsieh <bibby.hsieh@mediatek.com>

Fixup a issue was caused by the previous fixup patch.

Fixes: 1a92f989126e ("soc: mediatek: cmdq: reorder the parameter")

Cc: <stable@vger.kernel.org>
Signed-off-by: Bibby Hsieh <bibby.hsieh@mediatek.com>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
---
 drivers/soc/mediatek/mtk-cmdq-helper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/mediatek/mtk-cmdq-helper.c b/drivers/soc/mediatek/mtk-cmdq-helper.c
index 7aa0517ff2f3..3c82de5f9417 100644
--- a/drivers/soc/mediatek/mtk-cmdq-helper.c
+++ b/drivers/soc/mediatek/mtk-cmdq-helper.c
@@ -155,7 +155,7 @@ int cmdq_pkt_write_mask(struct cmdq_pkt *pkt, u8 subsys,
 		err = cmdq_pkt_append_command(pkt, CMDQ_CODE_MASK, 0, ~mask);
 		offset_mask |= CMDQ_WRITE_ENABLE_MASK;
 	}
-	err |= cmdq_pkt_write(pkt, value, subsys, offset_mask);
+	err |= cmdq_pkt_write(pkt, subsys, offset_mask, value);
 
 	return err;
 }
-- 
2.24.0

