Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9D16298931
	for <lists+stable@lfdr.de>; Mon, 26 Oct 2020 10:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391188AbgJZJMV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 05:12:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58079 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1747080AbgJZJMV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Oct 2020 05:12:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603703540;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=aBk/GB0BzK9NShbG1b7/o+zqziza4YabuXFT6JJKtRI=;
        b=dX6t6SVrtUDydEPFhBMTxig3yx0hptcCeO4iNDtYbNPt/8cK+lvNuhWf1yyHIpp3cZDsS9
        HydPUbyxCdZ91RV+qW19gSGWp74KAknmLUFirfBfLsX/qR2aaJC0xAe6bP6lG53kJg/Qtt
        515i/RCA8mr7nNRfUognq1JXRihcbms=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-558-zK_bwg7VOfWDzBJYSoBMuw-1; Mon, 26 Oct 2020 05:12:17 -0400
X-MC-Unique: zK_bwg7VOfWDzBJYSoBMuw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DB890425E9;
        Mon, 26 Oct 2020 09:12:15 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-70.rdu2.redhat.com [10.10.120.70])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 63D605C1C2;
        Mon, 26 Oct 2020 09:12:11 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH] cachefiles: Handle readpage error correctly
From:   David Howells <dhowells@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     stable@vger.kernel.org,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        dhowells@redhat.com, linux-cachefs@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 26 Oct 2020 09:12:10 +0000
Message-ID: <160370353064.1014444.12358832243259407276.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Wilcox (Oracle) <willy@infradead.org>

If ->readpage returns an error, it has already unlocked the page.

Fixes: 5e929b33c393 ("CacheFiles: Handle truncate unlocking the page we're reading")
Cc: stable@vger.kernel.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/cachefiles/rdwr.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/cachefiles/rdwr.c b/fs/cachefiles/rdwr.c
index 5b4cee71fa32..e027c718ca01 100644
--- a/fs/cachefiles/rdwr.c
+++ b/fs/cachefiles/rdwr.c
@@ -121,7 +121,7 @@ static int cachefiles_read_reissue(struct cachefiles_object *object,
 		_debug("reissue read");
 		ret = bmapping->a_ops->readpage(NULL, backpage);
 		if (ret < 0)
-			goto unlock_discard;
+			goto discard;
 	}
 
 	/* but the page may have been read before the monitor was installed, so
@@ -138,6 +138,7 @@ static int cachefiles_read_reissue(struct cachefiles_object *object,
 
 unlock_discard:
 	unlock_page(backpage);
+discard:
 	spin_lock_irq(&object->work_lock);
 	list_del(&monitor->op_link);
 	spin_unlock_irq(&object->work_lock);


