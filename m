Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7763D2A5F
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234025AbhGVQLF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:11:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:48198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235271AbhGVQJF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:09:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A46F361DCF;
        Thu, 22 Jul 2021 16:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972541;
        bh=A6UdTpLB6HHwHA/cCUHijmzeDT/x3U9rgp3iqxLsklM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xVL7fB/Fx90WwfubmRhT2q4shTJ5eDxhq1BLfildZBfsmMi/OgbefB48QJ9F35bkK
         DI9PG+CtDr7RqRxQtW6IHps61mxC4YPalsJAo7yk/luMr+G8yMgsDHh1ri/Gn9jFZL
         lQ2LmjmaDkjMEtGsmwcXZCOd9WIn/0IjWfItn7g4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.13 114/156] net: dsa: mv88e6xxx: enable SerDes PCS register dump via ethtool -d on Topaz
Date:   Thu, 22 Jul 2021 18:31:29 +0200
Message-Id: <20210722155632.058816682@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Behún <kabel@kernel.org>

commit 953b0dcbe2e3f7bee98cc3bca2ec82c8298e9c16 upstream.

Commit bf3504cea7d7e ("net: dsa: mv88e6xxx: Add 6390 family PCS
registers to ethtool -d") added support for dumping SerDes PCS registers
via ethtool -d for Peridot.

The same implementation is also valid for Topaz, but was not
enabled at the time.

Signed-off-by: Marek Behún <kabel@kernel.org>
Fixes: bf3504cea7d7e ("net: dsa: mv88e6xxx: Add 6390 family PCS registers to ethtool -d")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3626,6 +3626,8 @@ static const struct mv88e6xxx_ops mv88e6
 	.serdes_get_sset_count = mv88e6390_serdes_get_sset_count,
 	.serdes_get_strings = mv88e6390_serdes_get_strings,
 	.serdes_get_stats = mv88e6390_serdes_get_stats,
+	.serdes_get_regs_len = mv88e6390_serdes_get_regs_len,
+	.serdes_get_regs = mv88e6390_serdes_get_regs,
 	.phylink_validate = mv88e6341_phylink_validate,
 };
 
@@ -4435,6 +4437,8 @@ static const struct mv88e6xxx_ops mv88e6
 	.serdes_get_sset_count = mv88e6390_serdes_get_sset_count,
 	.serdes_get_strings = mv88e6390_serdes_get_strings,
 	.serdes_get_stats = mv88e6390_serdes_get_stats,
+	.serdes_get_regs_len = mv88e6390_serdes_get_regs_len,
+	.serdes_get_regs = mv88e6390_serdes_get_regs,
 	.phylink_validate = mv88e6341_phylink_validate,
 };
 


