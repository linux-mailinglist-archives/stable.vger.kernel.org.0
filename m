Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E68121F4506
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388604AbgFISKw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 14:10:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41236 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388140AbgFISF5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 14:05:57 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidF-0001oO-1J; Tue, 09 Jun 2020 19:05:53 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidE-006Vup-BB; Tue, 09 Jun 2020 19:05:52 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jouni Hogander" <jouni.hogander@unikie.com>
Date:   Tue, 09 Jun 2020 19:03:59 +0100
Message-ID: <lsq.1591725832.156394384@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 08/61] net-sysfs: fix netdev_queue_add_kobject() breakage
In-Reply-To: <lsq.1591725831.850867383@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.85-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 48a322b6f9965b2f1e4ce81af972f0e287b07ed0 upstream.

kobject_put() should only be called in error path.

Fixes: b8eb718348b8 ("net-sysfs: Fix reference count leak in rx|netdev_queue_add_kobject")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Jouni Hogander <jouni.hogander@unikie.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/core/net-sysfs.c | 1 +
 1 file changed, 1 insertion(+)

--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1158,6 +1158,7 @@ static int netdev_queue_add_kobject(stru
 #endif
 
 	kobject_uevent(kobj, KOBJ_ADD);
+	return 0;
 
 err:
 	kobject_put(kobj);

