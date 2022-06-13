Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4C8D54860F
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 17:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383670AbiFMObv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385105AbiFMOai (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:30:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A8EDA86A5;
        Mon, 13 Jun 2022 04:48:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92360612AC;
        Mon, 13 Jun 2022 11:48:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77806C3411C;
        Mon, 13 Jun 2022 11:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120881;
        bh=xiYEgWBVMCuIUkmI5EK4524c4rH/1oU6YNVnXbs2OsU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CewKg/IPdo05yYZhMRum+2tIyjM380BAQY1OwLXVbbdV1I87Ki+oWDuC/L1Ivbj0k
         1Z/hrjQ5oPP8D+iXQFKCVcWUrLIJzmQmv3xRXsBYFzBaWx0X9hSmS1iegkGpyc0FXN
         GmUdG5dWc6X/9EFmmSSvQzNMgYfGcfymKX6YqPtA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 169/298] amt: fix possible null-ptr-deref in amt_rcv()
Date:   Mon, 13 Jun 2022 12:11:03 +0200
Message-Id: <20220613094930.057866332@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit d16207f92a4a823c48b4ea953ad51f4483456768 ]

When amt interface receives amt message, it tries to obtain amt private
data from sock.
If there is no amt private data, it frees an skb immediately.
After kfree_skb(), it increases the rx_dropped stats.
But in order to use rx_dropped, amt private data is needed.
So, it makes amt_rcv() to do not increase rx_dropped stats when it can
not obtain amt private data.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: 1a1a0e80e005 ("amt: fix possible memory leak in amt_rcv()")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/amt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index d8c47c4e6559..e239c0262d56 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -2698,7 +2698,8 @@ static int amt_rcv(struct sock *sk, struct sk_buff *skb)
 	amt = rcu_dereference_sk_user_data(sk);
 	if (!amt) {
 		err = true;
-		goto drop;
+		kfree_skb(skb);
+		goto out;
 	}
 
 	skb->dev = amt->dev;
-- 
2.35.1



