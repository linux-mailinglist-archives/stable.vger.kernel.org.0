Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77A023B63FB
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 17:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236807AbhF1PCr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 11:02:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:36572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232654AbhF1PAi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 11:00:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6406061D74;
        Mon, 28 Jun 2021 14:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891258;
        bh=I+GWBZ/4lDqFfHc3Y8W5fLceRDT6D7V3Ua+AYQ2cNYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TBsJRa6l9sTjlojt/rL6VwX8PnzkybuXzhxST3eLbZ3izHNNhuBkD4UfVC9w6uPR0
         7Ej2KeP45U9XuvkxXHqNEkTHc7SSPZWtuwBPJOSL8WI6Ka8n69KaFVBczCvmSMtbqU
         amZivpAnwQebeVUpIeQd3uGPVPR/GLUjtyX/BEDeWzo02ShZSNI2Jg2gn/9/lBcyMR
         6iGCJVWl+qLoohOwK4WC28+eh4MrHGbqv2gmdzRqgGKV8s6+gIIvY7UrxGI+aGT8sG
         bZJbTpiuU9DdYrZVrIxw77ftewmtMFn6uAbeeQARRv2/uw+mrjjmyjCN5xZkD1Ok92
         KTuBjFhKAGqqw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+f303e045423e617d2cad@syzkaller.appspotmail.com,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 61/71] net: caif: fix memory leak in ldisc_open
Date:   Mon, 28 Jun 2021 10:39:53 -0400
Message-Id: <20210628144003.34260-62-sashal@kernel.org>
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

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit 58af3d3d54e87bfc1f936e16c04ade3369d34011 ]

Syzbot reported memory leak in tty_init_dev().
The problem was in unputted tty in ldisc_open()

static int ldisc_open(struct tty_struct *tty)
{
...
	ser->tty = tty_kref_get(tty);
...
	result = register_netdevice(dev);
	if (result) {
		rtnl_unlock();
		free_netdev(dev);
		return -ENODEV;
	}
...
}

Ser pointer is netdev private_data, so after free_netdev()
this pointer goes away with unputted tty reference. So, fix
it by adding tty_kref_put() before freeing netdev.

Reported-and-tested-by: syzbot+f303e045423e617d2cad@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/caif/caif_serial.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/caif/caif_serial.c b/drivers/net/caif/caif_serial.c
index 32834dad0b83..1243c2e5a86a 100644
--- a/drivers/net/caif/caif_serial.c
+++ b/drivers/net/caif/caif_serial.c
@@ -362,6 +362,7 @@ static int ldisc_open(struct tty_struct *tty)
 	rtnl_lock();
 	result = register_netdevice(dev);
 	if (result) {
+		tty_kref_put(tty);
 		rtnl_unlock();
 		free_netdev(dev);
 		return -ENODEV;
-- 
2.30.2

