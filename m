Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2601C9058
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 16:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727801AbgEGOiq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 10:38:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:53226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726661AbgEGO1c (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 10:27:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53B362084D;
        Thu,  7 May 2020 14:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588861652;
        bh=qLMtgJ8/c8TWxpBnHlwaeabkMU4VuzzyZFVVfNFrxxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dqEKIpu7v7wHdJl4Zjv6W9EdmzWExlFLABijIF/AdIZLjyPQTBcA867VAGWZdbJBg
         I+naw1oUVVBs2eQ6CLdB4bSzjZ/AGlO14Qc7ii6dwA5IYpswVukwFGHoSfNB9//y1m
         r0m9jmhp5BbnAhmzWOXGN7hhymBaxhw+PgH0GOHA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 04/50] dmaengine: ti: k3-psil: fix deadlock on error path
Date:   Thu,  7 May 2020 10:26:40 -0400
Message-Id: <20200507142726.25751-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200507142726.25751-1-sashal@kernel.org>
References: <20200507142726.25751-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

[ Upstream commit 172d59ecd61b89f535ad99a7e531c0f111453b9a ]

The mutex_unlock() is missed on error path of psil_get_ep_config()
which causes deadlock, so add missed mutex_unlock().

Fixes: 8c6bb62f6b4a ("dmaengine: ti: k3 PSI-L remote endpoint configuration")
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Link: https://lore.kernel.org/r/20200408185501.30776-1-grygorii.strashko@ti.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ti/k3-psil.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/ti/k3-psil.c b/drivers/dma/ti/k3-psil.c
index d7b965049ccb1..fb7c8150b0d1d 100644
--- a/drivers/dma/ti/k3-psil.c
+++ b/drivers/dma/ti/k3-psil.c
@@ -27,6 +27,7 @@ struct psil_endpoint_config *psil_get_ep_config(u32 thread_id)
 			soc_ep_map = &j721e_ep_map;
 		} else {
 			pr_err("PSIL: No compatible machine found for map\n");
+			mutex_unlock(&ep_map_mutex);
 			return ERR_PTR(-ENOTSUPP);
 		}
 		pr_debug("%s: Using map for %s\n", __func__, soc_ep_map->name);
-- 
2.20.1

