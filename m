Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9851CAF66
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728483AbgEHMnq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:43:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:41588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728156AbgEHMnk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:43:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA7D121974;
        Fri,  8 May 2020 12:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941820;
        bh=1dRfvo3y1eTNxKbDkM0vF8Peuzsi+lmgYxwyqGR7jto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2uwjnrwgBBKe3j285/EgyD9uBSXyUJxDSDGGLMv5wTE/5uIkX+kQUFrf6MVpmV9KD
         CSxvBO6tYjcmBH4C7axUk5Si+2s/5wYIL9n+uGnGowweSb4ZnDXnMbztAYwe49fXXq
         KCGoo1IeOw6Fowd512MyU6jQLZlCsXidilh1NOs8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bart Van Assche <bart.vanassche@sandisk.com>,
        Hannes Reinecke <hare@suse.com>,
        Christoph Hellwig <hch@lst.de>,
        Andy Grover <agrover@redhat.com>,
        Sagi Grimberg <sagig@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 4.4 183/312] target: Fix a memory leak in target_dev_lba_map_store()
Date:   Fri,  8 May 2020 14:32:54 +0200
Message-Id: <20200508123137.353779595@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bart.vanassche@sandisk.com>

commit f0a8afecb29ad0005e7e946228a0ef5422058b85 upstream.

strsep() modifies its first argument. Make the pointer passed to kfree()
match the return value of kmalloc().

Fixes: 229d4f112fd6 (commit "target_core_alua: Referrals configfs integration")
Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Andy Grover <agrover@redhat.com>
Cc: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_configfs.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1980,14 +1980,14 @@ static ssize_t target_dev_lba_map_store(
 	struct se_device *dev = to_device(item);
 	struct t10_alua_lba_map *lba_map = NULL;
 	struct list_head lba_list;
-	char *map_entries, *ptr;
+	char *map_entries, *orig, *ptr;
 	char state;
 	int pg_num = -1, pg;
 	int ret = 0, num = 0, pg_id, alua_state;
 	unsigned long start_lba = -1, end_lba = -1;
 	unsigned long segment_size = -1, segment_mult = -1;
 
-	map_entries = kstrdup(page, GFP_KERNEL);
+	orig = map_entries = kstrdup(page, GFP_KERNEL);
 	if (!map_entries)
 		return -ENOMEM;
 
@@ -2085,7 +2085,7 @@ out:
 	} else
 		core_alua_set_lba_map(dev, &lba_list,
 				      segment_size, segment_mult);
-	kfree(map_entries);
+	kfree(orig);
 	return count;
 }
 


