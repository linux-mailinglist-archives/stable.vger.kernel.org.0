Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E855469B8E
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356242AbhLFPRv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:17:51 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35010 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347381AbhLFPPT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:15:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA42A612DB;
        Mon,  6 Dec 2021 15:11:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D14EDC341C1;
        Mon,  6 Dec 2021 15:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803485;
        bh=vpf1Kc7d4gngzj8xnSiTjZyTZaCOO9eLVPE/IiqI1KE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YCFRvS9xtjWKvLp3tzha0j6tVmEPciWeTJ3EaIbN+A+7+NUYfMSQbm9+YQ48yEyWF
         phNhxawyigt3yImIllMgW4oGhmmM/+rDjyoH6kCEHjZ9DJFLhSO7xrUpdG2TtGFG3o
         5USqwQH9OrPojn+CqoRCXohgQJHcmU+Fi5ri1p2g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, liuguoqiang <liuguoqiang@uniontech.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 10/70] net: return correct error code
Date:   Mon,  6 Dec 2021 15:56:14 +0100
Message-Id: <20211206145552.262283222@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145551.909846023@linuxfoundation.org>
References: <20211206145551.909846023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: liuguoqiang <liuguoqiang@uniontech.com>

[ Upstream commit 6def480181f15f6d9ec812bca8cbc62451ba314c ]

When kmemdup called failed and register_net_sysctl return NULL, should
return ENOMEM instead of ENOBUFS

Signed-off-by: liuguoqiang <liuguoqiang@uniontech.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/devinet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index 603a3495afa62..4a8ad46397c0e 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -2585,7 +2585,7 @@ static int __devinet_sysctl_register(struct net *net, char *dev_name,
 free:
 	kfree(t);
 out:
-	return -ENOBUFS;
+	return -ENOMEM;
 }
 
 static void __devinet_sysctl_unregister(struct net *net,
-- 
2.33.0



