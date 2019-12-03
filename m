Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE8DA111C51
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:43:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbfLCWml (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:42:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:57694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728343AbfLCWmk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:42:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7640B20803;
        Tue,  3 Dec 2019 22:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412959;
        bh=NqpJgS/zcGankvvKn6DxWuKh1tqx5rUAmShdIQvPmpI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1CUpkkXBb3uwJxEPfuzJBheWx9yMcERz4vVeKx9nGTMWo+50Hg1f+KSBRDkkyJs2X
         FlJ5cjoBoQjix+kLmSTL0nYuAeN+wm2s4rRlJ5eoE1csZrneF6JgulzBMfOiSO1tus
         9c6sUFc0fl18jzlEEE/O927mMCufTrIziPiArpOI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 080/135] net: mscc: ocelot: fix __ocelot_rmw_ix prototype
Date:   Tue,  3 Dec 2019 23:35:20 +0100
Message-Id: <20191203213030.489718361@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>

[ Upstream commit 17fdd7638cb687cd7f15a48545f25d738f0101e0 ]

The "read-modify-write register index" function is declared with a
confusing prototype: the "mask" and "reg" arguments are swapped.

Fortunately, this does not affect callers so far. Both arguments are
u32, and the wrapper macros (ocelot_rmw_ix etc) have the arguments in
the correct order (the one from ocelot_io.c).

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index f7eeb4806897d..aa372aba66c8c 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -479,7 +479,7 @@ void __ocelot_write_ix(struct ocelot *ocelot, u32 val, u32 reg, u32 offset);
 #define ocelot_write_rix(ocelot, val, reg, ri) __ocelot_write_ix(ocelot, val, reg, reg##_RSZ * (ri))
 #define ocelot_write(ocelot, val, reg) __ocelot_write_ix(ocelot, val, reg, 0)
 
-void __ocelot_rmw_ix(struct ocelot *ocelot, u32 val, u32 reg, u32 mask,
+void __ocelot_rmw_ix(struct ocelot *ocelot, u32 val, u32 mask, u32 reg,
 		     u32 offset);
 #define ocelot_rmw_ix(ocelot, val, m, reg, gi, ri) __ocelot_rmw_ix(ocelot, val, m, reg, reg##_GSZ * (gi) + reg##_RSZ * (ri))
 #define ocelot_rmw_gix(ocelot, val, m, reg, gi) __ocelot_rmw_ix(ocelot, val, m, reg, reg##_GSZ * (gi))
-- 
2.20.1



