Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CED34510F4
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238676AbhKOS44 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:56:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:54772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243058AbhKOSxo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:53:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 694AE633C2;
        Mon, 15 Nov 2021 18:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999830;
        bh=73VVUh2iN1iuRBzrcEG8w9ExRYK8I8jkI4ftxEIab00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kCAwCTR1+lHSmzupr7I7n5Ok4fkVUUUhr2gwZdyf3/0yddnpxn3ZJNJzgB0umAbNS
         FRYrWShkw9h1WVwIhxe5XhaxWFyD72VDl4A0GI3pq/k8CxGfH+lgMkwsePweL285Rq
         G/CfdbJlyR7+iIpgIIoLwmfAGdi5Rr+wDN5Wvo5w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "jason-jh.lin" <jason-jh.lin@mediatek.com>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 440/849] mailbox: Remove WARN_ON for async_cb.cb in cmdq_exec_done
Date:   Mon, 15 Nov 2021 17:58:43 +0100
Message-Id: <20211115165435.170008485@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: jason-jh.lin <jason-jh.lin@mediatek.com>

[ Upstream commit ce1537fe288469bf68ee0aabdb860a790b4755ef ]

Because mtk_drm_crtc_update_config is not using cmdq_pkt_flush_async,
it won't have pkt->async_cb.cb anymore.

So remove the WARN_ON check of pkt->async_cb.cb at cmdq_exec_done.

Fixes: 1b6b0ce2240e ("mailbox: mtk-cmdq: Use mailbox rx_callback")
Signed-off-by: jason-jh.lin <jason-jh.lin@mediatek.com>
Reviewed-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Tested-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mtk-cmdq-mailbox.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mailbox/mtk-cmdq-mailbox.c b/drivers/mailbox/mtk-cmdq-mailbox.c
index 4f907e8f3894b..5e2796db026d2 100644
--- a/drivers/mailbox/mtk-cmdq-mailbox.c
+++ b/drivers/mailbox/mtk-cmdq-mailbox.c
@@ -186,7 +186,6 @@ static void cmdq_task_exec_done(struct cmdq_task *task, int sta)
 	struct cmdq_task_cb *cb = &task->pkt->async_cb;
 	struct cmdq_cb_data data;
 
-	WARN_ON(cb->cb == (cmdq_async_flush_cb)NULL);
 	data.sta = sta;
 	data.data = cb->data;
 	data.pkt = task->pkt;
-- 
2.33.0



