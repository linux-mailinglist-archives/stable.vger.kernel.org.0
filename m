Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 715AE1AA0EA
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 14:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S369649AbgDOMcr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 08:32:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:37406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409081AbgDOLob (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:44:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D882B21707;
        Wed, 15 Apr 2020 11:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586951069;
        bh=CPSe29ViT0r704qAM5xHTZXfN6dqqCW5YxUuPD2sLW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dtgi+IyDH09eSTsmALyjLP39BkLnbrQE+xco/FR8bCW1e9dOKdtBx8aSPSjjHk3RV
         T/UfYpoGpqHWtiH4vV1mdnq3dQEqaGBcVbBp+uaNqiooT1LfmWbznTvzjsWzIcSi3/
         hmMiIglARfQbTi2gG8ShJSkgMnVYGEr2cRGPO7PY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pi-Hsun Shih <pihsun@chromium.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.5 101/106] platform/chrome: cros_ec_rpmsg: Fix race with host event
Date:   Wed, 15 Apr 2020 07:42:21 -0400
Message-Id: <20200415114226.13103-101-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114226.13103-1-sashal@kernel.org>
References: <20200415114226.13103-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pi-Hsun Shih <pihsun@chromium.org>

[ Upstream commit f775ac78fcfc6bdc96bdda07029d11f2a5e84869 ]

Host event can be sent by remoteproc by any time, and
cros_ec_rpmsg_callback would be called after cros_ec_rpmsg_create_ept.
But the cros_ec_device is initialized after that, which cause host event
handler to use cros_ec_device that are not initialized properly yet.

Fix this by don't schedule host event handler before cros_ec_register
returns. Instead, remember that we have a pending host event, and
schedule host event handler after cros_ec_register.

Fixes: 71cddb7097e2 ("platform/chrome: cros_ec_rpmsg: Fix race with host command when probe failed.")
Signed-off-by: Pi-Hsun Shih <pihsun@chromium.org>
Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/cros_ec_rpmsg.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/chrome/cros_ec_rpmsg.c b/drivers/platform/chrome/cros_ec_rpmsg.c
index bd068afe43b53..1b38bc8e164c3 100644
--- a/drivers/platform/chrome/cros_ec_rpmsg.c
+++ b/drivers/platform/chrome/cros_ec_rpmsg.c
@@ -42,6 +42,8 @@ struct cros_ec_rpmsg {
 	struct completion xfer_ack;
 	struct work_struct host_event_work;
 	struct rpmsg_endpoint *ept;
+	bool has_pending_host_event;
+	bool probe_done;
 };
 
 /**
@@ -175,7 +177,14 @@ static int cros_ec_rpmsg_callback(struct rpmsg_device *rpdev, void *data,
 		memcpy(ec_dev->din, resp->data, len);
 		complete(&ec_rpmsg->xfer_ack);
 	} else if (resp->type == HOST_EVENT_MARK) {
-		schedule_work(&ec_rpmsg->host_event_work);
+		/*
+		 * If the host event is sent before cros_ec_register is
+		 * finished, queue the host event.
+		 */
+		if (ec_rpmsg->probe_done)
+			schedule_work(&ec_rpmsg->host_event_work);
+		else
+			ec_rpmsg->has_pending_host_event = true;
 	} else {
 		dev_warn(ec_dev->dev, "rpmsg received invalid type = %d",
 			 resp->type);
@@ -238,6 +247,11 @@ static int cros_ec_rpmsg_probe(struct rpmsg_device *rpdev)
 		return ret;
 	}
 
+	ec_rpmsg->probe_done = true;
+
+	if (ec_rpmsg->has_pending_host_event)
+		schedule_work(&ec_rpmsg->host_event_work);
+
 	return 0;
 }
 
-- 
2.20.1

