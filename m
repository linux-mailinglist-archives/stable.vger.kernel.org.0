Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC33311B5A7
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731879AbfLKPQT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:16:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:43314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731878AbfLKPQT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:16:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3961E24658;
        Wed, 11 Dec 2019 15:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077378;
        bh=xcdkye4lRun+480vOvUlfnWMlKXPKn42zOyCFXCoA4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pQtnC6gWT34Z2kO21vINO/K507BiYVkv0Lg2q2AtRcK0odSlRbicQ02v+akRssdi0
         AN12tBfoDrgFTFDZ9W+1sqt6ZZPSwECLCrMYjxEKhXg7f/1VYDAsWk8FGU6msVuaBm
         Gem4iS0B/0fKaIwQM5xUSr1NJ76o0loTU7rzpx7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaodong Xu <stid.smth@gmail.com>,
        Bo Chen <chenborfc@163.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 017/243] xfrm: release device reference for invalid state
Date:   Wed, 11 Dec 2019 16:02:59 +0100
Message-Id: <20191211150340.183928044@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaodong Xu <stid.smth@gmail.com>

[ Upstream commit 4944a4b1077f74d89073624bd286219d2fcbfce3 ]

An ESP packet could be decrypted in async mode if the input handler for
this packet returns -EINPROGRESS in xfrm_input(). At this moment the device
reference in skb is held. Later xfrm_input() will be invoked again to
resume the processing.
If the transform state is still valid it would continue to release the
device reference and there won't be a problem; however if the transform
state is not valid when async resumption happens, the packet will be
dropped while the device reference is still being held.
When the device is deleted for some reason and the reference to this
device is not properly released, the kernel will keep logging like:

unregister_netdevice: waiting for ppp2 to become free. Usage count = 1

The issue is observed when running IPsec traffic over a PPPoE device based
on a bridge interface. By terminating the PPPoE connection on the server
end for multiple times, the PPPoE device on the client side will eventually
get stuck on the above warning message.

This patch will check the async mode first and continue to release device
reference in async resumption, before it is dropped due to invalid state.

v2: Do not assign address family from outer_mode in the transform if the
state is invalid

v3: Release device reference in the error path instead of jumping to resume

Fixes: 4ce3dbe397d7b ("xfrm: Fix xfrm_input() to verify state is valid when (encap_type < 0)")
Signed-off-by: Xiaodong Xu <stid.smth@gmail.com>
Reported-by: Bo Chen <chenborfc@163.com>
Tested-by: Bo Chen <chenborfc@163.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_input.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index d5635908587f4..82b0a99ee1f43 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -246,6 +246,9 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 			else
 				XFRM_INC_STATS(net,
 					       LINUX_MIB_XFRMINSTATEINVALID);
+
+			if (encap_type == -1)
+				dev_put(skb->dev);
 			goto drop;
 		}
 
-- 
2.20.1



