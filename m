Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D13B71B0AF2
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbgDTMwB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:52:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:44202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728589AbgDTMrx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:47:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 356E6206D4;
        Mon, 20 Apr 2020 12:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386872;
        bh=Xw6XtnI1P4r4jz0fwH94cuSkePcfAi2Pj/GtL9L6O44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LMhMGvmrs5egHxY3El+zaPreA88RgfDSV17R66NztBoRj3QSF6YzbXEoqbR90TJso
         4MMAikLsH+2+JfABGwZgy6YzQ/BZxdNndKDhrTTQCeBWjJ2lfvHU3TLxcR9J3Js5AH
         NWeil8hl/S38ne2DUaxR9c0Apm93nFD9CK0tMXoI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sumit Garg <sumit.garg@linaro.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.4 46/60] mac80211: fix race in ieee80211_register_hw()
Date:   Mon, 20 Apr 2020 14:39:24 +0200
Message-Id: <20200420121512.904401756@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121500.490651540@linuxfoundation.org>
References: <20200420121500.490651540@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sumit Garg <sumit.garg@linaro.org>

commit 52e04b4ce5d03775b6a78f3ed1097480faacc9fd upstream.

A race condition leading to a kernel crash is observed during invocation
of ieee80211_register_hw() on a dragonboard410c device having wcn36xx
driver built as a loadable module along with a wifi manager in user-space
waiting for a wifi device (wlanX) to be active.

Sequence diagram for a particular kernel crash scenario:

    user-space  ieee80211_register_hw()  ieee80211_tasklet_handler()
    ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
       |                    |                 |
       |<---phy0----wiphy_register()          |
       |-----iwd if_add---->|                 |
       |                    |<---IRQ----(RX packet)
       |              Kernel crash            |
       |              due to unallocated      |
       |              workqueue.              |
       |                    |                 |
       |       alloc_ordered_workqueue()      |
       |                    |                 |
       |              Misc wiphy init.        |
       |                    |                 |
       |            ieee80211_if_add()        |
       |                    |                 |

As evident from above sequence diagram, this race condition isn't specific
to a particular wifi driver but rather the initialization sequence in
ieee80211_register_hw() needs to be fixed. So re-order the initialization
sequence and the updated sequence diagram would look like:

    user-space  ieee80211_register_hw()  ieee80211_tasklet_handler()
    ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
       |                    |                 |
       |       alloc_ordered_workqueue()      |
       |                    |                 |
       |              Misc wiphy init.        |
       |                    |                 |
       |<---phy0----wiphy_register()          |
       |-----iwd if_add---->|                 |
       |                    |<---IRQ----(RX packet)
       |                    |                 |
       |            ieee80211_if_add()        |
       |                    |                 |

Cc: stable@vger.kernel.org
Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
Link: https://lore.kernel.org/r/1586254255-28713-1-git-send-email-sumit.garg@linaro.org
[Johannes: fix rtnl imbalances]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/main.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1045,7 +1045,7 @@ int ieee80211_register_hw(struct ieee802
 		local->hw.wiphy->signal_type = CFG80211_SIGNAL_TYPE_UNSPEC;
 		if (hw->max_signal <= 0) {
 			result = -EINVAL;
-			goto fail_wiphy_register;
+			goto fail_workqueue;
 		}
 	}
 
@@ -1107,7 +1107,7 @@ int ieee80211_register_hw(struct ieee802
 
 	result = ieee80211_init_cipher_suites(local);
 	if (result < 0)
-		goto fail_wiphy_register;
+		goto fail_workqueue;
 
 	if (!local->ops->remain_on_channel)
 		local->hw.wiphy->max_remain_on_channel_duration = 5000;
@@ -1133,10 +1133,6 @@ int ieee80211_register_hw(struct ieee802
 
 	local->hw.wiphy->max_num_csa_counters = IEEE80211_MAX_CSA_COUNTERS_NUM;
 
-	result = wiphy_register(local->hw.wiphy);
-	if (result < 0)
-		goto fail_wiphy_register;
-
 	/*
 	 * We use the number of queues for feature tests (QoS, HT) internally
 	 * so restrict them appropriately.
@@ -1192,9 +1188,9 @@ int ieee80211_register_hw(struct ieee802
 		goto fail_flows;
 
 	rtnl_lock();
-
 	result = ieee80211_init_rate_ctrl_alg(local,
 					      hw->rate_control_algorithm);
+	rtnl_unlock();
 	if (result < 0) {
 		wiphy_debug(local->hw.wiphy,
 			    "Failed to initialize rate control algorithm\n");
@@ -1248,6 +1244,12 @@ int ieee80211_register_hw(struct ieee802
 		local->sband_allocated |= BIT(band);
 	}
 
+	result = wiphy_register(local->hw.wiphy);
+	if (result < 0)
+		goto fail_wiphy_register;
+
+	rtnl_lock();
+
 	/* add one default STA interface if supported */
 	if (local->hw.wiphy->interface_modes & BIT(NL80211_IFTYPE_STATION) &&
 	    !ieee80211_hw_check(hw, NO_AUTO_VIF)) {
@@ -1287,17 +1289,17 @@ int ieee80211_register_hw(struct ieee802
 #if defined(CONFIG_INET) || defined(CONFIG_IPV6)
  fail_ifa:
 #endif
+	wiphy_unregister(local->hw.wiphy);
+ fail_wiphy_register:
 	rtnl_lock();
 	rate_control_deinitialize(local);
 	ieee80211_remove_interfaces(local);
- fail_rate:
 	rtnl_unlock();
+ fail_rate:
  fail_flows:
 	ieee80211_led_exit(local);
 	destroy_workqueue(local->workqueue);
  fail_workqueue:
-	wiphy_unregister(local->hw.wiphy);
- fail_wiphy_register:
 	if (local->wiphy_ciphers_allocated)
 		kfree(local->hw.wiphy->cipher_suites);
 	kfree(local->int_scan_req);
@@ -1347,8 +1349,8 @@ void ieee80211_unregister_hw(struct ieee
 	skb_queue_purge(&local->skb_queue_unreliable);
 	skb_queue_purge(&local->skb_queue_tdls_chsw);
 
-	destroy_workqueue(local->workqueue);
 	wiphy_unregister(local->hw.wiphy);
+	destroy_workqueue(local->workqueue);
 	ieee80211_led_exit(local);
 	kfree(local->int_scan_req);
 }


