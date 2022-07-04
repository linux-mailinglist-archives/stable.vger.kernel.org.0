Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CBD7565897
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 16:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231376AbiGDO13 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 10:27:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234447AbiGDO12 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 10:27:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9FE4526DB
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 07:27:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656944846;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=k0T06GB1MQdWsPIbV+tDG0joRPQOsrGTew1Pd6ZBbVo=;
        b=bmAu06yK6Lq865gYxSL81rg9lBBAFAchk5A2BGw7F4xiOIlNEg6SXnrVQc/0nr/SpHsOBe
        tcuZD9z6PjQXW2XkG7WlP/PzLP6I/kNhk/V6s4Pv1Pipn7KHNb4MRaEpw+npVs1USt/9Ty
        3WVkjrLeaBow0z1VNUoRffdGa22CLDI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-507-fO65GEviPXe_73qVf4VCag-1; Mon, 04 Jul 2022 10:27:23 -0400
X-MC-Unique: fO65GEviPXe_73qVf4VCag-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4678E811E76;
        Mon,  4 Jul 2022 14:27:23 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.193.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8734F492CA3;
        Mon,  4 Jul 2022 14:27:22 +0000 (UTC)
From:   Lukas Czerner <lczerner@redhat.com>
To:     linux-ext4@vger.kernel.org
Cc:     tytso@mit.edu, stable@vger.kernel.org
Subject: [PATCH 1/2] ext4: check if directory block is within i_size
Date:   Mon,  4 Jul 2022 16:27:20 +0200
Message-Id: <20220704142721.157985-1-lczerner@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently ext4 directory handling code implicitly assumes that the
directory blocks are always within the i_size. In fact ext4_append()
will attempt to allocate next directory block based solely on i_size and
the i_size is then appropriately increased after a successful
allocation.

However, for this to work it requires i_size to be correct. If, for any
reason, the directory inode i_size is corrupted in a way that the
directory tree refers to a valid directory block past i_size, we could
end up corrupting parts of the directory tree structure by overwriting
already used directory blocks when modifying the directory.

Fix it by catching the corruption early in __ext4_read_dirblock().

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Addresses Red-Hat-Bugzilla: #2070205
Cc: stable@vger.kernel.org
---
 fs/ext4/namei.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index db4ba99d1ceb..cf460aa4f81d 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -110,6 +110,13 @@ static struct buffer_head *__ext4_read_dirblock(struct inode *inode,
 	struct ext4_dir_entry *dirent;
 	int is_dx_block = 0;
 
+	if (block >= inode->i_size) {
+		ext4_error_inode(inode, func, line, block,
+		       "Attempting to read directory block (%u) that is past i_size (%llu)",
+		       block, inode->i_size);
+		return ERR_PTR(-EFSCORRUPTED);
+	}
+
 	if (ext4_simulate_fail(inode->i_sb, EXT4_SIM_DIRBLOCK_EIO))
 		bh = ERR_PTR(-EIO);
 	else
-- 
2.35.3

