Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63A40272E53
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729644AbgIUQsJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:48:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:55442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729813AbgIUQsI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:48:08 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70250238D7;
        Mon, 21 Sep 2020 16:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706887;
        bh=UKno+OfoKWcMw03cOeLGzo/sZOEDnGfMcq5uX14k7HI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ed3NiTz/k4pR+cuGt2ZISKj2eJEQ4StNouQeDOOxiDNBvJlgE7ib8QqhHUO2U2NET
         o01IeCRiN48uHPmhHhR3z3rsuNFrzeG7FBRUTeE7m6LIMbph6RHvmePP+JrNKi6UfF
         YINt25u1PpPVN/hrTGLjZd/WnowIUmnuDIQZaqH8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 16/72] rapidio: Replace select DMAENGINES with depends on
Date:   Mon, 21 Sep 2020 18:30:55 +0200
Message-Id: <20200921163122.647738250@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921163121.870386357@linuxfoundation.org>
References: <20200921163121.870386357@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit d2b86100245080cfdf1e95e9e07477474c1be2bd ]

Enabling a whole subsystem from a single driver 'select' is frowned
upon and won't be accepted in new drivers, that need to use 'depends on'
instead. Existing selection of DMAENGINES will then cause circular
dependencies. Replace them with a dependency.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rapidio/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rapidio/Kconfig b/drivers/rapidio/Kconfig
index 677d1aff61b7f..788e7830771be 100644
--- a/drivers/rapidio/Kconfig
+++ b/drivers/rapidio/Kconfig
@@ -37,7 +37,7 @@ config RAPIDIO_ENABLE_RX_TX_PORTS
 config RAPIDIO_DMA_ENGINE
 	bool "DMA Engine support for RapidIO"
 	depends on RAPIDIO
-	select DMADEVICES
+	depends on DMADEVICES
 	select DMA_ENGINE
 	help
 	  Say Y here if you want to use DMA Engine frameork for RapidIO data
-- 
2.25.1



