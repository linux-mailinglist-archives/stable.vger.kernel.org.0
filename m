Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8986044E4
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 14:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232926AbiJSMR5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 08:17:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232944AbiJSMRW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 08:17:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1DBA6051D;
        Wed, 19 Oct 2022 04:53:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B09EFB822EF;
        Wed, 19 Oct 2022 08:44:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D992C433D6;
        Wed, 19 Oct 2022 08:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169040;
        bh=mGqmo0S/cZ1DZJ0WQ/Bt9WjSLdXTjqMxohIkX6GdePo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=we71KixHcSMFLmA9PPV8btBkfZoVPANvwJW/jYFOqdtblhfmO9qQQnaZ2UHMzYwR/
         NLFLI+prnBCVY+DtmXuoAVCkQYa3gQKmj9HSVQQBBrXfAXx0+RoQAqb6eLagj5sI1f
         FRIrBmn7MOrX27jbTWCyJsFlc/NI06SJvrZkr8X4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Lukas Czerner <lczerner@redhat.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.0 138/862] ext4: fix check for block being out of directory size
Date:   Wed, 19 Oct 2022 10:23:45 +0200
Message-Id: <20221019083256.084935161@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit 61a1d87a324ad5e3ed27c6699dfc93218fcf3201 upstream.

The check in __ext4_read_dirblock() for block being outside of directory
size was wrong because it compared block number against directory size
in bytes. Fix it.

Fixes: 65f8ea4cd57d ("ext4: check if directory block is within i_size")
CVE: CVE-2022-1184
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Lukas Czerner <lczerner@redhat.com>
Link: https://lore.kernel.org/r/20220822114832.1482-1-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -126,7 +126,7 @@ static struct buffer_head *__ext4_read_d
 	struct ext4_dir_entry *dirent;
 	int is_dx_block = 0;
 
-	if (block >= inode->i_size) {
+	if (block >= inode->i_size >> inode->i_blkbits) {
 		ext4_error_inode(inode, func, line, block,
 		       "Attempting to read directory block (%u) that is past i_size (%llu)",
 		       block, inode->i_size);


