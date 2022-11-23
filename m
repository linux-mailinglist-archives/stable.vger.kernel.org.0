Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C84463581A
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238200AbiKWJum (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:50:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238203AbiKWJt4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:49:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7254311605C
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:47:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 281C3B81E5E
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:47:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 725B1C433C1;
        Wed, 23 Nov 2022 09:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196828;
        bh=pvm/wxrC9xlwI5h6SNgivKLBHRhQapDihpLNb8afBHo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L2AKJiBrhJrvQ6i0JH5bTWj73NphgnvD7fby8CELZI9hYFhUGSvnFY+EKnPRTqmJs
         yc0Jk06AhGdzGQJ5VWvbFRWiQvFaoj7RB2H4hRY8GieeIkTm0OZuvhUbSIhaCGdXAO
         FJEOqzdInonRWv5T+fmOmQGVfcOMH7D9Bj39q+I8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jingbo Xu <jefflexu@linux.alibaba.com>,
        Gao Xiang <hsiangkao@linux.alibaba.com>,
        Jia Zhu <zhujia.zj@bytedance.com>, Chao Yu <chao@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 134/314] erofs: put metabuf in error path in fscache mode
Date:   Wed, 23 Nov 2022 09:49:39 +0100
Message-Id: <20221123084631.602838712@linuxfoundation.org>
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

[ Upstream commit 75e43355cbe4d5948a79bd592f2ffecb9f75f75d ]

For tail packing layout, put metabuf when error is encountered.

Fixes: 1ae9470c3e14 ("erofs: clean up .read_folio() and .readahead() in fscache mode")
Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Jia Zhu <zhujia.zj@bytedance.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Link: https://lore.kernel.org/r/20221104054028.52208-2-jefflexu@linux.alibaba.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/fscache.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/erofs/fscache.c b/fs/erofs/fscache.c
index 8585e324298c..79af25f0a56c 100644
--- a/fs/erofs/fscache.c
+++ b/fs/erofs/fscache.c
@@ -281,8 +281,10 @@ static int erofs_fscache_data_read(struct address_space *mapping,
 			return PTR_ERR(src);
 
 		iov_iter_xarray(&iter, READ, &mapping->i_pages, pos, PAGE_SIZE);
-		if (copy_to_iter(src + offset, size, &iter) != size)
+		if (copy_to_iter(src + offset, size, &iter) != size) {
+			erofs_put_metabuf(&buf);
 			return -EFAULT;
+		}
 		iov_iter_zero(PAGE_SIZE - size, &iter);
 		erofs_put_metabuf(&buf);
 		return PAGE_SIZE;
-- 
2.35.1



