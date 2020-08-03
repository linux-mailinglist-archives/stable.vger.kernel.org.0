Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FFC223A39C
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 13:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbgHCLw0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 07:52:26 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:52642 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726579AbgHCLwX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Aug 2020 07:52:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596455541;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=OFRirNY0qbITQuvUs027qrSTzYniVycvgcPdeGaACmE=;
        b=OOhCnX7xqFXSnXdDzlKY8Rm8VPraLdmc7aHVOfKZWxTgS8VrOgResL4qLMxoVxvVxjDGA5
        6PzuxJR/R0QRNP3fHPIzWvfsCjlHQfG7W91mvV+wce7vGqElrI020bnloE5pLhbBzwMqJ7
        ctUflXpnunREknyg+oUinq1Jf8MUnl8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-498-8xGRqULjOLyzspa6wAJgbg-1; Mon, 03 Aug 2020 07:52:19 -0400
X-MC-Unique: 8xGRqULjOLyzspa6wAJgbg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E8B7079EC1
        for <stable@vger.kernel.org>; Mon,  3 Aug 2020 11:52:18 +0000 (UTC)
Received: from max.home.com (unknown [10.40.194.131])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ED95B71762;
        Mon,  3 Aug 2020 11:52:14 +0000 (UTC)
From:   Andreas Gruenbacher <agruenba@redhat.com>
To:     cluster-devel@redhat.com
Cc:     Andreas Gruenbacher <agruenba@redhat.com>, stable@vger.kernel.org
Subject: [PATCH] gfs2: Fix refcount leak in gfs2_glock_poke
Date:   Mon,  3 Aug 2020 13:52:13 +0200
Message-Id: <20200803115213.432367-1-agruenba@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In gfs2_glock_poke, make sure gfs2_holder_uninit is called on the local
glock holder.  Without that, we're leaking a glock and a pid reference.

Fixes: 9e8990dea926 ("gfs2: Smarter iopen glock waiting")
Cc: stable@vger.kernel.org # v5.8+
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/gfs2/glock.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 57134d326cfa..f13b136654ca 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -790,9 +790,11 @@ static void gfs2_glock_poke(struct gfs2_glock *gl)
 	struct gfs2_holder gh;
 	int error;
 
-	error = gfs2_glock_nq_init(gl, LM_ST_SHARED, flags, &gh);
+	gfs2_holder_init(gl, LM_ST_SHARED, flags, &gh);
+	error = gfs2_glock_nq(&gh);
 	if (!error)
 		gfs2_glock_dq(&gh);
+	gfs2_holder_uninit(&gh);
 }
 
 static bool gfs2_try_evict(struct gfs2_glock *gl)
-- 
2.26.2

