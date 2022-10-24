Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5AD60A841
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235214AbiJXNDi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234817AbiJXNB4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:01:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA76629833;
        Mon, 24 Oct 2022 05:19:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE5ED61017;
        Mon, 24 Oct 2022 12:18:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFDFAC433D6;
        Mon, 24 Oct 2022 12:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613916;
        bh=27Hf3qBM+M05HOpUtzlV8FDc4ctAK6wPLlqXLlJMDOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iRYPsgh/K92UUj0KtVoE+ysdmSRyORJFzYD7Gz6wcharhkb8lqQSkvl9USIqsBiJ8
         IYZRIezMOqeUgSI3gFPC6j6dMWCMFNwlb6c1ee56lckEN1p0AyGHHqCp9wWYRBLRY6
         /AOusEVU7Z4K/5+GfE+RK9prTLs7LCmYn8GP06dQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Lukas Czerner <lczerner@redhat.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.10 063/390] ext4: fix check for block being out of directory size
Date:   Mon, 24 Oct 2022 13:27:40 +0200
Message-Id: <20221024113025.307918321@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -125,7 +125,7 @@ static struct buffer_head *__ext4_read_d
 	struct ext4_dir_entry *dirent;
 	int is_dx_block = 0;
 
-	if (block >= inode->i_size) {
+	if (block >= inode->i_size >> inode->i_blkbits) {
 		ext4_error_inode(inode, func, line, block,
 		       "Attempting to read directory block (%u) that is past i_size (%llu)",
 		       block, inode->i_size);


