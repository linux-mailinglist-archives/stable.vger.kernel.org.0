Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEFA226191F
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 20:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731740AbgIHSHk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 14:07:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:56674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731500AbgIHQLu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:11:50 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E484F2472F;
        Tue,  8 Sep 2020 15:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579651;
        bh=aOapCg8Fs1QO/aVSI3dHbCrCilxDYbrwYv0hJDimFW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J+CleQUMk0NF4lVwjUi+CPaQubOTbG1rSNwHBZlvEfBi/QOubvmn8jrFjn0FZQTRj
         ZPVz1xPNGb9mXHFATp1afPX38zna3hQGcr36KphIgfNeph+Ppket5D0aj91wbmhU8N
         jWme6CH0HwR1WT8KOqvMTIqKkjrp4XN3jxOumMHY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.8 165/186] dm writecache: handle DAX to partitions on persistent memory correctly
Date:   Tue,  8 Sep 2020 17:25:07 +0200
Message-Id: <20200908152249.661695677@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit f9e040efcc28309e5c592f7e79085a9a52e31f58 upstream.

The function dax_direct_access doesn't take partitions into account,
it always maps pages from the beginning of the device. Therefore,
persistent_memory_claim() must get the partition offset using
get_start_sect() and add it to the page offsets passed to
dax_direct_access().

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: 48debafe4f2f ("dm: add writecache target")
Cc: stable@vger.kernel.org # 4.18+
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-writecache.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -231,6 +231,7 @@ static int persistent_memory_claim(struc
 	pfn_t pfn;
 	int id;
 	struct page **pages;
+	sector_t offset;
 
 	wc->memory_vmapped = false;
 
@@ -245,9 +246,16 @@ static int persistent_memory_claim(struc
 		goto err1;
 	}
 
+	offset = get_start_sect(wc->ssd_dev->bdev);
+	if (offset & (PAGE_SIZE / 512 - 1)) {
+		r = -EINVAL;
+		goto err1;
+	}
+	offset >>= PAGE_SHIFT - 9;
+
 	id = dax_read_lock();
 
-	da = dax_direct_access(wc->ssd_dev->dax_dev, 0, p, &wc->memory_map, &pfn);
+	da = dax_direct_access(wc->ssd_dev->dax_dev, offset, p, &wc->memory_map, &pfn);
 	if (da < 0) {
 		wc->memory_map = NULL;
 		r = da;
@@ -269,7 +277,7 @@ static int persistent_memory_claim(struc
 		i = 0;
 		do {
 			long daa;
-			daa = dax_direct_access(wc->ssd_dev->dax_dev, i, p - i,
+			daa = dax_direct_access(wc->ssd_dev->dax_dev, offset + i, p - i,
 						NULL, &pfn);
 			if (daa <= 0) {
 				r = daa ? daa : -EINVAL;


