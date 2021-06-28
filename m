Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 142793B61A4
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234002AbhF1OhR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:37:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:43982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235338AbhF1OfW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:35:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EB3061C9E;
        Mon, 28 Jun 2021 14:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890630;
        bh=ZhudtaCtWlly0EAeh0317uFcm9vgXLNyBmrC/gLT+7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ohjn+XDavNuUz/NpuFRQIR4dm2OtG+nJlDsadBgLs+bSUS0+mA/wLc4LpBZ/nE/4C
         hyJd8SvEXuZQ2LqzJbvrQCS/ac3BPNruRYHlVsNxVil4a0cd8dKsc0nSAnOtp1LTkM
         /8d2jLiadHc/oUAF1qGTUSwoUtC/pIKqcBEpMDqo77rXPg8FwWaUISDXR/2IkRPrbA
         y8Oq/rF7EF/qJxmGfwYLu71DpgmD+XZtQUNoTmHsjt7Cw0YULDYg9eFmlQXPLijsEY
         n4Uneqf409IyUgNps3RW/IlZfyZOrQgB1CDRBIEv6/LDUPHjepaUqP2t4TPuQ8xvbi
         h+2cfVxBVURdQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+f303e045423e617d2cad@syzkaller.appspotmail.com,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 27/71] net: caif: fix memory leak in ldisc_open
Date:   Mon, 28 Jun 2021 10:29:20 -0400
Message-Id: <20210628143004.32596-28-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143004.32596-1-sashal@kernel.org>
References: <20210628143004.32596-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.129-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.129-rc1
X-KernelTest-Deadline: 2021-06-30T14:29+00:00
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
index 0f2bee59a82b..0bc7f6518fb3 100644
--- a/drivers/net/caif/caif_serial.c
+++ b/drivers/net/caif/caif_serial.c
@@ -351,6 +351,7 @@ static int ldisc_open(struct tty_struct *tty)
 	rtnl_lock();
 	result = register_netdevice(dev);
 	if (result) {
+		tty_kref_put(tty);
 		rtnl_unlock();
 		free_netdev(dev);
 		return -ENODEV;
-- 
2.30.2

