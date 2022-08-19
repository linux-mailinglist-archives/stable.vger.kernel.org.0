Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B30059A407
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353926AbiHSQqp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354103AbiHSQpu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:45:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31E6F12A558;
        Fri, 19 Aug 2022 09:11:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E644B8281C;
        Fri, 19 Aug 2022 16:11:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE8E4C433C1;
        Fri, 19 Aug 2022 16:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925516;
        bh=GMnZ7tRDjtB+T0jWJGzxZ1tR9+AlNiyqah4xgPle83g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ctvcKVJHzUUV9rOzPge1oqrHoFNw8yO5juPBstZtS40fNvRvkS6i+oFXPizqaMAsD
         s2epNZ2ysJnlk3zlQlaZmAdH9jZmheFiFCcbvs39ubnUcpe8Af7L5hB2RMcg2RHrrU
         F+5IMUnkveHXWL25vlTpLMuUBlChxO9JAjw4OhXY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>,
        Andreas Dilger <adilger@dilger.ca>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.10 516/545] ext4: check if directory block is within i_size
Date:   Fri, 19 Aug 2022 17:44:46 +0200
Message-Id: <20220819153852.607421846@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Czerner <lczerner@redhat.com>

commit 65f8ea4cd57dbd46ea13b41dc8bac03176b04233 upstream.

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

Addresses Red-Hat-Bugzilla: #2070205
CVE: CVE-2022-1184
Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Cc: stable@vger.kernel.org
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Link: https://lore.kernel.org/r/20220704142721.157985-1-lczerner@redhat.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/namei.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -109,6 +109,13 @@ static struct buffer_head *__ext4_read_d
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


