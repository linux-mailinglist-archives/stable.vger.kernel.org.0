Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD7B6AE8CF
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbjCGRS5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:18:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231128AbjCGRS1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:18:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBD8E7EA16
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:14:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66A02614E7
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:14:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E80BC433EF;
        Tue,  7 Mar 2023 17:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209247;
        bh=ZkNxk2A7W6zT9g8QRZolMj0vTxWc4QVw+JfRUV1wO7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NcQyyhuszj9Su0UrlsvnLzAFiIsd6rmt/u3e3gJ2FqgJIxLyFp3wlPK9mZ0vZ+Jhg
         9mNMSsPfJgMoFiKxVDBwRKCGBCJhJ0DG9ytqjbPyqXYa0IVat4KuUh5bnWSTyqFfrK
         6xLDqil8gaBW71Q6e4E3uPU16exnQQEBt7T/9FlA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jingbo Xu <jefflexu@linux.alibaba.com>,
        Jia Zhu <zhujia.zj@bytedance.com>,
        Gao Xiang <hsiangkao@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0127/1001] erofs: relinquish volume with mutex held
Date:   Tue,  7 Mar 2023 17:48:19 +0100
Message-Id: <20230307170027.577427980@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jingbo Xu <jefflexu@linux.alibaba.com>

[ Upstream commit 7032809a44d752b9e2275833787e0aa88a7540af ]

Relinquish fscache volume with mutex held.  Otherwise if a new domain is
registered when the old domain with the same name gets removed from the
list but not relinquished yet, fscache may complain the collision.

Fixes: 8b7adf1dff3d ("erofs: introduce fscache-based domain")
Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>
Reviewed-by: Jia Zhu <zhujia.zj@bytedance.com>
Link: https://lore.kernel.org/r/20230209063913.46341-4-jefflexu@linux.alibaba.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/fscache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/erofs/fscache.c b/fs/erofs/fscache.c
index 014e209623762..a7923d6661301 100644
--- a/fs/erofs/fscache.c
+++ b/fs/erofs/fscache.c
@@ -337,8 +337,8 @@ static void erofs_fscache_domain_put(struct erofs_domain *domain)
 			kern_unmount(erofs_pseudo_mnt);
 			erofs_pseudo_mnt = NULL;
 		}
-		mutex_unlock(&erofs_domain_list_lock);
 		fscache_relinquish_volume(domain->volume, NULL, false);
+		mutex_unlock(&erofs_domain_list_lock);
 		kfree(domain->domain_id);
 		kfree(domain);
 		return;
-- 
2.39.2



