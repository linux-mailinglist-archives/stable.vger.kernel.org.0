Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0273B639C
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234790AbhF1O6b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:58:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:59580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236958AbhF1O42 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:56:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 012D861C7B;
        Mon, 28 Jun 2021 14:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891215;
        bh=ucLNLCf5rRm6SkudXfKKiS8NBTQNhJd1UmBUBzRPhyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uZkrhXNCy3Sl10D9tIjeRG5ErRARxBBxL9uxW2TG0XFcwZfAr5Fxdm3JO+YyK+fQ/
         aNOmKe9GCyqKyC3VQiD31MHlzf91G0M5cx1dj94jg8zxo/DKQCoFRGvm43BdacOmpR
         FTXJD7i1DUwp84qGE6g+gUSLp4nqVll1i3LrZcQ5vb0sJgco9k0X2f0yl6SNPNYaJe
         w9g6M+wpGVviyz1SrEriquV6jNBVihaFvO60yp0gcN7GVV0W9Rv2IkZIwVz6vTsUAC
         gJWey0L/jtimo95CaUANXwYpr0IKhTRbLGrWmHFyDfImAtsc1QWhUtvs1whFhks04v
         reT60D5hYTeWQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Yongjun <zhengyongjun3@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 12/71] net/x25: Return the correct errno code
Date:   Mon, 28 Jun 2021 10:39:04 -0400
Message-Id: <20210628144003.34260-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628144003.34260-1-sashal@kernel.org>
References: <20210628144003.34260-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.274-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.274-rc1
X-KernelTest-Deadline: 2021-06-30T14:39+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheng Yongjun <zhengyongjun3@huawei.com>

[ Upstream commit d7736958668c4facc15f421e622ffd718f5be80a ]

When kalloc or kmemdup failed, should return ENOMEM rather than ENOBUF.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/x25/af_x25.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index 9c3fbf4553cc..c23c04d38a82 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -550,7 +550,7 @@ static int x25_create(struct net *net, struct socket *sock, int protocol,
 	if (protocol)
 		goto out;
 
-	rc = -ENOBUFS;
+	rc = -ENOMEM;
 	if ((sk = x25_alloc_socket(net, kern)) == NULL)
 		goto out;
 
-- 
2.30.2

