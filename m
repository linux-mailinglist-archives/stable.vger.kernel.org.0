Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D8D94C7492
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236831AbiB1Rpr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:45:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239846AbiB1Ron (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:44:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17FAEDFAD;
        Mon, 28 Feb 2022 09:37:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97720614BF;
        Mon, 28 Feb 2022 17:37:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0EB0C340E7;
        Mon, 28 Feb 2022 17:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069834;
        bh=j302gKTO4w+K7obYcgnAaWR6s5bMHrwgcd+p4UPzX7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l/wBHqL1gGOXc+BQZE7LFA+wQ4rnG4uRCB1MQbQW+Yz4t3DlWY0C42m2CSOie4vLa
         T3po4KeW0T1safRwnXrtz3H/h5GWj+ZkH6xExJUunDUkVVRN8seM7o43/67AADGYFb
         AJWmy/M+pABuK841YuJ7PyTjUVMFdAAnqm+sDoqU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Eric Dumazet <edumazet@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.15 028/139] netfilter: xt_socket: missing ifdef CONFIG_IP6_NF_IPTABLES dependency
Date:   Mon, 28 Feb 2022 18:23:22 +0100
Message-Id: <20220228172350.721813561@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172347.614588246@linuxfoundation.org>
References: <20220228172347.614588246@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 2874b7911132f6975e668f6849c8ac93bc4e1f35 upstream.

nf_defrag_ipv6_disable() requires CONFIG_IP6_NF_IPTABLES.

Fixes: 75063c9294fb ("netfilter: xt_socket: fix a typo in socket_mt_destroy()")
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Eric Dumazet<edumazet@google.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/xt_socket.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/netfilter/xt_socket.c
+++ b/net/netfilter/xt_socket.c
@@ -220,8 +220,10 @@ static void socket_mt_destroy(const stru
 {
 	if (par->family == NFPROTO_IPV4)
 		nf_defrag_ipv4_disable(par->net);
+#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
 	else if (par->family == NFPROTO_IPV6)
 		nf_defrag_ipv6_disable(par->net);
+#endif
 }
 
 static struct xt_match socket_mt_reg[] __read_mostly = {


