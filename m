Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C33FA3D6117
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232200AbhGZP22 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:28:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:41598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237827AbhGZP0c (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:26:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51EC160F94;
        Mon, 26 Jul 2021 16:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315591;
        bh=fZKqr2rL8TM+9eV1GqzW/W27kCfPeWVYClz/ASEuFG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yV5r4h9biV3Edm7CKKdOrPgx8Q510rYd7gcJkhAXzfOcNcyJwhP9l5z2Q4FDy+1rD
         85d43r7uvFTq66KI8ZLcbeB++lMJdvJ3Csuxno9BzaD5izb7jOAbImDA2uvtK5NhMv
         MarGxYv8nIbrDAdF4ABoc9fJq4l2AS19AQyt976o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 158/167] net: dsa: mv88e6xxx: enable SerDes PCS register dump via ethtool -d on Topaz
Date:   Mon, 26 Jul 2021 17:39:51 +0200
Message-Id: <20210726153844.715233504@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
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
@@ -3436,6 +3436,8 @@ static const struct mv88e6xxx_ops mv88e6
 	.serdes_get_sset_count = mv88e6390_serdes_get_sset_count,
 	.serdes_get_strings = mv88e6390_serdes_get_strings,
 	.serdes_get_stats = mv88e6390_serdes_get_stats,
+	.serdes_get_regs_len = mv88e6390_serdes_get_regs_len,
+	.serdes_get_regs = mv88e6390_serdes_get_regs,
 	.phylink_validate = mv88e6341_phylink_validate,
 };
 
@@ -4211,6 +4213,8 @@ static const struct mv88e6xxx_ops mv88e6
 	.serdes_get_sset_count = mv88e6390_serdes_get_sset_count,
 	.serdes_get_strings = mv88e6390_serdes_get_strings,
 	.serdes_get_stats = mv88e6390_serdes_get_stats,
+	.serdes_get_regs_len = mv88e6390_serdes_get_regs_len,
+	.serdes_get_regs = mv88e6390_serdes_get_regs,
 	.phylink_validate = mv88e6341_phylink_validate,
 };
 


