Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAD1D4705EA
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 17:38:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236848AbhLJQmL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 11:42:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243756AbhLJQmL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 11:42:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51B8DC061746
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 08:38:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A3A3B828B8
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 16:38:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D62BC341C6;
        Fri, 10 Dec 2021 16:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639154313;
        bh=VMaNkuLQ7st+0D0S+NO5h0rZE6kd5pLaXo+dv+XrzUA=;
        h=Subject:To:Cc:From:Date:From;
        b=VEAItlIzqQjm7Ox7ah+KFJIEQn64Ytvd4aCxtQgrgaYIOnZ+XKMFsQBlilZV6ZCa5
         LVFmJ9D9GgfTfAQYI+3K6pFSwI6FjFH/MYZ9YzM2UIhB6q87F8cammXHLPduldOFkW
         MiIewW3iwdUa2obuj8NM9H2P9a2+GNRE5+trtuSM=
Subject: FAILED: patch "[PATCH] netfilter: nft_exthdr: break evaluation if setting TCP option" failed to apply to 4.14-stable tree
To:     pablo@netfilter.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 10 Dec 2021 17:38:31 +0100
Message-ID: <16391543111099@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 962e5a40358787105f126ab1dc01604da3d169e9 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Tue, 30 Nov 2021 11:34:04 +0100
Subject: [PATCH] netfilter: nft_exthdr: break evaluation if setting TCP option
 fails

Break rule evaluation on malformed TCP options.

Fixes: 99d1712bc41c ("netfilter: exthdr: tcp option set support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index af4ee874a067..dbe1f2e7dd9e 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -236,7 +236,7 @@ static void nft_exthdr_tcp_set_eval(const struct nft_expr *expr,
 
 	tcph = nft_tcp_header_pointer(pkt, sizeof(buff), buff, &tcphdr_len);
 	if (!tcph)
-		return;
+		goto err;
 
 	opt = (u8 *)tcph;
 	for (i = sizeof(*tcph); i < tcphdr_len - 1; i += optl) {
@@ -251,16 +251,16 @@ static void nft_exthdr_tcp_set_eval(const struct nft_expr *expr,
 			continue;
 
 		if (i + optl > tcphdr_len || priv->len + priv->offset > optl)
-			return;
+			goto err;
 
 		if (skb_ensure_writable(pkt->skb,
 					nft_thoff(pkt) + i + priv->len))
-			return;
+			goto err;
 
 		tcph = nft_tcp_header_pointer(pkt, sizeof(buff), buff,
 					      &tcphdr_len);
 		if (!tcph)
-			return;
+			goto err;
 
 		offset = i + priv->offset;
 
@@ -303,6 +303,9 @@ static void nft_exthdr_tcp_set_eval(const struct nft_expr *expr,
 
 		return;
 	}
+	return;
+err:
+	regs->verdict.code = NFT_BREAK;
 }
 
 static void nft_exthdr_sctp_eval(const struct nft_expr *expr,

