Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2F9D10BE51
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729096AbfK0VfS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:35:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:35314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729838AbfK0Utk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:49:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1114E21787;
        Wed, 27 Nov 2019 20:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887779;
        bh=7Zb84RMymvrQrGc5whayYZnaI5yyN4gn14MocjTCebU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aWfg16+q33RcafAkYES7GBP9yBHEZEtFwTZ2fzc0EVU6M0m1QfLwKtKg7jupwJFX6
         7ALXenzCOv/zgizIjv4aZIC7M9pdXF4VsHcqac3hw9mbFqtU1c/eXgWssF7jnqAbrg
         Esel4yHUAXpX0KNYWzfu++niHZl8sbws/eyOLT/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 089/211] bpf: devmap: fix wrong interface selection in notifier_call
Date:   Wed, 27 Nov 2019 21:30:22 +0100
Message-Id: <20191127203102.160819159@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
References: <20191127203049.431810767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit f592f804831f1cf9d1f9966f58c80f150e6829b5 ]

The dev_map_notification() removes interface in devmap if
unregistering interface's ifindex is same.
But only checking ifindex is not enough because other netns can have
same ifindex. so that wrong interface selection could occurred.
Hence netdev pointer comparison code is added.

v2: compare netdev pointer instead of using net_eq() (Daniel Borkmann)
v1: Initial patch

Fixes: 2ddf71e23cc2 ("net: add notifier hooks for devmap bpf map")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/devmap.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 482bf42e21a41..1060eee6c8d5f 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -388,8 +388,7 @@ static int dev_map_notification(struct notifier_block *notifier,
 				struct bpf_dtab_netdev *dev, *odev;
 
 				dev = READ_ONCE(dtab->netdev_map[i]);
-				if (!dev ||
-				    dev->dev->ifindex != netdev->ifindex)
+				if (!dev || netdev != dev->dev)
 					continue;
 				odev = cmpxchg(&dtab->netdev_map[i], dev, NULL);
 				if (dev == odev)
-- 
2.20.1



