Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FACE6CC424
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233666AbjC1PAU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233606AbjC1PAT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:00:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CD2D1BC
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5851B81D68
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 175BDC433D2;
        Tue, 28 Mar 2023 15:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015615;
        bh=ppcyU463xwZOaxo01RMStBuHylzzBwo3UIENdFO8CC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZuxbsUNijgiOLmMx2OZr8W32QoSF8hRkGnHBKMS0RK4PIp3VrrC4bek6TiOa/dbSI
         5AaKJGwFiurK9awV7WGUvpmtQN1RSCryEeL4jo23kgR7D1nSfAKr6d8yy/Au/l1ZiG
         UInFAE5TCYHKO3BO0+ws4B4ro8h5YwR2auU0ZSFQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.1 111/224] thunderbolt: Fix memory leak in margining
Date:   Tue, 28 Mar 2023 16:41:47 +0200
Message-Id: <20230328142621.981617977@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit acec726473822bc6b585961f4ca2a11fa7f28341 upstream.

Memory for the usb4->margining needs to be relased for the upstream port
of the router as well, even though the debugfs directory gets released
with the router device removal. Fix this.

Fixes: d0f1e0c2a699 ("thunderbolt: Add support for receiver lane margining")
Cc: stable@vger.kernel.org
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/debugfs.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/thunderbolt/debugfs.c b/drivers/thunderbolt/debugfs.c
index 4339e706cc3a..f92ad71ef983 100644
--- a/drivers/thunderbolt/debugfs.c
+++ b/drivers/thunderbolt/debugfs.c
@@ -942,7 +942,8 @@ static void margining_port_remove(struct tb_port *port)
 
 	snprintf(dir_name, sizeof(dir_name), "port%d", port->port);
 	parent = debugfs_lookup(dir_name, port->sw->debugfs_dir);
-	debugfs_remove_recursive(debugfs_lookup("margining", parent));
+	if (parent)
+		debugfs_remove_recursive(debugfs_lookup("margining", parent));
 
 	kfree(port->usb4->margining);
 	port->usb4->margining = NULL;
@@ -967,19 +968,18 @@ static void margining_switch_init(struct tb_switch *sw)
 
 static void margining_switch_remove(struct tb_switch *sw)
 {
+	struct tb_port *upstream, *downstream;
 	struct tb_switch *parent_sw;
-	struct tb_port *downstream;
 	u64 route = tb_route(sw);
 
 	if (!route)
 		return;
 
-	/*
-	 * Upstream is removed with the router itself but we need to
-	 * remove the downstream port margining directory.
-	 */
+	upstream = tb_upstream_port(sw);
 	parent_sw = tb_switch_parent(sw);
 	downstream = tb_port_at(route, parent_sw);
+
+	margining_port_remove(upstream);
 	margining_port_remove(downstream);
 }
 
-- 
2.40.0



