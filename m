Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 704AD431C50
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232327AbhJRNkF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:40:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:56336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233662AbhJRNig (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:38:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B67A610A5;
        Mon, 18 Oct 2021 13:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634563930;
        bh=2ty7f5rGc2ejbIfuFfnmTHPa7uWKF7NP7tukwJltBak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SVISQ/4E4105/d1lpbo7wz3Zgg7wSqOK9aPa2BtveX1ygQC7ihWAbD0t/YzRSXmR0
         42uN7q2AJKxaBK9P/VjpDAR9IPjvu02wTFWG81+cL8V5vwOVh1i4wfuFR3a+ONLUwV
         PfjXw55zdHTlAzjSivyfEXiNZjt6BYfKVDqr7p8k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 52/69] ethernet: s2io: fix setting mac address during resume
Date:   Mon, 18 Oct 2021 15:24:50 +0200
Message-Id: <20211018132331.206529992@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132329.453964125@linuxfoundation.org>
References: <20211018132329.453964125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 40507e7aada8422c38aafa0c8a1a09e4623c712a upstream.

After recent cleanups, gcc started warning about a suspicious
memcpy() call during the s2io_io_resume() function:

In function '__dev_addr_set',
    inlined from 'eth_hw_addr_set' at include/linux/etherdevice.h:318:2,
    inlined from 's2io_set_mac_addr' at drivers/net/ethernet/neterion/s2io.c:5205:2,
    inlined from 's2io_io_resume' at drivers/net/ethernet/neterion/s2io.c:8569:7:
arch/x86/include/asm/string_32.h:182:25: error: '__builtin_memcpy' accessing 6 bytes at offsets 0 and 2 overlaps 4 bytes at offset 2 [-Werror=restrict]
  182 | #define memcpy(t, f, n) __builtin_memcpy(t, f, n)
      |                         ^~~~~~~~~~~~~~~~~~~~~~~~~
include/linux/netdevice.h:4648:9: note: in expansion of macro 'memcpy'
 4648 |         memcpy(dev->dev_addr, addr, len);
      |         ^~~~~~

What apparently happened is that an old cleanup changed the calling
conventions for s2io_set_mac_addr() from taking an ethernet address
as a character array to taking a struct sockaddr, but one of the
callers was not changed at the same time.

Change it to instead call the low-level do_s2io_prog_unicast() function
that still takes the old argument type.

Fixes: 2fd376884558 ("S2io: Added support set_mac_address driver entry point")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20211013143613.2049096-1-arnd@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/neterion/s2io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/neterion/s2io.c
+++ b/drivers/net/ethernet/neterion/s2io.c
@@ -8565,7 +8565,7 @@ static void s2io_io_resume(struct pci_de
 			return;
 		}
 
-		if (s2io_set_mac_addr(netdev, netdev->dev_addr) == FAILURE) {
+		if (do_s2io_prog_unicast(netdev, netdev->dev_addr) == FAILURE) {
 			s2io_card_down(sp);
 			pr_err("Can't restore mac addr after reset.\n");
 			return;


