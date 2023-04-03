Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3D96D4AC5
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234125AbjDCOuQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234043AbjDCOuB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:50:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E7F16979
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:49:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09CFFB81D75
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:48:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78804C433D2;
        Mon,  3 Apr 2023 14:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680533333;
        bh=KBfox2g9YW2SB/t/K3p4p2tza976T6QzWywv6Vl+qWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jjOIhWCdt8cwWrG3Olo9KHiDxS7X0UNt16U47zxBRO29uWk3l9RSSJle2j14CUSbg
         lSPgsoet2yZH7TJzoc7ZspN+RC1eRTto/P26KRrH7Dm8ASzMzqW2QtJPvy8y5DoF1k
         H14e3CXXqzQhE1LMgN4An0gDHllTpPiUY6p/NfYI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ronak Doshi <doshir@vmware.com>,
        Simon Horman <simon.horman@corigine.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.2 143/187] vmxnet3: use gro callback when UPT is enabled
Date:   Mon,  3 Apr 2023 16:09:48 +0200
Message-Id: <20230403140420.715359883@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
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

From: Ronak Doshi <doshir@vmware.com>

commit 3bced313b9a5a237c347e0f079c8c2fe4b3935aa upstream.

Currently, vmxnet3 uses GRO callback only if LRO is disabled. However,
on smartNic based setups where UPT is supported, LRO can be enabled
from guest VM but UPT devicve does not support LRO as of now. In such
cases, there can be performance degradation as GRO is not being done.

This patch fixes this issue by calling GRO API when UPT is enabled. We
use updateRxProd to determine if UPT mode is active or not.

To clarify few things discussed over the thread:
The patch is not neglecting any feature bits nor disabling GRO. It uses
GRO callback when UPT is active as LRO is not available in UPT.
GRO callback cannot be used as default for all cases as it degrades
performance for non-UPT cases or for cases when LRO is already done in
ESXi.

Cc: stable@vger.kernel.org
Fixes: 6f91f4ba046e ("vmxnet3: add support for capability registers")
Signed-off-by: Ronak Doshi <doshir@vmware.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/20230323200721.27622-1-doshir@vmware.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vmxnet3/vmxnet3_drv.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -1688,7 +1688,9 @@ not_lro:
 			if (unlikely(rcd->ts))
 				__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), rcd->tci);
 
-			if (adapter->netdev->features & NETIF_F_LRO)
+			/* Use GRO callback if UPT is enabled */
+			if ((adapter->netdev->features & NETIF_F_LRO) &&
+			    !rq->shared->updateRxProd)
 				netif_receive_skb(skb);
 			else
 				napi_gro_receive(&rq->napi, skb);


