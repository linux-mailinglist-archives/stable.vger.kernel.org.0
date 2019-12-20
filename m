Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B04B127CFC
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 15:32:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727548AbfLTObz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 09:31:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:35110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727988AbfLTObC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Dec 2019 09:31:02 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BCF024686;
        Fri, 20 Dec 2019 14:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576852261;
        bh=BSMkqmRXgeX1/bPvH4POSuwtq+XdKjoPpNBYCSOA42k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PGEzLZEGVwC4XWkTLNvAmcyAvLlxVPTAGpbtshWYGCkoF8mYBTCGHl21QSLLDmtfU
         cSMrGUJP4lHsnOw6jI/CR6d850OZnERZgB34hGp/D0uOiVjsTsP56dwqnZDVzX3R7N
         zZQbYMv+uT7cprF/nRl0yubyWFjkXKHRXpt2wd5g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paul Durrant <pdurrant@amazon.com>,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        Juergen Gross <jgross@suse.com>,
        Sasha Levin <sashal@kernel.org>,
        xen-devel@lists.xenproject.org, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 50/52] xen-blkback: prevent premature module unload
Date:   Fri, 20 Dec 2019 09:29:52 -0500
Message-Id: <20191220142954.9500-50-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191220142954.9500-1-sashal@kernel.org>
References: <20191220142954.9500-1-sashal@kernel.org>
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
index b90dbcd99c03e..c4cd68116e7fc 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -171,6 +171,15 @@ static struct xen_blkif *xen_blkif_alloc(domid_t domid)
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
@@ -320,6 +329,7 @@ static void xen_blkif_free(struct xen_blkif *blkif)
 
 	/* Make sure everything is drained before shutting down */
 	kmem_cache_free(xen_blkif_cachep, blkif);
+	module_put(THIS_MODULE);
 }
 
 int __init xen_blkif_interface_init(void)
-- 
2.20.1

