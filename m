Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE9B6BB341
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:42:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233030AbjCOMm4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:42:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233045AbjCOMmf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:42:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B44E82BEF3
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:41:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D91361D69
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:41:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43022C433EF;
        Wed, 15 Mar 2023 12:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678884078;
        bh=feaYzCQmnolwAAkCECIkZtYjMX1x4GiBId7TUk3zZN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tj2is6Ocsy6N6Rh43BsFBfPixJCfmkvyNn7pdVtw0Mc8RmBZfRRNIjpmUdUNtmMbm
         /+ijtwVul0rBIuwIseVcneMktIeM8Med0NxWvAPj7gvVCLB83xwujzOESBPaf+0/J1
         ZmmqNMM1Qh9Z/t61O4b42nUXhtmzLwm8uZi5TJyQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Huanhuan Wang <huanhuan.wang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 069/141] nfp: fix esp-tx-csum-offload doesnt take effect
Date:   Wed, 15 Mar 2023 13:12:52 +0100
Message-Id: <20230315115742.060828108@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
References: <20230315115739.932786806@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huanhuan Wang <huanhuan.wang@corigine.com>

[ Upstream commit 1cf78d4c4144ffdbc2c9d505db482cb204bb480b ]

When esp-tx-csum-offload is set to on, the protocol stack shouldn't
calculate the IPsec offload packet's csum, but it does. Because the
callback `.ndo_features_check` incorrectly masked NETIF_F_CSUM_MASK bit.

Fixes: 57f273adbcd4 ("nfp: add framework to support ipsec offloading")
Signed-off-by: Huanhuan Wang <huanhuan.wang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 70d7484c82af4..1182fa48a3b54 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -38,6 +38,7 @@
 #include <net/tls.h>
 #include <net/vxlan.h>
 #include <net/xdp_sock_drv.h>
+#include <net/xfrm.h>
 
 #include "nfpcore/nfp_dev.h"
 #include "nfpcore/nfp_nsp.h"
@@ -1897,6 +1898,9 @@ nfp_net_features_check(struct sk_buff *skb, struct net_device *dev,
 			features &= ~NETIF_F_GSO_MASK;
 	}
 
+	if (xfrm_offload(skb))
+		return features;
+
 	/* VXLAN/GRE check */
 	switch (vlan_get_protocol(skb)) {
 	case htons(ETH_P_IP):
-- 
2.39.2



