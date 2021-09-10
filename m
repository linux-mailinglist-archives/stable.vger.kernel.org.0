Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC3AD406C10
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 14:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234674AbhIJMgh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 08:36:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:51716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233466AbhIJMfd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Sep 2021 08:35:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9EADB60E94;
        Fri, 10 Sep 2021 12:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631277262;
        bh=EWlAHoPb3doGGBjlC3rxknodtu/d/Dmix/quZJ8/u2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EhHiJT5NEJC48ep5U92/RNXiu8RfWgbgmUoZ9A5+zTxR5iNVEl5QlECDHhuqAu8xA
         BOIStql0NajcXsVWSiRg2zBRIubnYDouwfcFMxhgjaB/juyQSkLCHcXrpn6AU0rWQD
         42emlH9jaPaG8hiUyKLfdvKrMK9pX01r/k31HGMo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Prabhakar Kushwaha <pkushwaha@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        Shai Malin <smalin@marvell.com>,
        Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 12/37] qede: Fix memset corruption
Date:   Fri, 10 Sep 2021 14:30:15 +0200
Message-Id: <20210910122917.580399550@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910122917.149278545@linuxfoundation.org>
References: <20210910122917.149278545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shai Malin <smalin@marvell.com>

[ Upstream commit e543468869e2532f5d7926e8f417782b48eca3dc ]

Thanks to Kees Cook who detected the problem of memset that starting
from not the first member, but sized for the whole struct.
The better change will be to remove the redundant memset and to clear
only the msix_cnt member.

Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
Reported-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qede/qede_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index ce3e62e73e4c..1133f6fe21a0 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -1773,6 +1773,7 @@ static void qede_sync_free_irqs(struct qede_dev *edev)
 	}
 
 	edev->int_info.used_cnt = 0;
+	edev->int_info.msix_cnt = 0;
 }
 
 static int qede_req_msix_irqs(struct qede_dev *edev)
@@ -2317,7 +2318,6 @@ static int qede_load(struct qede_dev *edev, enum qede_load_mode mode,
 	goto out;
 err4:
 	qede_sync_free_irqs(edev);
-	memset(&edev->int_info.msix_cnt, 0, sizeof(struct qed_int_info));
 err3:
 	qede_napi_disable_remove(edev);
 err2:
-- 
2.30.2



