Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAD7B81C93
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730883AbfHENZV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:25:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:33830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731197AbfHENZT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:25:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67FC620644;
        Mon,  5 Aug 2019 13:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011517;
        bh=/Dx7ANAA6hN9wxWi6f/n3vKkYD7HxxDIeNOQP/47imU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kizo4rJuMGLwjfRjOYKD8ZbyqZA7HbTOJutCiUDJEoH53z9jpPNahlIO0/tsngIOm
         5VIk6IuDTmhHUrUhgWGeqVQ3Ym8lhhhDgeFuGUvA9SRC+ixh6zVsNzcNQ1+t3UllVj
         0HdChAh8YML2jdn+RGb5J2dSFKsEQnqnX6y2jIOI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>,
        Souptick Joarder <jrdr.linux@gmail.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.2 119/131] xen/gntdev.c: Replace vm_map_pages() with vm_map_pages_zero()
Date:   Mon,  5 Aug 2019 15:03:26 +0200
Message-Id: <20190805124959.927342582@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124951.453337465@linuxfoundation.org>
References: <20190805124951.453337465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Souptick Joarder <jrdr.linux@gmail.com>

commit 8d1502f629c9966743de45744f4c1ba93a57d105 upstream.

'commit df9bde015a72 ("xen/gntdev.c: convert to use vm_map_pages()")'
breaks gntdev driver. If vma->vm_pgoff > 0, vm_map_pages()
will:
 - use map->pages starting at vma->vm_pgoff instead of 0
 - verify map->count against vma_pages()+vma->vm_pgoff instead of just
   vma_pages().

In practice, this breaks using a single gntdev FD for mapping multiple
grants.

relevant strace output:
[pid   857] ioctl(7, IOCTL_GNTDEV_MAP_GRANT_REF, 0x7ffd3407b6d0) = 0
[pid   857] mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_SHARED, 7, 0) =
0x777f1211b000
[pid   857] ioctl(7, IOCTL_GNTDEV_SET_UNMAP_NOTIFY, 0x7ffd3407b710) = 0
[pid   857] ioctl(7, IOCTL_GNTDEV_MAP_GRANT_REF, 0x7ffd3407b6d0) = 0
[pid   857] mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_SHARED, 7,
0x1000) = -1 ENXIO (No such device or address)

details here:
https://github.com/QubesOS/qubes-issues/issues/5199

The reason is -> ( copying Marek's word from discussion)

vma->vm_pgoff is used as index passed to gntdev_find_map_index. It's
basically using this parameter for "which grant reference to map".
map struct returned by gntdev_find_map_index() describes just the pages
to be mapped. Specifically map->pages[0] should be mapped at
vma->vm_start, not vma->vm_start+vma->vm_pgoff*PAGE_SIZE.

When trying to map grant with index (aka vma->vm_pgoff) > 1,
__vm_map_pages() will refuse to map it because it will expect map->count
to be at least vma_pages(vma)+vma->vm_pgoff, while it is exactly
vma_pages(vma).

Converting vm_map_pages() to use vm_map_pages_zero() will fix the
problem.

Marek has tested and confirmed the same.

Cc: stable@vger.kernel.org # v5.2+
Fixes: df9bde015a72 ("xen/gntdev.c: convert to use vm_map_pages()")

Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
Tested-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/xen/gntdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -1145,7 +1145,7 @@ static int gntdev_mmap(struct file *flip
 		goto out_put_map;
 
 	if (!use_ptemod) {
-		err = vm_map_pages(vma, map->pages, map->count);
+		err = vm_map_pages_zero(vma, map->pages, map->count);
 		if (err)
 			goto out_put_map;
 	} else {


