Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35B0D10BA72
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732011AbfK0VDO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:03:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:56360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732014AbfK0VDN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:03:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A88C21850;
        Wed, 27 Nov 2019 21:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888592;
        bh=Hkb8CNfhy9QgqCbkcvJJlCm1/a3KGg7NG2/yzxtl838=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yMi5XBOlpCJBcTLFBGLgNoov26E9MSGTRKOySKdYS5htRbi243LXQHtaILO1aB4o9
         EAGG6AurlF+mjU7DBuypGIohFg2zaSvwYOQ+LkIxrHTNYhyhmrhui9yawksLdxTte2
         uvlb+pKVoHnkxwfn4XoAOnoJSC5D0ENWpLn+I7Uk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 142/306] bpf: devmap: fix wrong interface selection in notifier_call
Date:   Wed, 27 Nov 2019 21:29:52 +0100
Message-Id: <20191127203125.715486640@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
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
index fc500ca464d00..1defea4b27553 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -520,8 +520,7 @@ static int dev_map_notification(struct notifier_block *notifier,
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



