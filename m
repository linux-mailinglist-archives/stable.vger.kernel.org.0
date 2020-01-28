Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29B0414B917
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:33:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732698AbgA1O0j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:26:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:54128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733200AbgA1O0i (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:26:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FC9224686;
        Tue, 28 Jan 2020 14:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221597;
        bh=ry1w5+wOxDp6nob0N2laByzLXUOzRwsg+mF825EiCfI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wcAgr5/CKIOBpx7IdqCW8IxQLpQji8BlL4X/dBYys79qDymIBg9loNR9lXGYium8I
         U1dwLZWul6G88juZBOd3XdYN+VYtRuEAdMHHGAILSePzopRDTBlCmkyp8ibJQK8CI2
         C7NNjO1kRSyrhkjsoLnTjESPPr9SOdrmFgmYmK1w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        David Miller <davem@davemloft.net>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH 4.19 14/92] net-sysfs: Call dev_hold always in netdev_queue_add_kobject
Date:   Tue, 28 Jan 2020 15:07:42 +0100
Message-Id: <20200128135811.014435471@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135809.344954797@linuxfoundation.org>
References: <20200128135809.344954797@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jouni Hogander <jouni.hogander@unikie.com>

commit e0b60903b434a7ee21ba8d8659f207ed84101e89 upstream.

Dev_hold has to be called always in netdev_queue_add_kobject.
Otherwise usage count drops below 0 in case of failure in
kobject_init_and_add.

Fixes: b8eb718348b8 ("net-sysfs: Fix reference count leak in rx|netdev_queue_add_kobject")
Reported-by: Hulk Robot <hulkci@huawei.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: David Miller <davem@davemloft.net>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/core/net-sysfs.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1469,14 +1469,17 @@ static int netdev_queue_add_kobject(stru
 	struct kobject *kobj = &queue->kobj;
 	int error = 0;
 
+	/* Kobject_put later will trigger netdev_queue_release call
+	 * which decreases dev refcount: Take that reference here
+	 */
+	dev_hold(queue->dev);
+
 	kobj->kset = dev->queues_kset;
 	error = kobject_init_and_add(kobj, &netdev_queue_ktype, NULL,
 				     "tx-%u", index);
 	if (error)
 		goto err;
 
-	dev_hold(queue->dev);
-
 #ifdef CONFIG_BQL
 	error = sysfs_create_group(kobj, &dql_group);
 	if (error)


