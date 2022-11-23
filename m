Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0522F635550
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:18:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237445AbiKWJSL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:18:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237453AbiKWJRk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:17:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C7CCE92
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:17:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 968ABB81E50
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:17:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDF62C433D6;
        Wed, 23 Nov 2022 09:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195048;
        bh=D28NUY+OgrZDPRI55/TXjC2f3gyGpINTmypgydaw21E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NUscDXL+kZiIx7HfKNp7HT7AWmWQ9N0Ais6Chj3ChA6C49Ul4YeQHfAxwzXNTbxbH
         qA3/hjGepbUU3l00YpA10f/x13H5yXHwMY5b3wf73yFT4fRMQ5rIaipHfH+My4cESs
         UJYI2pr+davEnumjszrgpYRuiLxBpCqeGoyGfTng=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhengchao Shao <shaozhengchao@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 102/156] net: caif: fix double disconnect client in chnl_net_open()
Date:   Wed, 23 Nov 2022 09:50:59 +0100
Message-Id: <20221123084601.669918826@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
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

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit 8fbb53c8bfd8c56ecf1f78dc821778b58f505503 ]

When connecting to client timeout, disconnect client for twice in
chnl_net_open(). Remove one. Compile tested only.

Fixes: 2aa40aef9deb ("caif: Use link layer MTU instead of fixed MTU")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/caif/chnl_net.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/caif/chnl_net.c b/net/caif/chnl_net.c
index 910f164dd20c..4dfac31f9466 100644
--- a/net/caif/chnl_net.c
+++ b/net/caif/chnl_net.c
@@ -314,9 +314,6 @@ static int chnl_net_open(struct net_device *dev)
 
 	if (result == 0) {
 		pr_debug("connect timeout\n");
-		caif_disconnect_client(dev_net(dev), &priv->chnl);
-		priv->state = CAIF_DISCONNECTED;
-		pr_debug("state disconnected\n");
 		result = -ETIMEDOUT;
 		goto error;
 	}
-- 
2.35.1



