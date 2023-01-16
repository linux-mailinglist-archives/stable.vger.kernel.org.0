Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0E1966CD99
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:37:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234946AbjAPRhn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:37:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234928AbjAPRhJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:37:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20F8523D93
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 09:13:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D01E7B8108E
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 17:13:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3532CC433D2;
        Mon, 16 Jan 2023 17:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673889226;
        bh=wBKxZmG349uxzszzewuZj5eTp7kBrI/4+z86tF8EWw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u44upGGaTHNBNALzvrxYtXb4+AvVkg0ALv2nrP+tInPy7mdscQ1W3H3aGqJLlvQ5t
         kFMyPiZH47Ijz0H1dwJRTAsoAmu7OLl9ZnzliuLNxHSz2H23aBechRi3ceKXFfKGo7
         fy65zZPDGqWBjI57urel4AddlLM8HUYaVm7SpVmk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pengfei Xu <pengfei.xu@intel.com>,
        Jan Kara <jack@suse.cz>, stable@kernel.org,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.14 305/338] ext4: avoid unaccounted block allocation when expanding inode
Date:   Mon, 16 Jan 2023 16:52:58 +0100
Message-Id: <20230116154834.403985650@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit 8994d11395f8165b3deca1971946f549f0822630 upstream.

When expanding inode space in ext4_expand_extra_isize_ea() we may need
to allocate external xattr block. If quota is not initialized for the
inode, the block allocation will not be accounted into quota usage. Make
sure the quota is initialized before we try to expand inode space.

Reported-by: Pengfei Xu <pengfei.xu@intel.com>
Link: https://lore.kernel.org/all/Y5BT+k6xWqthZc1P@xpf.sh.intel.com
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20221207115937.26601-2-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inode.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5905,6 +5905,14 @@ static int __ext4_expand_extra_isize(str
 		return 0;
 	}
 
+	/*
+	 * We may need to allocate external xattr block so we need quotas
+	 * initialized. Here we can be called with various locks held so we
+	 * cannot affort to initialize quotas ourselves. So just bail.
+	 */
+	if (dquot_initialize_needed(inode))
+		return -EAGAIN;
+
 	/* try to expand with EAs present */
 	error = ext4_expand_extra_isize_ea(inode, new_extra_isize,
 					   raw_inode, handle);


