Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 033F31CAF16
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728391AbgEHNO1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:14:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:49180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728853AbgEHMrG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:47:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6C662495E;
        Fri,  8 May 2020 12:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942026;
        bh=gVOuxZt4Sck/KrozpjIzTyUjv84dPeWtgnH6bd5twlU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hmR+WC8nl3vbPuAwJEHQsrKzAcFYIj83/C+h5aqVLxkwfy356v/Lsq72WZnVbyYzM
         h2ewRBNcMxGZKBPo3qSx+gXDg8R74v1SYHOsGWgBxgx+ECoXgQBMq/BpMXI4yj0Suf
         eEGyqLgnQU7r5Wg08KlRutbb2TySRGeN/fv5o5Tw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 266/312] net: ethernet: stmmac: dwmac-sti: fix probe error path
Date:   Fri,  8 May 2020 14:34:17 +0200
Message-Id: <20200508123143.145521242@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 0a9e22715ee384cf2a714c28f24ce8881b9fd815 upstream.

Make sure to disable clocks before returning on late probe errors.

Fixes: 8387ee21f972 ("stmmac: dwmac-sti: turn setup callback into a
probe function")
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c
@@ -365,7 +365,16 @@ static int sti_dwmac_probe(struct platfo
 	if (ret)
 		return ret;
 
-	return stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
+	ret = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
+	if (ret)
+		goto err_dwmac_exit;
+
+	return 0;
+
+err_dwmac_exit:
+	sti_dwmac_exit(pdev, plat_dat->bsp_priv);
+
+	return ret;
 }
 
 static const struct sti_dwmac_of_data stih4xx_dwmac_data = {


