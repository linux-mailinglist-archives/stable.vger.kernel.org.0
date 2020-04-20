Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE621B0C09
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 15:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728250AbgDTNAJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 09:00:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:33010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727812AbgDTMkk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:40:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B5792070B;
        Mon, 20 Apr 2020 12:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386439;
        bh=etT5MZ8mwbz2xuKce0zzrF5OeDSGl/wFU/I+fVDBueM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y+h4168bVJDCsoTQ/kr1qHxmB3pCJHLQl0lb47sJXVD1xEZMmtMQfO/8YonNgSX6r
         tsmDsQgR4pmdP8cvYOzazjfqxAeFaQp7bhEJ3wuBihVZB09RxA1AhwcHcLxtWpM3B6
         63XZh4XLUJBe696LhRbv1VUPWIzwIc9bi/p/FIHc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pi-Hsun Shih <pihsun@chromium.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>
Subject: [PATCH 5.5 23/65] platform/chrome: cros_ec_rpmsg: Fix race with host event
Date:   Mon, 20 Apr 2020 14:38:27 +0200
Message-Id: <20200420121511.525317370@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121505.909671922@linuxfoundation.org>
References: <20200420121505.909671922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pi-Hsun Shih <pihsun@chromium.org>

commit f775ac78fcfc6bdc96bdda07029d11f2a5e84869 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/chrome/cros_ec_rpmsg.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

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
@@ -175,7 +177,14 @@ static int cros_ec_rpmsg_callback(struct
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
@@ -238,6 +247,11 @@ static int cros_ec_rpmsg_probe(struct rp
 		return ret;
 	}
 
+	ec_rpmsg->probe_done = true;
+
+	if (ec_rpmsg->has_pending_host_event)
+		schedule_work(&ec_rpmsg->host_event_work);
+
 	return 0;
 }
 


