Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DCF56C1937
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:31:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232744AbjCTPbv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233051AbjCTPbd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:31:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5E20399F2
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:23:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F2854615A7
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:23:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1213AC433D2;
        Mon, 20 Mar 2023 15:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325830;
        bh=6BjCbJe3yeBFWIjm8HU9/LEHEJ3td8ALArsN78304o8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ObQGrpqsFdWrrFD8ruNeMyes/R+WARkT1gx0oRmKE+N39YJMFPAHebeZgqSJMbXO6
         iG4ZXv0mmoXWeBumjrZZALq4gvfi640oH3nIA8lnY/9yyyBgeM/8xn8GVunSx4FgDV
         sZtsapasYOOgyGM4EdP1i7FtZJ+WmgZcgwkncvgQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>,
        Baokun Li <libaokun1@huawei.com>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 108/211] ext4: update s_journal_inum if it changes after journal replay
Date:   Mon, 20 Mar 2023 15:54:03 +0100
Message-Id: <20230320145517.808934590@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit 3039d8b8692408438a618fac2776b629852663c3 ]

When mounting a crafted ext4 image, s_journal_inum may change after journal
replay, which is obviously unreasonable because we have successfully loaded
and replayed the journal through the old s_journal_inum. And the new
s_journal_inum bypasses some of the checks in ext4_get_journal(), which
may trigger a null pointer dereference problem. So if s_journal_inum
changes after the journal replay, we ignore the change, and rewrite the
current journal_inum to the superblock.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216541
Reported-by: Luís Henriques <lhenriques@suse.de>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20230107032126.4165860-3-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/super.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index c81fa0fa9901a..e79ca9ef98316 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5967,8 +5967,11 @@ static int ext4_load_journal(struct super_block *sb,
 	if (!really_read_only && journal_devnum &&
 	    journal_devnum != le32_to_cpu(es->s_journal_dev)) {
 		es->s_journal_dev = cpu_to_le32(journal_devnum);
-
-		/* Make sure we flush the recovery flag to disk. */
+		ext4_commit_super(sb);
+	}
+	if (!really_read_only && journal_inum &&
+	    journal_inum != le32_to_cpu(es->s_journal_inum)) {
+		es->s_journal_inum = cpu_to_le32(journal_inum);
 		ext4_commit_super(sb);
 	}
 
-- 
2.39.2



