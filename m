Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BDC410190C
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbfKSFWd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:22:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:37856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727744AbfKSFWc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:22:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A22832231A;
        Tue, 19 Nov 2019 05:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574140952;
        bh=e6CICMOupY8NFEmXVT/oiRzp/oDxkEoLf0qYaYMSIQk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NYVCs9G9GVDzlQXAwAS6LlMbavY7+L8AHiFW6Dw2XVk8AvKCDWCP6QYAz5IQBUlIe
         HCM+Irx796xre6eNpCc+mYimOvvUOGZQGWkN9Jj+NLg/s/I/4AxVfqYuehxvMbhyoE
         L4Qv46hD6/DpNdOUNKajC/MBhDUcfDaAz9N5FNA4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 40/48] net: ethernet: dwmac-sun8i: Use the correct function in exit path
Date:   Tue, 19 Nov 2019 06:20:00 +0100
Message-Id: <20191119051022.818468781@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119050946.745015350@linuxfoundation.org>
References: <20191119050946.745015350@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Corentin Labbe <clabbe@baylibre.com>

commit 40a1dcee2d1846a24619fe9ca45c661ca0db7dda upstream.

When PHY is not powered, the probe function fail and some resource are
still unallocated.
Furthermore some BUG happens:
dwmac-sun8i 5020000.ethernet: EMAC reset timeout
------------[ cut here ]------------
kernel BUG at /linux-next/net/core/dev.c:9844!

So let's use the right function (stmmac_pltfr_remove) in the error path.

Fixes: 9f93ac8d4085 ("net-next: stmmac: Add dwmac-sun8i")
Cc: <stable@vger.kernel.org> # v4.15+
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -1225,7 +1225,7 @@ static int sun8i_dwmac_probe(struct plat
 dwmac_mux:
 	sun8i_dwmac_unset_syscon(gmac);
 dwmac_exit:
-	sun8i_dwmac_exit(pdev, plat_dat->bsp_priv);
+	stmmac_pltfr_remove(pdev);
 return ret;
 }
 


