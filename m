Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD76373E3D
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390409AbfGXTms (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:42:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:44652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388240AbfGXTms (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:42:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDC9D21873;
        Wed, 24 Jul 2019 19:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997367;
        bh=+lOX/j8rmFpbITJk8sqtfGSUAEVYNwcy0C/BvfZ8d78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ND+TGw9FdWgICiAupfV3+EuZwFdOH1czUw+Uk/AoiglPEZdfUYRWx34x/PJh7iIC9
         b1qHq9XzvjwlSs5Y8hSpQgSkM890jgI4mhcVHsBJma1L6CYzhfr26//VpiXX7uc0Hp
         1IwCl6wQF6/U1syPqI7WqOX46QZjMNVI4G0xXLnI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zdenek Kabelac <zkabelac@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.2 412/413] dm thin metadata: check if in fail_io mode when setting needs_check
Date:   Wed, 24 Jul 2019 21:21:43 +0200
Message-Id: <20190724191803.972802548@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Snitzer <snitzer@redhat.com>

commit 54fa16ee532705985e6c946da455856f18f63ee1 upstream.

Check if in fail_io mode at start of dm_pool_metadata_set_needs_check().
Otherwise dm_pool_metadata_set_needs_check()'s superblock_lock() can
crash in dm_bm_write_lock() while accessing the block manager object
that was previously destroyed as part of a failed
dm_pool_abort_metadata() that ultimately set fail_io to begin with.

Also, update DMERR() message to more accurately describe
superblock_lock() failure.

Cc: stable@vger.kernel.org
Reported-by: Zdenek Kabelac <zkabelac@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-thin-metadata.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -2046,16 +2046,19 @@ int dm_pool_register_metadata_threshold(
 
 int dm_pool_metadata_set_needs_check(struct dm_pool_metadata *pmd)
 {
-	int r;
+	int r = -EINVAL;
 	struct dm_block *sblock;
 	struct thin_disk_superblock *disk_super;
 
 	pmd_write_lock(pmd);
+	if (pmd->fail_io)
+		goto out;
+
 	pmd->flags |= THIN_METADATA_NEEDS_CHECK_FLAG;
 
 	r = superblock_lock(pmd, &sblock);
 	if (r) {
-		DMERR("couldn't read superblock");
+		DMERR("couldn't lock superblock");
 		goto out;
 	}
 


