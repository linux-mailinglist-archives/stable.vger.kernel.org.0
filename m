Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A373B5FCF66
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbiJMARx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbiJMAR0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:17:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB4C4142CB1;
        Wed, 12 Oct 2022 17:16:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8978CB81CBE;
        Thu, 13 Oct 2022 00:16:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12B98C43470;
        Thu, 13 Oct 2022 00:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620199;
        bh=jQxxa2emWIrP+XhwowD1jj1IDXQ6DNjIM/1vneiQ1Y8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DNYk59+mXdD52nM7uoZgQIqIa2wZAnbKkYmvWBcRJDuPuJCJeaV2ihtmroa1nnFSE
         LDaC/rAokLMBzYdsVFYiRJ9CAs2JW5qX5dfx0bBCcYQCVicDRvMH34a09Tm9BzybOW
         meY/yUpbQBXeM448xSN7FyOkjxycwNwXDg5F5OV7UdDYntaDNv4NxFhzJFg1h1Y7aZ
         kJRFsMUkUYetmls1Op4JsLJsy1EHamFVPk2EMrVaBxHX0eg4IYafEvdyOkDDTuUQlN
         Sq9nvrNoHdU2N8z427jB9p4UEjQUC2wE4C3KuIOQyHWgDbvMNWtOETnD/V5SyvxTKr
         /mJS1omHH6SOA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     GUO Zihua <guozihua@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, philipp.g.hortmann@gmail.com,
        yangyingliang@huawei.com, dave@stgolabs.net, yogi.kernel@gmail.com,
        f3sch.git@outlook.com, linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 6.0 16/67] staging: rtl8192e: Fix return type for implementation of ndo_start_xmit
Date:   Wed, 12 Oct 2022 20:14:57 -0400
Message-Id: <20221013001554.1892206-16-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013001554.1892206-1-sashal@kernel.org>
References: <20221013001554.1892206-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: GUO Zihua <guozihua@huawei.com>

[ Upstream commit 513d9a61156d79dd0979c4ad400c8587f52cbb9d ]

CFI (Control Flow Integrity) is a safety feature allowing the system to
detect and react should a potential control flow hijacking occurs. In
particular, the Forward-Edge CFI protects indirect function calls by
ensuring the prototype of function that is actually called matches the
definition of the function hook.

Since Linux now supports CFI, it will be a good idea to fix mismatched
return type for implementation of hooks. Otherwise this would get
cought out by CFI and cause a panic.

Use enums from netdev_tx_t as return value instead, then change return
type to netdev_tx_t. Note that rtllib_xmit_inter() would return 1 only
on allocation failure and the queue is stopped if that happens, meeting
the documented requirement if NETDEV_TX_BUSY should be returned by
ndo_start_xmit.

Signed-off-by: GUO Zihua <guozihua@huawei.com>
Link: https://lore.kernel.org/r/20220905130053.10731-1-guozihua@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8192e/rtllib.h    | 2 +-
 drivers/staging/rtl8192e/rtllib_tx.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtllib.h b/drivers/staging/rtl8192e/rtllib.h
index 0ecd81a81866..b4b606f552fb 100644
--- a/drivers/staging/rtl8192e/rtllib.h
+++ b/drivers/staging/rtl8192e/rtllib.h
@@ -1938,7 +1938,7 @@ int rtllib_encrypt_fragment(
 	struct sk_buff *frag,
 	int hdr_len);
 
-int rtllib_xmit(struct sk_buff *skb,  struct net_device *dev);
+netdev_tx_t rtllib_xmit(struct sk_buff *skb,  struct net_device *dev);
 void rtllib_txb_free(struct rtllib_txb *txb);
 
 /* rtllib_rx.c */
diff --git a/drivers/staging/rtl8192e/rtllib_tx.c b/drivers/staging/rtl8192e/rtllib_tx.c
index 42f81b23a144..9da83531932f 100644
--- a/drivers/staging/rtl8192e/rtllib_tx.c
+++ b/drivers/staging/rtl8192e/rtllib_tx.c
@@ -962,9 +962,9 @@ static int rtllib_xmit_inter(struct sk_buff *skb, struct net_device *dev)
 
 }
 
-int rtllib_xmit(struct sk_buff *skb, struct net_device *dev)
+netdev_tx_t rtllib_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	memset(skb->cb, 0, sizeof(skb->cb));
-	return rtllib_xmit_inter(skb, dev);
+	return rtllib_xmit_inter(skb, dev) ? NETDEV_TX_BUSY : NETDEV_TX_OK;
 }
 EXPORT_SYMBOL(rtllib_xmit);
-- 
2.35.1

