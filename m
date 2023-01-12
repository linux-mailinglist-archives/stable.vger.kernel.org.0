Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2EB76677CF
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:49:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239823AbjALOtP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:49:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239961AbjALOsM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:48:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D05E2DDA
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:35:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A3E1B81E7A
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:35:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D4E0C433EF;
        Thu, 12 Jan 2023 14:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673534146;
        bh=3LKE1+L4KQdYW9+UssbXJ0COk/Jp3dr7WlnA39esg4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R1LUfHR9nrdj81lJX3CLihevJ3q9gfrapnEmk4uPHKxzRJSjq9IiRyIhgqo0KSQtO
         dE3mXFngxFGl9ZjxuPTUPmTuW7yZAn8a5BXhwSDsOx6IsIXtf/aUMceIkdATJewNmQ
         veTO/0WtVHWexBb58/Dktn0z9V5TuTGlO788NL2Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric Biggers <ebiggers@kernel.org>,
        syzbot+9767be679ef5016b6082@syzkaller.appspotmail.com,
        Alexander Potapenko <glider@google.com>,
        Eric Biggers <ebiggers@google.com>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 711/783] fs: ext4: initialize fsdata in pagecache_write()
Date:   Thu, 12 Jan 2023 14:57:07 +0100
Message-Id: <20230112135557.334651203@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

[ Upstream commit 956510c0c7439e90b8103aaeaf4da92878c622f0 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/verity.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/verity.c b/fs/ext4/verity.c
index 130070ec491b..e3019f920222 100644
--- a/fs/ext4/verity.c
+++ b/fs/ext4/verity.c
@@ -79,7 +79,7 @@ static int pagecache_write(struct inode *inode, const void *buf, size_t count,
 		size_t n = min_t(size_t, count,
 				 PAGE_SIZE - offset_in_page(pos));
 		struct page *page;
-		void *fsdata;
+		void *fsdata = NULL;
 		int res;
 
 		res = pagecache_write_begin(NULL, inode->i_mapping, pos, n, 0,
-- 
2.35.1



