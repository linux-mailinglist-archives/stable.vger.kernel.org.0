Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E98EB10BE2E
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:34:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729583AbfK0VeZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:34:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:37306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730412AbfK0Uu5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:50:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1C9421871;
        Wed, 27 Nov 2019 20:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887857;
        bh=wu8iWbB/vI5j91N6tp1uS1uxExscGnc+y38dgtOkPU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y/eLl+RZPL83SVWckG/gNA/xtLOMId5ATqtIQPY43PzIamoJbmOW2/eI0kahfAVbU
         EA8Kbfj9Gi0iawtTZ5i9hK/pQhSgfArTx/GO+JCedtNlVxiD2Fwg6hO5Nne6PXHOaW
         XveOo1LMfWS+OwqEl+7j1Cl4BZGKRIixMByADrdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Gerd W. Haeussler" <gerd.haeussler@cesys-it.com>,
        Jon Mason <jdmason@kudzu.us>,
        Dave Jiang <dave.jiang@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 121/211] ntb_netdev: fix sleep time mismatch
Date:   Wed, 27 Nov 2019 21:30:54 +0100
Message-Id: <20191127203105.588112666@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
References: <20191127203049.431810767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jon Mason <jdmason@kudzu.us>

[ Upstream commit a861594b1b7ffd630f335b351c4e9f938feadb8e ]

The tx_time should be in usecs (according to the comment above the
variable), but the setting of the timer during the rearming is done in
msecs.  Change it to match the expected units.

Fixes: e74bfeedad08 ("NTB: Add flow control to the ntb_netdev")
Suggested-by: Gerd W. Haeussler <gerd.haeussler@cesys-it.com>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Acked-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ntb_netdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ntb_netdev.c b/drivers/net/ntb_netdev.c
index 0250aa9ae2cbc..97bf49ad81a6d 100644
--- a/drivers/net/ntb_netdev.c
+++ b/drivers/net/ntb_netdev.c
@@ -236,7 +236,7 @@ static void ntb_netdev_tx_timer(unsigned long data)
 	struct ntb_netdev *dev = netdev_priv(ndev);
 
 	if (ntb_transport_tx_free_entry(dev->qp) < tx_stop) {
-		mod_timer(&dev->tx_timer, jiffies + msecs_to_jiffies(tx_time));
+		mod_timer(&dev->tx_timer, jiffies + usecs_to_jiffies(tx_time));
 	} else {
 		/* Make sure anybody stopping the queue after this sees the new
 		 * value of ntb_transport_tx_free_entry()
-- 
2.20.1



