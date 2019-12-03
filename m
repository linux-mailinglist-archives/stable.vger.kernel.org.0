Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC88111E3B
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730228AbfLCW5C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:57:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:52390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730089AbfLCW5C (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:57:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26DA22053B;
        Tue,  3 Dec 2019 22:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413821;
        bh=ZbzCA+8tCD2OdOmVoHIvAZlA87DvMw3bhEqOki+cICI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RVqwfCxxE2maBr/4QdQG6R4eHOx3Z/pkd/9iyM//MmptBU/e4upkP9xe3MjsfEbeS
         9wEMiCg3QKSWuJaPBU+yuc1RF2sfiZdJvxdVX0lMHYlwVvriDIGlqVQ7Kq11uYbJKv
         XSPSmIiKRfJ3ora4E/s87wEwG5wqPsQHpyStvPkc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, zang <dump@tzib.net>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 4.19 275/321] thunderbolt: Power cycle the router if NVM authentication fails
Date:   Tue,  3 Dec 2019 23:35:41 +0100
Message-Id: <20191203223441.434753857@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit 7a7ebfa85f4fac349f3ab219538c44efe18b0cf6 upstream.

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
 drivers/thunderbolt/switch.c |   54 +++++++++++++++++++++++++++++++++----------
 1 file changed, 42 insertions(+), 12 deletions(-)

--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -167,7 +167,7 @@ static int nvm_validate_and_write(struct
 
 static int nvm_authenticate_host(struct tb_switch *sw)
 {
-	int ret;
+	int ret = 0;
 
 	/*
 	 * Root switch NVM upgrade requires that we disconnect the
@@ -175,6 +175,8 @@ static int nvm_authenticate_host(struct
 	 * already).
 	 */
 	if (!sw->safe_mode) {
+		u32 status;
+
 		ret = tb_domain_disconnect_all_paths(sw->tb);
 		if (ret)
 			return ret;
@@ -183,7 +185,16 @@ static int nvm_authenticate_host(struct
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
@@ -191,7 +202,7 @@ static int nvm_authenticate_host(struct
 	 * switch.
 	 */
 	dma_port_power_cycle(sw->dma_port);
-	return 0;
+	return ret;
 }
 
 static int nvm_authenticate_device(struct tb_switch *sw)
@@ -199,8 +210,16 @@ static int nvm_authenticate_device(struc
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
@@ -937,8 +956,6 @@ static ssize_t nvm_authenticate_store(st
 			 */
 			nvm_authenticate_start(sw);
 			ret = nvm_authenticate_host(sw);
-			if (ret)
-				nvm_authenticate_complete(sw);
 		} else {
 			ret = nvm_authenticate_device(sw);
 		}
@@ -1332,13 +1349,16 @@ static int tb_switch_add_dma_port(struct
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
@@ -1359,6 +1379,19 @@ static int tb_switch_add_dma_port(struct
 		return 0;
 
 	/*
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
+	/*
 	 * Check status of the previous flash authentication. If there
 	 * is one we need to power cycle the switch in any case to make
 	 * it functional again.
@@ -1373,9 +1406,6 @@ static int tb_switch_add_dma_port(struct
 
 	if (status) {
 		tb_sw_info(sw, "switch flash authentication failed\n");
-		ret = tb_switch_set_uuid(sw);
-		if (ret)
-			return ret;
 		nvm_set_auth_status(sw, status);
 	}
 


