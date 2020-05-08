Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 378631CADBC
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728037AbgEHNEQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:04:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:54560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729342AbgEHMtN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:49:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13C92218AC;
        Fri,  8 May 2020 12:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942153;
        bh=1QYDlRPcvqbyXMsB9wotdQhXZF3aw5xyGZAehkYXLsU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d9njWvpE6h7DRDmIaavMPDWZt2vxCsHxvK28ly8lDoXoBFeRWQkcukrE/cNdr6PQ+
         YT2jigdG3xOFP5nlUrWSkXXD805TFMkY1bY4jy6xHtygR/5f/Zv9azKLwFTCD9YAoC
         C6bSBoJ3l5xOzqzs4lPBHRMnhLK7h/7baB5mHAm0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 279/312] net: ethernet: ti: cpsw: fix secondary-emac probe error path
Date:   Fri,  8 May 2020 14:34:30 +0200
Message-Id: <20200508123144.041298536@linuxfoundation.org>
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

commit a7fe9d466f6a33558a38c7ca9d58bcc83512d577 upstream.

Make sure to deregister the primary device in case the secondary emac
fails to probe.

kernel BUG at /home/johan/work/omicron/src/linux/net/core/dev.c:7743!
...
[<c05b3dec>] (free_netdev) from [<c04fe6c0>] (cpsw_probe+0x9cc/0xe50)
[<c04fe6c0>] (cpsw_probe) from [<c047b28c>] (platform_drv_probe+0x5c/0xc0)

Fixes: d9ba8f9e6298 ("driver: net: ethernet: cpsw: dual emac interface
implementation")
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/ti/cpsw.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -2532,12 +2532,14 @@ static int cpsw_probe(struct platform_de
 		ret = cpsw_probe_dual_emac(pdev, priv);
 		if (ret) {
 			cpsw_err(priv, probe, "error probe slave 2 emac interface\n");
-			goto clean_ale_ret;
+			goto clean_unregister_netdev_ret;
 		}
 	}
 
 	return 0;
 
+clean_unregister_netdev_ret:
+	unregister_netdev(ndev);
 clean_ale_ret:
 	cpsw_ale_destroy(priv->ale);
 clean_dma_ret:


