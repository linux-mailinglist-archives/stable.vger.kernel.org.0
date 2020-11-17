Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D72FE2B6371
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733041AbgKQNiO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:38:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:49418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732279AbgKQNiN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:38:13 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD67220870;
        Tue, 17 Nov 2020 13:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620292;
        bh=6iOxNDJRpZRddC+e2/LAvY92XRl6JIkcy/8/Q7+pMU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FWWXtsF/RUmssVSj+9w49gIo2cOZpMeh8WTqnl/w0JT9Fj1bSP79h1XYndclxvlQP
         pEvxFO6hHYpVcAUFl/8fzhQuq5eSMS0PInZND1G3m6ox0mT6hBFLz5OIa/8k0FsG4O
         FraLSiPPLuXhr/3bzryERwL0Le4Mi9hP7xm5oPag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Sven Van Asbroeck <thesven73@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 171/255] lan743x: fix use of uninitialized variable
Date:   Tue, 17 Nov 2020 14:05:11 +0100
Message-Id: <20201117122147.256254115@linuxfoundation.org>
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

From: Sven Van Asbroeck <thesven73@gmail.com>

[ Upstream commit edbc21113bde13ca3d06eec24b621b1f628583dd ]

When no devicetree is present, the driver will use an
uninitialized variable.

Fix by initializing this variable.

Fixes: 902a66e08cea ("lan743x: correctly handle chips with internal PHY")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>
Link: https://lore.kernel.org/r/20201112152513.1941-1-TheSven73@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/lan743x_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 6c25c7c8b7cf8..bc368136bccc6 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -1015,8 +1015,8 @@ static void lan743x_phy_close(struct lan743x_adapter *adapter)
 static int lan743x_phy_open(struct lan743x_adapter *adapter)
 {
 	struct lan743x_phy *phy = &adapter->phy;
+	struct phy_device *phydev = NULL;
 	struct device_node *phynode;
-	struct phy_device *phydev;
 	struct net_device *netdev;
 	int ret = -EIO;
 
-- 
2.27.0



