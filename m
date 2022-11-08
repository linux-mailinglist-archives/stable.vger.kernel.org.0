Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 543DA621398
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234732AbiKHNwC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:52:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234605AbiKHNvi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:51:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD6F665E4C
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:51:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CFAC61561
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:51:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69F71C433C1;
        Tue,  8 Nov 2022 13:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915496;
        bh=L6RSxyS58v6yYt6HfXv4poqGg9tYqqREq/83YoUmBEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VWiehHFTIBFuRv7rnvXCK46CjKkTVzrFNhopzGrEwCdjxrUncqLUmMc+VPOvmit9T
         ZGNpumuKmmBcpAI1CgFoVVnNvzXVN3M0Sp3VU+ZZdO1Tbfz8R30+lP7S1MPwZ1Lpu7
         b8M79a3/W1VbAOe8y139MaaSBr2A9FUzfcsXl5ZA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chuhong Yuan <hslester96@gmail.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 42/74] xfs: Add the missed xfs_perag_put() for xfs_ifree_cluster()
Date:   Tue,  8 Nov 2022 14:39:10 +0100
Message-Id: <20221108133335.453606651@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133333.659601604@linuxfoundation.org>
References: <20221108133333.659601604@linuxfoundation.org>
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

From: Chuhong Yuan <hslester96@gmail.com>

commit 8cc0072469723459dc6bd7beff81b2b3149f4cf4 upstream.

xfs_ifree_cluster() calls xfs_perag_get() at the beginning, but forgets to
call xfs_perag_put() in one failed path.
Add the missed function call to fix it.

Fixes: ce92464c180b ("xfs: make xfs_trans_get_buf return an error code")
Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_inode.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2592,8 +2592,10 @@ xfs_ifree_cluster(
 					mp->m_bsize * igeo->blocks_per_cluster,
 					XBF_UNMAPPED);
 
-		if (!bp)
+		if (!bp) {
+			xfs_perag_put(pag);
 			return -ENOMEM;
+		}
 
 		/*
 		 * This buffer may not have been correctly initialised as we


