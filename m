Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34E5E59466E
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243087AbiHOW5B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352242AbiHOWzV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:55:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6310413B88F;
        Mon, 15 Aug 2022 12:55:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA264612AC;
        Mon, 15 Aug 2022 19:55:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF6EFC433C1;
        Mon, 15 Aug 2022 19:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593307;
        bh=++/ccFWEPTN4VQVkgkKIVVVj1aYxf7ZJD9jzJQ3EwYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ov+PjKJlosBOqHgCYeaYP4BeE4m4HA2wXhT5f3GKunAYC/cTiM3lItUkU1NSpRD4P
         1L5cD5pGopOOLY4bE89C4xJDMMIzR8QA4iQ755YzpSv8wZpx0cm+UkJ541+C9Csb1f
         4nxllBDO4VpswNnQj+DneOyLLMWxwORcaCXQRG2k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <chao.yu@oppo.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0927/1095] f2fs: check pinfile in gc_data_segment() in advance
Date:   Mon, 15 Aug 2022 20:05:26 +0200
Message-Id: <20220815180507.603347042@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit a22bb5526d7dd627b94a7ee22e5a98c36e39fceb ]

In order to skip migrating section which contains data of pinned
file in advance.

Signed-off-by: Chao Yu <chao.yu@oppo.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/gc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index ea5b93b689cd..e83c07144d8f 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1480,6 +1480,13 @@ static int gc_data_segment(struct f2fs_sb_info *sbi, struct f2fs_summary *sum,
 					special_file(inode->i_mode))
 				continue;
 
+			if (is_inode_flag_set(inode, FI_PIN_FILE) &&
+							gc_type == FG_GC) {
+				f2fs_pin_file_control(inode, true);
+				iput(inode);
+				return submitted;
+			}
+
 			if (!f2fs_down_write_trylock(
 				&F2FS_I(inode)->i_gc_rwsem[WRITE])) {
 				iput(inode);
-- 
2.35.1



