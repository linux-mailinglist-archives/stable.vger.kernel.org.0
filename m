Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47C514C7408
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:39:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235060AbiB1RkW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:40:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238011AbiB1Rjb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:39:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC05A91341;
        Mon, 28 Feb 2022 09:34:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38A20B815B8;
        Mon, 28 Feb 2022 17:34:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 924E3C340E7;
        Mon, 28 Feb 2022 17:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069646;
        bh=+l3jU0nvv1HAdt1l7oH7jBuox343EAywraz1n02pq30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ntvs8eFVBoMNXhP6oGQ3QWz7uHVUVDtt6CniZRzKh2E9HSHIvnasC89O0Tg/qA/rj
         Jk19Ycx9Er5SXx00CWmtNL+PrCGG6DSiv2WJiWvYKRl8cHXkp6IrxFcYcuDX8tpV7n
         nC2VWhD6y8wftdrfN/OG12J2Fw8fGnT9SfhoaAyo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 41/80] udp_tunnel: Fix end of loop test in udp_tunnel_nic_unregister()
Date:   Mon, 28 Feb 2022 18:24:22 +0100
Message-Id: <20220228172316.511306586@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172311.789892158@linuxfoundation.org>
References: <20220228172311.789892158@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit de7b2efacf4e83954aed3f029d347dfc0b7a4f49 upstream.

This test is checking if we exited the list via break or not.  However
if it did not exit via a break then "node" does not point to a valid
udp_tunnel_nic_shared_node struct.  It will work because of the way
the structs are laid out it's the equivalent of
"if (info->shared->udp_tunnel_nic_info != dev)" which will always be
true, but it's not the right way to test.

Fixes: 74cc6d182d03 ("udp_tunnel: add the ability to share port tables")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/udp_tunnel_nic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/udp_tunnel_nic.c
+++ b/net/ipv4/udp_tunnel_nic.c
@@ -846,7 +846,7 @@ udp_tunnel_nic_unregister(struct net_dev
 		list_for_each_entry(node, &info->shared->devices, list)
 			if (node->dev == dev)
 				break;
-		if (node->dev != dev)
+		if (list_entry_is_head(node, &info->shared->devices, list))
 			return;
 
 		list_del(&node->list);


