Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5B2676FDE
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:26:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbjAVP0M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:26:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231419AbjAVP0J (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:26:09 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF8022DE3
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:26:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0681DCE0F4D
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:26:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E90F6C433EF;
        Sun, 22 Jan 2023 15:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674401164;
        bh=3NSeHrnmVWXlDkqw2hec1nL838PVPfh73vHfnWMnFFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ga0TuTsTVtu3rCFAanPH6ysZQc4dqrad/OONP0pe8vBzk76Ge6gkjPuxXq9Ae/g4f
         ppwXPDrnJ6uf5lDMdlhky1tAZAh0D1HrZxyWhDYFQnReuUbM8eH1HObL2+6zsEV5d2
         xgc/8NJZgEnCO99EEFex88Y3WY7jrarg/KnUqr6U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Utkarsh Patel <utkarsh.h.patel@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.1 094/193] thunderbolt: Do not call PM runtime functions in tb_retimer_scan()
Date:   Sun, 22 Jan 2023 16:03:43 +0100
Message-Id: <20230122150250.641991086@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit 23257cfc1cb7202fd0065e9f4a6a0aac1c04c4a9 upstream.

We cannot call PM runtime functions in tb_retimer_scan() because it will
also be called when retimers are scanned from userspace (happens when
there is no device connected on ChromeOS for instance) and at the same
USB4 port runtime resume hook. This leads to hang because neither can
proceed.

Fix this by runtime resuming USB4 ports in tb_scan_port() instead. This
makes sure the ports are runtime PM active when retimers are added under
it while avoiding the reported hang as well.

Reported-by: Utkarsh Patel <utkarsh.h.patel@intel.com>
Fixes: 1e56c88adecc ("thunderbolt: Runtime resume USB4 port when retimers are scanned")
Cc: stable@vger.kernel.org
Acked-by: Yehezkel Bernat <YehezkelShB@gmail.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/retimer.c |   17 +++--------------
 drivers/thunderbolt/tb.c      |   20 +++++++++++++++-----
 2 files changed, 18 insertions(+), 19 deletions(-)

--- a/drivers/thunderbolt/retimer.c
+++ b/drivers/thunderbolt/retimer.c
@@ -427,13 +427,6 @@ int tb_retimer_scan(struct tb_port *port
 {
 	u32 status[TB_MAX_RETIMER_INDEX + 1] = {};
 	int ret, i, last_idx = 0;
-	struct usb4_port *usb4;
-
-	usb4 = port->usb4;
-	if (!usb4)
-		return 0;
-
-	pm_runtime_get_sync(&usb4->dev);
 
 	/*
 	 * Send broadcast RT to make sure retimer indices facing this
@@ -441,7 +434,7 @@ int tb_retimer_scan(struct tb_port *port
 	 */
 	ret = usb4_port_enumerate_retimers(port);
 	if (ret)
-		goto out;
+		return ret;
 
 	/*
 	 * Enable sideband channel for each retimer. We can do this
@@ -471,11 +464,11 @@ int tb_retimer_scan(struct tb_port *port
 			break;
 	}
 
-	ret = 0;
 	if (!last_idx)
-		goto out;
+		return 0;
 
 	/* Add on-board retimers if they do not exist already */
+	ret = 0;
 	for (i = 1; i <= last_idx; i++) {
 		struct tb_retimer *rt;
 
@@ -489,10 +482,6 @@ int tb_retimer_scan(struct tb_port *port
 		}
 	}
 
-out:
-	pm_runtime_mark_last_busy(&usb4->dev);
-	pm_runtime_put_autosuspend(&usb4->dev);
-
 	return ret;
 }
 
--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -628,11 +628,15 @@ static void tb_scan_port(struct tb_port
 			 * Downstream switch is reachable through two ports.
 			 * Only scan on the primary port (link_nr == 0).
 			 */
+
+	if (port->usb4)
+		pm_runtime_get_sync(&port->usb4->dev);
+
 	if (tb_wait_for_port(port, false) <= 0)
-		return;
+		goto out_rpm_put;
 	if (port->remote) {
 		tb_port_dbg(port, "port already has a remote\n");
-		return;
+		goto out_rpm_put;
 	}
 
 	tb_retimer_scan(port, true);
@@ -647,12 +651,12 @@ static void tb_scan_port(struct tb_port
 		 */
 		if (PTR_ERR(sw) == -EIO || PTR_ERR(sw) == -EADDRNOTAVAIL)
 			tb_scan_xdomain(port);
-		return;
+		goto out_rpm_put;
 	}
 
 	if (tb_switch_configure(sw)) {
 		tb_switch_put(sw);
-		return;
+		goto out_rpm_put;
 	}
 
 	/*
@@ -681,7 +685,7 @@ static void tb_scan_port(struct tb_port
 
 	if (tb_switch_add(sw)) {
 		tb_switch_put(sw);
-		return;
+		goto out_rpm_put;
 	}
 
 	/* Link the switches using both links if available */
@@ -733,6 +737,12 @@ static void tb_scan_port(struct tb_port
 
 	tb_add_dp_resources(sw);
 	tb_scan_switch(sw);
+
+out_rpm_put:
+	if (port->usb4) {
+		pm_runtime_mark_last_busy(&port->usb4->dev);
+		pm_runtime_put_autosuspend(&port->usb4->dev);
+	}
 }
 
 static void tb_deactivate_and_free_tunnel(struct tb_tunnel *tunnel)


