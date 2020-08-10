Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EBCC2408FE
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728226AbgHJP1x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:27:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:33768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728371AbgHJP1r (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:27:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A83822BF3;
        Mon, 10 Aug 2020 15:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597073267;
        bh=nJ5uviGhYV6dHThWLKBvz/T7t58qjLG2DrnP1k+q9g0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HUSdd9iDh/of/hCker2+bPv/6DAAzLdOnw67NOcL1nzG5lcCk1El0Wyt2RxU1A+zJ
         rgDKZ/e1ZsoihWL9QQIiYDbKXgVNb6Jdi/81e98zOqRAiKoMZ9rlLGXSDOmUa03/0B
         OHeknup3+EQuASOLFLWzXEXXwdU3B0uyTgqnhA5k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Xiong <xiongx18@fudan.edu.cn>,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 44/67] atm: fix atm_dev refcnt leaks in atmtcp_remove_persistent
Date:   Mon, 10 Aug 2020 17:21:31 +0200
Message-Id: <20200810151811.617375764@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151809.438685785@linuxfoundation.org>
References: <20200810151809.438685785@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Xiong <xiongx18@fudan.edu.cn>

[ Upstream commit 51875dad43b44241b46a569493f1e4bfa0386d86 ]

atmtcp_remove_persistent() invokes atm_dev_lookup(), which returns a
reference of atm_dev with increased refcount or NULL if fails.

The refcount leaks issues occur in two error handling paths. If
dev_data->persist is zero or PRIV(dev)->vcc isn't NULL, the function
returns 0 without decreasing the refcount kept by a local variable,
resulting in refcount leaks.

Fix the issue by adding atm_dev_put() before returning 0 both when
dev_data->persist is zero or PRIV(dev)->vcc isn't NULL.

Signed-off-by: Xin Xiong <xiongx18@fudan.edu.cn>
Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/atm/atmtcp.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/atm/atmtcp.c b/drivers/atm/atmtcp.c
index d9fd70280482c..7f814da3c2d06 100644
--- a/drivers/atm/atmtcp.c
+++ b/drivers/atm/atmtcp.c
@@ -433,9 +433,15 @@ static int atmtcp_remove_persistent(int itf)
 		return -EMEDIUMTYPE;
 	}
 	dev_data = PRIV(dev);
-	if (!dev_data->persist) return 0;
+	if (!dev_data->persist) {
+		atm_dev_put(dev);
+		return 0;
+	}
 	dev_data->persist = 0;
-	if (PRIV(dev)->vcc) return 0;
+	if (PRIV(dev)->vcc) {
+		atm_dev_put(dev);
+		return 0;
+	}
 	kfree(dev_data);
 	atm_dev_put(dev);
 	atm_dev_deregister(dev);
-- 
2.25.1



