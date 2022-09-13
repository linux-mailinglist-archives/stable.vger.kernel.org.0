Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9C1E5B706F
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233615AbiIMOZS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233788AbiIMOYQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:24:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3353C61B03;
        Tue, 13 Sep 2022 07:16:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B827614C2;
        Tue, 13 Sep 2022 14:14:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68752C433D6;
        Tue, 13 Sep 2022 14:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078486;
        bh=W5/c/rz4SkjlvfKZ6VsL2xJxhvqUehoX+DDkoVI5Q/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u8k342hmN/Alo0XCu57EuOEtCnwgPnBbKA3kjtgGh9wZCQXYDF8oMIHLsMhKkpwq8
         KZNWbw7JVOf7dls2GHAidyDuEjJju+RIvHCtQK85RlZ8/rK5pc/EWGnZ10QBFVolf2
         qDflXOthNEzPxcNLNzyPmVxZzMoFXuHHrA5fHMns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sun Ke <sunke32@huawei.com>,
        Jingbo Xu <jefflexu@linux.alibaba.com>,
        Gao Xiang <hsiangkao@linux.alibaba.com>,
        Chao Yu <chao@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 133/192] erofs: fix error return code in erofs_fscache_{meta_,}read_folio
Date:   Tue, 13 Sep 2022 16:03:59 +0200
Message-Id: <20220913140416.637808524@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sun Ke <sunke32@huawei.com>

[ Upstream commit 5bd9628b784cc5e38e1c7ebb680bbd6ee741230e ]

If erofs_fscache_alloc_request fail and then goto out, it will return 0.
it should return a negative error code instead of 0.

Fixes: d435d53228dd ("erofs: change to use asynchronous io for fscache readpage/readahead")
Signed-off-by: Sun Ke <sunke32@huawei.com>
Reviewed-by: Jingbo Xu <jefflexu@linux.alibaba.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Link: https://lore.kernel.org/r/20220815034829.3940803-1-sunke32@huawei.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/fscache.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/erofs/fscache.c b/fs/erofs/fscache.c
index 8e01d89c3319e..b5fd9d71e67f1 100644
--- a/fs/erofs/fscache.c
+++ b/fs/erofs/fscache.c
@@ -222,8 +222,10 @@ static int erofs_fscache_meta_read_folio(struct file *data, struct folio *folio)
 
 	rreq = erofs_fscache_alloc_request(folio_mapping(folio),
 				folio_pos(folio), folio_size(folio));
-	if (IS_ERR(rreq))
+	if (IS_ERR(rreq)) {
+		ret = PTR_ERR(rreq);
 		goto out;
+	}
 
 	return erofs_fscache_read_folios_async(mdev.m_fscache->cookie,
 				rreq, mdev.m_pa);
@@ -301,8 +303,10 @@ static int erofs_fscache_read_folio(struct file *file, struct folio *folio)
 
 	rreq = erofs_fscache_alloc_request(folio_mapping(folio),
 				folio_pos(folio), folio_size(folio));
-	if (IS_ERR(rreq))
+	if (IS_ERR(rreq)) {
+		ret = PTR_ERR(rreq);
 		goto out_unlock;
+	}
 
 	pstart = mdev.m_pa + (pos - map.m_la);
 	return erofs_fscache_read_folios_async(mdev.m_fscache->cookie,
-- 
2.35.1



