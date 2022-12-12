Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5F2064A0C5
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231892AbiLLNaQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:30:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232054AbiLLNaP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:30:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C09E6DE
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:30:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C83B61042
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5077FC433F0;
        Mon, 12 Dec 2022 13:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670851813;
        bh=VN7Lp/Eykc67dy9hNvpwrRqy2encAQEIsVaJRELYcKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hp160OE5CNi+THs3gi/RyL//i+gnkp5As6sgTIcY/dUd86rHqYMVJV+929mHWK4qN
         76eQFOW8HhTCwgBMBbHaCyjTyi8FEkDZi9cjbF495uF3C/2fEy8F1mftsBeqUXmfoX
         a5BWrOIQkwjBlBvh++DtlAupHCz0qv7oa85X5rPY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ronak Doshi <doshir@vmware.com>,
        Guolin Yang <gyang@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 076/123] vmxnet3: use correct intrConf reference when using extended queues
Date:   Mon, 12 Dec 2022 14:17:22 +0100
Message-Id: <20221212130930.155335224@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130926.811961601@linuxfoundation.org>
References: <20221212130926.811961601@linuxfoundation.org>
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

[ Upstream commit 409e8ec8c5825591895937b8499b54aa2476fae7 ]

Commit 39f9895a00f4 ("vmxnet3: add support for 32 Tx/Rx queues")
added support for 32Tx/Rx queues. As a part of this patch, intrConf
structure was extended to incorporate increased queues.

This patch fixes the issue where incorrect reference is being used.

Fixes: 39f9895a00f4 ("vmxnet3: add support for 32 Tx/Rx queues")
Signed-off-by: Ronak Doshi <doshir@vmware.com>
Acked-by: Guolin Yang <gyang@vmware.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vmxnet3/vmxnet3_drv.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 44a0d469f3cf..21896e221300 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -75,8 +75,14 @@ vmxnet3_enable_all_intrs(struct vmxnet3_adapter *adapter)
 
 	for (i = 0; i < adapter->intr.num_intrs; i++)
 		vmxnet3_enable_intr(adapter, i);
-	adapter->shared->devRead.intrConf.intrCtrl &=
+	if (!VMXNET3_VERSION_GE_6(adapter) ||
+	    !adapter->queuesExtEnabled) {
+		adapter->shared->devRead.intrConf.intrCtrl &=
 					cpu_to_le32(~VMXNET3_IC_DISABLE_ALL);
+	} else {
+		adapter->shared->devReadExt.intrConfExt.intrCtrl &=
+					cpu_to_le32(~VMXNET3_IC_DISABLE_ALL);
+	}
 }
 
 
@@ -85,8 +91,14 @@ vmxnet3_disable_all_intrs(struct vmxnet3_adapter *adapter)
 {
 	int i;
 
-	adapter->shared->devRead.intrConf.intrCtrl |=
+	if (!VMXNET3_VERSION_GE_6(adapter) ||
+	    !adapter->queuesExtEnabled) {
+		adapter->shared->devRead.intrConf.intrCtrl |=
 					cpu_to_le32(VMXNET3_IC_DISABLE_ALL);
+	} else {
+		adapter->shared->devReadExt.intrConfExt.intrCtrl |=
+					cpu_to_le32(VMXNET3_IC_DISABLE_ALL);
+	}
 	for (i = 0; i < adapter->intr.num_intrs; i++)
 		vmxnet3_disable_intr(adapter, i);
 }
-- 
2.35.1



