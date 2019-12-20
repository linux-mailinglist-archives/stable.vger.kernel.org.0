Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47D8C127E0D
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 15:38:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727634AbfLTOiU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 09:38:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:42224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728383AbfLTOiD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Dec 2019 09:38:03 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55C342467F;
        Fri, 20 Dec 2019 14:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576852683;
        bh=0UoII2AumJokC/VfrLLHvpS8mLc3XhNoQs9cuTn6rEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=04nUYxhNZoBHkCtoX71EIKnYzzOqQrZS6rVgbebhUTYse1JEIQJDsTDQry5cVIc8q
         7Gy8RyZAN6MiHy0KMoSsH+pPLFIuMukoqGcVqCe5kawsM7sGbajiBKC/CHK3p0PHEe
         WCZIIUcNkgiaoPq2RdHDD71esEaiaYGsrBuRTXWw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paul Durrant <pdurrant@amazon.com>,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        Juergen Gross <jgross@suse.com>,
        Sasha Levin <sashal@kernel.org>,
        xen-devel@lists.xenproject.org, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 17/19] xen-blkback: prevent premature module unload
Date:   Fri, 20 Dec 2019 09:37:38 -0500
Message-Id: <20191220143741.10220-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191220143741.10220-1-sashal@kernel.org>
References: <20191220143741.10220-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Durrant <pdurrant@amazon.com>

[ Upstream commit fa2ac657f9783f0891b2935490afe9a7fd29d3fa ]

Objects allocated by xen_blkif_alloc come from the 'blkif_cache' kmem
cache. This cache is destoyed when xen-blkif is unloaded so it is
necessary to wait for the deferred free routine used for such objects to
complete. This necessity was missed in commit 14855954f636 "xen-blkback:
allow module to be cleanly unloaded". This patch fixes the problem by
taking/releasing extra module references in xen_blkif_alloc/free()
respectively.

Signed-off-by: Paul Durrant <pdurrant@amazon.com>
Reviewed-by: Roger Pau Monné <roger.pau@citrix.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/xen-blkback/xenbus.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index ed4e807791243..e9fa4a1fc7912 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -178,6 +178,15 @@ static struct xen_blkif *xen_blkif_alloc(domid_t domid)
 	blkif->domid = domid;
 	atomic_set(&blkif->refcnt, 1);
 	init_completion(&blkif->drain_complete);
+
+	/*
+	 * Because freeing back to the cache may be deferred, it is not
+	 * safe to unload the module (and hence destroy the cache) until
+	 * this has completed. To prevent premature unloading, take an
+	 * extra module reference here and release only when the object
+	 * has been freed back to the cache.
+	 */
+	__module_get(THIS_MODULE);
 	INIT_WORK(&blkif->free_work, xen_blkif_deferred_free);
 
 	return blkif;
@@ -327,6 +336,7 @@ static void xen_blkif_free(struct xen_blkif *blkif)
 
 	/* Make sure everything is drained before shutting down */
 	kmem_cache_free(xen_blkif_cachep, blkif);
+	module_put(THIS_MODULE);
 }
 
 int __init xen_blkif_interface_init(void)
-- 
2.20.1

