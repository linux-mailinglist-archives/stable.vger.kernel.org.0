Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 822F63A0249
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235801AbhFHTCh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:02:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:34008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237414AbhFHTAf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:00:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7BAC616ED;
        Tue,  8 Jun 2021 18:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177827;
        bh=k9qimZzS8pLMIf5jz271FfERmtM2ILCnjbYXe/DJ3QY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G+RKU2ChyFC0DSVIeHyHWIls/0Uyl9Lt81tBsi58j/YuMhKtLoaCNv6rykFrTiNVu
         mahLCxokjXrAy/d9RnPdW5Q/1MQtmjkAJKnPGPTuIqBQafZQFChwL47mHioFuGWFwj
         SmtDKPCboHvSV8sHOIl51ghcIF5c+k1KWVnFaf1s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 080/137] wireguard: do not use -O3
Date:   Tue,  8 Jun 2021 20:27:00 +0200
Message-Id: <20210608175945.063521105@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175942.377073879@linuxfoundation.org>
References: <20210608175942.377073879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit cc5060ca0285efe2728bced399a1955a7ce808b2 upstream.

Apparently, various versions of gcc have O3-related miscompiles. Looking
at the difference between -O2 and -O3 for gcc 11 doesn't indicate
miscompiles, but the difference also doesn't seem so significant for
performance that it's worth risking.

Link: https://lore.kernel.org/lkml/CAHk-=wjuoGyxDhAF8SsrTkN0-YfCx7E6jUN3ikC_tn2AKWTTsA@mail.gmail.com/
Link: https://lore.kernel.org/lkml/CAHmME9otB5Wwxp7H8bR_i2uH2esEMvoBMC8uEXBMH9p0q1s6Bw@mail.gmail.com/
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Cc: stable@vger.kernel.org
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireguard/Makefile |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/wireguard/Makefile
+++ b/drivers/net/wireguard/Makefile
@@ -1,5 +1,4 @@
-ccflags-y := -O3
-ccflags-y += -D'pr_fmt(fmt)=KBUILD_MODNAME ": " fmt'
+ccflags-y := -D'pr_fmt(fmt)=KBUILD_MODNAME ": " fmt'
 ccflags-$(CONFIG_WIREGUARD_DEBUG) += -DDEBUG
 wireguard-y := main.o
 wireguard-y += noise.o


