Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2C02B6531
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731590AbgKQNwJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:52:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:37806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731529AbgKQN3L (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:29:11 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6AFA20781;
        Tue, 17 Nov 2020 13:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619750;
        bh=cu0zs86j7xIopRBr5gk/sqGY3Igq1piVnCLL7h2gk1Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iCro9oZGlWcLKLRyHPcXHq3ujOfF6YksUps9jrIPcyi/ZfdoB7sabtUs4OLmtSbgA
         RNmRUBvZX4cRP7zpIH+tVxmzS/jRna8eA0ppiEIpvfLkQ2DJvb5rml8JFkjkYVFSof
         k0xG3DyYpMjMW12nOVne01ietXyU9z5U2eINkbIw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 5.4 144/151] r8169: fix potential skb double free in an error path
Date:   Tue, 17 Nov 2020 14:06:14 +0100
Message-Id: <20201117122128.431905207@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122121.381905960@linuxfoundation.org>
References: <20201117122121.381905960@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/realtek/r8169_main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5846,7 +5846,8 @@ static bool rtl8169_tso_csum_v2(struct r
 		opts[1] |= transport_offset << TCPHO_SHIFT;
 	} else {
 		if (unlikely(rtl_test_hw_pad_bug(tp, skb)))
-			return !eth_skb_pad(skb);
+			/* eth_skb_pad would free the skb on error */
+			return !__skb_put_padto(skb, ETH_ZLEN, false);
 	}
 
 	return true;


