Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DCD114B8B4
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732283AbgA1O0g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:26:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:54060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732570AbgA1O0g (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:26:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08EB12468D;
        Tue, 28 Jan 2020 14:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221595;
        bh=QHFduYetVXp18KqrwLRNczgW2umXofVRO1RGBi7dz+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m6fWFlbggikSAV10uBJwufuRISd1TUcQcVMao/csKzFTp1XnXwA/8QssZrk5ua8Ce
         MfWfvA8zgykz7MIG61ENKm+V3L9BSC7Q6KDE1cdOAX5/FAEEo4e9J7zHdJ/LRlPAO+
         x+0mPpdobDVreSzwR1UYNA+sEIsZSZWs+MECyqKE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jouni Hogander <jouni.hogander@unikie.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 13/92] net-sysfs: fix netdev_queue_add_kobject() breakage
Date:   Tue, 28 Jan 2020 15:07:41 +0100
Message-Id: <20200128135810.897145079@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

commit 48a322b6f9965b2f1e4ce81af972f0e287b07ed0 upstream.

kobject_put() should only be called in error path.

Fixes: b8eb718348b8 ("net-sysfs: Fix reference count leak in rx|netdev_queue_add_kobject")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Jouni Hogander <jouni.hogander@unikie.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/core/net-sysfs.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1484,6 +1484,7 @@ static int netdev_queue_add_kobject(stru
 #endif
 
 	kobject_uevent(kobj, KOBJ_ADD);
+	return 0;
 
 err:
 	kobject_put(kobj);


