Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F013664AC1
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239279AbjAJSgA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:36:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239444AbjAJSfP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:35:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AC7952C56
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:30:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C6E046183C
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:30:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D623AC433EF;
        Tue, 10 Jan 2023 18:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375446;
        bh=C4IC9BNKeQ7rzPpCqkogOm4nl55bFxI8LPb3jhoiabA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JWdLgq0fm6+jC6EyktM3HbnvRd0WAEf80d+Uvs5Q94zNgiZx5RC7zZ6usFofCKlcN
         0Xj+UhW7V69z5CxQI7pNRsqytzkCKNF356nsqp9E5sjyFgNZyXCj2y/eoq6pdCfMTh
         FR2Cso9xUBhcC4Z09md8owQ5/204TYSCBlaqF1Sw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Baokun Li <libaokun1@huawei.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
        stable@kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 191/290] ext4: correct inconsistent error msg in nojournal mode
Date:   Tue, 10 Jan 2023 19:04:43 +0100
Message-Id: <20230110180038.539937237@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
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

[ Upstream commit 89481b5fa8c0640e62ba84c6020cee895f7ac643 ]

When we used the journal_async_commit mounting option in nojournal mode,
the kernel told me that "can't mount with journal_checksum", was very
confusing. I find that when we mount with journal_async_commit, both the
JOURNAL_ASYNC_COMMIT and EXPLICIT_JOURNAL_CHECKSUM flags are set. However,
in the error branch, CHECKSUM is checked before ASYNC_COMMIT. As a result,
the above inconsistency occurs, and the ASYNC_COMMIT branch becomes dead
code that cannot be executed. Therefore, we exchange the positions of the
two judgments to make the error msg more accurate.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20221109074343.4184862-1-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/super.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index fd7565707975..1bb2e902667d 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4667,14 +4667,15 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		goto failed_mount3a;
 	} else {
 		/* Nojournal mode, all journal mount options are illegal */
-		if (test_opt2(sb, EXPLICIT_JOURNAL_CHECKSUM)) {
+		if (test_opt(sb, JOURNAL_ASYNC_COMMIT)) {
 			ext4_msg(sb, KERN_ERR, "can't mount with "
-				 "journal_checksum, fs mounted w/o journal");
+				 "journal_async_commit, fs mounted w/o journal");
 			goto failed_mount3a;
 		}
-		if (test_opt(sb, JOURNAL_ASYNC_COMMIT)) {
+
+		if (test_opt2(sb, EXPLICIT_JOURNAL_CHECKSUM)) {
 			ext4_msg(sb, KERN_ERR, "can't mount with "
-				 "journal_async_commit, fs mounted w/o journal");
+				 "journal_checksum, fs mounted w/o journal");
 			goto failed_mount3a;
 		}
 		if (sbi->s_commit_interval != JBD2_DEFAULT_MAX_COMMIT_AGE*HZ) {
-- 
2.35.1



