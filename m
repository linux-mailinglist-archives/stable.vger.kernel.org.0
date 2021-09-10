Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C37FE406C02
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 14:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233682AbhIJMgN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 08:36:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:51792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233869AbhIJMdv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Sep 2021 08:33:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2A76611CE;
        Fri, 10 Sep 2021 12:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631277160;
        bh=V4C5UP6bMCDHaR6X1XMoUIhm2tNfMSTWbPtSbr2ccTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V1jo/iy8gzwyRUSCSGqn++wS+gM3NLLLQe6D3AR8DwNFRqoQWnOVGJgPeUraEHFWi
         E6cylnjKrjUPqqI2+tJjm7uPKJeJzgd2fjrMzI8gGjNuMks9rsMqrM6jhBqfnoiy81
         +dLcExSAoHmE4C+n0qGGOiLPHPC+1wwmikzu49xE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hayes Wang <hayeswang@realtek.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.13 04/22] Revert "r8169: avoid link-up interrupt issue on RTL8106e if user enables ASPM"
Date:   Fri, 10 Sep 2021 14:30:03 +0200
Message-Id: <20210910122916.078980972@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910122915.942645251@linuxfoundation.org>
References: <20210910122915.942645251@linuxfoundation.org>
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
@@ -3510,6 +3510,7 @@ static void rtl_hw_start_8106(struct rtl
 	rtl_eri_write(tp, 0x1b0, ERIAR_MASK_0011, 0x0000);
 
 	rtl_pcie_state_l2l3_disable(tp);
+	rtl_hw_aspm_clkreq_enable(tp, true);
 }
 
 DECLARE_RTL_COND(rtl_mac_ocp_e00e_cond)


