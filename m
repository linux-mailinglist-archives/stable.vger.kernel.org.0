Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0325E65D816
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239604AbjADQK6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:10:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239986AbjADQKL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:10:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 834613C388
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:10:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 212EA6179A
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:10:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D277C433F1;
        Wed,  4 Jan 2023 16:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672848599;
        bh=f5oEEkB+j5jHBRMu6rRFXvjyC99Tc31Ra3JUcwmi/sc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OcZXlLV0tZR5V8LS/4PA2fiQSq1/nvws38mUnsv7StnROJECeCbDw6CZoV8+uT9oo
         HEAcFBmmykmix9TxF6130rUeXCj3DeUe5YFYjIgmjcJAxYkxPULUNelUU31uPGA1Dd
         IACB/3jFHOGyytBGOxexEm8X5Q54Z1y/NxbBi9K0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Al Viro <viro@zeniv.linux.org.uk>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 6.1 035/207] ext2: unbugger ext2_empty_dir()
Date:   Wed,  4 Jan 2023 17:04:53 +0100
Message-Id: <20230104160513.024565982@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
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

From: Al Viro <viro@zeniv.linux.org.uk>

commit 27e714c007e4ad01837bf0fac5c11913a38d7695 upstream.

In 27cfa258951a "ext2: fix fs corruption when trying to remove
a non-empty directory with IO error" a funny thing has happened:

-               page = ext2_get_page(inode, i, dir_has_error, &page_addr);
+               page = ext2_get_page(inode, i, 0, &page_addr);

 -               if (IS_ERR(page)) {
 -                       dir_has_error = 1;
 -                       continue;
 -               }
 +               if (IS_ERR(page))
 +                       goto not_empty;

And at not_empty: we hit ext2_put_page(page, page_addr), which does
put_page(page).  Which, unless I'm very mistaken, should oops
immediately when given ERR_PTR(-E...) as page.

OK, shit happens, insufficiently tested patches included.  But when
commit in question describes the fault-injection test that exercised
that particular failure exit...

Ow.

CC: stable@vger.kernel.org
Fixes: 27cfa258951a ("ext2: fix fs corruption when trying to remove a non-empty directory with IO error")
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext2/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -679,7 +679,7 @@ int ext2_empty_dir (struct inode * inode
 		page = ext2_get_page(inode, i, 0, &page_addr);
 
 		if (IS_ERR(page))
-			goto not_empty;
+			return 0;
 
 		kaddr = page_addr;
 		de = (ext2_dirent *)kaddr;


