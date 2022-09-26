Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC115EA160
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236523AbiIZKum (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:50:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236662AbiIZKs4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:48:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E64D357567;
        Mon, 26 Sep 2022 03:26:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29A6D60B2F;
        Mon, 26 Sep 2022 10:26:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3645FC433C1;
        Mon, 26 Sep 2022 10:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187973;
        bh=zwI7lY0f1SukIEKLWB1CYEkkrvnwk5+B3cYkOhMIKvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vmTzlGAoWUjaQeqBS5LrrjpDtaR++MskhTLwl7hks0KTVEmKZwhOCIjZMTF7qumGC
         S9a4+z9nPsrfic3TthDi3/BMwX9ON12qisvKie2yq7gdrshzxilbF9UqnQBY0TFfyF
         XbkiPTn6gOC6B8hk0xURA8n0YYzdh/uO31vnuONQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 105/120] xfs: slightly tweak an assert in xfs_fs_map_blocks
Date:   Mon, 26 Sep 2022 12:12:18 +0200
Message-Id: <20220926100754.814350434@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100750.519221159@linuxfoundation.org>
References: <20220926100750.519221159@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 88cdb7147b21b2d8b4bd3f3d95ce0bffd73e1ac3 upstream.

We should never see delalloc blocks for a pNFS layout, write or not.
Adjust the assert to check for that.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_pnfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -147,11 +147,11 @@ xfs_fs_map_blocks(
 	if (error)
 		goto out_unlock;
 
+	ASSERT(!nimaps || imap.br_startblock != DELAYSTARTBLOCK);
+
 	if (write) {
 		enum xfs_prealloc_flags	flags = 0;
 
-		ASSERT(imap.br_startblock != DELAYSTARTBLOCK);
-
 		if (!nimaps || imap.br_startblock == HOLESTARTBLOCK) {
 			/*
 			 * xfs_iomap_write_direct() expects to take ownership of


