Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE3D16557B8
	for <lists+stable@lfdr.de>; Sat, 24 Dec 2022 02:39:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236983AbiLXBjW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Dec 2022 20:39:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236848AbiLXBij (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Dec 2022 20:38:39 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4659E537E7;
        Fri, 23 Dec 2022 17:32:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E523CCE1D02;
        Sat, 24 Dec 2022 01:32:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78193C433D2;
        Sat, 24 Dec 2022 01:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671845551;
        bh=CuK5PUG57Iq76Bn6VOr/oG2+8tyxt7rEJGgFkOme8dQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WMNR53kKQaY9DSgBYoIPpgr6hX/6h8Rjn9jT/voTkWLQjlSBA2U/y/wMYw62L6NzM
         pCXOSr9B8perqN0XO72MVvrZMRR0DkizaO8ZFJaoXrLPPlI66kBeR30GJoJO1Id2oa
         LWMEqOg8cjV+FTdPljL8UGf0fAPEkrwth2EwN4T3FUc9++QNvseA/kzkLzERk6WDMH
         ywXJ215ROWzEQV1vvLY8OHlhDFav0lY2ssLH7seMLWJq/jNknVAwf/ArLweJ9/tway
         t7ZCNcntEx8+BM+hl6cPNgTFdL473r4YohOS+UDwq8f6l6QGvOai6TB065NQetq/B0
         x2oEECkKAMsrA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yuezhang Mo <Yuezhang.Mo@sony.com>,
        Sungjong Seo <sj1557.seo@samsung.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 10/11] exfat: fix overflow in sector and cluster conversion
Date:   Fri, 23 Dec 2022 20:32:00 -0500
Message-Id: <20221224013202.393372-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221224013202.393372-1-sashal@kernel.org>
References: <20221224013202.393372-1-sashal@kernel.org>
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
index 0d139c7d150d..5c5ddd4e3a2f 100644
--- a/fs/exfat/exfat_fs.h
+++ b/fs/exfat/exfat_fs.h
@@ -373,7 +373,7 @@ static inline sector_t exfat_cluster_to_sector(struct exfat_sb_info *sbi,
 		sbi->data_start_sector;
 }
 
-static inline int exfat_sector_to_cluster(struct exfat_sb_info *sbi,
+static inline unsigned int exfat_sector_to_cluster(struct exfat_sb_info *sbi,
 		sector_t sec)
 {
 	return ((sec - sbi->data_start_sector) >> sbi->sect_per_clus_bits) +
-- 
2.35.1

