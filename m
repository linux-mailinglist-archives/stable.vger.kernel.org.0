Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CFF1406C50
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 14:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233435AbhIJMiz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 08:38:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:52702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234816AbhIJMhI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Sep 2021 08:37:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF3FD6120C;
        Fri, 10 Sep 2021 12:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631277346;
        bh=F8QdmjtKL6/Wu8pkJufAIMMyWMxfPCEJTjYlh+/hMGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=07U5XhhCCHVoXSzh9155DYuciT2cS5pWSeI2xsMH7MKREFthOEv+hFs1qL2pot3Qk
         pxaoOpMSvGgz7D1QMMYI4nopHjb1VEMQg+9T4RT2JKBfPliAHNmsnWaIifqFVP7ZTC
         wppmh1tIRk1il1IvuVE6U3olw6D+m+qV8szj3BgI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hayes Wang <hayeswang@realtek.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 28/37] Revert "r8169: avoid link-up interrupt issue on RTL8106e if user enables ASPM"
Date:   Fri, 10 Sep 2021 14:30:31 +0200
Message-Id: <20210910122918.093706379@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910122917.149278545@linuxfoundation.org>
References: <20210910122917.149278545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>

commit 2115d3d482656ea702f7cf308c0ded3500282903 upstream.

This reverts commit 1ee8856de82faec9bc8bd0f2308a7f27e30ba207.

This is used to re-enable ASPM on RTL8106e, if it is possible.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/realtek/r8169_main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4713,6 +4713,7 @@ static void rtl_hw_start_8168g(struct rt
 	rtl_eri_clear_bits(tp, 0x1b0, ERIAR_MASK_0011, BIT(12));
 
 	rtl_pcie_state_l2l3_disable(tp);
+	rtl_hw_aspm_clkreq_enable(tp, true);
 }
 
 static void rtl_hw_start_8168g_1(struct rtl8169_private *tp)


