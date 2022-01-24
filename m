Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D77049A924
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:19:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1322197AbiAYDVW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:21:22 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35780 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353840AbiAXUJA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:09:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03333612FC;
        Mon, 24 Jan 2022 20:08:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B912CC340E5;
        Mon, 24 Jan 2022 20:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054938;
        bh=yrC4/59bDpg4P6F8ntcpYsVINcsebGMtT4MPqprAZJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Adj4hF7SDdLoqL2rEiwuDW9Ptg8Y/BorCexbABjI3O5Hb7zXh4v/ffWppUhZzNV78
         a9PEN8wXIV0cfUg0UiVyuTBrOBevbLz3BZJ2HM4IbBWNocKD0oNipANmMOT7JLbNDR
         wRMTEuLtS3EulaPyDlnAh90BRVN4f0ltB9pawzjw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 552/563] net: ethernet: mtk_eth_soc: fix error checking in mtk_mac_config()
Date:   Mon, 24 Jan 2022 19:45:17 +0100
Message-Id: <20220124184043.527136494@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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
@@ -215,7 +215,7 @@ static void mtk_mac_config(struct phylin
 					   phylink_config);
 	struct mtk_eth *eth = mac->hw;
 	u32 mcr_cur, mcr_new, sid, i;
-	int val, ge_mode, err;
+	int val, ge_mode, err = 0;
 
 	/* MT76x8 has no hardware settings between for the MAC */
 	if (!MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628) &&


