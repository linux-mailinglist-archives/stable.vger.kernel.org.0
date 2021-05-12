Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC79A37CC23
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234955AbhELQnC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:43:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:55800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242461AbhELQev (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:34:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 018E261973;
        Wed, 12 May 2021 15:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835178;
        bh=AU8BdlX6r6JvG4Iev0e1gijtSbHKk0qiK/xH1Vqw/BU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E9cSemgYTWEc163uqZYjR4ujNS6OLv6jbE44K2Y9ikUDtm0MWZJD2yfInj5JE4HOJ
         +bd8il/5Odxn7n7ToOc0f02JcWE18lXEFSLneM9cc5+bt+7x62L+ivAMYI59GSN57f
         8SXtC0Ew17VWzPBmD7V4nDJ/05EIkrEePGsbf6IU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 240/677] phy: ralink: phy-mt7621-pci: fix XTAL bitmask
Date:   Wed, 12 May 2021 16:44:46 +0200
Message-Id: <20210512144845.210862581@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergio Paracuellos <sergio.paracuellos@gmail.com>

[ Upstream commit 982313c38f2f3793b6435ff50997ae96a2274f5a ]

When this was rewriten to get mainlined and start to
use 'linux/bitfield.h' headers, XTAL_MASK was wrong.
It must mask three bits but only two were used. Hence
properly fix it to make things work.

Fixes: d87da32372a0 ("phy: ralink: Add PHY driver for MT7621 PCIe PHY")
Signed-off-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
Link: https://lore.kernel.org/r/20210302105412.16221-1-sergio.paracuellos@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/ralink/phy-mt7621-pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/ralink/phy-mt7621-pci.c b/drivers/phy/ralink/phy-mt7621-pci.c
index 9a610b414b1f..84ee2b5c2228 100644
--- a/drivers/phy/ralink/phy-mt7621-pci.c
+++ b/drivers/phy/ralink/phy-mt7621-pci.c
@@ -62,7 +62,7 @@
 
 #define RG_PE1_FRC_MSTCKDIV			BIT(5)
 
-#define XTAL_MASK				GENMASK(7, 6)
+#define XTAL_MASK				GENMASK(8, 6)
 
 #define MAX_PHYS	2
 
-- 
2.30.2



