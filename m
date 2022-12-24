Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A87EB65578D
	for <lists+stable@lfdr.de>; Sat, 24 Dec 2022 02:36:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236415AbiLXBgh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Dec 2022 20:36:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232949AbiLXBgF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Dec 2022 20:36:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAF644DE44;
        Fri, 23 Dec 2022 17:32:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57AE661FB7;
        Sat, 24 Dec 2022 01:32:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13114C433F0;
        Sat, 24 Dec 2022 01:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671845519;
        bh=bgawXfLoeJO3ffDh6CMrYlTuH2ns7yeTuONe6HVU0t8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FPmxXnV8opVsMQw3K0w6CHLesgzzPQthfL72nzSFB7MBSombhThju9BmvYzJ0wnSL
         /RPE3i5uaSU5mTIL2Q3LmTokUxQGOg7N0Ng3K4tTdKaqQIJvwclv8clz8CTvkKzRex
         awUNOO9KHaIOyxlaUwQhCgaiaAjnNsDrsD+LmlZPNd3TKVAmWIC+1xgpu+7Y1QhNRc
         MnV0AAlOF2tXvpSDg88PrFSxYhSSLjMPDhxRc6zKkWopyoX+MGBVDv5RZhOuQYDaMK
         a/oPfI4gb3mvSsYRUNdddia25w8+q/GFYxXfxEIczjp/Jg9xuPHDEnlwqzJFcYbwWV
         mgj7mXtN+B3Hg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yuezhang Mo <Yuezhang.Mo@sony.com>,
        Sungjong Seo <sj1557.seo@samsung.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 13/14] exfat: fix overflow in sector and cluster conversion
Date:   Fri, 23 Dec 2022 20:31:26 -0500
Message-Id: <20221224013127.393187-13-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221224013127.393187-1-sashal@kernel.org>
References: <20221224013127.393187-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuezhang Mo <Yuezhang.Mo@sony.com>

[ Upstream commit 40306b4d1ba25970dafd53432e8daa5d591ebd99 ]

According to the exFAT specification, there are at most 2^32-11
clusters in a volume. so using 'int' is not enough for cluster
index, the return value type of exfat_sector_to_cluster() should
be 'unsigned int'.

Signed-off-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/exfat_fs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/exfat/exfat_fs.h b/fs/exfat/exfat_fs.h
index 9f82a8a835ee..d99df8d83d38 100644
--- a/fs/exfat/exfat_fs.h
+++ b/fs/exfat/exfat_fs.h
@@ -374,7 +374,7 @@ static inline sector_t exfat_cluster_to_sector(struct exfat_sb_info *sbi,
 		sbi->data_start_sector;
 }
 
-static inline int exfat_sector_to_cluster(struct exfat_sb_info *sbi,
+static inline unsigned int exfat_sector_to_cluster(struct exfat_sb_info *sbi,
 		sector_t sec)
 {
 	return ((sec - sbi->data_start_sector) >> sbi->sect_per_clus_bits) +
-- 
2.35.1

