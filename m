Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D012F22F0FF
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732171AbgG0OXz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:23:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:53258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732165AbgG0OXw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:23:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95BC22083E;
        Mon, 27 Jul 2020 14:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859832;
        bh=/EPXNNpRbRs1wsCdJFgsArdWLV8XF3Yj+xCF+ejtOM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jpDOT/tL1zQW/FS2dZPtaUHQzKCKvVu4jxoUiJcfou9uiE7Z+8vL3xuadDtVY8ABM
         fKV8EJa+PYFzAPmJDJTp8OLLrFV5oGpiYi8wz9Cx92nCERjoJjVX4LXrIFleNdzGe0
         8kSu+oOaG4dWCaGqBRauoLr33+rBo8MdbkcLG35E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 082/179] netdevsim: fix unbalaced locking in nsim_create()
Date:   Mon, 27 Jul 2020 16:04:17 +0200
Message-Id: <20200727134936.676225376@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 2c9d8e01f0c6017317eee7638496173d4a64e6bc ]

In the nsim_create(), rtnl_lock() is called before nsim_bpf_init().
If nsim_bpf_init() is failed, rtnl_unlock() should be called,
but it isn't called.
So, unbalanced locking would occur.

Fixes: e05b2d141fef ("netdevsim: move netdev creation/destruction to dev probe")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/netdevsim/netdev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index 2908e0a0d6e19..23950e7a0f81e 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -302,7 +302,7 @@ nsim_create(struct nsim_dev *nsim_dev, struct nsim_dev_port *nsim_dev_port)
 	rtnl_lock();
 	err = nsim_bpf_init(ns);
 	if (err)
-		goto err_free_netdev;
+		goto err_rtnl_unlock;
 
 	nsim_ipsec_init(ns);
 
@@ -316,8 +316,8 @@ nsim_create(struct nsim_dev *nsim_dev, struct nsim_dev_port *nsim_dev_port)
 err_ipsec_teardown:
 	nsim_ipsec_teardown(ns);
 	nsim_bpf_uninit(ns);
+err_rtnl_unlock:
 	rtnl_unlock();
-err_free_netdev:
 	free_netdev(dev);
 	return ERR_PTR(err);
 }
-- 
2.25.1



