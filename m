Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85AC222678E
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733291AbgGTQMl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:12:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:52286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388001AbgGTQMj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:12:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49DD820684;
        Mon, 20 Jul 2020 16:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261558;
        bh=HXHRPEM+2O9GHjTozQU7VR71qzBWUhWaAWutmC+upGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WPodvokDNXmZFfFS+5Gg2boIHOAQeARwLHgVF9IQQoOkE2RHcvU6EBpDLgGBG4R5x
         Z+Eo9POPnwY7dfiE1CleClXFJAKCHCKjjzzhS9HP6d+voLBmki29CpfrKB86h/owYp
         OeW87rQNHMO5065sQokGJpexEIBXXnWT3spCl0no=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.7 159/244] thunderbolt: Fix path indices used in USB3 tunnel discovery
Date:   Mon, 20 Jul 2020 17:37:10 +0200
Message-Id: <20200720152833.408539876@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit 8b94a4b92327d061327117e127d7d44a4a43e639 upstream.

The USB3 discovery used wrong indices when tunnel is discovered. It
should use TB_USB3_PATH_DOWN for path that flows downstream and
TB_USB3_PATH_UP when it flows upstream. This should not affect the
functionality but better to fix it.

Fixes: e6f818585713 ("thunderbolt: Add support for USB 3.x tunnels")
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: stable@vger.kernel.org # v5.6+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/thunderbolt/tunnel.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/thunderbolt/tunnel.c
+++ b/drivers/thunderbolt/tunnel.c
@@ -913,21 +913,21 @@ struct tb_tunnel *tb_tunnel_discover_usb
 	 * case.
 	 */
 	path = tb_path_discover(down, TB_USB3_HOPID, NULL, -1,
-				&tunnel->dst_port, "USB3 Up");
+				&tunnel->dst_port, "USB3 Down");
 	if (!path) {
 		/* Just disable the downstream port */
 		tb_usb3_port_enable(down, false);
 		goto err_free;
 	}
-	tunnel->paths[TB_USB3_PATH_UP] = path;
-	tb_usb3_init_path(tunnel->paths[TB_USB3_PATH_UP]);
+	tunnel->paths[TB_USB3_PATH_DOWN] = path;
+	tb_usb3_init_path(tunnel->paths[TB_USB3_PATH_DOWN]);
 
 	path = tb_path_discover(tunnel->dst_port, -1, down, TB_USB3_HOPID, NULL,
-				"USB3 Down");
+				"USB3 Up");
 	if (!path)
 		goto err_deactivate;
-	tunnel->paths[TB_USB3_PATH_DOWN] = path;
-	tb_usb3_init_path(tunnel->paths[TB_USB3_PATH_DOWN]);
+	tunnel->paths[TB_USB3_PATH_UP] = path;
+	tb_usb3_init_path(tunnel->paths[TB_USB3_PATH_UP]);
 
 	/* Validate that the tunnel is complete */
 	if (!tb_port_is_usb3_up(tunnel->dst_port)) {


