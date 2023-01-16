Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0B8166CB9D
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:15:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234439AbjAPRPa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:15:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234431AbjAPRPE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:15:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3E142BED7
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:55:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78CF0B80E95
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:55:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC12C433D2;
        Mon, 16 Jan 2023 16:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888142;
        bh=ha/GU8zL0yqiZe7iwjBBmsiuYifTan2l3mkCgXcyR8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RFyNkyYu3Pcltbao7Tx6ocUPldWj5OPqPf5CdBd6f7evfiZ7MgzXpTHMw+YZ+7fNB
         Ad83D4ZF21lVgkAlvg2C7BHhXz6eLYGbBWryJ34hOTbbDzE1UiZ7285ASmCOYgawWs
         XYbGuDv1jNt1btIS2Wr9LQLFyFNDfl0aSNOFFNKQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pengfei Xu <pengfei.xu@intel.com>,
        Jan Kara <jack@suse.cz>, stable@kernel.org,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.19 416/521] ext4: avoid unaccounted block allocation when expanding inode
Date:   Mon, 16 Jan 2023 16:51:18 +0100
Message-Id: <20230116154905.724097015@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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
@@ -6041,6 +6041,14 @@ static int __ext4_expand_extra_isize(str
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


