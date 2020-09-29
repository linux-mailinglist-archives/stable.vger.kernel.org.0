Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9842C27CAF9
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732602AbgI2MXm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:23:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:46898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729760AbgI2LfJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:35:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34B4A23C43;
        Tue, 29 Sep 2020 11:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378912;
        bh=gizUYms1avGM+a5KK5WcbtwwMjQvvFthjI3iF6v7Uz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=11/9sx2ZO090zSRRSbL/ZxRogpqi9FBXdNigEhniVTODSctsyqBv6BKV6is3xGIDq
         91fXgR8Q/OWQQk7+Lq3lmiEEy6NsTGlF8mmNDp+y68y9DaSdyR4D3v2VNctFadoVXe
         GuwhNE/uls+Dg0H0TzjK/OS4yICEaUPFxbac/gfU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Tony Lindgren <tony@atomide.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 185/245] wlcore: fix runtime pm imbalance in wl1271_tx_work
Date:   Tue, 29 Sep 2020 13:00:36 +0200
Message-Id: <20200929105955.977392462@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
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
index b6e19c2d66b0a..250bcbf4ea2f2 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -877,6 +877,7 @@ void wl1271_tx_work(struct work_struct *work)
 
 	ret = wlcore_tx_work_locked(wl);
 	if (ret < 0) {
+		pm_runtime_put_noidle(wl->dev);
 		wl12xx_queue_recovery_work(wl);
 		goto out;
 	}
-- 
2.25.1



