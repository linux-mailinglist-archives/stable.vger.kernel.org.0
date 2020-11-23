Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A246D2C0A38
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732620AbgKWNRj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:17:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:55206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732617AbgKWMmQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:42:16 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8070E20732;
        Mon, 23 Nov 2020 12:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135336;
        bh=mGWjZSu3zXKv9i8E57uyyHYaoeA3qrC3Ff3m4uJ5QS4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l96zlfr2FtYNPIHDKa2ewpEY3QQii47y/X/UmiYhZEGZusGm/UW7I8M/L0d47JTgE
         u7elg0zK6dquSmTTIAyMWtmxsusoXZULFrm8KgjPc+/q2Nzrt72I582X7grJ0KVDDL
         F4O5PDe0FAdesizs4+AxWANuNX+ghxB/xTlJ/kWE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 014/252] netdevsim: set .owner to THIS_MODULE
Date:   Mon, 23 Nov 2020 13:19:24 +0100
Message-Id: <20201123121836.279812929@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit a5bbcbf29089a1252c201b1a7fd38151de355db9 ]

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 82c93a87bf8b ("netdevsim: implement couple of testing devlink health reporters")
Fixes: 424be63ad831 ("netdevsim: add UDP tunnel port offload support")
Fixes: 4418f862d675 ("netdevsim: implement support for devlink region and snapshots")
Fixes: d3cbb907ae57 ("netdevsim: add ACL trap reporting cookie as a metadata")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Link: https://lore.kernel.org/r/20201115103041.30701-1-ap420073@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/netdevsim/dev.c         |    2 ++
 drivers/net/netdevsim/health.c      |    1 +
 drivers/net/netdevsim/udp_tunnels.c |    1 +
 3 files changed, 4 insertions(+)

--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -94,6 +94,7 @@ static const struct file_operations nsim
 	.open = simple_open,
 	.write = nsim_dev_take_snapshot_write,
 	.llseek = generic_file_llseek,
+	.owner = THIS_MODULE,
 };
 
 static ssize_t nsim_dev_trap_fa_cookie_read(struct file *file,
@@ -186,6 +187,7 @@ static const struct file_operations nsim
 	.read = nsim_dev_trap_fa_cookie_read,
 	.write = nsim_dev_trap_fa_cookie_write,
 	.llseek = generic_file_llseek,
+	.owner = THIS_MODULE,
 };
 
 static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
--- a/drivers/net/netdevsim/health.c
+++ b/drivers/net/netdevsim/health.c
@@ -261,6 +261,7 @@ static const struct file_operations nsim
 	.open = simple_open,
 	.write = nsim_dev_health_break_write,
 	.llseek = generic_file_llseek,
+	.owner = THIS_MODULE,
 };
 
 int nsim_dev_health_init(struct nsim_dev *nsim_dev, struct devlink *devlink)
--- a/drivers/net/netdevsim/udp_tunnels.c
+++ b/drivers/net/netdevsim/udp_tunnels.c
@@ -119,6 +119,7 @@ static const struct file_operations nsim
 	.open = simple_open,
 	.write = nsim_udp_tunnels_info_reset_write,
 	.llseek = generic_file_llseek,
+	.owner = THIS_MODULE,
 };
 
 int nsim_udp_tunnels_info_create(struct nsim_dev *nsim_dev,


