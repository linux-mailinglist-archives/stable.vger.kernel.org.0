Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D063EFA2F1
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:07:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728322AbfKMCHE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 21:07:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:56540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730620AbfKMCA6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 21:00:58 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CFF522478;
        Wed, 13 Nov 2019 02:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610457;
        bh=PupgnrNiJS0Fg2hfrgcB/rrvt8DViF2+rMHAQ5nAC2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JSOj7qsKNGlDn+a2JOLj2pc+BZoF09fXcexsc1ew8pyt9P5F3YBVB6S0n+ARcQG6Z
         Iy2WFSD8RBqeC1WuD/NRFj+zd3fZyujlgik0f7KFH4xlaiYRVPxzEo4QdoSizCasSi
         XAR3zXXkHE7x8+zv+1i6ZqTYzdjLYbLPeBeTciLo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 48/68] reset: Fix potential use-after-free in __of_reset_control_get()
Date:   Tue, 12 Nov 2019 20:59:12 -0500
Message-Id: <20191113015932.12655-48-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015932.12655-1-sashal@kernel.org>
References: <20191113015932.12655-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit b790c8ea5593d6dc3580adfad8e117eeb56af874 ]

Calling of_node_put() decreases the reference count of a device tree
object, and may free some data.

However, the of_phandle_args structure embedding it is passed to
reset_controller_dev.of_xlate() after that, so it may still be accessed.

Move the call to of_node_put() down to fix this.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
[p.zabel@pengutronix.de: moved of_node_put after mutex_unlock]
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/reset/core.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/reset/core.c b/drivers/reset/core.c
index 188205a552613..d0ebca301afc9 100644
--- a/drivers/reset/core.c
+++ b/drivers/reset/core.c
@@ -324,28 +324,29 @@ struct reset_control *__of_reset_control_get(struct device_node *node,
 			break;
 		}
 	}
-	of_node_put(args.np);
 
 	if (!rcdev) {
-		mutex_unlock(&reset_list_mutex);
-		return ERR_PTR(-EPROBE_DEFER);
+		rstc = ERR_PTR(-EPROBE_DEFER);
+		goto out;
 	}
 
 	if (WARN_ON(args.args_count != rcdev->of_reset_n_cells)) {
-		mutex_unlock(&reset_list_mutex);
-		return ERR_PTR(-EINVAL);
+		rstc = ERR_PTR(-EINVAL);
+		goto out;
 	}
 
 	rstc_id = rcdev->of_xlate(rcdev, &args);
 	if (rstc_id < 0) {
-		mutex_unlock(&reset_list_mutex);
-		return ERR_PTR(rstc_id);
+		rstc = ERR_PTR(rstc_id);
+		goto out;
 	}
 
 	/* reset_list_mutex also protects the rcdev's reset_control list */
 	rstc = __reset_control_get_internal(rcdev, rstc_id, shared);
 
+out:
 	mutex_unlock(&reset_list_mutex);
+	of_node_put(args.np);
 
 	return rstc;
 }
-- 
2.20.1

