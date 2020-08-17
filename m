Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B209246A63
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730266AbgHQPfB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:35:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:39474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730440AbgHQPeq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:34:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E604522E00;
        Mon, 17 Aug 2020 15:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678486;
        bh=4CFGfsTcuLmf6c/2l3yQniiMu66wdLCJlBLj0T632xw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JtlyLVw90c8qH6B7mwXuCTeFjdBGiE7kDe+7tmS1UPN7xuFVgF2ugu/85DSfxOF1e
         ZxnX1nEMLQ5GocVfiD1rmwfAUy7RWciNyq7+qODDjWabfaerivbiHWFukk3xScT2wj
         TIGlz7tdKNOBijfdAbFSuzAL+hvIGfkmDrwb+vvs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Hai <wanghai38@huawei.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 349/464] wl1251: fix always return 0 error
Date:   Mon, 17 Aug 2020 17:15:02 +0200
Message-Id: <20200817143850.488290042@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit 20e6421344b5bc2f97b8e2db47b6994368417904 ]

wl1251_event_ps_report() should not always return 0 because
wl1251_ps_set_mode() may fail. Change it to return 'ret'.

Fixes: f7ad1eed4d4b ("wl1251: retry power save entry")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200730073939.33704-1-wanghai38@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ti/wl1251/event.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wl1251/event.c b/drivers/net/wireless/ti/wl1251/event.c
index 850864dbafa11..e6d426edab56b 100644
--- a/drivers/net/wireless/ti/wl1251/event.c
+++ b/drivers/net/wireless/ti/wl1251/event.c
@@ -70,7 +70,7 @@ static int wl1251_event_ps_report(struct wl1251 *wl,
 		break;
 	}
 
-	return 0;
+	return ret;
 }
 
 static void wl1251_event_mbox_dump(struct event_mailbox *mbox)
-- 
2.25.1



