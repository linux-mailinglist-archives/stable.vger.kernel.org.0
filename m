Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7E86BB023
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:15:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbjCOMP5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231821AbjCOMPd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:15:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DBE687370
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:15:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE51C61D54
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:15:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D329CC433EF;
        Wed, 15 Mar 2023 12:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678882530;
        bh=74lLmyFO+apqg8p9pAMYXM6bur1XN6Zv4gATIq2JuYw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=twsgqfb/rMWjNR7ztyFKT2wrYaaDyqwm1NlQAoT8rWNV6bBYKj93MEBMhh7cVMrvO
         9ryVVlFY0fAad1JGODFRtj0FpJ5kh/1D+ajW8rrwfxg+EFTYNC7cL/ZFimCQ4MWjHy
         ZCfJmAHJ7YYbEzAoWJgUXQVZhb9kA8yjOkfCxyrw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+38695a20b8addcbc1084@syzkaller.appspotmail.com,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 13/39] udf: Detect system inodes linked into directory hierarchy
Date:   Wed, 15 Mar 2023 13:12:27 +0100
Message-Id: <20230315115721.739996578@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115721.234756306@linuxfoundation.org>
References: <20230315115721.234756306@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit 85a37983ec69cc9fcd188bc37c4de15ee326355a ]

When UDF filesystem is corrupted, hidden system inodes can be linked
into directory hierarchy which is an avenue for further serious
corruption of the filesystem and kernel confusion as noticed by syzbot
fuzzed images. Refuse to access system inodes linked into directory
hierarchy and vice versa.

CC: stable@vger.kernel.org
Reported-by: syzbot+38695a20b8addcbc1084@syzkaller.appspotmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/inode.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 7436337914b19..77421e65623a1 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1871,8 +1871,13 @@ struct inode *__udf_iget(struct super_block *sb, struct kernel_lb_addr *ino,
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
 
-	if (!(inode->i_state & I_NEW))
+	if (!(inode->i_state & I_NEW)) {
+		if (UDF_I(inode)->i_hidden != hidden_inode) {
+			iput(inode);
+			return ERR_PTR(-EFSCORRUPTED);
+		}
 		return inode;
+	}
 
 	memcpy(&UDF_I(inode)->i_location, ino, sizeof(struct kernel_lb_addr));
 	err = udf_read_inode(inode, hidden_inode);
-- 
2.39.2



