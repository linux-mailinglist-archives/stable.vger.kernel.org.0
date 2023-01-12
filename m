Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E76686677CE
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:49:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239743AbjALOtN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:49:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239943AbjALOsK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:48:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F04081080
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:35:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AAF7AB81E79
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:35:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC0D1C433EF;
        Thu, 12 Jan 2023 14:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673534143;
        bh=4wi3KPwd9tikusbCykhfFXGqK7n/QRAG4eEKKh0Lg0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fuPfvQlHdo5tIoq2tTZBG3hIrRxSw07pIQGpZ82/ioRqu3sHckpL9Uyc0HZ6cs/Iv
         defDhs+BTa1QJ1nmceHF/jD3e8N716ucY4TCI1VDoWbqxdn0rQAgeHJHYH9QI+vLiF
         p4UHAkEDmUtf/v0X5RAmi6ZYPXeAhURtdKlZ8J2w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 710/783] ext4: use memcpy_to_page() in pagecache_write()
Date:   Thu, 12 Jan 2023 14:57:06 +0100
Message-Id: <20230112135557.282638845@linuxfoundation.org>
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

From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>

[ Upstream commit bd256fda92efe97b692dc72e246d35fa724d42d8 ]

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Link: https://lore.kernel.org/r/20210207190425.38107-7-chaitanya.kulkarni@wdc.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 956510c0c743 ("fs: ext4: initialize fsdata in pagecache_write()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/verity.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/ext4/verity.c b/fs/ext4/verity.c
index 35be8e7ec2a0..130070ec491b 100644
--- a/fs/ext4/verity.c
+++ b/fs/ext4/verity.c
@@ -80,7 +80,6 @@ static int pagecache_write(struct inode *inode, const void *buf, size_t count,
 				 PAGE_SIZE - offset_in_page(pos));
 		struct page *page;
 		void *fsdata;
-		void *addr;
 		int res;
 
 		res = pagecache_write_begin(NULL, inode->i_mapping, pos, n, 0,
@@ -88,9 +87,7 @@ static int pagecache_write(struct inode *inode, const void *buf, size_t count,
 		if (res)
 			return res;
 
-		addr = kmap_atomic(page);
-		memcpy(addr + offset_in_page(pos), buf, n);
-		kunmap_atomic(addr);
+		memcpy_to_page(page, offset_in_page(pos), buf, n);
 
 		res = pagecache_write_end(NULL, inode->i_mapping, pos, n, n,
 					  page, fsdata);
-- 
2.35.1



