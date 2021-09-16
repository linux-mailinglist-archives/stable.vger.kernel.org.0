Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C77B940E71B
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350881AbhIPR2k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:28:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:47064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351008AbhIPR0k (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:26:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78BF361A54;
        Thu, 16 Sep 2021 16:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810695;
        bh=FwX7FN7wCZQNTgYk6lhZ1YOTC7+64UlCreJtVCO1vOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C98PvXdwmdXLNfnevG05BvllYgDOXYIgxcHwzSsaFEZHu+py1muX/adYE4Ly0O+ib
         55Bff+n0ktMvY45SSEJqc3oZaZX0fjNUPwgnTwUDvXDGg3EzYi2jE0NE+4Zk4xV7B5
         uPsBhoBaUhh3Pdpt1Q740knDKMyVPV7R7OBnHHqg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 202/432] bus: fsl-mc: fix arg in call to dprc_scan_objects()
Date:   Thu, 16 Sep 2021 17:59:11 +0200
Message-Id: <20210916155817.660066825@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurentiu Tudor <laurentiu.tudor@nxp.com>

[ Upstream commit aa0a1ae020e2d24749e9f8085f12ca6d46899c94 ]

Second parameter of dprc_scan_objects() is a bool not a pointer
so change from NULL to false.

Signed-off-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
Link: https://lore.kernel.org/r/20210715140718.8513-1-laurentiu.tudor@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/fsl-mc/fsl-mc-bus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bus/fsl-mc/fsl-mc-bus.c b/drivers/bus/fsl-mc/fsl-mc-bus.c
index 09c8ab5e0959..ffec838450f3 100644
--- a/drivers/bus/fsl-mc/fsl-mc-bus.c
+++ b/drivers/bus/fsl-mc/fsl-mc-bus.c
@@ -220,7 +220,7 @@ static int scan_fsl_mc_bus(struct device *dev, void *data)
 	root_mc_dev = to_fsl_mc_device(dev);
 	root_mc_bus = to_fsl_mc_bus(root_mc_dev);
 	mutex_lock(&root_mc_bus->scan_mutex);
-	dprc_scan_objects(root_mc_dev, NULL);
+	dprc_scan_objects(root_mc_dev, false);
 	mutex_unlock(&root_mc_bus->scan_mutex);
 
 exit:
-- 
2.30.2



