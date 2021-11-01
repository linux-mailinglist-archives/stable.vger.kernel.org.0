Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70CBD441800
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:39:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233429AbhKAJmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:42:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:48004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232779AbhKAJkB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:40:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A7CF611ED;
        Mon,  1 Nov 2021 09:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758865;
        bh=pJwoazBRxcQ8JO5dTcWkRF5rdlVPgeypRLQqLd7f7Qk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CCX1ciaQrF2SMmAtwUpKcXKnZBGMyRlE9AWJhEoB+ODZhOVTJgtBxouDIseA1xn36
         74p0svyGnvuQP3vLI5HP4vvGd6ljqdbCDit76+l81Js7+qwQVscFDO/ybVaF5bVyNa
         fsgFCn6mAbGhNgP/uJrsE1U7ssQ8LTB09T6q6pJs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yanfei Xu <yanfei.xu@windriver.com>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.14 015/125] Revert "net: mdiobus: Fix memory leak in __mdiobus_register"
Date:   Mon,  1 Nov 2021 10:16:28 +0100
Message-Id: <20211101082536.400501204@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
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
@@ -548,7 +548,6 @@ int __mdiobus_register(struct mii_bus *b
 	err = device_register(&bus->dev);
 	if (err) {
 		pr_err("mii_bus %s failed to register\n", bus->id);
-		put_device(&bus->dev);
 		return -EINVAL;
 	}
 


