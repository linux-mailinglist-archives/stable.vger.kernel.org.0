Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC63B540B43
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350233AbiFGS1n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:27:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352050AbiFGSUt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:20:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59D4637A31;
        Tue,  7 Jun 2022 10:53:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C455C6159C;
        Tue,  7 Jun 2022 17:53:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3779DC3411C;
        Tue,  7 Jun 2022 17:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624407;
        bh=aHCYqNqHW5wOAkzq/rq12NubtRsbz6HRlKeEKiKMaWk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eK0PHLD3/sPalWJ9Vn1neZvAmM68hKx2Fe1tP8YtmK6cpw1zd5Kv1yqH5sttm3OHF
         0FuulQV+6q/WWSOMO0vVb6k300Fajv9YX4rutyGhhBnZaSte4KYPHPpLLIeFn+pgkX
         yQCFpKA25w5e3yB6Rs/WOGmiPWZnLUEpnJnOtKx2k4t7UAB3dyN8gFOQ+pphaW41bX
         9nl0OmVU5ZqcV9GX/ORq3ojZAFel5WxH1M99PwwF6eVTGqox0AU2rlgNg474Sqh+6n
         gOui3ZLYH1K60P2w3Y6B2N1bHoSJwfBI85xBfppStnaSMI8D4I9w2BY9uVmqucUg/6
         GWh9atwCGB8yw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mika Westerberg <mika.westerberg@linux.intel.com>,
        Brad Campbell <lists2009@fnarfbargle.com>,
        Sasha Levin <sashal@kernel.org>, andreas.noever@gmail.com,
        michael.jamet@intel.com, YehezkelShB@gmail.com,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 09/60] thunderbolt: Use different lane for second DisplayPort tunnel
Date:   Tue,  7 Jun 2022 13:52:06 -0400
Message-Id: <20220607175259.478835-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607175259.478835-1-sashal@kernel.org>
References: <20220607175259.478835-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit 9d2d0a5cf0ca063f417681cc33e767ce52615286 ]

Brad reported that on Apple hardware with Light Ridge or Falcon Ridge
controller, plugging in a chain of Thunderbolt displays (Light Ridge
based controllers) causes all kinds of tearing and flickering. The
reason for this is that on Thunderbolt 1 hardware there is no lane
bonding so we have two independent 10 Gb/s lanes, and currently Linux
tunnels both displays through the lane 1. This makes the displays to
share the 10 Gb/s bandwidth which may not be enough for higher
resolutions.

For this reason make the second tunnel go through the lane 0 instead.
This seems to match what the macOS connection manager is also doing.

Reported-by: Brad Campbell <lists2009@fnarfbargle.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Tested-by: Brad Campbell <lists2009@fnarfbargle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/tb.c     | 19 +++++++++++++++++--
 drivers/thunderbolt/test.c   | 16 ++++++++--------
 drivers/thunderbolt/tunnel.c | 11 ++++++-----
 drivers/thunderbolt/tunnel.h |  4 ++--
 4 files changed, 33 insertions(+), 17 deletions(-)

diff --git a/drivers/thunderbolt/tb.c b/drivers/thunderbolt/tb.c
index cbd0ad85ffb1..a1f5d1842811 100644
--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -867,7 +867,7 @@ static struct tb_port *tb_find_dp_out(struct tb *tb, struct tb_port *in)
 
 static void tb_tunnel_dp(struct tb *tb)
 {
-	int available_up, available_down, ret;
+	int available_up, available_down, ret, link_nr;
 	struct tb_cm *tcm = tb_priv(tb);
 	struct tb_port *port, *in, *out;
 	struct tb_tunnel *tunnel;
@@ -912,6 +912,20 @@ static void tb_tunnel_dp(struct tb *tb)
 		return;
 	}
 
+	/*
+	 * This is only applicable to links that are not bonded (so
+	 * when Thunderbolt 1 hardware is involved somewhere in the
+	 * topology). For these try to share the DP bandwidth between
+	 * the two lanes.
+	 */
+	link_nr = 1;
+	list_for_each_entry(tunnel, &tcm->tunnel_list, list) {
+		if (tb_tunnel_is_dp(tunnel)) {
+			link_nr = 0;
+			break;
+		}
+	}
+
 	/*
 	 * DP stream needs the domain to be active so runtime resume
 	 * both ends of the tunnel.
@@ -943,7 +957,8 @@ static void tb_tunnel_dp(struct tb *tb)
 	tb_dbg(tb, "available bandwidth for new DP tunnel %u/%u Mb/s\n",
 	       available_up, available_down);
 
-	tunnel = tb_tunnel_alloc_dp(tb, in, out, available_up, available_down);
+	tunnel = tb_tunnel_alloc_dp(tb, in, out, link_nr, available_up,
+				    available_down);
 	if (!tunnel) {
 		tb_port_dbg(out, "could not allocate DP tunnel\n");
 		goto err_reclaim;
diff --git a/drivers/thunderbolt/test.c b/drivers/thunderbolt/test.c
index 1f69bab236ee..66b6e665e96f 100644
--- a/drivers/thunderbolt/test.c
+++ b/drivers/thunderbolt/test.c
@@ -1348,7 +1348,7 @@ static void tb_test_tunnel_dp(struct kunit *test)
 	in = &host->ports[5];
 	out = &dev->ports[13];
 
-	tunnel = tb_tunnel_alloc_dp(NULL, in, out, 0, 0);
+	tunnel = tb_tunnel_alloc_dp(NULL, in, out, 1, 0, 0);
 	KUNIT_ASSERT_TRUE(test, tunnel != NULL);
 	KUNIT_EXPECT_EQ(test, tunnel->type, TB_TUNNEL_DP);
 	KUNIT_EXPECT_PTR_EQ(test, tunnel->src_port, in);
@@ -1394,7 +1394,7 @@ static void tb_test_tunnel_dp_chain(struct kunit *test)
 	in = &host->ports[5];
 	out = &dev4->ports[14];
 
-	tunnel = tb_tunnel_alloc_dp(NULL, in, out, 0, 0);
+	tunnel = tb_tunnel_alloc_dp(NULL, in, out, 1, 0, 0);
 	KUNIT_ASSERT_TRUE(test, tunnel != NULL);
 	KUNIT_EXPECT_EQ(test, tunnel->type, TB_TUNNEL_DP);
 	KUNIT_EXPECT_PTR_EQ(test, tunnel->src_port, in);
@@ -1444,7 +1444,7 @@ static void tb_test_tunnel_dp_tree(struct kunit *test)
 	in = &dev2->ports[13];
 	out = &dev5->ports[13];
 
-	tunnel = tb_tunnel_alloc_dp(NULL, in, out, 0, 0);
+	tunnel = tb_tunnel_alloc_dp(NULL, in, out, 1, 0, 0);
 	KUNIT_ASSERT_TRUE(test, tunnel != NULL);
 	KUNIT_EXPECT_EQ(test, tunnel->type, TB_TUNNEL_DP);
 	KUNIT_EXPECT_PTR_EQ(test, tunnel->src_port, in);
@@ -1509,7 +1509,7 @@ static void tb_test_tunnel_dp_max_length(struct kunit *test)
 	in = &dev6->ports[13];
 	out = &dev12->ports[13];
 
-	tunnel = tb_tunnel_alloc_dp(NULL, in, out, 0, 0);
+	tunnel = tb_tunnel_alloc_dp(NULL, in, out, 1, 0, 0);
 	KUNIT_ASSERT_TRUE(test, tunnel != NULL);
 	KUNIT_EXPECT_EQ(test, tunnel->type, TB_TUNNEL_DP);
 	KUNIT_EXPECT_PTR_EQ(test, tunnel->src_port, in);
@@ -1627,7 +1627,7 @@ static void tb_test_tunnel_port_on_path(struct kunit *test)
 	in = &dev2->ports[13];
 	out = &dev5->ports[13];
 
-	dp_tunnel = tb_tunnel_alloc_dp(NULL, in, out, 0, 0);
+	dp_tunnel = tb_tunnel_alloc_dp(NULL, in, out, 1, 0, 0);
 	KUNIT_ASSERT_TRUE(test, dp_tunnel != NULL);
 
 	KUNIT_EXPECT_TRUE(test, tb_tunnel_port_on_path(dp_tunnel, in));
@@ -2009,7 +2009,7 @@ static void tb_test_credit_alloc_dp(struct kunit *test)
 	in = &host->ports[5];
 	out = &dev->ports[14];
 
-	tunnel = tb_tunnel_alloc_dp(NULL, in, out, 0, 0);
+	tunnel = tb_tunnel_alloc_dp(NULL, in, out, 1, 0, 0);
 	KUNIT_ASSERT_TRUE(test, tunnel != NULL);
 	KUNIT_ASSERT_EQ(test, tunnel->npaths, (size_t)3);
 
@@ -2245,7 +2245,7 @@ static struct tb_tunnel *TB_TEST_DP_TUNNEL1(struct kunit *test,
 
 	in = &host->ports[5];
 	out = &dev->ports[13];
-	dp_tunnel1 = tb_tunnel_alloc_dp(NULL, in, out, 0, 0);
+	dp_tunnel1 = tb_tunnel_alloc_dp(NULL, in, out, 1, 0, 0);
 	KUNIT_ASSERT_TRUE(test, dp_tunnel1 != NULL);
 	KUNIT_ASSERT_EQ(test, dp_tunnel1->npaths, (size_t)3);
 
@@ -2282,7 +2282,7 @@ static struct tb_tunnel *TB_TEST_DP_TUNNEL2(struct kunit *test,
 
 	in = &host->ports[6];
 	out = &dev->ports[14];
-	dp_tunnel2 = tb_tunnel_alloc_dp(NULL, in, out, 0, 0);
+	dp_tunnel2 = tb_tunnel_alloc_dp(NULL, in, out, 1, 0, 0);
 	KUNIT_ASSERT_TRUE(test, dp_tunnel2 != NULL);
 	KUNIT_ASSERT_EQ(test, dp_tunnel2->npaths, (size_t)3);
 
diff --git a/drivers/thunderbolt/tunnel.c b/drivers/thunderbolt/tunnel.c
index a473cc7d9a8d..500a0afe3073 100644
--- a/drivers/thunderbolt/tunnel.c
+++ b/drivers/thunderbolt/tunnel.c
@@ -848,6 +848,7 @@ struct tb_tunnel *tb_tunnel_discover_dp(struct tb *tb, struct tb_port *in,
  * @tb: Pointer to the domain structure
  * @in: DP in adapter port
  * @out: DP out adapter port
+ * @link_nr: Preferred lane adapter when the link is not bonded
  * @max_up: Maximum available upstream bandwidth for the DP tunnel (%0
  *	    if not limited)
  * @max_down: Maximum available downstream bandwidth for the DP tunnel
@@ -859,8 +860,8 @@ struct tb_tunnel *tb_tunnel_discover_dp(struct tb *tb, struct tb_port *in,
  * Return: Returns a tb_tunnel on success or NULL on failure.
  */
 struct tb_tunnel *tb_tunnel_alloc_dp(struct tb *tb, struct tb_port *in,
-				     struct tb_port *out, int max_up,
-				     int max_down)
+				     struct tb_port *out, int link_nr,
+				     int max_up, int max_down)
 {
 	struct tb_tunnel *tunnel;
 	struct tb_path **paths;
@@ -884,21 +885,21 @@ struct tb_tunnel *tb_tunnel_alloc_dp(struct tb *tb, struct tb_port *in,
 	paths = tunnel->paths;
 
 	path = tb_path_alloc(tb, in, TB_DP_VIDEO_HOPID, out, TB_DP_VIDEO_HOPID,
-			     1, "Video");
+			     link_nr, "Video");
 	if (!path)
 		goto err_free;
 	tb_dp_init_video_path(path);
 	paths[TB_DP_VIDEO_PATH_OUT] = path;
 
 	path = tb_path_alloc(tb, in, TB_DP_AUX_TX_HOPID, out,
-			     TB_DP_AUX_TX_HOPID, 1, "AUX TX");
+			     TB_DP_AUX_TX_HOPID, link_nr, "AUX TX");
 	if (!path)
 		goto err_free;
 	tb_dp_init_aux_path(path);
 	paths[TB_DP_AUX_PATH_OUT] = path;
 
 	path = tb_path_alloc(tb, out, TB_DP_AUX_RX_HOPID, in,
-			     TB_DP_AUX_RX_HOPID, 1, "AUX RX");
+			     TB_DP_AUX_RX_HOPID, link_nr, "AUX RX");
 	if (!path)
 		goto err_free;
 	tb_dp_init_aux_path(path);
diff --git a/drivers/thunderbolt/tunnel.h b/drivers/thunderbolt/tunnel.h
index 03e56076b5bc..bb4d1f1d6d0b 100644
--- a/drivers/thunderbolt/tunnel.h
+++ b/drivers/thunderbolt/tunnel.h
@@ -71,8 +71,8 @@ struct tb_tunnel *tb_tunnel_alloc_pci(struct tb *tb, struct tb_port *up,
 struct tb_tunnel *tb_tunnel_discover_dp(struct tb *tb, struct tb_port *in,
 					bool alloc_hopid);
 struct tb_tunnel *tb_tunnel_alloc_dp(struct tb *tb, struct tb_port *in,
-				     struct tb_port *out, int max_up,
-				     int max_down);
+				     struct tb_port *out, int link_nr,
+				     int max_up, int max_down);
 struct tb_tunnel *tb_tunnel_alloc_dma(struct tb *tb, struct tb_port *nhi,
 				      struct tb_port *dst, int transmit_path,
 				      int transmit_ring, int receive_path,
-- 
2.35.1

