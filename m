Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92F47664A82
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:33:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234542AbjAJSdT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:33:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234635AbjAJScc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:32:32 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B4B918396
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:28:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 170ACCE18D1
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:28:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08341C433D2;
        Tue, 10 Jan 2023 18:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375292;
        bh=F8MtU1eoxuh5zPfD3IUNPi7HDU9HplHkb6kAhC7HvjE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d1TVTWEAAHcDbgbbDOrQQ8azzzOUtDSyuoG41wsiozalm0b3D5K418V6YE6sdRQxz
         JZ3JlHTC5Q4dWIW93Ee58PaamwS3LJf2jX09lUpa0EgLuwTXK5DjOwwHE1xbiYVYB2
         Se6tf+tVJeffnMjLdUeCkqkS2/P4uUgNWYu+HN9Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric Biggers <ebiggers@kernel.org>,
        syzbot+9767be679ef5016b6082@syzkaller.appspotmail.com,
        Alexander Potapenko <glider@google.com>,
        Eric Biggers <ebiggers@google.com>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 5.15 142/290] fs: ext4: initialize fsdata in pagecache_write()
Date:   Tue, 10 Jan 2023 19:03:54 +0100
Message-Id: <20230110180036.748145939@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
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

From: Alexander Potapenko <glider@google.com>

commit 956510c0c7439e90b8103aaeaf4da92878c622f0 upstream.

When aops->write_begin() does not initialize fsdata, KMSAN reports
an error passing the latter to aops->write_end().

Fix this by unconditionally initializing fsdata.

Cc: Eric Biggers <ebiggers@kernel.org>
Fixes: c93d8f885809 ("ext4: add basic fs-verity support")
Reported-by: syzbot+9767be679ef5016b6082@syzkaller.appspotmail.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Link: https://lore.kernel.org/r/20221121112134.407362-1-glider@google.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/verity.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/verity.c
+++ b/fs/ext4/verity.c
@@ -76,7 +76,7 @@ static int pagecache_write(struct inode
 		size_t n = min_t(size_t, count,
 				 PAGE_SIZE - offset_in_page(pos));
 		struct page *page;
-		void *fsdata;
+		void *fsdata = NULL;
 		int res;
 
 		res = pagecache_write_begin(NULL, inode->i_mapping, pos, n, 0,


