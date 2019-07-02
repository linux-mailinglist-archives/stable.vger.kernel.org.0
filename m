Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C7DA5CB2F
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727459AbfGBIJw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:09:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:57918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727678AbfGBIJv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:09:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DB5D2184B;
        Tue,  2 Jul 2019 08:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054991;
        bh=28Ru4aeXvLWSIhIKKU8OM7ebMN47JKfCB4G/ALz7aCw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zS/i6f2/xF2SaZv8U/1bwEj2LrCyZ+6uRWJDdf00oKBW+1YR98FNcCKXF2FzTif6P
         IZ7no1zJGX7kwF6IkUS8VkaChziV31xon7BdsXQ7nhlmPhYLhuVc5EZ3d9fBWdLqah
         RsPNtDd7EvxWyy6xRLxGZeb6l0MEPY8OCTzoP/QQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Roland Hii <roland.king.guan.hii@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 31/43] net: stmmac: fixed new system time seconds value calculation
Date:   Tue,  2 Jul 2019 10:02:11 +0200
Message-Id: <20190702080125.489741778@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080123.904399496@linuxfoundation.org>
References: <20190702080123.904399496@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roland Hii <roland.king.guan.hii@intel.com>

[ Upstream commit a1e5388b4d5fc78688e5e9ee6641f779721d6291 ]

When ADDSUB bit is set, the system time seconds field is calculated as
the complement of the seconds part of the update value.

For example, if 3.000000001 seconds need to be subtracted from the
system time, this field is calculated as
2^32 - 3 = 4294967296 - 3 = 0x100000000 - 3 = 0xFFFFFFFD

Previously, the 0x100000000 is mistakenly written as 100000000.

This is further simplified from
  sec = (0x100000000ULL - sec);
to
  sec = -sec;

Fixes: ba1ffd74df74 ("stmmac: fix PTP support for GMAC4")
Signed-off-by: Roland Hii <roland.king.guan.hii@intel.com>
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
@@ -121,7 +121,7 @@ static int stmmac_adjust_systime(void __
 		 * programmed with (2^32 – <new_sec_value>)
 		 */
 		if (gmac4)
-			sec = (100000000ULL - sec);
+			sec = -sec;
 
 		value = readl(ioaddr + PTP_TCR);
 		if (value & PTP_TCR_TSCTRLSSR)


