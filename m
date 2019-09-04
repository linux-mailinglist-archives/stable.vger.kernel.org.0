Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26FD6A8EB4
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388245AbfIDR7e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 13:59:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:38436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388244AbfIDR7d (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 13:59:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2202B22CEA;
        Wed,  4 Sep 2019 17:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567619972;
        bh=Rz5W86QNLhm8ZYZlo6tOUZ86rEbHzRkh+dT4ZEkT3eo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qgOJ/2JLjJSsCGlX7G3enaYb8fGbEMQE7mHCTvKftXn2PYvvubM95dWUq8BQqzuhC
         BS9bk1hX89TntEHOLNlAzLRzBfCFmW4rs9b22k11CKNRV57AJBYP5CyNqsQ5oUwvEs
         zaLPZY50tl1j+w0L+Tj5vnzFVxRGB5rAkXMEmmDY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Deepak Rawat <drawat@vmware.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 25/83] drm/vmwgfx: fix memory leak when too many retries have occurred
Date:   Wed,  4 Sep 2019 19:53:17 +0200
Message-Id: <20190904175306.098695604@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175303.488266791@linuxfoundation.org>
References: <20190904175303.488266791@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 6b7c3b86f0b63134b2ab56508921a0853ffa687a ]

Currently when too many retries have occurred there is a memory
leak on the allocation for reply on the error return path. Fix
this by kfree'ing reply before returning.

Addresses-Coverity: ("Resource leak")
Fixes: a9cd9c044aa9 ("drm/vmwgfx: Add a check to handle host message failure")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Deepak Rawat <drawat@vmware.com>
Signed-off-by: Deepak Rawat <drawat@vmware.com>
Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_msg.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_msg.c b/drivers/gpu/drm/vmwgfx/vmwgfx_msg.c
index e57a0bad7a626..77df50dd6d30d 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_msg.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_msg.c
@@ -300,8 +300,10 @@ static int vmw_recv_msg(struct rpc_channel *channel, void **msg,
 		break;
 	}
 
-	if (retries == RETRIES)
+	if (retries == RETRIES) {
+		kfree(reply);
 		return -EINVAL;
+	}
 
 	*msg_len = reply_len;
 	*msg     = reply;
-- 
2.20.1



