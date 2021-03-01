Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E306328F94
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242361AbhCATxM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:53:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:55160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242265AbhCAToS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:44:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8318865299;
        Mon,  1 Mar 2021 17:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619966;
        bh=oP76Qz3NljqfPRGvR0YglTT+F7RxoB8GYhz+DtHEjAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gC+dxl093aXW9s6fbQRw80xJzUBtSe2IiM/EwBNTSG2l2Kuj4ekmKqAIhniCOoxL7
         WEd8rGpKRSVufuGhaD86WNWQrNvZUU4aRiaqR8WfU7m565IhlXb/aJZSDXX1m0liWx
         61AllPCiXRge/Vjb2XIpqcgHxjhXu8s4MUGWinzc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.10 645/663] dm writecache: fix performance degradation in ssd mode
Date:   Mon,  1 Mar 2021 17:14:53 +0100
Message-Id: <20210301161213.764370775@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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


