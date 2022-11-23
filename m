Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A81EF6357F2
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:49:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238245AbiKWJtB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:49:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238244AbiKWJsm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:48:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F176573B93
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:45:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D532161A02
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:45:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C810AC433C1;
        Wed, 23 Nov 2022 09:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196750;
        bh=m7H/1F7srcbf/Xd5NOKYCw65oBVqXXthpE4VklhKM08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ni38keb83C/kHgI9V+XoeYVnznrgZ49CXWFFeouTb1xrThwCObpREkWMzQzMD75Jr
         S58cuHk0sdvcyNX66G6IsK50CHFI+YnY74sADUrAH1+hg5zJrwdUoXor/GPRmWxEmx
         zrd2jKxlP/Rd6j6xTjim6vlrAEJhclELMmef4wQE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jingbo Xu <jefflexu@linux.alibaba.com>,
        Gao Xiang <hsiangkao@linux.alibaba.com>,
        Chao Yu <chao@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 114/314] erofs: get correct count for unmapped range in fscache mode
Date:   Wed, 23 Nov 2022 09:49:19 +0100
Message-Id: <20221123084630.675780082@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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

From: Jingbo Xu <jefflexu@linux.alibaba.com>

[ Upstream commit e6d9f9ba111b56154f1b1120252aff269cebd49c ]

For unmapped range, the returned map.m_llen is zero, and thus the
calculated count is unexpected zero.

Prior to the refactoring introduced by commit 1ae9470c3e14 ("erofs:
clean up .read_folio() and .readahead() in fscache mode"), only the
readahead routine suffers from this. With the refactoring of making
.read_folio() and .readahead() calling one common routine, both
read_folio and readahead have this issue now.

Fix this by calculating count separately in unmapped condition.

Fixes: c665b394b9e8 ("erofs: implement fscache-based data readahead")
Fixes: 1ae9470c3e14 ("erofs: clean up .read_folio() and .readahead() in fscache mode")
Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Link: https://lore.kernel.org/r/20221104054028.52208-3-jefflexu@linux.alibaba.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/fscache.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/erofs/fscache.c b/fs/erofs/fscache.c
index 508b1a4df15e..8585e324298c 100644
--- a/fs/erofs/fscache.c
+++ b/fs/erofs/fscache.c
@@ -288,15 +288,16 @@ static int erofs_fscache_data_read(struct address_space *mapping,
 		return PAGE_SIZE;
 	}
 
-	count = min_t(size_t, map.m_llen - (pos - map.m_la), len);
-	DBG_BUGON(!count || count % PAGE_SIZE);
-
 	if (!(map.m_flags & EROFS_MAP_MAPPED)) {
+		count = len;
 		iov_iter_xarray(&iter, READ, &mapping->i_pages, pos, count);
 		iov_iter_zero(count, &iter);
 		return count;
 	}
 
+	count = min_t(size_t, map.m_llen - (pos - map.m_la), len);
+	DBG_BUGON(!count || count % PAGE_SIZE);
+
 	mdev = (struct erofs_map_dev) {
 		.m_deviceid = map.m_deviceid,
 		.m_pa = map.m_pa,
-- 
2.35.1



