Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 336C735BFD8
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237718AbhDLJHD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:07:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:54616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240253AbhDLJFX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:05:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E90661350;
        Mon, 12 Apr 2021 09:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218153;
        bh=PHbBWgzRd3G+NFaZBaVMzgI8cfLdfMIdyLajtqyTYc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0+HyLmY17mLCXDsCfroYE9wIy5MTBBsMw9Eetxte8rmu0MVBgV8m5xrAkdlC0XXVS
         vhV7rySYTkCPwngyLOO2RwsWPAQeVMQC3eQsG5IZCYNE7S0q/n9JlrtNydGJLYortM
         V8UZFgLvseZL0omOAzJshunTt6Aw1Zxke+1YWbTo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ciara Loftus <ciara.loftus@intel.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.11 056/210] libbpf: Restore umem state after socket create failure
Date:   Mon, 12 Apr 2021 10:39:21 +0200
Message-Id: <20210412084017.869491744@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ciara Loftus <ciara.loftus@intel.com>

commit 43f1bc1efff16f553dd573d02eb7a15750925568 upstream.

If the call to xsk_socket__create fails, the user may want to retry the
socket creation using the same umem. Ensure that the umem is in the
same state on exit if the call fails by:
1. ensuring the umem _save pointers are unmodified.
2. not unmapping the set of umem rings that were set up with the umem
during xsk_umem__create, since those maps existed before the call to
xsk_socket__create and should remain in tact even in the event of
failure.

Fixes: 2f6324a3937f ("libbpf: Support shared umems between queues and devices")
Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20210331061218.1647-3-ciara.loftus@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/lib/bpf/xsk.c |   41 +++++++++++++++++++++++------------------
 1 file changed, 23 insertions(+), 18 deletions(-)

--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -668,26 +668,30 @@ static struct xsk_ctx *xsk_get_ctx(struc
 	return NULL;
 }
 
-static void xsk_put_ctx(struct xsk_ctx *ctx)
+static void xsk_put_ctx(struct xsk_ctx *ctx, bool unmap)
 {
 	struct xsk_umem *umem = ctx->umem;
 	struct xdp_mmap_offsets off;
 	int err;
 
-	if (--ctx->refcount == 0) {
-		err = xsk_get_mmap_offsets(umem->fd, &off);
-		if (!err) {
-			munmap(ctx->fill->ring - off.fr.desc,
-			       off.fr.desc + umem->config.fill_size *
-			       sizeof(__u64));
-			munmap(ctx->comp->ring - off.cr.desc,
-			       off.cr.desc + umem->config.comp_size *
-			       sizeof(__u64));
-		}
+	if (--ctx->refcount)
+		return;
 
-		list_del(&ctx->list);
-		free(ctx);
-	}
+	if (!unmap)
+		goto out_free;
+
+	err = xsk_get_mmap_offsets(umem->fd, &off);
+	if (err)
+		goto out_free;
+
+	munmap(ctx->fill->ring - off.fr.desc, off.fr.desc + umem->config.fill_size *
+	       sizeof(__u64));
+	munmap(ctx->comp->ring - off.cr.desc, off.cr.desc + umem->config.comp_size *
+	       sizeof(__u64));
+
+out_free:
+	list_del(&ctx->list);
+	free(ctx);
 }
 
 static struct xsk_ctx *xsk_create_ctx(struct xsk_socket *xsk,
@@ -722,8 +726,6 @@ static struct xsk_ctx *xsk_create_ctx(st
 	memcpy(ctx->ifname, ifname, IFNAMSIZ - 1);
 	ctx->ifname[IFNAMSIZ - 1] = '\0';
 
-	umem->fill_save = NULL;
-	umem->comp_save = NULL;
 	ctx->fill = fill;
 	ctx->comp = comp;
 	list_add(&ctx->list, &umem->ctx_list);
@@ -779,6 +781,7 @@ int xsk_socket__create_shared(struct xsk
 	struct xsk_socket *xsk;
 	struct xsk_ctx *ctx;
 	int err, ifindex;
+	bool unmap = umem->fill_save != fill;
 
 	if (!umem || !xsk_ptr || !(rx || tx))
 		return -EFAULT;
@@ -919,6 +922,8 @@ int xsk_socket__create_shared(struct xsk
 	}
 
 	*xsk_ptr = xsk;
+	umem->fill_save = NULL;
+	umem->comp_save = NULL;
 	return 0;
 
 out_mmap_tx:
@@ -930,7 +935,7 @@ out_mmap_rx:
 		munmap(rx_map, off.rx.desc +
 		       xsk->config.rx_size * sizeof(struct xdp_desc));
 out_put_ctx:
-	xsk_put_ctx(ctx);
+	xsk_put_ctx(ctx, unmap);
 out_socket:
 	if (--umem->refcount)
 		close(xsk->fd);
@@ -996,7 +1001,7 @@ void xsk_socket__delete(struct xsk_socke
 		}
 	}
 
-	xsk_put_ctx(ctx);
+	xsk_put_ctx(ctx, true);
 
 	umem->refcount--;
 	/* Do not close an fd that also has an associated umem connected


