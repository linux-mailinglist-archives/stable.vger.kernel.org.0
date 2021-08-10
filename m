Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0F7C3E7E4F
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbhHJRcZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:32:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:60302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231268AbhHJRcX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:32:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F3E160F94;
        Tue, 10 Aug 2021 17:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628616721;
        bh=3DjrTyv5nsPqasdF4+blUb8lfkFTf1bfNJVxdLYiGAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j2NTd7KSI7y8tGSUhza437A+H/rrmrnscnmkNWz7fb9c1wV7nBeBBaGvzpIIPwuKW
         w8hHnkpegWicP2v5cbQqKiN3WmoHru99KO0RdlpCFcpw8uNUA39sJqNFPTsxO5PFND
         LCW880BQnO0VKeoLqAlZxBG+rjhPBCr6PJRKEmT0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 18/54] net: vxge: fix use-after-free in vxge_device_unregister
Date:   Tue, 10 Aug 2021 19:30:12 +0200
Message-Id: <20210810172944.779403736@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172944.179901509@linuxfoundation.org>
References: <20210810172944.179901509@linuxfoundation.org>
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
index 5ae3fa82909f..0766288e2f38 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-main.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-main.c
@@ -3529,13 +3529,13 @@ static void vxge_device_unregister(struct __vxge_hw_device *hldev)
 
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



