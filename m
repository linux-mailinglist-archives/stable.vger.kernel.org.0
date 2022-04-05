Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CBC04F3B2C
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:15:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238174AbiDELvM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356372AbiDEKXl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:23:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C262BB93A;
        Tue,  5 Apr 2022 03:08:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 017626179D;
        Tue,  5 Apr 2022 10:08:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F885C385A7;
        Tue,  5 Apr 2022 10:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153293;
        bh=ya1hx1/fE2HUdn3yYRyBbOZsn1H1ZTI+2o0qI65TxsE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xwGA8LUsf+m9um8N0BzHv9qnrrJKDZXGIj1m0cLrhbDv9lioZNb9CNqCdBYxQsz9l
         6ioBKLq4SvlVBcwodFGYDwroUSsfEs8z2X0AExHBteKgWxiVITy2iSQ5Gcx8lbYCw3
         DXxKYdKp2080impWxWgrmLVpErqOPy8P/R7PwR9w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhipeng Tan <tanzhipeng@hust.edu.cn>,
        Jicheng Shao <shaojicheng@hust.edu.cn>,
        Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 172/599] f2fs: fix to enable ATGC correctly via gc_idle sysfs interface
Date:   Tue,  5 Apr 2022 09:27:46 +0200
Message-Id: <20220405070303.960392461@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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
index 7ffd4bb398b0..a7e7d68256e0 100644
--- a/fs/f2fs/sysfs.c
+++ b/fs/f2fs/sysfs.c
@@ -386,7 +386,7 @@ static ssize_t __sbi_store(struct f2fs_attr *a,
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



