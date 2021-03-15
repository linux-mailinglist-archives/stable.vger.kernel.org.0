Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7939D33B77E
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:01:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233025AbhCOOAe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:00:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:37670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232147AbhCON7O (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4151364F19;
        Mon, 15 Mar 2021 13:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816731;
        bh=Jl3E8f1Oe96Wvoxz7fOTbqvT+/AHJp0BHWTCpa3LvGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nc9f1Abm7F2nFeg2yvfEHtUJVZlVJSnY62gXzupVXOy8u00+uYrD8IxpM8M/n0wcR
         ArvqHYEChIRkc81XeXpPHzspXJhuXwrcjO47wPB8SgdW+raaam6Tl7QHmNEpchOgo+
         lucAObL7zN4F57IWeLZvBEQ2Ch8llOUHAOcc8I6E=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.11 090/306] net: hns3: fix query vlan mask value error for flow director
Date:   Mon, 15 Mar 2021 14:52:33 +0100
Message-Id: <20210315135510.690750167@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Jian Shen <shenjian15@huawei.com>

commit c75ec148a316e8cf52274d16b9b422703b96f5ce upstream.

Currently, the driver returns VLAN_VID_MASK for vlan mask field,
when get flow director rule information for rule doesn't use vlan.
It may cause the vlan mask value display as 0xf000 in this
case, like below:

estuary:/$ ethtool -u eth1
50 RX rings available
Total 1 rules

Filter: 2
Rule Type: TCP over IPv4
Src IP addr: 0.0.0.0 mask: 255.255.255.255
Dest IP addr: 0.0.0.0 mask: 255.255.255.255
TOS: 0x0 mask: 0xff
Src port: 0 mask: 0xffff
Dest port: 0 mask: 0xffff
VLAN EtherType: 0x0 mask: 0xffff
VLAN: 0x0 mask: 0xf000
User-defined: 0x1234 mask: 0x0
Action: Direct to queue 3

Fix it by return 0.

Fixes: 05c2314fe6a8 ("net: hns3: Add support for rule query of flow director")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -6283,8 +6283,7 @@ static void hclge_fd_get_ext_info(struct
 		fs->h_ext.vlan_tci = cpu_to_be16(rule->tuples.vlan_tag1);
 		fs->m_ext.vlan_tci =
 				rule->unused_tuple & BIT(INNER_VLAN_TAG_FST) ?
-				cpu_to_be16(VLAN_VID_MASK) :
-				cpu_to_be16(rule->tuples_mask.vlan_tag1);
+				0 : cpu_to_be16(rule->tuples_mask.vlan_tag1);
 	}
 
 	if (fs->flow_type & FLOW_MAC_EXT) {


