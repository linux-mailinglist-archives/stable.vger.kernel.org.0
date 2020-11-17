Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEFEE2B6352
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732354AbgKQNhK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:37:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:48270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732315AbgKQNhI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:37:08 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF30920870;
        Tue, 17 Nov 2020 13:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620228;
        bh=H0dIFFMoiuOw6flSrUg0/ibVcmqoAPx4AYA+UHLxcHg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qWMJeBa9OHwuBETH78D5tBDgpvL/Ck4COMfmL4l+z/rhLOCOSof3IAFH1LAwuiFfc
         Wyav2DiBS54WN9VMHdTqfsYG9lvH+7lqLzhOy8rzQAFEdqSXINdPdOZsMzXV2NHInc
         CvJAoRlRND2IiJE5BmiFiln9yxJsaH+kVwBh0big=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 148/255] r8169: fix potential skb double free in an error path
Date:   Tue, 17 Nov 2020 14:04:48 +0100
Message-Id: <20201117122146.167423295@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit cc6528bc9a0c901c83b8220a2e2617f3354d6dd9 ]

The caller of rtl8169_tso_csum_v2() frees the skb if false is returned.
eth_skb_pad() internally frees the skb on error what would result in a
double free. Therefore use __skb_put_padto() directly and instruct it
to not free the skb on error.

Fixes: b423e9ae49d7 ("r8169: fix offloaded tx checksum for small packets.")
Reported-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://lore.kernel.org/r/f7e68191-acff-9ded-4263-c016428a8762@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index c74d9c02a805f..ed918c12bc5e9 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4145,7 +4145,8 @@ static bool rtl8169_tso_csum_v2(struct rtl8169_private *tp,
 		opts[1] |= transport_offset << TCPHO_SHIFT;
 	} else {
 		if (unlikely(skb->len < ETH_ZLEN && rtl_test_hw_pad_bug(tp)))
-			return !eth_skb_pad(skb);
+			/* eth_skb_pad would free the skb on error */
+			return !__skb_put_padto(skb, ETH_ZLEN, false);
 	}
 
 	return true;
-- 
2.27.0



