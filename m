Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A73D79439
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727206AbfG2T3T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:29:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:42006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727721AbfG2T3T (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:29:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAE30217D7;
        Mon, 29 Jul 2019 19:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564428558;
        bh=GFBXUdjCkqdWSyja6Renha4vSWYo1fMMNG5jLNDPuTA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iWDrhbig7bKmbb0yPMBKFlnYBVBEvvl76TkkSKmZqd+esdf96ikmq9/hAJFSMbIiy
         W1QzyNLLd/JFWyhn4ngKHz7EO0qnUV2u3uZbJzIBccqkCjKE4VU4eEct2803n5c1fT
         HLu36S2uajVhiSKVu0AovfP7TfMMoQPUOedoVnQ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.com>,
        "Ewan D. Milne" <emilne@redhat.com>,
        Ming Lei <ming.lei@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.14 115/293] scsi: core: Fix race on creating sense cache
Date:   Mon, 29 Jul 2019 21:20:06 +0200
Message-Id: <20190729190833.421885040@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
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
@@ -90,7 +90,7 @@ int scsi_init_sense_cache(struct Scsi_Ho
 		if (!scsi_sense_cache)
 			ret = -ENOMEM;
 	}
-
+ exit:
 	mutex_unlock(&scsi_sense_cache_mutex);
 	return ret;
 }


