Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0BF42DD1B
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 17:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233314AbhJNPEW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 11:04:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:45066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233133AbhJNPDE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 11:03:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7479611CA;
        Thu, 14 Oct 2021 14:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634223592;
        bh=vg+ilq+FkshFxvO6+fl5t/WS0G+CDNmxrnjPYa4IC0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=legOIdOkWC2bgmV+90FpNMLs+M6A80dab6cpv87gb1/P6rSG6sAkI5ARRxG20ZraY
         7Vs01ern1VP5IzNo68htMEzbZc83EVeNmklOgTODg6k0DD/B2p1Gms4UVicaf5Kbs/
         apztZAb7mBUQC+rGgxPc9BCESuMkm2KVWIYMhH/M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Aaron Young <aaron.young@oracle.com>,
        Rashmi Narasimhan <rashmi.narasimhan@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 16/22] net: sun: SUNVNET_COMMON should depend on INET
Date:   Thu, 14 Oct 2021 16:54:22 +0200
Message-Id: <20211014145208.508807439@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014145207.979449962@linuxfoundation.org>
References: <20211014145207.979449962@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 103bde372f084206c6972be543ecc247ebbff9f3 ]

When CONFIG_INET is not set, there are failing references to IPv4
functions, so make this driver depend on INET.

Fixes these build errors:

sparc64-linux-ld: drivers/net/ethernet/sun/sunvnet_common.o: in function `sunvnet_start_xmit_common':
sunvnet_common.c:(.text+0x1a68): undefined reference to `__icmp_send'
sparc64-linux-ld: drivers/net/ethernet/sun/sunvnet_common.o: in function `sunvnet_poll_common':
sunvnet_common.c:(.text+0x358c): undefined reference to `ip_send_check'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Aaron Young <aaron.young@oracle.com>
Cc: Rashmi Narasimhan <rashmi.narasimhan@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sun/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/sun/Kconfig b/drivers/net/ethernet/sun/Kconfig
index 309de38a7530..b0d3f9a2950c 100644
--- a/drivers/net/ethernet/sun/Kconfig
+++ b/drivers/net/ethernet/sun/Kconfig
@@ -73,6 +73,7 @@ config CASSINI
 config SUNVNET_COMMON
 	tristate "Common routines to support Sun Virtual Networking"
 	depends on SUN_LDOMS
+	depends on INET
 	default m
 
 config SUNVNET
-- 
2.33.0



