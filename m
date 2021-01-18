Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 143B72F9B15
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 09:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387617AbhARIQm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 03:16:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387610AbhARIQl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jan 2021 03:16:41 -0500
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [IPv6:2001:4b98:dc2:55:216:3eff:fef7:d647])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 694BCC061573;
        Mon, 18 Jan 2021 00:16:00 -0800 (PST)
Received: from deskari.lan (91-157-208-71.elisa-laajakaista.fi [91.157.208.71])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 4D9C22BB;
        Mon, 18 Jan 2021 09:15:58 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1610957758;
        bh=NY67C730CbIloBFeIkqctx6ZpjM0PzbrQOWMiGMqJes=;
        h=From:To:Cc:Subject:Date:From;
        b=hYgPp3QmZOK36l+s0QWZt6pERI3sVRRt/jw40vY2WyWhywpcoHpbWn4DDO9uijoHG
         YVi/PNz4hAMPrjxbHtIqkuLvJsfZLdYppZucBsEdotwrvYrQwjn0O8TzqcrZcJEaXN
         D8b9tRYq9cySJ4ngyHwBjtTUZxCTM4FnYjJnoDuM=
From:   Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
To:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        linux-media@vger.kernel.org
Cc:     Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
        stable@vger.kernel.org
Subject: [PATCH] media: i2c: max9286: fix access to unallocated memory
Date:   Mon, 18 Jan 2021 10:14:46 +0200
Message-Id: <20210118081446.46555-1-tomi.valkeinen@ideasonboard.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The asd allocated with v4l2_async_notifier_add_fwnode_subdev() must be
of size max9286_asd, otherwise access to max9286_asd->source will go to
unallocated memory.

Fixes: 86d37bf31af6 ("media: i2c: max9286: Allocate v4l2_async_subdev dynamically")
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Cc: stable@vger.kernel.org # v5.10+
---
 drivers/media/i2c/max9286.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/max9286.c b/drivers/media/i2c/max9286.c
index c82c1493e099..b1e2476d3c9e 100644
--- a/drivers/media/i2c/max9286.c
+++ b/drivers/media/i2c/max9286.c
@@ -580,7 +580,7 @@ static int max9286_v4l2_notifier_register(struct max9286_priv *priv)
 
 		asd = v4l2_async_notifier_add_fwnode_subdev(&priv->notifier,
 							    source->fwnode,
-							    sizeof(*asd));
+							    sizeof(struct max9286_asd));
 		if (IS_ERR(asd)) {
 			dev_err(dev, "Failed to add subdev for source %u: %ld",
 				i, PTR_ERR(asd));
-- 
2.25.1

