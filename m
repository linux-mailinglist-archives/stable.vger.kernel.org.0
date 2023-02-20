Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73D8969CD6B
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232367AbjBTNtN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:49:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232382AbjBTNtL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:49:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0709B1E1D8
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:48:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98A0060EAD
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:48:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A826EC433EF;
        Mon, 20 Feb 2023 13:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900938;
        bh=0zarprrUgmjw4Pj7zl6s1Dcz7DxV3nbexbDb9FdLe+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VZGEUae+gfmsG44Mz2KNID3hsAh/jFiNQlPd8W8fAC4yCNUzKfXAOGGYmOnfQivWF
         /KcytWetGp45eQGwQjNlMPhJxRDKYuPU3HaJ8YfqJlTz17yBQIepV0Itbdo/57u9Zb
         lHtGqRItzN7nes5tTe/ubcW6Y1PQaIEefFxUuuoI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, zlang@redhat.com,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 5.4 124/156] xfs: fix the forward progress assertion in xfs_iwalk_run_callbacks
Date:   Mon, 20 Feb 2023 14:36:08 +0100
Message-Id: <20230220133607.742380102@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
References: <20230220133602.515342638@linuxfoundation.org>
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

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit a5336d6bb2d02d0e9d4d3c8be04b80b8b68d56c8 upstream.

In commit 27c14b5daa82 we started tracking the last inode seen during an
inode walk to avoid infinite loops if a corrupt inobt record happens to
have a lower ir_startino than the record preceeding it.  Unfortunately,
the assertion trips over the case where there are completely empty inobt
records (which can happen quite easily on 64k page filesystems) because
we advance the tracking cursor without actually putting the empty record
into the processing buffer.  Fix the assert to allow for this case.

Reported-by: zlang@redhat.com
Fixes: 27c14b5daa82 ("xfs: ensure inobt record walks always make forward progress")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Zorro Lang <zlang@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_iwalk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -362,7 +362,7 @@ xfs_iwalk_run_callbacks(
 	/* Delete cursor but remember the last record we cached... */
 	xfs_iwalk_del_inobt(tp, curpp, agi_bpp, 0);
 	irec = &iwag->recs[iwag->nr_recs - 1];
-	ASSERT(next_agino == irec->ir_startino + XFS_INODES_PER_CHUNK);
+	ASSERT(next_agino >= irec->ir_startino + XFS_INODES_PER_CHUNK);
 
 	error = xfs_iwalk_ag_recs(iwag);
 	if (error)


