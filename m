Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BACA460419C
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbiJSKqo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230507AbiJSKom (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:44:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C9ADA2879;
        Wed, 19 Oct 2022 03:21:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D470B8231F;
        Wed, 19 Oct 2022 08:47:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE97C433D6;
        Wed, 19 Oct 2022 08:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169260;
        bh=93Mwl/CNPEa8olUJJ5MXG4cAm7nEoQMxsfLzscJcT+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bKNzwgB9bCRUdOtwTy96tCLtjBX3LXNlYdrQQZbyjmphOQAXyOhL5csTS7SjiruQJ
         MAfB0WTZdKFVbFYNke/FL4UW7nQ/voOt9Vu6rh4Y4FkJAzwxJQtPgtGZi2kT0jxjuO
         uFlJaECiKSeVW5BN1QS1EK+ca3yQYi/Srhrseuqs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+f966c13b1b4fc0403b19@syzkaller.appspotmail.com,
        Yue Hu <huyue2@coolpad.com>,
        Gao Xiang <hsiangkao@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 212/862] erofs: fix order >= MAX_ORDER warning due to crafted negative i_size
Date:   Wed, 19 Oct 2022 10:24:59 +0200
Message-Id: <20221019083259.396157131@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit 1dd73601a1cba37a0ed5f89a8662c90191df5873 ]

As syzbot reported [1], the root cause is that i_size field is a
signed type, and negative i_size is also less than EROFS_BLKSIZ.
As a consequence, it's handled as fast symlink unexpectedly.

Let's fall back to the generic path to deal with such unusual i_size.

[1] https://lore.kernel.org/r/000000000000ac8efa05e7feaa1f@google.com

Reported-by: syzbot+f966c13b1b4fc0403b19@syzkaller.appspotmail.com
Fixes: 431339ba9042 ("staging: erofs: add inode operations")
Reviewed-by: Yue Hu <huyue2@coolpad.com>
Link: https://lore.kernel.org/r/20220909023948.28925-1-hsiangkao@linux.alibaba.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/erofs/inode.c b/fs/erofs/inode.c
index 95a403720e8c..16cf9a283557 100644
--- a/fs/erofs/inode.c
+++ b/fs/erofs/inode.c
@@ -214,7 +214,7 @@ static int erofs_fill_symlink(struct inode *inode, void *kaddr,
 
 	/* if it cannot be handled with fast symlink scheme */
 	if (vi->datalayout != EROFS_INODE_FLAT_INLINE ||
-	    inode->i_size >= EROFS_BLKSIZ) {
+	    inode->i_size >= EROFS_BLKSIZ || inode->i_size < 0) {
 		inode->i_op = &erofs_symlink_iops;
 		return 0;
 	}
-- 
2.35.1



