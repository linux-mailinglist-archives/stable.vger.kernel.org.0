Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 267A36810E6
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237120AbjA3OIF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:08:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237122AbjA3OIE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:08:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 520B730E8
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:08:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE3C761088
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:08:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0113C433D2;
        Mon, 30 Jan 2023 14:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087682;
        bh=33bPHrH0OmXJrbGxu1Py4VXTBA+BJIFLr5ZjqxedDAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aGdPXSektR4tXmdAv0e3R/nUCLTTd4Nd82MHG/DxgCfbvL31Kv9chQ6OEAF8cPmKF
         EEHKNlCko876OM9rUteBL6fG7yZgNGtr8Vi6BHkFK1UZx2plX0QsNevZ1t4D/vVZOQ
         81JVnvik8XO++ZMl/a/vpjymLSCYqLGmhmje2i0U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jeremy Kerr <jk@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 289/313] net: mctp: add an explicit reference from a mctp_sk_key to sock
Date:   Mon, 30 Jan 2023 14:52:04 +0100
Message-Id: <20230130134350.193311790@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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

From: Jeremy Kerr <jk@codeconstruct.com.au>

[ Upstream commit de8a6b15d9654c3e4f672d76da9d9df8ee06331d ]

Currently, we correlate the mctp_sk_key lifetime to the sock lifetime
through the sock hash/unhash operations, but this is pretty tenuous, and
there are cases where we may have a temporary reference to an unhashed
sk.

This change makes the reference more explicit, by adding a hold on the
sock when it's associated with a mctp_sk_key, released on final key
unref.

Fixes: 73c618456dc5 ("mctp: locking, lifetime and validity changes for sk_keys")
Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mctp/route.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/mctp/route.c b/net/mctp/route.c
index f9a80b82dc51..ce10ba7ae839 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -147,6 +147,7 @@ static struct mctp_sk_key *mctp_key_alloc(struct mctp_sock *msk,
 	key->valid = true;
 	spin_lock_init(&key->lock);
 	refcount_set(&key->refs, 1);
+	sock_hold(key->sk);
 
 	return key;
 }
@@ -165,6 +166,7 @@ void mctp_key_unref(struct mctp_sk_key *key)
 	mctp_dev_release_key(key->dev, key);
 	spin_unlock_irqrestore(&key->lock, flags);
 
+	sock_put(key->sk);
 	kfree(key);
 }
 
@@ -419,14 +421,14 @@ static int mctp_route_input(struct mctp_route *route, struct sk_buff *skb)
 			 * this function.
 			 */
 			rc = mctp_key_add(key, msk);
-			if (rc) {
-				kfree(key);
-			} else {
+			if (!rc)
 				trace_mctp_key_acquire(key);
 
-				/* we don't need to release key->lock on exit */
-				mctp_key_unref(key);
-			}
+			/* we don't need to release key->lock on exit, so
+			 * clean up here and suppress the unlock via
+			 * setting to NULL
+			 */
+			mctp_key_unref(key);
 			key = NULL;
 
 		} else {
-- 
2.39.0



