Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B03540E5D3
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242937AbhIPRPy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:15:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:37128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240991AbhIPRHT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:07:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C56161B2E;
        Thu, 16 Sep 2021 16:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810164;
        bh=UGHrKtu/1BmUM34YT/nG1a3LYXSd907BIv+JWrNiEwA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Np0UaftB4KEtDs8oh1IRnVgjIX12sNlQA8gpgelxdZgSi/sAh2GQ2ciM9ZWNx9/SZ
         p6n0CNVwuaXujdlbByuKpvRZQukGFCRd5OzBoEjSugoZn2Wz7oRXoLZkQUTQdJPSuG
         m8aiipzD74a7kKLWqX/dSPbTe02LNMWU6QhXV1Js=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.14 023/432] ceph: fix dereference of null pointer cf
Date:   Thu, 16 Sep 2021 17:56:12 +0200
Message-Id: <20210916155811.609654755@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

commit 05a444d3f90a3c3e6362e88a1bf13e1a60f8cace upstream.

Currently in the case where kmem_cache_alloc fails the null pointer
cf is dereferenced when assigning cf->is_capsnap = false. Fix this
by adding a null pointer check and return path.

Cc: stable@vger.kernel.org
Addresses-Coverity: ("Dereference null return")
Fixes: b2f9fa1f3bd8 ("ceph: correctly handle releasing an embedded cap flush")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/caps.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1746,6 +1746,9 @@ struct ceph_cap_flush *ceph_alloc_cap_fl
 	struct ceph_cap_flush *cf;
 
 	cf = kmem_cache_alloc(ceph_cap_flush_cachep, GFP_KERNEL);
+	if (!cf)
+		return NULL;
+
 	cf->is_capsnap = false;
 	return cf;
 }


