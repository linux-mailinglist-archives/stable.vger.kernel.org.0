Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F85B5584BE
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232657AbiFWRtE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:49:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235163AbiFWRrg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:47:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C6FEA1483;
        Thu, 23 Jun 2022 10:11:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A20136159A;
        Thu, 23 Jun 2022 17:10:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DE6AC3411B;
        Thu, 23 Jun 2022 17:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004251;
        bh=bNnXXGIBtGG6oA1E2wBDwNptzVA6M58zY9cPK0/4WUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vLHRsHWAlEqqGIQ9Abh/UccDb5TN2ZknqWi5z/bjN1XJCxDD5nzf2pRcwQMCN5F5b
         UvGuHgbBvfi1vnZOMI0reIUz4gIkeZBxNYcsW7HKTb/SaaD77DBa+8EGmPubGl6Mhj
         vJZrvQzbCaZQOxfWHl9GG51Ks1uZJNsO+rWJZN98=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Ding Xiang <dingxiang@cmss.chinamobile.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.14 224/237] ext4: make variable "count" signed
Date:   Thu, 23 Jun 2022 18:44:18 +0200
Message-Id: <20220623164349.593653446@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.132308638@linuxfoundation.org>
References: <20220623164343.132308638@linuxfoundation.org>
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

From: Ding Xiang <dingxiang@cmss.chinamobile.com>

commit bc75a6eb856cb1507fa907bf6c1eda91b3fef52f upstream.

Since dx_make_map() may return -EFSCORRUPTED now, so change "count" to
be a signed integer so we can correctly check for an error code returned
by dx_make_map().

Fixes: 46c116b920eb ("ext4: verify dir block before splitting it")
Cc: stable@kernel.org
Signed-off-by: Ding Xiang <dingxiang@cmss.chinamobile.com>
Link: https://lore.kernel.org/r/20220530100047.537598-1-dingxiang@cmss.chinamobile.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/namei.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1724,7 +1724,8 @@ static struct ext4_dir_entry_2 *do_split
 			struct dx_hash_info *hinfo)
 {
 	unsigned blocksize = dir->i_sb->s_blocksize;
-	unsigned count, continued;
+	unsigned continued;
+	int count;
 	struct buffer_head *bh2;
 	ext4_lblk_t newblock;
 	u32 hash2;


