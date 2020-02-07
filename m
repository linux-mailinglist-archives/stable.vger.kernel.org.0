Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA61D1555D6
	for <lists+stable@lfdr.de>; Fri,  7 Feb 2020 11:36:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbgBGKgU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Feb 2020 05:36:20 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:36379 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726819AbgBGKgU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Feb 2020 05:36:20 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 7BC8721F34;
        Fri,  7 Feb 2020 05:36:19 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 07 Feb 2020 05:36:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=wZZx4o
        4KS49FXLJli7ekyxcY4BKY8zWk6AmeakOtE3I=; b=uPd1zw1psDecVeen6AscsA
        Jn5QwgckmySTC6CIszxJw8zYEgleqTMsmyy+Y9A1bt4P8i/i1xcp1YvF77kPsLKN
        iYW6VstHLWTXswIV9kLKTC5GNrowHW+0Kyx74t3mbSxThjQNjy0C4q6r1LazZLqn
        ntXIBizqZiSLT4TT9zXD9WHh9DmbPYlQ7JDKOBlVaPzZh610Nchfa4P+1UxNxEU8
        oZ7wpgo9m9C4GXHYK9XDbc0ERIbdMe9Kv3GN7A+KClFkqsowUQSiNnBJZqcmHZli
        XT+x7E9lCdVbZ5B7MWuB+vArtHbmC2AJVbO8swu6GxrdoUEels+jKkwN2FvK1ROQ
        ==
X-ME-Sender: <xms:oz09XognHfWxQ5PTab5tVLNWaVP2tinq8gFWsfqrDkitLQo_pp-aYA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheehgddukecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinheplhgruhhntghhphgrugdrnhgvthenucfkphepkeefrdekiedrke
    elrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhho
    mhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:oz09XggqZK6j-CI-GClvD1te3Z_nz0_OuGcaNNVoNsKiCLmQ9SuhDw>
    <xmx:oz09Xj7UFkq1hlwpbKLWZHksK733yZLVarwTt5z14PkYiKJWveBxvg>
    <xmx:oz09Xl9zR8SeU0quhJUh4nShCqv79ZBELJwSC9ZIW2rQxwqexrT-6g>
    <xmx:oz09XqeLaHFrh_-xRzNIqURLzfR8XRgC_V1w-CFp3pU2yP4RGjUjzg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0F1393280062;
        Fri,  7 Feb 2020 05:36:18 -0500 (EST)
Subject: FAILED: patch "[PATCH] dm: fix potential for q->make_request_fn NULL pointer" failed to apply to 4.9-stable tree
To:     snitzer@redhat.com, stefan.bader@canonical.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 07 Feb 2020 11:36:17 +0100
Message-ID: <158107177723164@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 47ace7e012b9f7ad71d43ac9063d335ea3d6820b Mon Sep 17 00:00:00 2001
From: Mike Snitzer <snitzer@redhat.com>
Date: Mon, 27 Jan 2020 14:07:23 -0500
Subject: [PATCH] dm: fix potential for q->make_request_fn NULL pointer

Move blk_queue_make_request() to dm.c:alloc_dev() so that
q->make_request_fn is never NULL during the lifetime of a DM device
(even one that is created without a DM table).

Otherwise generic_make_request() will crash simply by doing:
  dmsetup create -n test
  mount /dev/dm-N /mnt

While at it, move ->congested_data initialization out of
dm.c:alloc_dev() and into the bio-based specific init method.

Reported-by: Stefan Bader <stefan.bader@canonical.com>
BugLink: https://bugs.launchpad.net/bugs/1860231
Fixes: ff36ab34583a ("dm: remove request-based logic from make_request_fn wrapper")
Depends-on: c12c9a3c3860c ("dm: various cleanups to md->queue initialization code")
Cc: stable@vger.kernel.org
Signed-off-by: Mike Snitzer <snitzer@redhat.com>

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index e8f9661a10a1..b89f07ee2eff 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1859,6 +1859,7 @@ static void dm_init_normal_md_queue(struct mapped_device *md)
 	/*
 	 * Initialize aspects of queue that aren't relevant for blk-mq
 	 */
+	md->queue->backing_dev_info->congested_data = md;
 	md->queue->backing_dev_info->congested_fn = dm_any_congested;
 }
 
@@ -1949,7 +1950,12 @@ static struct mapped_device *alloc_dev(int minor)
 	if (!md->queue)
 		goto bad;
 	md->queue->queuedata = md;
-	md->queue->backing_dev_info->congested_data = md;
+	/*
+	 * default to bio-based required ->make_request_fn until DM
+	 * table is loaded and md->type established. If request-based
+	 * table is loaded: blk-mq will override accordingly.
+	 */
+	blk_queue_make_request(md->queue, dm_make_request);
 
 	md->disk = alloc_disk_node(1, md->numa_node_id);
 	if (!md->disk)
@@ -2264,7 +2270,6 @@ int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t)
 	case DM_TYPE_DAX_BIO_BASED:
 	case DM_TYPE_NVME_BIO_BASED:
 		dm_init_normal_md_queue(md);
-		blk_queue_make_request(md->queue, dm_make_request);
 		break;
 	case DM_TYPE_NONE:
 		WARN_ON_ONCE(true);

