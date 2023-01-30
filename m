Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 353B56812AC
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:23:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237543AbjA3OXv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:23:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236853AbjA3OXe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:23:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C1CE2330B
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:22:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8209961036
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:21:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D57DC4339C;
        Mon, 30 Jan 2023 14:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088495;
        bh=C3T/drTwnYIHjZ+cx2ji8QJ/6jcOeY2ZhJ70qDXqITk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eqbt+HFt5DQfzma0VxJEK3u7F6BoH/lnWLJgPJbe47Q5sf/o5FMwGbXrEHMBFxMTu
         S86+GKYzTlUHUUZpg4S2HaAE2skl23DY6oRFYLyO+w7oePi/s87vqA20+K+6LrOb4U
         PaqP6XmLljNKcKRQhlgVwlp60zBQh5vtML3cEqf8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric Biggers <ebiggers@kernel.org>,
        Alexander Potapenko <glider@google.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 021/143] affs: initialize fsdata in affs_truncate()
Date:   Mon, 30 Jan 2023 14:51:18 +0100
Message-Id: <20230130134307.754541062@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134306.862721518@linuxfoundation.org>
References: <20230130134306.862721518@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Potapenko <glider@google.com>

[ Upstream commit eef034ac6690118c88f357b00e2b3239c9d8575d ]

When aops->write_begin() does not initialize fsdata, KMSAN may report
an error passing the latter to aops->write_end().

Fix this by unconditionally initializing fsdata.

Fixes: f2b6a16eb8f5 ("fs: affs convert to new aops")
Suggested-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Alexander Potapenko <glider@google.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/affs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/affs/file.c b/fs/affs/file.c
index d91b0133d95d..c3d89fa1bab7 100644
--- a/fs/affs/file.c
+++ b/fs/affs/file.c
@@ -879,7 +879,7 @@ affs_truncate(struct inode *inode)
 	if (inode->i_size > AFFS_I(inode)->mmu_private) {
 		struct address_space *mapping = inode->i_mapping;
 		struct page *page;
-		void *fsdata;
+		void *fsdata = NULL;
 		loff_t isize = inode->i_size;
 		int res;
 
-- 
2.39.0



