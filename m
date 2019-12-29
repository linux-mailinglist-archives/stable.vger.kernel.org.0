Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 842FF12C7FC
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731206AbfL2Rtb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:49:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:33326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727287AbfL2Rtb (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:49:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60FE120718;
        Sun, 29 Dec 2019 17:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641770;
        bh=iaRKoO/NwOSQZ2zS1eIaHYnh0kIVL7zYHYUjEcLWo2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WzgGrJu1jp7gLwYsV5PfAfzPPb3+gJwGLo1WqzbF6KAQDx4Tb3KyK9rR2M1hd2VFD
         Mbo9QRCZ2QEOw0LEcUKJ0ZbmMG1aluQS1fX1SrXAaxDfQOUkhI/tFCp6EUD715U+fP
         OMNtawfbdWtHLX7GW1SHLtBSgceqoOrczCU4d5Kk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mao Wenan <maowenan@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 205/434] net: dsa: LAN9303: select REGMAP when LAN9303 enable
Date:   Sun, 29 Dec 2019 18:24:18 +0100
Message-Id: <20191229172715.444896792@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mao Wenan <maowenan@huawei.com>

[ Upstream commit b6989d248a2d13f02895bae1a9321b3bbccc0283 ]

When NET_DSA_SMSC_LAN9303=y and NET_DSA_SMSC_LAN9303_MDIO=y,
below errors can be seen:
drivers/net/dsa/lan9303_mdio.c:87:23: error: REGMAP_ENDIAN_LITTLE
undeclared here (not in a function)
  .reg_format_endian = REGMAP_ENDIAN_LITTLE,
drivers/net/dsa/lan9303_mdio.c:93:3: error: const struct regmap_config
has no member named reg_read
  .reg_read = lan9303_mdio_read,

It should select REGMAP in config NET_DSA_SMSC_LAN9303.

Fixes: dc7005831523 ("net: dsa: LAN9303: add MDIO managed mode support")
Signed-off-by: Mao Wenan <maowenan@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/Kconfig b/drivers/net/dsa/Kconfig
index f6232ce8481f..685e12b05a7c 100644
--- a/drivers/net/dsa/Kconfig
+++ b/drivers/net/dsa/Kconfig
@@ -77,6 +77,7 @@ config NET_DSA_REALTEK_SMI
 config NET_DSA_SMSC_LAN9303
 	tristate
 	select NET_DSA_TAG_LAN9303
+	select REGMAP
 	---help---
 	  This enables support for the SMSC/Microchip LAN9303 3 port ethernet
 	  switch chips.
-- 
2.20.1



