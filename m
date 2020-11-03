Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BFF62A52A2
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:51:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729696AbgKCUvm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:51:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:47080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731979AbgKCUvj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:51:39 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFB1D20719;
        Tue,  3 Nov 2020 20:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436699;
        bh=WO/ScDgnIcLpusW7IfzMoFEU6c2HkLknbh+ilnrtuzo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DLoijzkt9AxhEWNhXObaPh//PL5qAdmVh3jtnGezPE//3e8GadSrkpscKjXFtd4W0
         fGJKGX3yKjScnOg+8n/pif6qROPzFFJGXaIqE3H56UBwc37zRyVhzjc72vho5CJ1Um
         O6kI0Foixoi/wKBzqLonoGK2ng7t+yQEgJ605zcw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.9 364/391] cachefiles: Handle readpage error correctly
Date:   Tue,  3 Nov 2020 21:36:55 +0100
Message-Id: <20201103203411.707063589@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Wilcox (Oracle) <willy@infradead.org>

commit 9480b4e75b7108ee68ecf5bc6b4bd68e8031c521 upstream.

If ->readpage returns an error, it has already unlocked the page.

Fixes: 5e929b33c393 ("CacheFiles: Handle truncate unlocking the page we're reading")
Cc: stable@vger.kernel.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cachefiles/rdwr.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/cachefiles/rdwr.c
+++ b/fs/cachefiles/rdwr.c
@@ -121,7 +121,7 @@ static int cachefiles_read_reissue(struc
 		_debug("reissue read");
 		ret = bmapping->a_ops->readpage(NULL, backpage);
 		if (ret < 0)
-			goto unlock_discard;
+			goto discard;
 	}
 
 	/* but the page may have been read before the monitor was installed, so
@@ -138,6 +138,7 @@ static int cachefiles_read_reissue(struc
 
 unlock_discard:
 	unlock_page(backpage);
+discard:
 	spin_lock_irq(&object->work_lock);
 	list_del(&monitor->op_link);
 	spin_unlock_irq(&object->work_lock);


