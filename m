Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED9B45830EE
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242709AbiG0Row (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:44:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242853AbiG0Rnb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:43:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B95789E83;
        Wed, 27 Jul 2022 09:52:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A508CB821BE;
        Wed, 27 Jul 2022 16:52:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE42DC433C1;
        Wed, 27 Jul 2022 16:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940756;
        bh=OQUb/8RzLCrzVZweQIabAHag8h5C3q52n++aj87Xar8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zDTgB9ERv7Z7lfQqiYKLGfV2EqBGRtbDKfozR7RnSlQrt0rmsGvP0zmg+Y+QiW/76
         wF5gmf34AUmTU24xniKYoi+1+ViIYEVYm0c0BeN2yZpxALQyDGP2xDQB+kJW69u6hk
         KAZUc0LVfR1c0TyGzihMlSnQN4Umwyzwwvj+nl+E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 105/158] amt: drop unexpected advertisement message
Date:   Wed, 27 Jul 2022 18:12:49 +0200
Message-Id: <20220727161025.678539930@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 40185f359fbabaa61da754cc29d12f3a41e0a987 ]

AMT gateway interface should not receive unexpected advertisement messages.
In order to drop these packets, it should check nonce and amt->status.

Fixes: cbc21dc1cfe9 ("amt: add data plane of amt interface")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/amt.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index 2fe56640e493..0811a5211ec4 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -2260,6 +2260,10 @@ static bool amt_advertisement_handler(struct amt_dev *amt, struct sk_buff *skb)
 	    ipv4_is_zeronet(amta->ip4))
 		return true;
 
+	if (amt->status != AMT_STATUS_SENT_DISCOVERY ||
+	    amt->nonce != amta->nonce)
+		return true;
+
 	amt->remote_ip = amta->ip4;
 	netdev_dbg(amt->dev, "advertised remote ip = %pI4\n", &amt->remote_ip);
 	mod_delayed_work(amt_wq, &amt->req_wq, 0);
@@ -2975,6 +2979,7 @@ static int amt_dev_open(struct net_device *dev)
 
 	amt->req_cnt = 0;
 	amt->remote_ip = 0;
+	amt->nonce = 0;
 	get_random_bytes(&amt->key, sizeof(siphash_key_t));
 
 	amt->status = AMT_STATUS_INIT;
-- 
2.35.1



