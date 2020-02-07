Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D80281555DC
	for <lists+stable@lfdr.de>; Fri,  7 Feb 2020 11:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727154AbgBGKgb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Feb 2020 05:36:31 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:59299 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727144AbgBGKga (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Feb 2020 05:36:30 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 7F89621FF1;
        Fri,  7 Feb 2020 05:36:29 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 07 Feb 2020 05:36:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=9T+dZn
        ZDga0UqpXYNh9JO9A44mWB7yfEUi4YjIVwCjY=; b=plslUx8p/behx1kmf+QfN1
        iSLpMRRTyls4zhVpzDzeJIhQFuffrO8UDST5+SQHAF1ex+eN2sdNUO5rFlQ0Yhv9
        Ws8pHOID/61fLxeYiR9EgMZfUOcpkNrUOYSOXxDImvrLS2fFSx4CC2BZ1t9gdo2l
        foeqiVvbzJBW0qkTtuYmhaD5jMKnKfNdKdQrG79c8LkWeIrO2500EpkQjK+sSYY5
        +IVg08EJA7PXkSH/tpu9VRBQUlzJYfn+d6+I4DM8Ueq2oj7ZYhiUl5VNIe6LngHe
        Y86i0ddSivwWA2LqiEfCnkh8LLxe3OcxWv1pCzahO1N6Oh5Cr8EtsLzb+8AQbzNw
        ==
X-ME-Sender: <xms:rT09XqL6We2-ZcW6Y0mkDYM8qGhKTFtwi5z_0Y4bb3aHP-rDFY4SHQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheehgddukecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinheplhgruhhntghhphgrugdrnhgvthenucfkphepkeefrdekiedrke
    elrddutdejnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhho
    mhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:rT09Xsw1Z9AbiC323QJfC0ZzJ5e2vnN-Q2vXz8hXWDGoysry89TKzg>
    <xmx:rT09Xmu8qd3uFoBzebtBGEuZJW4j8ZCxet7x3ox2vh3I3qdRDBVyiw>
    <xmx:rT09Xvoo7C9ZIUPpW1ILsUIlmhCCr68_zs8gUpgu9oeb5_RMbkByhg>
    <xmx:rT09XslYGGXeuBxxU1RSKpYsQ3IlBvzMzRPK_ipOuw6VODtNgOAFZg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1E64030600DC;
        Fri,  7 Feb 2020 05:36:28 -0500 (EST)
Subject: FAILED: patch "[PATCH] dm: fix potential for q->make_request_fn NULL pointer" failed to apply to 4.4-stable tree
To:     snitzer@redhat.com, stefan.bader@canonical.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 07 Feb 2020 11:36:18 +0100
Message-ID: <1581071778111239@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
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

