Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7745B68956F
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:24:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233446AbjBCKXS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:23:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233467AbjBCKXI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:23:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E0ED9F9EC
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:22:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E7C3361EC9
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:22:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3A81C433EF;
        Fri,  3 Feb 2023 10:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419764;
        bh=pt1rSltNBFBLCWdk1rNMYsruffAUqt+GJFUF7hugn80=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hj83VhSkwKcE/jumWiQSphPLRj7FxUoPqKYJuhctOhgoyjCrAovXBBJnDO8Go1W5m
         i+qlk8zHe6lnccAw5TZxRIl1cjDk1Nqs1l5zhBJwm9RnCcIx8/a/zdB3mGwigwYiPN
         VtzlPy6veGtHG0NQQTgwaODWyc1JQ6GK87aXz2ss=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jeremy Kerr <jk@codeconstruct.com.au>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 28/28] net: mctp: purge receive queues on sk destruction
Date:   Fri,  3 Feb 2023 11:13:16 +0100
Message-Id: <20230203101011.142443636@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101009.946745030@linuxfoundation.org>
References: <20230203101009.946745030@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeremy Kerr <jk@codeconstruct.com.au>

commit 60bd1d9008a50cc78c4033a16a6f5d78210d481c upstream.

We may have pending skbs in the receive queue when the sk is being
destroyed; add a destructor to purge the queue.

MCTP doesn't use the error queue, so only the receive_queue is purged.

Fixes: 833ef3b91de6 ("mctp: Populate socket implementation")
Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Link: https://lore.kernel.org/r/20230126064551.464468-1-jk@codeconstruct.com.au
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mctp/af_mctp.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -587,6 +587,11 @@ static void mctp_sk_unhash(struct sock *
 	del_timer_sync(&msk->key_expiry);
 }
 
+static void mctp_sk_destruct(struct sock *sk)
+{
+	skb_queue_purge(&sk->sk_receive_queue);
+}
+
 static struct proto mctp_proto = {
 	.name		= "MCTP",
 	.owner		= THIS_MODULE,
@@ -623,6 +628,7 @@ static int mctp_pf_create(struct net *ne
 		return -ENOMEM;
 
 	sock_init_data(sock, sk);
+	sk->sk_destruct = mctp_sk_destruct;
 
 	rc = 0;
 	if (sk->sk_prot->init)


