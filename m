Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54B016AEE0C
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:09:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232240AbjCGSJU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:09:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231201AbjCGSI6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:08:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A79D685353
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:03:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6CF1B818F6
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:03:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F4134C433D2;
        Tue,  7 Mar 2023 18:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212191;
        bh=s11hswL2oJ7Z+VbMcKZPSGudY23IvsWh97b9d22EjRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ChQVgS67ok+DeXdwZlc8gwd92GN7vNzPHCFEthCqsewuXi3MPy4E6uFCBQw74wsFI
         7gGW3J+jEGyczqLKy+rmq55siIujyYU0Ta4YRewdwzX+p5dPGcGBEjNAwY6h4/BU1t
         Z0y0k21atGU2QmiLk6jLvBXPFd7Eg6OTXMa6Ul2w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jingbo Xu <jefflexu@linux.alibaba.com>,
        Jia Zhu <zhujia.zj@bytedance.com>,
        Gao Xiang <hsiangkao@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 106/885] erofs: relinquish volume with mutex held
Date:   Tue,  7 Mar 2023 17:50:40 +0100
Message-Id: <20230307170006.489732629@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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
index b04f93bc062a8..076cf8a149ef3 100644
--- a/fs/erofs/fscache.c
+++ b/fs/erofs/fscache.c
@@ -398,8 +398,8 @@ static void erofs_fscache_domain_put(struct erofs_domain *domain)
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



