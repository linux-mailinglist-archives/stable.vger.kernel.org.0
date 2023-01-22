Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47448676FB1
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231351AbjAVPYO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:24:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231350AbjAVPYN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:24:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00EC91A96E
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:24:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9432760C60
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:24:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A637AC433D2;
        Sun, 22 Jan 2023 15:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674401052;
        bh=ifJdVjY2AeBVZZjiUewJRXO3f4S6b7YHtavXXbHeXtE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XwkAPHFcbtjjxWEsrmZb4f64NcWe3FtS/KvAkgeCuj9yIbaiExuiU7ZawiqFz6Kol
         EhigeKFOM3zQlKohgTjB5G8e2P946P/yvKPOrkeg7fBJxZbK/Zon6tRv/K3p2VKnSv
         8q9FL09JmE5Gt07w5sZOAT/vNCXO9+/ezMfHG9HU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yehezkel Bernat <YehezkelShB@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.1 091/193] thunderbolt: Disable XDomain lane 1 only in software connection manager
Date:   Sun, 22 Jan 2023 16:03:40 +0100
Message-Id: <20230122150250.527038630@linuxfoundation.org>
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

commit 84ee211c83212f4d35b56e0603acdcc41f860f1b upstream.

When firmware connection manager is in use we should not touch the lane
adapter (well or any) configuration space so do this only when we know
that the software connection manager is active.

Fixes: 8e1de7042596 ("thunderbolt: Add support for XDomain lane bonding")
Cc: stable@vger.kernel.org
Acked-by: Yehezkel Bernat <YehezkelShB@gmail.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/xdomain.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/thunderbolt/xdomain.c b/drivers/thunderbolt/xdomain.c
index cfa83486c9da..3c51e47dd86b 100644
--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -1419,12 +1419,19 @@ static int tb_xdomain_get_properties(struct tb_xdomain *xd)
 	 * registered, we notify the userspace that it has changed.
 	 */
 	if (!update) {
-		struct tb_port *port;
+		/*
+		 * Now disable lane 1 if bonding was not enabled. Do
+		 * this only if bonding was possible at the beginning
+		 * (that is we are the connection manager and there are
+		 * two lanes).
+		 */
+		if (xd->bonding_possible) {
+			struct tb_port *port;
 
-		/* Now disable lane 1 if bonding was not enabled */
-		port = tb_port_at(xd->route, tb_xdomain_parent(xd));
-		if (!port->bonded)
-			tb_port_disable(port->dual_link_port);
+			port = tb_port_at(xd->route, tb_xdomain_parent(xd));
+			if (!port->bonded)
+				tb_port_disable(port->dual_link_port);
+		}
 
 		if (device_add(&xd->dev)) {
 			dev_err(&xd->dev, "failed to add XDomain device\n");
-- 
2.39.1



