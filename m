Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 109F836433C
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240401AbhDSNP4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:15:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:47094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240434AbhDSNOK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:14:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE49C613C8;
        Mon, 19 Apr 2021 13:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618837956;
        bh=mABS7goRvXg9TR8gO9YbvkB57ZRPwbCXbA+BP4zQdZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=phtMHKuMKUlg+KYeGk7GegLchDMszPoTsOkJQKaU1ik2EtnbQ9TQQXFnOc71f3Yxc
         jB0i0CpDquBKgPGZ/bOKdSFwhpisvdy7yQmjhMvL9Bfv3Zwbi+qScCfxUBLXL7SaBl
         ITHT2Rs7YCUq+XIkoT2MJHx6oBwqMlDu/OeWa1wA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 115/122] r8169: tweak max read request size for newer chips also in jumbo mtu mode
Date:   Mon, 19 Apr 2021 15:06:35 +0200
Message-Id: <20210419130534.082072819@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130530.166331793@linuxfoundation.org>
References: <20210419130530.166331793@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 5e00e16cb98935bcf06f51931876d898c226f65c ]

So far we don't increase the max read request size if we switch to
jumbo mode before bringing up the interface for the first time.
Let's change this.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 7c1a057dcf3d..47a4ff832d75 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2342,13 +2342,14 @@ static void r8168b_1_hw_jumbo_disable(struct rtl8169_private *tp)
 static void rtl_jumbo_config(struct rtl8169_private *tp)
 {
 	bool jumbo = tp->dev->mtu > ETH_DATA_LEN;
+	int readrq = 4096;
 
 	rtl_unlock_config_regs(tp);
 	switch (tp->mac_version) {
 	case RTL_GIGA_MAC_VER_12:
 	case RTL_GIGA_MAC_VER_17:
 		if (jumbo) {
-			pcie_set_readrq(tp->pci_dev, 512);
+			readrq = 512;
 			r8168b_1_hw_jumbo_enable(tp);
 		} else {
 			r8168b_1_hw_jumbo_disable(tp);
@@ -2356,7 +2357,7 @@ static void rtl_jumbo_config(struct rtl8169_private *tp)
 		break;
 	case RTL_GIGA_MAC_VER_18 ... RTL_GIGA_MAC_VER_26:
 		if (jumbo) {
-			pcie_set_readrq(tp->pci_dev, 512);
+			readrq = 512;
 			r8168c_hw_jumbo_enable(tp);
 		} else {
 			r8168c_hw_jumbo_disable(tp);
@@ -2381,8 +2382,8 @@ static void rtl_jumbo_config(struct rtl8169_private *tp)
 	}
 	rtl_lock_config_regs(tp);
 
-	if (!jumbo && pci_is_pcie(tp->pci_dev) && tp->supports_gmii)
-		pcie_set_readrq(tp->pci_dev, 4096);
+	if (pci_is_pcie(tp->pci_dev) && tp->supports_gmii)
+		pcie_set_readrq(tp->pci_dev, readrq);
 }
 
 DECLARE_RTL_COND(rtl_chipcmd_cond)
-- 
2.30.2



