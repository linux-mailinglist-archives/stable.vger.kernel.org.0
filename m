Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A51063D290C
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233828AbhGVQAw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:00:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:35404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233250AbhGVP6S (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:58:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 213E96138C;
        Thu, 22 Jul 2021 16:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626971933;
        bh=8REEDGipbr9mTvWuq5PaPNgjliagseRwWEoaLK1hhT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SwGac6dcnzasvzEIljJQhHzKfNIfuU7MJwG+XJcEMIPIfpAtPE4EVlTU1B1f9gwqG
         grzbTYEOCxDUBKJIfZCIpg6PKL8kvFxByLjueUUMzpQQp7O/EweVwATSc0g+qSQwav
         ePLRu4UZ7aOf/nngT+y8mfd4tgcEkc6wvD1AxWWsLkR7oI0bfczmyvAK2YJ6+Dg/cc
         1EdvGHVCcmTHDbelRLHBLT15vDuIA7D+IUGkssS9jMe3N1m/xPEP7G9unllT3ALi9/
         wucQEZ+L/o4sISz4fi/QLn4GhtaG44Pjaro+UPwAdOzCXFalS36p7BXxucxH/HkBb1
         5c9lsSH+bQ2Jg==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 2/2] net: dsa: mv88e6xxx: enable SerDes PCS register dump via ethtool -d on Topaz
Date:   Thu, 22 Jul 2021 18:38:48 +0200
Message-Id: <20210722163848.23080-2-kabel@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210722163848.23080-1-kabel@kernel.org>
References: <20210722163848.23080-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/net/dsa/mv88e6xxx/chip.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 8029e76b0745..184cbc93328c 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3436,6 +3436,8 @@ static const struct mv88e6xxx_ops mv88e6141_ops = {
 	.serdes_get_sset_count = mv88e6390_serdes_get_sset_count,
 	.serdes_get_strings = mv88e6390_serdes_get_strings,
 	.serdes_get_stats = mv88e6390_serdes_get_stats,
+	.serdes_get_regs_len = mv88e6390_serdes_get_regs_len,
+	.serdes_get_regs = mv88e6390_serdes_get_regs,
 	.phylink_validate = mv88e6341_phylink_validate,
 };
 
@@ -4211,6 +4213,8 @@ static const struct mv88e6xxx_ops mv88e6341_ops = {
 	.serdes_get_sset_count = mv88e6390_serdes_get_sset_count,
 	.serdes_get_strings = mv88e6390_serdes_get_strings,
 	.serdes_get_stats = mv88e6390_serdes_get_stats,
+	.serdes_get_regs_len = mv88e6390_serdes_get_regs_len,
+	.serdes_get_regs = mv88e6390_serdes_get_regs,
 	.phylink_validate = mv88e6341_phylink_validate,
 };
 
-- 
2.31.1

