Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCEA38DB39
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729394AbfHNRHb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:07:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:57032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729895AbfHNRHa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:07:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44D172084D;
        Wed, 14 Aug 2019 17:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802449;
        bh=NfrpQmMOf4J9fkuQWntFAF9LT56Nkw0hUJGQNe8kZ3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vza96ptqohbyN4Uk7PoFynvG8hMBiWKh+/dKWBmAisOajYbmLxHQIOg3LhJPBvcvf
         9SA0Y9XTHn7g5vzgk+7Sl7sno+cSeHzOkWm1OikywYzIa+0dihiXxHmlllg+u+kDKS
         Ms3u9zpplM5ymJt4c5mmKmSPikoCwafU599/bMKI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 5.2 131/144] dax: dax_layout_busy_page() should not unmap cow pages
Date:   Wed, 14 Aug 2019 19:01:27 +0200
Message-Id: <20190814165805.424900046@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165759.466811854@linuxfoundation.org>
References: <20190814165759.466811854@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vivek Goyal <vgoyal@redhat.com>

commit d75996dd022b6d83bd14af59b2775b1aa639e4b9 upstream.

Vivek:

    "As of now dax_layout_busy_page() calls unmap_mapping_range() with last
     argument as 1, which says even unmap cow pages. I am wondering who needs
     to get rid of cow pages as well.

     I noticed one interesting side affect of this. I mount xfs with -o dax and
     mmaped a file with MAP_PRIVATE and wrote some data to a page which created
     cow page. Then I called fallocate() on that file to zero a page of file.
     fallocate() called dax_layout_busy_page() which unmapped cow pages as well
     and then I tried to read back the data I wrote and what I get is old
     data from persistent memory. I lost the data I had written. This
     read basically resulted in new fault and read back the data from
     persistent memory.

     This sounds wrong. Are there any users which need to unmap cow pages
     as well? If not, I am proposing changing it to not unmap cow pages.

     I noticed this while while writing virtio_fs code where when I tried
     to reclaim a memory range and that corrupted the executable and I
     was running from virtio-fs and program got segment violation."

Dan:

    "In fact the unmap_mapping_range() in this path is only to synchronize
     against get_user_pages_fast() and force it to call back into the
     filesystem to re-establish the mapping. COW pages should be left
     untouched by dax_layout_busy_page()."

Cc: <stable@vger.kernel.org>
Fixes: 5fac7408d828 ("mm, fs, dax: handle layout changes to pinned dax mappings")
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Link: https://lore.kernel.org/r/20190802192956.GA3032@redhat.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/dax.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/dax.c
+++ b/fs/dax.c
@@ -601,7 +601,7 @@ struct page *dax_layout_busy_page(struct
 	 * guaranteed to either see new references or prevent new
 	 * references from being established.
 	 */
-	unmap_mapping_range(mapping, 0, 0, 1);
+	unmap_mapping_range(mapping, 0, 0, 0);
 
 	xas_lock_irq(&xas);
 	xas_for_each(&xas, entry, ULONG_MAX) {


