Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49BC93CA9EE
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242969AbhGOTLJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:11:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:45710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237288AbhGOTIa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:08:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39D4D613DD;
        Thu, 15 Jul 2021 19:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375850;
        bh=1t40GFUdfFHXYov82Lchb4r/peMxoMO2yy/t5xvZifk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mx0txGPIYqIMESzSHXe7sU5209ypR+jsr2TqYeuw6c7VIIypJJYHaCamX6r7Ch5rC
         hSw3dqeD5XbS9nIJSEpeLtkHkWv/k+WOm7lfrXQdrxhIyuQGoji7BPB/bR1kfFnYJp
         Sr/2k59vWSmhT/a+FOQEwmZCGrnuOBc/RU9E6mOQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zou Wei <zou_wei@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 020/266] atm: nicstar: Fix possible use-after-free in nicstar_cleanup()
Date:   Thu, 15 Jul 2021 20:36:15 +0200
Message-Id: <20210715182617.476945810@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
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



