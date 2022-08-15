Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30C605936A9
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233435AbiHOTDD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245109AbiHOTBR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:01:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D5E24B0FD;
        Mon, 15 Aug 2022 11:32:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9BF6EB8106C;
        Mon, 15 Aug 2022 18:32:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB253C433C1;
        Mon, 15 Aug 2022 18:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588368;
        bh=grTevtiDtZeHGoNwnZ4+5BrwyLfTwOyIQ6OsoxiYJ1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BTGZNCqWcOdw+eCswi2KtL4pCY0tKmnKmzSxT9RiPiKXbfppEjBznfdidx3hkeLY+
         y0RUvMZejwDSDCj/qdf5VEysJ/NE9zQT/UHmMNqETszt4Lb4R9ROr1Jg8s0xiiNlRE
         RbOLJJZq9DpWrdfwUdkZEv5YcW4I/ByAHtQOYHmQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        Grzegorz Szczurek <grzegorzx.szczurek@intel.com>,
        Kiran Patil <kiran.patil@intel.com>,
        Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
        Bharathi Sreenivas <bharathi.sreenivas@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 380/779] iavf: Fix tc qdisc show listing too many queues
Date:   Mon, 15 Aug 2022 20:00:24 +0200
Message-Id: <20220815180353.534510020@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>

[ Upstream commit 93cb804edab1b9a5bb7bb7b6824012dbb20abf22 ]

Fix tc qdisc show dev <ethX> root displaying too many fq_codel qdiscs.
tc_modify_qdisc, which is caller of ndo_setup_tc, expects driver to call
netif_set_real_num_tx_queues, which prepares qdiscs.
Without this patch, fq_codel qdiscs would not be adjusted to number of
queues on VF.
e.g.:
tc qdisc show dev <ethX>
qdisc mq 0: root
qdisc fq_codel 0: parent :4 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
qdisc fq_codel 0: parent :3 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
qdisc fq_codel 0: parent :2 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
qdisc fq_codel 0: parent :1 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
tc qdisc add dev <ethX> root mqprio num_tc 2 map 1 0 0 0 0 0 0 0 queues 1@0 1@1 hw 1 mode channel shaper bw_rlimit max_rate 5000Mbit 150Mbit
tc qdisc show dev <ethX>
qdisc mqprio 8003: root tc 2 map 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
             queues:(0:0) (1:1)
             mode:channel
             shaper:bw_rlimit   max_rate:5Gbit 150Mbit
qdisc fq_codel 0: parent 8003:4 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
qdisc fq_codel 0: parent 8003:3 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
qdisc fq_codel 0: parent 8003:2 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
qdisc fq_codel 0: parent 8003:1 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64

While after fix:
tc qdisc add dev <ethX> root mqprio num_tc 2 map 1 0 0 0 0 0 0 0 queues 1@0 1@1 hw 1 mode channel shaper bw_rlimit max_rate 5000Mbit 150Mbit
tc qdisc show dev <ethX> #should show 2, shows 4
qdisc mqprio 8004: root tc 2 map 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
             queues:(0:0) (1:1)
             mode:channel
             shaper:bw_rlimit   max_rate:5Gbit 150Mbit
qdisc fq_codel 0: parent 8004:2 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
qdisc fq_codel 0: parent 8004:1 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64

Fixes: d5b33d024496 ("i40evf: add ndo_setup_tc callback to i40evf")
Signed-off-by: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
Co-developed-by: Grzegorz Szczurek <grzegorzx.szczurek@intel.com>
Signed-off-by: Grzegorz Szczurek <grzegorzx.szczurek@intel.com>
Co-developed-by: Kiran Patil <kiran.patil@intel.com>
Signed-off-by: Kiran Patil <kiran.patil@intel.com>
Signed-off-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Tested-by: Bharathi Sreenivas <bharathi.sreenivas@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf.h      |  5 +++++
 drivers/net/ethernet/intel/iavf/iavf_main.c | 21 +++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index ab84fc83352f..99d2b090a1e6 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -378,6 +378,11 @@ struct iavf_adapter {
 	/* lock to protect access to the cloud filter list */
 	spinlock_t cloud_filter_list_lock;
 	u16 num_cloud_filters;
+	/* snapshot of "num_active_queues" before setup_tc for qdisc add
+	 * is invoked. This information is useful during qdisc del flow,
+	 * to restore correct number of queues
+	 */
+	int orig_num_active_queues;
 
 #define IAVF_MAX_FDIR_FILTERS 128	/* max allowed Flow Director filters */
 	u16 fdir_active_fltr;
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 067f0b265e7d..e2349131a428 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2839,6 +2839,7 @@ static int __iavf_setup_tc(struct net_device *netdev, void *type_data)
 			netif_tx_disable(netdev);
 			iavf_del_all_cloud_filters(adapter);
 			adapter->aq_required = IAVF_FLAG_AQ_DISABLE_CHANNELS;
+			total_qps = adapter->orig_num_active_queues;
 			goto exit;
 		} else {
 			return -EINVAL;
@@ -2882,7 +2883,21 @@ static int __iavf_setup_tc(struct net_device *netdev, void *type_data)
 				adapter->ch_config.ch_info[i].offset = 0;
 			}
 		}
+
+		/* Take snapshot of original config such as "num_active_queues"
+		 * It is used later when delete ADQ flow is exercised, so that
+		 * once delete ADQ flow completes, VF shall go back to its
+		 * original queue configuration
+		 */
+
+		adapter->orig_num_active_queues = adapter->num_active_queues;
+
+		/* Store queue info based on TC so that VF gets configured
+		 * with correct number of queues when VF completes ADQ config
+		 * flow
+		 */
 		adapter->ch_config.total_qps = total_qps;
+
 		netif_tx_stop_all_queues(netdev);
 		netif_tx_disable(netdev);
 		adapter->aq_required |= IAVF_FLAG_AQ_ENABLE_CHANNELS;
@@ -2899,6 +2914,12 @@ static int __iavf_setup_tc(struct net_device *netdev, void *type_data)
 		}
 	}
 exit:
+	if (test_bit(__IAVF_IN_REMOVE_TASK, &adapter->crit_section))
+		return 0;
+
+	netif_set_real_num_rx_queues(netdev, total_qps);
+	netif_set_real_num_tx_queues(netdev, total_qps);
+
 	return ret;
 }
 
-- 
2.35.1



