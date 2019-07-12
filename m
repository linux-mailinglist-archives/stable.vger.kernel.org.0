Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF1C663AA
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 04:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728861AbfGLCIb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jul 2019 22:08:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54924 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726587AbfGLCIb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jul 2019 22:08:31 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E246B81F10;
        Fri, 12 Jul 2019 02:08:30 +0000 (UTC)
Received: from localhost (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 704C7600CD;
        Fri, 12 Jul 2019 02:08:27 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        Ming Lei <ming.lei@redhat.com>,
        Stable <stable@vger.kernel.org>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.com>,
        "Ewan D . Milne" <emilne@redhat.com>
Subject: [PATCH V2] scsi: fix race on creating sense cache
Date:   Fri, 12 Jul 2019 10:08:19 +0800
Message-Id: <20190712020819.31935-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Fri, 12 Jul 2019 02:08:31 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When scsi_init_sense_cache(host) is called concurrently from different
hosts, each code path may see that the cache isn't created, then try
to create a new one, then the created sense cache may be overrided and
leaked.

Fixes the issue by moving 'mutex_lock(&scsi_sense_cache_mutex)' before
scsi_select_sense_cache().

Fixes: 0a6ac4ee7c21 ("scsi: respect unchecked_isa_dma for blk-mq")
Cc: Stable <stable@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/scsi_lib.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index e07a376a8c38..7493680ec104 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -72,11 +72,11 @@ int scsi_init_sense_cache(struct Scsi_Host *shost)
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
@@ -92,7 +92,7 @@ int scsi_init_sense_cache(struct Scsi_Host *shost)
 		if (!scsi_sense_cache)
 			ret = -ENOMEM;
 	}
-
+ exit:
 	mutex_unlock(&scsi_sense_cache_mutex);
 	return ret;
 }
-- 
2.20.1

