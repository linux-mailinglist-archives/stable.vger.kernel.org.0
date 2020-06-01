Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9D21EAA87
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729577AbgFASIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:08:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:55106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730785AbgFASIv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:08:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 258AB2068D;
        Mon,  1 Jun 2020 18:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034930;
        bh=gM9YRzn3kuFgPVGpApvzadERLBeSrMqro91MQy0ovP8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PPdWigsVNB1gOQzXmk0yxrFbuC4fNV3KaNLbMQ/h7eJeZxFGFPfx1GZP3YFQH2SnF
         JE3wR6W90i/FVf4MHG7lJU7BheBgQTDaa5GS75X3O5f0cBZ99MrT65x42se4l5aXZe
         HBSYoKvX4EL3nt911NkgsrGFX0PuI/eZ6XeYumXI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dennis YC Hsieh <dennis-yc.hsieh@mediatek.com>,
        CK Hu <ck.hu@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 077/142] soc: mediatek: cmdq: return send msg error code
Date:   Mon,  1 Jun 2020 19:53:55 +0200
Message-Id: <20200601174046.007180577@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174037.904070960@linuxfoundation.org>
References: <20200601174037.904070960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dennis YC Hsieh <dennis-yc.hsieh@mediatek.com>

[ Upstream commit 34c4e4072603ff5c174df73b973896abb76cbb51 ]

Return error code to client if send message fail,
so that client has chance to error handling.

Fixes: 576f1b4bc802 ("soc: mediatek: Add Mediatek CMDQ helper")
Signed-off-by: Dennis YC Hsieh <dennis-yc.hsieh@mediatek.com>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Link: https://lore.kernel.org/r/1583664775-19382-6-git-send-email-dennis-yc.hsieh@mediatek.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/mediatek/mtk-cmdq-helper.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/mediatek/mtk-cmdq-helper.c b/drivers/soc/mediatek/mtk-cmdq-helper.c
index 73a852b2f417..34eec26b0c1f 100644
--- a/drivers/soc/mediatek/mtk-cmdq-helper.c
+++ b/drivers/soc/mediatek/mtk-cmdq-helper.c
@@ -258,7 +258,9 @@ int cmdq_pkt_flush_async(struct cmdq_pkt *pkt, cmdq_async_flush_cb cb,
 		spin_unlock_irqrestore(&client->lock, flags);
 	}
 
-	mbox_send_message(client->chan, pkt);
+	err = mbox_send_message(client->chan, pkt);
+	if (err < 0)
+		return err;
 	/* We can send next packet immediately, so just call txdone. */
 	mbox_client_txdone(client->chan, 0);
 
-- 
2.25.1



