Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE4A66CC4D2
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbjC1PJI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:09:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230468AbjC1PJH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:09:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61521EF8A
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:07:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F13176182C
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:07:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A4B1C433D2;
        Tue, 28 Mar 2023 15:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680016060;
        bh=l0jwYSHTdrJNcOI17zfXhy5yc1JpKFo34IZ+YpP76AU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AGXHd72jLDic7luRJhfFRz7h9z0fy1fUG7zPtFRQF4eHWnh5Yw5Q/vRynHNV1Oszt
         tY4QA3JpPRTYmwGQOHuOiBN6PzMP+oeZAVhNm+SVpSH8kka5dGb/1+vz2rvPeRSzCZ
         9LwTrmtNqRKlhhot13Et4qwJVxBhMwMQk9m8DHEY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 050/146] net: dsa: tag_brcm: legacy: fix daisy-chained switches
Date:   Tue, 28 Mar 2023 16:42:19 +0200
Message-Id: <20230328142604.785791374@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142602.660084725@linuxfoundation.org>
References: <20230328142602.660084725@linuxfoundation.org>
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

From: Álvaro Fernández Rojas <noltari@gmail.com>

[ Upstream commit 032a954061afd4b7426c3eb6bfd2952ef1e9a384 ]

When BCM63xx internal switches are connected to switches with a 4-byte
Broadcom tag, it does not identify the packet as VLAN tagged, so it adds one
based on its PVID (which is likely 0).
Right now, the packet is received by the BCM63xx internal switch and the 6-byte
tag is properly processed. The next step would to decode the corresponding
4-byte tag. However, the internal switch adds an invalid VLAN tag after the
6-byte tag and the 4-byte tag handling fails.
In order to fix this we need to remove the invalid VLAN tag after the 6-byte
tag before passing it to the 4-byte tag decoding.

Fixes: 964dbf186eaa ("net: dsa: tag_brcm: add support for legacy tags")
Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20230319095540.239064-1-noltari@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/tag_brcm.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
index 96dbb8ee2fee1..ed5f68c4f1dad 100644
--- a/net/dsa/tag_brcm.c
+++ b/net/dsa/tag_brcm.c
@@ -7,6 +7,7 @@
 
 #include <linux/dsa/brcm.h>
 #include <linux/etherdevice.h>
+#include <linux/if_vlan.h>
 #include <linux/list.h>
 #include <linux/slab.h>
 
@@ -248,6 +249,7 @@ static struct sk_buff *brcm_leg_tag_xmit(struct sk_buff *skb,
 static struct sk_buff *brcm_leg_tag_rcv(struct sk_buff *skb,
 					struct net_device *dev)
 {
+	int len = BRCM_LEG_TAG_LEN;
 	int source_port;
 	u8 *brcm_tag;
 
@@ -262,12 +264,16 @@ static struct sk_buff *brcm_leg_tag_rcv(struct sk_buff *skb,
 	if (!skb->dev)
 		return NULL;
 
+	/* VLAN tag is added by BCM63xx internal switch */
+	if (netdev_uses_dsa(skb->dev))
+		len += VLAN_HLEN;
+
 	/* Remove Broadcom tag and update checksum */
-	skb_pull_rcsum(skb, BRCM_LEG_TAG_LEN);
+	skb_pull_rcsum(skb, len);
 
 	dsa_default_offload_fwd_mark(skb);
 
-	dsa_strip_etype_header(skb, BRCM_LEG_TAG_LEN);
+	dsa_strip_etype_header(skb, len);
 
 	return skb;
 }
-- 
2.39.2



