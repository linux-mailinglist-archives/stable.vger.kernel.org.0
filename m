Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88E772EED8
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732262AbfE3DuR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:50:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:57408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730657AbfE3DT5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:19:57 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 547D42485E;
        Thu, 30 May 2019 03:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186397;
        bh=F+hl5h+p7FG1yySKoaIIOhNXx2f4OrJUVzBXMxQpzTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f+QHCH2yo1ikGjXrv15nifvC9qo3b69E2ANJGsV+fDxHGgL/BXSI+jyCbkMFKaq1V
         lPvmccsKXbWWKqLZsYAyJM8hErY1V9FjY2NQTvoGn9ehUWsWO4zmQByV0znoaW38JE
         6ZCUxowCSlEkFsrs8uZ2hoCaFWG1444Gh3t1YiBI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aditya Pakki <pakki001@umn.edu>,
        Mukesh Ojha <mojha@codeaurora.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 177/193] thunderbolt: Fix to check for kmemdup failure
Date:   Wed, 29 May 2019 20:07:11 -0700
Message-Id: <20190530030512.325244420@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030446.953835040@linuxfoundation.org>
References: <20190530030446.953835040@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 2cc12751cf464a722ff57b54d17d30c84553f9c0 ]

Memory allocated via kmemdup might fail and return a NULL pointer.
This patch adds a check on the return value of kmemdup and passes the
error upstream.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/switch.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/thunderbolt/switch.c b/drivers/thunderbolt/switch.c
index 8bd1371099808..fe2384b019ec9 100644
--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -1206,13 +1206,14 @@ int tb_switch_configure(struct tb_switch *sw)
 	return tb_plug_events_active(sw, true);
 }
 
-static void tb_switch_set_uuid(struct tb_switch *sw)
+static int tb_switch_set_uuid(struct tb_switch *sw)
 {
 	u32 uuid[4];
-	int cap;
+	int cap, ret;
 
+	ret = 0;
 	if (sw->uuid)
-		return;
+		return ret;
 
 	/*
 	 * The newer controllers include fused UUID as part of link
@@ -1220,7 +1221,9 @@ static void tb_switch_set_uuid(struct tb_switch *sw)
 	 */
 	cap = tb_switch_find_vse_cap(sw, TB_VSE_CAP_LINK_CONTROLLER);
 	if (cap > 0) {
-		tb_sw_read(sw, uuid, TB_CFG_SWITCH, cap + 3, 4);
+		ret = tb_sw_read(sw, uuid, TB_CFG_SWITCH, cap + 3, 4);
+		if (ret)
+			return ret;
 	} else {
 		/*
 		 * ICM generates UUID based on UID and fills the upper
@@ -1235,6 +1238,9 @@ static void tb_switch_set_uuid(struct tb_switch *sw)
 	}
 
 	sw->uuid = kmemdup(uuid, sizeof(uuid), GFP_KERNEL);
+	if (!sw->uuid)
+		ret = -ENOMEM;
+	return ret;
 }
 
 static int tb_switch_add_dma_port(struct tb_switch *sw)
@@ -1280,7 +1286,9 @@ static int tb_switch_add_dma_port(struct tb_switch *sw)
 
 	if (status) {
 		tb_sw_info(sw, "switch flash authentication failed\n");
-		tb_switch_set_uuid(sw);
+		ret = tb_switch_set_uuid(sw);
+		if (ret)
+			return ret;
 		nvm_set_auth_status(sw, status);
 	}
 
@@ -1330,7 +1338,9 @@ int tb_switch_add(struct tb_switch *sw)
 		}
 		tb_sw_info(sw, "uid: %#llx\n", sw->uid);
 
-		tb_switch_set_uuid(sw);
+		ret = tb_switch_set_uuid(sw);
+		if (ret)
+			return ret;
 
 		for (i = 0; i <= sw->config.max_port_number; i++) {
 			if (sw->ports[i].disabled) {
-- 
2.20.1



