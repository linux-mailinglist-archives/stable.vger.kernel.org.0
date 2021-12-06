Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7B28469B62
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345147AbhLFPRN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:17:13 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:33684 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355905AbhLFPNO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:13:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CFEA61328;
        Mon,  6 Dec 2021 15:09:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10ADEC341C2;
        Mon,  6 Dec 2021 15:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803384;
        bh=N2hQwQrj8/ZltlL4+WHRDjcfhcttg2gMAZKuvKrGMY4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KNpGO6Z98AZR2vAImRvPx1fX7XunZE8FYup3+SD2ROo5HXmjaa1ZYiIkmW+dfi3hu
         3/qBhrQxBJKp3AfShYdr+ZIB046nikUtewjJUDooGbmII1UoOeC1jmZmqAEYr4HZbB
         Xr49/2SWX9j9UVAVxncihKi6nX7DCBHKMXnNcRIA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, liuguoqiang <liuguoqiang@uniontech.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 06/48] net: return correct error code
Date:   Mon,  6 Dec 2021 15:56:23 +0100
Message-Id: <20211206145549.072699933@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145548.859182340@linuxfoundation.org>
References: <20211206145548.859182340@linuxfoundation.org>
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
index 12a2cea9d606a..e2ab8cdb71347 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -2354,7 +2354,7 @@ static int __devinet_sysctl_register(struct net *net, char *dev_name,
 free:
 	kfree(t);
 out:
-	return -ENOBUFS;
+	return -ENOMEM;
 }
 
 static void __devinet_sysctl_unregister(struct net *net,
-- 
2.33.0



