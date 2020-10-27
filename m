Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94D8B29BEB0
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1813757AbgJ0Qya (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:54:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:47896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1794456AbgJ0PLz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:11:55 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54DFD21D41;
        Tue, 27 Oct 2020 15:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811514;
        bh=MGUjrEt6VRiyl5xh57Zht9CI7leQYXMlkQNCM3e6U30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wbhgXTIPDWnfnjfMPYNp1+V1Ht+PcOljgs8VVEsGOc/bf/kcqrHOw68BiZzCG1Gb9
         kYTsDEr3ct4eECmYdw81xwJBvtHzSRZ2xjTZ28s3ZzPqaIb9NHt+Lht7czbsf5BZMf
         Z1//8Gc+Zth9+kLmXMi4+71hEwY0v6d8/nKHIinE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dennis YC Hsieh <dennis-yc.hsieh@mediatek.com>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 513/633] soc: mediatek: cmdq: add clear option in cmdq_pkt_wfe api
Date:   Tue, 27 Oct 2020 14:54:16 +0100
Message-Id: <20201027135546.813580503@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dennis YC Hsieh <dennis-yc.hsieh@mediatek.com>

[ Upstream commit 23c22299cd290409c6b78f57c42b64f8dfb6dd92 ]

Add clear parameter to let client decide if
event should be clear to 0 after GCE receive it.

Signed-off-by: Dennis YC Hsieh <dennis-yc.hsieh@mediatek.com>
Acked-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Link: https://lore.kernel.org/r/1594136714-11650-9-git-send-email-dennis-yc.hsieh@mediatek.com
[mb: fix commit message]
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_crtc.c  | 2 +-
 drivers/soc/mediatek/mtk-cmdq-helper.c   | 5 +++--
 include/linux/mailbox/mtk-cmdq-mailbox.h | 3 +--
 include/linux/soc/mediatek/mtk-cmdq.h    | 5 +++--
 4 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_drm_crtc.c b/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
index d8b43500f12d1..f64c83dc6644e 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
@@ -485,7 +485,7 @@ static void mtk_drm_crtc_hw_config(struct mtk_drm_crtc *mtk_crtc)
 		mbox_flush(mtk_crtc->cmdq_client->chan, 2000);
 		cmdq_handle = cmdq_pkt_create(mtk_crtc->cmdq_client, PAGE_SIZE);
 		cmdq_pkt_clear_event(cmdq_handle, mtk_crtc->cmdq_event);
-		cmdq_pkt_wfe(cmdq_handle, mtk_crtc->cmdq_event);
+		cmdq_pkt_wfe(cmdq_handle, mtk_crtc->cmdq_event, true);
 		mtk_crtc_ddp_config(crtc, cmdq_handle);
 		cmdq_pkt_flush_async(cmdq_handle, ddp_cmdq_cb, cmdq_handle);
 	}
diff --git a/drivers/soc/mediatek/mtk-cmdq-helper.c b/drivers/soc/mediatek/mtk-cmdq-helper.c
index 87ee9f767b7af..d8ace96832bac 100644
--- a/drivers/soc/mediatek/mtk-cmdq-helper.c
+++ b/drivers/soc/mediatek/mtk-cmdq-helper.c
@@ -213,15 +213,16 @@ int cmdq_pkt_write_mask(struct cmdq_pkt *pkt, u8 subsys,
 }
 EXPORT_SYMBOL(cmdq_pkt_write_mask);
 
-int cmdq_pkt_wfe(struct cmdq_pkt *pkt, u16 event)
+int cmdq_pkt_wfe(struct cmdq_pkt *pkt, u16 event, bool clear)
 {
 	struct cmdq_instruction inst = { {0} };
+	u32 clear_option = clear ? CMDQ_WFE_UPDATE : 0;
 
 	if (event >= CMDQ_MAX_EVENT)
 		return -EINVAL;
 
 	inst.op = CMDQ_CODE_WFE;
-	inst.value = CMDQ_WFE_OPTION;
+	inst.value = CMDQ_WFE_OPTION | clear_option;
 	inst.event = event;
 
 	return cmdq_pkt_append_command(pkt, inst);
diff --git a/include/linux/mailbox/mtk-cmdq-mailbox.h b/include/linux/mailbox/mtk-cmdq-mailbox.h
index a4dc45fbec0a4..23bc366f6c3b3 100644
--- a/include/linux/mailbox/mtk-cmdq-mailbox.h
+++ b/include/linux/mailbox/mtk-cmdq-mailbox.h
@@ -27,8 +27,7 @@
  * bit 16-27: update value
  * bit 31: 1 - update, 0 - no update
  */
-#define CMDQ_WFE_OPTION			(CMDQ_WFE_UPDATE | CMDQ_WFE_WAIT | \
-					CMDQ_WFE_WAIT_VALUE)
+#define CMDQ_WFE_OPTION			(CMDQ_WFE_WAIT | CMDQ_WFE_WAIT_VALUE)
 
 /** cmdq event maximum */
 #define CMDQ_MAX_EVENT			0x3ff
diff --git a/include/linux/soc/mediatek/mtk-cmdq.h b/include/linux/soc/mediatek/mtk-cmdq.h
index a74c1d5acdf3c..cb71dca985589 100644
--- a/include/linux/soc/mediatek/mtk-cmdq.h
+++ b/include/linux/soc/mediatek/mtk-cmdq.h
@@ -105,11 +105,12 @@ int cmdq_pkt_write_mask(struct cmdq_pkt *pkt, u8 subsys,
 /**
  * cmdq_pkt_wfe() - append wait for event command to the CMDQ packet
  * @pkt:	the CMDQ packet
- * @event:	the desired event type to "wait and CLEAR"
+ * @event:	the desired event type to wait
+ * @clear:	clear event or not after event arrive
  *
  * Return: 0 for success; else the error code is returned
  */
-int cmdq_pkt_wfe(struct cmdq_pkt *pkt, u16 event);
+int cmdq_pkt_wfe(struct cmdq_pkt *pkt, u16 event, bool clear);
 
 /**
  * cmdq_pkt_clear_event() - append clear event command to the CMDQ packet
-- 
2.25.1



