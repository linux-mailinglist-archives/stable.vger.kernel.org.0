Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51E28157893
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:09:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728890AbgBJMj2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:39:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:37124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728130AbgBJMj1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:39:27 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87C1821739;
        Mon, 10 Feb 2020 12:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338366;
        bh=t+7mj2y7Pg3yWFabejvmCnP1OD8PLDuyovdxaA+8P1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xIGXde+u519NtW9POFP9LciPNfcxDYXY0Nr4G49U5tkVQ6Aabd4VKia40Ik6wSofJ
         b/coXnHLPdTah8npshJ/SxPfotoFMivJKaVyNxAxYQNF0mxjqBH/J4L84pPHnnGfyU
         POzQeIfNz7eHqhnzoLGgMWFBtMVHrnxTEEXxUbaw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Taehee Yoo <ap420073@gmail.com>
Subject: [PATCH 5.5 025/367] netdevsim: fix stack-out-of-bounds in nsim_dev_debugfs_init()
Date:   Mon, 10 Feb 2020 04:28:58 -0800
Message-Id: <20200210122426.200878011@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 6fb8852b1298200da39bd85788bc5755d1d56f32 ]

When netdevsim dev is being created, a debugfs directory is created.
The variable "dev_ddir_name" is 16bytes device name pointer and device
name is "netdevsim<dev id>".
The maximum dev id length is 10.
So, 16bytes for device name isn't enough.

Test commands:
    modprobe netdevsim
    echo "1000000000 0" > /sys/bus/netdevsim/new_device

Splat looks like:
[  249.622710][  T900] BUG: KASAN: stack-out-of-bounds in number+0x824/0x880
[  249.623658][  T900] Write of size 1 at addr ffff88804c527988 by task bash/900
[  249.624521][  T900]
[  249.624830][  T900] CPU: 1 PID: 900 Comm: bash Not tainted 5.5.0+ #322
[  249.625691][  T900] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  249.626712][  T900] Call Trace:
[  249.627103][  T900]  dump_stack+0x96/0xdb
[  249.627639][  T900]  ? number+0x824/0x880
[  249.628173][  T900]  print_address_description.constprop.5+0x1be/0x360
[  249.629022][  T900]  ? number+0x824/0x880
[  249.629569][  T900]  ? number+0x824/0x880
[  249.630105][  T900]  __kasan_report+0x12a/0x170
[  249.630717][  T900]  ? number+0x824/0x880
[  249.631201][  T900]  kasan_report+0xe/0x20
[  249.631723][  T900]  number+0x824/0x880
[  249.632235][  T900]  ? put_dec+0xa0/0xa0
[  249.632716][  T900]  ? rcu_read_lock_sched_held+0x90/0xc0
[  249.633392][  T900]  vsnprintf+0x63c/0x10b0
[  249.633983][  T900]  ? pointer+0x5b0/0x5b0
[  249.634543][  T900]  ? mark_lock+0x11d/0xc40
[  249.635200][  T900]  sprintf+0x9b/0xd0
[  249.635750][  T900]  ? scnprintf+0xe0/0xe0
[  249.636370][  T900]  nsim_dev_probe+0x63c/0xbf0 [netdevsim]
[ ... ]

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Fixes: ab1d0cc004d7 ("netdevsim: change debugfs tree topology")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/netdevsim/dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -73,7 +73,7 @@ static const struct file_operations nsim
 
 static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
 {
-	char dev_ddir_name[16];
+	char dev_ddir_name[sizeof(DRV_NAME) + 10];
 
 	sprintf(dev_ddir_name, DRV_NAME "%u", nsim_dev->nsim_bus_dev->dev.id);
 	nsim_dev->ddir = debugfs_create_dir(dev_ddir_name, nsim_dev_ddir);


