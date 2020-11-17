Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2702B63E3
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733026AbgKQNme (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:42:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:53488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732521AbgKQNlM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:41:12 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDFA120870;
        Tue, 17 Nov 2020 13:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620471;
        bh=XGQzUUIqVdnBFX5aIgJkBe9k651L/X8WLIcid+bDbdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kyRSLbgwSSnD3ReRiG3Z2U8x5kWwbRmD8Dc8KlBPx2j5UmkEMIYSxXkMRq9dqLUOp
         hqbz0RSJkQUfrjIeqqbxrZZX+RJocNGgHnO0KPD2MjQjYJhtMxnnNiHTkeWP7AakAX
         578DTCxI6D8scX5qARbQo7lRqkH/VSwc1NbV/rUo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kris Karas <bugs-a17@moonlit-rail.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 5.9 231/255] NFSv4.2: fix failure to unregister shrinker
Date:   Tue, 17 Nov 2020 14:06:11 +0100
Message-Id: <20201117122150.181446172@linuxfoundation.org>
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

From: J. Bruce Fields <bfields@redhat.com>

commit 70438afbf17e5194dd607dd17759560a363b7bb4 upstream.

We forgot to unregister the nfs4_xattr_large_entry_shrinker.

That leaves the global list of shrinkers corrupted after unload of the
nfs module, after which possibly unrelated code that calls
register_shrinker() or unregister_shrinker() gets a BUG() with
"supervisor write access in kernel mode".

And similarly for the nfs4_xattr_large_entry_lru.

Reported-by: Kris Karas <bugs-a17@moonlit-rail.com>
Tested-By: Kris Karas <bugs-a17@moonlit-rail.com>
Fixes: 95ad37f90c33 "NFSv4.2: add client side xattr caching."
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
CC: stable@vger.kernel.org
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs42xattr.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/nfs/nfs42xattr.c
+++ b/fs/nfs/nfs42xattr.c
@@ -1048,8 +1048,10 @@ out4:
 
 void nfs4_xattr_cache_exit(void)
 {
+	unregister_shrinker(&nfs4_xattr_large_entry_shrinker);
 	unregister_shrinker(&nfs4_xattr_entry_shrinker);
 	unregister_shrinker(&nfs4_xattr_cache_shrinker);
+	list_lru_destroy(&nfs4_xattr_large_entry_lru);
 	list_lru_destroy(&nfs4_xattr_entry_lru);
 	list_lru_destroy(&nfs4_xattr_cache_lru);
 	kmem_cache_destroy(nfs4_xattr_cache_cachep);


