Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74D17106CAB
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730011AbfKVKxu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:53:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:38710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730223AbfKVKxq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:53:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7286120715;
        Fri, 22 Nov 2019 10:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420025;
        bh=VgPPyE22Zgxe2jV9lOAP3R21u862evy97/e4M8bGaoo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YO5UZEaydh7/+gcEwQZIsvQNhVrnFs4AlM7T2ffuVwhA2URPTwgdYnCfVIZYoZCTF
         AkG80dnYtFi1b9uZhNwB3NvxakRnq/5Oy0AktxaV1jdZ73wnpnVkVUE7bdu+TH2hOd
         rc0c6SgX98FpeAlHnSd1nY9d8R7p4apnjrRaFvOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 091/122] reset: Fix potential use-after-free in __of_reset_control_get()
Date:   Fri, 22 Nov 2019 11:29:04 +0100
Message-Id: <20191122100828.274593621@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100722.177052205@linuxfoundation.org>
References: <20191122100722.177052205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index da4292e9de978..72b96b5c75a8f 100644
--- a/drivers/reset/core.c
+++ b/drivers/reset/core.c
@@ -466,28 +466,29 @@ struct reset_control *__of_reset_control_get(struct device_node *node,
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



