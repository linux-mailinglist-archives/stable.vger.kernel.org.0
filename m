Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0B8E5AECA2
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240964AbiIFOD3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:03:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241048AbiIFOCQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:02:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7AAE1123;
        Tue,  6 Sep 2022 06:44:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 884AD6154D;
        Tue,  6 Sep 2022 13:43:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96E71C433D6;
        Tue,  6 Sep 2022 13:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471801;
        bh=4dlgeQLWQkdbkwYAH0LptfHKzlPXCb/0oVluVpxLKIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1dflrealMMM6G7OpvfdBXM8acEaMCJoA2/IridBsYuTCQKmLpcKI1MiY1XnspZB7u
         B5BvSZ/MrmRPJX2B/6CIDhodPUHhsKKE+PP3CQM4C+j+eUDaH0o30n5clpzxhWOAV1
         M6T4ao0vlxbA58Ddzazqxluwh0e6bYFITQd7y24s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sun Ke <sunke32@huawei.com>,
        Jeffle Xu <jefflexu@linux.alibaba.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        David Howells <dhowells@redhat.com>,
        Gao Xiang <hsiangkao@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 044/155] cachefiles: fix error return code in cachefiles_ondemand_copen()
Date:   Tue,  6 Sep 2022 15:29:52 +0200
Message-Id: <20220906132831.277055643@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
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

[ Upstream commit c93ccd63b18c8d108c57b2bb0e5f3b058b9d2029 ]

The cache_size field of copen is specified by the user daemon.
If cache_size < 0, then the OPEN request is expected to fail,
while copen itself shall succeed. However, returning 0 is indeed
unexpected when cache_size is an invalid error code.

Fix this by returning error when cache_size is an invalid error code.

Changes
=======
v4: update the code suggested by Dan
v3: update the commit log suggested by Jingbo.

Fixes: c8383054506c ("cachefiles: notify the user daemon when looking up cookie")
Signed-off-by: Sun Ke <sunke32@huawei.com>
Suggested-by: Jeffle Xu <jefflexu@linux.alibaba.com>
Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Jingbo Xu <jefflexu@linux.alibaba.com>
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20220818111935.1683062-1-sunke32@huawei.com/ # v2
Link: https://lore.kernel.org/r/20220818125038.2247720-1-sunke32@huawei.com/ # v3
Link: https://lore.kernel.org/r/20220826023515.3437469-1-sunke32@huawei.com/ # v4
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cachefiles/ondemand.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/cachefiles/ondemand.c b/fs/cachefiles/ondemand.c
index 1fee702d55293..7e1586bd5cf34 100644
--- a/fs/cachefiles/ondemand.c
+++ b/fs/cachefiles/ondemand.c
@@ -158,9 +158,13 @@ int cachefiles_ondemand_copen(struct cachefiles_cache *cache, char *args)
 
 	/* fail OPEN request if daemon reports an error */
 	if (size < 0) {
-		if (!IS_ERR_VALUE(size))
-			size = -EINVAL;
-		req->error = size;
+		if (!IS_ERR_VALUE(size)) {
+			req->error = -EINVAL;
+			ret = -EINVAL;
+		} else {
+			req->error = size;
+			ret = 0;
+		}
 		goto out;
 	}
 
-- 
2.35.1



