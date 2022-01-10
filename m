Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5C334890BA
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:24:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239260AbiAJHYU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:24:20 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:34868 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239232AbiAJHYN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:24:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7ED60611AD;
        Mon, 10 Jan 2022 07:24:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EB1BC36AED;
        Mon, 10 Jan 2022 07:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799452;
        bh=84qzenAi/MN28XMQ5nketlIT30hEZ5thlwSQ3CPqIz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1rG54k8zR6g8EFjseNV18WOTgFw3UHE3PBsLq8Jxj1l5cjXIbju4ARFYC0HoKDD16
         xtixJt7/7vwqPJPWVNu35Y4q9MLdOilqUja+S8lng8Fix4O2KoyxqqeD0QJkNZc0Qc
         wKkxg8VSwd7SgCp68sMP+ZsGNOU+LnHWDIbpkMOo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Lukasz Cieplicki <lukaszx.cieplicki@intel.com>,
        Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 4.4 05/14] i40e: Fix incorrect netdevs real number of RX/TX queues
Date:   Mon, 10 Jan 2022 08:22:44 +0100
Message-Id: <20220110071811.954298622@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071811.779189823@linuxfoundation.org>
References: <20220110071811.779189823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jedrzej Jagielski <jedrzej.jagielski@intel.com>

commit e738451d78b2f8a9635d66c6a87f304b4d965f7a upstream.

There was a wrong queues representation in sysfs during
driver's reinitialization in case of online cpus number is
less than combined queues. It was caused by stopped
NetworkManager, which is responsible for calling vsi_open
function during driver's initialization.
In specific situation (ex. 12 cpus online) there were 16 queues
in /sys/class/net/<iface>/queues. In case of modifying queues with
value higher, than number of online cpus, then it caused write
errors and other errors.
Add updating of sysfs's queues representation during driver
initialization.

Fixes: 41c445ff0f48 ("i40e: main driver core")
Signed-off-by: Lukasz Cieplicki <lukaszx.cieplicki@intel.com>
Signed-off-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c |   32 +++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -5361,6 +5361,27 @@ int i40e_open(struct net_device *netdev)
 }
 
 /**
+ * i40e_netif_set_realnum_tx_rx_queues - Update number of tx/rx queues
+ * @vsi: vsi structure
+ *
+ * This updates netdev's number of tx/rx queues
+ *
+ * Returns status of setting tx/rx queues
+ **/
+static int i40e_netif_set_realnum_tx_rx_queues(struct i40e_vsi *vsi)
+{
+	int ret;
+
+	ret = netif_set_real_num_rx_queues(vsi->netdev,
+					   vsi->num_queue_pairs);
+	if (ret)
+		return ret;
+
+	return netif_set_real_num_tx_queues(vsi->netdev,
+					    vsi->num_queue_pairs);
+}
+
+/**
  * i40e_vsi_open -
  * @vsi: the VSI to open
  *
@@ -5394,13 +5415,7 @@ int i40e_vsi_open(struct i40e_vsi *vsi)
 			goto err_setup_rx;
 
 		/* Notify the stack of the actual queue counts. */
-		err = netif_set_real_num_tx_queues(vsi->netdev,
-						   vsi->num_queue_pairs);
-		if (err)
-			goto err_set_queues;
-
-		err = netif_set_real_num_rx_queues(vsi->netdev,
-						   vsi->num_queue_pairs);
+		err = i40e_netif_set_realnum_tx_rx_queues(vsi);
 		if (err)
 			goto err_set_queues;
 
@@ -9415,6 +9430,9 @@ struct i40e_vsi *i40e_vsi_setup(struct i
 		ret = i40e_config_netdev(vsi);
 		if (ret)
 			goto err_netdev;
+		ret = i40e_netif_set_realnum_tx_rx_queues(vsi);
+		if (ret)
+			goto err_netdev;
 		ret = register_netdev(vsi->netdev);
 		if (ret)
 			goto err_netdev;


