Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32B6E28B8FE
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390551AbgJLN4r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:56:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:48296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389425AbgJLNoE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:44:04 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D864820838;
        Mon, 12 Oct 2020 13:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510231;
        bh=6oJ223lUE7Q/unMQomk+APF9/Oh4iCmwYXc1Lf8CVmM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yJHn0tl8JNmKzlfpRLTQa4XKZAJbtQKySEa06dxprm54fhY/R98BiY3fUFiSZoqnH
         6aRCOa3TP8ReNql6fwOdIrvAgCsqsjFiYaBFYGdj+YwYwH6Do3uWi8aR5d0Abf55cs
         ImaSz5fDzhqUh3Pd73qdaSpdVdlrTbzLx8z1+Cns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Christoph Hellwig <hch@lst.de>,
        Stefan Haberland <sth@linux.ibm.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.8 011/124] partitions/ibm: fix non-DASD devices
Date:   Mon, 12 Oct 2020 15:30:15 +0200
Message-Id: <20201012133147.397962071@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 7370997d48520ad923e8eb4deb59ebf290396202 upstream.

Don't error out if the dasd_biodasdinfo symbol is not available.

Cc: stable@vger.kernel.org
Fixes: 26d7e28e3820 ("s390/dasd: remove ioctl_by_bdev calls")
Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Stefan Haberland <sth@linux.ibm.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/partitions/ibm.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/block/partitions/ibm.c
+++ b/block/partitions/ibm.c
@@ -305,8 +305,6 @@ int ibm_partition(struct parsed_partitio
 	if (!disk->fops->getgeo)
 		goto out_exit;
 	fn = symbol_get(dasd_biodasdinfo);
-	if (!fn)
-		goto out_exit;
 	blocksize = bdev_logical_block_size(bdev);
 	if (blocksize <= 0)
 		goto out_symbol;
@@ -326,7 +324,7 @@ int ibm_partition(struct parsed_partitio
 	geo->start = get_start_sect(bdev);
 	if (disk->fops->getgeo(bdev, geo))
 		goto out_freeall;
-	if (fn(disk, info)) {
+	if (!fn || fn(disk, info)) {
 		kfree(info);
 		info = NULL;
 	}
@@ -370,7 +368,8 @@ out_nolab:
 out_nogeo:
 	kfree(info);
 out_symbol:
-	symbol_put(dasd_biodasdinfo);
+	if (fn)
+		symbol_put(dasd_biodasdinfo);
 out_exit:
 	return res;
 }


