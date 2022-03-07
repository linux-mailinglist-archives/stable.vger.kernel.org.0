Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8609B4CFA0D
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233685AbiCGKNj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:13:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242613AbiCGKLm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:11:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E58C8BE33;
        Mon,  7 Mar 2022 01:55:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5762360A27;
        Mon,  7 Mar 2022 09:55:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32EE8C340E9;
        Mon,  7 Mar 2022 09:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646931;
        bh=AbS0plN3wl9M/BBk2Eh0BdNxchcCA1b1qetcw+4wI9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gvl+N00H9lStVBIMcIfSHejlfEEs0PydRiphLCVSTvz49e2yMdngRzi4FTEchyKuk
         CZ/flVNu0irfb1AYLDbJyyL7RwfO+kWVE6ndHY5jfIUkuzki/3k3qBSP1O54GjRYvZ
         qsq/1H7VUkmR1eFW1csSCNJe9VDeMY7aUh2UDqGk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 137/186] can: etas_es58x: change opened_channel_cnts type from atomic_t to u8
Date:   Mon,  7 Mar 2022 10:19:35 +0100
Message-Id: <20220307091657.909256173@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091654.092878898@linuxfoundation.org>
References: <20220307091654.092878898@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

[ Upstream commit f4896248e9025ff744b4147e6758274a1cb8cbae ]

The driver uses an atomic_t variable: struct
es58x_device::opened_channel_cnt to keep track of the number of opened
channels in order to only allocate memory for the URBs when this count
changes from zero to one.

While the intent was to prevent race conditions, the choice of an
atomic_t turns out to be a bad idea for several reasons:

- implementation is incorrect and fails to decrement
  opened_channel_cnt when the URB allocation fails as reported in
  [1].

- even if opened_channel_cnt were to be correctly decremented,
  atomic_t is insufficient to cover edge cases: there can be a race
  condition in which 1/ a first process fails to allocate URBs
  memory 2/ a second process enters es58x_open() before the first
  process does its cleanup and decrements opened_channed_cnt. In
  which case, the second process would successfully return despite
  the URBs memory not being allocated.

- actually, any kind of locking mechanism was useless here because
  it is redundant with the network stack big kernel lock
  (a.k.a. rtnl_lock) which is being hold by all the callers of
  net_device_ops:ndo_open() and net_device_ops:ndo_close(). c.f. the
  ASSERST_RTNL() calls in __dev_open() [2] and __dev_close_many()
  [3].

The atmomic_t is thus replaced by a simple u8 type and the logic to
increment and decrement es58x_device:opened_channel_cnt is simplified
accordingly fixing the bug reported in [1]. We do not check again for
ASSERST_RTNL() as this is already done by the callers.

[1] https://lore.kernel.org/linux-can/20220201140351.GA2548@kili/T/#u
[2] https://elixir.bootlin.com/linux/v5.16/source/net/core/dev.c#L1463
[3] https://elixir.bootlin.com/linux/v5.16/source/net/core/dev.c#L1541

Fixes: 8537257874e9 ("can: etas_es58x: add core support for ETAS ES58X CAN USB interfaces")
Link: https://lore.kernel.org/all/20220212112713.577957-1-mailhol.vincent@wanadoo.fr
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/etas_es58x/es58x_core.c | 9 +++++----
 drivers/net/can/usb/etas_es58x/es58x_core.h | 8 +++++---
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c b/drivers/net/can/usb/etas_es58x/es58x_core.c
index fb07c33ba0c3..78d0a5947ba1 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -1787,7 +1787,7 @@ static int es58x_open(struct net_device *netdev)
 	struct es58x_device *es58x_dev = es58x_priv(netdev)->es58x_dev;
 	int ret;
 
-	if (atomic_inc_return(&es58x_dev->opened_channel_cnt) == 1) {
+	if (!es58x_dev->opened_channel_cnt) {
 		ret = es58x_alloc_rx_urbs(es58x_dev);
 		if (ret)
 			return ret;
@@ -1805,12 +1805,13 @@ static int es58x_open(struct net_device *netdev)
 	if (ret)
 		goto free_urbs;
 
+	es58x_dev->opened_channel_cnt++;
 	netif_start_queue(netdev);
 
 	return ret;
 
  free_urbs:
-	if (atomic_dec_and_test(&es58x_dev->opened_channel_cnt))
+	if (!es58x_dev->opened_channel_cnt)
 		es58x_free_urbs(es58x_dev);
 	netdev_err(netdev, "%s: Could not open the network device: %pe\n",
 		   __func__, ERR_PTR(ret));
@@ -1845,7 +1846,8 @@ static int es58x_stop(struct net_device *netdev)
 
 	es58x_flush_pending_tx_msg(netdev);
 
-	if (atomic_dec_and_test(&es58x_dev->opened_channel_cnt))
+	es58x_dev->opened_channel_cnt--;
+	if (!es58x_dev->opened_channel_cnt)
 		es58x_free_urbs(es58x_dev);
 
 	return 0;
@@ -2214,7 +2216,6 @@ static struct es58x_device *es58x_init_es58x_dev(struct usb_interface *intf,
 	init_usb_anchor(&es58x_dev->tx_urbs_idle);
 	init_usb_anchor(&es58x_dev->tx_urbs_busy);
 	atomic_set(&es58x_dev->tx_urbs_idle_cnt, 0);
-	atomic_set(&es58x_dev->opened_channel_cnt, 0);
 	usb_set_intfdata(intf, es58x_dev);
 
 	es58x_dev->rx_pipe = usb_rcvbulkpipe(es58x_dev->udev,
diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.h b/drivers/net/can/usb/etas_es58x/es58x_core.h
index 826a15871573..e5033cb5e695 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.h
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.h
@@ -373,8 +373,6 @@ struct es58x_operators {
  *	queue wake/stop logic should prevent this URB from getting
  *	empty. Please refer to es58x_get_tx_urb() for more details.
  * @tx_urbs_idle_cnt: number of urbs in @tx_urbs_idle.
- * @opened_channel_cnt: number of channels opened (c.f. es58x_open()
- *	and es58x_stop()).
  * @ktime_req_ns: kernel timestamp when es58x_set_realtime_diff_ns()
  *	was called.
  * @realtime_diff_ns: difference in nanoseconds between the clocks of
@@ -384,6 +382,10 @@ struct es58x_operators {
  *	in RX branches.
  * @rx_max_packet_size: Maximum length of bulk-in URB.
  * @num_can_ch: Number of CAN channel (i.e. number of elements of @netdev).
+ * @opened_channel_cnt: number of channels opened. Free of race
+ *	conditions because its two users (net_device_ops:ndo_open()
+ *	and net_device_ops:ndo_close()) guarantee that the network
+ *	stack big kernel lock (a.k.a. rtnl_mutex) is being hold.
  * @rx_cmd_buf_len: Length of @rx_cmd_buf.
  * @rx_cmd_buf: The device might split the URB commands in an
  *	arbitrary amount of pieces. This buffer is used to concatenate
@@ -406,7 +408,6 @@ struct es58x_device {
 	struct usb_anchor tx_urbs_busy;
 	struct usb_anchor tx_urbs_idle;
 	atomic_t tx_urbs_idle_cnt;
-	atomic_t opened_channel_cnt;
 
 	u64 ktime_req_ns;
 	s64 realtime_diff_ns;
@@ -415,6 +416,7 @@ struct es58x_device {
 
 	u16 rx_max_packet_size;
 	u8 num_can_ch;
+	u8 opened_channel_cnt;
 
 	u16 rx_cmd_buf_len;
 	union es58x_urb_cmd rx_cmd_buf;
-- 
2.34.1



