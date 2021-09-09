Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED539404E53
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244985AbhIIMLG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:11:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:47660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343978AbhIIMG0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:06:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B340A6124C;
        Thu,  9 Sep 2021 11:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188047;
        bh=TRyJTAInw6CXkUix/RXhHzQyJsQtbUZ90uYPuhbnlgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E79K5bAFmWY7dg4mm7IiRoXinDjLfemmHkNsha//LS8pGN50KCn23DjiRciAc3i8k
         8Je3473/frqPHtpf8api0jMIENFZ/JH9HDEYaWpsbc+UIOZ2snxJZM67ORGUJOxlAx
         6zO4o/53hayRd4SZFroYXVfP7ZWV97nLlyt8D3kKieN+rabvx92tP9xDeMezMspKtT
         MG1aFbOdONzmnlmuBDGGX0nwUy9jPs7dYZ+XGvQNA5Ys/6lemoS90UK4NXyIH5WENI
         qXBzydZ+V2f2ivOM6RO0GG1/5xq+ILIFPoH38UKH3Th51sAeeMrZcFZGQ4msckMo60
         OcRqq0IK8FGDQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.13 040/219] bus: fsl-mc: fix arg in call to dprc_scan_objects()
Date:   Thu,  9 Sep 2021 07:43:36 -0400
Message-Id: <20210909114635.143983-40-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
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
index 380ad1fdb745..74faaf3e4e27 100644
--- a/drivers/bus/fsl-mc/fsl-mc-bus.c
+++ b/drivers/bus/fsl-mc/fsl-mc-bus.c
@@ -219,7 +219,7 @@ static int scan_fsl_mc_bus(struct device *dev, void *data)
 	root_mc_dev = to_fsl_mc_device(dev);
 	root_mc_bus = to_fsl_mc_bus(root_mc_dev);
 	mutex_lock(&root_mc_bus->scan_mutex);
-	dprc_scan_objects(root_mc_dev, NULL);
+	dprc_scan_objects(root_mc_dev, false);
 	mutex_unlock(&root_mc_bus->scan_mutex);
 
 exit:
-- 
2.30.2

