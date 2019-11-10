Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 862B9F68B0
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 12:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbfKJLcM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Nov 2019 06:32:12 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42540 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726610AbfKJLcM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Nov 2019 06:32:12 -0500
Received: by mail-wr1-f65.google.com with SMTP id a15so11606342wrf.9
        for <stable@vger.kernel.org>; Sun, 10 Nov 2019 03:32:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=eqtZaRSTf6xIkwuPq1/HFHXXUlATMq/NHIIuhCWeknE=;
        b=0kwJ4ih0MBW94wtyqcnSiEUWwf7e4nSsn7yZjt1Ih7C14XjKqudwbSRuNuRXNwioYK
         yRsvj0cK1ELFBUaF6SP4LZ36SsDk8pgOVRo2dUc2h/mtmUckG1TbphQzWu6iYxj6aT2A
         GJS8Ps8Dbc9bT4z6oFAVtpKz7/qzKzbeeSxpWG1SND6foE6Vm4K9uUQtECf4P+G0C1vw
         oaJr6SdzCoLyCX4D8NIhIexfeRZWjPJGzTN+O5wiPRpzLhCokFbACXrvkbaR/okV2KKU
         XwI3jRTFPtsnCNh9E8fx/T9UmSXGX75Ws1ZDqOIVD39sT16TArR4eJqBukqx2bFlF5Kt
         O1Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=eqtZaRSTf6xIkwuPq1/HFHXXUlATMq/NHIIuhCWeknE=;
        b=ZY32xNBHVuvBkqZUB8HZGxl3K8NTbo3L16+YoHJ/Us5GFy43ibxX3TFTpcBMSZrAkl
         gO7bUNG10H3sB2dN5bItuL42aUP9DLMHvz05M5fNqIRcG2OdVtzGoovBLlwWMtYBahLJ
         p+gyufxfgGqAfem9yuj/vUpwpzup8rA+JJSBRe4skyk9vBkAo+5ZbEFPZ4BHSreEv02G
         Q0WXRruTsaJUAdKrN3g7TM2tiq2p/cGblJuMrNZDRmkHPRWxc6Pb15StXbOU+8gvqOiY
         dskfNrZ4WlIk/Xvtc60+Qu3WzbyzP2iVCUURRZwEaGujmNjZay9SHpSCD/WG/WgK85O0
         6xNA==
X-Gm-Message-State: APjAAAV5MXIf7/53acv5tEdiQkpPypqhE16P4CNZRFqJoL8+SZ5yccLq
        LxNUdhIi5qmeu7SRNHWWUG+pCw==
X-Google-Smtp-Source: APXvYqwVMKPltIJcxfYK5pX/jgL4O+v5P+oIZIcn6bHiA4cAV1wqJtXljV3PMLaASgLhKqeraItTfg==
X-Received: by 2002:adf:fe8d:: with SMTP id l13mr172966wrr.287.1573385530196;
        Sun, 10 Nov 2019 03:32:10 -0800 (PST)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id p4sm13440238wrx.71.2019.11.10.03.32.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 10 Nov 2019 03:32:09 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     alexandre.torgue@st.com, davem@davemloft.net, joabreu@synopsys.com,
        mripard@kernel.org, peppe.cavallaro@st.com, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>,
        "# v4 . 15+" <stable@vger.kernel.org>
Subject: [PATCH] net: ethernet: dwmac-sun8i: Use the correct function in exit path
Date:   Sun, 10 Nov 2019 11:30:48 +0000
Message-Id: <1573385448-30282-1-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
index eefb06d918c8..1c8d84ed8410 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -1227,7 +1227,7 @@ static int sun8i_dwmac_probe(struct platform_device *pdev)
 dwmac_mux:
 	sun8i_dwmac_unset_syscon(gmac);
 dwmac_exit:
-	sun8i_dwmac_exit(pdev, plat_dat->bsp_priv);
+	stmmac_pltfr_remove(pdev);
 return ret;
 }
 
-- 
2.23.0

