Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA47A329229
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238438AbhCAUkS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:40:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:51350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236783AbhCAUdo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:33:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FB2C65104;
        Mon,  1 Mar 2021 18:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614622172;
        bh=oP76Qz3NljqfPRGvR0YglTT+F7RxoB8GYhz+DtHEjAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qOwQzIWUiMOm4F7RG1e73K2jwwmhU7tdCCxuyQZwBXHEyShEtbHI8081Z1rI31/oK
         AcnbBrB6BZ8bdWgwlI7fY9+9SKAm9jOKSowQKYrrBN1DwVG5P2NnXfiOmzLh91GYY/
         Yc2qxxl03DFIovEW8USdq1lpTbMaxe8AIX9tRKCk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.11 757/775] dm writecache: fix performance degradation in ssd mode
Date:   Mon,  1 Mar 2021 17:15:25 +0100
Message-Id: <20210301161238.722034854@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit cb728484a7710c202f02b96aa0962ce9b07aa5c2 upstream.

Fix a thinko in ssd_commit_superblock. region.count is in sectors, not
bytes. This bug doesn't corrupt data, but it causes performance
degradation.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: dc8a01ae1dbd ("dm writecache: optimize superblock write")
Cc: stable@vger.kernel.org # v5.7+
Reported-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-writecache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -523,7 +523,7 @@ static void ssd_commit_superblock(struct
 
 	region.bdev = wc->ssd_dev->bdev;
 	region.sector = 0;
-	region.count = PAGE_SIZE;
+	region.count = PAGE_SIZE >> SECTOR_SHIFT;
 
 	if (unlikely(region.sector + region.count > wc->metadata_sectors))
 		region.count = wc->metadata_sectors - region.sector;


