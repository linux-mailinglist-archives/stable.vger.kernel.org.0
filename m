Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 500CB1FC266
	for <lists+stable@lfdr.de>; Wed, 17 Jun 2020 01:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbgFPXhf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 19:37:35 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:27732 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726271AbgFPXhf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Jun 2020 19:37:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592350653;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=dAIoWCDMhMk4LZC+m7ZCXzqJOA4lfz/6pbetHLdYCkM=;
        b=i1OEICvRqrmtiZFLfazhUukk1Gzw0k5qhFgsvO5whsznSsrRfWM4BFH1LYm3G7oPkNuAKQ
        U0hsUNcy3zw5Vod82PBp9kzuoOvhI8P6VH70cNR3A9X4JIvDqRrL3sc98aE4DNpEpQsxSJ
        kz1459iVOpf4tpK+5YryMAPa3jfLHC8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-452-kOLjSPO9PqqAvDjvYIhBNQ-1; Tue, 16 Jun 2020 19:37:29 -0400
X-MC-Unique: kOLjSPO9PqqAvDjvYIhBNQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BBA33E919;
        Tue, 16 Jun 2020 23:37:28 +0000 (UTC)
Received: from npache.remote.csb (ovpn-115-159.rdu2.redhat.com [10.10.115.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C2E7719C71;
        Tue, 16 Jun 2020 23:37:25 +0000 (UTC)
From:   Nico Pache <npache@redhat.com>
To:     aquini@redhat.com, npache@redhat.com
Cc:     Yihui Zeng <yzeng56@asu.edu>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: 
Date:   Tue, 16 Jun 2020 19:37:21 -0400
Message-Id: <20200616233721.19313-1-npache@redhat.com>
Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1846533
CVE:    CVE-2020-10773 
Tested: https://datawarehouse-cki.apps.ocp.prod.psi.redhat.com/pipeline/601873
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From ec13df6442492592eb6a0b21d65d0489ac91a180 Mon Sep 17 00:00:00 2001
From: Yihui ZENG <yzeng56@asu.edu>
Date: Fri, 25 Oct 2019 12:31:48 +0300
Subject: [PATCH] s390/cmm: fix information leak in cmm_timeout_handler()

The problem is that we were putting the NUL terminator too far:

	buf[sizeof(buf) - 1] = '\0';

If the user input isn't NUL terminated and they haven't initialized the
whole buffer then it leads to an info leak.  The NUL terminator should
be:

	buf[len - 1] = '\0';

Signed-off-by: Yihui Zeng <yzeng56@asu.edu>
Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
[heiko.carstens@de.ibm.com: keep semantics of how *lenp and *ppos are handled]
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
(cherry picked from commit b8e51a6a9db94bc1fb18ae831b3dab106b5a4b5f)
Signed-off-by: Nico Pache <npache@redhat.com>
---
 arch/s390/mm/cmm.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/s390/mm/cmm.c b/arch/s390/mm/cmm.c
index 9d84a1feefef..846561d4245e 100644
--- a/arch/s390/mm/cmm.c
+++ b/arch/s390/mm/cmm.c
@@ -306,16 +306,16 @@ static int cmm_timeout_handler(ctl_table *ctl, int write,  void __user *buffer,
 	}
 
 	if (write) {
-		len = *lenp;
-		if (copy_from_user(buf, buffer,
-				   len > sizeof(buf) ? sizeof(buf) : len))
+		len = min(*lenp, sizeof(buf));
+		if (copy_from_user(buf, buffer, len))
 			return -EFAULT;
-		buf[sizeof(buf) - 1] = '\0';
+		buf[len - 1] = '\0';
 		cmm_skip_blanks(buf, &p);
 		nr = simple_strtoul(p, &p, 0);
 		cmm_skip_blanks(p, &p);
 		seconds = simple_strtoul(p, &p, 0);
 		cmm_set_timeout(nr, seconds);
+		*ppos += *lenp;
 	} else {
 		len = sprintf(buf, "%ld %ld\n",
 			      cmm_timeout_pages, cmm_timeout_seconds);
@@ -323,9 +323,9 @@ static int cmm_timeout_handler(ctl_table *ctl, int write,  void __user *buffer,
 			len = *lenp;
 		if (copy_to_user(buffer, buf, len))
 			return -EFAULT;
+		*lenp = len;
+		*ppos += len;
 	}
-	*lenp = len;
-	*ppos += len;
 	return 0;
 }
 
-- 
2.18.1

