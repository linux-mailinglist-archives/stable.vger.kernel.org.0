Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2959B6B42AC
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:05:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231727AbjCJOFe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:05:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231740AbjCJOFS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:05:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C850011051C
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:05:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 402D9B822C3
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:05:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAA68C433EF;
        Fri, 10 Mar 2023 14:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457107;
        bh=1eNf2rnF2+IQaObR/7MOkLchWxP3alFNsUiR4jI+jVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yadmCi8HCTgFu3BTpXrocaVWjhfcLykujfkWIXB0iRHz0dADpIec1JWBgEFTzJhq6
         YAbWevNhX6oCzPrJXUlOnVDycuVkwW01g4tPth89cSUS6JGT6Hygz2Fb53mhw/hHh8
         HxKLASX1nvBvtQCLaAEXQJeqGGvCxkQcJPkwmXQI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chao Yu <chao@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 022/200] f2fs: fix to abort atomic write only during do_exist()
Date:   Fri, 10 Mar 2023 14:37:09 +0100
Message-Id: <20230310133717.726789366@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <chao@kernel.org>

[ Upstream commit ae267fc1cfe9f941afcb90dc963ee6448dae73cf ]

Commit 7a10f0177e11 ("f2fs: don't give partially written atomic data
from process crash") attempted to drop atomic write data after process
crash, however, f2fs_abort_atomic_write() may be called from noncrash
case, fix it by adding missed PF_EXITING check condition
f2fs_file_flush().

- application crashs
 - do_exit
  - exit_signals -- sets PF_EXITING
  - exit_files
   - put_files_struct
    - close_files
     - filp_close
      - flush (f2fs_file_flush)
       - check atomic_write_task && PF_EXITING
       - f2fs_abort_atomic_write

Fixes: 7a10f0177e11 ("f2fs: don't give partially written atomic data from process crash")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 88eecd7149cd5..8a576c004b72a 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1879,7 +1879,8 @@ static int f2fs_file_flush(struct file *file, fl_owner_t id)
 	 * until all the writers close its file. Since this should be done
 	 * before dropping file lock, it needs to do in ->flush.
 	 */
-	if (F2FS_I(inode)->atomic_write_task == current)
+	if (F2FS_I(inode)->atomic_write_task == current &&
+				(current->flags & PF_EXITING))
 		f2fs_abort_atomic_write(inode, true);
 	return 0;
 }
-- 
2.39.2



