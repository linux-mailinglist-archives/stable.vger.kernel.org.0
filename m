Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0689156FA31
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbiGKJPD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:15:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231600AbiGKJOZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:14:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5484A22BE3;
        Mon, 11 Jul 2022 02:10:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0AD0B80E76;
        Mon, 11 Jul 2022 09:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEDBCC34115;
        Mon, 11 Jul 2022 09:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530619;
        bh=qLea0AxIc99SW/1s9HO6AXWcrtBAjyvRjPO0jHRNnEE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tEBduIbnBQGceKQa4T7zK5Mng1h0AvxSSWtbVcw9iaTDcmlStBZZNqGXRZgCJbCpX
         ePFDz6Pcv+sDGy/leHGQaimiKecSFHU6oCG0o11ln581QlVUwKyajwb+7wkEYVZjeC
         mDD1TBvoO91M/EMqyXTyXx4fxwblzGkUN6xit3CI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Kuniyuki Iwashima <kuniyu@amazon.com>
Subject: [PATCH 5.4 18/38] xfs: remove incorrect ASSERT in xfs_rename
Date:   Mon, 11 Jul 2022 11:07:00 +0200
Message-Id: <20220711090539.270186245@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090538.722676354@linuxfoundation.org>
References: <20220711090538.722676354@linuxfoundation.org>
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
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_inode.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3232,7 +3232,6 @@ xfs_rename(
 	 * appropriately.
 	 */
 	if (flags & RENAME_WHITEOUT) {
-		ASSERT(!(flags & (RENAME_NOREPLACE | RENAME_EXCHANGE)));
 		error = xfs_rename_alloc_whiteout(target_dp, &wip);
 		if (error)
 			return error;


