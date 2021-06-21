Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B77A03AEF51
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232772AbhFUQhe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:37:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:56006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233259AbhFUQfc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:35:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C346861353;
        Mon, 21 Jun 2021 16:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292883;
        bh=3M0J0Y2bv0GuS+70jx5FFKCRi3uIvUvVg8zz4e0UaxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PyhaLvUqIPBAfNryGWNKNqwBIGNrmyGJhkxdMjM7VhOyCyUejJHY8Cr1osszHFfdP
         zJQcs96aG8IpJFBaJaKVv9ZMTGKqiZF34o6iIz59uspHN3lBNbwhNqstErUjO//BUQ
         m5DnDQHCc3YXUqc3+GsXZD4o1b8w7aJdOyBgkFa8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 002/178] dmaengine: idxd: add missing dsa driver unregister
Date:   Mon, 21 Jun 2021 18:13:36 +0200
Message-Id: <20210621154921.365513351@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 077cdb355b3d8ee0f258856962e6dac06e744401 ]

The idxd_unregister_driver() has never been called for the idxd driver upon
removal. Add fix to call unregister driver on module removal.

Fixes: c52ca478233c ("dmaengine: idxd: add configuration component of driver")
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/161947994449.1053102.13189942817915448216.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/idxd/init.c b/drivers/dma/idxd/init.c
index f73677490b6c..eb41bb9df0fd 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -719,6 +719,7 @@ module_init(idxd_init_module);
 
 static void __exit idxd_exit_module(void)
 {
+	idxd_unregister_driver();
 	pci_unregister_driver(&idxd_pci_driver);
 	idxd_cdev_remove();
 	idxd_unregister_bus_type();
-- 
2.30.2



