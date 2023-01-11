Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC0AD66510D
	for <lists+stable@lfdr.de>; Wed, 11 Jan 2023 02:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232288AbjAKBVI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 20:21:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234163AbjAKBVH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 20:21:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CB705F9C;
        Tue, 10 Jan 2023 17:21:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95A8161999;
        Wed, 11 Jan 2023 01:21:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D89D3C433D2;
        Wed, 11 Jan 2023 01:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673400061;
        bh=L2t71BZAowgZYZQjAiJUgHg5t13KDoB6HhVsNJIeyNY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L7JoI+MkIawQAMHxRrqPYTlHdXS1ivbHKTc5leT23+JiDvlMHtU4+kbetF/XDoZ3z
         wHx5z2mXt4kHennZKTdPXPoxDtc2Uqe4JeAU8XLPa0CthVH+S5GpUCwdgEB9QoorPX
         gKJ3wmfaUNzFZSLa2WvsJHhrThj9XXONmQ/dl4aoP/ImabSfQZRRdMumsDnNq8oyR+
         beVufNdFQgK3Ga94ViB6iQl1o9szq3b4GlJGNclfXC/pQYLJeYmEXGT3MeTL/B8mDr
         A+Wlrlw3J6mRTvf+Bdpbii9rvDMaGl1DwkT4T2HYhEOpLyHiZv0AREGs7qOQ/pxu0I
         AGH9ODalRgAIQ==
Date:   Tue, 10 Jan 2023 17:20:59 -0800
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc:     stable@vger.kernel.org, Randall Huang <huangrandall@google.com>
Subject: Re: [PATCH v2] f2fs: retry to update the inode page given EIO
Message-ID: <Y74O+5SklijYqMU1@google.com>
References: <20230105233908.1030651-1-jaegeuk@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105233908.1030651-1-jaegeuk@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In f2fs_update_inode_page, f2fs_get_node_page handles EIO along with
f2fs_handle_page_eio that stops checkpoint, if the disk couldn't be recovered.
As a result, we don't need to stop checkpoint right away given single EIO.

Cc: stable@vger.kernel.org
Signed-off-by: Randall Huang <huangrandall@google.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---

 Change log from v1:
  - fix a bug

 fs/f2fs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index ff6cf66ed46b..2ed7a621fdf1 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -719,7 +719,7 @@ void f2fs_update_inode_page(struct inode *inode)
 	if (IS_ERR(node_page)) {
 		int err = PTR_ERR(node_page);
 
-		if (err == -ENOMEM) {
+		if (err == -ENOMEM || (err == -EIO && !f2fs_cp_error(sbi))) {
 			cond_resched();
 			goto retry;
 		} else if (err != -ENOENT) {
-- 
2.39.0.314.g84b9a713c41-goog

