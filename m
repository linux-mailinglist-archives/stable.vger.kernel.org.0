Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D862320E2D4
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732206AbgF2VJF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:09:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:45464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730326AbgF2TAT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:00:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F5BE254C6;
        Mon, 29 Jun 2020 15:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593446020;
        bh=w3TFxo/9VyhZfB+HgR6d7F51RKl8eRTq06YPoX5tZuI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cRIEdwWpVzo+P+SOwdr/RX0OXF/BZnipd1x46kuY/FIJbO1X8ZfOOJuYt/Ehyqg+k
         l22sBEruBOJd9fe6XsMyhzj3ZuN7j7fOmXUoXO4gEy0mxu2iJ8CxML8is4IDq8dvdt
         5wsOEuufg9QTKZwfZN1F2ADuagx66YtWMPoWQ5aU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Osipenko <digetx@gmail.com>,
        David Heidelberg <david@ixit.cz>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 027/135] power: supply: smb347-charger: IRQSTAT_D is volatile
Date:   Mon, 29 Jun 2020 11:51:21 -0400
Message-Id: <20200629155309.2495516-28-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629155309.2495516-1-sashal@kernel.org>
References: <20200629155309.2495516-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:53+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit c32ea07a30630ace950e07ffe7a18bdcc25898e1 ]

Fix failure when USB cable is connected:
smb347 2-006a: reading IRQSTAT_D failed

Fixes: 1502cfe19bac ("smb347-charger: Fix battery status reporting logic for charger faults")

Tested-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/smb347-charger.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/power/smb347-charger.c b/drivers/power/smb347-charger.c
index 072c5189bd6d1..0655dbdc7000d 100644
--- a/drivers/power/smb347-charger.c
+++ b/drivers/power/smb347-charger.c
@@ -1141,6 +1141,7 @@ static bool smb347_volatile_reg(struct device *dev, unsigned int reg)
 	switch (reg) {
 	case IRQSTAT_A:
 	case IRQSTAT_C:
+	case IRQSTAT_D:
 	case IRQSTAT_E:
 	case IRQSTAT_F:
 	case STAT_A:
-- 
2.25.1

