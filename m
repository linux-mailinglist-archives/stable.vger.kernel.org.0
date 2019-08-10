Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F84088E60
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727282AbfHJUyW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:54:22 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53806 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726481AbfHJUns (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:43:48 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDK-00053m-8X; Sat, 10 Aug 2019 21:43:46 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDJ-0003a0-DP; Sat, 10 Aug 2019 21:43:45 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Arnd Bergmann" <arnd@arndb.de>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.966493490@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 032/157] 3c515: fix integer overflow warning
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit fb6fafbc7de4a813bb5364358bbe27f71e62b24a upstream.

clang points out a harmless signed integer overflow:

drivers/net/ethernet/3com/3c515.c:1530:66: error: implicit conversion from 'int' to 'short' changes value from 32783 to -32753 [-Werror,-Wconstant-conversion]
                new_mode = SetRxFilter | RxStation | RxMulticast | RxBroadcast | RxProm;
                         ~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~
drivers/net/ethernet/3com/3c515.c:1532:52: error: implicit conversion from 'int' to 'short' changes value from 32775 to -32761 [-Werror,-Wconstant-conversion]
                new_mode = SetRxFilter | RxStation | RxMulticast | RxBroadcast;
                         ~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~
drivers/net/ethernet/3com/3c515.c:1534:38: error: implicit conversion from 'int' to 'short' changes value from 32773 to -32763 [-Werror,-Wconstant-conversion]
                new_mode = SetRxFilter | RxStation | RxBroadcast;
                         ~ ~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~

Make the variable unsigned to avoid the overflow.

Fixes: Linux-2.1.128pre1
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/3com/3c515.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/3com/3c515.c
+++ b/drivers/net/ethernet/3com/3c515.c
@@ -1524,7 +1524,7 @@ static void update_stats(int ioaddr, str
 static void set_rx_mode(struct net_device *dev)
 {
 	int ioaddr = dev->base_addr;
-	short new_mode;
+	unsigned short new_mode;
 
 	if (dev->flags & IFF_PROMISC) {
 		if (corkscrew_debug > 3)

