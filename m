Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E679F1F2BF3
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728483AbgFIATL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:19:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:40504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729585AbgFHXSU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:18:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2F8920842;
        Mon,  8 Jun 2020 23:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658300;
        bh=KlyNs6xYV4r0qSVA/sqnvpMD4awrGAD7Rgv1smJS0j4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2l1XS6hVHaxBPFOoRlDPhywu+zENAFc5rFhR/AvEYLUtrj8NSNXbDrCuqN1l1qJZZ
         L/8T+99o5WCpLuyjfwJvlh95izr8cmFOF4F6kwp2SFqX4DV8FGSHmdsXgHdH6Td6eB
         5yL+WmiVbIJerilmxqzj8EKFo85djExn9sg+tTTA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dennis YC Hsieh <dennis-yc.hsieh@mediatek.com>,
        CK Hu <ck.hu@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.6 303/606] soc: mediatek: cmdq: return send msg error code
Date:   Mon,  8 Jun 2020 19:07:08 -0400
Message-Id: <20200608231211.3363633-303-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index db37144ae98c..87ee9f767b7a 100644
--- a/drivers/soc/mediatek/mtk-cmdq-helper.c
+++ b/drivers/soc/mediatek/mtk-cmdq-helper.c
@@ -351,7 +351,9 @@ int cmdq_pkt_flush_async(struct cmdq_pkt *pkt, cmdq_async_flush_cb cb,
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

