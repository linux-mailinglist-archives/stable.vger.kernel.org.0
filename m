Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 131495C0328
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 18:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232089AbiIUQAq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 12:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232577AbiIUP77 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:59:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1118A262C;
        Wed, 21 Sep 2022 08:53:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09DB76314A;
        Wed, 21 Sep 2022 15:52:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA4BC433C1;
        Wed, 21 Sep 2022 15:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775539;
        bh=pgA44nAsDatBh2OWn9vathmo8HkM6qQ8de/WrjrRmi0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GoIhRxQ6Cv3zhWG7tkE4w3wXM8wbx3QHnHfLd8ToWoN4p7HHGgaTnZFF0JO0fXC/+
         pHysL3FQVPl/gD8VlP6Cma8g4old77a9DGdGAb+fJ0ku6Fi1ys8sUIUwvcJHtfiOh2
         2s39OxlUZlggfD/lNSy5fjwgU1yfxvb1/Ci0bnOA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Soenke Huster <soenke.huster@eknoes.de>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 30/39] wifi: mac80211_hwsim: check length for virtio packets
Date:   Wed, 21 Sep 2022 17:46:35 +0200
Message-Id: <20220921153646.719004184@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153645.663680057@linuxfoundation.org>
References: <20220921153645.663680057@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Soenke Huster <soenke.huster@eknoes.de>

[ Upstream commit 8c0427842aaef161a38ac83b7e8d8fe050b4be04 ]

An invalid packet with a length shorter than the specified length in the
netlink header can lead to use-after-frees and slab-out-of-bounds in the
processing of the netlink attributes, such as the following:

  BUG: KASAN: slab-out-of-bounds in __nla_validate_parse+0x1258/0x2010
  Read of size 2 at addr ffff88800ac7952c by task kworker/0:1/12

  Workqueue: events hwsim_virtio_rx_work
  Call Trace:
   <TASK>
   dump_stack_lvl+0x45/0x5d
   print_report.cold+0x5e/0x5e5
   kasan_report+0xb1/0x1c0
   __nla_validate_parse+0x1258/0x2010
   __nla_parse+0x22/0x30
   hwsim_virtio_handle_cmd.isra.0+0x13f/0x2d0
   hwsim_virtio_rx_work+0x1b2/0x370
   process_one_work+0x8df/0x1530
   worker_thread+0x575/0x11a0
   kthread+0x29d/0x340
   ret_from_fork+0x22/0x30
 </TASK>

Discarding packets with an invalid length solves this.
Therefore, skb->len must be set at reception.

Change-Id: Ieaeb9a4c62d3beede274881a7c2722c6c6f477b6
Signed-off-by: Soenke Huster <soenke.huster@eknoes.de>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mac80211_hwsim.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 8e412125a49c..50190ded7edc 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -4209,6 +4209,10 @@ static int hwsim_virtio_handle_cmd(struct sk_buff *skb)
 
 	nlh = nlmsg_hdr(skb);
 	gnlh = nlmsg_data(nlh);
+
+	if (skb->len < nlh->nlmsg_len)
+		return -EINVAL;
+
 	err = genlmsg_parse(nlh, &hwsim_genl_family, tb, HWSIM_ATTR_MAX,
 			    hwsim_genl_policy, NULL);
 	if (err) {
@@ -4251,7 +4255,8 @@ static void hwsim_virtio_rx_work(struct work_struct *work)
 	spin_unlock_irqrestore(&hwsim_virtio_lock, flags);
 
 	skb->data = skb->head;
-	skb_set_tail_pointer(skb, len);
+	skb_reset_tail_pointer(skb);
+	skb_put(skb, len);
 	hwsim_virtio_handle_cmd(skb);
 
 	spin_lock_irqsave(&hwsim_virtio_lock, flags);
-- 
2.35.1



