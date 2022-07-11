Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6181656FDA1
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234070AbiGKJ6a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:58:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234226AbiGKJ6H (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:58:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA8BB3C8D1;
        Mon, 11 Jul 2022 02:27:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A0A861363;
        Mon, 11 Jul 2022 09:27:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB9FCC34115;
        Mon, 11 Jul 2022 09:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531626;
        bh=sdJokJh/mT6NTEEZR+84538Xzs9PvYlTM6kDBhenlis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tTWcjakxlatJtJ7KXYTSGOakj5TiV44VinyNGzYArj2mwEsz5KR2x2HEW08IDRJBv
         iYXqX0yjwKb/yPRqICKVtwwWRvL1EDrE/7ifMeJ0Y9LH0vCNU+oyldAuxuCOFgR2AP
         qKHWKzrjA56rAZc84YRfD/x6HM5gogAgvSy/9pgU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Ayushman Dutta <ayudutta@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>
Subject: [PATCH 5.15 171/230] xfs: remove incorrect ASSERT in xfs_rename
Date:   Mon, 11 Jul 2022 11:07:07 +0200
Message-Id: <20220711090608.911844588@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

commit e445976537ad139162980bee015b7364e5b64fff upstream.

This ASSERT in xfs_rename is a) incorrect, because
(RENAME_WHITEOUT|RENAME_NOREPLACE) is a valid combination, and
b) unnecessary, because actual invalid flag combinations are already
handled at the vfs level in do_renameat2() before we get called.
So, remove it.

Reported-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Fixes: 7dcf5c3e4527 ("xfs: add RENAME_WHITEOUT support")
Reported-by: Ayushman Dutta <ayudutta@amazon.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_inode.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3128,7 +3128,6 @@ xfs_rename(
 	 * appropriately.
 	 */
 	if (flags & RENAME_WHITEOUT) {
-		ASSERT(!(flags & (RENAME_NOREPLACE | RENAME_EXCHANGE)));
 		error = xfs_rename_alloc_whiteout(mnt_userns, target_dp, &wip);
 		if (error)
 			return error;


