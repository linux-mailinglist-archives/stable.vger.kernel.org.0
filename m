Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E81F64416CE
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231821AbhKAJaE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:30:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:36830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232834AbhKAJ2D (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:28:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41C8A611C5;
        Mon,  1 Nov 2021 09:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758557;
        bh=dsvR+jMv+1KcQ65oX45GBozaLFymzzrKSk9REQN0lDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0s2xKr7bS/wZ/kyuIWaVxE71ArlfMOdmt6uYpWlKrYFn8Fq2/2VrSOAHJIGsdPapz
         Bd5gZ9pCQ7aJmMyLMdzmIGK0o539dojCXqn7YZdN8WCziguxARCGDezdT068wht9tf
         Fw63UO5c+QBp8NQvg5DFtaXapYIym0mSLgyIjOWc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yanfei Xu <yanfei.xu@windriver.com>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 13/51] Revert "net: mdiobus: Fix memory leak in __mdiobus_register"
Date:   Mon,  1 Nov 2021 10:17:17 +0100
Message-Id: <20211101082503.703704540@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082500.203657870@linuxfoundation.org>
References: <20211101082500.203657870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

commit 10eff1f5788b6ffac212c254e2f3666219576889 upstream.

This reverts commit ab609f25d19858513919369ff3d9a63c02cd9e2e.

This patch is correct in the sense that we _should_ call device_put() in
case of device_register() failure, but the problem in this code is more
vast.

We need to set bus->state to UNMDIOBUS_REGISTERED before calling
device_register() to correctly release the device in mdiobus_free().
This patch prevents us from doing it, since in case of device_register()
failure put_device() will be called 2 times and it will cause UAF or
something else.

Also, Reported-by: tag in revered commit was wrong, since syzbot
reported different leak in same function.

Link: https://lore.kernel.org/netdev/20210928092657.GI2048@kadam/
Acked-by: Yanfei Xu <yanfei.xu@windriver.com>
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Link: https://lore.kernel.org/r/f12fb1faa4eccf0f355788225335eb4309ff2599.1633024062.git.paskripkin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/mdio_bus.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -395,7 +395,6 @@ int __mdiobus_register(struct mii_bus *b
 	err = device_register(&bus->dev);
 	if (err) {
 		pr_err("mii_bus %s failed to register\n", bus->id);
-		put_device(&bus->dev);
 		return -EINVAL;
 	}
 


