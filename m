Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 464DB40E170
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240741AbhIPQaf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:30:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:38076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241580AbhIPQ1l (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:27:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 527B1615A6;
        Thu, 16 Sep 2021 16:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809058;
        bh=FQQhf1P/5UOOIWmCysYBlmJAOiWVzl/mtBuC34RsB9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jXK1yM13jR/91/yqFODTf9HPIDYC0dW5A3pL2U3lfrDwBvqq6Tndv4oO/iriNBbuJ
         kmXI/6cvyOeLvwIvcQQaFzooS//TpOmPVfyyecn1uNwFYDjpzp8JJMnD8rsRZEvpRj
         TicBf0gbbc1oXXZUjmwmfHDrai7pxkTevkZ3sOyw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.13 016/380] ceph: fix dereference of null pointer cf
Date:   Thu, 16 Sep 2021 17:56:13 +0200
Message-Id: <20210916155804.520893632@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
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
@@ -1756,6 +1756,9 @@ struct ceph_cap_flush *ceph_alloc_cap_fl
 	struct ceph_cap_flush *cf;
 
 	cf = kmem_cache_alloc(ceph_cap_flush_cachep, GFP_KERNEL);
+	if (!cf)
+		return NULL;
+
 	cf->is_capsnap = false;
 	return cf;
 }


