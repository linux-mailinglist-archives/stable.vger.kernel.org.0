Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55F29599F37
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350018AbiHSPrr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 11:47:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350143AbiHSPrH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 11:47:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9418E6EF11;
        Fri, 19 Aug 2022 08:46:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F373EB82811;
        Fri, 19 Aug 2022 15:46:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 474A1C433D6;
        Fri, 19 Aug 2022 15:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924008;
        bh=inlHmPP1FVIWgYLUIgSMjotQGnUyGr0HMWijxVlg7Nk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J2XUdwwf5xyGARhx0uSwHzKRgIJaBkIB2D4PLmg8K8vIjerK37dfI9IIQZwxv+B4T
         c7072AxpXbGmKFiPK4Qv1UManUWVkZgyrl+65sdQOG7/eH7xe/eZWmcdZWQCTEbzvo
         zyYGGPp8LWaBWhWZp9JDBAI2cfMU7sgVrJ3QiapQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 5.10 025/545] xfs: fix I_DONTCACHE
Date:   Fri, 19 Aug 2022 17:36:35 +0200
Message-Id: <20220819153830.321012867@linuxfoundation.org>
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

From: Dave Chinner <dchinner@redhat.com>

commit f38a032b165d812b0ba8378a5cd237c0888ff65f upstream.

Yup, the VFS hoist broke it, and nobody noticed. Bulkstat workloads
make it clear that it doesn't work as it should.

Fixes: dae2f8ed7992 ("fs: Lift XFS_IDONTCACHE to the VFS layer")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_icache.c |    3 ++-
 fs/xfs/xfs_iops.c   |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -47,8 +47,9 @@ xfs_inode_alloc(
 		return NULL;
 	}
 
-	/* VFS doesn't initialise i_mode! */
+	/* VFS doesn't initialise i_mode or i_state! */
 	VFS_I(ip)->i_mode = 0;
+	VFS_I(ip)->i_state = 0;
 
 	XFS_STATS_INC(mp, vn_active);
 	ASSERT(atomic_read(&ip->i_pincount) == 0);
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1328,7 +1328,7 @@ xfs_setup_inode(
 	gfp_t			gfp_mask;
 
 	inode->i_ino = ip->i_ino;
-	inode->i_state = I_NEW;
+	inode->i_state |= I_NEW;
 
 	inode_sb_list_add(inode);
 	/* make the inode look hashed for the writeback code */


