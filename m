Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFBF343D6DD
	for <lists+stable@lfdr.de>; Thu, 28 Oct 2021 00:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbhJ0Wqk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 18:46:40 -0400
Received: from relay.sw.ru ([185.231.240.75]:45838 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229993AbhJ0Wqj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Oct 2021 18:46:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=MIME-Version:Message-Id:Date:Subject:From:
        Content-Type; bh=d74juDRdxPoQkpotA/M6W+mrKHM/6IIG5SVXlhw+MOM=; b=A9afUDp7576H
        JoSoERxxs3mY5kKrGQV5qpbqU2nqw6G8HlZzB7WLb8brY7TXSHGfj5qr7VLQug/f3Ht3oSVRVZOnr
        LiNKtzud0BII91MzSGQJqpqYZwa6IO99cORVy2AaMKRDBDa7FSzU6A2gUmfrnv6yiWZEQ4lL+/U/4
        Ev6So=;
Received: from [10.94.6.52] (helo=dhcp-172-16-24-175.sw.ru)
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <alexander.mikhalitsyn@virtuozzo.com>)
        id 1mfreU-007RG6-BB; Thu, 28 Oct 2021 01:44:10 +0300
From:   Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
To:     linux-kernel@vger.kernel.org
Cc:     Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andrei Vagin <avagin@gmail.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        Vasily Averin <vvs@virtuozzo.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] ipc: WARN if trying to remove ipc object which is absent
Date:   Thu, 28 Oct 2021 01:43:47 +0300
Message-Id: <20211027224348.611025-2-alexander.mikhalitsyn@virtuozzo.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20211027224348.611025-1-alexander.mikhalitsyn@virtuozzo.com>
References: <20211027224348.611025-1-alexander.mikhalitsyn@virtuozzo.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Lets produce a warning if we trying to remove non-existing
IPC object from IPC namespace kht/idr structures.

This allows to catch possible bugs when ipc_rmid() function was
called with inconsistent struct ipc_ids*, struct kern_ipc_perm*
arguments.

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Vasily Averin <vvs@virtuozzo.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Alexander Mikhalitsyn <alexander@mihalicyn.com>
Cc: stable@vger.kernel.org
Co-developed-by: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
---
 ipc/util.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/ipc/util.c b/ipc/util.c
index 0027e47626b7..b28003c653d1 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -447,8 +447,8 @@ static int ipcget_public(struct ipc_namespace *ns, struct ipc_ids *ids,
 static void ipc_kht_remove(struct ipc_ids *ids, struct kern_ipc_perm *ipcp)
 {
 	if (ipcp->key != IPC_PRIVATE)
-		rhashtable_remove_fast(&ids->key_ht, &ipcp->khtnode,
-				       ipc_kht_params);
+		WARN_ON_ONCE(rhashtable_remove_fast(&ids->key_ht, &ipcp->khtnode,
+				       ipc_kht_params));
 }
 
 /**
@@ -498,7 +498,7 @@ void ipc_rmid(struct ipc_ids *ids, struct kern_ipc_perm *ipcp)
 {
 	int idx = ipcid_to_idx(ipcp->id);
 
-	idr_remove(&ids->ipcs_idr, idx);
+	WARN_ON_ONCE(idr_remove(&ids->ipcs_idr, idx) != ipcp);
 	ipc_kht_remove(ids, ipcp);
 	ids->in_use--;
 	ipcp->deleted = true;
-- 
2.31.1

