Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7777406B9A
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 14:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233444AbhIJMct (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 08:32:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:50318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233445AbhIJMcs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Sep 2021 08:32:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C944B604DA;
        Fri, 10 Sep 2021 12:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631277097;
        bh=1eyGnNXy3I5oAG/eMA5HTQVipfqWe/iyJY3oltcElOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ue1lLc+pM+QrnaBKYa06Mn2XThFlB/RzYZ0A8nb8B58ftuMh5aU5njG1ysfRfkk47
         m3tZxUqaLDxVqgcEylNH/UmL+NSfM/QmBfCUWCS5zbwTbWNcBRLCHelv98akhQsnpe
         EPof5jYeK2TcOr8yHtSjiJde9kj/syKNwIts5HcY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hayes Wang <hayeswang@realtek.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.14 04/23] Revert "r8169: avoid link-up interrupt issue on RTL8106e if user enables ASPM"
Date:   Fri, 10 Sep 2021 14:29:54 +0200
Message-Id: <20210910122916.165465149@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910122916.022815161@linuxfoundation.org>
References: <20210910122916.022815161@linuxfoundation.org>
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
@@ -3489,6 +3489,7 @@ static void rtl_hw_start_8402(struct rtl
 	rtl_eri_write(tp, 0x1b0, ERIAR_MASK_0011, 0x0000);
 
 	rtl_pcie_state_l2l3_disable(tp);
+	rtl_hw_aspm_clkreq_enable(tp, true);
 }
 
 static void rtl_hw_start_8106(struct rtl8169_private *tp)


