Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2A41CABD0
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729524AbgEHMrP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:47:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:49456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729231AbgEHMrO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:47:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 526D121473;
        Fri,  8 May 2020 12:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942033;
        bh=imHllWF0IkqPyAJK3PIZEqSeIRDsQqcMz00EYhA95eU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1vf/Up/QuOzNak28oi51q6ND44SJMFIt7Rr8y6DMeXEFLej8nSAbrUgSka4bQfnuH
         0uXP/DjF0EPOYUZ7IAzs+axZwn2XnJifr3Fa+nm/St9KC1S64YiZOi4C9jxwUcFX4r
         fkvbBYvUVy1C2/9lvgljVcfnKYpnQNUklBOdgNzM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 268/312] net: ethernet: stmmac: dwmac-rk: fix probe error path
Date:   Fri,  8 May 2020 14:34:19 +0200
Message-Id: <20200508123143.283415866@linuxfoundation.org>
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

commit 2d222656db08b8eef3b53b56cf1ce4a90fe8cd78 upstream.

Make sure to disable runtime PM, power down the PHY, and disable clocks
before returning on late probe errors.

Fixes: 27ffefd2d109 ("stmmac: dwmac-rk: create a new probe function")
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
@@ -600,7 +600,16 @@ static int rk_gmac_probe(struct platform
 	if (ret)
 		return ret;
 
-	return stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
+	ret = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
+	if (ret)
+		goto err_gmac_exit;
+
+	return 0;
+
+err_gmac_exit:
+	rk_gmac_exit(pdev, plat_dat->bsp_priv);
+
+	return ret;
 }
 
 static const struct of_device_id rk_gmac_dwmac_match[] = {


