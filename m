Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9994D6CC2FF
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233435AbjC1Oua (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233397AbjC1OuL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:50:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F06ADC15A
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:49:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52939B81D72
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:49:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A71C433D2;
        Tue, 28 Mar 2023 14:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680014977;
        bh=EBuVphMgO07SvHhHw7Hw5mLeatlRJ3L+6J6Gr0C28cg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FSFHZPtq6cE78nQt5MMZFKCwkn1nIgwTqEexZSDkb3WND/b55/qAjme5UnVg/4VwX
         uh365Ikt+o71qGIn1F4vanJmcKcz8+0EKPMbyB3oJlOFT8hd2F8y6iC6nKIWdOr6Pt
         YGEi4o7qv8aDYeuzQn8XFrafDKFkEyap1LWT2uOo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.2 121/240] thunderbolt: Fix memory leak in margining
Date:   Tue, 28 Mar 2023 16:41:24 +0200
Message-Id: <20230328142624.826282340@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
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
 drivers/thunderbolt/debugfs.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/thunderbolt/debugfs.c
+++ b/drivers/thunderbolt/debugfs.c
@@ -942,7 +942,8 @@ static void margining_port_remove(struct
 
 	snprintf(dir_name, sizeof(dir_name), "port%d", port->port);
 	parent = debugfs_lookup(dir_name, port->sw->debugfs_dir);
-	debugfs_remove_recursive(debugfs_lookup("margining", parent));
+	if (parent)
+		debugfs_remove_recursive(debugfs_lookup("margining", parent));
 
 	kfree(port->usb4->margining);
 	port->usb4->margining = NULL;
@@ -967,19 +968,18 @@ static void margining_switch_init(struct
 
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
 


