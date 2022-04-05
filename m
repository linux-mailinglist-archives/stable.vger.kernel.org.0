Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3475B4F2722
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233117AbiDEIFN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:05:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233337AbiDEH5E (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:57:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A36184504C;
        Tue,  5 Apr 2022 00:50:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0BBECB81BAF;
        Tue,  5 Apr 2022 07:50:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CFFEC340EE;
        Tue,  5 Apr 2022 07:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145052;
        bh=S9cmyvSafNm0XeTi5sEgSrscdGdc2H02qmOF7tU8Kz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w1DTVntSHDMojccmFFdqNBm5oLaIiI/AzVIg2MAeuWPPjoRG7GdytWnmHD4HCFIb7
         pYx32UfdQNbKQMJphHXp8EHDqkLsWnjNUbjRQB3W3HK7hZT9/CwrVbZIEInRMkqIgi
         iVj0q/zd3KL52gYINaDINFVPI4I1gZ95LAIXDhYU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhipeng Tan <tanzhipeng@hust.edu.cn>,
        Jicheng Shao <shaojicheng@hust.edu.cn>,
        Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0268/1126] f2fs: fix to enable ATGC correctly via gc_idle sysfs interface
Date:   Tue,  5 Apr 2022 09:16:55 +0200
Message-Id: <20220405070415.477113051@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit 7d19e3dab0002e527052b0aaf986e8c32e5537bf ]

It needs to assign sbi->gc_mode with GC_IDLE_AT rather than GC_AT when
user tries to enable ATGC via gc_idle sysfs interface, fix it.

Fixes: 093749e296e2 ("f2fs: support age threshold based garbage collection")
Cc: Zhipeng Tan <tanzhipeng@hust.edu.cn>
Signed-off-by: Jicheng Shao <shaojicheng@hust.edu.cn>
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/sysfs.c b/fs/f2fs/sysfs.c
index 8ac506671245..bdb1b5c05be2 100644
--- a/fs/f2fs/sysfs.c
+++ b/fs/f2fs/sysfs.c
@@ -481,7 +481,7 @@ static ssize_t __sbi_store(struct f2fs_attr *a,
 		} else if (t == GC_IDLE_AT) {
 			if (!sbi->am.atgc_enabled)
 				return -EINVAL;
-			sbi->gc_mode = GC_AT;
+			sbi->gc_mode = GC_IDLE_AT;
 		} else {
 			sbi->gc_mode = GC_NORMAL;
 		}
-- 
2.34.1



