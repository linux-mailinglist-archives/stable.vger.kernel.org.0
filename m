Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F970451ECA
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347141AbhKPAhc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:37:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:45224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344787AbhKOTZ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B37B63327;
        Mon, 15 Nov 2021 19:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003061;
        bh=DBBQlRGGKcNTH9lwqZ9/8RTUFWhe5wO9et+EjbBSE6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m5iPmoe4TOq0QT0LRNx3Dmk3fjN3oVFIn9OonkUew7Zlu5cofQ+mfquIQ8GoI/lLg
         YCWXnJbnTDvIqrBasq506zM4Ezc3SPTIdytvoKueqvc5ZrW+uW3KHx5PnXOaAzFPRG
         TFFr4uAI2EdQkcBmE/c4hRJ7n7FNTurARWs/k+EU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 796/917] octeontx2-pf: select CONFIG_NET_DEVLINK
Date:   Mon, 15 Nov 2021 18:04:51 +0100
Message-Id: <20211115165455.965363850@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 9cbc3367968de69017a87a1118b62490ac1bdd0a ]

The octeontx2 pf nic driver failsz to link when the devlink support
is not reachable:

aarch64-linux-ld: drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.o: in function `otx2_dl_mcam_count_get':
otx2_devlink.c:(.text+0x10): undefined reference to `devlink_priv'
aarch64-linux-ld: drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.o: in function `otx2_dl_mcam_count_validate':
otx2_devlink.c:(.text+0x50): undefined reference to `devlink_priv'
aarch64-linux-ld: drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.o: in function `otx2_dl_mcam_count_set':
otx2_devlink.c:(.text+0xd0): undefined reference to `devlink_priv'
aarch64-linux-ld: drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.o: in function `otx2_devlink_info_get':
otx2_devlink.c:(.text+0x150): undefined reference to `devlink_priv'

This is already selected by the admin function driver, but not the
actual nic, which might be built-in when the af driver is not.

Fixes: 2da489432747 ("octeontx2-pf: devlink params support to set mcam entry count")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/Kconfig b/drivers/net/ethernet/marvell/octeontx2/Kconfig
index 3f982ccf2c85f..639893d870550 100644
--- a/drivers/net/ethernet/marvell/octeontx2/Kconfig
+++ b/drivers/net/ethernet/marvell/octeontx2/Kconfig
@@ -31,6 +31,7 @@ config NDC_DIS_DYNAMIC_CACHING
 config OCTEONTX2_PF
 	tristate "Marvell OcteonTX2 NIC Physical Function driver"
 	select OCTEONTX2_MBOX
+	select NET_DEVLINK
 	depends on (64BIT && COMPILE_TEST) || ARM64
 	depends on PCI
 	depends on PTP_1588_CLOCK_OPTIONAL
-- 
2.33.0



