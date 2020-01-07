Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 697EF1332CC
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:14:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729773AbgAGVJB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:09:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:33936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729771AbgAGVJA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:09:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DFE5E2077B;
        Tue,  7 Jan 2020 21:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431340;
        bh=+7HNKpmb+eFtvWyjVyXi+WtRWV+xXqbI+prde13+/jI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UM9cFRxFlECz0ByT0y1r1X0JL5jOXuRach3UG6BSKeDSUIkKtqpnsmUwSceAT8TRG
         d86cResq6hsM68Jx7N4DgBnhaNUz1R+p9Uw0946TN8oPf2u+zHSB1XTz0yFBbcdp1N
         +alnDoRErv6Dg1cTgUlDyLrvm8lRiJzphUx5AQZg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Durrant <pdurrant@amazon.com>,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        Juergen Gross <jgross@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 17/74] xen-blkback: prevent premature module unload
Date:   Tue,  7 Jan 2020 21:54:42 +0100
Message-Id: <20200107205147.834754123@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205135.369001641@linuxfoundation.org>
References: <20200107205135.369001641@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index ed4e80779124..e9fa4a1fc791 100644
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



