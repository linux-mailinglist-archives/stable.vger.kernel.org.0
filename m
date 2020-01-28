Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF8314BBBF
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:49:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgA1Osf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:48:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:48578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726715AbgA1OCT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:02:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75097205F4;
        Tue, 28 Jan 2020 14:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220138;
        bh=3hKvNmT8nmLVI3xCpYfux5YxrqvOxqQ22wVDWQSZauo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MhVaQu6qarECxABreXgoWGBF7mxYQlBk7fJiGjThhNsrVEcDB1Kn/fEBSn5+Hwgr1
         hDAY5KtzGdJte9tOQ9g+2mSC2LNZEYqccTtKmX1bIUseUhrHwd+TwZgey4kfuwu9cj
         Pthd7iNjW3Lkqtm4u5A0c7uEvnVpb2dfljkmc+8s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven-Haegar Koch <haegar@sdinet.de>,
        David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 032/104] ipv4: Detect rollover in specific fib table dump
Date:   Tue, 28 Jan 2020 14:59:53 +0100
Message-Id: <20200128135821.698374819@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135817.238524998@linuxfoundation.org>
References: <20200128135817.238524998@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

[ Upstream commit 9827c0634e461703abf81e8cc8b7adf5da5886d0 ]

Sven-Haegar reported looping on fib dumps when 255.255.255.255 route has
been added to a table. The looping is caused by the key rolling over from
FFFFFFFF to 0. When dumping a specific table only, we need a means to detect
when the table dump is done. The key and count saved to cb args are both 0
only at the start of the table dump. If key is 0 and count > 0, then we are
in the rollover case. Detect and return to avoid looping.

This only affects dumps of a specific table; for dumps of all tables
(the case prior to the change in the Fixes tag) inet_dump_fib moved
the entry counter to the next table and reset the cb args used by
fib_table_dump and fn_trie_dump_leaf, so the rollover ffffffff back
to 0 did not cause looping with the dumps.

Fixes: effe67926624 ("net: Enable kernel side filtering of route dumps")
Reported-by: Sven-Haegar Koch <haegar@sdinet.de>
Signed-off-by: David Ahern <dsahern@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/fib_trie.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -2175,6 +2175,12 @@ int fib_table_dump(struct fib_table *tb,
 	int count = cb->args[2];
 	t_key key = cb->args[3];
 
+	/* First time here, count and key are both always 0. Count > 0
+	 * and key == 0 means the dump has wrapped around and we are done.
+	 */
+	if (count && !key)
+		return skb->len;
+
 	while ((l = leaf_walk_rcu(&tp, key)) != NULL) {
 		int err;
 


