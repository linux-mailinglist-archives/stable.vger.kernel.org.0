Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12498310E7D
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 18:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233240AbhBEPi1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 10:38:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57019 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233268AbhBEPgY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Feb 2021 10:36:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612545440;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ihSyqYfW0nGFsoTHzFvhp8JA++HG2ehzL7hWbqCwMZA=;
        b=gOqW9sVNDoecND4/2iJUWk0SkLGzxZxEOEDLIaavUzc/N87RBnYpelNWvx0Ya8NY0nDTNq
        gGyTNrfPT08pSjdGcYd4ubsz5wYMsIWxJqndy6hksXD3eZZYubs0rrG53PJBGfNe6c2QcZ
        iFhjEjlTmUF4ybOVvMgQsxadWQNEjEA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292-Ix-xrUFLOCqkazPGwRtOtg-1; Fri, 05 Feb 2021 12:17:18 -0500
X-MC-Unique: Ix-xrUFLOCqkazPGwRtOtg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DE4ED100AA21
        for <stable@vger.kernel.org>; Fri,  5 Feb 2021 17:17:10 +0000 (UTC)
Received: from max.com (ovpn-112-155.ams2.redhat.com [10.36.112.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0AAEA5D9D2;
        Fri,  5 Feb 2021 17:17:09 +0000 (UTC)
From:   Andreas Gruenbacher <agruenba@redhat.com>
To:     cluster-devel@redhat.com
Cc:     Andreas Gruenbacher <agruenba@redhat.com>, stable@vger.kernel.org
Subject: [PATCH] gfs2: Lock imbalance on error path in gfs2_recover_one
Date:   Fri,  5 Feb 2021 18:17:08 +0100
Message-Id: <20210205171708.326048-1-agruenba@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In gfs2_recover_one, fix a sd_log_flush_lock imbalance when a recovery
pass fails.

Fixes: c9ebc4b73799 ("gfs2: allow journal replay to hold sd_log_flush_lock")
Cc: stable@vger.kernel.org # v5.7+
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/gfs2/recovery.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/gfs2/recovery.c b/fs/gfs2/recovery.c
index a3eae2c76b70..f15f9b86e8a7 100644
--- a/fs/gfs2/recovery.c
+++ b/fs/gfs2/recovery.c
@@ -511,8 +511,10 @@ static void gfs2_recover_one(struct gfs2_jdesc *jd)
 			error = foreach_descriptor(jd, head.lh_tail,
 						   head.lh_blkno, pass);
 			lops_after_scan(jd, error, pass);
-			if (error)
+			if (error) {
+				up_read(&sdp->sd_log_flush_lock);
 				goto fail_gunlock_thaw;
+			}
 		}
 
 		recover_local_statfs(jd, &head);
-- 
2.26.2

