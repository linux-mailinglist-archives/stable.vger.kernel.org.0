Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE0227C808
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731607AbgI2L6X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:58:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:39238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730682AbgI2LmF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:42:05 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EAD92065C;
        Tue, 29 Sep 2020 11:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379725;
        bh=fO15eBwbnxmL4fI+RPHnRPQiHTZvIx9WsiBnsp2ccqw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q4l3ApI4mB+bFGWvTkh7PsPfT6GuHySgbQH+Wv1r/ONtDEUeUeLtmQ1zwTroqfRwW
         CmADfA+C7VmKjb0HS0JAs7V5mt83pfjlWpcjpt6ZHNUv1SO4qrUqc73H8QYPxWOJg+
         chqfs4cnTqr/OK8BcJDDzAhSvHyVf4qlUts8amBc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Tony Lindgren <tony@atomide.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 291/388] wlcore: fix runtime pm imbalance in wl1271_tx_work
Date:   Tue, 29 Sep 2020 13:00:22 +0200
Message-Id: <20200929110024.551857494@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 9604617e998b49f7695fea1479ed82421ef8c9f0 ]

There are two error handling paths in this functon. When
wlcore_tx_work_locked() returns an error code, we should
decrease the runtime PM usage counter the same way as the
error handling path beginning from pm_runtime_get_sync().

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Acked-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200520124241.9931-1-dinghao.liu@zju.edu.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ti/wlcore/tx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index 90e56d4c3df3b..e20e18cd04aed 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -863,6 +863,7 @@ void wl1271_tx_work(struct work_struct *work)
 
 	ret = wlcore_tx_work_locked(wl);
 	if (ret < 0) {
+		pm_runtime_put_noidle(wl->dev);
 		wl12xx_queue_recovery_work(wl);
 		goto out;
 	}
-- 
2.25.1



