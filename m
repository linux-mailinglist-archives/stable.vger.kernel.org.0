Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04E0F3CD7E4
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242567AbhGSOTa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:19:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:54880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241393AbhGSOTD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:19:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8278B61002;
        Mon, 19 Jul 2021 14:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626706783;
        bh=1J1EScfW7yJRqaoL4pux23XgwAQvFXnbifWtR0O+rnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vKF+I3iTGDVJBb9bdkTCjNeP2audX3orkLjhAjqOAxJSDNnMNXJuvy1WkRSfwz8dV
         DIxwhc4mZz2zfiOf/S/NO+YDhwXUwkaJGGaWjk/8HZAZseupqc2IkoBfHzFW4twoq7
         c+f1QeQ1ArCJQ7pZDg/YLnRMGKe7ZPBbepCggDxs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zou Wei <zou_wei@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 096/188] atm: iphase: fix possible use-after-free in ia_module_exit()
Date:   Mon, 19 Jul 2021 16:51:20 +0200
Message-Id: <20210719144935.486964074@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144913.076563739@linuxfoundation.org>
References: <20210719144913.076563739@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>

[ Upstream commit 1c72e6ab66b9598cac741ed397438a52065a8f1f ]

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
 drivers/atm/iphase.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/atm/iphase.c b/drivers/atm/iphase.c
index 860a33a90ebf..dc1b7f11e6af 100644
--- a/drivers/atm/iphase.c
+++ b/drivers/atm/iphase.c
@@ -3296,7 +3296,7 @@ static void __exit ia_module_exit(void)
 {
 	pci_unregister_driver(&ia_driver);
 
-        del_timer(&ia_timer);
+	del_timer_sync(&ia_timer);
 }
 
 module_init(ia_module_init);
-- 
2.30.2



