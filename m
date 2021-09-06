Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3834E401B84
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 14:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242453AbhIFM5j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 08:57:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:33720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242457AbhIFM5d (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Sep 2021 08:57:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96B1F61027;
        Mon,  6 Sep 2021 12:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630932989;
        bh=0Q8EKeXxkYgT94UKm7lT9utLHVkGRoZMzD9jbo+cAPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YpfML9hMLB4FbWldZGK2QrXGSY0UZEqUrzOgu7j+q4g11oFr7hQeOceF9slYd5efR
         HWSHiCDNKJBbI2FiQaqYn4/jInSjoooQmVMtECzKuJU2MOHkeeWuUm1mTDC2aPI0CP
         A///CZDIWcnJCM85QgFOvHunPEBr2gqtTkfNS6Bs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Prabhakar Kushwaha <pkushwaha@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        Shai Malin <smalin@marvell.com>,
        Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 16/29] qede: Fix memset corruption
Date:   Mon,  6 Sep 2021 14:55:31 +0200
Message-Id: <20210906125450.325804754@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210906125449.756437409@linuxfoundation.org>
References: <20210906125449.756437409@linuxfoundation.org>
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
index d9a3c811ac8b..e93f06e4a172 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -1869,6 +1869,7 @@ static void qede_sync_free_irqs(struct qede_dev *edev)
 	}
 
 	edev->int_info.used_cnt = 0;
+	edev->int_info.msix_cnt = 0;
 }
 
 static int qede_req_msix_irqs(struct qede_dev *edev)
@@ -2409,7 +2410,6 @@ static int qede_load(struct qede_dev *edev, enum qede_load_mode mode,
 	goto out;
 err4:
 	qede_sync_free_irqs(edev);
-	memset(&edev->int_info.msix_cnt, 0, sizeof(struct qed_int_info));
 err3:
 	qede_napi_disable_remove(edev);
 err2:
-- 
2.30.2



