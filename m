Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0607666326
	for <lists+stable@lfdr.de>; Wed, 11 Jan 2023 19:55:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239278AbjAKSzb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 13:55:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239504AbjAKSzA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 13:55:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A92F33D9E9;
        Wed, 11 Jan 2023 10:54:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 456EE61DC0;
        Wed, 11 Jan 2023 18:54:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B2DAC433EF;
        Wed, 11 Jan 2023 18:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673463274;
        bh=jJXh1vAxyah+RSk36H0uasBBaBLj/+dpkHSkaO37ss0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CPUcBM+H6w5MPJ26lYG9gBLwDkP3/yBstxi6nW084sNA9M+uObOkEMSMq052ksKhW
         +RntYatoGOjtYGlr6/VZV2wBdN+mQ0ly8Mu25vjDQZ5CnWm4V+sPqnvGz9ahZeFabe
         n2s+1r5QLD64zsHld0AK8safrubs2YoS5jicfPq+Q7jvo5lR/Wmcu9YaFi0eIFvqsj
         c7xSjyXVGKO/uLVLTuidVuqRe3q46F1ZG+EldZbdT0LP+m7coVckT4E/SFXg9aXwXi
         T4EcJDonD5kIUR46WQGygIAMuXWVUa7shrKe9Bp0lNQD8s2bEqdhUNhZGmRa0BAhVD
         Jvu5ZTsv/yFOg==
Date:   Wed, 11 Jan 2023 10:54:32 -0800
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc:     stable@vger.kernel.org
Subject: Re: [f2fs-dev] [PATCH v3] f2fs: retry to update the inode page given
 EIO
Message-ID: <Y78F6KrTNFi0xBa/@google.com>
References: <20230105233908.1030651-1-jaegeuk@kernel.org>
 <Y74O+5SklijYqMU1@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y74O+5SklijYqMU1@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

 Change log from v2:
  - set EIO to cover the case of data corruption given by buggy UFS driver

 fs/f2fs/inode.c | 2 +-
 fs/f2fs/node.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

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
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 558b318f7316..1629dc300c61 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1455,7 +1455,7 @@ static struct page *__get_node_page(struct f2fs_sb_info *sbi, pgoff_t nid,
 			  ofs_of_node(page), cpver_of_node(page),
 			  next_blkaddr_of_node(page));
 	set_sbi_flag(sbi, SBI_NEED_FSCK);
-	err = -EINVAL;
+	err = -EIO;
 out_err:
 	ClearPageUptodate(page);
 out_put_err:
-- 
2.39.0.314.g84b9a713c41-goog

