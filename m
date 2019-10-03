Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E22E2CACCA
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729034AbfJCR3e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 13:29:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:34968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388079AbfJCQMi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:12:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE26120865;
        Thu,  3 Oct 2019 16:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119158;
        bh=OEJuyGRuQV/TMV5fm8GvzzZkATmPIugznv+/fAGZ58I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A7vhQAbFtXUnMaUubQPD4W4rUggOadhw88ROfAiQX1tTGIt0tZ3GSKl6EOflMHZ7F
         VyY9kr8e6JMCvR6K9cvAONiu27wBUdxf/QVV61CXytuIIeRl6qgUjWaED+9U47iISg
         70XGd9Eoqh0EDFBJOMlt596mOryszaeU09B9zl3k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 4.14 147/185] fuse: fix missing unlock_page in fuse_writepage()
Date:   Thu,  3 Oct 2019 17:53:45 +0200
Message-Id: <20191003154511.943701174@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154437.541662648@linuxfoundation.org>
References: <20191003154437.541662648@linuxfoundation.org>
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
@@ -1699,6 +1699,7 @@ static int fuse_writepage(struct page *p
 		WARN_ON(wbc->sync_mode == WB_SYNC_ALL);
 
 		redirty_page_for_writepage(wbc, page);
+		unlock_page(page);
 		return 0;
 	}
 


