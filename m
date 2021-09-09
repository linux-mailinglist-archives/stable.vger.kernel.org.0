Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69BAD404A1C
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 13:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237632AbhIILor (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 07:44:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:46516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238374AbhIILnc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:43:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7846F61208;
        Thu,  9 Sep 2021 11:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187728;
        bh=FwX7FN7wCZQNTgYk6lhZ1YOTC7+64UlCreJtVCO1vOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IpYi3sBmzpQeU7JVaiIdDIr9psOuZGKg6+AMRmJ2K+hG5AYOYncgtYuEU2Oji0CV2
         TJZy53Tzz//iquD0JBPzlPhZLxLzr5ktTdL2t2Tpm6SZUtobVDJSUGTGOe7YSe9RmH
         ldBGJkZZJOKhfuUAP5+QHhhgTNPas/aQx434rNWw5qOWQ5ZE+L3GG0mA0YO108P1zq
         6TphcBJC/kvwDm3XBQ8LlV1KHt5cMcgUzYnNSUt5lXDyAJpb6aMyAuEumkBrKlc441
         0+aQAi0iIoBMuvTqCc0hSHXyjc4Wy5LZmYy7szv8uKYgCY+TpBN38AUl09FWS+IMf5
         55IRxv1OOTIog==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.14 048/252] bus: fsl-mc: fix arg in call to dprc_scan_objects()
Date:   Thu,  9 Sep 2021 07:37:42 -0400
Message-Id: <20210909114106.141462-48-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

