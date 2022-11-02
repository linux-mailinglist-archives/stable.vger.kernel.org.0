Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98E206159FF
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbiKBDWv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230500AbiKBDWa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:22:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59D3626106
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:22:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9B6B617CB
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:22:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86D66C433D6;
        Wed,  2 Nov 2022 03:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667359338;
        bh=TduVsrTV8c+1EYQixNCG5YRaqqS1JFu/7n8YVoT4xx0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MxpFlgCvD4q6p3O5wM+MQLfv5WjTEa/Pq2TAaD7PddiTyTJ0kHjbRRwXL2z+BAWmG
         1QnDXfn/hWtB/PhCKsEQPgJiIY2er5wQgI36EPwwkM3pXs9/ZOtGPeHjPyhRllN/S+
         uzEOrGO5WiDUm+jMkZUNNPTqdvHCqrtBVMiqW3ps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 23/64] xfs: finish dfops on every insert range shift iteration
Date:   Wed,  2 Nov 2022 03:33:49 +0100
Message-Id: <20221102022052.558387236@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022051.821538553@linuxfoundation.org>
References: <20221102022051.821538553@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chandan Babu R <chandan.babu@oracle.com>

From: Brian Foster <bfoster@redhat.com>

commit 9c516e0e4554e8f26ab73d46cbc789d7d8db664d upstream.

The recent change to make insert range an atomic operation used the
incorrect transaction rolling mechanism. The explicit transaction
roll does not finish deferred operations. This means that intents
for rmapbt updates caused by extent shifts are not logged until the
final transaction commits. Thus if a crash occurs during an insert
range, log recovery might leave the rmapbt in an inconsistent state.
This was discovered by repeated runs of generic/455.

Update insert range to finish dfops on every shift iteration. This
is similar to collapse range and ensures that intents are logged
with the transactions that make associated changes.

Fixes: dd87f87d87fa ("xfs: rework insert range into an atomic operation")
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_bmap_util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1340,7 +1340,7 @@ xfs_insert_file_space(
 		goto out_trans_cancel;
 
 	do {
-		error = xfs_trans_roll_inode(&tp, ip);
+		error = xfs_defer_finish(&tp);
 		if (error)
 			goto out_trans_cancel;
 


