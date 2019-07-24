Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 934BC73A8D
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403811AbfGXTvX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:51:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:60602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391652AbfGXTvU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:51:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 618D321873;
        Wed, 24 Jul 2019 19:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997879;
        bh=WehsvQN0BP1fhg4h0wIjyNdGiJvwusZzVCJnALS/tbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HBYGd33dOkV5Kw9yaC6yI93lyOPdBeYUCCQ79HJvFnIHjFdyd7LsmRHy8fUwIxXpI
         fIk4YMDdYlSES/O8mORJAacmB3XR96mPwLFrNQDqE4tafxxDXEXILQpugH4sMcPKTt
         s2UenBKI37KEyIf+pk2JPJ/giqCN3tdEgj7Bq/0A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Gong <wgong@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 176/371] ath10k: destroy sdio workqueue while remove sdio module
Date:   Wed, 24 Jul 2019 21:18:48 +0200
Message-Id: <20190724191738.465061959@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 3ed39f8e747a7aafeec07bb244f2c3a1bdca5730 ]

The workqueue need to flush and destory while remove sdio module,
otherwise it will have thread which is not destory after remove
sdio modules.

Tested with QCA6174 SDIO with firmware
WLAN.RMH.4.4.1-00007-QCARMSWP-1.

Signed-off-by: Wen Gong <wgong@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/sdio.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/sdio.c b/drivers/net/wireless/ath/ath10k/sdio.c
index 73ef3e75d199..28bdf0212538 100644
--- a/drivers/net/wireless/ath/ath10k/sdio.c
+++ b/drivers/net/wireless/ath/ath10k/sdio.c
@@ -2081,6 +2081,9 @@ static void ath10k_sdio_remove(struct sdio_func *func)
 	cancel_work_sync(&ar_sdio->wr_async_work);
 	ath10k_core_unregister(ar);
 	ath10k_core_destroy(ar);
+
+	flush_workqueue(ar_sdio->workqueue);
+	destroy_workqueue(ar_sdio->workqueue);
 }
 
 static const struct sdio_device_id ath10k_sdio_devices[] = {
-- 
2.20.1



