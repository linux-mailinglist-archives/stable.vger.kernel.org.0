Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77788246B9B
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730885AbgHQP7G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:59:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:46184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730939AbgHQP6z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:58:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7936920760;
        Mon, 17 Aug 2020 15:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679935;
        bh=tEM0h2Eeq0xk2+/KRcSElEjI+YzKG8o5jvvzr5kp4tU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0+TqDItDoGl0+80yDxxpfMRz9BfwWKA2ryTjo+1yPk8A89OLcp9DLcz7sZsZXkX7g
         Wii3N1I23AU6BSOmkujB2f3V5MXuCx8x0d4N3Av1uaLzIx1ETnkSfc0xikKf5WeUzJ
         vuGjlNiRJW3sIEgAb1HCFb6oPng/T/w6jcewsW64=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.7 383/393] xen/gntdev: Fix dmabuf import with non-zero sgt offset
Date:   Mon, 17 Aug 2020 17:17:13 +0200
Message-Id: <20200817143838.185481005@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>

commit 5fa4e6f1c2d8c9a4e47e1931b42893172d388f2b upstream.

It is possible that the scatter-gather table during dmabuf import has
non-zero offset of the data, but user-space doesn't expect that.
Fix this by failing the import, so user-space doesn't access wrong data.

Fixes: bf8dc55b1358 ("xen/gntdev: Implement dma-buf import functionality")

Signed-off-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
Acked-by: Juergen Gross <jgross@suse.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200813062113.11030-2-andr2000@gmail.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/xen/gntdev-dmabuf.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/xen/gntdev-dmabuf.c
+++ b/drivers/xen/gntdev-dmabuf.c
@@ -613,6 +613,14 @@ dmabuf_imp_to_refs(struct gntdev_dmabuf_
 		goto fail_detach;
 	}
 
+	/* Check that we have zero offset. */
+	if (sgt->sgl->offset) {
+		ret = ERR_PTR(-EINVAL);
+		pr_debug("DMA buffer has %d bytes offset, user-space expects 0\n",
+			 sgt->sgl->offset);
+		goto fail_unmap;
+	}
+
 	/* Check number of pages that imported buffer has. */
 	if (attach->dmabuf->size != gntdev_dmabuf->nr_pages << PAGE_SHIFT) {
 		ret = ERR_PTR(-EINVAL);


