Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D27550F5C4
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344451AbiDZIsf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:48:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347180AbiDZIpz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:45:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B280B7CB3E;
        Tue, 26 Apr 2022 01:37:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CB1460908;
        Tue, 26 Apr 2022 08:37:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50BFAC385AC;
        Tue, 26 Apr 2022 08:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962255;
        bh=uaEadmqpPE1CfD4AexJXHcnVRP9yzpsnk7DXbyJr8mA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iFWOl0g6uPHX822R/sCWMX+3y0FGfTPhoIzyY78HBN5bszZTAVAwzWAQNgjseMrMH
         FSy2Dnhj9yBa8cAP5VoAF8/PQxtWuB/PdIzPz9NQBseNmz5glPD9LUEvKdev3J/NXz
         3N9NVWjgT7HVaGYYh0MI15Y0JAzNDZoZF8RDJxfQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        Christian Brauner <brauner@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 004/124] vfs: make sync_filesystem return errors from ->sync_fs
Date:   Tue, 26 Apr 2022 10:20:05 +0200
Message-Id: <20220426081747.417783842@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081747.286685339@linuxfoundation.org>
References: <20220426081747.286685339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit 5679897eb104cec9e99609c3f045a0c20603da4c ]

Strangely, sync_filesystem ignores the return code from the ->sync_fs
call, which means that syscalls like syncfs(2) never see the error.
This doesn't seem right, so fix that.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/sync.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/sync.c b/fs/sync.c
index 3ce8e2137f31..c7690016453e 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -29,7 +29,7 @@
  */
 int sync_filesystem(struct super_block *sb)
 {
-	int ret;
+	int ret = 0;
 
 	/*
 	 * We need to be protected against the filesystem going from
@@ -52,15 +52,21 @@ int sync_filesystem(struct super_block *sb)
 	 * at a time.
 	 */
 	writeback_inodes_sb(sb, WB_REASON_SYNC);
-	if (sb->s_op->sync_fs)
-		sb->s_op->sync_fs(sb, 0);
+	if (sb->s_op->sync_fs) {
+		ret = sb->s_op->sync_fs(sb, 0);
+		if (ret)
+			return ret;
+	}
 	ret = sync_blockdev_nowait(sb->s_bdev);
-	if (ret < 0)
+	if (ret)
 		return ret;
 
 	sync_inodes_sb(sb);
-	if (sb->s_op->sync_fs)
-		sb->s_op->sync_fs(sb, 1);
+	if (sb->s_op->sync_fs) {
+		ret = sb->s_op->sync_fs(sb, 1);
+		if (ret)
+			return ret;
+	}
 	return sync_blockdev(sb->s_bdev);
 }
 EXPORT_SYMBOL(sync_filesystem);
-- 
2.35.1



