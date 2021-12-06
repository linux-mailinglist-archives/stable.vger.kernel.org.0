Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E138F469EB4
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385653AbhLFPnp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:43:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376488AbhLFPgq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:36:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E805C08EACA;
        Mon,  6 Dec 2021 07:21:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA924B81138;
        Mon,  6 Dec 2021 15:21:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD2CC341C1;
        Mon,  6 Dec 2021 15:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804091;
        bh=z/cuVoIyPLjSIH6NKC38LEmUUOHD3/wwUcHONsV+qhc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AaalKjPvWZo3tI8lD6X9HYmLpMqpUkwYgo2+71wGBQ0SzsAayIsWLPAm7X/3NbeQj
         ilYnrrdXLbxThWp7XV9L6VVVepp8LDr0SyEXNp9Lh9HDnw8CloVV1AA9Xah7u7QkGl
         PC3RIjQ3eOoqDiii0U4jj+gXsFSqWb16kPEBovFw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, liuguoqiang <liuguoqiang@uniontech.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 023/207] net: return correct error code
Date:   Mon,  6 Dec 2021 15:54:37 +0100
Message-Id: <20211206145611.006604828@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
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
index f4468980b6757..4744c7839de53 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -2587,7 +2587,7 @@ static int __devinet_sysctl_register(struct net *net, char *dev_name,
 free:
 	kfree(t);
 out:
-	return -ENOBUFS;
+	return -ENOMEM;
 }
 
 static void __devinet_sysctl_unregister(struct net *net,
-- 
2.33.0



