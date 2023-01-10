Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 383E4664AFD
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:38:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239473AbjAJSiP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:38:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239503AbjAJSht (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:37:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DC498E9B9
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:33:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E542E61866
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:33:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3702C433EF;
        Tue, 10 Jan 2023 18:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375582;
        bh=HYXyHXdqUa4HxQZQeVe7B60xLLqKpBhVx6oSYUYuaF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AJ1gauCG5P8jVXIYZc8OKWmPjGdaTlIdW3ZjmsgPWgsoIZ2sh3JSYuLn0ZnMO8lsn
         KlUVloFAgJiRk1e9voNix8Lb14BP+80LHnV2bv+XKWiTiksDVnNZLxW2wqQGFHHizm
         8+6MAMHSzBSs0aEVyGt5nEK3xarc/im0KNMCvcR0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ronak Doshi <doshir@vmware.com>,
        Peng Li <lpeng@vmware.com>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 204/290] vmxnet3: correctly report csum_level for encapsulated packet
Date:   Tue, 10 Jan 2023 19:04:56 +0100
Message-Id: <20230110180039.024236208@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
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

From: Ronak Doshi <doshir@vmware.com>

[ Upstream commit 3d8f2c4269d08f8793e946279dbdf5e972cc4911 ]

Commit dacce2be3312 ("vmxnet3: add geneve and vxlan tunnel offload
support") added support for encapsulation offload. However, the
pathc did not report correctly the csum_level for encapsulated packet.

This patch fixes this issue by reporting correct csum level for the
encapsulated packet.

Fixes: dacce2be3312 ("vmxnet3: add geneve and vxlan tunnel offload support")
Signed-off-by: Ronak Doshi <doshir@vmware.com>
Acked-by: Peng Li <lpeng@vmware.com>
Link: https://lore.kernel.org/r/20221220202556.24421-1-doshir@vmware.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vmxnet3/vmxnet3_drv.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 21896e221300..b88092a6bc85 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -1242,6 +1242,10 @@ vmxnet3_rx_csum(struct vmxnet3_adapter *adapter,
 		    (le32_to_cpu(gdesc->dword[3]) &
 		     VMXNET3_RCD_CSUM_OK) == VMXNET3_RCD_CSUM_OK) {
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
+			if ((le32_to_cpu(gdesc->dword[0]) &
+				     (1UL << VMXNET3_RCD_HDR_INNER_SHIFT))) {
+				skb->csum_level = 1;
+			}
 			WARN_ON_ONCE(!(gdesc->rcd.tcp || gdesc->rcd.udp) &&
 				     !(le32_to_cpu(gdesc->dword[0]) &
 				     (1UL << VMXNET3_RCD_HDR_INNER_SHIFT)));
@@ -1251,6 +1255,10 @@ vmxnet3_rx_csum(struct vmxnet3_adapter *adapter,
 		} else if (gdesc->rcd.v6 && (le32_to_cpu(gdesc->dword[3]) &
 					     (1 << VMXNET3_RCD_TUC_SHIFT))) {
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
+			if ((le32_to_cpu(gdesc->dword[0]) &
+				     (1UL << VMXNET3_RCD_HDR_INNER_SHIFT))) {
+				skb->csum_level = 1;
+			}
 			WARN_ON_ONCE(!(gdesc->rcd.tcp || gdesc->rcd.udp) &&
 				     !(le32_to_cpu(gdesc->dword[0]) &
 				     (1UL << VMXNET3_RCD_HDR_INNER_SHIFT)));
-- 
2.35.1



