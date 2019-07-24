Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A22AC73D26
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391876AbfGXUPB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:15:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:37218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404318AbfGXTyU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:54:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2976420665;
        Wed, 24 Jul 2019 19:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998059;
        bh=7qHMARGZqYN8XVCRyjerYdEwNpm0JOUaZFtCVUzQbSI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lQ04XvIHiIWbjCPFhtrL/6bZ0EDWGY895RAgaeFgH2tXjks7bWVTG6t7YMkHmHHxl
         SwOJePt7xDCZ3rxs/9rb30EnutpieiLGQAnmj/poC0pyBjhg5wEqiYW+zLzndnG4fy
         QzLft9YD5yM3RK2mCKn3TVuRELV5wWW5KmNC1N20=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.com>,
        "Ewan D. Milne" <emilne@redhat.com>,
        Ming Lei <ming.lei@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.1 232/371] scsi: core: Fix race on creating sense cache
Date:   Wed, 24 Jul 2019 21:19:44 +0200
Message-Id: <20190724191741.947657397@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

commit f9b0530fa02e0c73f31a49ef743e8f44eb8e32cc upstream.

When scsi_init_sense_cache(host) is called concurrently from different
hosts, each code path may find that no cache has been created and
allocate a new one. The lack of locking can lead to potentially
overriding a cache allocated by a different host.

Fix the issue by moving 'mutex_lock(&scsi_sense_cache_mutex)' before
scsi_select_sense_cache().

Fixes: 0a6ac4ee7c21 ("scsi: respect unchecked_isa_dma for blk-mq")
Cc: Stable <stable@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/scsi_lib.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -71,11 +71,11 @@ int scsi_init_sense_cache(struct Scsi_Ho
 	struct kmem_cache *cache;
 	int ret = 0;
 
+	mutex_lock(&scsi_sense_cache_mutex);
 	cache = scsi_select_sense_cache(shost->unchecked_isa_dma);
 	if (cache)
-		return 0;
+		goto exit;
 
-	mutex_lock(&scsi_sense_cache_mutex);
 	if (shost->unchecked_isa_dma) {
 		scsi_sense_isadma_cache =
 			kmem_cache_create("scsi_sense_cache(DMA)",
@@ -91,7 +91,7 @@ int scsi_init_sense_cache(struct Scsi_Ho
 		if (!scsi_sense_cache)
 			ret = -ENOMEM;
 	}
-
+ exit:
 	mutex_unlock(&scsi_sense_cache_mutex);
 	return ret;
 }


