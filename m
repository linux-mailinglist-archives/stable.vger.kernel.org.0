Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 937396353F9
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:02:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236959AbiKWJCL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:02:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236958AbiKWJCJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:02:09 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04FA61001DF
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:02:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 143ECCE20F4
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:02:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECFF0C433D6;
        Wed, 23 Nov 2022 09:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669194124;
        bh=KrvNOB/jWRk0+sIQgnh6ZQSThFAyEoNxallyG23zNL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KGnUarTP9L8F4d6KXAIhTb4WVDyZOomDfu12eN4zSYnbrxFqhpUQTb8h0XbBC7qvu
         W0p4VAKFFu1ySunulFg+e58QwMJrEPs9v3dnkHnXL5xv2ZRpINKSHwDT+409+4MqNi
         MBWeo6L4tIvBxY2BVKi002nRr3+LCjDzlhCifbgE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wei Yongjun <weiyongjun1@huawei.com>,
        Martin Schiller <ms@dev.tdt.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 51/88] net/x25: Fix skb leak in x25_lapb_receive_frame()
Date:   Wed, 23 Nov 2022 09:50:48 +0100
Message-Id: <20221123084550.291854144@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084548.535439312@linuxfoundation.org>
References: <20221123084548.535439312@linuxfoundation.org>
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

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 2929cceb2fcf0ded7182562e4888afafece82cce ]

x25_lapb_receive_frame() using skb_copy() to get a private copy of
skb, the new skb should be freed in the undersized/fragmented skb
error handling path. Otherwise there is a memory leak.

Fixes: cb101ed2c3c7 ("x25: Handle undersized/fragmented skbs")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Acked-by: Martin Schiller <ms@dev.tdt.de>
Link: https://lore.kernel.org/r/20221114110519.514538-1-weiyongjun@huaweicloud.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/x25/x25_dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/x25/x25_dev.c b/net/x25/x25_dev.c
index 30f71620d4e3..24f2676e3b66 100644
--- a/net/x25/x25_dev.c
+++ b/net/x25/x25_dev.c
@@ -122,7 +122,7 @@ int x25_lapb_receive_frame(struct sk_buff *skb, struct net_device *dev,
 
 	if (!pskb_may_pull(skb, 1)) {
 		x25_neigh_put(nb);
-		return 0;
+		goto drop;
 	}
 
 	switch (skb->data[0]) {
-- 
2.35.1



