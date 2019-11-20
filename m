Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 173D2103619
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 09:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727674AbfKTIhk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 03:37:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:47070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726687AbfKTIhk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Nov 2019 03:37:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26FFF21852;
        Wed, 20 Nov 2019 08:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574239058;
        bh=9TxRKc9pHvpYhkxFtkNQlLwIGrg8vVVm4053jMJ4p9g=;
        h=Subject:To:From:Date:From;
        b=XEcceWn1bxze1B46fmyBX7eqYHxr+UuL0ei6x4u3uw/QCAd4GGDUl3zrWFfLg5wgV
         h2uTggGjh0BbuW8j9V9eMGm4r3u1HytDZnQLmsfZfhMRETFqRtSoRQP0n15+V3vVnW
         LANZh2Kp9Zak+0F4ud18WhmycN+3ti9cX/+J4p10=
Subject: patch "thunderbolt: Power cycle the router if NVM authentication fails" added to char-misc-next
To:     mika.westerberg@linux.intel.com, dump@tzib.net,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 20 Nov 2019 09:37:36 +0100
Message-ID: <157423905677206@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    thunderbolt: Power cycle the router if NVM authentication fails

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 7a7ebfa85f4fac349f3ab219538c44efe18b0cf6 Mon Sep 17 00:00:00 2001
From: Mika Westerberg <mika.westerberg@linux.intel.com>
Date: Mon, 11 Nov 2019 13:25:44 +0300
Subject: thunderbolt: Power cycle the router if NVM authentication fails

On zang's Dell XPS 13 9370 after Thunderbolt NVM firmware upgrade the
Thunderbolt controller did not come back as expected. Only after the
system was rebooted it became available again. It is not entirely clear
what happened but I suspect the new NVM firmware image authentication
failed for some reason. Regardless of this the router needs to be power
cycled if NVM authentication fails in order to get it fully functional
again.

This modifies the driver to issue a power cycle in case the NVM
authentication fails immediately when dma_port_flash_update_auth()
returns. We also need to call tb_switch_set_uuid() earlier to be able to
fetch possible NVM authentication failure when DMA port is added.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=205457
Reported-by: zang <dump@tzib.net>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/switch.c | 54 ++++++++++++++++++++++++++++--------
 1 file changed, 42 insertions(+), 12 deletions(-)

diff --git a/drivers/thunderbolt/switch.c b/drivers/thunderbolt/switch.c
index 3f477df2730a..ca86a8e09c77 100644
--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -168,7 +168,7 @@ static int nvm_validate_and_write(struct tb_switch *sw)
 
 static int nvm_authenticate_host(struct tb_switch *sw)
 {
-	int ret;
+	int ret = 0;
 
 	/*
 	 * Root switch NVM upgrade requires that we disconnect the
@@ -176,6 +176,8 @@ static int nvm_authenticate_host(struct tb_switch *sw)
 	 * already).
 	 */
 	if (!sw->safe_mode) {
+		u32 status;
+
 		ret = tb_domain_disconnect_all_paths(sw->tb);
 		if (ret)
 			return ret;
@@ -184,7 +186,16 @@ static int nvm_authenticate_host(struct tb_switch *sw)
 		 * everything goes well so getting timeout is expected.
 		 */
 		ret = dma_port_flash_update_auth(sw->dma_port);
-		return ret == -ETIMEDOUT ? 0 : ret;
+		if (!ret || ret == -ETIMEDOUT)
+			return 0;
+
+		/*
+		 * Any error from update auth operation requires power
+		 * cycling of the host router.
+		 */
+		tb_sw_warn(sw, "failed to authenticate NVM, power cycling\n");
+		if (dma_port_flash_update_auth_status(sw->dma_port, &status) > 0)
+			nvm_set_auth_status(sw, status);
 	}
 
 	/*
@@ -192,7 +203,7 @@ static int nvm_authenticate_host(struct tb_switch *sw)
 	 * switch.
 	 */
 	dma_port_power_cycle(sw->dma_port);
-	return 0;
+	return ret;
 }
 
 static int nvm_authenticate_device(struct tb_switch *sw)
@@ -200,8 +211,16 @@ static int nvm_authenticate_device(struct tb_switch *sw)
 	int ret, retries = 10;
 
 	ret = dma_port_flash_update_auth(sw->dma_port);
-	if (ret && ret != -ETIMEDOUT)
+	switch (ret) {
+	case 0:
+	case -ETIMEDOUT:
+	case -EACCES:
+	case -EINVAL:
+		/* Power cycle is required */
+		break;
+	default:
 		return ret;
+	}
 
 	/*
 	 * Poll here for the authentication status. It takes some time
@@ -1420,8 +1439,6 @@ static ssize_t nvm_authenticate_store(struct device *dev,
 			 */
 			nvm_authenticate_start(sw);
 			ret = nvm_authenticate_host(sw);
-			if (ret)
-				nvm_authenticate_complete(sw);
 		} else {
 			ret = nvm_authenticate_device(sw);
 		}
@@ -1876,13 +1893,16 @@ static int tb_switch_add_dma_port(struct tb_switch *sw)
 	int ret;
 
 	switch (sw->generation) {
-	case 3:
-		break;
-
 	case 2:
 		/* Only root switch can be upgraded */
 		if (tb_route(sw))
 			return 0;
+
+		/* fallthrough */
+	case 3:
+		ret = tb_switch_set_uuid(sw);
+		if (ret)
+			return ret;
 		break;
 
 	default:
@@ -1906,6 +1926,19 @@ static int tb_switch_add_dma_port(struct tb_switch *sw)
 	if (sw->no_nvm_upgrade)
 		return 0;
 
+	/*
+	 * If there is status already set then authentication failed
+	 * when the dma_port_flash_update_auth() returned. Power cycling
+	 * is not needed (it was done already) so only thing we do here
+	 * is to unblock runtime PM of the root port.
+	 */
+	nvm_get_auth_status(sw, &status);
+	if (status) {
+		if (!tb_route(sw))
+			nvm_authenticate_complete(sw);
+		return 0;
+	}
+
 	/*
 	 * Check status of the previous flash authentication. If there
 	 * is one we need to power cycle the switch in any case to make
@@ -1921,9 +1954,6 @@ static int tb_switch_add_dma_port(struct tb_switch *sw)
 
 	if (status) {
 		tb_sw_info(sw, "switch flash authentication failed\n");
-		ret = tb_switch_set_uuid(sw);
-		if (ret)
-			return ret;
 		nvm_set_auth_status(sw, status);
 	}
 
-- 
2.24.0


