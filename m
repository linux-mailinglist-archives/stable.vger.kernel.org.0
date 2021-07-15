Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 310F83CA809
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241598AbhGOS6G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:58:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:33734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241774AbhGOS5T (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:57:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E37660D07;
        Thu, 15 Jul 2021 18:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375265;
        bh=1t40GFUdfFHXYov82Lchb4r/peMxoMO2yy/t5xvZifk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N5X1vlwK3Ur0TlH52xhAj61jiSzv+wEUnjTBhxsxnAmwqxUlEHsKjVE75hYE+1pfx
         j1mZj5cBTqaFFESH/xblffkPyTY/gQvtNMkVeZ7fJtKZ1Lfkzk9YMGLaxI5QCnmtKq
         GDjiPfvjZANs4nZ9rTp4Y+lBdY/o9OMuohdqtWmo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zou Wei <zou_wei@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 015/242] atm: nicstar: Fix possible use-after-free in nicstar_cleanup()
Date:   Thu, 15 Jul 2021 20:36:17 +0200
Message-Id: <20210715182554.433921216@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>

[ Upstream commit 34e7434ba4e97f4b85c1423a59b2922ba7dff2ea ]

This module's remove path calls del_timer(). However, that function
does not wait until the timer handler finishes. This means that the
timer handler may still be running after the driver's remove function
has finished, which would result in a use-after-free.

Fix by calling del_timer_sync(), which makes sure the timer handler
has finished, and unable to re-schedule itself.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/atm/nicstar.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/atm/nicstar.c b/drivers/atm/nicstar.c
index 5c7e4df159b9..b015c3e14336 100644
--- a/drivers/atm/nicstar.c
+++ b/drivers/atm/nicstar.c
@@ -299,7 +299,7 @@ static void __exit nicstar_cleanup(void)
 {
 	XPRINTK("nicstar: nicstar_cleanup() called.\n");
 
-	del_timer(&ns_timer);
+	del_timer_sync(&ns_timer);
 
 	pci_unregister_driver(&nicstar_driver);
 
-- 
2.30.2



