Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5E722688A
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732813AbgGTQGg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:06:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:43014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733066AbgGTQGf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:06:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE2A12064B;
        Mon, 20 Jul 2020 16:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261195;
        bh=Nz8ZteKhSkYTG5rCDbUfXV2UcP+Q5MKHPQObJp6Ki0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p/ERgPxndxD10b4dglrcDoLUlRUaezn9x1OqY/DqoHYkd0Uw6NXT71NsllcoXdfCf
         6ebmYyzKBteF9fvW+C45CEo2S/z3Yargc94w5BWIb3owEvBO1GplIsPQxHyuT3u8sE
         B0Mrykj0GREPsPc240TR1OMZcBrNsj/UM1eMTw3E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.7 027/244] net: ipv4: Fix wrong type conversion from hint to rt in ip_route_use_hint()
Date:   Mon, 20 Jul 2020 17:34:58 +0200
Message-Id: <20200720152827.152840776@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

[ Upstream commit 2ce578ca9444bb44da66b9a494f56e7ec12e6466 ]

We can't cast sk_buff to rtable by (struct rtable *)hint. Use skb_rtable().

Fixes: 02b24941619f ("ipv4: use dst hint for ipv4 list receive")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/route.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2027,7 +2027,7 @@ int ip_route_use_hint(struct sk_buff *sk
 		      const struct sk_buff *hint)
 {
 	struct in_device *in_dev = __in_dev_get_rcu(dev);
-	struct rtable *rt = (struct rtable *)hint;
+	struct rtable *rt = skb_rtable(hint);
 	struct net *net = dev_net(dev);
 	int err = -EINVAL;
 	u32 tag = 0;


