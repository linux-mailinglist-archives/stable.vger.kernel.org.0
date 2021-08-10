Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A65103E817E
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 20:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234354AbhHJSAE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 14:00:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:60680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234908AbhHJR57 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:57:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4EA1461391;
        Tue, 10 Aug 2021 17:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617535;
        bh=mtHvomnz+GOQ0h9ygikC2fB+8jfm/bjDlMaEj3vsUxQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FuLvPSnIimWQ1QATxMeYfUlSfpfsLCaQz+K/mIolSnNFyVhZWEYJ6R32XGV/jEvNc
         ADqUNQzCJBab3x/CRmySzfMTpo5k7DWB9Zf8CQQsJHdenYNU0TiT9hNdcQ3oEDywTY
         7qCaH/G2cdLAp9pYTYR1oC7s3Wu/d7+nMc6mYsLc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 068/175] net: vxge: fix use-after-free in vxge_device_unregister
Date:   Tue, 10 Aug 2021 19:29:36 +0200
Message-Id: <20210810173003.176319173@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit 942e560a3d3862dd5dee1411dbdd7097d29b8416 ]

Smatch says:
drivers/net/ethernet/neterion/vxge/vxge-main.c:3518 vxge_device_unregister() error: Using vdev after free_{netdev,candev}(dev);
drivers/net/ethernet/neterion/vxge/vxge-main.c:3518 vxge_device_unregister() error: Using vdev after free_{netdev,candev}(dev);
drivers/net/ethernet/neterion/vxge/vxge-main.c:3520 vxge_device_unregister() error: Using vdev after free_{netdev,candev}(dev);
drivers/net/ethernet/neterion/vxge/vxge-main.c:3520 vxge_device_unregister() error: Using vdev after free_{netdev,candev}(dev);

Since vdev pointer is netdev private data accessing it after free_netdev()
call can cause use-after-free bug. Fix it by moving free_netdev() call at
the end of the function

Fixes: 6cca200362b4 ("vxge: cleanup probe error paths")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/neterion/vxge/vxge-main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/neterion/vxge/vxge-main.c b/drivers/net/ethernet/neterion/vxge/vxge-main.c
index 87892bd992b1..56556373548c 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-main.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-main.c
@@ -3527,13 +3527,13 @@ static void vxge_device_unregister(struct __vxge_hw_device *hldev)
 
 	kfree(vdev->vpaths);
 
-	/* we are safe to free it now */
-	free_netdev(dev);
-
 	vxge_debug_init(vdev->level_trace, "%s: ethernet device unregistered",
 			buf);
 	vxge_debug_entryexit(vdev->level_trace,	"%s: %s:%d  Exiting...", buf,
 			     __func__, __LINE__);
+
+	/* we are safe to free it now */
+	free_netdev(dev);
 }
 
 /*
-- 
2.30.2



