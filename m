Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8298C627EE4
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237463AbiKNMwx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:52:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237464AbiKNMww (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:52:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 894FC25E83
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:52:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0947E6115D
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:52:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D031C433D6;
        Mon, 14 Nov 2022 12:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430370;
        bh=rMT2Gm0iH/o5ONbQaX5dp0pjpNoAqbxW0jYYiGwC7CQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v8Abnb4zaI/sZaS+bABnn8OT4PK5Xv0V2UPt4N2K5MYya5HsuDBO8iJ7L13DkfDSb
         fIOc42gPEPhpNlNvXe+EZGbkLb7VcMPbHV7YqrR7aw72Lz4nR1I8efb1CjoAIvjpx8
         BL+e63vBB2UGHMafKRfaopBqDjMzVCenyv6FaD+U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Limonciello, Mario" <Mario.Limonciello@amd.com>
Subject: [PATCH 5.15 001/131] thunderbolt: Tear down existing tunnels when resuming from hibernate
Date:   Mon, 14 Nov 2022 13:44:30 +0100
Message-Id: <20221114124448.806960282@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
References: <20221114124448.729235104@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit 43bddb26e20af916249b5318200cfe1734c1700c upstream.

If the boot firmware implements connection manager of its own it may not
create the paths in the same way or order we do. For example it may
create first PCIe tunnel and then USB3 tunnel. When we restore our
tunnels (first de-activating them) we may be doing that over completely
different tunnels and that leaves them possibly non-functional. For this
reason we re-use the tunnel discovery functionality and find out all the
existing tunnels, and tear them down. Once that is done we can restore
our tunnels.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: "Limonciello, Mario" <Mario.Limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/path.c   |   38 ++++++++++++++----------
 drivers/thunderbolt/tb.c     |   68 ++++++++++++++++++++++++++++++++-----------
 drivers/thunderbolt/tb.h     |    5 ++-
 drivers/thunderbolt/tunnel.c |   27 ++++++++++-------
 drivers/thunderbolt/tunnel.h |    9 +++--
 5 files changed, 102 insertions(+), 45 deletions(-)

--- a/drivers/thunderbolt/path.c
+++ b/drivers/thunderbolt/path.c
@@ -85,11 +85,12 @@ static int tb_path_find_src_hopid(struct
  * @dst_hopid: HopID to the @dst (%-1 if don't care)
  * @last: Last port is filled here if not %NULL
  * @name: Name of the path
+ * @alloc_hopid: Allocate HopIDs for the ports
  *
  * Follows a path starting from @src and @src_hopid to the last output
- * port of the path. Allocates HopIDs for the visited ports. Call
- * tb_path_free() to release the path and allocated HopIDs when the path
- * is not needed anymore.
+ * port of the path. Allocates HopIDs for the visited ports (if
+ * @alloc_hopid is true). Call tb_path_free() to release the path and
+ * allocated HopIDs when the path is not needed anymore.
  *
  * Note function discovers also incomplete paths so caller should check
  * that the @dst port is the expected one. If it is not, the path can be
@@ -99,7 +100,8 @@ static int tb_path_find_src_hopid(struct
  */
 struct tb_path *tb_path_discover(struct tb_port *src, int src_hopid,
 				 struct tb_port *dst, int dst_hopid,
-				 struct tb_port **last, const char *name)
+				 struct tb_port **last, const char *name,
+				 bool alloc_hopid)
 {
 	struct tb_port *out_port;
 	struct tb_regs_hop hop;
@@ -156,6 +158,7 @@ struct tb_path *tb_path_discover(struct
 	path->tb = src->sw->tb;
 	path->path_length = num_hops;
 	path->activated = true;
+	path->alloc_hopid = alloc_hopid;
 
 	path->hops = kcalloc(num_hops, sizeof(*path->hops), GFP_KERNEL);
 	if (!path->hops) {
@@ -177,13 +180,14 @@ struct tb_path *tb_path_discover(struct
 			goto err;
 		}
 
-		if (tb_port_alloc_in_hopid(p, h, h) < 0)
+		if (alloc_hopid && tb_port_alloc_in_hopid(p, h, h) < 0)
 			goto err;
 
 		out_port = &sw->ports[hop.out_port];
 		next_hop = hop.next_hop;
 
-		if (tb_port_alloc_out_hopid(out_port, next_hop, next_hop) < 0) {
+		if (alloc_hopid &&
+		    tb_port_alloc_out_hopid(out_port, next_hop, next_hop) < 0) {
 			tb_port_release_in_hopid(p, h);
 			goto err;
 		}
@@ -263,6 +267,8 @@ struct tb_path *tb_path_alloc(struct tb
 		return NULL;
 	}
 
+	path->alloc_hopid = true;
+
 	in_hopid = src_hopid;
 	out_port = NULL;
 
@@ -345,17 +351,19 @@ err:
  */
 void tb_path_free(struct tb_path *path)
 {
-	int i;
+	if (path->alloc_hopid) {
+		int i;
 
-	for (i = 0; i < path->path_length; i++) {
-		const struct tb_path_hop *hop = &path->hops[i];
+		for (i = 0; i < path->path_length; i++) {
+			const struct tb_path_hop *hop = &path->hops[i];
 
-		if (hop->in_port)
-			tb_port_release_in_hopid(hop->in_port,
-						 hop->in_hop_index);
-		if (hop->out_port)
-			tb_port_release_out_hopid(hop->out_port,
-						  hop->next_hop_index);
+			if (hop->in_port)
+				tb_port_release_in_hopid(hop->in_port,
+							 hop->in_hop_index);
+			if (hop->out_port)
+				tb_port_release_out_hopid(hop->out_port,
+							  hop->next_hop_index);
+		}
 	}
 
 	kfree(path->hops);
--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -105,10 +105,11 @@ static void tb_remove_dp_resources(struc
 	}
 }
 
-static void tb_discover_tunnels(struct tb_switch *sw)
+static void tb_switch_discover_tunnels(struct tb_switch *sw,
+				       struct list_head *list,
+				       bool alloc_hopids)
 {
 	struct tb *tb = sw->tb;
-	struct tb_cm *tcm = tb_priv(tb);
 	struct tb_port *port;
 
 	tb_switch_for_each_port(sw, port) {
@@ -116,24 +117,41 @@ static void tb_discover_tunnels(struct t
 
 		switch (port->config.type) {
 		case TB_TYPE_DP_HDMI_IN:
-			tunnel = tb_tunnel_discover_dp(tb, port);
+			tunnel = tb_tunnel_discover_dp(tb, port, alloc_hopids);
 			break;
 
 		case TB_TYPE_PCIE_DOWN:
-			tunnel = tb_tunnel_discover_pci(tb, port);
+			tunnel = tb_tunnel_discover_pci(tb, port, alloc_hopids);
 			break;
 
 		case TB_TYPE_USB3_DOWN:
-			tunnel = tb_tunnel_discover_usb3(tb, port);
+			tunnel = tb_tunnel_discover_usb3(tb, port, alloc_hopids);
 			break;
 
 		default:
 			break;
 		}
 
-		if (!tunnel)
-			continue;
+		if (tunnel)
+			list_add_tail(&tunnel->list, list);
+	}
+
+	tb_switch_for_each_port(sw, port) {
+		if (tb_port_has_remote(port)) {
+			tb_switch_discover_tunnels(port->remote->sw, list,
+						   alloc_hopids);
+		}
+	}
+}
+
+static void tb_discover_tunnels(struct tb *tb)
+{
+	struct tb_cm *tcm = tb_priv(tb);
+	struct tb_tunnel *tunnel;
+
+	tb_switch_discover_tunnels(tb->root_switch, &tcm->tunnel_list, true);
 
+	list_for_each_entry(tunnel, &tcm->tunnel_list, list) {
 		if (tb_tunnel_is_pci(tunnel)) {
 			struct tb_switch *parent = tunnel->dst_port->sw;
 
@@ -146,13 +164,6 @@ static void tb_discover_tunnels(struct t
 			pm_runtime_get_sync(&tunnel->src_port->sw->dev);
 			pm_runtime_get_sync(&tunnel->dst_port->sw->dev);
 		}
-
-		list_add_tail(&tunnel->list, &tcm->tunnel_list);
-	}
-
-	tb_switch_for_each_port(sw, port) {
-		if (tb_port_has_remote(port))
-			tb_discover_tunnels(port->remote->sw);
 	}
 }
 
@@ -1384,7 +1395,7 @@ static int tb_start(struct tb *tb)
 	/* Full scan to discover devices added before the driver was loaded. */
 	tb_scan_switch(tb->root_switch);
 	/* Find out tunnels created by the boot firmware */
-	tb_discover_tunnels(tb->root_switch);
+	tb_discover_tunnels(tb);
 	/*
 	 * If the boot firmware did not create USB 3.x tunnels create them
 	 * now for the whole topology.
@@ -1444,6 +1455,8 @@ static int tb_resume_noirq(struct tb *tb
 {
 	struct tb_cm *tcm = tb_priv(tb);
 	struct tb_tunnel *tunnel, *n;
+	unsigned int usb3_delay = 0;
+	LIST_HEAD(tunnels);
 
 	tb_dbg(tb, "resuming...\n");
 
@@ -1454,8 +1467,31 @@ static int tb_resume_noirq(struct tb *tb
 	tb_free_invalid_tunnels(tb);
 	tb_free_unplugged_children(tb->root_switch);
 	tb_restore_children(tb->root_switch);
-	list_for_each_entry_safe(tunnel, n, &tcm->tunnel_list, list)
+
+	/*
+	 * If we get here from suspend to disk the boot firmware or the
+	 * restore kernel might have created tunnels of its own. Since
+	 * we cannot be sure they are usable for us we find and tear
+	 * them down.
+	 */
+	tb_switch_discover_tunnels(tb->root_switch, &tunnels, false);
+	list_for_each_entry_safe_reverse(tunnel, n, &tunnels, list) {
+		if (tb_tunnel_is_usb3(tunnel))
+			usb3_delay = 500;
+		tb_tunnel_deactivate(tunnel);
+		tb_tunnel_free(tunnel);
+	}
+
+	/* Re-create our tunnels now */
+	list_for_each_entry_safe(tunnel, n, &tcm->tunnel_list, list) {
+		/* USB3 requires delay before it can be re-activated */
+		if (tb_tunnel_is_usb3(tunnel)) {
+			msleep(usb3_delay);
+			/* Only need to do it once */
+			usb3_delay = 0;
+		}
 		tb_tunnel_restart(tunnel);
+	}
 	if (!list_empty(&tcm->tunnel_list)) {
 		/*
 		 * the pcie links need some time to get going.
--- a/drivers/thunderbolt/tb.h
+++ b/drivers/thunderbolt/tb.h
@@ -354,6 +354,7 @@ enum tb_path_port {
  *	      when deactivating this path
  * @hops: Path hops
  * @path_length: How many hops the path uses
+ * @alloc_hopid: Does this path consume port HopID
  *
  * A path consists of a number of hops (see &struct tb_path_hop). To
  * establish a PCIe tunnel two paths have to be created between the two
@@ -374,6 +375,7 @@ struct tb_path {
 	bool clear_fc;
 	struct tb_path_hop *hops;
 	int path_length;
+	bool alloc_hopid;
 };
 
 /* HopIDs 0-7 are reserved by the Thunderbolt protocol */
@@ -957,7 +959,8 @@ int tb_dp_port_enable(struct tb_port *po
 
 struct tb_path *tb_path_discover(struct tb_port *src, int src_hopid,
 				 struct tb_port *dst, int dst_hopid,
-				 struct tb_port **last, const char *name);
+				 struct tb_port **last, const char *name,
+				 bool alloc_hopid);
 struct tb_path *tb_path_alloc(struct tb *tb, struct tb_port *src, int src_hopid,
 			      struct tb_port *dst, int dst_hopid, int link_nr,
 			      const char *name);
--- a/drivers/thunderbolt/tunnel.c
+++ b/drivers/thunderbolt/tunnel.c
@@ -207,12 +207,14 @@ static int tb_pci_init_path(struct tb_pa
  * tb_tunnel_discover_pci() - Discover existing PCIe tunnels
  * @tb: Pointer to the domain structure
  * @down: PCIe downstream adapter
+ * @alloc_hopid: Allocate HopIDs from visited ports
  *
  * If @down adapter is active, follows the tunnel to the PCIe upstream
  * adapter and back. Returns the discovered tunnel or %NULL if there was
  * no tunnel.
  */
-struct tb_tunnel *tb_tunnel_discover_pci(struct tb *tb, struct tb_port *down)
+struct tb_tunnel *tb_tunnel_discover_pci(struct tb *tb, struct tb_port *down,
+					 bool alloc_hopid)
 {
 	struct tb_tunnel *tunnel;
 	struct tb_path *path;
@@ -233,7 +235,7 @@ struct tb_tunnel *tb_tunnel_discover_pci
 	 * case.
 	 */
 	path = tb_path_discover(down, TB_PCI_HOPID, NULL, -1,
-				&tunnel->dst_port, "PCIe Up");
+				&tunnel->dst_port, "PCIe Up", alloc_hopid);
 	if (!path) {
 		/* Just disable the downstream port */
 		tb_pci_port_enable(down, false);
@@ -244,7 +246,7 @@ struct tb_tunnel *tb_tunnel_discover_pci
 		goto err_free;
 
 	path = tb_path_discover(tunnel->dst_port, -1, down, TB_PCI_HOPID, NULL,
-				"PCIe Down");
+				"PCIe Down", alloc_hopid);
 	if (!path)
 		goto err_deactivate;
 	tunnel->paths[TB_PCI_PATH_DOWN] = path;
@@ -761,6 +763,7 @@ static int tb_dp_init_video_path(struct
  * tb_tunnel_discover_dp() - Discover existing Display Port tunnels
  * @tb: Pointer to the domain structure
  * @in: DP in adapter
+ * @alloc_hopid: Allocate HopIDs from visited ports
  *
  * If @in adapter is active, follows the tunnel to the DP out adapter
  * and back. Returns the discovered tunnel or %NULL if there was no
@@ -768,7 +771,8 @@ static int tb_dp_init_video_path(struct
  *
  * Return: DP tunnel or %NULL if no tunnel found.
  */
-struct tb_tunnel *tb_tunnel_discover_dp(struct tb *tb, struct tb_port *in)
+struct tb_tunnel *tb_tunnel_discover_dp(struct tb *tb, struct tb_port *in,
+					bool alloc_hopid)
 {
 	struct tb_tunnel *tunnel;
 	struct tb_port *port;
@@ -787,7 +791,7 @@ struct tb_tunnel *tb_tunnel_discover_dp(
 	tunnel->src_port = in;
 
 	path = tb_path_discover(in, TB_DP_VIDEO_HOPID, NULL, -1,
-				&tunnel->dst_port, "Video");
+				&tunnel->dst_port, "Video", alloc_hopid);
 	if (!path) {
 		/* Just disable the DP IN port */
 		tb_dp_port_enable(in, false);
@@ -797,14 +801,15 @@ struct tb_tunnel *tb_tunnel_discover_dp(
 	if (tb_dp_init_video_path(tunnel->paths[TB_DP_VIDEO_PATH_OUT]))
 		goto err_free;
 
-	path = tb_path_discover(in, TB_DP_AUX_TX_HOPID, NULL, -1, NULL, "AUX TX");
+	path = tb_path_discover(in, TB_DP_AUX_TX_HOPID, NULL, -1, NULL, "AUX TX",
+				alloc_hopid);
 	if (!path)
 		goto err_deactivate;
 	tunnel->paths[TB_DP_AUX_PATH_OUT] = path;
 	tb_dp_init_aux_path(tunnel->paths[TB_DP_AUX_PATH_OUT]);
 
 	path = tb_path_discover(tunnel->dst_port, -1, in, TB_DP_AUX_RX_HOPID,
-				&port, "AUX RX");
+				&port, "AUX RX", alloc_hopid);
 	if (!path)
 		goto err_deactivate;
 	tunnel->paths[TB_DP_AUX_PATH_IN] = path;
@@ -1344,12 +1349,14 @@ static void tb_usb3_init_path(struct tb_
  * tb_tunnel_discover_usb3() - Discover existing USB3 tunnels
  * @tb: Pointer to the domain structure
  * @down: USB3 downstream adapter
+ * @alloc_hopid: Allocate HopIDs from visited ports
  *
  * If @down adapter is active, follows the tunnel to the USB3 upstream
  * adapter and back. Returns the discovered tunnel or %NULL if there was
  * no tunnel.
  */
-struct tb_tunnel *tb_tunnel_discover_usb3(struct tb *tb, struct tb_port *down)
+struct tb_tunnel *tb_tunnel_discover_usb3(struct tb *tb, struct tb_port *down,
+					  bool alloc_hopid)
 {
 	struct tb_tunnel *tunnel;
 	struct tb_path *path;
@@ -1370,7 +1377,7 @@ struct tb_tunnel *tb_tunnel_discover_usb
 	 * case.
 	 */
 	path = tb_path_discover(down, TB_USB3_HOPID, NULL, -1,
-				&tunnel->dst_port, "USB3 Down");
+				&tunnel->dst_port, "USB3 Down", alloc_hopid);
 	if (!path) {
 		/* Just disable the downstream port */
 		tb_usb3_port_enable(down, false);
@@ -1380,7 +1387,7 @@ struct tb_tunnel *tb_tunnel_discover_usb
 	tb_usb3_init_path(tunnel->paths[TB_USB3_PATH_DOWN]);
 
 	path = tb_path_discover(tunnel->dst_port, -1, down, TB_USB3_HOPID, NULL,
-				"USB3 Up");
+				"USB3 Up", alloc_hopid);
 	if (!path)
 		goto err_deactivate;
 	tunnel->paths[TB_USB3_PATH_UP] = path;
--- a/drivers/thunderbolt/tunnel.h
+++ b/drivers/thunderbolt/tunnel.h
@@ -64,10 +64,12 @@ struct tb_tunnel {
 	int allocated_down;
 };
 
-struct tb_tunnel *tb_tunnel_discover_pci(struct tb *tb, struct tb_port *down);
+struct tb_tunnel *tb_tunnel_discover_pci(struct tb *tb, struct tb_port *down,
+					 bool alloc_hopid);
 struct tb_tunnel *tb_tunnel_alloc_pci(struct tb *tb, struct tb_port *up,
 				      struct tb_port *down);
-struct tb_tunnel *tb_tunnel_discover_dp(struct tb *tb, struct tb_port *in);
+struct tb_tunnel *tb_tunnel_discover_dp(struct tb *tb, struct tb_port *in,
+					bool alloc_hopid);
 struct tb_tunnel *tb_tunnel_alloc_dp(struct tb *tb, struct tb_port *in,
 				     struct tb_port *out, int link_nr,
 				     int max_up, int max_down);
@@ -77,7 +79,8 @@ struct tb_tunnel *tb_tunnel_alloc_dma(st
 				      int receive_ring);
 bool tb_tunnel_match_dma(const struct tb_tunnel *tunnel, int transmit_path,
 			 int transmit_ring, int receive_path, int receive_ring);
-struct tb_tunnel *tb_tunnel_discover_usb3(struct tb *tb, struct tb_port *down);
+struct tb_tunnel *tb_tunnel_discover_usb3(struct tb *tb, struct tb_port *down,
+					  bool alloc_hopid);
 struct tb_tunnel *tb_tunnel_alloc_usb3(struct tb *tb, struct tb_port *up,
 				       struct tb_port *down, int max_up,
 				       int max_down);


