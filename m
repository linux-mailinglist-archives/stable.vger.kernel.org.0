Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48F0A1D0F24
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 12:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732791AbgEMJrJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:47:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:44700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732784AbgEMJrG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:47:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CEFE20769;
        Wed, 13 May 2020 09:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363225;
        bh=8WGXdX0TnAX86/ckTL3jkixuy+9Tp1nesLQ+hXMtkso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nieX7bXyyzfsGK1SHLV1xeOHToVzo98Nt0t7CLkI0XiyZ0a+J5riTGOs/Glr8FAhR
         SA3j0xykqSy8pd3yW3wFrMDFAjaAvK4DU2x/9hgl08uTLk4nQ4vQPJHlQ+87HtE2eX
         IM6hDDJ+xkWkmRHscBXM1eZNTySAsWg5+2KVIjkg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.19 36/48] batman-adv: Fix refcnt leak in batadv_v_ogm_process
Date:   Wed, 13 May 2020 11:45:02 +0200
Message-Id: <20200513094401.060898423@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094351.100352960@linuxfoundation.org>
References: <20200513094351.100352960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiyu Yang <xiyuyang19@fudan.edu.cn>

commit 6f91a3f7af4186099dd10fa530dd7e0d9c29747d upstream.

batadv_v_ogm_process() invokes batadv_hardif_neigh_get(), which returns
a reference of the neighbor object to "hardif_neigh" with increased
refcount.

When batadv_v_ogm_process() returns, "hardif_neigh" becomes invalid, so
the refcount should be decreased to keep refcount balanced.

The reference counting issue happens in one exception handling paths of
batadv_v_ogm_process(). When batadv_v_ogm_orig_get() fails to get the
orig node and returns NULL, the refcnt increased by
batadv_hardif_neigh_get() is not decreased, causing a refcnt leak.

Fix this issue by jumping to "out" label when batadv_v_ogm_orig_get()
fails to get the orig node.

Fixes: 9323158ef9f4 ("batman-adv: OGMv2 - implement originators logic")
Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/batman-adv/bat_v_ogm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/batman-adv/bat_v_ogm.c
+++ b/net/batman-adv/bat_v_ogm.c
@@ -735,7 +735,7 @@ static void batadv_v_ogm_process(const s
 
 	orig_node = batadv_v_ogm_orig_get(bat_priv, ogm_packet->orig);
 	if (!orig_node)
-		return;
+		goto out;
 
 	neigh_node = batadv_neigh_node_get_or_create(orig_node, if_incoming,
 						     ethhdr->h_source);


