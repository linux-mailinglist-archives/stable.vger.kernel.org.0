Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C81E42B6450
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733102AbgKQNps (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:45:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:50400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732714AbgKQNi4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:38:56 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CDF224686;
        Tue, 17 Nov 2020 13:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620336;
        bh=Kqj6HjstnrinK+EdA1ZCxAJKe/uCeXJQ14TCnPfp7xs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xnwU7qU8JtyGPuR+EwGPKiIYNAuOP9FbaUiouJ48WeAPOKQ/W2u3kiGbFPortQiHE
         NwbTqIXmVZz9Xsil/xC9nWs0A/K8q6gfF7vIqL4iU+NQV4UD0vMlWnjEwEv3EF6GJJ
         B6crspBS3K+OkgTZa64sBXdhXTOt13p0xEpVp7kk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Zapolskiy <vladimir@tuxera.com>,
        Chao Yu <yuchao0@huawei.com>, Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH 5.9 183/255] erofs: fix setting up pcluster for temporary pages
Date:   Tue, 17 Nov 2020 14:05:23 +0100
Message-Id: <20201117122147.825896165@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gao Xiang <hsiangkao@redhat.com>

commit a30573b3cdc77b8533d004ece1ea7c0146b437a0 upstream.

pcluster should be only set up for all managed pages instead of
temporary pages. Since it currently uses page->mapping to identify,
the impact is minor for now.

[ Update: Vladimir reported the kernel log becomes polluted
  because PAGE_FLAGS_CHECK_AT_FREE flag(s) set if the page
  allocation debug option is enabled. ]

Link: https://lore.kernel.org/r/20201022145724.27284-1-hsiangkao@aol.com
Fixes: 5ddcee1f3a1c ("erofs: get rid of __stagingpage_alloc helper")
Cc: <stable@vger.kernel.org> # 5.5+
Tested-by: Vladimir Zapolskiy <vladimir@tuxera.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/erofs/zdata.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1080,8 +1080,11 @@ out_allocpage:
 		cond_resched();
 		goto repeat;
 	}
-	set_page_private(page, (unsigned long)pcl);
-	SetPagePrivate(page);
+
+	if (tocache) {
+		set_page_private(page, (unsigned long)pcl);
+		SetPagePrivate(page);
+	}
 out:	/* the only exit (for tracing and debugging) */
 	return page;
 }


