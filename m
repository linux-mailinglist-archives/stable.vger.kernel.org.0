Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B06A033B72D
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231789AbhCON7p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:59:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:36764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232350AbhCON62 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:58:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E094764F17;
        Mon, 15 Mar 2021 13:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816706;
        bh=hJVwzSC6/ST+dE99RgvAl3V8AhpXoY12zMpM3vlMe1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KgFcZ/tSy97qsvCKoPEXX2hCEWaCWK7A87M/UrG3tjZ4PIylLC+MhUUX8+bbv4dCn
         3zl5iH4XWiy2/WKOsWRj7zIHhteLjvnGdte0Sjo95MAxK7OvAJPxz3keZyi9JuW2Ro
         yEi5m1yypWXODBhKAX+260xAHTtVzggLICmqAuVI=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hayes Wang <hayeswang@realtek.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.11 076/306] r8169: fix r8168fp_adjust_ocp_cmd function
Date:   Mon, 15 Mar 2021 14:52:19 +0100
Message-Id: <20210315135510.214125519@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Hayes Wang <hayeswang@realtek.com>

commit abbf9a0ef8848dca58c5b97750c1c59bbee45637 upstream.

The (0xBAF70000 & 0x00FFF000) << 6 should be (0xf70 << 18).

Fixes: 561535b0f239 ("r8169: fix OCP access on RTL8117")
Signed-off-by: Hayes Wang <hayeswang@realtek.com>
Acked-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/realtek/r8169_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1013,7 +1013,7 @@ static void r8168fp_adjust_ocp_cmd(struc
 {
 	/* based on RTL8168FP_OOBMAC_BASE in vendor driver */
 	if (tp->mac_version == RTL_GIGA_MAC_VER_52 && type == ERIAR_OOB)
-		*cmd |= 0x7f0 << 18;
+		*cmd |= 0xf70 << 18;
 }
 
 DECLARE_RTL_COND(rtl_eriar_cond)


