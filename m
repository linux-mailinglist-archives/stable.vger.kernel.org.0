Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FEEF540A5F
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351625AbiFGSUP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352644AbiFGSRY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:17:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9214E13C088;
        Tue,  7 Jun 2022 10:52:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C228617AA;
        Tue,  7 Jun 2022 17:52:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 149E1C385A5;
        Tue,  7 Jun 2022 17:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624351;
        bh=h9I8z9yfCsj9WKik3+U8sz5LvflAmBBSL/fxUrdruoU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YjiKO2q2e2G+ErzK/uIwUNkOjTaL/bWPJ9CY0J7fiZ1UN+3xlll1ip0Owdy075rCx
         ZXpZth8k+AQEWLrrUbCo6uxMxtt2Zu/S6uITqwmYumZSKkSOH3TugdGXjjQplX1ab0
         ULyM+b1KFIjJykAqAA9E38KCXk5wT5IbX5N7ScUFBmAHXIo+Hr6ghEHyicTJ8gxL2r
         ZHEf94FIMxHy66dEYXUnTpJEA5iXSeZg6AzQEoodJypCsrJRUH32tSFA1GTwB0Rc+r
         Mlt0h5/euyEYBJW726xj6fB4Np9B/bGFP+op5T6Z+BPVlQoueUOQp1MU4wnbKjY/CD
         4JSE8lp+60GUw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Gerald Lee <sundaywind2004@gmail.com>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        Sasha Levin <sashal@kernel.org>, ntfs3@lists.linux.dev
Subject: [PATCH AUTOSEL 5.18 59/68] fs/ntfs3: Fix invalid free in log_replay
Date:   Tue,  7 Jun 2022 13:48:25 -0400
Message-Id: <20220607174846.477972-59-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607174846.477972-1-sashal@kernel.org>
References: <20220607174846.477972-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit f26967b9f7a830e228bb13fb41bd516ddd9d789d ]

log_read_rst() returns ENOMEM error when there is not enough memory.
In this case, if info is returned without initialization,
it attempts to kfree the uninitialized info->r_page pointer. This patch
moves the memset initialization code to before log_read_rst() is called.

Reported-by: Gerald Lee <sundaywind2004@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/fslog.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ntfs3/fslog.c b/fs/ntfs3/fslog.c
index 06492f088d60..fc36c53b865a 100644
--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -1185,8 +1185,6 @@ static int log_read_rst(struct ntfs_log *log, u32 l_size, bool first,
 	if (!r_page)
 		return -ENOMEM;
 
-	memset(info, 0, sizeof(struct restart_info));
-
 	/* Determine which restart area we are looking for. */
 	if (first) {
 		vbo = 0;
@@ -3791,10 +3789,11 @@ int log_replay(struct ntfs_inode *ni, bool *initialized)
 	if (!log)
 		return -ENOMEM;
 
+	memset(&rst_info, 0, sizeof(struct restart_info));
+
 	log->ni = ni;
 	log->l_size = l_size;
 	log->one_page_buf = kmalloc(page_size, GFP_NOFS);
-
 	if (!log->one_page_buf) {
 		err = -ENOMEM;
 		goto out;
@@ -3842,6 +3841,7 @@ int log_replay(struct ntfs_inode *ni, bool *initialized)
 	if (rst_info.vbo)
 		goto check_restart_area;
 
+	memset(&rst_info2, 0, sizeof(struct restart_info));
 	err = log_read_rst(log, l_size, false, &rst_info2);
 
 	/* Determine which restart area to use. */
-- 
2.35.1

