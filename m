Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5350D469C29
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:18:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243458AbhLFPVK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:21:10 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51008 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356989AbhLFPSU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:18:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5002AB810E7;
        Mon,  6 Dec 2021 15:14:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96BA6C341C5;
        Mon,  6 Dec 2021 15:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803689;
        bh=/Z7CNgucd+B3GlywSkB//6+/YCEKR6UbH4HGynuhu+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=08oDPrCAy0TSQlc5zenzZLWGUU6GvNCwm/gt1Qo5DmSZeSLhBP8/u8XbV25Ts+Jb/
         TO28Tz3ofCc7Paoh5pzTshAmCL8J9mI9k0LUTUbmGVbvkUuHsgPN1Hg/98Dk2fAVtm
         2yQfhaThwSwUfDfdzGBwXvEQd/hGO9h2nPSfNQhA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, liuguoqiang <liuguoqiang@uniontech.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 012/130] net: return correct error code
Date:   Mon,  6 Dec 2021 15:55:29 +0100
Message-Id: <20211206145600.043504956@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
References: <20211206145559.607158688@linuxfoundation.org>
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
index 7c18597774297..148ef484a66ce 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -2582,7 +2582,7 @@ static int __devinet_sysctl_register(struct net *net, char *dev_name,
 free:
 	kfree(t);
 out:
-	return -ENOBUFS;
+	return -ENOMEM;
 }
 
 static void __devinet_sysctl_unregister(struct net *net,
-- 
2.33.0



