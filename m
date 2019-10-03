Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38483CA8EF
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391527AbfJCQek (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:34:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:43318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391775AbfJCQej (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:34:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D9A620830;
        Thu,  3 Oct 2019 16:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120478;
        bh=ZSr+ymMHWbVbOK74oW3ZFZxpB4i/n3GUFDbjMk3BF4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MhR2wjqG8wNQ0LFe0cplbQn6d5ND7PUmlNee7rNZ+iGxEi8QCF0WaUbK1IW9bC6iw
         OWLnL64Bl0h0mSkTO5w7+qi7f6QW3+U09zpDud+IPQY+umf4XVrUxRvUcYBzQI7k3s
         pX6x22kQTD8leeM8BfodAvdxGj0FhrvI24rNc6dk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.2 236/313] fuse: fix missing unlock_page in fuse_writepage()
Date:   Thu,  3 Oct 2019 17:53:34 +0200
Message-Id: <20191003154556.245317543@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

commit d5880c7a8620290a6c90ced7a0e8bd0ad9419601 upstream.

unlock_page() was missing in case of an already in-flight write against the
same page.

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Fixes: ff17be086477 ("fuse: writepage: skip already in flight")
Cc: <stable@vger.kernel.org> # v3.13
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fuse/file.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1767,6 +1767,7 @@ static int fuse_writepage(struct page *p
 		WARN_ON(wbc->sync_mode == WB_SYNC_ALL);
 
 		redirty_page_for_writepage(wbc, page);
+		unlock_page(page);
 		return 0;
 	}
 


