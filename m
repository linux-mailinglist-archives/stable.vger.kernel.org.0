Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 646916B44BC
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:27:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232286AbjCJO1r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:27:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232298AbjCJO13 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:27:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28080118BF7
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:26:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0D54B822BD
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:26:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C3EC433D2;
        Fri, 10 Mar 2023 14:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458360;
        bh=9YnypwYQpihCst+WgcQEOLTet+xEiqZhBLwSAQ5gzFQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sBGC89D5yX116/uzGlXYbAIn8WxvCMYnorQ/TzK43SMaExrpgiRdOO8nFVmIT9XBt
         MkpafElqpYugOAUwPT3Si/OUcf/I+iMHTvNDI8cH3zNyx8CR+/9cJaifvCSj4QADeE
         XYpiWkZAlm2DE7963c55nLMz8IHO3AUqlBrY1RaQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Eric Biggers <ebiggers@google.com>, Tejun Heo <tj@kernel.org>,
        Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 4.19 251/252] f2fs: fix cgroup writeback accounting with fs-layer encryption
Date:   Fri, 10 Mar 2023 14:40:21 +0100
Message-Id: <20230310133727.239052985@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 844545c51a5b2a524b22a2fe9d0b353b827d24b4 upstream.

When writing a page from an encrypted file that is using
filesystem-layer encryption (not inline encryption), f2fs encrypts the
pagecache page into a bounce page, then writes the bounce page.

It also passes the bounce page to wbc_account_cgroup_owner().  That's
incorrect, because the bounce page is a newly allocated temporary page
that doesn't have the memory cgroup of the original pagecache page.
This makes wbc_account_cgroup_owner() not account the I/O to the owner
of the pagecache page as it should.

Fix this by always passing the pagecache page to
wbc_account_cgroup_owner().

Fixes: 578c647879f7 ("f2fs: implement cgroup writeback support")
Cc: stable@vger.kernel.org
Reported-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Acked-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/data.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -464,7 +464,7 @@ int f2fs_submit_page_bio(struct f2fs_io_
 	}
 
 	if (fio->io_wbc && !is_read_io(fio->op))
-		wbc_account_io(fio->io_wbc, page, PAGE_SIZE);
+		wbc_account_io(fio->io_wbc, fio->page, PAGE_SIZE);
 
 	bio_set_op_attrs(bio, fio->op, fio->op_flags);
 
@@ -533,7 +533,7 @@ alloc_new:
 	}
 
 	if (fio->io_wbc)
-		wbc_account_io(fio->io_wbc, bio_page, PAGE_SIZE);
+		wbc_account_io(fio->io_wbc, fio->page, PAGE_SIZE);
 
 	io->last_block_in_bio = fio->new_blkaddr;
 	f2fs_trace_ios(fio, 0);


