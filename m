Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37A64499DBA
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1586134AbiAXWZo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:25:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1584674AbiAXWVc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:21:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 291F7C0424FE;
        Mon, 24 Jan 2022 12:52:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA2FAB80CCF;
        Mon, 24 Jan 2022 20:52:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10B22C340E5;
        Mon, 24 Jan 2022 20:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057562;
        bh=Fr/LKWtC4UyTPQgHsHi1fEAW/E12tFtoUubYw4q27BA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lc2P/Aft5jTaMPIJCLSXGnbJme7Sj+M6/hOn3P5ZNzdnUlA4W4o0R5Hm4/uXlKqCS
         EQtexxmkCeBw4ijJ8ZVoMsYvyj4AZRn5OvcYe5XthZ2tqXYv+bd6tZTnm+tNszJWqB
         4SXd9OgzOpzc9SLf0fmprNO/jT0cGQcKjlSXS00c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 832/846] net: ethernet: mtk_eth_soc: fix error checking in mtk_mac_config()
Date:   Mon, 24 Jan 2022 19:45:49 +0100
Message-Id: <20220124184129.612885100@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

commit 214b3369ab9b0a6f28d6c970220c209417edbc65 upstream.

Clang static analysis reports this problem
mtk_eth_soc.c:394:7: warning: Branch condition evaluates
  to a garbage value
                if (err)
                    ^~~

err is not initialized and only conditionally set.
So intitialize err.

Fixes: 7e538372694b ("net: ethernet: mediatek: Re-add support SGMII")
Signed-off-by: Tom Rix <trix@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -224,7 +224,7 @@ static void mtk_mac_config(struct phylin
 					   phylink_config);
 	struct mtk_eth *eth = mac->hw;
 	u32 mcr_cur, mcr_new, sid, i;
-	int val, ge_mode, err;
+	int val, ge_mode, err = 0;
 
 	/* MT76x8 has no hardware settings between for the MAC */
 	if (!MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628) &&


