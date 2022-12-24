Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB478655736
	for <lists+stable@lfdr.de>; Sat, 24 Dec 2022 02:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236607AbiLXBc5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Dec 2022 20:32:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233485AbiLXBcV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Dec 2022 20:32:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31EBBD101;
        Fri, 23 Dec 2022 17:30:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03ECDB821BE;
        Sat, 24 Dec 2022 01:30:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F028DC433EF;
        Sat, 24 Dec 2022 01:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671845432;
        bh=VY/PYsvOAgiJvESvvnWu6D66FvhPePyAUeKQYJWQohU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i44RL/Ew/LPm5dH7MOzD5y2zKGnlCKp5mvUZlLwz38Sn1CLwodbFbAZhH8UXIOr2w
         BH8qtDEp+1DDXoBVHZCdcWJ+LdAOV4Kok6J85DQ/OxevWbCM4OX/wgH2alWyjXit93
         bX3pmuTbZ6muaw1r1XJXNrYvgIdpO5RS4F3NXzU0bCY0ElJrx4x/2+AHLPvVssGGgK
         D+ha/BEg9pNy1qupp/D4JTaHVC02iWtYdIgxDb5ame9OXkOTJgsScxZQLfgUd5aX18
         uPEK9VZ62+SU+AIzqmPhYL5BgwsWE8HGux5bB21c+xCm3ebKCKCNqQT5TQOTjpSTpV
         dUvUoYVgN3Ihw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yuezhang Mo <Yuezhang.Mo@sony.com>,
        Sungjong Seo <sj1557.seo@samsung.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 25/26] exfat: fix overflow in sector and cluster conversion
Date:   Fri, 23 Dec 2022 20:29:29 -0500
Message-Id: <20221224012930.392358-25-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221224012930.392358-1-sashal@kernel.org>
References: <20221224012930.392358-1-sashal@kernel.org>
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
index a8f8eee4937c..7f6b1d5bceab 100644
--- a/fs/exfat/exfat_fs.h
+++ b/fs/exfat/exfat_fs.h
@@ -375,7 +375,7 @@ static inline sector_t exfat_cluster_to_sector(struct exfat_sb_info *sbi,
 		sbi->data_start_sector;
 }
 
-static inline int exfat_sector_to_cluster(struct exfat_sb_info *sbi,
+static inline unsigned int exfat_sector_to_cluster(struct exfat_sb_info *sbi,
 		sector_t sec)
 {
 	return ((sec - sbi->data_start_sector) >> sbi->sect_per_clus_bits) +
-- 
2.35.1

