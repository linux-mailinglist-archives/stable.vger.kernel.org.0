Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCFEA5EA30E
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234336AbiIZLTe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237444AbiIZLSM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:18:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B7EA65673;
        Mon, 26 Sep 2022 03:38:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EFDA9B80957;
        Mon, 26 Sep 2022 10:38:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CF4AC433D7;
        Mon, 26 Sep 2022 10:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188685;
        bh=CME+exr/BiZwbfHj3Ck2tTxmIjQN46Qf/f3jVKEcMmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P0o8iwTTGJkFwYrwyYqw0rwz1VoSfXCQrCt04fte5r5dHLoJD3J7PQzmaLBAJ+DNp
         w3qBqQt1rIfnKnxGUe7TtjxTLfEQgY5hq61NkzXzFneH/mZaHfSChf06kXSuMD/dbc
         yf/VkO3imFlHg2Jqa35vk++UkhnOAJHOcjQzrPPo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 056/148] xfs: fix xfs_ifree() error handling to not leak perag ref
Date:   Mon, 26 Sep 2022 12:11:30 +0200
Message-Id: <20220926100758.133194611@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100756.074519146@linuxfoundation.org>
References: <20220926100756.074519146@linuxfoundation.org>
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

From: Brian Foster <bfoster@redhat.com>

[ Upstream commit 6f5097e3367a7c0751e165e4c15bc30511a4ba38 ]

For some reason commit 9a5280b312e2e ("xfs: reorder iunlink remove
operation in xfs_ifree") replaced a jump to the exit path in the
event of an xfs_difree() error with a direct return, which skips
releasing the perag reference acquired at the top of the function.
Restore the original code to drop the reference on error.

Fixes: 9a5280b312e2e ("xfs: reorder iunlink remove operation in xfs_ifree")
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2634,7 +2634,7 @@ xfs_ifree(
 	 */
 	error = xfs_difree(tp, pag, ip->i_ino, &xic);
 	if (error)
-		return error;
+		goto out;
 
 	error = xfs_iunlink_remove(tp, pag, ip);
 	if (error)


